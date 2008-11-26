From: akpm@linux-foundation.org
Subject: - quota-make-_suspended-just-a-flag.patch removed from -mm tree
Date: Wed, 26 Nov 2008 12:27:09 -0800
Message-ID: <200811262027.mAQKR9tC000315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbYKZU1P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 15:27:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: make _SUSPENDED just a flag
has been removed from the -mm tree.  Its filename was
     quota-make-_suspended-just-a-flag.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: make _SUSPENDED just a flag
From: Jan Kara <jack@suse.cz>

Up to now, DQUOT_USR_SUSPENDED behaved like a state - i.e., either quota
was enabled or suspended or none.  Now allowed states are 0, ENABLED,
ENABLED | SUSPENDED.  This will be useful later when we implement separate
enabling of quota usage tracking and limits enforcement because we need to
keep track of a state which has been suspended.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c               |   10 ++++++----
 include/linux/quotaops.h |    6 ++++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff -puN fs/dquot.c~quota-make-_suspended-just-a-flag fs/dquot.c
--- a/fs/dquot.c~quota-make-_suspended-just-a-flag
+++ a/fs/dquot.c
@@ -1564,18 +1564,20 @@ static inline void reset_enable_flags(st
 {
 	switch (type) {
 		case USRQUOTA:
-			dqopt->flags &= ~DQUOT_USR_ENABLED;
 			if (remount)
 				dqopt->flags |= DQUOT_USR_SUSPENDED;
-			else
+			else {
+				dqopt->flags &= ~DQUOT_USR_ENABLED;
 				dqopt->flags &= ~DQUOT_USR_SUSPENDED;
+			}
 			break;
 		case GRPQUOTA:
-			dqopt->flags &= ~DQUOT_GRP_ENABLED;
 			if (remount)
 				dqopt->flags |= DQUOT_GRP_SUSPENDED;
-			else
+			else {
+				dqopt->flags &= ~DQUOT_GRP_ENABLED;
 				dqopt->flags &= ~DQUOT_GRP_SUSPENDED;
+			}
 			break;
 	}
 }
diff -puN include/linux/quotaops.h~quota-make-_suspended-just-a-flag include/linux/quotaops.h
--- a/include/linux/quotaops.h~quota-make-_suspended-just-a-flag
+++ a/include/linux/quotaops.h
@@ -67,8 +67,10 @@ static inline struct mem_dqinfo *sb_dqin
 static inline int sb_has_quota_enabled(struct super_block *sb, int type)
 {
 	if (type == USRQUOTA)
-		return sb_dqopt(sb)->flags & DQUOT_USR_ENABLED;
-	return sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED;
+		return (sb_dqopt(sb)->flags & DQUOT_USR_ENABLED)
+			&& !(sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED);
+	return (sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED)
+		&& !(sb_dqopt(sb)->flags & DQUOT_GROUP_SUSPENDED);
 }
 
 static inline int sb_any_quota_enabled(struct super_block *sb)
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
quota-make-_suspended-just-a-flag.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix.patch
ext3-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
ext4-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
reiserfs-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
quota-remove-compatibility-function-sb_any_quota_enabled.patch
quota-introduce-dquot_quota_sys_file-flag.patch
quota-move-quotaio_vh-from-include-linux-to-fs.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-split-off-quota-tree-handling-into-a-separate-file.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch

