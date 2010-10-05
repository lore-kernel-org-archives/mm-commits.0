From: akpm@linux-foundation.org
Subject: + vfs-mark-mounts-read-only-on-forced-remount.patch added to -mm tree
Date: Tue, 05 Oct 2010 12:43:04 -0700
Message-ID: <201010051943.o95Jh4AX015797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755537Ab0JETnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 15:43:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     vfs: mark mounts read-only on forced remount
has been added to the -mm tree.  Its filename is
     vfs-mark-mounts-read-only-on-forced-remount.patch

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
Subject: vfs: mark mounts read-only on forced remount
From: Miklos Szeredi <mszeredi@suse.cz>

When the superblock is forcefully remounted read-only, as in case of an
emergency remount or filesystem errors, make sure that the mounts
belonging to the superblock are also marked read-only.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/internal.h  |    1 +
 fs/namespace.c |   16 ++++++++++++++++
 fs/super.c     |   16 ++++++++++++----
 3 files changed, 29 insertions(+), 4 deletions(-)

diff -puN fs/internal.h~vfs-mark-mounts-read-only-on-forced-remount fs/internal.h
--- a/fs/internal.h~vfs-mark-mounts-read-only-on-forced-remount
+++ a/fs/internal.h
@@ -72,6 +72,7 @@ extern struct vfsmount *copy_tree(struct
 extern int sb_prepare_remount_readonly(struct super_block *);
 extern void sb_cancel_remount_readonly(struct super_block *);
 extern void sb_finish_remount_readonly(struct super_block *);
+extern void mark_mounts_readonly(struct super_block *);
 
 extern void __init mnt_init(void);
 
diff -puN fs/namespace.c~vfs-mark-mounts-read-only-on-forced-remount fs/namespace.c
--- a/fs/namespace.c~vfs-mark-mounts-read-only-on-forced-remount
+++ a/fs/namespace.c
@@ -418,7 +418,13 @@ static int mnt_make_writable(struct vfsm
 
 void sb_force_remount_readonly(struct super_block *sb)
 {
+	struct vfsmount *mnt;
+
+	br_write_lock(vfsmount_lock);
+	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance)
+		mnt->mnt_flags |= MNT_READONLY;
 	sb->s_flags |= MS_RDONLY;
+	br_write_unlock(vfsmount_lock);
 }
 EXPORT_SYMBOL(sb_force_remount_readonly);
 
@@ -477,6 +483,16 @@ void sb_finish_remount_readonly(struct s
 	wake_up_all(&sb->s_wait_remount_readonly);
 }
 
+void mark_mounts_readonly(struct super_block *sb)
+{
+	struct vfsmount *mnt;
+
+	br_write_lock(vfsmount_lock);
+	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance)
+		mnt->mnt_flags |= MNT_READONLY;
+	br_write_unlock(vfsmount_lock);
+}
+
 void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
diff -puN fs/super.c~vfs-mark-mounts-read-only-on-forced-remount fs/super.c
--- a/fs/super.c~vfs-mark-mounts-read-only-on-forced-remount
+++ a/fs/super.c
@@ -558,6 +558,7 @@ int do_remount_sb(struct super_block *sb
 {
 	int retval;
 	int remount_ro;
+	bool old_ro;
 
 	if (sb->s_frozen != SB_UNFROZEN)
 		return -EBUSY;
@@ -572,12 +573,14 @@ int do_remount_sb(struct super_block *sb
 	shrink_dcache_sb(sb);
 	sync_filesystem(sb);
 
-	remount_ro = (flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY);
+	old_ro = (sb->s_flags & MS_RDONLY) != 0;
+	remount_ro = (flags & MS_RDONLY) && !old_ro;
 
 	/* If we are remounting RDONLY and current sb is read/write,
 	   make sure there are no rw files opened */
 	if (remount_ro) {
 		if (force) {
+			mark_mounts_readonly(sb);
 			mark_files_ro(sb);
 		} else {
 			retval = sb_prepare_remount_readonly(sb);
@@ -599,9 +602,14 @@ int do_remount_sb(struct super_block *sb
 			return retval;
 		}
 	}
-	if (remount_ro && !force)
-		sb_finish_remount_readonly(sb);
-
+	if (remount_ro) {
+		WARN_ON(!(flags & MS_RDONLY));
+		if (!force)
+			sb_finish_remount_readonly(sb);
+	} else if ((flags & MS_RDONLY) && !old_ro) {
+		/* filesystem remounted r/o without being asked to */
+		sb_force_remount_readonly(sb);
+	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
 
 	/*
_

Patches currently in -mm which might be from mszeredi@suse.cz are

linux-next.patch
vfs-fix-infinite-loop-caused-by-clone_mnt-race.patch
vfs-ignore-error-on-forced-remount.patch
vfs-fix-per-mount-read-write.patch
vfs-add-sb_force_remount_readonly-helper.patch
vfs-allow-mnt_want_write-to-sleep.patch
vfs-allow-mnt_want_write-to-sleep-fix.patch
vfs-keep-list-of-mounts-for-each-superblock.patch
vfs-protect-remounting-superblock-read-only.patch
vfs-fs_may_remount_ro-turn-unnecessary-check-into-a-warn_on.patch
vfs-mark-mounts-read-only-on-forced-remount.patch
fuse-use-clear_highpage-and-km_user0-instead-of-km_user1.patch
fuse-use-release_pages.patch

