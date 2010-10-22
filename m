From: akpm@linux-foundation.org
Subject: + vfs-protect-remounting-superblock-read-only-update.patch added to -mm tree
Date: Fri, 22 Oct 2010 12:34:21 -0700
Message-ID: <201010221934.o9MJYLea003019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758520Ab0JVTfC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Oct 2010 15:35:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     vfs-protect-remounting-superblock-read-only-update.txt
has been added to the -mm tree.  Its filename is
     vfs-protect-remounting-superblock-read-only-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs-protect-remounting-superblock-read-only-update.txt
From: Miklos Szeredi <mszeredi@suse.cz>

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c        |   41 ++++++++++++++++++++--------------------
 include/linux/mount.h |    1 
 2 files changed, 22 insertions(+), 20 deletions(-)

diff -puN fs/namespace.c~vfs-protect-remounting-superblock-read-only-update fs/namespace.c
--- a/fs/namespace.c~vfs-protect-remounting-superblock-read-only-update
+++ a/fs/namespace.c
@@ -438,11 +438,17 @@ int sb_prepare_remount_readonly(struct s
 			}
 		}
 	}
+	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance) {
+		if (mnt->mnt_flags & MNT_WRITE_HOLD) {
+			if (!err) {
+				mnt->mnt_flags |= MNT_READONLY | MNT_WAS_WRITE;
+				smp_wmb();
+			}
+			mnt->mnt_flags &= ~MNT_WRITE_HOLD;
+		}
+	}
 	br_write_unlock(vfsmount_lock);
 
-	if (err)
-		sb_cancel_remount_readonly(sb);
-
 	return err;
 }
 
@@ -452,12 +458,11 @@ void sb_cancel_remount_readonly(struct s
 
 	br_write_lock(vfsmount_lock);
 	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance) {
-		if (mnt->mnt_flags & MNT_WRITE_HOLD)
-			mnt->mnt_flags &= ~MNT_WRITE_HOLD;
+		if (mnt->mnt_flags & MNT_WAS_WRITE)
+			mnt->mnt_flags &= ~(MNT_WAS_WRITE | MNT_READONLY);
 	}
 
 	br_write_unlock(vfsmount_lock);
-	wake_up_all(&sb->s_wait_remount_readonly);
 }
 
 void sb_finish_remount_readonly(struct super_block *sb)
@@ -466,15 +471,11 @@ void sb_finish_remount_readonly(struct s
 
 	br_write_lock(vfsmount_lock);
 	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance) {
-		if (!(mnt->mnt_flags & MNT_READONLY)) {
-			mnt->mnt_flags |= MNT_READONLY;
-			smp_wmb();
-			mnt->mnt_flags &= ~MNT_WRITE_HOLD;
-		}
+		if (mnt->mnt_flags & MNT_WAS_WRITE)
+			mnt->mnt_flags &= ~MNT_WAS_WRITE;
 	}
 	sb->s_flags |= MS_RDONLY;
 	br_write_unlock(vfsmount_lock);
-	wake_up_all(&sb->s_wait_remount_readonly);
 }
 
 void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
@@ -1844,6 +1845,14 @@ int do_add_mount(struct vfsmount *newmnt
 
 	mnt_flags &= ~(MNT_SHARED | MNT_WRITE_HOLD | MNT_INTERNAL);
 
+	/* Locking is necessary to prevent racing with remount r/o */
+	down_read(&newmnt->mnt_sb->s_umount);
+	if (newmnt->mnt_sb->s_flags & MS_RDONLY)
+		mnt_flags |= MNT_READONLY;
+
+	newmnt->mnt_flags = mnt_flags;
+	up_read(&newmnt->mnt_sb->s_umount);
+
 	down_write(&namespace_sem);
 	/* Something was mounted here while we slept */
 	while (d_mountpoint(path->dentry) &&
@@ -1863,14 +1872,6 @@ int do_add_mount(struct vfsmount *newmnt
 	if (S_ISLNK(newmnt->mnt_root->d_inode->i_mode))
 		goto unlock;
 
-	/* Locking is necessary to prevent racing with remount r/o */
-	br_read_lock(vfsmount_lock);
-	if (newmnt->mnt_sb->s_flags & MS_RDONLY)
-		mnt_flags |= MNT_READONLY;
-
-	newmnt->mnt_flags = mnt_flags;
-	br_read_unlock(vfsmount_lock);
-
 	if ((err = graft_tree(newmnt, path)))
 		goto unlock;
 
diff -puN include/linux/mount.h~vfs-protect-remounting-superblock-read-only-update include/linux/mount.h
--- a/include/linux/mount.h~vfs-protect-remounting-superblock-read-only-update
+++ a/include/linux/mount.h
@@ -30,6 +30,7 @@ struct mnt_namespace;
 
 #define MNT_SHRINKABLE	0x100
 #define MNT_WRITE_HOLD	0x200
+#define MNT_WAS_WRITE	0x400   /* used by remount to remember write mounts */
 
 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
vfs-fix-infinite-loop-caused-by-clone_mnt-race.patch
vfs-ignore-error-on-forced-remount.patch
vfs-fix-per-mount-read-write.patch
vfs-add-sb_force_remount_readonly-helper.patch
vfs-allow-mnt_want_write-to-sleep.patch
vfs-keep-list-of-mounts-for-each-superblock.patch
vfs-protect-remounting-superblock-read-only.patch
vfs-protect-remounting-superblock-read-only-update.patch
vfs-fs_may_remount_ro-turn-unnecessary-check-into-a-warn_on.patch
vfs-mark-mounts-read-only-on-forced-remount.patch
fuse-use-clear_highpage-and-km_user0-instead-of-km_user1.patch
fuse-use-release_pages.patch

