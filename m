Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D671BC48BC2
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 20:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0F4A611C9
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 20:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhFWUgP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Jun 2021 16:36:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhFWUgP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Jun 2021 16:36:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31ED1611AD;
        Wed, 23 Jun 2021 20:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624480436;
        bh=6d9qVqBh7TI5lMghG8ubtAtWGmnz3ENtny5nVLZxkLQ=;
        h=Date:From:To:Subject:From;
        b=zw53fZLD3bZ4JzcZEzKyIFqbv4+ybTSwQn29JkhrcglrgQMmx6cFKoOc2PGmiNYrJ
         5oP1CZzKheYgyTPzXMK6ia9uFE1uE2VgPS40PE+qXN+kT4trRozBsPSCwS3TpYvJIq
         7Fy3cfmuRpmTs4GT83wLREjfEFjO0QKM5pGiPKT8=
Date:   Wed, 23 Jun 2021 13:33:55 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, hughd@google.com, jack@suse.cz,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged] mm-fix-comments-mentioning-i_mutex.patch removed
 from -mm tree
Message-ID: <20210623203355.V0EaX0sU6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix comments mentioning i_mutex
has been removed from the -mm tree.  Its filename was
     mm-fix-comments-mentioning-i_mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: fix comments mentioning i_mutex

inode->i_mutex has been replaced with inode->i_rwsem long ago.  Fix
comments still mentioning i_mutex.

Link: https://lkml.kernel.org/r/20210429094141.12819-1-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c        |   10 +++++-----
 mm/madvise.c        |    2 +-
 mm/memory-failure.c |    2 +-
 mm/rmap.c           |    6 +++---
 mm/shmem.c          |   20 ++++++++++----------
 mm/truncate.c       |    8 ++++----
 6 files changed, 24 insertions(+), 24 deletions(-)

--- a/mm/filemap.c~mm-fix-comments-mentioning-i_mutex
+++ a/mm/filemap.c
@@ -76,7 +76,7 @@
  *      ->swap_lock		(exclusive_swap_page, others)
  *        ->i_pages lock
  *
- *  ->i_mutex
+ *  ->i_rwsem
  *    ->i_mmap_rwsem		(truncate->unmap_mapping_range)
  *
  *  ->mmap_lock
@@ -87,7 +87,7 @@
  *  ->mmap_lock
  *    ->lock_page		(access_process_vm)
  *
- *  ->i_mutex			(generic_perform_write)
+ *  ->i_rwsem			(generic_perform_write)
  *    ->mmap_lock		(fault_in_pages_readable->do_page_fault)
  *
  *  bdi->wb.list_lock
@@ -3715,12 +3715,12 @@ EXPORT_SYMBOL(generic_perform_write);
  * modification times and calls proper subroutines depending on whether we
  * do direct IO or a standard buffered write.
  *
- * It expects i_mutex to be grabbed unless we work on a block device or similar
+ * It expects i_rwsem to be grabbed unless we work on a block device or similar
  * object which does not need locking at all.
  *
  * This function does *not* take care of syncing data in case of O_SYNC write.
  * A caller has to handle it. This is mainly due to the fact that we want to
- * avoid syncing under i_mutex.
+ * avoid syncing under i_rwsem.
  *
  * Return:
  * * number of bytes written, even for truncated writes
@@ -3808,7 +3808,7 @@ EXPORT_SYMBOL(__generic_file_write_iter)
  *
  * This is a wrapper around __generic_file_write_iter() to be used by most
  * filesystems. It takes care of syncing the file in case of O_SYNC file
- * and acquires i_mutex as needed.
+ * and acquires i_rwsem as needed.
  * Return:
  * * negative error code if no data has been written at all of
  *   vfs_fsync_range() failed for a synchronous write
--- a/mm/madvise.c~mm-fix-comments-mentioning-i_mutex
+++ a/mm/madvise.c
@@ -910,7 +910,7 @@ static long madvise_remove(struct vm_are
 			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
 
 	/*
-	 * Filesystem's fallocate may need to take i_mutex.  We need to
+	 * Filesystem's fallocate may need to take i_rwsem.  We need to
 	 * explicitly grab a reference because the vma (and hence the
 	 * vma's reference to the file) can go away as soon as we drop
 	 * mmap_lock.
--- a/mm/memory-failure.c~mm-fix-comments-mentioning-i_mutex
+++ a/mm/memory-failure.c
@@ -853,7 +853,7 @@ static int me_pagecache_clean(struct pag
 	/*
 	 * Truncation is a bit tricky. Enable it per file system for now.
 	 *
-	 * Open: to take i_mutex or not for this? Right now we don't.
+	 * Open: to take i_rwsem or not for this? Right now we don't.
 	 */
 	ret = truncate_error_page(p, pfn, mapping);
 out:
--- a/mm/rmap.c~mm-fix-comments-mentioning-i_mutex
+++ a/mm/rmap.c
@@ -20,9 +20,9 @@
 /*
  * Lock ordering in mm:
  *
- * inode->i_mutex	(while writing or truncating, not reading or faulting)
+ * inode->i_rwsem	(while writing or truncating, not reading or faulting)
  *   mm->mmap_lock
- *     page->flags PG_locked (lock_page)   * (see huegtlbfs below)
+ *     page->flags PG_locked (lock_page)   * (see hugetlbfs below)
  *       hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share)
  *         mapping->i_mmap_rwsem
  *           hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
@@ -41,7 +41,7 @@
  *                             in arch-dependent flush_dcache_mmap_lock,
  *                             within bdi.wb->list_lock in __sync_single_inode)
  *
- * anon_vma->rwsem,mapping->i_mutex      (memory_failure, collect_procs_anon)
+ * anon_vma->rwsem,mapping->i_mmap_rwsem   (memory_failure, collect_procs_anon)
  *   ->tasklist_lock
  *     pte map lock
  *
--- a/mm/shmem.c~mm-fix-comments-mentioning-i_mutex
+++ a/mm/shmem.c
@@ -96,7 +96,7 @@ static struct vfsmount *shm_mnt;
 
 /*
  * shmem_fallocate communicates with shmem_fault or shmem_writepage via
- * inode->i_private (with i_mutex making sure that it has only one user at
+ * inode->i_private (with i_rwsem making sure that it has only one user at
  * a time): we would prefer not to enlarge the shmem inode just for that.
  */
 struct shmem_falloc {
@@ -774,7 +774,7 @@ static int shmem_free_swap(struct addres
  * Determine (in bytes) how many of the shmem object's pages mapped by the
  * given offsets are swapped out.
  *
- * This is safe to call without i_mutex or the i_pages lock thanks to RCU,
+ * This is safe to call without i_rwsem or the i_pages lock thanks to RCU,
  * as long as the inode doesn't go away and racy results are not a problem.
  */
 unsigned long shmem_partial_swap_usage(struct address_space *mapping,
@@ -806,7 +806,7 @@ unsigned long shmem_partial_swap_usage(s
  * Determine (in bytes) how many of the shmem object's pages mapped by the
  * given vma is swapped out.
  *
- * This is safe to call without i_mutex or the i_pages lock thanks to RCU,
+ * This is safe to call without i_rwsem or the i_pages lock thanks to RCU,
  * as long as the inode doesn't go away and racy results are not a problem.
  */
 unsigned long shmem_swap_usage(struct vm_area_struct *vma)
@@ -1069,7 +1069,7 @@ static int shmem_setattr(struct user_nam
 		loff_t oldsize = inode->i_size;
 		loff_t newsize = attr->ia_size;
 
-		/* protected by i_mutex */
+		/* protected by i_rwsem */
 		if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
 		    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
 			return -EPERM;
@@ -2071,7 +2071,7 @@ static vm_fault_t shmem_fault(struct vm_
 	/*
 	 * Trinity finds that probing a hole which tmpfs is punching can
 	 * prevent the hole-punch from ever completing: which in turn
-	 * locks writers out with its hold on i_mutex.  So refrain from
+	 * locks writers out with its hold on i_rwsem.  So refrain from
 	 * faulting pages into the hole while it's being punched.  Although
 	 * shmem_undo_range() does remove the additions, it may be unable to
 	 * keep up, as each new page needs its own unmap_mapping_range() call,
@@ -2082,7 +2082,7 @@ static vm_fault_t shmem_fault(struct vm_
 	 * we just need to make racing faults a rare case.
 	 *
 	 * The implementation below would be much simpler if we just used a
-	 * standard mutex or completion: but we cannot take i_mutex in fault,
+	 * standard mutex or completion: but we cannot take i_rwsem in fault,
 	 * and bloating every shmem inode for this unlikely case would be sad.
 	 */
 	if (unlikely(inode->i_private)) {
@@ -2482,7 +2482,7 @@ shmem_write_begin(struct file *file, str
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	pgoff_t index = pos >> PAGE_SHIFT;
 
-	/* i_mutex is held by caller */
+	/* i_rwsem is held by caller */
 	if (unlikely(info->seals & (F_SEAL_GROW |
 				   F_SEAL_WRITE | F_SEAL_FUTURE_WRITE))) {
 		if (info->seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE))
@@ -2582,7 +2582,7 @@ static ssize_t shmem_file_read_iter(stru
 
 		/*
 		 * We must evaluate after, since reads (unlike writes)
-		 * are called without i_mutex protection against truncate
+		 * are called without i_rwsem protection against truncate
 		 */
 		nr = PAGE_SIZE;
 		i_size = i_size_read(inode);
@@ -2652,7 +2652,7 @@ static loff_t shmem_file_llseek(struct f
 		return -ENXIO;
 
 	inode_lock(inode);
-	/* We're holding i_mutex so we can access i_size directly */
+	/* We're holding i_rwsem so we can access i_size directly */
 	offset = mapping_seek_hole_data(mapping, offset, inode->i_size, whence);
 	if (offset >= 0)
 		offset = vfs_setpos(file, offset, MAX_LFS_FILESIZE);
@@ -2681,7 +2681,7 @@ static long shmem_fallocate(struct file
 		loff_t unmap_end = round_down(offset + len, PAGE_SIZE) - 1;
 		DECLARE_WAIT_QUEUE_HEAD_ONSTACK(shmem_falloc_waitq);
 
-		/* protected by i_mutex */
+		/* protected by i_rwsem */
 		if (info->seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
 			error = -EPERM;
 			goto out;
--- a/mm/truncate.c~mm-fix-comments-mentioning-i_mutex
+++ a/mm/truncate.c
@@ -422,7 +422,7 @@ EXPORT_SYMBOL(truncate_inode_pages_range
  * @mapping: mapping to truncate
  * @lstart: offset from which to truncate
  *
- * Called under (and serialised by) inode->i_mutex.
+ * Called under (and serialised by) inode->i_rwsem.
  *
  * Note: When this function returns, there can be a page in the process of
  * deletion (inside __delete_from_page_cache()) in the specified range.  Thus
@@ -439,7 +439,7 @@ EXPORT_SYMBOL(truncate_inode_pages);
  * truncate_inode_pages_final - truncate *all* pages before inode dies
  * @mapping: mapping to truncate
  *
- * Called under (and serialized by) inode->i_mutex.
+ * Called under (and serialized by) inode->i_rwsem.
  *
  * Filesystems have to use this in the .evict_inode path to inform the
  * VM that this is the final truncate and the inode is going away.
@@ -761,7 +761,7 @@ EXPORT_SYMBOL(truncate_pagecache);
  * setattr function when ATTR_SIZE is passed in.
  *
  * Must be called with a lock serializing truncates and writes (generally
- * i_mutex but e.g. xfs uses a different lock) and before all filesystem
+ * i_rwsem but e.g. xfs uses a different lock) and before all filesystem
  * specific block truncation has been performed.
  */
 void truncate_setsize(struct inode *inode, loff_t newsize)
@@ -790,7 +790,7 @@ EXPORT_SYMBOL(truncate_setsize);
  *
  * The function must be called after i_size is updated so that page fault
  * coming after we unlock the page will already see the new i_size.
- * The function must be called while we still hold i_mutex - this not only
+ * The function must be called while we still hold i_rwsem - this not only
  * makes sure i_size is stable but also that userspace cannot observe new
  * i_size value before we are prepared to store mmap writes at new inode size.
  */
_

Patches currently in -mm which might be from jack@suse.cz are

dax-fix-enomem-handling-in-grab_mapping_entry.patch

