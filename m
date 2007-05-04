From: akpm@linux-foundation.org
Subject: + unprivileged-mounts-allow-unprivileged-umount.patch added to -mm tree
Date: Thu, 03 May 2007 23:07:48 -0700
Message-ID: <200705040607.l4467mLT030288@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767565AbXEDGNM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:13:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de, linuxram@us.ibm.com


The patch titled
     unprivileged mounts: allow unprivileged umount
has been added to the -mm tree.  Its filename is
     unprivileged-mounts-allow-unprivileged-umount.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -639,6 +639,27 @@ static int do_umount(struct vfsmount *mn
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
@@ -662,7 +683,7 @@ asmlinkage long sys_umount(char __user *
 		goto dput_and_out;
 
 	retval = -EPERM;
-	if (!capable(CAP_SYS_ADMIN))
+	if (!permit_umount(nd.mnt, flags))
 		goto dput_and_out;
 
 	retval = do_umount(nd.mnt, flags);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-filesystem-subtype-support.patch
add-file-position-info-to-proc.patch
check-privileges-before-setting-mount-propagation.patch
consolidate-generic_writepages-and-mpage_writepages.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
