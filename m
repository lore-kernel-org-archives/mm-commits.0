From: akpm@linux-foundation.org
Subject: - quota-quota-core-changes-for-quotaon-on-remount.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:56:29 -0700
Message-ID: <200804282156.m3SLuTqt018231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937100AbYD1V4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:56:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: quota core changes for quotaon on remount
has been removed from the -mm tree.  Its filename was
     quota-quota-core-changes-for-quotaon-on-remount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: quota core changes for quotaon on remount
From: Jan Kara <jack@suse.cz>

Currently, we just turn quotas off on remount of filesystem to read-only
state.  The patch below adds necessary framework so that we can turn quotas
off on remount RO but we are able to automatically reenable them again when
filesystem is remounted to RW state.  All we need to do is to keep references
to inodes of quota files when remounting RO and using these references to
reenable quotas when remounting RW.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c               |   77 ++++++++++++++++++++++++++++++++-----
 fs/quota.c               |    5 --
 fs/super.c               |   10 +++-
 include/linux/quota.h    |   14 +++++-
 include/linux/quotaops.h |   29 +++++++++++--
 5 files changed, 113 insertions(+), 22 deletions(-)

diff -puN fs/dquot.c~quota-quota-core-changes-for-quotaon-on-remount fs/dquot.c
--- a/fs/dquot.c~quota-quota-core-changes-for-quotaon-on-remount
+++ a/fs/dquot.c
@@ -1449,31 +1449,43 @@ static inline void set_enable_flags(stru
 	switch (type) {
 		case USRQUOTA:
 			dqopt->flags |= DQUOT_USR_ENABLED;
+			dqopt->flags &= ~DQUOT_USR_SUSPENDED;
 			break;
 		case GRPQUOTA:
 			dqopt->flags |= DQUOT_GRP_ENABLED;
+			dqopt->flags &= ~DQUOT_GRP_SUSPENDED;
 			break;
 	}
 }
 
-static inline void reset_enable_flags(struct quota_info *dqopt, int type)
+static inline void reset_enable_flags(struct quota_info *dqopt, int type,
+				      int remount)
 {
 	switch (type) {
 		case USRQUOTA:
 			dqopt->flags &= ~DQUOT_USR_ENABLED;
+			if (remount)
+				dqopt->flags |= DQUOT_USR_SUSPENDED;
+			else
+				dqopt->flags &= ~DQUOT_USR_SUSPENDED;
 			break;
 		case GRPQUOTA:
 			dqopt->flags &= ~DQUOT_GRP_ENABLED;
+			if (remount)
+				dqopt->flags |= DQUOT_GRP_SUSPENDED;
+			else
+				dqopt->flags &= ~DQUOT_GRP_SUSPENDED;
 			break;
 	}
 }
 
+
 /*
  * Turn quota off on a device. type == -1 ==> quotaoff for all types (umount)
  */
-int vfs_quota_off(struct super_block *sb, int type)
+int vfs_quota_off(struct super_block *sb, int type, int remount)
 {
-	int cnt;
+	int cnt, ret = 0;
 	struct quota_info *dqopt = sb_dqopt(sb);
 	struct inode *toputinode[MAXQUOTAS];
 
@@ -1483,9 +1495,17 @@ int vfs_quota_off(struct super_block *sb
 		toputinode[cnt] = NULL;
 		if (type != -1 && cnt != type)
 			continue;
+		/* If we keep inodes of quota files after remount and quotaoff
+		 * is called, drop kept inodes. */
+		if (!remount && sb_has_quota_suspended(sb, cnt)) {
+			iput(dqopt->files[cnt]);
+			dqopt->files[cnt] = NULL;
+			reset_enable_flags(dqopt, cnt, 0);
+			continue;
+		}
 		if (!sb_has_quota_enabled(sb, cnt))
 			continue;
-		reset_enable_flags(dqopt, cnt);
+		reset_enable_flags(dqopt, cnt, remount);
 
 		/* Note: these are blocking operations */
 		drop_dquot_ref(sb, cnt);
@@ -1501,7 +1521,8 @@ int vfs_quota_off(struct super_block *sb
 		put_quota_format(dqopt->info[cnt].dqi_format);
 
 		toputinode[cnt] = dqopt->files[cnt];
-		dqopt->files[cnt] = NULL;
+		if (!remount)
+			dqopt->files[cnt] = NULL;
 		dqopt->info[cnt].dqi_flags = 0;
 		dqopt->info[cnt].dqi_igrace = 0;
 		dqopt->info[cnt].dqi_bgrace = 0;
@@ -1531,12 +1552,19 @@ int vfs_quota_off(struct super_block *sb
 				mutex_unlock(&toputinode[cnt]->i_mutex);
 				mark_inode_dirty(toputinode[cnt]);
 			}
-			iput(toputinode[cnt]);
 			mutex_unlock(&dqopt->dqonoff_mutex);
+			/* On remount RO, we keep the inode pointer so that we
+			 * can reenable quota on the subsequent remount RW.
+			 * But we have better not keep inode pointer when there
+			 * is pending delete on the quota file... */
+			if (!remount)
+				iput(toputinode[cnt]);
+			else if (!toputinode[cnt]->i_nlink)
+				ret = -EBUSY;
 		}
 	if (sb->s_bdev)
 		invalidate_bdev(sb->s_bdev);
-	return 0;
+	return ret;
 }
 
 /*
@@ -1574,7 +1602,8 @@ static int vfs_quota_on_inode(struct ino
 	invalidate_bdev(sb->s_bdev);
 	mutex_lock(&inode->i_mutex);
 	mutex_lock(&dqopt->dqonoff_mutex);
-	if (sb_has_quota_enabled(sb, type)) {
+	if (sb_has_quota_enabled(sb, type) ||
+			sb_has_quota_suspended(sb, type)) {
 		error = -EBUSY;
 		goto out_lock;
 	}
@@ -1597,6 +1626,7 @@ static int vfs_quota_on_inode(struct ino
 
 	dqopt->ops[type] = fmt->qf_ops;
 	dqopt->info[type].dqi_format = fmt;
+	dqopt->info[type].dqi_fmt_id = format_id;
 	INIT_LIST_HEAD(&dqopt->info[type].dqi_dirty_list);
 	mutex_lock(&dqopt->dqio_mutex);
 	if ((error = dqopt->ops[type]->read_file_info(sb, type)) < 0) {
@@ -1632,12 +1662,41 @@ out_fmt:
 	return error; 
 }
 
+/* Reenable quotas on remount RW */
+static int vfs_quota_on_remount(struct super_block *sb, int type)
+{
+	struct quota_info *dqopt = sb_dqopt(sb);
+	struct inode *inode;
+	int ret;
+
+	mutex_lock(&dqopt->dqonoff_mutex);
+	if (!sb_has_quota_suspended(sb, type)) {
+		mutex_unlock(&dqopt->dqonoff_mutex);
+		return 0;
+	}
+	BUG_ON(sb_has_quota_enabled(sb, type));
+
+	inode = dqopt->files[type];
+	dqopt->files[type] = NULL;
+	reset_enable_flags(dqopt, type, 0);
+	mutex_unlock(&dqopt->dqonoff_mutex);
+
+	ret = vfs_quota_on_inode(inode, type, dqopt->info[type].dqi_fmt_id);
+	iput(inode);
+
+	return ret;
+}
+
 /* Actual function called from quotactl() */
-int vfs_quota_on(struct super_block *sb, int type, int format_id, char *path)
+int vfs_quota_on(struct super_block *sb, int type, int format_id, char *path,
+		 int remount)
 {
 	struct nameidata nd;
 	int error;
 
+	if (remount)
+		return vfs_quota_on_remount(sb, type);
+
 	error = path_lookup(path, LOOKUP_FOLLOW, &nd);
 	if (error < 0)
 		return error;
diff -puN fs/quota.c~quota-quota-core-changes-for-quotaon-on-remount fs/quota.c
--- a/fs/quota.c~quota-quota-core-changes-for-quotaon-on-remount
+++ a/fs/quota.c
@@ -69,7 +69,6 @@ static int generic_quotactl_valid(struct
 	switch (cmd) {
 		case Q_GETFMT:
 		case Q_GETINFO:
-		case Q_QUOTAOFF:
 		case Q_SETINFO:
 		case Q_SETQUOTA:
 		case Q_GETQUOTA:
@@ -229,12 +228,12 @@ static int do_quotactl(struct super_bloc
 
 			if (IS_ERR(pathname = getname(addr)))
 				return PTR_ERR(pathname);
-			ret = sb->s_qcop->quota_on(sb, type, id, pathname);
+			ret = sb->s_qcop->quota_on(sb, type, id, pathname, 0);
 			putname(pathname);
 			return ret;
 		}
 		case Q_QUOTAOFF:
-			return sb->s_qcop->quota_off(sb, type);
+			return sb->s_qcop->quota_off(sb, type, 0);
 
 		case Q_GETFMT: {
 			__u32 fmt;
diff -puN fs/super.c~quota-quota-core-changes-for-quotaon-on-remount fs/super.c
--- a/fs/super.c~quota-quota-core-changes-for-quotaon-on-remount
+++ a/fs/super.c
@@ -179,7 +179,7 @@ void deactivate_super(struct super_block
 	if (atomic_dec_and_lock(&s->s_active, &sb_lock)) {
 		s->s_count -= S_BIAS-1;
 		spin_unlock(&sb_lock);
-		DQUOT_OFF(s);
+		DQUOT_OFF(s, 0);
 		down_write(&s->s_umount);
 		fs->kill_sb(s);
 		put_filesystem(fs);
@@ -608,6 +608,7 @@ retry:
 int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 {
 	int retval;
+	int remount_rw;
 	
 #ifdef CONFIG_BLOCK
 	if (!(flags & MS_RDONLY) && bdev_read_only(sb->s_bdev))
@@ -625,8 +626,11 @@ int do_remount_sb(struct super_block *sb
 			mark_files_ro(sb);
 		else if (!fs_may_remount_ro(sb))
 			return -EBUSY;
-		DQUOT_OFF(sb);
+		retval = DQUOT_OFF(sb, 1);
+		if (retval < 0 && retval != -ENOSYS)
+			return -EBUSY;
 	}
+	remount_rw = !(flags & MS_RDONLY) && (sb->s_flags & MS_RDONLY);
 
 	if (sb->s_op->remount_fs) {
 		lock_super(sb);
@@ -636,6 +640,8 @@ int do_remount_sb(struct super_block *sb
 			return retval;
 	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
+	if (remount_rw)
+		DQUOT_ON_REMOUNT(sb);
 	return 0;
 }
 
diff -puN include/linux/quota.h~quota-quota-core-changes-for-quotaon-on-remount include/linux/quota.h
--- a/include/linux/quota.h~quota-quota-core-changes-for-quotaon-on-remount
+++ a/include/linux/quota.h
@@ -202,6 +202,8 @@ struct quota_format_type;
 
 struct mem_dqinfo {
 	struct quota_format_type *dqi_format;
+	int dqi_fmt_id;		/* Id of the dqi_format - used when turning
+				 * quotas on after remount RW */
 	struct list_head dqi_dirty_list;	/* List of dirty dquots */
 	unsigned long dqi_flags;
 	unsigned int dqi_bgrace;
@@ -298,8 +300,8 @@ struct dquot_operations {
 
 /* Operations handling requests from userspace */
 struct quotactl_ops {
-	int (*quota_on)(struct super_block *, int, int, char *);
-	int (*quota_off)(struct super_block *, int);
+	int (*quota_on)(struct super_block *, int, int, char *, int);
+	int (*quota_off)(struct super_block *, int, int);
 	int (*quota_sync)(struct super_block *, int);
 	int (*get_info)(struct super_block *, int, struct if_dqinfo *);
 	int (*set_info)(struct super_block *, int, struct if_dqinfo *);
@@ -320,6 +322,10 @@ struct quota_format_type {
 
 #define DQUOT_USR_ENABLED	0x01		/* User diskquotas enabled */
 #define DQUOT_GRP_ENABLED	0x02		/* Group diskquotas enabled */
+#define DQUOT_USR_SUSPENDED	0x04		/* User diskquotas are off, but
+						 * we have necessary info in
+						 * memory to turn them on */
+#define DQUOT_GRP_SUSPENDED	0x08		/* The same for group quotas */
 
 struct quota_info {
 	unsigned int flags;			/* Flags for diskquotas on this device */
@@ -337,6 +343,10 @@ struct quota_info {
 #define sb_any_quota_enabled(sb) (sb_has_quota_enabled(sb, USRQUOTA) | \
 				  sb_has_quota_enabled(sb, GRPQUOTA))
 
+#define sb_has_quota_suspended(sb, type) \
+	((type) == USRQUOTA ? (sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED) : \
+			      (sb_dqopt(sb)->flags & DQUOT_GRP_SUSPENDED))
+
 int register_quota_format(struct quota_format_type *fmt);
 void unregister_quota_format(struct quota_format_type *fmt);
 
diff -puN include/linux/quotaops.h~quota-quota-core-changes-for-quotaon-on-remount include/linux/quotaops.h
--- a/include/linux/quotaops.h~quota-quota-core-changes-for-quotaon-on-remount
+++ a/include/linux/quotaops.h
@@ -37,10 +37,11 @@ extern int dquot_release(struct dquot *d
 extern int dquot_commit_info(struct super_block *sb, int type);
 extern int dquot_mark_dquot_dirty(struct dquot *dquot);
 
-extern int vfs_quota_on(struct super_block *sb, int type, int format_id, char *path);
+extern int vfs_quota_on(struct super_block *sb, int type, int format_id,
+		char *path, int remount);
 extern int vfs_quota_on_mount(struct super_block *sb, char *qf_name,
 		int format_id, int type);
-extern int vfs_quota_off(struct super_block *sb, int type);
+extern int vfs_quota_off(struct super_block *sb, int type, int remount);
 extern int vfs_quota_sync(struct super_block *sb, int type);
 extern int vfs_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
 extern int vfs_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
@@ -175,12 +176,27 @@ static inline void DQUOT_SYNC(struct sup
 	sync_dquots(sb, -1);
 }
 
-static inline int DQUOT_OFF(struct super_block *sb)
+static inline int DQUOT_OFF(struct super_block *sb, int remount)
 {
 	int ret = -ENOSYS;
 
-	if (sb_any_quota_enabled(sb) && sb->s_qcop && sb->s_qcop->quota_off)
-		ret = sb->s_qcop->quota_off(sb, -1);
+	if (sb->s_qcop && sb->s_qcop->quota_off)
+		ret = sb->s_qcop->quota_off(sb, -1, remount);
+	return ret;
+}
+
+static inline int DQUOT_ON_REMOUNT(struct super_block *sb)
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
 	return ret;
 }
 
@@ -196,7 +212,8 @@ static inline int DQUOT_OFF(struct super
 #define DQUOT_ALLOC_INODE(inode)		(0)
 #define DQUOT_FREE_INODE(inode)			do { } while(0)
 #define DQUOT_SYNC(sb)				do { } while(0)
-#define DQUOT_OFF(sb)				(0)
+#define DQUOT_OFF(sb, remount)			(0)
+#define DQUOT_ON_REMOUNT(sb)			(0)
 #define DQUOT_TRANSFER(inode, iattr)		(0)
 static inline int DQUOT_PREALLOC_SPACE_NODIRTY(struct inode *inode, qsize_t nr)
 {
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

