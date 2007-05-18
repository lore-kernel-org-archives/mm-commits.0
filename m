From: akpm@linux-foundation.org
Subject: - circular-locking-dependency-found-in-quota-off.patch removed from -mm tree
Date: Fri, 18 May 2007 00:06:41 -0700
Message-ID: <200705180706.l4I76eWT010199@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53600 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306AbXERH1m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:27:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     circular locking dependency found in QUOTA OFF
has been removed from the -mm tree.  Its filename was
     circular-locking-dependency-found-in-quota-off.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: circular locking dependency found in QUOTA OFF
From: Jan Kara <jack@suse.cz>

i_mutex on quota files is special.  Unlike i_mutexes for other inodes it is
acquired under dqonoff_mutex.  Tell lockdep about this lock ranking.  Also
comment and code in quota_sync_sb() seem to be bogus (as i_mutex for quota
file can be acquired under dqonoff_mutex).  Move truncate_inode_pages()
call under dqonoff_mutex and save some problems with races...

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c |    2 +-
 fs/quota.c |   23 +++++++----------------
 2 files changed, 8 insertions(+), 17 deletions(-)

diff -puN fs/dquot.c~circular-locking-dependency-found-in-quota-off fs/dquot.c
--- a/fs/dquot.c~circular-locking-dependency-found-in-quota-off
+++ a/fs/dquot.c
@@ -1421,7 +1421,7 @@ int vfs_quota_off(struct super_block *sb
 			/* If quota was reenabled in the meantime, we have
 			 * nothing to do */
 			if (!sb_has_quota_enabled(sb, cnt)) {
-				mutex_lock(&toputinode[cnt]->i_mutex);
+				mutex_lock_nested(&toputinode[cnt]->i_mutex, I_MUTEX_QUOTA);
 				toputinode[cnt]->i_flags &= ~(S_IMMUTABLE |
 				  S_NOATIME | S_NOQUOTA);
 				truncate_inode_pages(&toputinode[cnt]->i_data, 0);
diff -puN fs/quota.c~circular-locking-dependency-found-in-quota-off fs/quota.c
--- a/fs/quota.c~circular-locking-dependency-found-in-quota-off
+++ a/fs/quota.c
@@ -157,7 +157,6 @@ static int check_quotactl_valid(struct s
 static void quota_sync_sb(struct super_block *sb, int type)
 {
 	int cnt;
-	struct inode *discard[MAXQUOTAS];
 
 	sb->s_qcop->quota_sync(sb, type);
 	/* This is not very clever (and fast) but currently I don't know about
@@ -167,29 +166,21 @@ static void quota_sync_sb(struct super_b
 		sb->s_op->sync_fs(sb, 1);
 	sync_blockdev(sb->s_bdev);
 
-	/* Now when everything is written we can discard the pagecache so
-	 * that userspace sees the changes. We need i_mutex and so we could
-	 * not do it inside dqonoff_mutex. Moreover we need to be carefull
-	 * about races with quotaoff() (that is the reason why we have own
-	 * reference to inode). */
+	/*
+	 * Now when everything is written we can discard the pagecache so
+	 * that userspace sees the changes.
+	 */
 	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		discard[cnt] = NULL;
 		if (type != -1 && cnt != type)
 			continue;
 		if (!sb_has_quota_enabled(sb, cnt))
 			continue;
-		discard[cnt] = igrab(sb_dqopt(sb)->files[cnt]);
+		mutex_lock_nested(&sb_dqopt(sb)->files[cnt]->i_mutex, I_MUTEX_QUOTA);
+		truncate_inode_pages(&sb_dqopt(sb)->files[cnt]->i_data, 0);
+		mutex_unlock(&sb_dqopt(sb)->files[cnt]->i_mutex);
 	}
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
-	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (discard[cnt]) {
-			mutex_lock(&discard[cnt]->i_mutex);
-			truncate_inode_pages(&discard[cnt]->i_data, 0);
-			mutex_unlock(&discard[cnt]->i_mutex);
-			iput(discard[cnt]);
-		}
-	}
 }
 
 void sync_dquots(struct super_block *sb, int type)
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
ext4-copy-i_flags-to-inode-flags-on-write.patch
