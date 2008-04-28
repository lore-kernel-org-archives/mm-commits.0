From: akpm@linux-foundation.org
Subject: - quota-various-style-cleanups.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:56:27 -0700
Message-ID: <200804282156.m3SLuRx9018228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937037AbYD1V4b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:56:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: various style cleanups
has been removed from the -mm tree.  Its filename was
     quota-various-style-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: various style cleanups
From: Jan Kara <jack@suse.cz>

Cleanups in quota code:
  Change __inline__ to inline.
  Change some macros to inline functions.
  Remove vfs_quota_off_mount() macro.
  DQUOT_OFF() should be (0) is CONFIG_QUOTA is disabled.
  Move declaration of mark_dquot_dirty and dirty_dquot from quota.h to dquot.c

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c               |   10 ++++-
 fs/reiserfs/super.c      |    2 -
 include/linux/quota.h    |    5 --
 include/linux/quotaops.h |   71 ++++++++++++++++++++++++++-----------
 4 files changed, 60 insertions(+), 28 deletions(-)

diff -puN fs/dquot.c~quota-various-style-cleanups fs/dquot.c
--- a/fs/dquot.c~quota-various-style-cleanups
+++ a/fs/dquot.c
@@ -289,7 +289,15 @@ static void wait_on_dquot(struct dquot *
 	mutex_unlock(&dquot->dq_lock);
 }
 
-#define mark_dquot_dirty(dquot) ((dquot)->dq_sb->dq_op->mark_dirty(dquot))
+static inline int dquot_dirty(struct dquot *dquot)
+{
+	return test_bit(DQ_MOD_B, &dquot->dq_flags);
+}
+
+static inline int mark_dquot_dirty(struct dquot *dquot)
+{
+	return dquot->dq_sb->dq_op->mark_dirty(dquot);
+}
 
 int dquot_mark_dquot_dirty(struct dquot *dquot)
 {
diff -puN fs/reiserfs/super.c~quota-various-style-cleanups fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~quota-various-style-cleanups
+++ a/fs/reiserfs/super.c
@@ -304,7 +304,7 @@ static int finish_unfinished(struct supe
 	/* Turn quotas off */
 	for (i = 0; i < MAXQUOTAS; i++) {
 		if (sb_dqopt(s)->files[i])
-			vfs_quota_off_mount(s, i);
+			vfs_quota_off(s, i);
 	}
 	if (ms_active_set)
 		/* Restore the flag back */
diff -puN include/linux/quota.h~quota-various-style-cleanups include/linux/quota.h
--- a/include/linux/quota.h~quota-various-style-cleanups
+++ a/include/linux/quota.h
@@ -331,11 +331,6 @@ struct quota_info {
 	struct quota_format_ops *ops[MAXQUOTAS];	/* Operations for each type */
 };
 
-/* Inline would be better but we need to dereference super_block which is not defined yet */
-int mark_dquot_dirty(struct dquot *dquot);
-
-#define dquot_dirty(dquot) test_bit(DQ_MOD_B, &(dquot)->dq_flags)
-
 #define sb_has_quota_enabled(sb, type) ((type)==USRQUOTA ? \
 	(sb_dqopt(sb)->flags & DQUOT_USR_ENABLED) : (sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED))
 
diff -puN include/linux/quotaops.h~quota-various-style-cleanups include/linux/quotaops.h
--- a/include/linux/quotaops.h~quota-various-style-cleanups
+++ a/include/linux/quotaops.h
@@ -41,7 +41,6 @@ extern int vfs_quota_on(struct super_blo
 extern int vfs_quota_on_mount(struct super_block *sb, char *qf_name,
 		int format_id, int type);
 extern int vfs_quota_off(struct super_block *sb, int type);
-#define vfs_quota_off_mount(sb, type) vfs_quota_off(sb, type)
 extern int vfs_quota_sync(struct super_block *sb, int type);
 extern int vfs_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
 extern int vfs_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
@@ -59,7 +58,7 @@ extern struct quotactl_ops vfs_quotactl_
 
 /* It is better to call this function outside of any transaction as it might
  * need a lot of space in journal for dquot structure allocation. */
-static __inline__ void DQUOT_INIT(struct inode *inode)
+static inline void DQUOT_INIT(struct inode *inode)
 {
 	BUG_ON(!inode->i_sb);
 	if (sb_any_quota_enabled(inode->i_sb) && !IS_NOQUOTA(inode))
@@ -67,7 +66,7 @@ static __inline__ void DQUOT_INIT(struct
 }
 
 /* The same as with DQUOT_INIT */
-static __inline__ void DQUOT_DROP(struct inode *inode)
+static inline void DQUOT_DROP(struct inode *inode)
 {
 	/* Here we can get arbitrary inode from clear_inode() so we have
 	 * to be careful. OTOH we don't need locking as quota operations
@@ -90,7 +89,7 @@ static __inline__ void DQUOT_DROP(struct
 
 /* The following allocation/freeing/transfer functions *must* be called inside
  * a transaction (deadlocks possible otherwise) */
-static __inline__ int DQUOT_PREALLOC_SPACE_NODIRTY(struct inode *inode, qsize_t nr)
+static inline int DQUOT_PREALLOC_SPACE_NODIRTY(struct inode *inode, qsize_t nr)
 {
 	if (sb_any_quota_enabled(inode->i_sb)) {
 		/* Used space is updated in alloc_space() */
@@ -102,7 +101,7 @@ static __inline__ int DQUOT_PREALLOC_SPA
 	return 0;
 }
 
-static __inline__ int DQUOT_PREALLOC_SPACE(struct inode *inode, qsize_t nr)
+static inline int DQUOT_PREALLOC_SPACE(struct inode *inode, qsize_t nr)
 {
 	int ret;
         if (!(ret =  DQUOT_PREALLOC_SPACE_NODIRTY(inode, nr)))
@@ -110,7 +109,7 @@ static __inline__ int DQUOT_PREALLOC_SPA
 	return ret;
 }
 
-static __inline__ int DQUOT_ALLOC_SPACE_NODIRTY(struct inode *inode, qsize_t nr)
+static inline int DQUOT_ALLOC_SPACE_NODIRTY(struct inode *inode, qsize_t nr)
 {
 	if (sb_any_quota_enabled(inode->i_sb)) {
 		/* Used space is updated in alloc_space() */
@@ -122,7 +121,7 @@ static __inline__ int DQUOT_ALLOC_SPACE_
 	return 0;
 }
 
-static __inline__ int DQUOT_ALLOC_SPACE(struct inode *inode, qsize_t nr)
+static inline int DQUOT_ALLOC_SPACE(struct inode *inode, qsize_t nr)
 {
 	int ret;
 	if (!(ret = DQUOT_ALLOC_SPACE_NODIRTY(inode, nr)))
@@ -130,7 +129,7 @@ static __inline__ int DQUOT_ALLOC_SPACE(
 	return ret;
 }
 
-static __inline__ int DQUOT_ALLOC_INODE(struct inode *inode)
+static inline int DQUOT_ALLOC_INODE(struct inode *inode)
 {
 	if (sb_any_quota_enabled(inode->i_sb)) {
 		DQUOT_INIT(inode);
@@ -140,7 +139,7 @@ static __inline__ int DQUOT_ALLOC_INODE(
 	return 0;
 }
 
-static __inline__ void DQUOT_FREE_SPACE_NODIRTY(struct inode *inode, qsize_t nr)
+static inline void DQUOT_FREE_SPACE_NODIRTY(struct inode *inode, qsize_t nr)
 {
 	if (sb_any_quota_enabled(inode->i_sb))
 		inode->i_sb->dq_op->free_space(inode, nr);
@@ -148,19 +147,19 @@ static __inline__ void DQUOT_FREE_SPACE_
 		inode_sub_bytes(inode, nr);
 }
 
-static __inline__ void DQUOT_FREE_SPACE(struct inode *inode, qsize_t nr)
+static inline void DQUOT_FREE_SPACE(struct inode *inode, qsize_t nr)
 {
 	DQUOT_FREE_SPACE_NODIRTY(inode, nr);
 	mark_inode_dirty(inode);
 }
 
-static __inline__ void DQUOT_FREE_INODE(struct inode *inode)
+static inline void DQUOT_FREE_INODE(struct inode *inode)
 {
 	if (sb_any_quota_enabled(inode->i_sb))
 		inode->i_sb->dq_op->free_inode(inode, 1);
 }
 
-static __inline__ int DQUOT_TRANSFER(struct inode *inode, struct iattr *iattr)
+static inline int DQUOT_TRANSFER(struct inode *inode, struct iattr *iattr)
 {
 	if (sb_any_quota_enabled(inode->i_sb) && !IS_NOQUOTA(inode)) {
 		DQUOT_INIT(inode);
@@ -171,9 +170,12 @@ static __inline__ int DQUOT_TRANSFER(str
 }
 
 /* The following two functions cannot be called inside a transaction */
-#define DQUOT_SYNC(sb)	sync_dquots(sb, -1)
+static inline void DQUOT_SYNC(struct super_block *sb)
+{
+	sync_dquots(sb, -1);
+}
 
-static __inline__ int DQUOT_OFF(struct super_block *sb)
+static inline int DQUOT_OFF(struct super_block *sb)
 {
 	int ret = -ENOSYS;
 
@@ -194,7 +196,7 @@ static __inline__ int DQUOT_OFF(struct s
 #define DQUOT_ALLOC_INODE(inode)		(0)
 #define DQUOT_FREE_INODE(inode)			do { } while(0)
 #define DQUOT_SYNC(sb)				do { } while(0)
-#define DQUOT_OFF(sb)				do { } while(0)
+#define DQUOT_OFF(sb)				(0)
 #define DQUOT_TRANSFER(inode, iattr)		(0)
 static inline int DQUOT_PREALLOC_SPACE_NODIRTY(struct inode *inode, qsize_t nr)
 {
@@ -235,11 +237,38 @@ static inline void DQUOT_FREE_SPACE(stru
 
 #endif /* CONFIG_QUOTA */
 
-#define DQUOT_PREALLOC_BLOCK_NODIRTY(inode, nr)	DQUOT_PREALLOC_SPACE_NODIRTY(inode, ((qsize_t)(nr)) << (inode)->i_sb->s_blocksize_bits)
-#define DQUOT_PREALLOC_BLOCK(inode, nr)	DQUOT_PREALLOC_SPACE(inode, ((qsize_t)(nr)) << (inode)->i_sb->s_blocksize_bits)
-#define DQUOT_ALLOC_BLOCK_NODIRTY(inode, nr) DQUOT_ALLOC_SPACE_NODIRTY(inode, ((qsize_t)(nr)) << (inode)->i_sb->s_blocksize_bits)
-#define DQUOT_ALLOC_BLOCK(inode, nr) DQUOT_ALLOC_SPACE(inode, ((qsize_t)(nr)) << (inode)->i_sb->s_blocksize_bits)
-#define DQUOT_FREE_BLOCK_NODIRTY(inode, nr) DQUOT_FREE_SPACE_NODIRTY(inode, ((qsize_t)(nr)) << (inode)->i_sb->s_blocksize_bits)
-#define DQUOT_FREE_BLOCK(inode, nr) DQUOT_FREE_SPACE(inode, ((qsize_t)(nr)) << (inode)->i_sb->s_blocksize_bits)
+static inline int DQUOT_PREALLOC_BLOCK_NODIRTY(struct inode *inode, qsize_t nr)
+{
+	return DQUOT_PREALLOC_SPACE_NODIRTY(inode,
+			nr << inode->i_sb->s_blocksize_bits);
+}
+
+static inline int DQUOT_PREALLOC_BLOCK(struct inode *inode, qsize_t nr)
+{
+	return DQUOT_PREALLOC_SPACE(inode,
+			nr << inode->i_sb->s_blocksize_bits);
+}
+
+static inline int DQUOT_ALLOC_BLOCK_NODIRTY(struct inode *inode, qsize_t nr)
+{
+	return DQUOT_ALLOC_SPACE_NODIRTY(inode,
+			nr << inode->i_sb->s_blocksize_bits);
+}
+
+static inline int DQUOT_ALLOC_BLOCK(struct inode *inode, qsize_t nr)
+{
+	return DQUOT_ALLOC_SPACE(inode,
+			nr << inode->i_sb->s_blocksize_bits);
+}
+
+static inline void DQUOT_FREE_BLOCK_NODIRTY(struct inode *inode, qsize_t nr)
+{
+	DQUOT_FREE_SPACE_NODIRTY(inode, nr << inode->i_sb->s_blocksize_bits);
+}
+
+static inline void DQUOT_FREE_BLOCK(struct inode *inode, qsize_t nr)
+{
+	DQUOT_FREE_SPACE(inode, nr << inode->i_sb->s_blocksize_bits);
+}
 
 #endif /* _LINUX_QUOTAOPS_ */
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
vfs-fix-lock-inversion-in-drop_pagecache_sb.patch
vfs-skip-inodes-without-pages-to-free-in-drop_pagecache_sb.patch
ext4-fix-update-of-mtime-and-ctime-on-rename.patch
ext4-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch
ext4-fix-mount-messages-when-quota-disabled.patch
quota-le_add_cpu-conversion.patch
isofs-use-get-put_unaligned_-helpers.patch

