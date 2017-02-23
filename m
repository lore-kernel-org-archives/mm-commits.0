From: akpm@linux-foundation.org
Subject: [merged] dax-add-tracepoints-to-dax_pmd_load_hole.patch removed
 from -mm tree
Date: Thu, 23 Feb 2017 13:11:18 -0800
Message-ID: <58af4ff6.CbpyWQZHkxxf5rz1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38246 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751170AbdBWVLT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:11:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dave.jiang@intel.com, david@fromorbit.com, jack@suse.cz, mawilcox@microsoft.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: add tracepoints to dax_pmd_load_hole()
has been removed from the -mm tree.  Its filename was
     dax-add-tracepoints-to-dax_pmd_load_hole.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: add tracepoints to dax_pmd_load_hole()

Add tracepoints to dax_pmd_load_hole(), following the same logging
conventions as the tracepoints in dax_iomap_pmd_fault().

Here is an example PMD fault showing the new tracepoints:

read_big-1478  [004] ....   238.242188: xfs_filemap_pmd_fault: dev 259:0
ino 0x1003

read_big-1478  [004] ....   238.242191: dax_pmd_fault: dev 259:0 ino 0x1003
shared ALLOW_RETRY|KILLABLE|USER address 0x10400000 vm_start 0x10200000
vm_end 0x10600000 pgoff 0x200 max_pgoff 0x1400

read_big-1478  [004] ....   238.242390: dax_pmd_load_hole: dev 259:0 ino
0x1003 shared address 0x10400000 zero_page ffffea0002c20000 radix_entry
0x1e

read_big-1478  [004] ....   238.242392: dax_pmd_fault_done: dev 259:0 ino
0x1003 shared ALLOW_RETRY|KILLABLE|USER address 0x10400000 vm_start
0x10200000 vm_end 0x10600000 pgoff 0x200 max_pgoff 0x1400 NOPAGE

Link: http://lkml.kernel.org/r/1484085142-2297-5-git-send-email-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                      |   14 +++++++---
 include/trace/events/fs_dax.h |   42 ++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 4 deletions(-)

diff -puN fs/dax.c~dax-add-tracepoints-to-dax_pmd_load_hole fs/dax.c
--- a/fs/dax.c~dax-add-tracepoints-to-dax_pmd_load_hole
+++ a/fs/dax.c
@@ -1299,33 +1299,39 @@ static int dax_pmd_load_hole(struct vm_a
 {
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	unsigned long pmd_addr = address & PMD_MASK;
+	struct inode *inode = mapping->host;
 	struct page *zero_page;
+	void *ret = NULL;
 	spinlock_t *ptl;
 	pmd_t pmd_entry;
-	void *ret;
 
 	zero_page = mm_get_huge_zero_page(vma->vm_mm);
 
 	if (unlikely(!zero_page))
-		return VM_FAULT_FALLBACK;
+		goto fallback;
 
 	ret = dax_insert_mapping_entry(mapping, vmf, *entryp, 0,
 			RADIX_DAX_PMD | RADIX_DAX_HZP);
 	if (IS_ERR(ret))
-		return VM_FAULT_FALLBACK;
+		goto fallback;
 	*entryp = ret;
 
 	ptl = pmd_lock(vma->vm_mm, pmd);
 	if (!pmd_none(*pmd)) {
 		spin_unlock(ptl);
-		return VM_FAULT_FALLBACK;
+		goto fallback;
 	}
 
 	pmd_entry = mk_pmd(zero_page, vma->vm_page_prot);
 	pmd_entry = pmd_mkhuge(pmd_entry);
 	set_pmd_at(vma->vm_mm, pmd_addr, pmd, pmd_entry);
 	spin_unlock(ptl);
+	trace_dax_pmd_load_hole(inode, vma, address, zero_page, ret);
 	return VM_FAULT_NOPAGE;
+
+fallback:
+	trace_dax_pmd_load_hole_fallback(inode, vma, address, zero_page, ret);
+	return VM_FAULT_FALLBACK;
 }
 
 int dax_iomap_pmd_fault(struct vm_area_struct *vma, unsigned long address,
diff -puN include/trace/events/fs_dax.h~dax-add-tracepoints-to-dax_pmd_load_hole include/trace/events/fs_dax.h
--- a/include/trace/events/fs_dax.h~dax-add-tracepoints-to-dax_pmd_load_hole
+++ a/include/trace/events/fs_dax.h
@@ -61,6 +61,48 @@ DEFINE_EVENT(dax_pmd_fault_class, name,
 DEFINE_PMD_FAULT_EVENT(dax_pmd_fault);
 DEFINE_PMD_FAULT_EVENT(dax_pmd_fault_done);
 
+DECLARE_EVENT_CLASS(dax_pmd_load_hole_class,
+	TP_PROTO(struct inode *inode, struct vm_area_struct *vma,
+		unsigned long address, struct page *zero_page,
+		void *radix_entry),
+	TP_ARGS(inode, vma, address, zero_page, radix_entry),
+	TP_STRUCT__entry(
+		__field(unsigned long, ino)
+		__field(unsigned long, vm_flags)
+		__field(unsigned long, address)
+		__field(struct page *, zero_page)
+		__field(void *, radix_entry)
+		__field(dev_t, dev)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->vm_flags = vma->vm_flags;
+		__entry->address = address;
+		__entry->zero_page = zero_page;
+		__entry->radix_entry = radix_entry;
+	),
+	TP_printk("dev %d:%d ino %#lx %s address %#lx zero_page %p "
+			"radix_entry %#lx",
+		MAJOR(__entry->dev),
+		MINOR(__entry->dev),
+		__entry->ino,
+		__entry->vm_flags & VM_SHARED ? "shared" : "private",
+		__entry->address,
+		__entry->zero_page,
+		(unsigned long)__entry->radix_entry
+	)
+)
+
+#define DEFINE_PMD_LOAD_HOLE_EVENT(name) \
+DEFINE_EVENT(dax_pmd_load_hole_class, name, \
+	TP_PROTO(struct inode *inode, struct vm_area_struct *vma, \
+		unsigned long address, struct page *zero_page, \
+		void *radix_entry), \
+	TP_ARGS(inode, vma, address, zero_page, radix_entry))
+
+DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole);
+DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole_fallback);
 
 #endif /* _TRACE_FS_DAX_H */
 
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

mmfsdax-change-pmd_fault-to-huge_fault-fix-2.patch
drm-remove-unnecessary-fault-wrappers.patch

