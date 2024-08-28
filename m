Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB762D2F5
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 00:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724803809; cv=none; b=n2Jo5HJezQKhTVRrIaHUUnrllQ9faljIL1Ncgq2820XWMAeWaLgWWPQS6pgkWv2X8tvWrl/zJTF7S4K/+Ns8Fefdb0rPCiY4cjMeTnff3bv8/Qd4RmJEBATqqI78XcxS5//FQqdQhUOfAPQkzV1yyI9PpuNcIcaAPIiM1Apveug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724803809; c=relaxed/simple;
	bh=0SyteD71/H5rll+D+pr5viYzIcyathOD9qL8Jqs6HD4=;
	h=Date:To:From:Subject:Message-Id; b=D7OlPBeHVww8+UfBBY25lmA6tn3gIrCfjlJbrgKJdlTes4yUXgi4QdKqtAvFlgpaAntTeIm/jQubzcdeA+8K5ioGXVGczA8t6iXwe1iTNjQDnuJlkgu0wL5wXLHPBs+1m/V+zg68vZqSiOy4SjASNOxFdD0Fd/CTShgucXwKOhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QQ2DwoJH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QQ2DwoJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3208FC4AF64;
	Wed, 28 Aug 2024 00:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724803809;
	bh=0SyteD71/H5rll+D+pr5viYzIcyathOD9qL8Jqs6HD4=;
	h=Date:To:From:Subject:From;
	b=QQ2DwoJHfKhsQ16detb/4moFfjpXXg4ZJsbGc54NHxEP4MS15lN0C4wURIoiQlogV
	 gEW6FUpa5ODCcCxFS91BjjuY+OPMqgzNs0rG+ybzq+Hye4icd3mkj+5/aFqsWbSqP4
	 A0rcZUaW61R2Ko2mRP6SeMLOu9BUXkQt0DJ4gwpo=
Date: Tue, 27 Aug 2024 17:10:08 -0700
To: mm-commits@vger.kernel.org,huangxiaojia2@huawei.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-use-kthread_create-and-kthread_stop-for-the-log-writer-thread.patch added to mm-nonmm-unstable branch
Message-Id: <20240828001009.3208FC4AF64@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: use kthread_create and kthread_stop for the log writer thread
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-use-kthread_create-and-kthread_stop-for-the-log-writer-thread.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-use-kthread_create-and-kthread_stop-for-the-log-writer-thread.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: use kthread_create and kthread_stop for the log writer thread
Date: Tue, 27 Aug 2024 02:41:15 +0900

By using kthread_create() and kthread_stop() to start and stop the log
writer thread, eliminate custom thread start and stop helpers, as well as
the wait queue "sc_wait_task" on the "nilfs_sc_info" struct and
NILFS_SEGCTOR_QUIT flag that exist only to implement them.

Also, update the kernel doc comments of the changed functions as
appropriate.

Link: https://lkml.kernel.org/r/20240826174116.5008-8-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Huang Xiaojia <huangxiaojia2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |   82 +++++++++++++++---------------------------
 fs/nilfs2/segment.h |    3 -
 2 files changed, 31 insertions(+), 54 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-use-kthread_create-and-kthread_stop-for-the-log-writer-thread
+++ a/fs/nilfs2/segment.c
@@ -2630,11 +2630,15 @@ static int nilfs_segctor_flush_mode(stru
 }
 
 /**
- * nilfs_segctor_thread - main loop of the segment constructor thread.
+ * nilfs_segctor_thread - main loop of the log writer thread
  * @arg: pointer to a struct nilfs_sc_info.
  *
- * nilfs_segctor_thread() initializes a timer and serves as a daemon
- * to execute segment constructions.
+ * nilfs_segctor_thread() is the main loop function of the log writer kernel
+ * thread, which determines whether log writing is necessary, and if so,
+ * performs the log write in the background, or waits if not.  It is also
+ * used to decide the background writeback of the superblock.
+ *
+ * Return: Always 0.
  */
 static int nilfs_segctor_thread(void *arg)
 {
@@ -2642,11 +2646,6 @@ static int nilfs_segctor_thread(void *ar
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int timeout = 0;
 
-	timer_setup(&sci->sc_timer, nilfs_construction_timeout, 0);
-
-	/* start sync. */
-	sci->sc_task = current;
-	wake_up(&sci->sc_wait_task); /* for nilfs_segctor_start_thread() */
 	nilfs_info(sci->sc_super,
 		   "segctord starting. Construction interval = %lu seconds, CP frequency < %lu seconds",
 		   sci->sc_interval / HZ, sci->sc_mjcp_freq / HZ);
@@ -2657,7 +2656,7 @@ static int nilfs_segctor_thread(void *ar
 	for (;;) {
 		int mode;
 
-		if (sci->sc_state & NILFS_SEGCTOR_QUIT)
+		if (kthread_should_stop())
 			goto end_thread;
 
 		if (timeout || sci->sc_seq_request != sci->sc_seq_done)
@@ -2711,41 +2710,10 @@ static int nilfs_segctor_thread(void *ar
 	/* end sync. */
 	sci->sc_task = NULL;
 	timer_shutdown_sync(&sci->sc_timer);
-	wake_up(&sci->sc_wait_task); /* for nilfs_segctor_kill_thread() */
 	spin_unlock(&sci->sc_state_lock);
 	return 0;
 }
 
-static int nilfs_segctor_start_thread(struct nilfs_sc_info *sci)
-{
-	struct task_struct *t;
-
-	t = kthread_run(nilfs_segctor_thread, sci, "segctord");
-	if (IS_ERR(t)) {
-		int err = PTR_ERR(t);
-
-		nilfs_err(sci->sc_super, "error %d creating segctord thread",
-			  err);
-		return err;
-	}
-	wait_event(sci->sc_wait_task, sci->sc_task != NULL);
-	return 0;
-}
-
-static void nilfs_segctor_kill_thread(struct nilfs_sc_info *sci)
-	__acquires(&sci->sc_state_lock)
-	__releases(&sci->sc_state_lock)
-{
-	sci->sc_state |= NILFS_SEGCTOR_QUIT;
-
-	while (sci->sc_task) {
-		wake_up(&sci->sc_wait_daemon);
-		spin_unlock(&sci->sc_state_lock);
-		wait_event(sci->sc_wait_task, sci->sc_task == NULL);
-		spin_lock(&sci->sc_state_lock);
-	}
-}
-
 /*
  * Setup & clean-up functions
  */
@@ -2766,7 +2734,6 @@ static struct nilfs_sc_info *nilfs_segct
 
 	init_waitqueue_head(&sci->sc_wait_request);
 	init_waitqueue_head(&sci->sc_wait_daemon);
-	init_waitqueue_head(&sci->sc_wait_task);
 	spin_lock_init(&sci->sc_state_lock);
 	INIT_LIST_HEAD(&sci->sc_dirty_files);
 	INIT_LIST_HEAD(&sci->sc_segbufs);
@@ -2821,8 +2788,12 @@ static void nilfs_segctor_destroy(struct
 
 	up_write(&nilfs->ns_segctor_sem);
 
+	if (sci->sc_task) {
+		wake_up(&sci->sc_wait_daemon);
+		kthread_stop(sci->sc_task);
+	}
+
 	spin_lock(&sci->sc_state_lock);
-	nilfs_segctor_kill_thread(sci);
 	flag = ((sci->sc_state & NILFS_SEGCTOR_COMMIT) || sci->sc_flush_request
 		|| sci->sc_seq_request != sci->sc_seq_done);
 	spin_unlock(&sci->sc_state_lock);
@@ -2870,14 +2841,15 @@ static void nilfs_segctor_destroy(struct
  * This allocates a log writer object, initializes it, and starts the
  * log writer.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error code is returned.
- *
- * %-ENOMEM - Insufficient memory available.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EINTR	- Log writer thread creation failed due to interruption.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root)
 {
 	struct the_nilfs *nilfs = sb->s_fs_info;
+	struct nilfs_sc_info *sci;
+	struct task_struct *t;
 	int err;
 
 	if (nilfs->ns_writer) {
@@ -2890,15 +2862,23 @@ int nilfs_attach_log_writer(struct super
 		return 0;
 	}
 
-	nilfs->ns_writer = nilfs_segctor_new(sb, root);
-	if (!nilfs->ns_writer)
+	sci = nilfs_segctor_new(sb, root);
+	if (unlikely(!sci))
 		return -ENOMEM;
 
-	err = nilfs_segctor_start_thread(nilfs->ns_writer);
-	if (unlikely(err))
+	nilfs->ns_writer = sci;
+	t = kthread_create(nilfs_segctor_thread, sci, "segctord");
+	if (IS_ERR(t)) {
+		err = PTR_ERR(t);
+		nilfs_err(sb, "error %d creating segctord thread", err);
 		nilfs_detach_log_writer(sb);
+		return err;
+	}
+	sci->sc_task = t;
+	timer_setup(&sci->sc_timer, nilfs_construction_timeout, 0);
 
-	return err;
+	wake_up_process(sci->sc_task);
+	return 0;
 }
 
 /**
--- a/fs/nilfs2/segment.h~nilfs2-use-kthread_create-and-kthread_stop-for-the-log-writer-thread
+++ a/fs/nilfs2/segment.h
@@ -105,7 +105,6 @@ struct nilfs_segsum_pointer {
  * @sc_flush_request: inode bitmap of metadata files to be flushed
  * @sc_wait_request: Client request queue
  * @sc_wait_daemon: Daemon wait queue
- * @sc_wait_task: Start/end wait queue to control segctord task
  * @sc_seq_request: Request counter
  * @sc_seq_accepted: Accepted request count
  * @sc_seq_done: Completion counter
@@ -158,7 +157,6 @@ struct nilfs_sc_info {
 
 	wait_queue_head_t	sc_wait_request;
 	wait_queue_head_t	sc_wait_daemon;
-	wait_queue_head_t	sc_wait_task;
 
 	__u32			sc_seq_request;
 	__u32			sc_seq_accepted;
@@ -191,7 +189,6 @@ enum {
 };
 
 /* sc_state */
-#define NILFS_SEGCTOR_QUIT	    0x0001  /* segctord is being destroyed */
 #define NILFS_SEGCTOR_COMMIT	    0x0004  /* committed transaction exists */
 
 /*
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-protect-references-to-superblock-parameters-exposed-in-sysfs.patch
nilfs2-fix-missing-cleanup-on-rollforward-recovery-error.patch
nilfs2-fix-state-management-in-error-path-of-log-writing-function.patch
nilfs2-add-support-for-fs_ioc_getuuid.patch
nilfs2-add-support-for-fs_ioc_getfssysfspath.patch
nilfs2-add-support-for-fs_ioc_getfslabel.patch
nilfs2-add-support-for-fs_ioc_setfslabel.patch
nilfs2-do-not-output-warnings-when-clearing-dirty-buffers.patch
nilfs2-add-missing-argument-description-for-__nilfs_error.patch
nilfs2-add-missing-argument-descriptions-for-ioctl-related-helpers.patch
nilfs2-improve-kernel-doc-comments-for-b-tree-node-helpers.patch
nilfs2-fix-incorrect-kernel-doc-declaration-of-nilfs_palloc_req-structure.patch
nilfs2-add-missing-description-of-nilfs_btree_path-structure.patch
nilfs2-describe-the-members-of-nilfs_bmap_operations-structure.patch
nilfs2-fix-inconsistencies-in-kernel-doc-comments-in-segmenth.patch
nilfs2-fix-missing-initial-short-descriptions-of-kernel-doc-comments.patch
nilfs2-treat-missing-sufile-header-block-as-metadata-corruption.patch
nilfs2-treat-missing-cpfile-header-block-as-metadata-corruption.patch
nilfs2-do-not-propagate-enoent-error-from-sufile-during-recovery.patch
nilfs2-do-not-propagate-enoent-error-from-sufile-during-gc.patch
nilfs2-do-not-propagate-enoent-error-from-nilfs_sufile_mark_dirty.patch
nilfs2-use-the-bits_per_long-macro.patch
nilfs2-separate-inode-type-information-from-i_state-field.patch
nilfs2-eliminate-the-shared-counter-and-spinlock-for-i_generation.patch
nilfs2-do-not-repair-reserved-inode-bitmap-in-nilfs_new_inode.patch
nilfs2-remove-sc_timer_task.patch
nilfs2-use-kthread_create-and-kthread_stop-for-the-log-writer-thread.patch
nilfs2-refactor-nilfs_segctor_thread.patch

