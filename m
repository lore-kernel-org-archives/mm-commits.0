From: akpm@linux-foundation.org
Subject: + quota-implement-sending-information-via-netlink-about-user-below-quota.patch added to -mm tree
Date: Sat, 12 Jul 2008 18:30:43 -0700
Message-ID: <200807130130.m6D1UhlR030727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752279AbYGMBbA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Jul 2008 21:31:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, slava@nsys.by


The patch titled
     quota: implement sending information via netlink about user below quota
has been added to the -mm tree.  Its filename is
     quota-implement-sending-information-via-netlink-about-user-below-quota.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: implement sending information via netlink about user below quota
From: Jan Kara <jack@suse.cz>

Sometimes it may be useful for userspace to know (e.g.  for some hosting
guys) that some user stopped exceeding his hardlimit or softlimit in
quotas.  Implement sending of such events to userspace via quota netlink
protocol so that they don't have to poll for such events.  Based on idea
and initial implementation by Vladislav Bogdanov.

Cc: Vladislav Bogdanov <slava@nsys.by>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c            |   60 ++++++++++++++++++++++++++++++++++++----
 include/linux/quota.h |    4 ++
 2 files changed, 58 insertions(+), 6 deletions(-)

diff -puN fs/dquot.c~quota-implement-sending-information-via-netlink-about-user-below-quota fs/dquot.c
--- a/fs/dquot.c~quota-implement-sending-information-via-netlink-about-user-below-quota
+++ a/fs/dquot.c
@@ -889,7 +889,10 @@ static void print_warning(struct dquot *
 	char *msg = NULL;
 	struct tty_struct *tty;
 
-	if (!need_print_warning(dquot))
+	if (warntype == QUOTA_NL_IHARDBELOW ||
+	    warntype == QUOTA_NL_ISOFTBELOW ||
+	    warntype == QUOTA_NL_BHARDBELOW ||
+	    warntype == QUOTA_NL_BSOFTBELOW || !need_print_warning(dquot))
 		return;
 
 	mutex_lock(&tty_mutex);
@@ -1097,6 +1100,35 @@ static int check_bdq(struct dquot *dquot
 	return QUOTA_OK;
 }
 
+static int info_idq_free(struct dquot *dquot, ulong inodes)
+{
+	if (test_bit(DQ_FAKE_B, &dquot->dq_flags) ||
+	    dquot->dq_dqb.dqb_curinodes <= dquot->dq_dqb.dqb_isoftlimit)
+		return QUOTA_NL_NOWARN;
+
+	if (dquot->dq_dqb.dqb_curinodes - inodes <= dquot->dq_dqb.dqb_isoftlimit)
+		return QUOTA_NL_ISOFTBELOW;
+	if (dquot->dq_dqb.dqb_curinodes >= dquot->dq_dqb.dqb_ihardlimit &&
+	    dquot->dq_dqb.dqb_curinodes - inodes < dquot->dq_dqb.dqb_ihardlimit)
+		return QUOTA_NL_IHARDBELOW;
+	return QUOTA_NL_NOWARN;
+}
+
+static int info_bdq_free(struct dquot *dquot, qsize_t space)
+{
+	if (test_bit(DQ_FAKE_B, &dquot->dq_flags) ||
+	    toqb(dquot->dq_dqb.dqb_curspace) <= dquot->dq_dqb.dqb_bsoftlimit)
+		return QUOTA_NL_NOWARN;
+
+	if (toqb(dquot->dq_dqb.dqb_curspace - space) <=
+	    dquot->dq_dqb.dqb_bsoftlimit)
+		return QUOTA_NL_BSOFTBELOW;
+	if (toqb(dquot->dq_dqb.dqb_curspace) >= dquot->dq_dqb.dqb_bhardlimit &&
+	    toqb(dquot->dq_dqb.dqb_curspace - space) <
+						dquot->dq_dqb.dqb_bhardlimit)
+		return QUOTA_NL_BHARDBELOW;
+	return QUOTA_NL_NOWARN;
+}
 /*
  *	Initialize quota pointers in inode
  *	Transaction must be started at entry
@@ -1284,6 +1316,7 @@ warn_put_all:
 int dquot_free_space(struct inode *inode, qsize_t number)
 {
 	unsigned int cnt;
+	char warntype[MAXQUOTAS];
 
 	/* First test before acquiring mutex - solves deadlocks when we
          * re-enter the quota code and are already holding the mutex */
@@ -1292,6 +1325,7 @@ out_sub:
 		inode_sub_bytes(inode, number);
 		return QUOTA_OK;
 	}
+
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	/* Now recheck reliably when holding dqptr_sem */
 	if (IS_NOQUOTA(inode)) {
@@ -1302,6 +1336,7 @@ out_sub:
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (inode->i_dquot[cnt] == NODQUOT)
 			continue;
+		warntype[cnt] = info_bdq_free(inode->i_dquot[cnt], number);
 		dquot_decr_space(inode->i_dquot[cnt], number);
 	}
 	inode_sub_bytes(inode, number);
@@ -1310,6 +1345,7 @@ out_sub:
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 		if (inode->i_dquot[cnt])
 			mark_dquot_dirty(inode->i_dquot[cnt]);
+	flush_warnings(inode->i_dquot, warntype);
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return QUOTA_OK;
 }
@@ -1320,11 +1356,13 @@ out_sub:
 int dquot_free_inode(const struct inode *inode, unsigned long number)
 {
 	unsigned int cnt;
+	char warntype[MAXQUOTAS];
 
 	/* First test before acquiring mutex - solves deadlocks when we
          * re-enter the quota code and are already holding the mutex */
 	if (IS_NOQUOTA(inode))
 		return QUOTA_OK;
+
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	/* Now recheck reliably when holding dqptr_sem */
 	if (IS_NOQUOTA(inode)) {
@@ -1335,6 +1373,7 @@ int dquot_free_inode(const struct inode 
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (inode->i_dquot[cnt] == NODQUOT)
 			continue;
+		warntype[cnt] = info_idq_free(inode->i_dquot[cnt], number);
 		dquot_decr_inodes(inode->i_dquot[cnt], number);
 	}
 	spin_unlock(&dq_data_lock);
@@ -1342,6 +1381,7 @@ int dquot_free_inode(const struct inode 
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 		if (inode->i_dquot[cnt])
 			mark_dquot_dirty(inode->i_dquot[cnt]);
+	flush_warnings(inode->i_dquot, warntype);
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return QUOTA_OK;
 }
@@ -1359,7 +1399,8 @@ int dquot_transfer(struct inode *inode, 
 	struct dquot *transfer_to[MAXQUOTAS];
 	int cnt, ret = NO_QUOTA, chuid = (iattr->ia_valid & ATTR_UID) && inode->i_uid != iattr->ia_uid,
 	    chgid = (iattr->ia_valid & ATTR_GID) && inode->i_gid != iattr->ia_gid;
-	char warntype[MAXQUOTAS];
+	char warntype_to[MAXQUOTAS];
+	char warntype_from_inodes[MAXQUOTAS], warntype_from_space[MAXQUOTAS];
 
 	/* First test before acquiring mutex - solves deadlocks when we
          * re-enter the quota code and are already holding the mutex */
@@ -1368,7 +1409,7 @@ int dquot_transfer(struct inode *inode, 
 	/* Clear the arrays */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		transfer_to[cnt] = transfer_from[cnt] = NODQUOT;
-		warntype[cnt] = QUOTA_NL_NOWARN;
+		warntype_to[cnt] = QUOTA_NL_NOWARN;
 	}
 	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	/* Now recheck reliably when holding dqptr_sem */
@@ -1400,8 +1441,9 @@ int dquot_transfer(struct inode *inode, 
 		if (transfer_to[cnt] == NODQUOT)
 			continue;
 		transfer_from[cnt] = inode->i_dquot[cnt];
-		if (check_idq(transfer_to[cnt], 1, warntype+cnt) == NO_QUOTA ||
-		    check_bdq(transfer_to[cnt], space, 0, warntype+cnt) == NO_QUOTA)
+		if (check_idq(transfer_to[cnt], 1, warntype_to + cnt) ==
+		    NO_QUOTA || check_bdq(transfer_to[cnt], space, 0,
+		    warntype_to + cnt) == NO_QUOTA)
 			goto warn_put_all;
 	}
 
@@ -1417,6 +1459,10 @@ int dquot_transfer(struct inode *inode, 
 
 		/* Due to IO error we might not have transfer_from[] structure */
 		if (transfer_from[cnt]) {
+			warntype_from_inodes[cnt] =
+				info_idq_free(transfer_from[cnt], 1);
+			warntype_from_space[cnt] =
+				info_bdq_free(transfer_from[cnt], space);
 			dquot_decr_inodes(transfer_from[cnt], 1);
 			dquot_decr_space(transfer_from[cnt], space);
 		}
@@ -1436,7 +1482,9 @@ warn_put_all:
 		if (transfer_to[cnt])
 			mark_dquot_dirty(transfer_to[cnt]);
 	}
-	flush_warnings(transfer_to, warntype);
+	flush_warnings(transfer_to, warntype_to);
+	flush_warnings(transfer_from, warntype_from_inodes);
+	flush_warnings(transfer_from, warntype_from_space);
 	
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (ret == QUOTA_OK && transfer_from[cnt] != NODQUOT)
diff -puN include/linux/quota.h~quota-implement-sending-information-via-netlink-about-user-below-quota include/linux/quota.h
--- a/include/linux/quota.h~quota-implement-sending-information-via-netlink-about-user-below-quota
+++ a/include/linux/quota.h
@@ -135,6 +135,10 @@ struct if_dqinfo {
 #define QUOTA_NL_BHARDWARN 4		/* Block hardlimit reached */
 #define QUOTA_NL_BSOFTLONGWARN 5	/* Block grace time expired */
 #define QUOTA_NL_BSOFTWARN 6		/* Block softlimit reached */
+#define QUOTA_NL_IHARDBELOW 7		/* Usage got below inode hardlimit */
+#define QUOTA_NL_ISOFTBELOW 8		/* Usage got below inode softlimit */
+#define QUOTA_NL_BHARDBELOW 9		/* Usage got below block hardlimit */
+#define QUOTA_NL_BSOFTBELOW 10		/* Usage got below block softlimit */
 
 enum {
 	QUOTA_NL_C_UNSPEC,
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
ext3-fix-synchronization-of-quota-files-in-journal=data-mode.patch
ext3-fix-typos-in-messages-and-comments-journalled-journaled.patch
ext3-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
jbd-positively-dispose-the-unmapped-data-buffers-in-journal_commit_transaction.patch
jbd-dont-abort-if-flushing-file-data-failed.patch
jbd-dont-abort-if-flushing-file-data-failed-fix.patch
reiserfs-fix-synchronization-of-quota-files-in-journal=data-mode.patch
reiserfs-fix-typos-in-messages-and-comments-journalled-journaled.patch
reiserfs-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
quota-fix-possible-infinite-loop-in-quota-code.patch
quota-rename-quota-functions-from-upper-case-make-bigger-ones-non-inline.patch
quota-cleanup-loop-in-sync_dquots.patch
quota-move-function-macros-from-quotah-to-quotaopsh.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-fix.patch
quota-convert-macros-to-inline-functions.patch
quota-implement-sending-information-via-netlink-about-user-below-quota.patch

