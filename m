Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B036C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378914AbiFQCMV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379421AbiFQCMR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:12:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B3C64BDB
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:12:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60E6B61C0A
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F55C3411A;
        Fri, 17 Jun 2022 02:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655431935;
        bh=BiqPm8AbLUIS3ni8WfaMmhnBqxc3qweZEJ8Dr4zWx4g=;
        h=Date:To:From:Subject:From;
        b=MldcwjxpGggRsORlwiajbL/siaWgEtUA/6Iu3yvPUSFZ6Wyyk54f561R4xZ1M6pZe
         8Nojy/ei9a2IsFc4q4IX/cwDqCjEy8yB0peajZNDJfNP1uiYbIkoeNUdXdYeyd+U6O
         TGWBa40YR4QZw/6lkVmWQl7GCHDFMCz037xBllro=
Date:   Thu, 16 Jun 2022 19:12:15 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
        keescook@chromium.org, elver@google.com, ebiederm@xmission.com,
        axboe@kernel.dk, pmladek@suse.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kthread-make-it-clear-that-kthread_create_on_node-might-be-terminated-by-any-fatal-signal.patch removed from -mm tree
Message-Id: <20220617021215.B7F55C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kthread: make it clear that kthread_create_on_node() might be terminated by any fatal signal
has been removed from the -mm tree.  Its filename was
     kthread-make-it-clear-that-kthread_create_on_node-might-be-terminated-by-any-fatal-signal.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: kthread: make it clear that kthread_create_on_node() might be terminated by any fatal signal
Date: Tue, 15 Mar 2022 11:24:44 +0100

The comments in kernel/kthread.c create a feeling that only SIGKILL is
able to terminate the creation of kernel kthreads by
kthread_create()/_on_node()/_on_cpu() APIs.

In reality, wait_for_completion_killable() might be killed by any fatal
signal that does not have a custom handler:

	(!siginmask(signr, SIG_KERNEL_IGNORE_MASK|SIG_KERNEL_STOP_MASK) && \
	 (t)->sighand->action[(signr)-1].sa.sa_handler == SIG_DFL)

static inline void signal_wake_up(struct task_struct *t, bool resume)
{
	signal_wake_up_state(t, resume ? TASK_WAKEKILL : 0);
}

static void complete_signal(int sig, struct task_struct *p, enum pid_type type)
{
[...]
	/*
	 * Found a killable thread.  If the signal will be fatal,
	 * then start taking the whole group down immediately.
	 */
	if (sig_fatal(p, sig) ...) {
		if (!sig_kernel_coredump(sig)) {
		[...]
			do {
				task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
				sigaddset(&t->pending.signal, SIGKILL);
				signal_wake_up(t, 1);
			} while_each_thread(p, t);
			return;
		}
	}
}

Update the comments in kernel/kthread.c to make this more obvious.

The motivation for this change was debugging why a module initialization
failed.  The module was being loaded from initrd.  It "magically" failed
when systemd was switching to the real root.  The clean up operations sent
SIGTERM to various pending processed that were started from initrd.

Link: https://lkml.kernel.org/r/20220315102444.2380-1-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/kernel/kthread.c~kthread-make-it-clear-that-kthread_create_on_node-might-be-terminated-by-any-fatal-signal
+++ a/kernel/kthread.c
@@ -340,7 +340,7 @@ static int kthread(void *_create)
 
 	self = to_kthread(current);
 
-	/* If user was SIGKILLed, I release the structure. */
+	/* Release the structure when caller killed by a fatal signal. */
 	done = xchg(&create->done, NULL);
 	if (!done) {
 		kfree(create);
@@ -398,7 +398,7 @@ static void create_kthread(struct kthrea
 	/* We want our own signal handler (we take no signals by default). */
 	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
 	if (pid < 0) {
-		/* If user was SIGKILLed, I release the structure. */
+		/* Release the structure when caller killed by a fatal signal. */
 		struct completion *done = xchg(&create->done, NULL);
 
 		if (!done) {
@@ -440,9 +440,9 @@ struct task_struct *__kthread_create_on_
 	 */
 	if (unlikely(wait_for_completion_killable(&done))) {
 		/*
-		 * If I was SIGKILLed before kthreadd (or new kernel thread)
-		 * calls complete(), leave the cleanup of this structure to
-		 * that thread.
+		 * If I was killed by a fatal signal before kthreadd (or new
+		 * kernel thread) calls complete(), leave the cleanup of this
+		 * structure to that thread.
 		 */
 		if (xchg(&create->done, NULL))
 			return ERR_PTR(-EINTR);
@@ -876,7 +876,7 @@ fail_task:
  *
  * Returns a pointer to the allocated worker on success, ERR_PTR(-ENOMEM)
  * when the needed structures could not get allocated, and ERR_PTR(-EINTR)
- * when the worker was SIGKILLed.
+ * when the caller was killed by a fatal signal.
  */
 struct kthread_worker *
 kthread_create_worker(unsigned int flags, const char namefmt[], ...)
@@ -925,7 +925,7 @@ EXPORT_SYMBOL(kthread_create_worker);
  * Return:
  * The pointer to the allocated worker on success, ERR_PTR(-ENOMEM)
  * when the needed structures could not get allocated, and ERR_PTR(-EINTR)
- * when the worker was SIGKILLed.
+ * when the caller was killed by a fatal signal.
  */
 struct kthread_worker *
 kthread_create_worker_on_cpu(int cpu, unsigned int flags,
_

Patches currently in -mm which might be from pmladek@suse.com are


