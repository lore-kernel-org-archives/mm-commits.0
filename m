From: akpm@linux-foundation.org
Subject: - quota-move-function-macros-from-quotah-to-quotaopsh.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:57:52 -0700
Message-ID: <200807252257.m6PMvqcb003229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756691AbYGYW61 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:58:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, arjenpool@gmail.com, vegard.nossum@gmail.com, mm-commits@vger.kernel.org


The patch titled
     quota: move function-macros from quota.h to quotaops.h
has been removed from the -mm tree.  Its filename was
     quota-move-function-macros-from-quotah-to-quotaopsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: move function-macros from quota.h to quotaops.h
From: Jan Kara <jack@suse.cz>

Move declarations of some macros, which should be in fact functions to
quotaops.h.  This way they can be later converted to inline functions
because we can now use declarations from quota.h.  Also add necessary
includes of quotaops.h to a few files.

[akpm@linux-foundation.org: fix JFS build]
[akpm@linux-foundation.org: fix UFS build]
[vegard.nossum@gmail.com: fix QUOTA=n build]
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Arjen Pool <arjenpool@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c          |    1 +
 fs/jfs/super.c           |    1 +
 fs/quota_v1.c            |    1 +
 fs/quota_v2.c            |    1 +
 fs/reiserfs/super.c      |    1 +
 fs/ufs/super.c           |    1 +
 include/linux/quota.h    |   22 +++-------------------
 include/linux/quotaops.h |   26 ++++++++++++++++++++++++++
 8 files changed, 35 insertions(+), 19 deletions(-)

diff -puN fs/ext2/super.c~quota-move-function-macros-from-quotah-to-quotaopsh fs/ext2/super.c
--- a/fs/ext2/super.c~quota-move-function-macros-from-quotah-to-quotaopsh
+++ a/fs/ext2/super.c
@@ -31,6 +31,7 @@
 #include <linux/seq_file.h>
 #include <linux/mount.h>
 #include <linux/log2.h>
+#include <linux/quotaops.h>
 #include <asm/uaccess.h>
 #include "ext2.h"
 #include "xattr.h"
diff -puN fs/jfs/super.c~quota-move-function-macros-from-quotah-to-quotaopsh fs/jfs/super.c
--- a/fs/jfs/super.c~quota-move-function-macros-from-quotah-to-quotaopsh
+++ a/fs/jfs/super.c
@@ -22,6 +22,7 @@
 #include <linux/parser.h>
 #include <linux/completion.h>
 #include <linux/vfs.h>
+#include <linux/quotaops.h>
 #include <linux/mount.h>
 #include <linux/moduleparam.h>
 #include <linux/kthread.h>
diff -puN fs/quota_v1.c~quota-move-function-macros-from-quotah-to-quotaopsh fs/quota_v1.c
--- a/fs/quota_v1.c~quota-move-function-macros-from-quotah-to-quotaopsh
+++ a/fs/quota_v1.c
@@ -1,6 +1,7 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/quota.h>
+#include <linux/quotaops.h>
 #include <linux/dqblk_v1.h>
 #include <linux/quotaio_v1.h>
 #include <linux/kernel.h>
diff -puN fs/quota_v2.c~quota-move-function-macros-from-quotah-to-quotaopsh fs/quota_v2.c
--- a/fs/quota_v2.c~quota-move-function-macros-from-quotah-to-quotaopsh
+++ a/fs/quota_v2.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/quotaops.h>
 
 #include <asm/byteorder.h>
 
diff -puN fs/reiserfs/super.c~quota-move-function-macros-from-quotah-to-quotaopsh fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~quota-move-function-macros-from-quotah-to-quotaopsh
+++ a/fs/reiserfs/super.c
@@ -22,6 +22,7 @@
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
 #include <linux/exportfs.h>
+#include <linux/quotaops.h>
 #include <linux/vfs.h>
 #include <linux/mnt_namespace.h>
 #include <linux/mount.h>
diff -puN fs/ufs/super.c~quota-move-function-macros-from-quotah-to-quotaopsh fs/ufs/super.c
--- a/fs/ufs/super.c~quota-move-function-macros-from-quotah-to-quotaopsh
+++ a/fs/ufs/super.c
@@ -76,6 +76,7 @@
 
 #include <linux/errno.h>
 #include <linux/fs.h>
+#include <linux/quotaops.h>
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/stat.h>
diff -puN include/linux/quota.h~quota-move-function-macros-from-quotah-to-quotaopsh include/linux/quota.h
--- a/include/linux/quota.h~quota-move-function-macros-from-quotah-to-quotaopsh
+++ a/include/linux/quota.h
@@ -41,9 +41,6 @@
 #define __DQUOT_VERSION__	"dquot_6.5.1"
 #define __DQUOT_NUM_VERSION__	6*10000+5*100+1
 
-typedef __kernel_uid32_t qid_t; /* Type in which we store ids in memory */
-typedef __u64 qsize_t;          /* Type in which we store sizes */
-
 /* Size of blocks in which are counted size limits */
 #define QUOTABLOCK_BITS 10
 #define QUOTABLOCK_SIZE (1 << QUOTABLOCK_BITS)
@@ -172,6 +169,9 @@ enum {
 
 #include <asm/atomic.h>
 
+typedef __kernel_uid32_t qid_t; /* Type in which we store ids in memory */
+typedef __u64 qsize_t;          /* Type in which we store sizes */
+
 extern spinlock_t dq_data_lock;
 
 /* Maximal numbers of writes for quota operation (insert/delete/update)
@@ -225,9 +225,6 @@ struct super_block;
 extern void mark_info_dirty(struct super_block *sb, int type);
 #define info_dirty(info) test_bit(DQF_INFO_DIRTY_B, &(info)->dqi_flags)
 
-#define sb_dqopt(sb) (&(sb)->s_dquot)
-#define sb_dqinfo(sb, type) (sb_dqopt(sb)->info+(type))
-
 struct dqstats {
 	int lookups;
 	int drops;
@@ -335,19 +332,6 @@ struct quota_info {
 	struct quota_format_ops *ops[MAXQUOTAS];	/* Operations for each type */
 };
 
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
-
 int register_quota_format(struct quota_format_type *fmt);
 void unregister_quota_format(struct quota_format_type *fmt);
 
diff -puN include/linux/quotaops.h~quota-move-function-macros-from-quotah-to-quotaopsh include/linux/quotaops.h
--- a/include/linux/quotaops.h~quota-move-function-macros-from-quotah-to-quotaopsh
+++ a/include/linux/quotaops.h
@@ -14,6 +14,8 @@
 
 #include <linux/fs.h>
 
+#define sb_dqopt(sb) (&(sb)->s_dquot)
+
 #if defined(CONFIG_QUOTA)
 
 /*
@@ -52,6 +54,25 @@ void vfs_dq_drop(struct inode *inode);
 int vfs_dq_transfer(struct inode *inode, struct iattr *iattr);
 int vfs_dq_quota_on_remount(struct super_block *sb);
 
+#define sb_dqinfo(sb, type) (sb_dqopt(sb)->info+(type))
+
+/*
+ * Functions for checking status of quota
+ */
+
+#define sb_has_quota_enabled(sb, type) ((type)==USRQUOTA ? \
+	(sb_dqopt(sb)->flags & DQUOT_USR_ENABLED) : (sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED))
+
+#define sb_any_quota_enabled(sb) (sb_has_quota_enabled(sb, USRQUOTA) | \
+				  sb_has_quota_enabled(sb, GRPQUOTA))
+
+#define sb_has_quota_suspended(sb, type) \
+	((type) == USRQUOTA ? (sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED) : \
+			      (sb_dqopt(sb)->flags & DQUOT_GRP_SUSPENDED))
+
+#define sb_any_quota_suspended(sb) (sb_has_quota_suspended(sb, USRQUOTA) | \
+				  sb_has_quota_suspended(sb, GRPQUOTA))
+
 /*
  * Operations supported for diskquotas.
  */
@@ -159,6 +180,11 @@ static inline int vfs_dq_off(struct supe
 
 #else
 
+#define sb_has_quota_enabled(sb, type) 0
+#define sb_any_quota_enabled(sb) 0
+#define sb_has_quota_suspended(sb, type) 0
+#define sb_any_quota_suspended(sb) 0
+
 /*
  * NO-OP when quota not configured.
  */
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch

