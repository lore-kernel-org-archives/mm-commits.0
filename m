From: akpm@linux-foundation.org
Subject: - autofs4-improve-parameter-usage.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:18:39 -0800
Message-ID: <200901072218.n07MIdOq018100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762063AbZAGWTr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:19:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     autofs4: improve parameter usage
has been removed from the -mm tree.  Its filename was
     autofs4-improve-parameter-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: improve parameter usage
From: Ian Kent <raven@themaw.net>

The parameter usage in the device node ioctl code uses arg1 and arg2 as
parameter names.  This patch redefines the parameter names to reflect what
they actually are in an effort to make the code more readable.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c         |   54 +++++++++++-----------
 include/linux/auto_dev-ioctl.h |   75 +++++++++++++++++++++++++++++--
 2 files changed, 100 insertions(+), 29 deletions(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs4-improve-parameter-usage fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs4-improve-parameter-usage
+++ a/fs/autofs4/dev-ioctl.c
@@ -180,7 +180,7 @@ static int autofs_dev_ioctl_protover(str
 				     struct autofs_sb_info *sbi,
 				     struct autofs_dev_ioctl *param)
 {
-	param->arg1 = sbi->version;
+	param->protover.version = sbi->version;
 	return 0;
 }
 
@@ -189,7 +189,7 @@ static int autofs_dev_ioctl_protosubver(
 					struct autofs_sb_info *sbi,
 					struct autofs_dev_ioctl *param)
 {
-	param->arg1 = sbi->sub_version;
+	param->protosubver.sub_version = sbi->sub_version;
 	return 0;
 }
 
@@ -335,13 +335,13 @@ static int autofs_dev_ioctl_openmount(st
 	int err, fd;
 
 	/* param->path has already been checked */
-	if (!param->arg1)
+	if (!param->openmount.devid)
 		return -EINVAL;
 
 	param->ioctlfd = -1;
 
 	path = param->path;
-	devid = param->arg1;
+	devid = param->openmount.devid;
 
 	err = 0;
 	fd = autofs_dev_ioctl_open_mountpoint(path, devid);
@@ -373,7 +373,7 @@ static int autofs_dev_ioctl_ready(struct
 {
 	autofs_wqt_t token;
 
-	token = (autofs_wqt_t) param->arg1;
+	token = (autofs_wqt_t) param->ready.token;
 	return autofs4_wait_release(sbi, token, 0);
 }
 
@@ -388,8 +388,8 @@ static int autofs_dev_ioctl_fail(struct 
 	autofs_wqt_t token;
 	int status;
 
-	token = (autofs_wqt_t) param->arg1;
-	status = param->arg2 ? param->arg2 : -ENOENT;
+	token = (autofs_wqt_t) param->fail.token;
+	status = param->fail.status ? param->fail.status : -ENOENT;
 	return autofs4_wait_release(sbi, token, status);
 }
 
@@ -412,10 +412,10 @@ static int autofs_dev_ioctl_setpipefd(st
 	int pipefd;
 	int err = 0;
 
-	if (param->arg1 == -1)
+	if (param->setpipefd.pipefd == -1)
 		return -EINVAL;
 
-	pipefd = param->arg1;
+	pipefd = param->setpipefd.pipefd;
 
 	mutex_lock(&sbi->wq_mutex);
 	if (!sbi->catatonic) {
@@ -457,8 +457,8 @@ static int autofs_dev_ioctl_timeout(stru
 {
 	unsigned long timeout;
 
-	timeout = param->arg1;
-	param->arg1 = sbi->exp_timeout / HZ;
+	timeout = param->timeout.timeout;
+	param->timeout.timeout = sbi->exp_timeout / HZ;
 	sbi->exp_timeout = timeout * HZ;
 	return 0;
 }
@@ -489,7 +489,7 @@ static int autofs_dev_ioctl_requester(st
 	path = param->path;
 	devid = sbi->sb->s_dev;
 
-	param->arg1 = param->arg2 = -1;
+	param->requester.uid = param->requester.gid = -1;
 
 	/* Get nameidata of the parent directory */
 	err = path_lookup(path, LOOKUP_PARENT, &nd);
@@ -505,8 +505,8 @@ static int autofs_dev_ioctl_requester(st
 		err = 0;
 		autofs4_expire_wait(nd.path.dentry);
 		spin_lock(&sbi->fs_lock);
-		param->arg1 = ino->uid;
-		param->arg2 = ino->gid;
+		param->requester.uid = ino->uid;
+		param->requester.gid = ino->gid;
 		spin_unlock(&sbi->fs_lock);
 	}
 
@@ -529,7 +529,7 @@ static int autofs_dev_ioctl_expire(struc
 	int err = -EAGAIN;
 	int how;
 
-	how = param->arg1;
+	how = param->expire.how;
 	mnt = fp->f_path.mnt;
 
 	if (sbi->type & AUTOFS_TYPE_TRIGGER)
@@ -565,9 +565,9 @@ static int autofs_dev_ioctl_askumount(st
 				      struct autofs_sb_info *sbi,
 				      struct autofs_dev_ioctl *param)
 {
-	param->arg1 = 0;
+	param->askumount.may_umount = 0;
 	if (may_umount(fp->f_path.mnt))
-		param->arg1 = 1;
+		param->askumount.may_umount = 1;
 	return 0;
 }
 
@@ -600,6 +600,7 @@ static int autofs_dev_ioctl_ismountpoint
 	struct nameidata nd;
 	const char *path;
 	unsigned int type;
+	unsigned int devid, magic;
 	int err = -ENOENT;
 
 	if (param->size <= sizeof(*param)) {
@@ -608,10 +609,10 @@ static int autofs_dev_ioctl_ismountpoint
 	}
 
 	path = param->path;
-	type = param->arg1;
+	type = param->ismountpoint.in.type;
 
-	param->arg1 = 0;
-	param->arg2 = 0;
+	param->ismountpoint.out.devid = devid = 0;
+	param->ismountpoint.out.magic = magic = 0;
 
 	if (!fp || param->ioctlfd == -1) {
 		if (type == AUTOFS_TYPE_ANY) {
@@ -622,7 +623,7 @@ static int autofs_dev_ioctl_ismountpoint
 				goto out;
 
 			sb = nd.path.dentry->d_sb;
-			param->arg1 = new_encode_dev(sb->s_dev);
+			devid = new_encode_dev(sb->s_dev);
 		} else {
 			struct autofs_info *ino;
 
@@ -635,14 +636,14 @@ static int autofs_dev_ioctl_ismountpoint
 				goto out_release;
 
 			ino = autofs4_dentry_ino(nd.path.dentry);
-			param->arg1 = autofs4_get_dev(ino->sbi);
+			devid = autofs4_get_dev(ino->sbi);
 		}
 
 		err = 0;
 		if (nd.path.dentry->d_inode &&
 		    nd.path.mnt->mnt_root == nd.path.dentry) {
 			err = 1;
-			param->arg2 = nd.path.dentry->d_inode->i_sb->s_magic;
+			magic = nd.path.dentry->d_inode->i_sb->s_magic;
 		}
 	} else {
 		dev_t devid = new_encode_dev(sbi->sb->s_dev);
@@ -655,18 +656,21 @@ static int autofs_dev_ioctl_ismountpoint
 		if (err)
 			goto out_release;
 
-		param->arg1 = autofs4_get_dev(sbi);
+		devid = autofs4_get_dev(sbi);
 
 		err = have_submounts(nd.path.dentry);
 
 		if (nd.path.mnt->mnt_mountpoint != nd.path.mnt->mnt_root) {
 			if (follow_down(&nd.path.mnt, &nd.path.dentry)) {
 				struct inode *inode = nd.path.dentry->d_inode;
-				param->arg2 = inode->i_sb->s_magic;
+				magic = inode->i_sb->s_magic;
 			}
 		}
 	}
 
+	param->ismountpoint.out.devid = devid;
+	param->ismountpoint.out.magic = magic;
+
 out_release:
 	path_put(&nd.path);
 out:
diff -puN include/linux/auto_dev-ioctl.h~autofs4-improve-parameter-usage include/linux/auto_dev-ioctl.h
--- a/include/linux/auto_dev-ioctl.h~autofs4-improve-parameter-usage
+++ a/include/linux/auto_dev-ioctl.h
@@ -10,6 +10,7 @@
 #ifndef _LINUX_AUTO_DEV_IOCTL_H
 #define _LINUX_AUTO_DEV_IOCTL_H
 
+#include <linux/string.h>
 #include <linux/types.h>
 
 #define AUTOFS_DEVICE_NAME		"autofs"
@@ -25,6 +26,60 @@
  * An ioctl interface for autofs mount point control.
  */
 
+struct args_protover {
+	__u32	version;
+};
+
+struct args_protosubver {
+	__u32	sub_version;
+};
+
+struct args_openmount {
+	__u32	devid;
+};
+
+struct args_ready {
+	__u32	token;
+};
+
+struct args_fail {
+	__u32	token;
+	__s32	status;
+};
+
+struct args_setpipefd {
+	__s32	pipefd;
+};
+
+struct args_timeout {
+	__u64	timeout;
+};
+
+struct args_requester {
+	__u32	uid;
+	__u32	gid;
+};
+
+struct args_expire {
+	__u32	how;
+};
+
+struct args_askumount {
+	__u32	may_umount;
+};
+
+struct args_ismountpoint {
+	union {
+		struct args_in {
+			__u32	type;
+		} in;
+		struct args_out {
+			__u32	devid;
+			__u32	magic;
+		} out;
+	};
+};
+
 /*
  * All the ioctls use this structure.
  * When sending a path size must account for the total length
@@ -39,20 +94,32 @@ struct autofs_dev_ioctl {
 				 * including this struct */
 	__s32 ioctlfd;		/* automount command fd */
 
-	__u32 arg1;		/* Command parameters */
-	__u32 arg2;
+	/* Command parameters */
+
+	union {
+		struct args_protover		protover;
+		struct args_protosubver		protosubver;
+		struct args_openmount		openmount;
+		struct args_ready		ready;
+		struct args_fail		fail;
+		struct args_setpipefd		setpipefd;
+		struct args_timeout		timeout;
+		struct args_requester		requester;
+		struct args_expire		expire;
+		struct args_askumount		askumount;
+		struct args_ismountpoint	ismountpoint;
+	};
 
 	char path[0];
 };
 
 static inline void init_autofs_dev_ioctl(struct autofs_dev_ioctl *in)
 {
+	memset(in, 0, sizeof(struct autofs_dev_ioctl));
 	in->ver_major = AUTOFS_DEV_IOCTL_VERSION_MAJOR;
 	in->ver_minor = AUTOFS_DEV_IOCTL_VERSION_MINOR;
 	in->size = sizeof(struct autofs_dev_ioctl);
 	in->ioctlfd = -1;
-	in->arg1 = 0;
-	in->arg2 = 0;
 	return;
 }
 
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch

