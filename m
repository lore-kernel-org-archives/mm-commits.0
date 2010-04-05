From: akpm@linux-foundation.org
Subject: + ntfs-clean-up-ntfs_attr_extend_initialized.patch added to -mm tree
Date: Mon, 05 Apr 2010 14:49:06 -0700
Message-ID: <201004052149.o35Ln6lO011057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756145Ab0DEVtl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 17:49:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, aia21@cantab.net


The patch titled
     ntfs: clean up ntfs_attr_extend_initialized
has been added to the -mm tree.  Its filename is
     ntfs-clean-up-ntfs_attr_extend_initialized.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntfs: clean up ntfs_attr_extend_initialized
From: Minchan Kim <minchan.kim@gmail.com>

cached_page and lru_pvec have not been used.  Let's remove the arguments.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Anton Altaparmakov <aia21@cantab.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/file.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN fs/ntfs/file.c~ntfs-clean-up-ntfs_attr_extend_initialized fs/ntfs/file.c
--- a/fs/ntfs/file.c~ntfs-clean-up-ntfs_attr_extend_initialized
+++ a/fs/ntfs/file.c
@@ -98,9 +98,6 @@ static int ntfs_file_open(struct inode *
  * the page at all.  For a more detailed explanation see ntfs_truncate() in
  * fs/ntfs/inode.c.
  *
- * @cached_page and @lru_pvec are just optimizations for dealing with multiple
- * pages.
- *
  * Return 0 on success and -errno on error.  In the case that an error is
  * encountered it is possible that the initialized size will already have been
  * incremented some way towards @new_init_size but it is guaranteed that if
@@ -110,8 +107,7 @@ static int ntfs_file_open(struct inode *
  * Locking: i_mutex on the vfs inode corrseponsind to the ntfs inode @ni must be
  *	    held by the caller.
  */
-static int ntfs_attr_extend_initialized(ntfs_inode *ni, const s64 new_init_size,
-		struct page **cached_page, struct pagevec *lru_pvec)
+static int ntfs_attr_extend_initialized(ntfs_inode *ni, const s64 new_init_size)
 {
 	s64 old_init_size;
 	loff_t old_i_size;
@@ -1925,8 +1921,7 @@ static ssize_t ntfs_file_buffered_write(
 	ll = ni->initialized_size;
 	read_unlock_irqrestore(&ni->size_lock, flags);
 	if (pos > ll) {
-		err = ntfs_attr_extend_initialized(ni, pos, &cached_page,
-				&lru_pvec);
+		err = ntfs_attr_extend_initialized(ni, pos);
 		if (err < 0) {
 			ntfs_error(vol->sb, "Cannot perform write to inode "
 					"0x%lx, attribute type 0x%x, because "
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

rmap-fix-anon_vma_fork-memory-leak.patch
exit-fix-oops-in-sync_mm_rss.patch
exit-fix-oops-in-sync_mm_rss-fix.patch
mm-revert-vmscan-get_scan_ratio-cleanup.patch
ntfs-clean-up-ntfs_attr_extend_initialized.patch
ntfs-use-add_to_page_cache_lru.patch
shmem-remove-redundant-code.patch
mm-remove-return-value-of-putback_lru_pages.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch

