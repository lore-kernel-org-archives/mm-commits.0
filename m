From: akpm@linux-foundation.org
Subject: - fs-sys_sync-fix.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:43 -0800
Message-ID: <200901072214.n07MEhEu014622@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761627AbZAGWOr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs: sys_sync fix
has been removed from the -mm tree.  Its filename was
     fs-sys_sync-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1133,7 +1133,6 @@ struct super_block {
 	struct rw_semaphore	s_umount;
 	struct mutex		s_lock;
 	int			s_count;
-	int			s_syncing;
 	int			s_need_sync_fs;
 	atomic_t		s_active;
 #ifdef CONFIG_SECURITY
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

