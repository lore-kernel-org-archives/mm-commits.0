Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 148F2C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 20:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE93260F55
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 20:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhJJUwk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Oct 2021 16:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229684AbhJJUwj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 10 Oct 2021 16:52:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAAD460F4B;
        Sun, 10 Oct 2021 20:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633899041;
        bh=eC0lvg6bNKwdH6WzE+TyR7lruLkE+vKxFitxh9PPdIs=;
        h=Date:From:To:Subject:From;
        b=DcKaMFicmrtrYla4lgrRdoEVEInr+8ax9TtjkXjkt9OPCrrElROD8nLoVcxRatCQH
         QIyR++Z4L4JXzBbjFc2eWzXe0FXmvkAxww+mGal9oKcQOJymAHJLLRkDd4R+B0qWFU
         DvoAnqphKEi1Eh7EIBeG/1Dg4jCGw4UeAXJem4uM=
Date:   Sun, 10 Oct 2021 13:50:40 -0700
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        vvidic@valentin-vidic.from.hr
Subject:  + ocfs2-cleanup-journal-init-and-shutdown.patch added to
 -mm tree
Message-ID: <20211010205040.PlW_nIp-q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: cleanup journal init and shutdown
has been added to the -mm tree.  Its filename is
     ocfs2-cleanup-journal-init-and-shutdown.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-cleanup-journal-init-and-shutdown.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-cleanup-journal-init-and-shutdown.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Subject: ocfs2: cleanup journal init and shutdown

Allocate and free struct ocfs2_journal in ocfs2_journal_init and
ocfs2_journal_shutdown.  Init and release of system inodes references the
journal so reorder calls to make sure they work correctly.

Link: https://lkml.kernel.org/r/20211009145006.3478-1-vvidic@valentin-vidic.from.hr
Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c   |    4 ++--
 fs/ocfs2/journal.c |   28 ++++++++++++++++++++++------
 fs/ocfs2/journal.h |    3 +--
 fs/ocfs2/super.c   |   40 +++-------------------------------------
 4 files changed, 28 insertions(+), 47 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-cleanup-journal-init-and-shutdown
+++ a/fs/ocfs2/inode.c
@@ -125,7 +125,6 @@ struct inode *ocfs2_iget(struct ocfs2_su
 	struct inode *inode = NULL;
 	struct super_block *sb = osb->sb;
 	struct ocfs2_find_inode_args args;
-	journal_t *journal = OCFS2_SB(sb)->journal->j_journal;
 
 	trace_ocfs2_iget_begin((unsigned long long)blkno, flags,
 			       sysfile_type);
@@ -172,10 +171,11 @@ struct inode *ocfs2_iget(struct ocfs2_su
 	 * part of the transaction - the inode could have been reclaimed and
 	 * now it is reread from disk.
 	 */
-	if (journal) {
+	if (osb->journal) {
 		transaction_t *transaction;
 		tid_t tid;
 		struct ocfs2_inode_info *oi = OCFS2_I(inode);
+		journal_t *journal = osb->journal->j_journal;
 
 		read_lock(&journal->j_state_lock);
 		if (journal->j_running_transaction)
--- a/fs/ocfs2/journal.c~ocfs2-cleanup-journal-init-and-shutdown
+++ a/fs/ocfs2/journal.c
@@ -810,19 +810,34 @@ void ocfs2_set_journal_params(struct ocf
 	write_unlock(&journal->j_state_lock);
 }
 
-int ocfs2_journal_init(struct ocfs2_journal *journal, int *dirty)
+int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
 {
 	int status = -1;
 	struct inode *inode = NULL; /* the journal inode */
 	journal_t *j_journal = NULL;
+	struct ocfs2_journal *journal = NULL;
 	struct ocfs2_dinode *di = NULL;
 	struct buffer_head *bh = NULL;
-	struct ocfs2_super *osb;
 	int inode_lock = 0;
 
-	BUG_ON(!journal);
-
-	osb = journal->j_osb;
+	/* initialize our journal structure */
+	journal = kzalloc(sizeof(struct ocfs2_journal), GFP_KERNEL);
+	if (!journal) {
+		mlog(ML_ERROR, "unable to alloc journal\n");
+		status = -ENOMEM;
+		goto done;
+	}
+	osb->journal = journal;
+	journal->j_osb = osb;
+
+	atomic_set(&journal->j_num_trans, 0);
+	init_rwsem(&journal->j_trans_barrier);
+	init_waitqueue_head(&journal->j_checkpointed);
+	spin_lock_init(&journal->j_lock);
+	journal->j_trans_id = 1UL;
+	INIT_LIST_HEAD(&journal->j_la_cleanups);
+	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
+	journal->j_state = OCFS2_JOURNAL_FREE;
 
 	/* already have the inode for our journal */
 	inode = ocfs2_get_system_file_inode(osb, JOURNAL_SYSTEM_INODE,
@@ -1028,9 +1043,10 @@ void ocfs2_journal_shutdown(struct ocfs2
 
 	journal->j_state = OCFS2_JOURNAL_FREE;
 
-//	up_write(&journal->j_trans_barrier);
 done:
 	iput(inode);
+	kfree(journal);
+	osb->journal = NULL;
 }
 
 static void ocfs2_clear_journal_error(struct super_block *sb,
--- a/fs/ocfs2/journal.h~ocfs2-cleanup-journal-init-and-shutdown
+++ a/fs/ocfs2/journal.h
@@ -167,8 +167,7 @@ int ocfs2_compute_replay_slots(struct oc
  *  ocfs2_start_checkpoint - Kick the commit thread to do a checkpoint.
  */
 void   ocfs2_set_journal_params(struct ocfs2_super *osb);
-int    ocfs2_journal_init(struct ocfs2_journal *journal,
-			  int *dirty);
+int    ocfs2_journal_init(struct ocfs2_super *osb, int *dirty);
 void   ocfs2_journal_shutdown(struct ocfs2_super *osb);
 int    ocfs2_journal_wipe(struct ocfs2_journal *journal,
 			  int full);
--- a/fs/ocfs2/super.c~ocfs2-cleanup-journal-init-and-shutdown
+++ a/fs/ocfs2/super.c
@@ -1894,8 +1894,6 @@ static void ocfs2_dismount_volume(struct
 	/* This will disable recovery and flush any recovery work. */
 	ocfs2_recovery_exit(osb);
 
-	ocfs2_journal_shutdown(osb);
-
 	ocfs2_sync_blockdev(sb);
 
 	ocfs2_purge_refcount_trees(osb);
@@ -1918,6 +1916,8 @@ static void ocfs2_dismount_volume(struct
 
 	ocfs2_release_system_inodes(osb);
 
+	ocfs2_journal_shutdown(osb);
+
 	/*
 	 * If we're dismounting due to mount error, mount.ocfs2 will clean
 	 * up heartbeat.  If we're a local mount, there is no heartbeat.
@@ -2016,7 +2016,6 @@ static int ocfs2_initialize_super(struct
 	int i, cbits, bbits;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
 	struct inode *inode = NULL;
-	struct ocfs2_journal *journal;
 	struct ocfs2_super *osb;
 	u64 total_blocks;
 
@@ -2197,33 +2196,6 @@ static int ocfs2_initialize_super(struct
 
 	get_random_bytes(&osb->s_next_generation, sizeof(u32));
 
-	/* FIXME
-	 * This should be done in ocfs2_journal_init(), but unknown
-	 * ordering issues will cause the filesystem to crash.
-	 * If anyone wants to figure out what part of the code
-	 * refers to osb->journal before ocfs2_journal_init() is run,
-	 * be my guest.
-	 */
-	/* initialize our journal structure */
-
-	journal = kzalloc(sizeof(struct ocfs2_journal), GFP_KERNEL);
-	if (!journal) {
-		mlog(ML_ERROR, "unable to alloc journal\n");
-		status = -ENOMEM;
-		goto bail;
-	}
-	osb->journal = journal;
-	journal->j_osb = osb;
-
-	atomic_set(&journal->j_num_trans, 0);
-	init_rwsem(&journal->j_trans_barrier);
-	init_waitqueue_head(&journal->j_checkpointed);
-	spin_lock_init(&journal->j_lock);
-	journal->j_trans_id = (unsigned long) 1;
-	INIT_LIST_HEAD(&journal->j_la_cleanups);
-	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
-	journal->j_state = OCFS2_JOURNAL_FREE;
-
 	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
 	init_llist_head(&osb->dquot_drop_list);
 
@@ -2404,7 +2376,7 @@ static int ocfs2_check_volume(struct ocf
 						  * ourselves. */
 
 	/* Init our journal object. */
-	status = ocfs2_journal_init(osb->journal, &dirty);
+	status = ocfs2_journal_init(osb, &dirty);
 	if (status < 0) {
 		mlog(ML_ERROR, "Could not initialize journal!\n");
 		goto finally;
@@ -2513,12 +2485,6 @@ static void ocfs2_delete_osb(struct ocfs
 
 	kfree(osb->osb_orphan_wipes);
 	kfree(osb->slot_recovery_generations);
-	/* FIXME
-	 * This belongs in journal shutdown, but because we have to
-	 * allocate osb->journal at the start of ocfs2_initialize_osb(),
-	 * we free it here.
-	 */
-	kfree(osb->journal);
 	kfree(osb->local_alloc_copy);
 	kfree(osb->uuid_str);
 	kfree(osb->vol_label);
_

Patches currently in -mm which might be from vvidic@valentin-vidic.from.hr are

ocfs2-mount-fails-with-buffer-overflow-in-strlen.patch
ocfs2-cleanup-journal-init-and-shutdown.patch

