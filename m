From: akpm@linux-foundation.org
Subject: - quota-rename-quota-functions-from-upper-case-make-bigger-ones-non-inline.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:57:48 -0700
Message-ID: <200807252257.m6PMvmu4003220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756567AbYGYW6W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:58:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: rename quota functions from upper case, make bigger ones non-inline
has been removed from the -mm tree.  Its filename was
     quota-rename-quota-functions-from-upper-case-make-bigger-ones-non-inline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: rename quota functions from upper case, make bigger ones non-inline
From: Jan Kara <jack@suse.cz>

Cleanup quotaops.h: Rename functions from uppercase to lowercase (and
define backward compatibility macros), move larger functions to dquot.c
and make them non-inline.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c               |   53 ++++++++
 include/linux/quotaops.h |  220 +++++++++++++++++--------------------
 2 files changed, 157 insertions(+), 116 deletions(-)

diff -puN fs/dquot.c~quota-rename-quota-functions-from-upper-case-make-bigger-ones-non-inline fs/dquot.c
--- a/fs/dquot.c~quota-rename-quota-functions-from-upper-case-make-bigger-ones-non-inline
+++ a/fs/dquot.c
@@ -1153,6 +1153,28 @@ int dquot_drop(struct inode *inode)
 	return 0;
 }
 
+/* Wrapper to remove references to quota structures from inode */
+void vfs_dq_drop(struct inode *inode)
+{
+	/* Here we can get arbitrary inode from clear_inode() so we have
+	 * to be careful. OTOH we don't need locking as quota operations
+	 * are allowed to change only at mount time */
+	if (!IS_NOQUOTA(inode) && inode->i_sb && inode->i_sb->dq_op
+	    && inode->i_sb->dq_op->drop) {
+		int cnt;
+		/* Test before calling to rule out calls from proc and such
+                 * where we are not allowed to block. Note that this is
+		 * actually reliable test even without the lock - the caller
+		 * must assure that nobody can come after the DQUOT_DROP and
+		 * add quota pointers back anyway */
+		for (cnt = 0; cnt < MAXQUOTAS; cnt++)
+			if (inode->i_dquot[cnt] != NODQUOT)
+				break;
+		if (cnt < MAXQUOTAS)
+			inode->i_sb->dq_op->drop(inode);
+	}
+}
+
 /*
  * Following four functions update i_blocks+i_bytes fields and
  * quota information (together with appropriate checks)
@@ -1426,6 +1448,18 @@ warn_put_all:
 	return ret;
 }
 
+/* Wrapper for transferring ownership of an inode */
+int vfs_dq_transfer(struct inode *inode, struct iattr *iattr)
+{
+	if (sb_any_quota_enabled(inode->i_sb) && !IS_NOQUOTA(inode)) {
+		vfs_dq_init(inode);
+		if (inode->i_sb->dq_op->transfer(inode, iattr) == NO_QUOTA)
+			return 1;
+	}
+	return 0;
+}
+
+
 /*
  * Write info of quota file to disk
  */
@@ -1766,6 +1800,22 @@ out:
 	return error;
 }
 
+/* Wrapper to turn on quotas when remounting rw */
+int vfs_dq_quota_on_remount(struct super_block *sb)
+{
+	int cnt;
+	int ret = 0, err;
+
+	if (!sb->s_qcop || !sb->s_qcop->quota_on)
+		return -ENOSYS;
+	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
+		err = sb->s_qcop->quota_on(sb, cnt, 0, NULL, 1);
+		if (err < 0 && !ret)
+			ret = err;
+	}
+	return ret;
+}
+
 /* Generic routine for getting common part of quota structure */
 static void do_get_dqblk(struct dquot *dquot, struct if_dqblk *di)
 {
@@ -2101,8 +2151,11 @@ EXPORT_SYMBOL(dquot_release);
 EXPORT_SYMBOL(dquot_mark_dquot_dirty);
 EXPORT_SYMBOL(dquot_initialize);
 EXPORT_SYMBOL(dquot_drop);
+EXPORT_SYMBOL(vfs_dq_drop);
 EXPORT_SYMBOL(dquot_alloc_space);
 EXPORT_SYMBOL(dquot_alloc_inode);
 EXPORT_SYMBOL(dquot_free_space);
 EXPORT_SYMBOL(dquot_free_inode);
 EXPORT_SYMBOL(dquot_transfer);
+EXPORT_SYMBOL(vfs_dq_transfer);
+EXPORT_SYMBOL(vfs_dq_quota_on_remount);
diff -puN include/linux/quotaops.h~quota-rename-quota-functions-from-upper-case-make-bigger-ones-non-inline include/linux/quotaops.h
--- a/include/linux/quotaops.h~quota-rename-quota-functions-from-upper-case-make-bigger-ones-non-inline
+++ a/include/linux/quotaops.h
@@ -19,34 +19,38 @@
 /*
  * declaration of quota_function calls in kernel.
  */
-extern void sync_dquots(struct super_block *sb, int type);
+void sync_dquots(struct super_block *sb, int type);
 
-extern int dquot_initialize(struct inode *inode, int type);
-extern int dquot_drop(struct inode *inode);
+int dquot_initialize(struct inode *inode, int type);
+int dquot_drop(struct inode *inode);
 
-extern int dquot_alloc_space(struct inode *inode, qsize_t number, int prealloc);
-extern int dquot_alloc_inode(const struct inode *inode, unsigned long number);
+int dquot_alloc_space(struct inode *inode, qsize_t number, int prealloc);
+int dquot_alloc_inode(const struct inode *inode, unsigned long number);
 
-extern int dquot_free_space(struct inode *inode, qsize_t number);
-extern int dquot_free_inode(const struct inode *inode, unsigned long number);
-
-extern int dquot_transfer(struct inode *inode, struct iattr *iattr);
-extern int dquot_commit(struct dquot *dquot);
-extern int dquot_acquire(struct dquot *dquot);
-extern int dquot_release(struct dquot *dquot);
-extern int dquot_commit_info(struct super_block *sb, int type);
-extern int dquot_mark_dquot_dirty(struct dquot *dquot);
-
-extern int vfs_quota_on(struct super_block *sb, int type, int format_id,
-		char *path, int remount);
-extern int vfs_quota_on_mount(struct super_block *sb, char *qf_name,
-		int format_id, int type);
-extern int vfs_quota_off(struct super_block *sb, int type, int remount);
-extern int vfs_quota_sync(struct super_block *sb, int type);
-extern int vfs_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
-extern int vfs_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
-extern int vfs_get_dqblk(struct super_block *sb, int type, qid_t id, struct if_dqblk *di);
-extern int vfs_set_dqblk(struct super_block *sb, int type, qid_t id, struct if_dqblk *di);
+int dquot_free_space(struct inode *inode, qsize_t number);
+int dquot_free_inode(const struct inode *inode, unsigned long number);
+
+int dquot_transfer(struct inode *inode, struct iattr *iattr);
+int dquot_commit(struct dquot *dquot);
+int dquot_acquire(struct dquot *dquot);
+int dquot_release(struct dquot *dquot);
+int dquot_commit_info(struct super_block *sb, int type);
+int dquot_mark_dquot_dirty(struct dquot *dquot);
+
+int vfs_quota_on(struct super_block *sb, int type, int format_id,
+ 	char *path, int remount);
+int vfs_quota_on_mount(struct super_block *sb, char *qf_name,
+ 	int format_id, int type);
+int vfs_quota_off(struct super_block *sb, int type, int remount);
+int vfs_quota_sync(struct super_block *sb, int type);
+int vfs_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
+int vfs_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
+int vfs_get_dqblk(struct super_block *sb, int type, qid_t id, struct if_dqblk *di);
+int vfs_set_dqblk(struct super_block *sb, int type, qid_t id, struct if_dqblk *di);
+
+void vfs_dq_drop(struct inode *inode);
+int vfs_dq_transfer(struct inode *inode, struct iattr *iattr);
+int vfs_dq_quota_on_remount(struct super_block *sb);
 
 /*
  * Operations supported for diskquotas.
@@ -59,38 +63,16 @@ extern struct quotactl_ops vfs_quotactl_
 
 /* It is better to call this function outside of any transaction as it might
  * need a lot of space in journal for dquot structure allocation. */
-static inline void DQUOT_INIT(struct inode *inode)
+static inline void vfs_dq_init(struct inode *inode)
 {
 	BUG_ON(!inode->i_sb);
 	if (sb_any_quota_enabled(inode->i_sb) && !IS_NOQUOTA(inode))
 		inode->i_sb->dq_op->initialize(inode, -1);
 }
 
-/* The same as with DQUOT_INIT */
-static inline void DQUOT_DROP(struct inode *inode)
-{
-	/* Here we can get arbitrary inode from clear_inode() so we have
-	 * to be careful. OTOH we don't need locking as quota operations
-	 * are allowed to change only at mount time */
-	if (!IS_NOQUOTA(inode) && inode->i_sb && inode->i_sb->dq_op
-	    && inode->i_sb->dq_op->drop) {
-		int cnt;
-		/* Test before calling to rule out calls from proc and such
-                 * where we are not allowed to block. Note that this is
-		 * actually reliable test even without the lock - the caller
-		 * must assure that nobody can come after the DQUOT_DROP and
-		 * add quota pointers back anyway */
-		for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-			if (inode->i_dquot[cnt] != NODQUOT)
-				break;
-		if (cnt < MAXQUOTAS)
-			inode->i_sb->dq_op->drop(inode);
-	}
-}
-
 /* The following allocation/freeing/transfer functions *must* be called inside
  * a transaction (deadlocks possible otherwise) */
-static inline int DQUOT_PREALLOC_SPACE_NODIRTY(struct inode *inode, qsize_t nr)
+static inline int vfs_dq_prealloc_space_nodirty(struct inode *inode, qsize_t nr)
 {
 	if (sb_any_quota_enabled(inode->i_sb)) {
 		/* Used space is updated in alloc_space() */
@@ -102,15 +84,15 @@ static inline int DQUOT_PREALLOC_SPACE_N
 	return 0;
 }
 
-static inline int DQUOT_PREALLOC_SPACE(struct inode *inode, qsize_t nr)
+static inline int vfs_dq_prealloc_space(struct inode *inode, qsize_t nr)
 {
 	int ret;
-        if (!(ret =  DQUOT_PREALLOC_SPACE_NODIRTY(inode, nr)))
+        if (!(ret =  vfs_dq_prealloc_space_nodirty(inode, nr)))
 		mark_inode_dirty(inode);
 	return ret;
 }
 
-static inline int DQUOT_ALLOC_SPACE_NODIRTY(struct inode *inode, qsize_t nr)
+static inline int vfs_dq_alloc_space_nodirty(struct inode *inode, qsize_t nr)
 {
 	if (sb_any_quota_enabled(inode->i_sb)) {
 		/* Used space is updated in alloc_space() */
@@ -122,25 +104,25 @@ static inline int DQUOT_ALLOC_SPACE_NODI
 	return 0;
 }
 
-static inline int DQUOT_ALLOC_SPACE(struct inode *inode, qsize_t nr)
+static inline int vfs_dq_alloc_space(struct inode *inode, qsize_t nr)
 {
 	int ret;
-	if (!(ret = DQUOT_ALLOC_SPACE_NODIRTY(inode, nr)))
+	if (!(ret = vfs_dq_alloc_space_nodirty(inode, nr)))
 		mark_inode_dirty(inode);
 	return ret;
 }
 
-static inline int DQUOT_ALLOC_INODE(struct inode *inode)
+static inline int vfs_dq_alloc_inode(struct inode *inode)
 {
 	if (sb_any_quota_enabled(inode->i_sb)) {
-		DQUOT_INIT(inode);
+		vfs_dq_init(inode);
 		if (inode->i_sb->dq_op->alloc_inode(inode, 1) == NO_QUOTA)
 			return 1;
 	}
 	return 0;
 }
 
-static inline void DQUOT_FREE_SPACE_NODIRTY(struct inode *inode, qsize_t nr)
+static inline void vfs_dq_free_space_nodirty(struct inode *inode, qsize_t nr)
 {
 	if (sb_any_quota_enabled(inode->i_sb))
 		inode->i_sb->dq_op->free_space(inode, nr);
@@ -148,35 +130,25 @@ static inline void DQUOT_FREE_SPACE_NODI
 		inode_sub_bytes(inode, nr);
 }
 
-static inline void DQUOT_FREE_SPACE(struct inode *inode, qsize_t nr)
+static inline void vfs_dq_free_space(struct inode *inode, qsize_t nr)
 {
-	DQUOT_FREE_SPACE_NODIRTY(inode, nr);
+	vfs_dq_free_space_nodirty(inode, nr);
 	mark_inode_dirty(inode);
 }
 
-static inline void DQUOT_FREE_INODE(struct inode *inode)
+static inline void vfs_dq_free_inode(struct inode *inode)
 {
 	if (sb_any_quota_enabled(inode->i_sb))
 		inode->i_sb->dq_op->free_inode(inode, 1);
 }
 
-static inline int DQUOT_TRANSFER(struct inode *inode, struct iattr *iattr)
-{
-	if (sb_any_quota_enabled(inode->i_sb) && !IS_NOQUOTA(inode)) {
-		DQUOT_INIT(inode);
-		if (inode->i_sb->dq_op->transfer(inode, iattr) == NO_QUOTA)
-			return 1;
-	}
-	return 0;
-}
-
 /* The following two functions cannot be called inside a transaction */
-static inline void DQUOT_SYNC(struct super_block *sb)
+static inline void vfs_dq_sync(struct super_block *sb)
 {
 	sync_dquots(sb, -1);
 }
 
-static inline int DQUOT_OFF(struct super_block *sb, int remount)
+static inline int vfs_dq_off(struct super_block *sb, int remount)
 {
 	int ret = -ENOSYS;
 
@@ -185,21 +157,6 @@ static inline int DQUOT_OFF(struct super
 	return ret;
 }
 
-static inline int DQUOT_ON_REMOUNT(struct super_block *sb)
-{
-	int cnt;
-	int ret = 0, err;
-
-	if (!sb->s_qcop || !sb->s_qcop->quota_on)
-		return -ENOSYS;
-	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		err = sb->s_qcop->quota_on(sb, cnt, 0, NULL, 1);
-		if (err < 0 && !ret)
-			ret = err;
-	}
-	return ret;
-}
-
 #else
 
 /*
@@ -208,113 +165,144 @@ static inline int DQUOT_ON_REMOUNT(struc
 #define sb_dquot_ops				(NULL)
 #define sb_quotactl_ops				(NULL)
 
-static inline void DQUOT_INIT(struct inode *inode)
+static inline void vfs_dq_init(struct inode *inode)
 {
 }
 
-static inline void DQUOT_DROP(struct inode *inode)
+static inline void vfs_dq_drop(struct inode *inode)
 {
 }
 
-static inline int DQUOT_ALLOC_INODE(struct inode *inode)
+static inline int vfs_dq_alloc_inode(struct inode *inode)
 {
 	return 0;
 }
 
-static inline void DQUOT_FREE_INODE(struct inode *inode)
+static inline void vfs_dq_free_inode(struct inode *inode)
 {
 }
 
-static inline void DQUOT_SYNC(struct super_block *sb)
+static inline void vfs_dq_sync(struct super_block *sb)
 {
 }
 
-static inline int DQUOT_OFF(struct super_block *sb, int remount)
+static inline int vfs_dq_off(struct super_block *sb, int remount)
 {
 	return 0;
 }
 
-static inline int DQUOT_ON_REMOUNT(struct super_block *sb)
+static inline int vfs_dq_quota_on_remount(struct super_block *sb)
 {
 	return 0;
 }
 
-static inline int DQUOT_TRANSFER(struct inode *inode, struct iattr *iattr)
+static inline int vfs_dq_transfer(struct inode *inode, struct iattr *iattr)
 {
 	return 0;
 }
 
-static inline int DQUOT_PREALLOC_SPACE_NODIRTY(struct inode *inode, qsize_t nr)
+static inline int vfs_dq_prealloc_space_nodirty(struct inode *inode, qsize_t nr)
 {
 	inode_add_bytes(inode, nr);
 	return 0;
 }
 
-static inline int DQUOT_PREALLOC_SPACE(struct inode *inode, qsize_t nr)
+static inline int vfs_dq_prealloc_space(struct inode *inode, qsize_t nr)
 {
-	DQUOT_PREALLOC_SPACE_NODIRTY(inode, nr);
+	vfs_dq_prealloc_space_nodirty(inode, nr);
 	mark_inode_dirty(inode);
 	return 0;
 }
 
-static inline int DQUOT_ALLOC_SPACE_NODIRTY(struct inode *inode, qsize_t nr)
+static inline int vfs_dq_alloc_space_nodirty(struct inode *inode, qsize_t nr)
 {
 	inode_add_bytes(inode, nr);
 	return 0;
 }
 
-static inline int DQUOT_ALLOC_SPACE(struct inode *inode, qsize_t nr)
+static inline int vfs_dq_alloc_space(struct inode *inode, qsize_t nr)
 {
-	DQUOT_ALLOC_SPACE_NODIRTY(inode, nr);
+	vfs_dq_alloc_space_nodirty(inode, nr);
 	mark_inode_dirty(inode);
 	return 0;
 }
 
-static inline void DQUOT_FREE_SPACE_NODIRTY(struct inode *inode, qsize_t nr)
+static inline void vfs_dq_free_space_nodirty(struct inode *inode, qsize_t nr)
 {
 	inode_sub_bytes(inode, nr);
 }
 
-static inline void DQUOT_FREE_SPACE(struct inode *inode, qsize_t nr)
+static inline void vfs_dq_free_space(struct inode *inode, qsize_t nr)
 {
-	DQUOT_FREE_SPACE_NODIRTY(inode, nr);
+	vfs_dq_free_space_nodirty(inode, nr);
 	mark_inode_dirty(inode);
 }	
 
 #endif /* CONFIG_QUOTA */
 
-static inline int DQUOT_PREALLOC_BLOCK_NODIRTY(struct inode *inode, qsize_t nr)
+static inline int vfs_dq_prealloc_block_nodirty(struct inode *inode, qsize_t nr)
 {
-	return DQUOT_PREALLOC_SPACE_NODIRTY(inode,
+	return vfs_dq_prealloc_space_nodirty(inode,
 			nr << inode->i_sb->s_blocksize_bits);
 }
 
-static inline int DQUOT_PREALLOC_BLOCK(struct inode *inode, qsize_t nr)
+static inline int vfs_dq_prealloc_block(struct inode *inode, qsize_t nr)
 {
-	return DQUOT_PREALLOC_SPACE(inode,
+	return vfs_dq_prealloc_space(inode,
 			nr << inode->i_sb->s_blocksize_bits);
 }
 
-static inline int DQUOT_ALLOC_BLOCK_NODIRTY(struct inode *inode, qsize_t nr)
+static inline int vfs_dq_alloc_block_nodirty(struct inode *inode, qsize_t nr)
 {
-	return DQUOT_ALLOC_SPACE_NODIRTY(inode,
+ 	return vfs_dq_alloc_space_nodirty(inode,
 			nr << inode->i_sb->s_blocksize_bits);
 }
 
-static inline int DQUOT_ALLOC_BLOCK(struct inode *inode, qsize_t nr)
+static inline int vfs_dq_alloc_block(struct inode *inode, qsize_t nr)
 {
-	return DQUOT_ALLOC_SPACE(inode,
+	return vfs_dq_alloc_space(inode,
 			nr << inode->i_sb->s_blocksize_bits);
 }
 
-static inline void DQUOT_FREE_BLOCK_NODIRTY(struct inode *inode, qsize_t nr)
+static inline void vfs_dq_free_block_nodirty(struct inode *inode, qsize_t nr)
 {
-	DQUOT_FREE_SPACE_NODIRTY(inode, nr << inode->i_sb->s_blocksize_bits);
+	vfs_dq_free_space_nodirty(inode, nr << inode->i_sb->s_blocksize_bits);
 }
 
-static inline void DQUOT_FREE_BLOCK(struct inode *inode, qsize_t nr)
+static inline void vfs_dq_free_block(struct inode *inode, qsize_t nr)
 {
-	DQUOT_FREE_SPACE(inode, nr << inode->i_sb->s_blocksize_bits);
+	vfs_dq_free_space(inode, nr << inode->i_sb->s_blocksize_bits);
 }
 
+/*
+ * Define uppercase equivalents for compatibility with old function names
+ * Can go away when we think all users have been converted (15/04/2008)
+ */
+#define DQUOT_INIT(inode) vfs_dq_init(inode)
+#define DQUOT_DROP(inode) vfs_dq_drop(inode)
+#define DQUOT_PREALLOC_SPACE_NODIRTY(inode, nr) \
+				vfs_dq_prealloc_space_nodirty(inode, nr)
+#define DQUOT_PREALLOC_SPACE(inode, nr) vfs_dq_prealloc_space(inode, nr)
+#define DQUOT_ALLOC_SPACE_NODIRTY(inode, nr) \
+				vfs_dq_alloc_space_nodirty(inode, nr)
+#define DQUOT_ALLOC_SPACE(inode, nr) vfs_dq_alloc_space(inode, nr)
+#define DQUOT_PREALLOC_BLOCK_NODIRTY(inode, nr) \
+				vfs_dq_prealloc_block_nodirty(inode, nr)
+#define DQUOT_PREALLOC_BLOCK(inode, nr) vfs_dq_prealloc_block(inode, nr)
+#define DQUOT_ALLOC_BLOCK_NODIRTY(inode, nr) \
+				vfs_dq_alloc_block_nodirty(inode, nr)
+#define DQUOT_ALLOC_BLOCK(inode, nr) vfs_dq_alloc_block(inode, nr)
+#define DQUOT_ALLOC_INODE(inode) vfs_dq_alloc_inode(inode)
+#define DQUOT_FREE_SPACE_NODIRTY(inode, nr) \
+				vfs_dq_free_space_nodirty(inode, nr)
+#define DQUOT_FREE_SPACE(inode, nr) vfs_dq_free_space(inode, nr)
+#define DQUOT_FREE_BLOCK_NODIRTY(inode, nr) \
+				vfs_dq_free_block_nodirty(inode, nr)
+#define DQUOT_FREE_BLOCK(inode, nr) vfs_dq_free_block(inode, nr)
+#define DQUOT_FREE_INODE(inode) vfs_dq_free_inode(inode)
+#define DQUOT_TRANSFER(inode, iattr) vfs_dq_transfer(inode, iattr)
+#define DQUOT_SYNC(sb) vfs_dq_sync(sb)
+#define DQUOT_OFF(sb, remount) vfs_dq_off(sb, remount)
+#define DQUOT_ON_REMOUNT(sb) vfs_dq_quota_on_remount(sb)
+
 #endif /* _LINUX_QUOTAOPS_ */
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch

