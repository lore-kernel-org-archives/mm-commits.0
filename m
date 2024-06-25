Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60D5179658
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 18:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719338759; cv=none; b=Jz4yH8boUmbVuWR5TCedIakSx1dQTaPV1/4aCMv6x23RqTnmntrHwmG4VGiVy2oQHUFNi+jL0hAq1bakdWOHkf8hoH3tQERyQBEvBjGFf2+XNtawVqjlL6y5t3NnnNRHgW1ecK6Sy743pgjK+JtWHJl1ZzNepdR+9cqVtGgJvQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719338759; c=relaxed/simple;
	bh=zLhjQCPtV/STtvykwYWYSvKHq753a0ISOKxWwaH90W8=;
	h=Date:To:From:Subject:Message-Id; b=recF0CaATNk2JnuO4TFPijiuAiHm46PzKMoYWWVAFa/e3W85Yx7J4JBtEFP4yKE9NE8UCoLviVCx7S75QVh6Wca5VKoF0nxyEu2BtGHylZM2Fw2aJ56YA8nqAztPHQFYiT1QzucCc/NsdWGN93qydOjhaXYFTg85bDlq2lweq6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TU64djc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TU64djc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807A1C32781;
	Tue, 25 Jun 2024 18:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719338759;
	bh=zLhjQCPtV/STtvykwYWYSvKHq753a0ISOKxWwaH90W8=;
	h=Date:To:From:Subject:From;
	b=TU64djc83j4Tz4CX/FZix7m/Tlv/KdOv4EM0o2Om7FaT/zY0AMae+Ojfm9wwD5jf5
	 /o+A9ckFBzcsf+u7amNRhAon1HhckPz3Ucmhi4vaDhGmet8khRFKsFlI8N38zyOXp+
	 1BOg7mtXmZP9nWDlj5Olv5G+hxGo8qFsyjyJpsZE=
Date: Tue, 25 Jun 2024 11:05:58 -0700
To: mm-commits@vger.kernel.org,ebiederm@xmission.com,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + coredump-simplify-zap_process.patch added to mm-nonmm-unstable branch
Message-Id: <20240625180559.807A1C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: coredump: simplify zap_process()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     coredump-simplify-zap_process.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/coredump-simplify-zap_process.patch

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
coredump-simplify-zap_process.patch

