From: akpm@linux-foundation.org
Subject: + reiserfs-dont-lock-journal_init.patch added to -mm tree
Date: Tue, 22 Nov 2011 12:06:31 -0800
Message-ID: <201111222006.pAMK6WIP006545@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:44076 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab1KVUGf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 15:06:35 -0500
Received: by mail-ww0-f74.google.com with SMTP id 5so21841wwe.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 12:06:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, hch@lst.de, jeffm@suse.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: reiserfs: don't lock journal_init()
has been added to the -mm tree.  Its filename is
     reiserfs-dont-lock-journal_init.patch

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
Subject: reiserfs: don't lock journal_init()

journal_init() doesn't need the lock since no operation on the filesystem
is involved there.  journal_read() and get_list_bitmap() have yet to be
reviewed carefully though before removing the lock there.  Just keep the
it around these two calls for safety.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/journal.c |   53 +++++++++++++++-------------------------
 fs/reiserfs/super.c   |   21 ++++++++-------
 2 files changed, 31 insertions(+), 43 deletions(-)

diff -puN fs/reiserfs/journal.c~reiserfs-dont-lock-journal_init fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c~reiserfs-dont-lock-journal_init
+++ a/fs/reiserfs/journal.c
@@ -2678,16 +2678,10 @@ int journal_init(struct super_block *sb,
 	char b[BDEVNAME_SIZE];
 	int ret;
 
-	/*
-	 * Unlock here to avoid various RECLAIM-FS-ON <-> IN-RECLAIM-FS
-	 * dependency inversion warnings.
-	 */
-	reiserfs_write_unlock(sb);
 	journal = SB_JOURNAL(sb) = vzalloc(sizeof(struct reiserfs_journal));
 	if (!journal) {
 		reiserfs_warning(sb, "journal-1256",
 				 "unable to get memory for journal structure");
-		reiserfs_write_lock(sb);
 		return 1;
 	}
 	INIT_LIST_HEAD(&journal->j_bitmap_nodes);
@@ -2695,10 +2689,8 @@ int journal_init(struct super_block *sb,
 	INIT_LIST_HEAD(&journal->j_working_list);
 	INIT_LIST_HEAD(&journal->j_journal_list);
 	journal->j_persistent_trans = 0;
-	ret = reiserfs_allocate_list_bitmaps(sb, journal->j_list_bitmap,
-					   reiserfs_bmap_count(sb));
-	reiserfs_write_lock(sb);
-	if (ret)
+	if (reiserfs_allocate_list_bitmaps(sb, journal->j_list_bitmap,
+					   reiserfs_bmap_count(sb)))
 		goto free_and_return;
 
 	allocate_bitmap_nodes(sb);
@@ -2727,27 +2719,11 @@ int journal_init(struct super_block *sb,
 		goto free_and_return;
 	}
 
-	/*
-	 * We need to unlock here to avoid creating the following
-	 * dependency:
-	 * reiserfs_lock -> sysfs_mutex
-	 * Because the reiserfs mmap path creates the following dependency:
-	 * mm->mmap -> reiserfs_lock, hence we have
-	 * mm->mmap -> reiserfs_lock ->sysfs_mutex
-	 * This would ends up in a circular dependency with sysfs readdir path
-	 * which does sysfs_mutex -> mm->mmap_sem
-	 * This is fine because the reiserfs lock is useless in mount path,
-	 * at least until we call journal_begin. We keep it for paranoid
-	 * reasons.
-	 */
-	reiserfs_write_unlock(sb);
 	if (journal_init_dev(sb, journal, j_dev_name) != 0) {
-		reiserfs_write_lock(sb);
 		reiserfs_warning(sb, "sh-462",
 				 "unable to initialize jornal device");
 		goto free_and_return;
 	}
-	reiserfs_write_lock(sb);
 
 	rs = SB_DISK_SUPER_BLOCK(sb);
 
@@ -2829,9 +2805,7 @@ int journal_init(struct super_block *sb,
 	journal->j_mount_id = 10;
 	journal->j_state = 0;
 	atomic_set(&(journal->j_jlock), 0);
-	reiserfs_write_unlock(sb);
 	journal->j_cnode_free_list = allocate_cnodes(num_cnodes);
-	reiserfs_write_lock(sb);
 	journal->j_cnode_free_orig = journal->j_cnode_free_list;
 	journal->j_cnode_free = journal->j_cnode_free_list ? num_cnodes : 0;
 	journal->j_cnode_used = 0;
@@ -2848,24 +2822,37 @@ int journal_init(struct super_block *sb,
 
 	init_journal_hash(sb);
 	jl = journal->j_current_jl;
+
+	/*
+	 * get_list_bitmap() may call flush_commit_list() which
+	 * requires the lock. Calling flush_commit_list() shouldn't happen
+	 * this early but I like to be paranoid.
+	 */
+	reiserfs_write_lock(sb);
 	jl->j_list_bitmap = get_list_bitmap(sb, jl);
+	reiserfs_write_unlock(sb);
 	if (!jl->j_list_bitmap) {
 		reiserfs_warning(sb, "journal-2005",
 				 "get_list_bitmap failed for journal list 0");
 		goto free_and_return;
 	}
-	if (journal_read(sb) < 0) {
+
+	/*
+	 * Journal_read needs to be inspected in order to push down
+	 * the lock further inside (or even remove it).
+	 */
+	reiserfs_write_lock(sb);
+	ret = journal_read(sb);
+	reiserfs_write_unlock(sb);
+	if (ret < 0) {
 		reiserfs_warning(sb, "reiserfs-2006",
 				 "Replay Failure, unable to mount");
 		goto free_and_return;
 	}
 
 	reiserfs_mounted_fs_count++;
-	if (reiserfs_mounted_fs_count <= 1) {
-		reiserfs_write_unlock(sb);
+	if (reiserfs_mounted_fs_count <= 1)
 		commit_wq = alloc_workqueue("reiserfs", WQ_MEM_RECLAIM, 0);
-		reiserfs_write_lock(sb);
-	}
 
 	INIT_DELAYED_WORK(&journal->j_work, flush_async_commits);
 	journal->j_work_sb = sb;
diff -puN fs/reiserfs/super.c~reiserfs-dont-lock-journal_init fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~reiserfs-dont-lock-journal_init
+++ a/fs/reiserfs/super.c
@@ -1727,6 +1727,17 @@ static int reiserfs_fill_super(struct su
 		printk("reiserfs: using flush barriers\n");
 	}
 
+	// set_device_ro(s->s_dev, 1) ;
+	if (journal_init(s, jdev_name, old_format, commit_max_age)) {
+		SWARN(silent, s, "sh-2022",
+		      "unable to initialize journal space");
+		goto error_unlocked;
+	} else {
+		jinit_done = 1;	/* once this is set, journal_release must be called
+				 ** if we error out of the mount
+				 */
+	}
+
 	/*
 	 * This path assumed to be called with the BKL in the old times.
 	 * Now we have inherited the big reiserfs lock from it and many
@@ -1737,16 +1748,6 @@ static int reiserfs_fill_super(struct su
 	 */
 	reiserfs_write_lock(s);
 
-	// set_device_ro(s->s_dev, 1) ;
-	if (journal_init(s, jdev_name, old_format, commit_max_age)) {
-		SWARN(silent, s, "sh-2022",
-		      "unable to initialize journal space");
-		goto error;
-	} else {
-		jinit_done = 1;	/* once this is set, journal_release must be called
-				 ** if we error out of the mount
-				 */
-	}
 	if (reread_meta_blocks(s)) {
 		SWARN(silent, s, "jmacd-9",
 		      "unable to reread meta blocks after journal init");
_
Subject: Subject: reiserfs: don't lock journal_init()

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

