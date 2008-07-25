From: akpm@linux-foundation.org
Subject: - quota-convert-macros-to-inline-functions.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:57:54 -0700
Message-ID: <200807252257.m6PMvslM003234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756653AbYGYW6Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:58:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: convert macros to inline functions
has been removed from the -mm tree.  Its filename was
     quota-convert-macros-to-inline-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: convert macros to inline functions
From: Jan Kara <jack@suse.cz>

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/quota.h    |    5 ++
 include/linux/quotaops.h |   65 +++++++++++++++++++++++++++----------
 2 files changed, 53 insertions(+), 17 deletions(-)

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
@@ -11,10 +11,12 @@
 #define _LINUX_QUOTAOPS_
 
 #include <linux/smp_lock.h>
-
 #include <linux/fs.h>
 
-#define sb_dqopt(sb) (&(sb)->s_dquot)
+static inline struct quota_info *sb_dqopt(struct super_block *sb)
+{
+	return &sb->s_dquot;
+}
 
 #if defined(CONFIG_QUOTA)
 
@@ -54,24 +56,40 @@ void vfs_dq_drop(struct inode *inode);
 int vfs_dq_transfer(struct inode *inode, struct iattr *iattr);
 int vfs_dq_quota_on_remount(struct super_block *sb);
 
-#define sb_dqinfo(sb, type) (sb_dqopt(sb)->info+(type))
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
@@ -180,10 +198,25 @@ static inline int vfs_dq_off(struct supe
 
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

origin.patch

