From: akpm@linux-foundation.org
Subject: + reiserfs-delay-reiserfs-lock-until-journal-initialization.patch added to -mm tree
Date: Tue, 22 Nov 2011 12:06:15 -0800
Message-ID: <201111222006.pAMK6G4m004600@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:44076 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab1KVUGc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 15:06:32 -0500
Received: by wwe5 with SMTP id 5so21841wwe.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 12:06:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, hch@lst.de, jeffm@suse.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: reiserfs: delay reiserfs lock until journal initialization
has been added to the -mm tree.  Its filename is
     reiserfs-delay-reiserfs-lock-until-journal-initialization.patch

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
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: reiserfs: delay reiserfs lock until journal initialization

In the mount path, transactions that are made before journal
initialization don't involve the filesystem.  We can delay the reiserfs
lock until we play with the journal.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/bitmap.c |    3 --
 fs/reiserfs/super.c  |   43 ++++++++++++++++++++++-------------------
 2 files changed, 24 insertions(+), 22 deletions(-)

diff -puN fs/reiserfs/bitmap.c~reiserfs-delay-reiserfs-lock-until-journal-initialization fs/reiserfs/bitmap.c
--- a/fs/reiserfs/bitmap.c~reiserfs-delay-reiserfs-lock-until-journal-initialization
+++ a/fs/reiserfs/bitmap.c
@@ -1273,10 +1273,7 @@ int reiserfs_init_bitmap_cache(struct su
 	struct reiserfs_bitmap_info *bitmap;
 	unsigned int bmap_nr = reiserfs_bmap_count(sb);
 
-	/* Avoid lock recursion in fault case */
-	reiserfs_write_unlock(sb);
 	bitmap = vmalloc(sizeof(*bitmap) * bmap_nr);
-	reiserfs_write_lock(sb);
 	if (bitmap == NULL)
 		return -ENOMEM;
 
diff -puN fs/reiserfs/super.c~reiserfs-delay-reiserfs-lock-until-journal-initialization fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~reiserfs-delay-reiserfs-lock-until-journal-initialization
+++ a/fs/reiserfs/super.c
@@ -1655,22 +1655,11 @@ static int reiserfs_fill_super(struct su
 	mutex_init(&REISERFS_SB(s)->lock);
 	REISERFS_SB(s)->lock_depth = -1;
 
-	/*
-	 * This function is called with the bkl, which also was the old
-	 * locking used here.
-	 * do_journal_begin() will soon check if we hold the lock (ie: was the
-	 * bkl). This is likely because do_journal_begin() has several another
-	 * callers because at this time, it doesn't seem to be necessary to
-	 * protect against anything.
-	 * Anyway, let's be conservative and lock for now.
-	 */
-	reiserfs_write_lock(s);
-
 	jdev_name = NULL;
 	if (reiserfs_parse_options
 	    (s, (char *)data, &(sbi->s_mount_opt), &blocks, &jdev_name,
 	     &commit_max_age, qf_names, &qfmt) == 0) {
-		goto error;
+		goto error_unlocked;
 	}
 #ifdef CONFIG_QUOTA
 	handle_quota_files(s, qf_names, &qfmt);
@@ -1678,7 +1667,7 @@ static int reiserfs_fill_super(struct su
 
 	if (blocks) {
 		SWARN(silent, s, "jmacd-7", "resize option for remount only");
-		goto error;
+		goto error_unlocked;
 	}
 
 	/* try old format (undistributed bitmap, super block in 8-th 1k block of a device) */
@@ -1688,7 +1677,7 @@ static int reiserfs_fill_super(struct su
 	else if (read_super_block(s, REISERFS_DISK_OFFSET_IN_BYTES)) {
 		SWARN(silent, s, "sh-2021", "can not find reiserfs on %s",
 		      reiserfs_bdevname(s));
-		goto error;
+		goto error_unlocked;
 	}
 
 	rs = SB_DISK_SUPER_BLOCK(s);
@@ -1704,7 +1693,7 @@ static int reiserfs_fill_super(struct su
 		      "or increase size of your LVM partition");
 		SWARN(silent, s, "", "Or may be you forgot to "
 		      "reboot after fdisk when it told you to");
-		goto error;
+		goto error_unlocked;
 	}
 
 	sbi->s_mount_state = SB_REISERFS_STATE(s);
@@ -1712,8 +1701,9 @@ static int reiserfs_fill_super(struct su
 
 	if ((errval = reiserfs_init_bitmap_cache(s))) {
 		SWARN(silent, s, "jmacd-8", "unable to read bitmap");
-		goto error;
+		goto error_unlocked;
 	}
+
 	errval = -EINVAL;
 #ifdef CONFIG_REISERFS_CHECK
 	SWARN(silent, s, "", "CONFIG_REISERFS_CHECK is set ON");
@@ -1736,6 +1726,17 @@ static int reiserfs_fill_super(struct su
 	if (reiserfs_barrier_flush(s)) {
 		printk("reiserfs: using flush barriers\n");
 	}
+
+	/*
+	 * This path assumed to be called with the BKL in the old times.
+	 * Now we have inherited the big reiserfs lock from it and many
+	 * reiserfs helpers called in the mount path and elsewhere require
+	 * this lock to be held even if it's not always necessary. Let's be
+	 * conservative and hold it early. The window can be reduced after
+	 * careful review of the code.
+	 */
+	reiserfs_write_lock(s);
+
 	// set_device_ro(s->s_dev, 1) ;
 	if (journal_init(s, jdev_name, old_format, commit_max_age)) {
 		SWARN(silent, s, "sh-2022",
@@ -1896,12 +1897,16 @@ static int reiserfs_fill_super(struct su
 	return (0);
 
 error:
-	if (jinit_done) {	/* kill the commit thread, free journal ram */
+	reiserfs_write_unlock(s);
+
+error_unlocked:
+	/* kill the commit thread, free journal ram */
+	if (jinit_done) {
+		reiserfs_write_lock(s);
 		journal_release_error(NULL, s);
+		reiserfs_write_unlock(s);
 	}
 
-	reiserfs_write_unlock(s);
-
 	reiserfs_free_bitmap_cache(s);
 	if (SB_BUFFER_WITH_SB(s))
 		brelse(SB_BUFFER_WITH_SB(s));
_
Subject: Subject: reiserfs: delay reiserfs lock until journal initialization

Patches currently in -mm which might be from fweisbec@gmail.com are

linux-next.patch
reiserfs-delay-reiserfs-lock-until-journal-initialization.patch
reiserfs-dont-lock-journal_init.patch
reiserfs-dont-lock-root-inode-searching.patch
cgroups-add-res_counter_write_u64-api.patch
cgroups-new-resource-counter-inheritance-api.patch
cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks.patch
cgroups-new-cancel_attach_task-subsystem-callback.patch
cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor.patch
cgroups-add-res-counter-common-ancestor-searching.patch
res_counter-allow-charge-failure-pointer-to-be-null.patch
cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch
cgroups-allow-subsystems-to-cancel-a-fork.patch
cgroups-add-a-task-counter-subsystem.patch
cgroups-add-a-task-counter-subsystem-fix.patch
cgroup-fix-task-counter-common-ancestor-logic.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch

