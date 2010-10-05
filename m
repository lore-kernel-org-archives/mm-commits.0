From: akpm@linux-foundation.org
Subject: + vfs-allow-mnt_want_write-to-sleep.patch added to -mm tree
Date: Tue, 05 Oct 2010 12:42:54 -0700
Message-ID: <201010051942.o95JgsdR015710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756189Ab0JETnE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 15:43:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     vfs: allow mnt_want_write() to sleep
has been added to the -mm tree.  Its filename is
     vfs-allow-mnt_want_write-to-sleep.patch

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
Subject: vfs: allow mnt_want_write() to sleep
From: Miklos Szeredi <mszeredi@suse.cz>

Allow mnt_want_write() to sleep.

This is necessary to enable holding off write requests for the duration of
->remount_fs(), which may sleep.

A quick audit didn't turn up any callers from atomic context.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c     |   11 +++++++----
 fs/super.c         |    1 +
 include/linux/fs.h |    5 +++++
 3 files changed, 13 insertions(+), 4 deletions(-)

diff -puN fs/namespace.c~vfs-allow-mnt_want_write-to-sleep fs/namespace.c
--- a/fs/namespace.c~vfs-allow-mnt_want_write-to-sleep
+++ a/fs/namespace.c
@@ -281,8 +281,12 @@ int mnt_want_write(struct vfsmount *mnt)
 	 * incremented count after it has set MNT_WRITE_HOLD.
 	 */
 	smp_mb();
-	while (mnt->mnt_flags & MNT_WRITE_HOLD)
-		cpu_relax();
+	if (unlikely(mnt->mnt_flags & MNT_WRITE_HOLD)) {
+		preempt_enable();
+		wait_event(mnt->mnt_sb->s_wait_remount_readonly,
+			   !(mnt->mnt_flags & MNT_WRITE_HOLD));
+		preempt_disable();
+	}
 	/*
 	 * After the slowpath clears MNT_WRITE_HOLD, mnt_is_readonly will
 	 * be set to match its requirements. So we must not load that until
@@ -292,9 +296,7 @@ int mnt_want_write(struct vfsmount *mnt)
 	if (__mnt_is_readonly(mnt)) {
 		dec_mnt_writers(mnt);
 		ret = -EROFS;
-		goto out;
 	}
-out:
 	preempt_enable();
 	return ret;
 }
@@ -395,6 +397,7 @@ static int mnt_make_readonly(struct vfsm
 	 */
 	smp_wmb();
 	mnt->mnt_flags &= ~MNT_WRITE_HOLD;
+	wake_up_all(&mnt->mnt_sb->s_wait_remount_readonly);
 	br_write_unlock(vfsmount_lock);
 	return ret;
 }
diff -puN fs/super.c~vfs-allow-mnt_want_write-to-sleep fs/super.c
--- a/fs/super.c~vfs-allow-mnt_want_write-to-sleep
+++ a/fs/super.c
@@ -108,6 +108,7 @@ static struct super_block *alloc_super(s
 		mutex_init(&s->s_dquot.dqonoff_mutex);
 		init_rwsem(&s->s_dquot.dqptr_sem);
 		init_waitqueue_head(&s->s_wait_unfrozen);
+		init_waitqueue_head(&s->s_wait_remount_readonly);
 		s->s_maxbytes = MAX_NON_LFS;
 		s->s_op = &default_op;
 		s->s_time_gran = 1000000000;
diff -puN include/linux/fs.h~vfs-allow-mnt_want_write-to-sleep include/linux/fs.h
--- a/include/linux/fs.h~vfs-allow-mnt_want_write-to-sleep
+++ a/include/linux/fs.h
@@ -1380,6 +1380,11 @@ struct super_block {
 	struct mutex s_vfs_rename_mutex;	/* Kludge */
 
 	/*
+	 * Wait queue for remouting read-only
+	 */
+	wait_queue_head_t s_wait_remount_readonly;
+
+	/*
 	 * Filesystem subtype.  If non-empty the filesystem type field
 	 * in /proc/mounts will be "type.subtype"
 	 */
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

