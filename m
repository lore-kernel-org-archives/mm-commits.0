From: akpm@linux-foundation.org
Subject: + quota-convert-macros-to-inline-functions.patch added to -mm tree
Date: Tue, 03 Jun 2008 16:18:52 -0700
Message-ID: <200806032318.m53NIqWI025121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753640AbYFCXS5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 19:18:57 -0400
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

 include/linux/quota.h |   55 ++++++++++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 16 deletions(-)

diff -puN include/linux/quota.h~quota-convert-macros-to-inline-functions include/linux/quota.h
--- a/include/linux/quota.h~quota-convert-macros-to-inline-functions
+++ a/include/linux/quota.h
@@ -125,10 +125,20 @@ extern spinlock_t dq_data_lock;
 #define DQUOT_DEL_REWRITE max(V1_DEL_REWRITE, V2_DEL_REWRITE)
 
 void mark_info_dirty(struct super_block *sb, int type);
-#define info_dirty(info) test_bit(DQF_INFO_DIRTY_B, &(info)->dqi_flags)
-
-#define sb_dqopt(sb) (&(sb)->s_dquot)
-#define sb_dqinfo(sb, type) (sb_dqopt(sb)->info+(type))
+static inline int info_dirty(struct mem_dqinfo *info)
+{
+	return test_bit(DQF_INFO_DIRTY_B, &info->dqi_flags);
+}
+
+static inline struct quota_info *sb_dqopt(struct super_block *sb)
+{
+	return &sb->s_dquot;
+}
+
+static inline struct mem_dqinfo *sb_dqinfo(struct super_block *sb, int type)
+{
+	return sb_dqopt(sb)->info + type;
+}
 
 struct dqstats {
 	int lookups;
@@ -146,18 +156,31 @@ extern struct dqstats dqstats;
 #define QUOTA_OK          0
 #define NO_QUOTA          1
 
-#define sb_has_quota_enabled(sb, type) ((type)==USRQUOTA ? \
-	(sb_dqopt(sb)->flags & DQUOT_USR_ENABLED) : (sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED))
-
-#define sb_any_quota_enabled(sb) (sb_has_quota_enabled(sb, USRQUOTA) | \
-				  sb_has_quota_enabled(sb, GRPQUOTA))
-
-#define sb_has_quota_suspended(sb, type) \
-	((type) == USRQUOTA ? (sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED) : \
-			      (sb_dqopt(sb)->flags & DQUOT_GRP_SUSPENDED))
-
-#define sb_any_quota_suspended(sb) (sb_has_quota_suspended(sb, USRQUOTA) | \
-				  sb_has_quota_suspended(sb, GRPQUOTA))
+static inline int sb_has_quota_enabled(struct super_block *sb, int type)
+{
+	if (type == USRQUOTA)
+		return sb_dqopt(sb)->flags & DQUOT_USR_ENABLED;
+	return sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED;
+}
+
+static inline int sb_any_quota_enabled(struct super_block *sb)
+{
+	return sb_has_quota_enabled(sb, USRQUOTA) ||
+		sb_has_quota_enabled(sb, GRPQUOTA);
+}
+
+static inline int sb_has_quota_suspended(struct super_block *sb, int type)
+{
+	if (type == USRQUOTA)
+		return sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED;
+	return sb_dqopt(sb)->flags & DQUOT_GRP_SUSPENDED;
+}
+
+static inline int sb_any_quota_suspended(struct super_block *sb)
+{
+	return sb_has_quota_suspended(sb, USRQUOTA) ||
+		sb_has_quota_suspended(sb, GRPQUOTA);
+}
 
 int register_quota_format(struct quota_format_type *fmt);
 void unregister_quota_format(struct quota_format_type *fmt);
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
ext4-add-explicit-include-of-linux-quotah-into-ext4_jbd2h.patch
ext2-add-explicit-include-of-linux-quotah-into-superc.patch
quota-split-out-quota_structh-out-of-quotah.patch
quota-convert-macros-to-inline-functions.patch

