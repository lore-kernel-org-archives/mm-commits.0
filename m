From: akpm@linux-foundation.org
Subject: + fs-sys_sync-fix.patch added to -mm tree
Date: Thu, 11 Dec 2008 13:07:54 -0800
Message-ID: <200812112107.mBBL7sfJ018439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757165AbYLKVH7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 16:07:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     fs: sys_sync fix
has been added to the -mm tree.  Its filename is
     fs-sys_sync-fix.patch

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
Subject: fs: sys_sync fix
From: Nick Piggin <npiggin@suse.de>

s_syncing livelock avoidance was breaking data integrity guarantee of
sys_sync, by allowing sys_sync to skip writing or waiting for superblocks
if there is a concurrent sys_sync happening.

This livelock avoidance is much less important now that we don't have the
get_super_to_sync() call after every sb that we sync.  This was replaced
by __put_super_and_need_restart.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c  |   20 +-------------------
 include/linux/fs.h |    1 -
 2 files changed, 1 insertion(+), 20 deletions(-)

diff -puN fs/fs-writeback.c~fs-sys_sync-fix fs/fs-writeback.c
--- a/fs/fs-writeback.c~fs-sys_sync-fix
+++ a/fs/fs-writeback.c
@@ -652,18 +652,6 @@ void sync_inodes_sb(struct super_block *
 	sync_sb_inodes(sb, &wbc);
 }
 
-/*
- * Rather lame livelock avoidance.
- */
-static void set_sb_syncing(int val)
-{
-	struct super_block *sb;
-	spin_lock(&sb_lock);
-	list_for_each_entry_reverse(sb, &super_blocks, s_list)
-		sb->s_syncing = val;
-	spin_unlock(&sb_lock);
-}
-
 /**
  * sync_inodes - writes all inodes to disk
  * @wait: wait for completion
@@ -690,9 +678,6 @@ static void __sync_inodes(int wait)
 	spin_lock(&sb_lock);
 restart:
 	list_for_each_entry(sb, &super_blocks, s_list) {
-		if (sb->s_syncing)
-			continue;
-		sb->s_syncing = 1;
 		sb->s_count++;
 		spin_unlock(&sb_lock);
 		down_read(&sb->s_umount);
@@ -710,13 +695,10 @@ restart:
 
 void sync_inodes(int wait)
 {
-	set_sb_syncing(0);
 	__sync_inodes(0);
 
-	if (wait) {
-		set_sb_syncing(0);
+	if (wait)
 		__sync_inodes(1);
-	}
 }
 
 /**
diff -puN include/linux/fs.h~fs-sys_sync-fix include/linux/fs.h
--- a/include/linux/fs.h~fs-sys_sync-fix
+++ a/include/linux/fs.h
@@ -1112,7 +1112,6 @@ struct super_block {
 	struct rw_semaphore	s_umount;
 	struct mutex		s_lock;
 	int			s_count;
-	int			s_syncing;
 	int			s_need_sync_fs;
 	atomic_t		s_active;
 #ifdef CONFIG_SECURITY
_

Patches currently in -mm which might be from npiggin@suse.de are

linux-next.patch
mm-dont-mark_page_accessed-in-fault-path.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-invoke-oom-killer-from-page-fault.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-cyclic-fix.patch
mm-write_cache_pages-cyclic-fix-fix.patch
mm-write_cache_pages-early-loop-termination.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-write_cache_pages-integrity-fix.patch
mm-write_cache_pages-cleanups.patch
mm-write_cache_pages-optimise-page-cleaning.patch
mm-write_cache_pages-terminate-quickly.patch
mm-write_cache_pages-more-terminate-quickly.patch
mm-do_sync_mapping_range-integrity-fix.patch
mm-get-rid-of-pagevec_release_nonlru.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-vmalloc-tweak-failure-printk.patch
mm-vmalloc-improve-vmallocinfo.patch
mm-vmalloc-use-mutex-for-purge.patch
mm-vmalloc-make-lazy-unmapping-configurable.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
hugetlb-unsigned-ret-cannot-be-negative.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-direct-io-starvation-improvement.patch
fs-remove-wb_sync_hold.patch
fs-sync_sb_inodes-fix.patch
fs-sys_sync-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
mm-fsync-livelock-avoidance.patch
reiser4.patch

