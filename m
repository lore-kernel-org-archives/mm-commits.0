From: akpm@linux-foundation.org
Subject: [merged] reiserfs-delay-reiserfs-lock-until-journal-initialization.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:32:54 -0800
Message-ID: <20120111213255.0094A5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:43465 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163Ab2AKVc4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:32:56 -0500
Received: by mail-ee0-f74.google.com with SMTP id d41so44375eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:32:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, hch@lst.de, jack@suse.cz, jeffm@suse.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: reiserfs: delay reiserfs lock until journal initialization
has been removed from the -mm tree.  Its filename was
     reiserfs-delay-reiserfs-lock-until-journal-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/bitmap.c |    3 --
 fs/reiserfs/super.c  |   43 ++++++++++++++++++++++-------------------
 2 files changed, 24 insertions(+), 22 deletions(-)

diff -puN fs/reiserfs/bitmap.c~reiserfs-delay-reiserfs-lock-until-journal-initialization fs/reiserfs/bitmap.c
--- a/fs/reiserfs/bitmap.c~reiserfs-delay-reiserfs-lock-until-journal-initialization
+++ a/fs/reiserfs/bitmap.c
@@ -1364,10 +1364,7 @@ int reiserfs_init_bitmap_cache(struct su
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
@@ -1746,22 +1746,11 @@ static int reiserfs_fill_super(struct su
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
 	if (jdev_name && jdev_name[0]) {
 		REISERFS_SB(s)->s_jdev = kstrdup(jdev_name, GFP_KERNEL);
@@ -1777,7 +1766,7 @@ static int reiserfs_fill_super(struct su
 
 	if (blocks) {
 		SWARN(silent, s, "jmacd-7", "resize option for remount only");
-		goto error;
+		goto error_unlocked;
 	}
 
 	/* try old format (undistributed bitmap, super block in 8-th 1k block of a device) */
@@ -1787,7 +1776,7 @@ static int reiserfs_fill_super(struct su
 	else if (read_super_block(s, REISERFS_DISK_OFFSET_IN_BYTES)) {
 		SWARN(silent, s, "sh-2021", "can not find reiserfs on %s",
 		      reiserfs_bdevname(s));
-		goto error;
+		goto error_unlocked;
 	}
 
 	rs = SB_DISK_SUPER_BLOCK(s);
@@ -1803,7 +1792,7 @@ static int reiserfs_fill_super(struct su
 		      "or increase size of your LVM partition");
 		SWARN(silent, s, "", "Or may be you forgot to "
 		      "reboot after fdisk when it told you to");
-		goto error;
+		goto error_unlocked;
 	}
 
 	sbi->s_mount_state = SB_REISERFS_STATE(s);
@@ -1811,8 +1800,9 @@ static int reiserfs_fill_super(struct su
 
 	if ((errval = reiserfs_init_bitmap_cache(s))) {
 		SWARN(silent, s, "jmacd-8", "unable to read bitmap");
-		goto error;
+		goto error_unlocked;
 	}
+
 	errval = -EINVAL;
 #ifdef CONFIG_REISERFS_CHECK
 	SWARN(silent, s, "", "CONFIG_REISERFS_CHECK is set ON");
@@ -1835,6 +1825,17 @@ static int reiserfs_fill_super(struct su
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
@@ -1995,12 +1996,16 @@ static int reiserfs_fill_super(struct su
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
