From: akpm@linux-foundation.org
Subject: [merged] autofs4-coding-style-fixes.patch removed from -mm tree
Date: Wed, 16 Mar 2016 12:57:47 -0700
Message-ID: <56e9babb.3RFeRSPk2x7DLWbQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934130AbcCPT5s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:57:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: coding style fixes
has been removed from the -mm tree.  Its filename was
     autofs4-coding-style-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: autofs4: coding style fixes

Try and make the coding style completely consistent throughtout the autofs
module and inline with kernel coding style recommendations.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h          |   55 ++++++++---------
 fs/autofs4/dev-ioctl.c         |   28 +++++----
 fs/autofs4/expire.c            |   60 ++++++++++---------
 fs/autofs4/init.c              |   10 ---
 fs/autofs4/inode.c             |   25 +++-----
 fs/autofs4/root.c              |   95 ++++++++++++++++---------------
 fs/autofs4/symlink.c           |   11 +--
 fs/autofs4/waitq.c             |   49 ++++++++-------
 include/linux/auto_dev-ioctl.h |    1 
 include/linux/auto_fs.h        |   10 ---
 include/uapi/linux/auto_fs.h   |   19 ++----
 include/uapi/linux/auto_fs4.h  |   15 +---
 12 files changed, 190 insertions(+), 188 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-coding-style-fixes fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-coding-style-fixes
+++ a/fs/autofs4/autofs_i.h
@@ -1,15 +1,11 @@
-/* -*- c -*- ------------------------------------------------------------- *
- *   
- * linux/fs/autofs/autofs_i.h
- *
- *   Copyright 1997-1998 Transmeta Corporation - All Rights Reserved
- *   Copyright 2005-2006 Ian Kent <raven@themaw.net>
+/*
+ *  Copyright 1997-1998 Transmeta Corporation - All Rights Reserved
+ *  Copyright 2005-2006 Ian Kent <raven@themaw.net>
  *
  * This file is part of the Linux kernel and is made available under
  * the terms of the GNU General Public License, version 2, or at your
  * option, any later version, incorporated herein by reference.
- *
- * ----------------------------------------------------------------------- */
+ */
 
 /* Internal header file for autofs */
 
@@ -35,7 +31,7 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <asm/current.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 /* #define DEBUG */
 
@@ -51,12 +47,14 @@
 	printk(KERN_ERR "pid %d: %s: " fmt "\n",	\
 		current->pid, __func__, ##__VA_ARGS__)
 
-/* Unified info structure.  This is pointed to by both the dentry and
-   inode structures.  Each file in the filesystem has an instance of this
-   structure.  It holds a reference to the dentry, so dentries are never
-   flushed while the file exists.  All name lookups are dealt with at the
-   dentry level, although the filesystem can interfere in the validation
-   process.  Readdir is implemented by traversing the dentry lists. */
+/*
+ * Unified info structure.  This is pointed to by both the dentry and
+ * inode structures.  Each file in the filesystem has an instance of this
+ * structure.  It holds a reference to the dentry, so dentries are never
+ * flushed while the file exists.  All name lookups are dealt with at the
+ * dentry level, although the filesystem can interfere in the validation
+ * process.  Readdir is implemented by traversing the dentry lists.
+ */
 struct autofs_info {
 	struct dentry	*dentry;
 	struct inode	*inode;
@@ -78,7 +76,7 @@ struct autofs_info {
 	kgid_t gid;
 };
 
-#define AUTOFS_INF_EXPIRING	(1<<0) /* dentry is in the process of expiring */
+#define AUTOFS_INF_EXPIRING	(1<<0) /* dentry in the process of expiring */
 #define AUTOFS_INF_NO_RCU	(1<<1) /* the dentry is being considered
 					* for expiry, so RCU_walk is
 					* not permitted
@@ -140,10 +138,11 @@ static inline struct autofs_info *autofs
 }
 
 /* autofs4_oz_mode(): do we see the man behind the curtain?  (The
-   processes which do manipulations for us in user space sees the raw
-   filesystem without "magic".) */
-
-static inline int autofs4_oz_mode(struct autofs_sb_info *sbi) {
+ * processes which do manipulations for us in user space sees the raw
+ * filesystem without "magic".)
+ */
+static inline int autofs4_oz_mode(struct autofs_sb_info *sbi)
+{
 	return sbi->catatonic || task_pgrp(current) == sbi->oz_pgrp;
 }
 
@@ -154,12 +153,12 @@ void autofs4_free_ino(struct autofs_info
 int is_autofs4_dentry(struct dentry *);
 int autofs4_expire_wait(struct dentry *dentry, int rcu_walk);
 int autofs4_expire_run(struct super_block *, struct vfsmount *,
-			struct autofs_sb_info *,
-			struct autofs_packet_expire __user *);
+		       struct autofs_sb_info *,
+		       struct autofs_packet_expire __user *);
 int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 			    struct autofs_sb_info *sbi, int when);
 int autofs4_expire_multi(struct super_block *, struct vfsmount *,
-			struct autofs_sb_info *, int __user *);
+			 struct autofs_sb_info *, int __user *);
 struct dentry *autofs4_expire_direct(struct super_block *sb,
 				     struct vfsmount *mnt,
 				     struct autofs_sb_info *sbi, int how);
@@ -224,8 +223,8 @@ static inline int autofs_prepare_pipe(st
 
 /* Queue management functions */
 
-int autofs4_wait(struct autofs_sb_info *,struct dentry *, enum autofs_notify);
-int autofs4_wait_release(struct autofs_sb_info *,autofs_wqt_t,int);
+int autofs4_wait(struct autofs_sb_info *, struct dentry *, enum autofs_notify);
+int autofs4_wait_release(struct autofs_sb_info *, autofs_wqt_t, int);
 void autofs4_catatonic_mode(struct autofs_sb_info *);
 
 static inline u32 autofs4_get_dev(struct autofs_sb_info *sbi)
@@ -242,37 +241,37 @@ static inline void __autofs4_add_expirin
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+
 	if (ino) {
 		if (list_empty(&ino->expiring))
 			list_add(&ino->expiring, &sbi->expiring_list);
 	}
-	return;
 }
 
 static inline void autofs4_add_expiring(struct dentry *dentry)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+
 	if (ino) {
 		spin_lock(&sbi->lookup_lock);
 		if (list_empty(&ino->expiring))
 			list_add(&ino->expiring, &sbi->expiring_list);
 		spin_unlock(&sbi->lookup_lock);
 	}
-	return;
 }
 
 static inline void autofs4_del_expiring(struct dentry *dentry)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+
 	if (ino) {
 		spin_lock(&sbi->lookup_lock);
 		if (!list_empty(&ino->expiring))
 			list_del_init(&ino->expiring);
 		spin_unlock(&sbi->lookup_lock);
 	}
-	return;
 }
 
 extern void autofs4_kill_sb(struct super_block *);
diff -puN fs/autofs4/dev-ioctl.c~autofs4-coding-style-fixes fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs4-coding-style-fixes
+++ a/fs/autofs4/dev-ioctl.c
@@ -72,8 +72,8 @@ static int check_dev_ioctl_version(int c
 {
 	int err = 0;
 
-	if ((AUTOFS_DEV_IOCTL_VERSION_MAJOR != param->ver_major) ||
-	    (AUTOFS_DEV_IOCTL_VERSION_MINOR < param->ver_minor)) {
+	if ((param->ver_major != AUTOFS_DEV_IOCTL_VERSION_MAJOR) ||
+	    (param->ver_minor > AUTOFS_DEV_IOCTL_VERSION_MINOR)) {
 		AUTOFS_WARN("ioctl control interface version mismatch: "
 		     "kernel(%u.%u), user(%u.%u), cmd(%d)",
 		     AUTOFS_DEV_IOCTL_VERSION_MAJOR,
@@ -93,7 +93,8 @@ static int check_dev_ioctl_version(int c
  * Copy parameter control struct, including a possible path allocated
  * at the end of the struct.
  */
-static struct autofs_dev_ioctl *copy_dev_ioctl(struct autofs_dev_ioctl __user *in)
+static struct autofs_dev_ioctl *
+		copy_dev_ioctl(struct autofs_dev_ioctl __user *in)
 {
 	struct autofs_dev_ioctl tmp, *res;
 
@@ -116,7 +117,6 @@ static struct autofs_dev_ioctl *copy_dev
 static inline void free_dev_ioctl(struct autofs_dev_ioctl *param)
 {
 	kfree(param);
-	return;
 }
 
 /*
@@ -197,7 +197,9 @@ static int find_autofs_mount(const char
 			     void *data)
 {
 	struct path path;
-	int err = kern_path_mountpoint(AT_FDCWD, pathname, &path, 0);
+	int err;
+
+	err = kern_path_mountpoint(AT_FDCWD, pathname, &path, 0);
 	if (err)
 		return err;
 	err = -ENOENT;
@@ -225,6 +227,7 @@ static int test_by_dev(struct path *path
 static int test_by_type(struct path *path, void *p)
 {
 	struct autofs_info *ino = autofs4_dentry_ino(path->dentry);
+
 	return ino && ino->sbi->type & *(unsigned *)p;
 }
 
@@ -456,8 +459,10 @@ static int autofs_dev_ioctl_requester(st
 		err = 0;
 		autofs4_expire_wait(path.dentry, 0);
 		spin_lock(&sbi->fs_lock);
-		param->requester.uid = from_kuid_munged(current_user_ns(), ino->uid);
-		param->requester.gid = from_kgid_munged(current_user_ns(), ino->gid);
+		param->requester.uid =
+			from_kuid_munged(current_user_ns(), ino->uid);
+		param->requester.gid =
+			from_kgid_munged(current_user_ns(), ino->gid);
 		spin_unlock(&sbi->fs_lock);
 	}
 	path_put(&path);
@@ -619,7 +624,8 @@ static ioctl_fn lookup_dev_ioctl(unsigne
 }
 
 /* ioctl dispatcher */
-static int _autofs_dev_ioctl(unsigned int command, struct autofs_dev_ioctl __user *user)
+static int _autofs_dev_ioctl(unsigned int command,
+			     struct autofs_dev_ioctl __user *user)
 {
 	struct autofs_dev_ioctl *param;
 	struct file *fp;
@@ -711,6 +717,7 @@ out:
 static long autofs_dev_ioctl(struct file *file, uint command, ulong u)
 {
 	int err;
+
 	err = _autofs_dev_ioctl(command, (struct autofs_dev_ioctl __user *) u);
 	return (long) err;
 }
@@ -733,8 +740,8 @@ static const struct file_operations _dev
 
 static struct miscdevice _autofs_dev_ioctl_misc = {
 	.minor		= AUTOFS_MINOR,
-	.name  		= AUTOFS_DEVICE_NAME,
-	.fops  		= &_dev_ioctl_fops
+	.name		= AUTOFS_DEVICE_NAME,
+	.fops		= &_dev_ioctl_fops
 };
 
 MODULE_ALIAS_MISCDEV(AUTOFS_MINOR);
@@ -757,6 +764,5 @@ int __init autofs_dev_ioctl_init(void)
 void autofs_dev_ioctl_exit(void)
 {
 	misc_deregister(&_autofs_dev_ioctl_misc);
-	return;
 }
 
diff -puN fs/autofs4/expire.c~autofs4-coding-style-fixes fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs4-coding-style-fixes
+++ a/fs/autofs4/expire.c
@@ -1,16 +1,12 @@
-/* -*- c -*- --------------------------------------------------------------- *
- *
- * linux/fs/autofs/expire.c
- *
- *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
- *  Copyright 1999-2000 Jeremy Fitzhardinge <jeremy@goop.org>
- *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
+/*
+ * Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
+ * Copyright 1999-2000 Jeremy Fitzhardinge <jeremy@goop.org>
+ * Copyright 2001-2006 Ian Kent <raven@themaw.net>
  *
  * This file is part of the Linux kernel and is made available under
  * the terms of the GNU General Public License, version 2, or at your
  * option, any later version, incorporated herein by reference.
- *
- * ------------------------------------------------------------------------- */
+ */
 
 #include "autofs_i.h"
 
@@ -18,7 +14,7 @@ static unsigned long now;
 
 /* Check if a dentry can be expired */
 static inline int autofs4_can_expire(struct dentry *dentry,
-					unsigned long timeout, int do_now)
+				     unsigned long timeout, int do_now)
 {
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 
@@ -58,7 +54,9 @@ static int autofs4_mount_busy(struct vfs
 
 	/* Update the expiry counter if fs is busy */
 	if (!may_umount_tree(path.mnt)) {
-		struct autofs_info *ino = autofs4_dentry_ino(top);
+		struct autofs_info *ino;
+
+		ino = autofs4_dentry_ino(top);
 		ino->last_used = jiffies;
 		goto done;
 	}
@@ -74,7 +72,7 @@ done:
  * Calculate and dget next entry in the subdirs list under root.
  */
 static struct dentry *get_next_positive_subdir(struct dentry *prev,
-						struct dentry *root)
+					       struct dentry *root)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(root->d_sb);
 	struct list_head *next;
@@ -121,7 +119,7 @@ cont:
  * Calculate and dget next entry in top down tree traversal.
  */
 static struct dentry *get_next_positive_dentry(struct dentry *prev,
-						struct dentry *root)
+					       struct dentry *root)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(root->d_sb);
 	struct list_head *next;
@@ -187,15 +185,17 @@ again:
  * autofs submounts.
  */
 static int autofs4_direct_busy(struct vfsmount *mnt,
-				struct dentry *top,
-				unsigned long timeout,
-				int do_now)
+			       struct dentry *top,
+			       unsigned long timeout,
+			       int do_now)
 {
 	DPRINTK("top %p %pd", top, top);
 
 	/* If it's busy update the expiry counters */
 	if (!may_umount_tree(mnt)) {
-		struct autofs_info *ino = autofs4_dentry_ino(top);
+		struct autofs_info *ino;
+
+		ino = autofs4_dentry_ino(top);
 		if (ino)
 			ino->last_used = jiffies;
 		return 1;
@@ -208,7 +208,8 @@ static int autofs4_direct_busy(struct vf
 	return 0;
 }
 
-/* Check a directory tree of mount points for busyness
+/*
+ * Check a directory tree of mount points for busyness
  * The tree is not busy iff no mountpoints are busy
  */
 static int autofs4_tree_busy(struct vfsmount *mnt,
@@ -404,6 +405,7 @@ static struct dentry *should_expire(stru
 	} else {
 		/* Path walk currently on this dentry? */
 		struct dentry *expired;
+
 		ino_count = atomic_read(&ino->count) + 1;
 		if (d_count(dentry) > ino_count)
 			return NULL;
@@ -522,21 +524,22 @@ int autofs4_expire_wait(struct dentry *d
 
 /* Perform an expiry operation */
 int autofs4_expire_run(struct super_block *sb,
-		      struct vfsmount *mnt,
-		      struct autofs_sb_info *sbi,
-		      struct autofs_packet_expire __user *pkt_p)
+		       struct vfsmount *mnt,
+		       struct autofs_sb_info *sbi,
+		       struct autofs_packet_expire __user *pkt_p)
 {
 	struct autofs_packet_expire pkt;
 	struct autofs_info *ino;
 	struct dentry *dentry;
 	int ret = 0;
 
-	memset(&pkt,0,sizeof pkt);
+	memset(&pkt, 0, sizeof(pkt));
 
 	pkt.hdr.proto_version = sbi->version;
 	pkt.hdr.type = autofs_ptype_expire;
 
-	if ((dentry = autofs4_expire_indirect(sb, mnt, sbi, 0)) == NULL)
+	dentry = autofs4_expire_indirect(sb, mnt, sbi, 0);
+	if (!dentry)
 		return -EAGAIN;
 
 	pkt.len = dentry->d_name.len;
@@ -544,7 +547,7 @@ int autofs4_expire_run(struct super_bloc
 	pkt.name[pkt.len] = '\0';
 	dput(dentry);
 
-	if ( copy_to_user(pkt_p, &pkt, sizeof(struct autofs_packet_expire)) )
+	if (copy_to_user(pkt_p, &pkt, sizeof(struct autofs_packet_expire)))
 		ret = -EFAULT;
 
 	spin_lock(&sbi->fs_lock);
@@ -573,7 +576,8 @@ int autofs4_do_expire_multi(struct super
 		struct autofs_info *ino = autofs4_dentry_ino(dentry);
 
 		/* This is synchronous because it makes the daemon a
-                   little easier */
+		 * little easier
+		 */
 		ret = autofs4_wait(sbi, dentry, NFY_EXPIRE);
 
 		spin_lock(&sbi->fs_lock);
@@ -588,8 +592,10 @@ int autofs4_do_expire_multi(struct super
 	return ret;
 }
 
-/* Call repeatedly until it returns -EAGAIN, meaning there's nothing
-   more to be done */
+/*
+ * Call repeatedly until it returns -EAGAIN, meaning there's nothing
+ * more to be done.
+ */
 int autofs4_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 			struct autofs_sb_info *sbi, int __user *arg)
 {
diff -puN fs/autofs4/init.c~autofs4-coding-style-fixes fs/autofs4/init.c
--- a/fs/autofs4/init.c~autofs4-coding-style-fixes
+++ a/fs/autofs4/init.c
@@ -1,14 +1,10 @@
-/* -*- c -*- --------------------------------------------------------------- *
- *
- * linux/fs/autofs/init.c
- *
- *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
+/*
+ * Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *
  * This file is part of the Linux kernel and is made available under
  * the terms of the GNU General Public License, version 2, or at your
  * option, any later version, incorporated herein by reference.
- *
- * ------------------------------------------------------------------------- */
+ */
 
 #include <linux/module.h>
 #include <linux/init.h>
diff -puN fs/autofs4/inode.c~autofs4-coding-style-fixes fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs4-coding-style-fixes
+++ a/fs/autofs4/inode.c
@@ -1,15 +1,11 @@
-/* -*- c -*- --------------------------------------------------------------- *
- *
- * linux/fs/autofs/inode.c
- *
- *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
- *  Copyright 2005-2006 Ian Kent <raven@themaw.net>
+/*
+ * Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
+ * Copyright 2005-2006 Ian Kent <raven@themaw.net>
  *
  * This file is part of the Linux kernel and is made available under
  * the terms of the GNU General Public License, version 2, or at your
  * option, any later version, incorporated herein by reference.
- *
- * ------------------------------------------------------------------------- */
+ */
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -24,7 +20,9 @@
 
 struct autofs_info *autofs4_new_ino(struct autofs_sb_info *sbi)
 {
-	struct autofs_info *ino = kzalloc(sizeof(*ino), GFP_KERNEL);
+	struct autofs_info *ino;
+
+	ino = kzalloc(sizeof(*ino), GFP_KERNEL);
 	if (ino) {
 		INIT_LIST_HEAD(&ino->active);
 		INIT_LIST_HEAD(&ino->expiring);
@@ -152,6 +150,7 @@ static int parse_options(char *options,
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
+
 		if (!*p)
 			continue;
 
@@ -209,9 +208,9 @@ static int parse_options(char *options,
 
 int autofs4_fill_super(struct super_block *s, void *data, int silent)
 {
-	struct inode * root_inode;
-	struct dentry * root;
-	struct file * pipe;
+	struct inode *root_inode;
+	struct dentry *root;
+	struct file *pipe;
 	int pipefd;
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;
@@ -222,7 +221,7 @@ int autofs4_fill_super(struct super_bloc
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		return -ENOMEM;
-	DPRINTK("starting up, sbi = %p",sbi);
+	DPRINTK("starting up, sbi = %p", sbi);
 
 	s->s_fs_info = sbi;
 	sbi->magic = AUTOFS_SBI_MAGIC;
diff -puN fs/autofs4/root.c~autofs4-coding-style-fixes fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-coding-style-fixes
+++ a/fs/autofs4/root.c
@@ -1,16 +1,12 @@
-/* -*- c -*- --------------------------------------------------------------- *
- *
- * linux/fs/autofs/root.c
- *
- *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
- *  Copyright 1999-2000 Jeremy Fitzhardinge <jeremy@goop.org>
- *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
+/*
+ * Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
+ * Copyright 1999-2000 Jeremy Fitzhardinge <jeremy@goop.org>
+ * Copyright 2001-2006 Ian Kent <raven@themaw.net>
  *
  * This file is part of the Linux kernel and is made available under
  * the terms of the GNU General Public License, version 2, or at your
  * option, any later version, incorporated herein by reference.
- *
- * ------------------------------------------------------------------------- */
+ */
 
 #include <linux/capability.h>
 #include <linux/errno.h>
@@ -23,16 +19,18 @@
 
 #include "autofs_i.h"
 
-static int autofs4_dir_symlink(struct inode *,struct dentry *,const char *);
-static int autofs4_dir_unlink(struct inode *,struct dentry *);
-static int autofs4_dir_rmdir(struct inode *,struct dentry *);
-static int autofs4_dir_mkdir(struct inode *,struct dentry *,umode_t);
-static long autofs4_root_ioctl(struct file *,unsigned int,unsigned long);
+static int autofs4_dir_symlink(struct inode *, struct dentry *, const char *);
+static int autofs4_dir_unlink(struct inode *, struct dentry *);
+static int autofs4_dir_rmdir(struct inode *, struct dentry *);
+static int autofs4_dir_mkdir(struct inode *, struct dentry *, umode_t);
+static long autofs4_root_ioctl(struct file *, unsigned int, unsigned long);
 #ifdef CONFIG_COMPAT
-static long autofs4_root_compat_ioctl(struct file *,unsigned int,unsigned long);
+static long autofs4_root_compat_ioctl(struct file *,
+				      unsigned int, unsigned long);
 #endif
 static int autofs4_dir_open(struct inode *inode, struct file *file);
-static struct dentry *autofs4_lookup(struct inode *,struct dentry *, unsigned int);
+static struct dentry *autofs4_lookup(struct inode *,
+				     struct dentry *, unsigned int);
 static struct vfsmount *autofs4_d_automount(struct path *);
 static int autofs4_d_manage(struct dentry *, bool);
 static void autofs4_dentry_release(struct dentry *);
@@ -74,7 +72,9 @@ const struct dentry_operations autofs4_d
 static void autofs4_add_active(struct dentry *dentry)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_info *ino;
+
+	ino = autofs4_dentry_ino(dentry);
 	if (ino) {
 		spin_lock(&sbi->lookup_lock);
 		if (!ino->active_count) {
@@ -84,13 +84,14 @@ static void autofs4_add_active(struct de
 		ino->active_count++;
 		spin_unlock(&sbi->lookup_lock);
 	}
-	return;
 }
 
 static void autofs4_del_active(struct dentry *dentry)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_info *ino;
+
+	ino = autofs4_dentry_ino(dentry);
 	if (ino) {
 		spin_lock(&sbi->lookup_lock);
 		ino->active_count--;
@@ -100,7 +101,6 @@ static void autofs4_del_active(struct de
 		}
 		spin_unlock(&sbi->lookup_lock);
 	}
-	return;
 }
 
 static int autofs4_dir_open(struct inode *inode, struct file *file)
@@ -320,7 +320,9 @@ static struct dentry *autofs4_mountpoint
 	if (autofs_type_indirect(sbi->type) && d_unhashed(dentry)) {
 		struct dentry *parent = dentry->d_parent;
 		struct autofs_info *ino;
-		struct dentry *new = d_lookup(parent, &dentry->d_name);
+		struct dentry *new;
+
+		new = d_lookup(parent, &dentry->d_name);
 		if (!new)
 			return NULL;
 		ino = autofs4_dentry_ino(new);
@@ -455,6 +457,7 @@ static int autofs4_d_manage(struct dentr
 		 * a mount-trap.
 		 */
 		struct inode *inode;
+
 		if (ino->flags & (AUTOFS_INF_EXPIRING | AUTOFS_INF_NO_RCU))
 			return 0;
 		if (d_mountpoint(dentry))
@@ -494,7 +497,8 @@ static int autofs4_d_manage(struct dentr
 }
 
 /* Lookups in the root directory */
-static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
+static struct dentry *autofs4_lookup(struct inode *dir,
+				     struct dentry *dentry, unsigned int flags)
 {
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;
@@ -513,9 +517,9 @@ static struct dentry *autofs4_lookup(str
 		autofs4_oz_mode(sbi));
 
 	active = autofs4_lookup_active(dentry);
-	if (active) {
+	if (active)
 		return active;
-	} else {
+	else {
 		/*
 		 * A dentry that is not within the root can never trigger a
 		 * mount operation, unless the directory already exists, so we
@@ -526,7 +530,8 @@ static struct dentry *autofs4_lookup(str
 			return ERR_PTR(-ENOENT);
 
 		/* Mark entries in the root as mount triggers */
-		if (autofs_type_indirect(sbi->type) && IS_ROOT(dentry->d_parent))
+		if (IS_ROOT(dentry->d_parent) &&
+		    autofs_type_indirect(sbi->type))
 			__managed_dentry_set_managed(dentry);
 
 		ino = autofs4_new_ino(sbi);
@@ -664,7 +669,6 @@ static void autofs_set_leaf_automount_fl
 	if (IS_ROOT(parent->d_parent))
 		return;
 	managed_dentry_clear_managed(parent);
-	return;
 }
 
 static void autofs_clear_leaf_automount_flags(struct dentry *dentry)
@@ -687,7 +691,6 @@ static void autofs_clear_leaf_automount_
 	if (d_child->next == &parent->d_subdirs &&
 	    d_child->prev == &parent->d_subdirs)
 		managed_dentry_set_managed(parent);
-	return;
 }
 
 static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
@@ -728,7 +731,8 @@ static int autofs4_dir_rmdir(struct inod
 	return 0;
 }
 
-static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
+static int autofs4_dir_mkdir(struct inode *dir,
+			     struct dentry *dentry, umode_t mode)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
@@ -768,7 +772,7 @@ static int autofs4_dir_mkdir(struct inod
 /* Get/set timeout ioctl() operation */
 #ifdef CONFIG_COMPAT
 static inline int autofs4_compat_get_set_timeout(struct autofs_sb_info *sbi,
-					 compat_ulong_t __user *p)
+						 compat_ulong_t __user *p)
 {
 	int rv;
 	unsigned long ntimeout;
@@ -787,7 +791,7 @@ static inline int autofs4_compat_get_set
 #endif
 
 static inline int autofs4_get_set_timeout(struct autofs_sb_info *sbi,
-					 unsigned long __user *p)
+					  unsigned long __user *p)
 {
 	int rv;
 	unsigned long ntimeout;
@@ -805,13 +809,15 @@ static inline int autofs4_get_set_timeou
 }
 
 /* Return protocol version */
-static inline int autofs4_get_protover(struct autofs_sb_info *sbi, int __user *p)
+static inline int autofs4_get_protover(struct autofs_sb_info *sbi,
+				       int __user *p)
 {
 	return put_user(sbi->version, p);
 }
 
 /* Return protocol sub version */
-static inline int autofs4_get_protosubver(struct autofs_sb_info *sbi, int __user *p)
+static inline int autofs4_get_protosubver(struct autofs_sb_info *sbi,
+					  int __user *p)
 {
 	return put_user(sbi->sub_version, p);
 }
@@ -834,9 +840,9 @@ static inline int autofs4_ask_umount(str
 }
 
 /* Identify autofs4_dentries - this is so we can tell if there's
-   an extra dentry refcount or not.  We only hold a refcount on the
-   dentry if its non-negative (ie, d_inode != NULL)
-*/
+ * an extra dentry refcount or not.  We only hold a refcount on the
+ * dentry if its non-negative (ie, d_inode != NULL)
+ */
 int is_autofs4_dentry(struct dentry *dentry)
 {
 	return dentry && d_really_is_positive(dentry) &&
@@ -855,7 +861,7 @@ static int autofs4_root_ioctl_unlocked(s
 	void __user *p = (void __user *)arg;
 
 	DPRINTK("cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u",
-		cmd,arg,sbi,task_pgrp_nr(current));
+		cmd, arg, sbi, task_pgrp_nr(current));
 
 	if (_IOC_TYPE(cmd) != _IOC_TYPE(AUTOFS_IOC_FIRST) ||
 	     _IOC_NR(cmd) - _IOC_NR(AUTOFS_IOC_FIRST) >= AUTOFS_IOC_COUNT)
@@ -864,11 +870,11 @@ static int autofs4_root_ioctl_unlocked(s
 	if (!autofs4_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	
-	switch(cmd) {
+	switch (cmd) {
 	case AUTOFS_IOC_READY:	/* Wait queue: go ahead and retry */
-		return autofs4_wait_release(sbi,(autofs_wqt_t)arg,0);
+		return autofs4_wait_release(sbi, (autofs_wqt_t) arg, 0);
 	case AUTOFS_IOC_FAIL:	/* Wait queue: fail with ENOENT */
-		return autofs4_wait_release(sbi,(autofs_wqt_t)arg,-ENOENT);
+		return autofs4_wait_release(sbi, (autofs_wqt_t) arg, -ENOENT);
 	case AUTOFS_IOC_CATATONIC: /* Enter catatonic mode (daemon shutdown) */
 		autofs4_catatonic_mode(sbi);
 		return 0;
@@ -888,10 +894,12 @@ static int autofs4_root_ioctl_unlocked(s
 
 	/* return a single thing to expire */
 	case AUTOFS_IOC_EXPIRE:
-		return autofs4_expire_run(inode->i_sb,filp->f_path.mnt,sbi, p);
+		return autofs4_expire_run(inode->i_sb,
+					  filp->f_path.mnt, sbi, p);
 	/* same as above, but can send multiple expires through pipe */
 	case AUTOFS_IOC_EXPIRE_MULTI:
-		return autofs4_expire_multi(inode->i_sb,filp->f_path.mnt,sbi, p);
+		return autofs4_expire_multi(inode->i_sb,
+					    filp->f_path.mnt, sbi, p);
 
 	default:
 		return -ENOSYS;
@@ -902,12 +910,13 @@ static long autofs4_root_ioctl(struct fi
 			       unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
+
 	return autofs4_root_ioctl_unlocked(inode, filp, cmd, arg);
 }
 
 #ifdef CONFIG_COMPAT
 static long autofs4_root_compat_ioctl(struct file *filp,
-			     unsigned int cmd, unsigned long arg)
+				      unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
 	int ret;
@@ -916,7 +925,7 @@ static long autofs4_root_compat_ioctl(st
 		ret = autofs4_root_ioctl_unlocked(inode, filp, cmd, arg);
 	else
 		ret = autofs4_root_ioctl_unlocked(inode, filp, cmd,
-			(unsigned long)compat_ptr(arg));
+					      (unsigned long) compat_ptr(arg));
 
 	return ret;
 }
diff -puN fs/autofs4/symlink.c~autofs4-coding-style-fixes fs/autofs4/symlink.c
--- a/fs/autofs4/symlink.c~autofs4-coding-style-fixes
+++ a/fs/autofs4/symlink.c
@@ -1,14 +1,10 @@
-/* -*- c -*- --------------------------------------------------------------- *
- *
- * linux/fs/autofs/symlink.c
- *
- *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
+/*
+ * Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *
  * This file is part of the Linux kernel and is made available under
  * the terms of the GNU General Public License, version 2, or at your
  * option, any later version, incorporated herein by reference.
- *
- * ------------------------------------------------------------------------- */
+ */
 
 #include "autofs_i.h"
 
@@ -18,6 +14,7 @@ static const char *autofs4_get_link(stru
 {
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;
+
 	if (!dentry)
 		return ERR_PTR(-ECHILD);
 	sbi = autofs4_sbi(dentry->d_sb);
diff -puN fs/autofs4/waitq.c~autofs4-coding-style-fixes fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-coding-style-fixes
+++ a/fs/autofs4/waitq.c
@@ -1,15 +1,11 @@
-/* -*- c -*- --------------------------------------------------------------- *
- *
- * linux/fs/autofs/waitq.c
- *
- *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
- *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
+/*
+ * Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
+ * Copyright 2001-2006 Ian Kent <raven@themaw.net>
  *
  * This file is part of the Linux kernel and is made available under
  * the terms of the GNU General Public License, version 2, or at your
  * option, any later version, incorporated herein by reference.
- *
- * ------------------------------------------------------------------------- */
+ */
 
 #include <linux/slab.h>
 #include <linux/time.h>
@@ -18,7 +14,8 @@
 #include "autofs_i.h"
 
 /* We make this a static variable rather than a part of the superblock; it
-   is better if we don't reassign numbers easily even across filesystems */
+ * is better if we don't reassign numbers easily even across filesystems
+ */
 static autofs_wqt_t autofs4_next_wait_queue = 1;
 
 /* These are the signals we allow interrupting a pending mount */
@@ -69,17 +66,19 @@ static int autofs4_write(struct autofs_s
 	set_fs(KERNEL_DS);
 
 	mutex_lock(&sbi->pipe_mutex);
-	while (bytes &&
-	       (wr = __vfs_write(file,data,bytes,&file->f_pos)) > 0) {
+	wr = __vfs_write(file, data, bytes, &file->f_pos);
+	while (bytes && wr) {
 		data += wr;
 		bytes -= wr;
+		wr = __vfs_write(file, data, bytes, &file->f_pos);
 	}
 	mutex_unlock(&sbi->pipe_mutex);
 
 	set_fs(fs);
 
 	/* Keep the currently executing process from receiving a
-	   SIGPIPE unless it was already supposed to get one */
+	 * SIGPIPE unless it was already supposed to get one
+	 */
 	if (wr == -EPIPE && !sigpipe) {
 		spin_lock_irqsave(&current->sighand->siglock, flags);
 		sigdelset(&current->pending.signal, SIGPIPE);
@@ -103,9 +102,10 @@ static void autofs4_notify_daemon(struct
 	size_t pktsz;
 
 	DPRINTK("wait id = 0x%08lx, name = %.*s, type=%d",
-		(unsigned long) wq->wait_queue_token, wq->name.len, wq->name.name, type);
+		(unsigned long) wq->wait_queue_token,
+		wq->name.len, wq->name.name, type);
 
-	memset(&pkt,0,sizeof pkt); /* For security reasons */
+	memset(&pkt, 0, sizeof(pkt)); /* For security reasons */
 
 	pkt.hdr.proto_version = sbi->version;
 	pkt.hdr.type = type;
@@ -126,7 +126,8 @@ static void autofs4_notify_daemon(struct
 	}
 	case autofs_ptype_expire_multi:
 	{
-		struct autofs_packet_expire_multi *ep = &pkt.v4_pkt.expire_multi;
+		struct autofs_packet_expire_multi *ep =
+					&pkt.v4_pkt.expire_multi;
 
 		pktsz = sizeof(*ep);
 
@@ -231,7 +232,7 @@ autofs4_find_wait(struct autofs_sb_info
 		if (wq->name.hash == qstr->hash &&
 		    wq->name.len == qstr->len &&
 		    wq->name.name &&
-			 !memcmp(wq->name.name, qstr->name, qstr->len))
+		    !memcmp(wq->name.name, qstr->name, qstr->len))
 			break;
 	}
 	return wq;
@@ -248,7 +249,7 @@ autofs4_find_wait(struct autofs_sb_info
 static int validate_request(struct autofs_wait_queue **wait,
 			    struct autofs_sb_info *sbi,
 			    struct qstr *qstr,
-			    struct dentry*dentry, enum autofs_notify notify)
+			    struct dentry *dentry, enum autofs_notify notify)
 {
 	struct autofs_wait_queue *wq;
 	struct autofs_info *ino;
@@ -322,8 +323,10 @@ static int validate_request(struct autof
 		 * continue on and create a new request.
 		 */
 		if (!IS_ROOT(dentry)) {
-			if (d_really_is_positive(dentry) && d_unhashed(dentry)) {
+			if (d_unhashed(dentry) &&
+			    d_really_is_positive(dentry)) {
 				struct dentry *parent = dentry->d_parent;
+
 				new = d_lookup(parent, &dentry->d_name);
 				if (new)
 					dentry = new;
@@ -340,8 +343,8 @@ static int validate_request(struct autof
 	return 1;
 }
 
-int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
-		enum autofs_notify notify)
+int autofs4_wait(struct autofs_sb_info *sbi,
+		 struct dentry *dentry, enum autofs_notify notify)
 {
 	struct autofs_wait_queue *wq;
 	struct qstr qstr;
@@ -411,7 +414,7 @@ int autofs4_wait(struct autofs_sb_info *
 
 	if (!wq) {
 		/* Create a new wait queue */
-		wq = kmalloc(sizeof(struct autofs_wait_queue),GFP_KERNEL);
+		wq = kmalloc(sizeof(struct autofs_wait_queue), GFP_KERNEL);
 		if (!wq) {
 			kfree(qstr.name);
 			mutex_unlock(&sbi->wq_mutex);
@@ -454,7 +457,9 @@ int autofs4_wait(struct autofs_sb_info *
 			(unsigned long) wq->wait_queue_token, wq->name.len,
 			wq->name.name, notify);
 
-		/* autofs4_notify_daemon() may block; it will unlock ->wq_mutex */
+		/*
+		 * autofs4_notify_daemon() may block; it will unlock ->wq_mutex
+		 */
 		autofs4_notify_daemon(sbi, wq, type);
 	} else {
 		wq->wait_ctr++;
diff -puN include/linux/auto_dev-ioctl.h~autofs4-coding-style-fixes include/linux/auto_dev-ioctl.h
--- a/include/linux/auto_dev-ioctl.h~autofs4-coding-style-fixes
+++ a/include/linux/auto_dev-ioctl.h
@@ -125,7 +125,6 @@ static inline void init_autofs_dev_ioctl
 	in->ver_minor = AUTOFS_DEV_IOCTL_VERSION_MINOR;
 	in->size = sizeof(struct autofs_dev_ioctl);
 	in->ioctlfd = -1;
-	return;
 }
 
 /*
diff -puN include/linux/auto_fs.h~autofs4-coding-style-fixes include/linux/auto_fs.h
--- a/include/linux/auto_fs.h~autofs4-coding-style-fixes
+++ a/include/linux/auto_fs.h
@@ -1,14 +1,10 @@
-/* -*- linux-c -*- ------------------------------------------------------- *
- *   
- * linux/include/linux/auto_fs.h
- *
- *   Copyright 1997 Transmeta Corporation - All Rights Reserved
+/*
+ * Copyright 1997 Transmeta Corporation - All Rights Reserved
  *
  * This file is part of the Linux kernel and is made available under
  * the terms of the GNU General Public License, version 2, or at your
  * option, any later version, incorporated herein by reference.
- *
- * ----------------------------------------------------------------------- */
+ */
 
 #ifndef _LINUX_AUTO_FS_H
 #define _LINUX_AUTO_FS_H
diff -puN include/uapi/linux/auto_fs.h~autofs4-coding-style-fixes include/uapi/linux/auto_fs.h
--- a/include/uapi/linux/auto_fs.h~autofs4-coding-style-fixes
+++ a/include/uapi/linux/auto_fs.h
@@ -1,7 +1,4 @@
-/* -*- linux-c -*- ------------------------------------------------------- *
- *   
- * linux/include/linux/auto_fs.h
- *
+/*
  *   Copyright 1997 Transmeta Corporation - All Rights Reserved
  *
  * This file is part of the Linux kernel and is made available under
@@ -63,12 +60,12 @@ struct autofs_packet_expire {
 	char name[NAME_MAX+1];
 };
 
-#define AUTOFS_IOC_READY      _IO(0x93,0x60)
-#define AUTOFS_IOC_FAIL       _IO(0x93,0x61)
-#define AUTOFS_IOC_CATATONIC  _IO(0x93,0x62)
-#define AUTOFS_IOC_PROTOVER   _IOR(0x93,0x63,int)
-#define AUTOFS_IOC_SETTIMEOUT32 _IOWR(0x93,0x64,compat_ulong_t)
-#define AUTOFS_IOC_SETTIMEOUT _IOWR(0x93,0x64,unsigned long)
-#define AUTOFS_IOC_EXPIRE     _IOR(0x93,0x65,struct autofs_packet_expire)
+#define AUTOFS_IOC_READY      _IO(0x93, 0x60)
+#define AUTOFS_IOC_FAIL       _IO(0x93, 0x61)
+#define AUTOFS_IOC_CATATONIC  _IO(0x93, 0x62)
+#define AUTOFS_IOC_PROTOVER   _IOR(0x93, 0x63, int)
+#define AUTOFS_IOC_SETTIMEOUT32 _IOWR(0x93, 0x64, compat_ulong_t)
+#define AUTOFS_IOC_SETTIMEOUT _IOWR(0x93, 0x64, unsigned long)
+#define AUTOFS_IOC_EXPIRE     _IOR(0x93, 0x65, struct autofs_packet_expire)
 
 #endif /* _UAPI_LINUX_AUTO_FS_H */
diff -puN include/uapi/linux/auto_fs4.h~autofs4-coding-style-fixes include/uapi/linux/auto_fs4.h
--- a/include/uapi/linux/auto_fs4.h~autofs4-coding-style-fixes
+++ a/include/uapi/linux/auto_fs4.h
@@ -1,6 +1,4 @@
-/* -*- c -*-
- * linux/include/linux/auto_fs4.h
- *
+/*
  * Copyright 1999-2000 Jeremy Fitzhardinge <jeremy@goop.org>
  *
  * This file is part of the Linux kernel and is made available under
@@ -38,7 +36,6 @@
 static inline void set_autofs_type_indirect(unsigned int *type)
 {
 	*type = AUTOFS_TYPE_INDIRECT;
-	return;
 }
 
 static inline unsigned int autofs_type_indirect(unsigned int type)
@@ -49,7 +46,6 @@ static inline unsigned int autofs_type_i
 static inline void set_autofs_type_direct(unsigned int *type)
 {
 	*type = AUTOFS_TYPE_DIRECT;
-	return;
 }
 
 static inline unsigned int autofs_type_direct(unsigned int type)
@@ -60,7 +56,6 @@ static inline unsigned int autofs_type_d
 static inline void set_autofs_type_offset(unsigned int *type)
 {
 	*type = AUTOFS_TYPE_OFFSET;
-	return;
 }
 
 static inline unsigned int autofs_type_offset(unsigned int type)
@@ -81,7 +76,6 @@ static inline unsigned int autofs_type_t
 static inline void set_autofs_type_any(unsigned int *type)
 {
 	*type = AUTOFS_TYPE_ANY;
-	return;
 }
 
 static inline unsigned int autofs_type_any(unsigned int type)
@@ -154,11 +148,10 @@ union autofs_v5_packet_union {
 	autofs_packet_expire_direct_t expire_direct;
 };
 
-#define AUTOFS_IOC_EXPIRE_MULTI		_IOW(0x93,0x66,int)
+#define AUTOFS_IOC_EXPIRE_MULTI		_IOW(0x93, 0x66, int)
 #define AUTOFS_IOC_EXPIRE_INDIRECT	AUTOFS_IOC_EXPIRE_MULTI
 #define AUTOFS_IOC_EXPIRE_DIRECT	AUTOFS_IOC_EXPIRE_MULTI
-#define AUTOFS_IOC_PROTOSUBVER		_IOR(0x93,0x67,int)
-#define AUTOFS_IOC_ASKUMOUNT		_IOR(0x93,0x70,int)
