From: akpm@linux-foundation.org
Subject: + quota-convert-macros-to-inline-functions.patch added to -mm tree
Date: Thu, 05 Jun 2008 11:50:31 -0700
Message-ID: <200806051850.m55IoVht024477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756676AbYFESuf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 14:50:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     quota: convert macros to inline functions
has been added to the -mm tree.  Its filename is
     quota-convert-macros-to-inline-functions.patch

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
Subject: quota: convert macros to inline functions
From: Jan Kara <jack@suse.cz>

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/quota.h    |    5 ++
 include/linux/quotaops.h |   65 ++++++++++++++++++++++++++++---------
 2 files changed, 54 insertions(+), 16 deletions(-)

diff -puN include/linux/quota.h~quota-convert-macros-to-inline-functions include/linux/quota.h
--- a/include/linux/quota.h~quota-convert-macros-to-inline-functions
+++ a/include/linux/quota.h
@@ -223,7 +223,10 @@ struct super_block;
 #define DQF_INFO_DIRTY (1 << DQF_INFO_DIRTY_B)	/* Is info dirty? */
 
 extern void mark_info_dirty(struct super_block *sb, int type);
-#define info_dirty(info) test_bit(DQF_INFO_DIRTY_B, &(info)->dqi_flags)
+static inline int info_dirty(struct mem_dqinfo *info)
+{
+	return test_bit(DQF_INFO_DIRTY_B, &info->dqi_flags);
+}
 
 struct dqstats {
 	int lookups;
diff -puN include/linux/quotaops.h~quota-convert-macros-to-inline-functions include/linux/quotaops.h
--- a/include/linux/quotaops.h~quota-convert-macros-to-inline-functions
+++ a/include/linux/quotaops.h
@@ -52,25 +52,45 @@ void vfs_dq_drop(struct inode *inode);
 int vfs_dq_transfer(struct inode *inode, struct iattr *iattr);
 int vfs_dq_quota_on_remount(struct super_block *sb);
 
-#define sb_dqopt(sb) (&(sb)->s_dquot)
-#define sb_dqinfo(sb, type) (sb_dqopt(sb)->info+(type))
+static inline struct quota_info *sb_dqopt(struct super_block *sb)
+{
+	return &sb->s_dquot;
+}
+
+static inline struct mem_dqinfo *sb_dqinfo(struct super_block *sb, int type)
+{
+	return sb_dqopt(sb)->info + type;
+}
 
 /*
  * Functions for checking status of quota
  */
 
-#define sb_has_quota_enabled(sb, type) ((type)==USRQUOTA ? \
-	(sb_dqopt(sb)->flags & DQUOT_USR_ENABLED) : (sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED))
+static inline int sb_has_quota_enabled(struct super_block *sb, int type)
+{
+	if (type == USRQUOTA)
+		return sb_dqopt(sb)->flags & DQUOT_USR_ENABLED;
+	return sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED;
+}
 
-#define sb_any_quota_enabled(sb) (sb_has_quota_enabled(sb, USRQUOTA) | \
-				  sb_has_quota_enabled(sb, GRPQUOTA))
+static inline int sb_any_quota_enabled(struct super_block *sb)
+{
+	return sb_has_quota_enabled(sb, USRQUOTA) ||
+		sb_has_quota_enabled(sb, GRPQUOTA);
+}
 
-#define sb_has_quota_suspended(sb, type) \
-	((type) == USRQUOTA ? (sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED) : \
-			      (sb_dqopt(sb)->flags & DQUOT_GRP_SUSPENDED))
+static inline int sb_has_quota_suspended(struct super_block *sb, int type)
+{
+	if (type == USRQUOTA)
+		return sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED;
+	return sb_dqopt(sb)->flags & DQUOT_GRP_SUSPENDED;
+}
 
-#define sb_any_quota_suspended(sb) (sb_has_quota_suspended(sb, USRQUOTA) | \
-				  sb_has_quota_suspended(sb, GRPQUOTA))
+static inline int sb_any_quota_suspended(struct super_block *sb)
+{
+	return sb_has_quota_suspended(sb, USRQUOTA) ||
+		sb_has_quota_suspended(sb, GRPQUOTA);
+}
 
 /*
  * Operations supported for diskquotas.
@@ -179,10 +199,25 @@ static inline int vfs_dq_off(struct supe
 
 #else
 
-#define sb_has_quota_enabled(sb, type) 0
-#define sb_any_quota_enabled(sb) 0
-#define sb_has_quota_suspended(sb, type) 0
-#define sb_any_quota_suspended(sb) 0
+static inline int sb_has_quota_enabled(struct super_block *sb, int type)
+{
+	return 0;
+}
+
+static inline int sb_any_quota_enabled(struct super_block *sb)
+{
+	return 0;
+}
+
+static inline int sb_has_quota_suspended(struct super_block *sb, int type)
+{
+	return 0;
+}
+
+static inline int sb_any_quota_suspended(struct super_block *sb)
+{
+	return 0;
+}
 
 /*
  * NO-OP when quota not configured.
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
ext3-fix-synchronization-of-quota-files-in-journal=data-mode.patch
ext3-fix-typos-in-messages-and-comments-journalled-journaled.patch
ext3-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
jbd-strictly-check-for-write-errors-on-data-buffers.patch
jbd-ordered-data-integrity-fix.patch
jbd-abort-when-failed-to-log-metadata-buffers.patch
jbd-fix-error-handling-for-checkpoint-io.patch
ext3-abort-ext3-if-the-journal-has-aborted.patch
reiserfs-fix-synchronization-of-quota-files-in-journal=data-mode.patch
reiserfs-fix-typos-in-messages-and-comments-journalled-journaled.patch
reiserfs-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
quota-rename-quota-functions-from-upper-case-make-bigger-ones-non-inline.patch
quota-cleanup-loop-in-sync_dquots.patch
quota-move-function-macros-from-quotah-to-quotaopsh.patch
quota-convert-macros-to-inline-functions.patch

