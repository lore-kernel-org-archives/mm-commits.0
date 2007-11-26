From: akpm@linux-foundation.org
Subject: - unprivileged-mounts-allow-unprivileged-umount.patch removed from -mm tree
Date: Mon, 26 Nov 2007 11:35:34 -0800
Message-ID: <200711261935.lAQJZY1t019232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51817 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754095AbXKZTgZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 14:36:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hch@lst.de, linuxram@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     unprivileged mounts: allow unprivileged umount
has been removed from the -mm tree.  Its filename was
     unprivileged-mounts-allow-unprivileged-umount.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: unprivileged mounts: allow unprivileged umount
From: Miklos Szeredi <mszeredi@suse.cz>

The owner doesn't need sysadmin capabilities to call umount().

Similar behavior as umount(8) on mounts having "user=UID" option in /etc/mtab.
The difference is that umount also checks /etc/fstab, presumably to exclude
another mount on the same mountpoint.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff -puN fs/namespace.c~unprivileged-mounts-allow-unprivileged-umount fs/namespace.c
--- a/fs/namespace.c~unprivileged-mounts-allow-unprivileged-umount
+++ a/fs/namespace.c
@@ -634,6 +634,27 @@ static int do_umount(struct vfsmount *mn
 	return retval;
 }
 
+static bool is_mount_owner(struct vfsmount *mnt, uid_t uid)
+{
+	return (mnt->mnt_flags & MNT_USER) && mnt->mnt_uid == uid;
+}
+
+/*
+ * umount is permitted for
+ *  - sysadmin
+ *  - mount owner, if not forced umount
+ */
+static bool permit_umount(struct vfsmount *mnt, int flags)
+{
+	if (capable(CAP_SYS_ADMIN))
+		return true;
+
+	if (flags & MNT_FORCE)
+		return false;
+
+	return is_mount_owner(mnt, current->fsuid);
+}
+
 /*
  * Now umount can handle mount points as well as block devices.
  * This is important for filesystems which use unnamed block devices.
@@ -657,7 +678,7 @@ asmlinkage long sys_umount(char __user *
 		goto dput_and_out;
 
 	retval = -EPERM;
-	if (!capable(CAP_SYS_ADMIN))
+	if (!permit_umount(nd.mnt, flags))
 		goto dput_and_out;
 
 	retval = do_umount(nd.mnt, flags);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fuse-fix-reading-past-eof.patch
fuse-cleanup-add-fuse_get_attr_version.patch
fuse-pass-open-flags-to-read-and-write.patch
fuse-fix-fuse_file_ops-sending.patch
fuse-fix-uninitialized-field-in-fuse_inode.patch
fuse-fix-attribute-caching-after-rename.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
