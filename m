Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5ABEEB3
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 00:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724803811; cv=none; b=bbjCpcbPwx0iY7ueBpXu2hOcLDE3jx16o6sHdLj6mEtHwqoExpoI5uQu9ZTDoBn7ti0U6LVIjdrfKA3S1gJKqNmfGqH6JHgl7d9hwiBVTQPZrenTvV9NWMJfSPHTkAiqslsn5aApX6valF6y3UtpBx2WkrQEpcfzmLMsR1Qwxgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724803811; c=relaxed/simple;
	bh=gxSKWhsOJIY92NNiF9fyg19Uo/50AIBSVfeeHzBId7c=;
	h=Date:To:From:Subject:Message-Id; b=AdFd3LxsR9JPtMFtxZObF7DdBgvhed2J5iZSWJWl8/QA1hOAd5EylagX2dsNiMSFyDa2m7li3exE6+H9LWyDZ3Fg/Sf0tqaMTu2kKZdJWRIlnl0baQjK+iQ8heYtqwboRUMR0zyGT5eMUGyThvmLoWhbfpYb9BhSTwU/rApmp0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kzlegpk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kzlegpk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7BFC4AF51;
	Wed, 28 Aug 2024 00:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724803811;
	bh=gxSKWhsOJIY92NNiF9fyg19Uo/50AIBSVfeeHzBId7c=;
	h=Date:To:From:Subject:From;
	b=Kzlegpk44tKElQbvgW9AP4yQpoeBAS/0vpVC8sHYecab+5QuL2Ia8geuufmutbv0s
	 sAGWY3k4FSsUHY/GGexFi7I7MX2mNXjh1vuOTnG6JGD6B52wsUZ7sW+2cxtF82ISKT
	 HwdKO10ihj1aSMcDtzZXHaNDSIuMt0nFmyvuknjA=
Date: Tue, 27 Aug 2024 17:10:10 -0700
To: mm-commits@vger.kernel.org,huangxiaojia2@huawei.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-refactor-nilfs_segctor_thread.patch added to mm-nonmm-unstable branch
Message-Id: <20240828001011.7A7BFC4AF51@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: refactor nilfs_segctor_thread()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-refactor-nilfs_segctor_thread.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-refactor-nilfs_segctor_thread.patch

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
Subject: nilfs2: refactor nilfs_segctor_thread()
Date: Tue, 27 Aug 2024 02:41:16 +0900

Simplify nilfs_segctor_thread(), the main loop function of the log writer
thread, to make the basic structure easier to understand.

In particular, the acquisition and release of the sc_state_lock spinlock
was scattered throughout the function, so extract the determination of
whether log writing is required into a helper function and make the
spinlock lock sections clearer.

Link: https://lkml.kernel.org/r/20240826174116.5008-9-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Huang Xiaojia <huangxiaojia2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |   85 +++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 45 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-refactor-nilfs_segctor_thread
+++ a/fs/nilfs2/segment.c
@@ -2630,6 +2630,32 @@ static int nilfs_segctor_flush_mode(stru
 }
 
 /**
+ * nilfs_log_write_required - determine whether log writing is required
+ * @sci:   nilfs_sc_info struct
+ * @modep: location for storing log writing mode
+ *
+ * Return: true if log writing is required, false otherwise.  If log writing
+ * is required, the mode is stored in the location pointed to by @modep.
+ */
+static bool nilfs_log_write_required(struct nilfs_sc_info *sci, int *modep)
+{
+	bool timedout, ret = true;
+
+	spin_lock(&sci->sc_state_lock);
+	timedout = ((sci->sc_state & NILFS_SEGCTOR_COMMIT) &&
+		   time_after_eq(jiffies, sci->sc_timer.expires));
+	if (timedout || sci->sc_seq_request != sci->sc_seq_done)
+		*modep = SC_LSEG_SR;
+	else if (sci->sc_flush_request)
+		*modep = nilfs_segctor_flush_mode(sci);
+	else
+		ret = false;
+
+	spin_unlock(&sci->sc_state_lock);
+	return ret;
+}
+
+/**
  * nilfs_segctor_thread - main loop of the log writer thread
  * @arg: pointer to a struct nilfs_sc_info.
  *
@@ -2644,70 +2670,39 @@ static int nilfs_segctor_thread(void *ar
 {
 	struct nilfs_sc_info *sci = (struct nilfs_sc_info *)arg;
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
-	int timeout = 0;
 
 	nilfs_info(sci->sc_super,
 		   "segctord starting. Construction interval = %lu seconds, CP frequency < %lu seconds",
 		   sci->sc_interval / HZ, sci->sc_mjcp_freq / HZ);
 
 	set_freezable();
-	spin_lock(&sci->sc_state_lock);
- loop:
-	for (;;) {
-		int mode;
 
-		if (kthread_should_stop())
-			goto end_thread;
-
-		if (timeout || sci->sc_seq_request != sci->sc_seq_done)
-			mode = SC_LSEG_SR;
-		else if (sci->sc_flush_request)
-			mode = nilfs_segctor_flush_mode(sci);
-		else
-			break;
-
-		spin_unlock(&sci->sc_state_lock);
-		nilfs_segctor_thread_construct(sci, mode);
-		spin_lock(&sci->sc_state_lock);
-		timeout = 0;
-	}
-
-
-	if (freezing(current)) {
-		spin_unlock(&sci->sc_state_lock);
-		try_to_freeze();
-		spin_lock(&sci->sc_state_lock);
-	} else {
+	while (!kthread_should_stop()) {
 		DEFINE_WAIT(wait);
-		int should_sleep = 1;
+		bool should_write;
+		int mode;
+
+		if (freezing(current)) {
+			try_to_freeze();
+			continue;
+		}
 
 		prepare_to_wait(&sci->sc_wait_daemon, &wait,
 				TASK_INTERRUPTIBLE);
-
-		if (sci->sc_seq_request != sci->sc_seq_done)
-			should_sleep = 0;
-		else if (sci->sc_flush_request)
-			should_sleep = 0;
-		else if (sci->sc_state & NILFS_SEGCTOR_COMMIT)
-			should_sleep = time_before(jiffies,
-					sci->sc_timer.expires);
-
-		if (should_sleep) {
-			spin_unlock(&sci->sc_state_lock);
+		should_write = nilfs_log_write_required(sci, &mode);
+		if (!should_write)
 			schedule();
-			spin_lock(&sci->sc_state_lock);
-		}
 		finish_wait(&sci->sc_wait_daemon, &wait);
-		timeout = ((sci->sc_state & NILFS_SEGCTOR_COMMIT) &&
-			   time_after_eq(jiffies, sci->sc_timer.expires));
 
 		if (nilfs_sb_dirty(nilfs) && nilfs_sb_need_update(nilfs))
 			set_nilfs_discontinued(nilfs);
+
+		if (should_write)
+			nilfs_segctor_thread_construct(sci, mode);
 	}
-	goto loop;
 
- end_thread:
 	/* end sync. */
+	spin_lock(&sci->sc_state_lock);
 	sci->sc_task = NULL;
 	timer_shutdown_sync(&sci->sc_timer);
 	spin_unlock(&sci->sc_state_lock);
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

