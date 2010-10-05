From: akpm@linux-foundation.org
Subject: + vfs-keep-list-of-mounts-for-each-superblock.patch added to -mm tree
Date: Tue, 05 Oct 2010 12:42:58 -0700
Message-ID: <201010051942.o95Jgwb3015716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755047Ab0JETnJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 15:43:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     vfs: keep list of mounts for each superblock
has been added to the -mm tree.  Its filename is
     vfs-keep-list-of-mounts-for-each-superblock.patch

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
Subject: vfs: keep list of mounts for each superblock
From: Miklos Szeredi <mszeredi@suse.cz>

Keep track of vfsmounts belonging to a superblock.  List is protected by
vfsmount_lock.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c        |    5 +++++
 fs/super.c            |    7 +++++++
 include/linux/fs.h    |    1 +
 include/linux/mount.h |    1 +
 4 files changed, 14 insertions(+)

diff -puN fs/namespace.c~vfs-keep-list-of-mounts-for-each-superblock fs/namespace.c
--- a/fs/namespace.c~vfs-keep-list-of-mounts-for-each-superblock
+++ a/fs/namespace.c
@@ -638,6 +638,10 @@ static struct vfsmount *clone_mnt(struct
 			if (!list_empty(&old->mnt_expire))
 				list_add(&mnt->mnt_expire, &old->mnt_expire);
 		}
+
+		br_write_lock(vfsmount_lock);
+		list_add_tail(&mnt->mnt_instance, &mnt->mnt_sb->s_mounts);
+		br_write_unlock(vfsmount_lock);
 	}
 	return mnt;
 
@@ -677,6 +681,7 @@ repeat:
 		return;
 	}
 	if (likely(!mnt->mnt_pinned)) {
+		list_del(&mnt->mnt_instance);
 		br_write_unlock(vfsmount_lock);
 		__mntput(mnt);
 		return;
diff -puN fs/super.c~vfs-keep-list-of-mounts-for-each-superblock fs/super.c
--- a/fs/super.c~vfs-keep-list-of-mounts-for-each-superblock
+++ a/fs/super.c
@@ -75,6 +75,7 @@ static struct super_block *alloc_super(s
 		INIT_HLIST_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
 		INIT_LIST_HEAD(&s->s_dentry_lru);
+		INIT_LIST_HEAD(&s->s_mounts);
 		init_rwsem(&s->s_umount);
 		mutex_init(&s->s_lock);
 		lockdep_set_class(&s->s_umount, &type->s_umount_key);
@@ -130,6 +131,7 @@ static inline void destroy_super(struct 
 	free_percpu(s->s_files);
 #endif
 	security_sb_free(s);
+	WARN_ON(!list_empty(&s->s_mounts));
 	kfree(s->s_subtype);
 	kfree(s->s_options);
 	kfree(s);
@@ -972,6 +974,11 @@ vfs_kern_mount(struct file_system_type *
 	mnt->mnt_parent = mnt;
 	up_write(&mnt->mnt_sb->s_umount);
 	free_secdata(secdata);
+
+	br_write_lock(vfsmount_lock);
+	list_add_tail(&mnt->mnt_instance, &mnt->mnt_sb->s_mounts);
+	br_write_unlock(vfsmount_lock);
+
 	return mnt;
 out_sb:
 	dput(mnt->mnt_root);
diff -puN include/linux/fs.h~vfs-keep-list-of-mounts-for-each-superblock include/linux/fs.h
--- a/include/linux/fs.h~vfs-keep-list-of-mounts-for-each-superblock
+++ a/include/linux/fs.h
@@ -1351,6 +1351,7 @@ struct super_block {
 #else
 	struct list_head	s_files;
 #endif
+	struct list_head	s_mounts;	/* list of mounts */
 	/* s_dentry_lru and s_nr_dentry_unused are protected by dcache_lock */
 	struct list_head	s_dentry_lru;	/* unused dentry lru */
 	int			s_nr_dentry_unused;	/* # of dentry on lru */
diff -puN include/linux/mount.h~vfs-keep-list-of-mounts-for-each-superblock include/linux/mount.h
--- a/include/linux/mount.h~vfs-keep-list-of-mounts-for-each-superblock
+++ a/include/linux/mount.h
@@ -54,6 +54,7 @@ struct vfsmount {
 	struct super_block *mnt_sb;	/* pointer to superblock */
 	struct list_head mnt_mounts;	/* list of children, anchored here */
 	struct list_head mnt_child;	/* and going through their mnt_child */
+	struct list_head mnt_instance;	/* mount instance on sb->s_mounts */
 	int mnt_flags;
 	/* 4 bytes hole on 64bits arches without fsnotify */
 #ifdef CONFIG_FSNOTIFY
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

