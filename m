From: akpm@linux-foundation.org
Subject: - quota-cleanup-loop-in-sync_dquots.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:57:50 -0700
Message-ID: <200807252257.m6PMvojp003226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753608AbYGYXGd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, vegard.nossum@gmail.com, mm-commits@vger.kernel.org


The patch titled
     quota: cleanup loop in sync_dquots()
has been removed from the -mm tree.  Its filename was
     quota-cleanup-loop-in-sync_dquots.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: cleanup loop in sync_dquots()
From: Jan Kara <jack@suse.cz>

Make loop in sync_dquots() checking whether there's something to write
more readable, remove useless variable and macro info_any_dirty() which
is used only in this place.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/quota.c            |   18 ++++++++++++------
 include/linux/quota.h |    2 --
 2 files changed, 12 insertions(+), 8 deletions(-)

diff -puN fs/quota.c~quota-cleanup-loop-in-sync_dquots fs/quota.c
--- a/fs/quota.c~quota-cleanup-loop-in-sync_dquots
+++ a/fs/quota.c
@@ -186,7 +186,7 @@ static void quota_sync_sb(struct super_b
 
 void sync_dquots(struct super_block *sb, int type)
 {
-	int cnt, dirty;
+	int cnt;
 
 	if (sb) {
 		if (sb->s_qcop->quota_sync)
@@ -198,11 +198,17 @@ void sync_dquots(struct super_block *sb,
 restart:
 	list_for_each_entry(sb, &super_blocks, s_list) {
 		/* This test just improves performance so it needn't be reliable... */
-		for (cnt = 0, dirty = 0; cnt < MAXQUOTAS; cnt++)
-			if ((type == cnt || type == -1) && sb_has_quota_enabled(sb, cnt)
-			    && info_any_dirty(&sb_dqopt(sb)->info[cnt]))
-				dirty = 1;
-		if (!dirty)
+		for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
+			if (type != -1 && type != cnt)
+				continue;
+			if (!sb_has_quota_enabled(sb, cnt))
+				continue;
+			if (!info_dirty(&sb_dqopt(sb)->info[cnt]) &&
+			    list_empty(&sb_dqopt(sb)->info[cnt].dqi_dirty_list))
+				continue;
+			break;
+		}
+		if (cnt == MAXQUOTAS)
 			continue;
 		sb->s_count++;
 		spin_unlock(&sb_lock);
diff -puN include/linux/quota.h~quota-cleanup-loop-in-sync_dquots include/linux/quota.h
--- a/include/linux/quota.h~quota-cleanup-loop-in-sync_dquots
+++ a/include/linux/quota.h
@@ -224,8 +224,6 @@ struct super_block;
 
 extern void mark_info_dirty(struct super_block *sb, int type);
 #define info_dirty(info) test_bit(DQF_INFO_DIRTY_B, &(info)->dqi_flags)
-#define info_any_dquot_dirty(info) (!list_empty(&(info)->dqi_dirty_list))
-#define info_any_dirty(info) (info_dirty(info) || info_any_dquot_dirty(info))
 
 #define sb_dqopt(sb) (&(sb)->s_dquot)
 #define sb_dqinfo(sb, type) (sb_dqopt(sb)->info+(type))
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch

