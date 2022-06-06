Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB34DC43334
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jun 2022 15:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240274AbiFFPBT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Jun 2022 11:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240246AbiFFPBL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2022 11:01:11 -0400
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED9B32162D
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 08:01:04 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:38756)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nyEE3-003fQb-5Y; Mon, 06 Jun 2022 09:01:03 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:32976 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nyEE0-007Mai-QS; Mon, 06 Jun 2022 09:01:02 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
        keescook@chromium.org, elver@google.com, axboe@kernel.dk,
        pmladek@suse.com
References: <20220315235159.4ED42C340E8@smtp.kernel.org>
Date:   Mon, 06 Jun 2022 10:00:54 -0500
In-Reply-To: <20220315235159.4ED42C340E8@smtp.kernel.org> (Andrew Morton's
        message of "Tue, 15 Mar 2022 16:51:58 -0700")
Message-ID: <87y1y94z15.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1nyEE0-007Mai-QS;;;mid=<87y1y94z15.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1+g6dA1sui0moUveyuIccydr7wtsX1jHZ4=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: +
 kthread-make-it-clear-that-kthread_create_on_node-might-be-terminated-by-any-fatal-signal.patch
 added to -mm tree
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


Andrew are you still planning to push this comment fix upstream?

Eric

Andrew Morton <akpm@linux-foundation.org> writes:

> The patch titled
>      Subject: kthread: make it clear that kthread_create_on_node() might be terminated by any fatal signal
> has been added to the -mm tree.  Its filename is
>      kthread-make-it-clear-that-kthread_create_on_node-might-be-terminated-by-any-fatal-signal.patch
>
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/kthread-make-it-clear-that-kthread_create_on_node-might-be-terminated-by-any-fatal-signal.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/kthread-make-it-clear-that-kthread_create_on_node-might-be-terminated-by-any-fatal-signal.patch
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
>
> ------------------------------------------------------
> From: Petr Mladek <pmladek@suse.com>
> Subject: kthread: make it clear that kthread_create_on_node() might be terminated by any fatal signal
>
> The comments in kernel/kthread.c create a feeling that only SIGKILL is
> able to terminate the creation of kernel kthreads by
> kthread_create()/_on_node()/_on_cpu() APIs.
>
> In reality, wait_for_completion_killable() might be killed by any fatal
> signal that does not have a custom handler:
>
> 	(!siginmask(signr, SIG_KERNEL_IGNORE_MASK|SIG_KERNEL_STOP_MASK) && \
> 	 (t)->sighand->action[(signr)-1].sa.sa_handler == SIG_DFL)
>
> static inline void signal_wake_up(struct task_struct *t, bool resume)
> {
> 	signal_wake_up_state(t, resume ? TASK_WAKEKILL : 0);
> }
>
> static void complete_signal(int sig, struct task_struct *p, enum pid_type type)
> {
> [...]
> 	/*
> 	 * Found a killable thread.  If the signal will be fatal,
> 	 * then start taking the whole group down immediately.
> 	 */
> 	if (sig_fatal(p, sig) ...) {
> 		if (!sig_kernel_coredump(sig)) {
> 		[...]
> 			do {
> 				task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
> 				sigaddset(&t->pending.signal, SIGKILL);
> 				signal_wake_up(t, 1);
> 			} while_each_thread(p, t);
> 			return;
> 		}
> 	}
> }
>
> Update the comments in kernel/kthread.c to make this more obvious.
>
> The motivation for this change was debugging why a module initialization
> failed.  The module was being loaded from initrd.  It "magically" failed
> when systemd was switching to the real root.  The clean up operations sent
> SIGTERM to various pending processed that were started from initrd.
>
> Link: https://lkml.kernel.org/r/20220315102444.2380-1-pmladek@suse.com
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Marco Elver <elver@google.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  kernel/kthread.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> --- a/kernel/kthread.c~kthread-make-it-clear-that-kthread_create_on_node-might-be-terminated-by-any-fatal-signal
> +++ a/kernel/kthread.c
> @@ -341,7 +341,7 @@ static int kthread(void *_create)
>  
>  	self = to_kthread(current);
>  
> -	/* If user was SIGKILLed, I release the structure. */
> +	/* Release the structure when caller killed by a fatal signal. */
>  	done = xchg(&create->done, NULL);
>  	if (!done) {
>  		kfree(create);
> @@ -399,7 +399,7 @@ static void create_kthread(struct kthrea
>  	/* We want our own signal handler (we take no signals by default). */
>  	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
>  	if (pid < 0) {
> -		/* If user was SIGKILLed, I release the structure. */
> +		/* Release the structure when caller killed by a fatal signal. */
>  		struct completion *done = xchg(&create->done, NULL);
>  
>  		if (!done) {
> @@ -441,9 +441,9 @@ struct task_struct *__kthread_create_on_
>  	 */
>  	if (unlikely(wait_for_completion_killable(&done))) {
>  		/*
> -		 * If I was SIGKILLed before kthreadd (or new kernel thread)
> -		 * calls complete(), leave the cleanup of this structure to
> -		 * that thread.
> +		 * If I was killed by a fatal signal before kthreadd (or new
> +		 * kernel thread) calls complete(), leave the cleanup of this
> +		 * structure to that thread.
>  		 */
>  		if (xchg(&create->done, NULL))
>  			return ERR_PTR(-EINTR);
> @@ -877,7 +877,7 @@ fail_task:
>   *
>   * Returns a pointer to the allocated worker on success, ERR_PTR(-ENOMEM)
>   * when the needed structures could not get allocated, and ERR_PTR(-EINTR)
> - * when the worker was SIGKILLed.
> + * when the caller was killed by a fatal signal.
>   */
>  struct kthread_worker *
>  kthread_create_worker(unsigned int flags, const char namefmt[], ...)
> @@ -926,7 +926,7 @@ EXPORT_SYMBOL(kthread_create_worker);
>   * Return:
>   * The pointer to the allocated worker on success, ERR_PTR(-ENOMEM)
>   * when the needed structures could not get allocated, and ERR_PTR(-EINTR)
> - * when the worker was SIGKILLed.
> + * when the caller was killed by a fatal signal.
>   */
>  struct kthread_worker *
>  kthread_create_worker_on_cpu(int cpu, unsigned int flags,
> _
>
> Patches currently in -mm which might be from pmladek@suse.com are
>
> kthread-make-it-clear-that-kthread_create_on_node-might-be-terminated-by-any-fatal-signal.patch
