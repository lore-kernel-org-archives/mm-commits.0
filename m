From: akpm@linux-foundation.org
Subject: [folded-merged] mm-fix-xip-fault-vs-truncate-race-fix.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 15:43:18 -0800
Message-ID: <54e28096.v0MWkME1beYGEhQK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53880 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbbBPXn4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 18:43:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, matthew.r.wilcox@intel.com, rdunlap@infradead.org, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-xip-fault-vs-truncate-race-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-xip-fault-vs-truncate-race-fix.patch

This patch was dropped because it was folded into mm-fix-xip-fault-vs-truncate-race.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-xip-fault-vs-truncate-race-fix

switch to i_mmap_lock_read(), add comment in unmap_single_vma()

Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap_xip.c |   20 +++++++++++++-------
 mm/memory.c      |    5 +++++
 2 files changed, 18 insertions(+), 7 deletions(-)

diff -puN mm/filemap_xip.c~mm-fix-xip-fault-vs-truncate-race-fix mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-fix-xip-fault-vs-truncate-race-fix
+++ a/mm/filemap_xip.c
@@ -256,17 +256,20 @@ again:
 		__xip_unmap(mapping, vmf->pgoff);
 
 found:
-		/* We must recheck i_size under i_mmap_mutex */
-		mutex_lock(&mapping->i_mmap_mutex);
+		/*
+		 * We must recheck i_size under i_mmap_rwsem to prevent races
+		 * with truncation
+		 */
+		i_mmap_lock_read(mapping);
 		size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
 							PAGE_CACHE_SHIFT;
 		if (unlikely(vmf->pgoff >= size)) {
-			mutex_unlock(&mapping->i_mmap_mutex);
+			i_mmap_unlock_read(mapping);
 			return VM_FAULT_SIGBUS;
 		}
 		err = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
 							xip_pfn);
-		mutex_unlock(&mapping->i_mmap_mutex);
+		i_mmap_unlock_read(mapping);
 		if (err == -ENOMEM)
 			return VM_FAULT_OOM;
 		/*
@@ -291,8 +294,11 @@ found:
 		if (error != -ENODATA)
 			goto out;
 
-		/* We must recheck i_size under i_mmap_mutex */
-		mutex_lock(&mapping->i_mmap_mutex);
+		/*
+		 * We must recheck i_size under i_mmap_rwsem to prevent races
+		 * with truncation
+		 */
+		i_mmap_lock_read(mapping);
 		size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
 							PAGE_CACHE_SHIFT;
 		if (unlikely(vmf->pgoff >= size)) {
@@ -310,7 +316,7 @@ found:
 
 		ret = VM_FAULT_NOPAGE;
 unlock:
-		mutex_unlock(&mapping->i_mmap_mutex);
+		i_mmap_unlock_read(mapping);
 out:
 		write_seqcount_end(&xip_sparse_seq);
 		mutex_unlock(&xip_sparse_mutex);
diff -puN mm/memory.c~mm-fix-xip-fault-vs-truncate-race-fix mm/memory.c
--- a/mm/memory.c~mm-fix-xip-fault-vs-truncate-race-fix
+++ a/mm/memory.c
@@ -1303,6 +1303,11 @@ static void unmap_single_vma(struct mmu_
 			 * safe to do nothing in this case.
 			 */
 			if (vma->vm_file) {
+				/*
+				 * Note that DAX uses i_mmap_lock to serialise
+				 * against file truncate - truncate calls into
+				 * unmap_single_vma().
+				 */
 				i_mmap_lock_write(vma->vm_file->f_mapping);
 				__unmap_hugepage_range_final(tlb, vma, start, end, NULL);
 				i_mmap_unlock_write(vma->vm_file->f_mapping);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch

