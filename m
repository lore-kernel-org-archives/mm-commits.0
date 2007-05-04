From: akpm@linux-foundation.org
Subject: + unprivileged-mounts-add-no-submounts-flag.patch added to -mm tree
Date: Thu, 03 May 2007 23:08:04 -0700
Message-ID: <200705040608.l44684Y4030317@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754502AbXEDGNY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:13:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de, linuxram@us.ibm.com


The patch titled
     unprivileged mounts: add "no submounts" flag
has been added to the -mm tree.  Its filename is
     unprivileged-mounts-add-no-submounts-flag.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: unprivileged mounts: add "no submounts" flag
From: Miklos Szeredi <mszeredi@suse.cz>

Add a new mount flag "nomnt", which denies submounts for the owner.
This would be useful, if we want to support traditional /etc/fstab
based user mounts.

In this case mount(8) would still have to be suid-root, to check the
mountpoint against the user/users flag in /etc/fstab, but /etc/mtab
would no longer be mandatory for storing the actual owner of the
mount.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c        |    8 +++++++-
 include/linux/fs.h    |    1 +
 include/linux/mount.h |    1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

diff -puN fs/namespace.c~unprivileged-mounts-add-no-submounts-flag fs/namespace.c
--- a/fs/namespace.c~unprivileged-mounts-add-no-submounts-flag
+++ a/fs/namespace.c
@@ -441,6 +441,7 @@ static int show_vfsmnt(struct seq_file *
 		{ MNT_NOATIME, ",noatime" },
 		{ MNT_NODIRATIME, ",nodiratime" },
 		{ MNT_RELATIME, ",relatime" },
+		{ MNT_NOMNT, ",nomnt" },
 		{ 0, NULL }
 	};
 	struct proc_fs_info *fs_infop;
@@ -787,6 +788,9 @@ static bool permit_mount(struct nameidat
 	if (S_ISLNK(inode->i_mode))
 		return false;
 
+	if (nd->mnt->mnt_flags & MNT_NOMNT)
+		return false;
+
 	if (!is_mount_owner(nd->mnt, current->fsuid))
 		return false;
 
@@ -1556,9 +1560,11 @@ long do_mount(char *dev_name, char *dir_
 		mnt_flags |= MNT_NODIRATIME;
 	if (flags & MS_RELATIME)
 		mnt_flags |= MNT_RELATIME;
+	if (flags & MS_NOMNT)
+		mnt_flags |= MNT_NOMNT;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
-		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME);
+		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME | MS_NOMNT);
 
 	/* ... and get the mountpoint */
 	retval = path_lookup(dir_name, LOOKUP_FOLLOW, &nd);
diff -puN include/linux/fs.h~unprivileged-mounts-add-no-submounts-flag include/linux/fs.h
--- a/include/linux/fs.h~unprivileged-mounts-add-no-submounts-flag
+++ a/include/linux/fs.h
@@ -128,6 +128,7 @@ extern int dir_notify_enable;
 #define MS_SHARED	(1<<20)	/* change to shared */
 #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
 #define MS_SETUSER	(1<<22) /* set mnt_uid to current user */
+#define MS_NOMNT	(1<<23) /* don't allow unprivileged submounts */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 
diff -puN include/linux/mount.h~unprivileged-mounts-add-no-submounts-flag include/linux/mount.h
--- a/include/linux/mount.h~unprivileged-mounts-add-no-submounts-flag
+++ a/include/linux/mount.h
@@ -28,6 +28,7 @@ struct mnt_namespace;
 #define MNT_NOATIME	0x08
 #define MNT_NODIRATIME	0x10
 #define MNT_RELATIME	0x20
+#define MNT_NOMNT	0x40
 
 #define MNT_SHRINKABLE	0x100
 #define MNT_USER	0x200
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
