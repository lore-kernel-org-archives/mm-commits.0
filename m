Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C35D1C7EE2E
	for <mm-commits@archiver.kernel.org>; Sun, 11 Jun 2023 20:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbjFKUcm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Jun 2023 16:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjFKUcl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Jun 2023 16:32:41 -0400
X-Greylist: delayed 1973 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 11 Jun 2023 13:32:40 PDT
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECF9E4E
        for <mm-commits@vger.kernel.org>; Sun, 11 Jun 2023 13:32:40 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:33516)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1q8RE0-005LWt-46; Sun, 11 Jun 2023 13:59:44 -0600
Received: from ip68-110-29-46.om.om.cox.net ([68.110.29.46]:57064 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1q8RDx-00FC0Q-RB; Sun, 11 Jun 2023 13:59:43 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, mcgrof@kernel.org,
        keescook@chromium.org, chenhuacai@loongson.cn
References: <20230605231056.16BD1C433D2@smtp.kernel.org>
Date:   Sun, 11 Jun 2023 14:59:35 -0500
In-Reply-To: <20230605231056.16BD1C433D2@smtp.kernel.org> (Andrew Morton's
        message of "Mon, 05 Jun 2023 16:10:55 -0700")
Message-ID: <87352x22jc.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1q8RDx-00FC0Q-RB;;;mid=<87352x22jc.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.110.29.46;;;frm=ebiederm@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX1+PhTkody+t7848kKhiIirQRl3MtaviSaY=
X-SA-Exim-Connect-IP: 68.110.29.46
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: + kthread-unify-kernel_thread-and-user_mode_thread.patch added
 to mm-nonmm-unstable branch
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> The patch titled
>      Subject: kthread: Unify kernel_thread() and user_mode_thread()
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      kthread-unify-kernel_thread-and-user_mode_thread.patch

Andrew.

My fuzzy memory thinks Linus asked for the current split.

Plus this change just obfuscates the code making the most important
detail the argument to a boolean parameter.  Meaning you have to have
an interface that has only 3 callers memorized to even begin to make
sense of it.

There are only about 3 callers so *shrug* it can be messed up and
we won't hurt much.  But ick.

Eric


> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kthread-unify-kernel_thread-and-user_mode_thread.patch
>
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Huacai Chen <chenhuacai@loongson.cn>
> Subject: kthread: Unify kernel_thread() and user_mode_thread()
> Date: Sat, 3 Jun 2023 09:53:02 +0800
>
> Commit 343f4c49f2438d8 ("kthread: Don't allocate kthread_struct for init
> and umh") introduces a new function user_mode_thread() for init and umh.
>
> init and umh are different from typical kernel threads since the don't
> need a "kthread" struct and they will finally become user processes by
> calling kernel_execve(), but on the other hand, they are also different
> from typical user mode threads (they have no "mm" structs at creation
> time, which is traditionally used to distinguish a user thread and a
> kernel thread).
>
> So I think it is reasonable to treat init and umh as "special kernel
> threads". Then let's unify the kernel_thread() and user_mode_thread()
> to kernel_thread() again, and add a new 'user' parameter for init and
> umh.
>
> This also makes code simpler.
>
> Link: https://lkml.kernel.org/r/20230603015302.1768127-1-chenhuacai@loongson.cn
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  include/linux/sched/task.h |    3 +--
>  init/main.c                |    4 ++--
>  kernel/fork.c              |   20 ++------------------
>  kernel/kthread.c           |    2 +-
>  kernel/umh.c               |    6 +++---
>  5 files changed, 9 insertions(+), 26 deletions(-)
>
> --- a/include/linux/sched/task.h~kthread-unify-kernel_thread-and-user_mode_thread
> +++ a/include/linux/sched/task.h
> @@ -100,8 +100,7 @@ struct task_struct *copy_process(struct
>  struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node);
>  struct task_struct *fork_idle(int);
>  extern pid_t kernel_thread(int (*fn)(void *), void *arg, const char *name,
> -			    unsigned long flags);
> -extern pid_t user_mode_thread(int (*fn)(void *), void *arg, unsigned long flags);
> +			    unsigned long flags, bool user);
>  extern long kernel_wait4(pid_t, int __user *, int, struct rusage *);
>  int kernel_wait(pid_t pid, int *stat);
>  
> --- a/init/main.c~kthread-unify-kernel_thread-and-user_mode_thread
> +++ a/init/main.c
> @@ -690,7 +690,7 @@ noinline void __ref __noreturn rest_init
>  	 * the init task will end up wanting to create kthreads, which, if
>  	 * we schedule it before we create kthreadd, will OOPS.
>  	 */
> -	pid = user_mode_thread(kernel_init, NULL, CLONE_FS);
> +	pid = kernel_thread(kernel_init, NULL, NULL, CLONE_FS, true);
>  	/*
>  	 * Pin init on the boot CPU. Task migration is not properly working
>  	 * until sched_init_smp() has been run. It will set the allowed
> @@ -703,7 +703,7 @@ noinline void __ref __noreturn rest_init
>  	rcu_read_unlock();
>  
>  	numa_default_policy();
> -	pid = kernel_thread(kthreadd, NULL, NULL, CLONE_FS | CLONE_FILES);
> +	pid = kernel_thread(kthreadd, NULL, NULL, CLONE_FS | CLONE_FILES, false);
>  	rcu_read_lock();
>  	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
>  	rcu_read_unlock();
> --- a/kernel/fork.c~kthread-unify-kernel_thread-and-user_mode_thread
> +++ a/kernel/fork.c
> @@ -2958,7 +2958,7 @@ pid_t kernel_clone(struct kernel_clone_a
>   * Create a kernel thread.
>   */
>  pid_t kernel_thread(int (*fn)(void *), void *arg, const char *name,
> -		    unsigned long flags)
> +		    unsigned long flags, bool user)
>  {
>  	struct kernel_clone_args args = {
>  		.flags		= ((lower_32_bits(flags) | CLONE_VM |
> @@ -2967,23 +2967,7 @@ pid_t kernel_thread(int (*fn)(void *), v
>  		.fn		= fn,
>  		.fn_arg		= arg,
>  		.name		= name,
> -		.kthread	= 1,
> -	};
> -
> -	return kernel_clone(&args);
> -}
> -
> -/*
> - * Create a user mode thread.
> - */
> -pid_t user_mode_thread(int (*fn)(void *), void *arg, unsigned long flags)
> -{
> -	struct kernel_clone_args args = {
> -		.flags		= ((lower_32_bits(flags) | CLONE_VM |
> -				    CLONE_UNTRACED) & ~CSIGNAL),
> -		.exit_signal	= (lower_32_bits(flags) & CSIGNAL),
> -		.fn		= fn,
> -		.fn_arg		= arg,
> +		.kthread	= !user,
>  	};
>  
>  	return kernel_clone(&args);
> --- a/kernel/kthread.c~kthread-unify-kernel_thread-and-user_mode_thread
> +++ a/kernel/kthread.c
> @@ -400,7 +400,7 @@ static void create_kthread(struct kthrea
>  #endif
>  	/* We want our own signal handler (we take no signals by default). */
>  	pid = kernel_thread(kthread, create, create->full_name,
> -			    CLONE_FS | CLONE_FILES | SIGCHLD);
> +			    CLONE_FS | CLONE_FILES | SIGCHLD, false);
>  	if (pid < 0) {
>  		/* Release the structure when caller killed by a fatal signal. */
>  		struct completion *done = xchg(&create->done, NULL);
> --- a/kernel/umh.c~kthread-unify-kernel_thread-and-user_mode_thread
> +++ a/kernel/umh.c
> @@ -130,7 +130,7 @@ static void call_usermodehelper_exec_syn
>  
>  	/* If SIGCLD is ignored do_wait won't populate the status. */
>  	kernel_sigaction(SIGCHLD, SIG_DFL);
> -	pid = user_mode_thread(call_usermodehelper_exec_async, sub_info, SIGCHLD);
> +	pid = kernel_thread(call_usermodehelper_exec_async, sub_info, NULL, SIGCHLD, true);
>  	if (pid < 0)
>  		sub_info->retval = pid;
>  	else
> @@ -169,8 +169,8 @@ static void call_usermodehelper_exec_wor
>  		 * want to pollute current->children, and we need a parent
>  		 * that always ignores SIGCHLD to ensure auto-reaping.
>  		 */
> -		pid = user_mode_thread(call_usermodehelper_exec_async, sub_info,
> -				       CLONE_PARENT | SIGCHLD);
> +		pid = kernel_thread(call_usermodehelper_exec_async, sub_info,
> +				       NULL, CLONE_PARENT | SIGCHLD, true);
>  		if (pid < 0) {
>  			sub_info->retval = pid;
>  			umh_complete(sub_info);
> _
>
> Patches currently in -mm which might be from chenhuacai@loongson.cn are
>
> kthread-unify-kernel_thread-and-user_mode_thread.patch
