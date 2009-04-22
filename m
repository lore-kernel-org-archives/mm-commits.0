From: akpm@linux-foundation.org
Subject: [merged] btrfs-use-memdup_user.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:31:01 -0700
Message-ID: <200904221831.n3MIV1k4006512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341AbZDVSdn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:33:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, chris.mason@oracle.com, mm-commits@vger.kernel.org


The patch titled
     btrfs: use memdup_user()
has been removed from the -mm tree.  Its filename was
     btrfs-use-memdup_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: btrfs: use memdup_user()
From: Li Zefan <lizf@cn.fujitsu.com>

Remove open-coded memdup_user().

Note this changes some GFP_NOFS to GFP_KERNEL, since copy_from_user() may
cause pagefault, it's pointless to pass GFP_NOFS to kmalloc().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/ioctl.c |   49 +++++++++++----------------------------------
 fs/btrfs/super.c |   13 +++--------
 2 files changed, 16 insertions(+), 46 deletions(-)

diff -puN fs/btrfs/ioctl.c~btrfs-use-memdup_user fs/btrfs/ioctl.c
--- a/fs/btrfs/ioctl.c~btrfs-use-memdup_user
+++ a/fs/btrfs/ioctl.c
@@ -461,15 +461,9 @@ static int btrfs_ioctl_resize(struct btr
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	vol_args = kmalloc(sizeof(*vol_args), GFP_NOFS);
-
-	if (!vol_args)
-		return -ENOMEM;
-
-	if (copy_from_user(vol_args, arg, sizeof(*vol_args))) {
-		ret = -EFAULT;
-		goto out;
-	}
+	vol_args = memdup_user(arg, sizeof(*vol_args));
+	if (IS_ERR(vol_args))
+		return PTR_ERR(vol_args);
 
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 	namelen = strlen(vol_args->name);
@@ -545,7 +539,6 @@ static int btrfs_ioctl_resize(struct btr
 
 out_unlock:
 	mutex_unlock(&root->fs_info->volume_mutex);
-out:
 	kfree(vol_args);
 	return ret;
 }
@@ -565,15 +558,9 @@ static noinline int btrfs_ioctl_snap_cre
 	if (root->fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
 
-	vol_args = kmalloc(sizeof(*vol_args), GFP_NOFS);
-
-	if (!vol_args)
-		return -ENOMEM;
-
-	if (copy_from_user(vol_args, arg, sizeof(*vol_args))) {
-		ret = -EFAULT;
-		goto out;
-	}
+	vol_args = memdup_user(arg, sizeof(*vol_args));
+	if (IS_ERR(vol_args))
+		return PTR_ERR(vol_args);
 
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 	namelen = strlen(vol_args->name);
@@ -675,19 +662,13 @@ static long btrfs_ioctl_add_dev(struct b
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	vol_args = kmalloc(sizeof(*vol_args), GFP_NOFS);
+	vol_args = memdup_user(arg, sizeof(*vol_args));
+	if (IS_ERR(vol_args))
+		return PTR_ERR(vol_args);
 
-	if (!vol_args)
-		return -ENOMEM;
-
-	if (copy_from_user(vol_args, arg, sizeof(*vol_args))) {
-		ret = -EFAULT;
-		goto out;
-	}
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 	ret = btrfs_init_new_device(root, vol_args->name);
 
-out:
 	kfree(vol_args);
 	return ret;
 }
@@ -703,19 +684,13 @@ static long btrfs_ioctl_rm_dev(struct bt
 	if (root->fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
 
-	vol_args = kmalloc(sizeof(*vol_args), GFP_NOFS);
+	vol_args = memdup_user(arg, sizeof(*vol_args));
+	if (IS_ERR(vol_args))
+		return PTR_ERR(vol_args);
 
-	if (!vol_args)
-		return -ENOMEM;
-
-	if (copy_from_user(vol_args, arg, sizeof(*vol_args))) {
-		ret = -EFAULT;
-		goto out;
-	}
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 	ret = btrfs_rm_device(root, vol_args->name);
 
-out:
 	kfree(vol_args);
 	return ret;
 }
diff -puN fs/btrfs/super.c~btrfs-use-memdup_user fs/btrfs/super.c
--- a/fs/btrfs/super.c~btrfs-use-memdup_user
+++ a/fs/btrfs/super.c
@@ -635,14 +635,9 @@ static long btrfs_control_ioctl(struct f
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	vol = kmalloc(sizeof(*vol), GFP_KERNEL);
-	if (!vol)
-		return -ENOMEM;
-
-	if (copy_from_user(vol, (void __user *)arg, sizeof(*vol))) {
-		ret = -EFAULT;
-		goto out;
-	}
+	vol = memdup_user((void __user *)arg, sizeof(*vol));
+	if (IS_ERR(vol))
+		return PTR_ERR(vol);
 
 	switch (cmd) {
 	case BTRFS_IOC_SCAN_DEV:
@@ -650,7 +645,7 @@ static long btrfs_control_ioctl(struct f
 					    &btrfs_fs_type, &fs_devices);
 		break;
 	}
-out:
+
 	kfree(vol);
 	return ret;
 }
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch
devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem.patch

