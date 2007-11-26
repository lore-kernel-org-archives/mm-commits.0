From: akpm@linux-foundation.org
Subject: - unprivileged-mounts-add-no-submounts-flag.patch removed from -mm tree
Date: Mon, 26 Nov 2007 11:35:48 -0800
Message-ID: <200711261935.lAQJZmdT019255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54127 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754192AbXKZTgR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 14:36:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hch@lst.de, linuxram@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     unprivileged mounts: add "no submounts" flag
has been removed from the -mm tree.  Its filename was
     unprivileged-mounts-add-no-submounts-flag.patch

This patch was dropped because an updated version will be merged

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

 fs/namespace.c        |   10 ++++++++--
 include/linux/fs.h    |    1 +
 include/linux/mount.h |    1 +
 3 files changed, 10 insertions(+), 2 deletions(-)

diff -puN fs/namespace.c~unprivileged-mounts-add-no-submounts-flag fs/namespace.c
--- a/fs/namespace.c~unprivileged-mounts-add-no-submounts-flag
+++ a/fs/namespace.c
@@ -436,6 +436,7 @@ static int show_vfsmnt(struct seq_file *
 		{ MNT_NOATIME, ",noatime" },
 		{ MNT_NODIRATIME, ",nodiratime" },
 		{ MNT_RELATIME, ",relatime" },
+		{ MNT_NOMNT, ",nomnt" },
 		{ 0, NULL }
 	};
 	struct proc_fs_info *fs_infop;
@@ -782,6 +783,9 @@ static bool permit_mount(struct nameidat
 	if (S_ISLNK(inode->i_mode))
 		return false;
 
+	if (nd->mnt->mnt_flags & MNT_NOMNT)
+		return false;
+
 	if (!is_mount_owner(nd->mnt, current->fsuid))
 		return false;
 
@@ -1597,9 +1601,11 @@ long do_mount(char *dev_name, char *dir_
 		mnt_flags |= MNT_NODIRATIME;
 	if (flags & MS_RELATIME)
 		mnt_flags |= MNT_RELATIME;
+	if (flags & MS_NOMNT)
+		mnt_flags |= MNT_NOMNT;
 
-	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
-		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT);
+	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE | MS_NOATIME |
+			MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT | MS_NOMNT);
 
 	/* ... and get the mountpoint */
 	retval = path_lookup(dir_name, LOOKUP_FOLLOW, &nd);
diff -puN include/linux/fs.h~unprivileged-mounts-add-no-submounts-flag include/linux/fs.h
--- a/include/linux/fs.h~unprivileged-mounts-add-no-submounts-flag
+++ a/include/linux/fs.h
@@ -129,6 +129,7 @@ extern int dir_notify_enable;
 #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_SETUSER	(1<<23) /* set mnt_uid to current user */
+#define MS_NOMNT	(1<<24) /* don't allow unprivileged submounts */
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

fuse-fix-reading-past-eof.patch
fuse-cleanup-add-fuse_get_attr_version.patch
fuse-pass-open-flags-to-read-and-write.patch
fuse-fix-fuse_file_ops-sending.patch
fuse-fix-uninitialized-field-in-fuse_inode.patch
fuse-fix-attribute-caching-after-rename.patch
unprivileged-mounts-add-no-submounts-flag.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
