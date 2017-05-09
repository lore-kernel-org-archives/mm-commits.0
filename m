From: akpm@linux-foundation.org
Subject: [merged] dax-add-tracepoints-to-dax_pfn_mkwrite.patch
 removed from -mm tree
Date: Tue, 09 May 2017 11:04:40 -0700
Message-ID: <20170509180440.QGMgSZP5u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36214 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753963AbdEISEw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:04:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, jack@suse.cz, mawilcox@microsoft.com, mingo@redhat.com, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, rostedt@goodmis.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: dax: add tracepoints to dax_pfn_mkwrite()
has been removed from the -mm tree.  Its filename was
     dax-add-tracepoints-to-dax_pfn_mkwrite.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: add tracepoints to dax_pfn_mkwrite()

Add tracepoints to dax_pfn_mkwrite(), following the same logging
conventions as the rest of DAX.

Here is an example PTE fault followed by a pfn_mkwrite:

small_aligned-1094  [002] ....   374.084998: dax_pte_fault: dev 259:0 ino
0x1003 shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10400000 pgoff
0x200

small_aligned-1094  [002] ....   374.085145: dax_pte_fault_done: dev 259:0
ino 0x1003 shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10400000 pgoff
0x200 MAJOR|NOPAGE

small_aligned-1094  [002] ....   374.085165: dax_pfn_mkwrite: dev 259:0 ino
0x1003 shared WRITE|MKWRITE|ALLOW_RETRY|KILLABLE|USER address 0x10400000
pgoff 0x200 NOPAGE

Link: http://lkml.kernel.org/r/20170221195116.13278-3-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                      |    3 +++
 include/trace/events/fs_dax.h |    2 ++
 2 files changed, 5 insertions(+)

diff -puN fs/dax.c~dax-add-tracepoints-to-dax_pfn_mkwrite fs/dax.c
--- a/fs/dax.c~dax-add-tracepoints-to-dax_pfn_mkwrite
+++ a/fs/dax.c
@@ -927,6 +927,7 @@ int dax_pfn_mkwrite(struct vm_fault *vmf
 {
 	struct file *file = vmf->vma->vm_file;
 	struct address_space *mapping = file->f_mapping;
+	struct inode *inode = mapping->host;
 	void *entry, **slot;
 	pgoff_t index = vmf->pgoff;
 
@@ -936,6 +937,7 @@ int dax_pfn_mkwrite(struct vm_fault *vmf
 		if (entry)
 			put_unlocked_mapping_entry(mapping, index, entry);
 		spin_unlock_irq(&mapping->tree_lock);
+		trace_dax_pfn_mkwrite_no_entry(inode, vmf, VM_FAULT_NOPAGE);
 		return VM_FAULT_NOPAGE;
 	}
 	radix_tree_tag_set(&mapping->page_tree, index, PAGECACHE_TAG_DIRTY);
@@ -948,6 +950,7 @@ int dax_pfn_mkwrite(struct vm_fault *vmf
 	 */
 	finish_mkwrite_fault(vmf);
 	put_locked_mapping_entry(mapping, index, entry);
+	trace_dax_pfn_mkwrite(inode, vmf, VM_FAULT_NOPAGE);
 	return VM_FAULT_NOPAGE;
 }
 EXPORT_SYMBOL_GPL(dax_pfn_mkwrite);
diff -puN include/trace/events/fs_dax.h~dax-add-tracepoints-to-dax_pfn_mkwrite include/trace/events/fs_dax.h
--- a/include/trace/events/fs_dax.h~dax-add-tracepoints-to-dax_pfn_mkwrite
+++ a/include/trace/events/fs_dax.h
@@ -190,6 +190,8 @@ DEFINE_EVENT(dax_pte_fault_class, name,
 
 DEFINE_PTE_FAULT_EVENT(dax_pte_fault);
 DEFINE_PTE_FAULT_EVENT(dax_pte_fault_done);
+DEFINE_PTE_FAULT_EVENT(dax_pfn_mkwrite_no_entry);
+DEFINE_PTE_FAULT_EVENT(dax_pfn_mkwrite);
 
 #endif /* _TRACE_FS_DAX_H */
 
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are


