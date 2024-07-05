Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F53613A88A
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 06:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720161817; cv=none; b=TXycoNmRrejkRGMcNNTIabt6lOou36ni+j4oFZIqdhgvbP0HcU6SZ5y8JLxUTnFCSotLemMrpD9b32DYLdidu2l8Mg84F0NPyxKSkIgC9hOQSPPU2pdjy3VcMc9ZDYSMr0n33e8bQFfKQS7oE9uwM2TvpDoHaGPuCU/iThpz7ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720161817; c=relaxed/simple;
	bh=vClXktKIJc2IwkSMnA7HMxcwDDJJIsSaC+AsA9E3gls=;
	h=Date:To:From:Subject:Message-Id; b=qErhvtNZsR+kDba0mMkFMuCm14tyQJ79cqqkhFOiEYUX2rcMp7Df/toBaDOmU+pyVn4zKqkGX/c1a9W+zU/WAOAareuv+N4xM7jJDQOkuxERXTI3WkAJetKkdFSaDuZx4rMl7f6k4vAajrIYbxJx3340KOsuoCFmttFHxMH2SF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q72taw5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q72taw5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DFBC116B1;
	Fri,  5 Jul 2024 06:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720161817;
	bh=vClXktKIJc2IwkSMnA7HMxcwDDJJIsSaC+AsA9E3gls=;
	h=Date:To:From:Subject:From;
	b=Q72taw5LmGxHH9VUOJB36a+B8JzhzozpnrnQ+CmAzIClBaJqv7X4RgG0MyZnuh2Wn
	 Fw3ePxw2s6QbsGGMGHueAjSTCTJso37t9vQxAaDdLM/B9ZdmKo9kvfT3TiHftUT/MT
	 +Xmh8ruo/m5PyNZwCcHXm6boLCaEOP0ZtgBzwy3Y=
Date: Thu, 04 Jul 2024 23:43:36 -0700
To: mm-commits@vger.kernel.org,ebiederm@xmission.com,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] coredump-simplify-zap_process.patch removed from -mm tree
Message-Id: <20240705064337.04DFBC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: coredump: simplify zap_process()
has been removed from the -mm tree.  Its filename was
     coredump-simplify-zap_process.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: simplify zap_process()
Date: Tue, 25 Jun 2024 16:03:11 +0200

After commit 0258b5fd7c71 ("coredump: Limit coredumps to a single thread
group") zap_process() doesn't need the "task_struct *start" arg,
zap_threads() can pass "signal_struct *signal" instead.

This simplifies the code and allows to use __for_each_thread() which
is slightly more efficient.

Link: https://lkml.kernel.org/r/20240625140311.GA20787@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/coredump.c~coredump-simplify-zap_process
+++ a/fs/coredump.c
@@ -361,17 +361,16 @@ out:
 	return ispipe;
 }
 
-static int zap_process(struct task_struct *start, int exit_code)
+static int zap_process(struct signal_struct *signal, int exit_code)
 {
 	struct task_struct *t;
 	int nr = 0;
 
-	/* Allow SIGKILL, see prepare_signal() */
-	start->signal->flags = SIGNAL_GROUP_EXIT;
-	start->signal->group_exit_code = exit_code;
-	start->signal->group_stop_count = 0;
+	signal->flags = SIGNAL_GROUP_EXIT;
+	signal->group_exit_code = exit_code;
+	signal->group_stop_count = 0;
 
-	for_each_thread(start, t) {
+	__for_each_thread(signal, t) {
 		task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
 		if (t != current && !(t->flags & PF_POSTCOREDUMP)) {
 			sigaddset(&t->pending.signal, SIGKILL);
@@ -391,8 +390,9 @@ static int zap_threads(struct task_struc
 
 	spin_lock_irq(&tsk->sighand->siglock);
 	if (!(signal->flags & SIGNAL_GROUP_EXIT) && !signal->group_exec_task) {
+		/* Allow SIGKILL, see prepare_signal() */
 		signal->core_state = core_state;
-		nr = zap_process(tsk, exit_code);
+		nr = zap_process(signal, exit_code);
 		clear_tsk_thread_flag(tsk, TIF_SIGPENDING);
 		tsk->flags |= PF_DUMPCORE;
 		atomic_set(&core_state->nr_threads, nr);
_

Patches currently in -mm which might be from oleg@redhat.com are

zap_pid_ns_processes-dont-send-sigkill-to-sub-threads.patch

