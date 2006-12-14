From: akpm@osdl.org
Subject: - relative-atime.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:08:12 -0800
Message-ID: <200612140608.kBE68CSc001931@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52077 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbWLNGIw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:08:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: val_henson@linux.intel.com, hch@lst.de, kzak@redhat.com, mark.fasheh@oracle.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     relative atime
has been removed from the -mm tree.  Its filename was
     relative-atime.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: relative atime
From: Valerie Henson <val_henson@linux.intel.com>

Add "relatime" (relative atime) support.  Relative atime only updates the
atime if the previous atime is older than the mtime or ctime.  Like
noatime, but useful for applications like mutt that need to know when a
file has been read since it was last modified.

A corresponding patch against mount(8) is available at
http://userweb.kernel.org/~akpm/mount-relative-atime.txt

Signed-off-by: Valerie Henson <val_henson@linux.intel.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Karel Zak <kzak@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/inode.c            |   22 ++++++++++++++++++----
 fs/namespace.c        |    5 ++++-
 include/linux/fs.h    |    1 +
 include/linux/mount.h |    1 +
 4 files changed, 24 insertions(+), 5 deletions(-)

diff -puN fs/inode.c~relative-atime fs/inode.c
--- a/fs/inode.c~relative-atime
+++ a/fs/inode.c
@@ -1177,13 +1177,27 @@ void touch_atime(struct vfsmount *mnt, s
 			return;
 		if ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode))
 			return;
+
+		if (mnt->mnt_flags & MNT_RELATIME) {
+			/*
+			 * With relative atime, only update atime if the
+			 * previous atime is earlier than either the ctime or
+			 * mtime.
+			 */
+			if (timespec_compare(&inode->i_mtime,
+						&inode->i_atime) < 0 &&
+			    timespec_compare(&inode->i_ctime,
+						&inode->i_atime) < 0)
+				return;
+		}
 	}
 
 	now = current_fs_time(inode->i_sb);
-	if (!timespec_equal(&inode->i_atime, &now)) {
-		inode->i_atime = now;
-		mark_inode_dirty_sync(inode);
-	}
+	if (timespec_equal(&inode->i_atime, &now))
+		return;
+
+	inode->i_atime = now;
+	mark_inode_dirty_sync(inode);
 }
 EXPORT_SYMBOL(touch_atime);
 
diff -puN fs/namespace.c~relative-atime fs/namespace.c
--- a/fs/namespace.c~relative-atime
+++ a/fs/namespace.c
@@ -368,6 +368,7 @@ static int show_vfsmnt(struct seq_file *
 		{ MNT_NOEXEC, ",noexec" },
 		{ MNT_NOATIME, ",noatime" },
 		{ MNT_NODIRATIME, ",nodiratime" },
+		{ MNT_RELATIME, ",relatime" },
 		{ 0, NULL }
 	};
 	struct proc_fs_info *fs_infop;
@@ -1405,9 +1406,11 @@ long do_mount(char *dev_name, char *dir_
 		mnt_flags |= MNT_NOATIME;
 	if (flags & MS_NODIRATIME)
 		mnt_flags |= MNT_NODIRATIME;
+	if (flags & MS_RELATIME)
+		mnt_flags |= MNT_RELATIME;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
-		   MS_NOATIME | MS_NODIRATIME);
+		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME);
 
 	/* ... and get the mountpoint */
 	retval = path_lookup(dir_name, LOOKUP_FOLLOW, &nd);
diff -puN include/linux/fs.h~relative-atime include/linux/fs.h
--- a/include/linux/fs.h~relative-atime
+++ a/include/linux/fs.h
@@ -120,6 +120,7 @@ extern int dir_notify_enable;
 #define MS_PRIVATE	(1<<18)	/* change to private */
 #define MS_SLAVE	(1<<19)	/* change to slave */
 #define MS_SHARED	(1<<20)	/* change to shared */
+#define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 
diff -puN include/linux/mount.h~relative-atime include/linux/mount.h
--- a/include/linux/mount.h~relative-atime
+++ a/include/linux/mount.h
@@ -27,6 +27,7 @@ struct mnt_namespace;
 #define MNT_NOEXEC	0x04
 #define MNT_NOATIME	0x08
 #define MNT_NODIRATIME	0x10
+#define MNT_RELATIME	0x20
 
 #define MNT_SHRINKABLE	0x100
 
_

Patches currently in -mm which might be from val_henson@linux.intel.com are

tulip-fix-shutdown-dma-irq-race.patch
tulip-fix-for-64-bit-mips.patch
tulip-natsemi-dp83840a-phy-fix.patch
ext2-reservations.patch

