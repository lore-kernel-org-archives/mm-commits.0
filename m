From: akpm@linux-foundation.org
Subject: [patch 107/114] dax: add tracepoints to
 dax_iomap_pte_fault()
Date: Mon, 08 May 2017 16:00:00 -0700
Message-ID: <20170508230000.izDHqAqgx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47680 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751087AbdEHXAB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 19:00:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, jack@suse.cz, mawilcox@microsoft.com, mingo@redhat.com, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, rostedt@goodmis.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: add tracepoints to dax_iomap_pte_fault()

Patch series "second round of tracepoints for DAX".

This second round of DAX tracepoint patches adds tracing to the PTE fault
path (dax_iomap_pte_fault(), dax_pfn_mkwrite(), dax_load_hole(),
dax_insert_mapping()) and to the writeback path
(dax_writeback_mapping_range(), dax_writeback_one()).

The purpose of this tracing is to give us a high level view of what DAX is
doing, whether faults are being serviced by PMDs or PTEs, and by real
storage or by zero pages covering holes.

I do have some patches nearly ready which also add tracing to
grab_mapping_entry() and dax_insert_mapping_entry().  These are more
targeted at logging how we are interacting with the radix tree, how we use
empty entries for locking, whether we "downgrade" huge zero pages to 4k
PTE sized allocations, etc.  In the end it seemed to me that this might be
too detailed to have as constantly present tracepoints, but if anyone sees
value in having tracepoints like this in the DAX code permanently (Jan?),
please let me know and I'll add those last two patches.

All these tracepoints were done to be consistent with the style of the XFS
tracepoints and with the existing DAX PMD tracepoints.


This patch (of 6):

Add tracepoints to dax_iomap_pte_fault(), following the same logging
conventions as the rest of DAX.

Here is an example fault that initially tries to be serviced by the PMD
fault handler but which falls back to PTEs because the VMA isn't large
enough to hold a PMD:

small-1086  [005] ....    71.140014: xfs_filemap_huge_fault: dev 259:0 ino
0x1003

small-1086  [005] ....    71.140027: dax_pmd_fault: dev 259:0 ino 0x1003
shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10420000 vm_start
0x10200000 vm_end 0x10500000 pgoff 0x220 max_pgoff 0x1400

small-1086  [005] ....    71.140028: dax_pmd_fault_done: dev 259:0 ino
0x1003 shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10420000 vm_start
0x10200000 vm_end 0x10500000 pgoff 0x220 max_pgoff 0x1400 FALLBACK

small-1086  [005] ....    71.140035: dax_pte_fault: dev 259:0 ino 0x1003
shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10420000 pgoff 0x220

small-1086  [005] ....    71.140396: dax_pte_fault_done: dev 259:0 ino
0x1003 shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10420000 pgoff
0x220 MAJOR|NOPAGE

Link: http://lkml.kernel.org/r/20170221195116.13278-2-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                      |   15 ++++++++---
 include/trace/events/fs_dax.h |   41 ++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 4 deletions(-)

diff -puN fs/dax.c~dax-add-tracepoints-to-dax_iomap_pte_fault fs/dax.c
--- a/fs/dax.c~dax-add-tracepoints-to-dax_iomap_pte_fault
+++ a/fs/dax.c
@@ -1150,13 +1150,16 @@ static int dax_iomap_pte_fault(struct vm
 	int vmf_ret = 0;
 	void *entry;
 
+	trace_dax_pte_fault(inode, vmf, vmf_ret);
 	/*
 	 * Check whether offset isn't beyond end of file now. Caller is supposed
 	 * to hold locks serializing us with truncate / punch hole so this is
 	 * a reliable test.
 	 */
-	if (pos >= i_size_read(inode))
-		return VM_FAULT_SIGBUS;
+	if (pos >= i_size_read(inode)) {
+		vmf_ret = VM_FAULT_SIGBUS;
+		goto out;
+	}
 
 	if ((vmf->flags & FAULT_FLAG_WRITE) && !vmf->cow_page)
 		flags |= IOMAP_WRITE;
@@ -1167,8 +1170,10 @@ static int dax_iomap_pte_fault(struct vm
 	 * that we never have to deal with more than a single extent here.
 	 */
 	error = ops->iomap_begin(inode, pos, PAGE_SIZE, flags, &iomap);
-	if (error)
-		return dax_fault_return(error);
+	if (error) {
+		vmf_ret = dax_fault_return(error);
+		goto out;
+	}
 	if (WARN_ON_ONCE(iomap.offset + iomap.length < pos + PAGE_SIZE)) {
 		vmf_ret = dax_fault_return(-EIO);	/* fs corruption? */
 		goto finish_iomap;
@@ -1252,6 +1257,8 @@ static int dax_iomap_pte_fault(struct vm
 		 */
 		ops->iomap_end(inode, pos, PAGE_SIZE, copied, flags, &iomap);
 	}
+out:
+	trace_dax_pte_fault_done(inode, vmf, vmf_ret);
 	return vmf_ret;
 }
 
diff -puN include/trace/events/fs_dax.h~dax-add-tracepoints-to-dax_iomap_pte_fault include/trace/events/fs_dax.h
--- a/include/trace/events/fs_dax.h~dax-add-tracepoints-to-dax_iomap_pte_fault
+++ a/include/trace/events/fs_dax.h
@@ -150,6 +150,47 @@ DEFINE_EVENT(dax_pmd_insert_mapping_clas
 DEFINE_PMD_INSERT_MAPPING_EVENT(dax_pmd_insert_mapping);
 DEFINE_PMD_INSERT_MAPPING_EVENT(dax_pmd_insert_mapping_fallback);
 
+DECLARE_EVENT_CLASS(dax_pte_fault_class,
+	TP_PROTO(struct inode *inode, struct vm_fault *vmf, int result),
+	TP_ARGS(inode, vmf, result),
+	TP_STRUCT__entry(
+		__field(unsigned long, ino)
+		__field(unsigned long, vm_flags)
+		__field(unsigned long, address)
+		__field(pgoff_t, pgoff)
+		__field(dev_t, dev)
+		__field(unsigned int, flags)
+		__field(int, result)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->vm_flags = vmf->vma->vm_flags;
+		__entry->address = vmf->address;
+		__entry->flags = vmf->flags;
+		__entry->pgoff = vmf->pgoff;
+		__entry->result = result;
+	),
+	TP_printk("dev %d:%d ino %#lx %s %s address %#lx pgoff %#lx %s",
+		MAJOR(__entry->dev),
+		MINOR(__entry->dev),
+		__entry->ino,
+		__entry->vm_flags & VM_SHARED ? "shared" : "private",
+		__print_flags(__entry->flags, "|", FAULT_FLAG_TRACE),
+		__entry->address,
+		__entry->pgoff,
+		__print_flags(__entry->result, "|", VM_FAULT_RESULT_TRACE)
+	)
+)
+
+#define DEFINE_PTE_FAULT_EVENT(name) \
+DEFINE_EVENT(dax_pte_fault_class, name, \
+	TP_PROTO(struct inode *inode, struct vm_fault *vmf, int result), \
+	TP_ARGS(inode, vmf, result))
+
+DEFINE_PTE_FAULT_EVENT(dax_pte_fault);
+DEFINE_PTE_FAULT_EVENT(dax_pte_fault_done);
+
 #endif /* _TRACE_FS_DAX_H */
 
 /* This part must be outside protection */
_
