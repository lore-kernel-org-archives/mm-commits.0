Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC6214BF89
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248860; cv=none; b=eVH/cax4LOHZ8XaMtFfQlZa1S9cnhIOd+5c/Pf4JWtdiLyKbRVC8SsRdv/MLiPT618gydAyCFR/1xZo6j8s2b2IwQvKVO8ZAX+e3CHmqdWJyXU4c/K4Q5Tyn1LiAE1ZPZBudHhchfnEWOF8s2ZTMpNv/bayj6raoKgoWARyXn18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248860; c=relaxed/simple;
	bh=GLdFPwv28ufl8hqjaphnsWizFcrujs4S8/Cvpd1R2YU=;
	h=Date:To:From:Subject:Message-Id; b=pcaiDOOG+qq+cLv7uwrb7tZrLYvt8l46rN1YWM/uDPIY/S0Epuk/0mzIAB3dYom/DZf5lrh8yOgSnOZUkYdVfn8rnkDhSMQNwVlgnBSobNpbftIK85XwnXWEpkF82GnDWgUsOBeQsnyMH3Q1goMZJ4C3OB9ffnG3tUNZQchj2Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1NIAFEw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1NIAFEw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026B6C4CEC2;
	Mon,  2 Sep 2024 03:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248860;
	bh=GLdFPwv28ufl8hqjaphnsWizFcrujs4S8/Cvpd1R2YU=;
	h=Date:To:From:Subject:From;
	b=1NIAFEw853rbt5DGbG3Ci1OfiW71I1o+CupZrUE417NER4jeOFm6/n7obRoV+k7R2
	 Pp3lc1pLCFfHzspNY0dxTuh/FkYCfpY2csPJVur9ir+GrGe6J35SIGTgnYs+WQe6pt
	 3/s/M1gB0cCmt8RFUfdJpVlMFC+wted0C2BcFg1g=
Date: Sun, 01 Sep 2024 20:47:39 -0700
To: mm-commits@vger.kernel.org,huangxiaojia2@huawei.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-refactor-nilfs_segctor_thread.patch removed from -mm tree
Message-Id: <20240902034740.026B6C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: refactor nilfs_segctor_thread()
has been removed from the -mm tree.  Its filename was
     nilfs2-refactor-nilfs_segctor_thread.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2628,6 +2628,32 @@ static int nilfs_segctor_flush_mode(stru
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
@@ -2642,70 +2668,39 @@ static int nilfs_segctor_thread(void *ar
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


