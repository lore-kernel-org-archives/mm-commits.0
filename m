Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_RED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B535C4743D
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 05:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1F0960FE3
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 05:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhFKFB6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Jun 2021 01:01:58 -0400
Received: from mail-oln040092075046.outbound.protection.outlook.com ([40.92.75.46]:56494
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229562AbhFKFB6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Jun 2021 01:01:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8LgnyQcAVXI0ZuTz5jp9cFMkZby425vflAOqcTT6RLEbHneRvEF2TFWWfaaL36Diyo9romfaJwR80UECsR4y4MK+Me8b/1xB9RllZNrCbBJPrYDFCNDeZI53OVNgMZ6UVD8Q45l9D2F8OmmhgSjOSOgdPn84Qcv6LJhgI3+nUNPcFv4n8pv0hepMYwdcVspKJMEN1juJYBSAm/UWDioFNlSqsZFjDsW1zhtftVC000mb5FM1MjiD6JsmeibXB2llDDGSFmqHMV/3lqkiVkQcFoliHNVQaUlV1SRG50AhV+0osY8FJQWyXBwjNdvmxG4HEbJCP6ijZzzXJehqErHDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W5bNHDtbcLljxmdTp+fq27jKaNwqhCuDYpI+HODFcC8=;
 b=ZzlBuoS+GU+EuWHas+Gx8C0IJEEekz0zKzFKOkltCxIlqewesiKolyJW7HraNXRPVsxrQt1jQeFrFzcsM459cooe/83y9RgNmzgMiAqkdQfr0Puvb+T/rv/9cL0ES4MtjVISIcwd5DSgR/6t3+8rZUZ5ghXFVGXidBmacWO6NgxL83BZG3aKe+0mFoH88LShaRhOfOWuq6j4nnXwiDhSkRukL26CuYFjR13ya6rBW0IPXIRZtY4UiRXbNLedrzU1nhjSPy+Y8K2ceKGNhiKhnZJptqachrcIkCR7FGNLqVS+UvzL8MQcKZhNOsHEw5WUv2zXbJSaErTG7Y0we0oyxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from VI1EUR04FT014.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0e::4d) by
 VI1EUR04HT156.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0e::139)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Fri, 11 Jun
 2021 04:59:57 +0000
Received: from AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM
 (2a01:111:e400:7e0e::51) by VI1EUR04FT014.mail.protection.outlook.com
 (2a01:111:e400:7e0e::172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Fri, 11 Jun 2021 04:59:57 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:DB4AFAAAF2820B56B72291E2F9B24897A9A6456090B7D53D78351F0DE45B4043;UpperCasedChecksum:4FD573D26E1416737E773351016080A7ADF48D35E46E8D26EE946D523CF2BEFA;SizeAsReceived:8296;Count:47
Received: from AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::e5e5:7b7a:5ea5:c75a]) by AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::e5e5:7b7a:5ea5:c75a%7]) with mapi id 15.20.4219.021; Fri, 11 Jun 2021
 04:59:57 +0000
Subject: Re: + exec-fix-dead-lock-in-de_thread-with-ptrace_attach.patch added
 to -mm tree
To:     akpm@linux-foundation.org, adobriyan@gmail.com, areber@redhat.com,
        axboe@kernel.dk, chaithco@redhat.com, christian.brauner@ubuntu.com,
        deller@gmx.de, ebiederm@xmission.com, jamorris@linux.microsoft.com,
        keescook@chromium.org, laoar.shao@gmail.com, luto@amacapital.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, oleg@redhat.com,
        serge@hallyn.com, shuah@kernel.org, surenb@google.com,
        tglx@linutronix.de, viro@zeniv.linux.org.uk, wad@chromium.org,
        yifeifz2@illinois.edu
References: <20210610213914.vjORPvaBB%akpm@linux-foundation.org>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AM8PR10MB4708CBDC4A00F5ADEE69958AE4349@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
Date:   Fri, 11 Jun 2021 06:59:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <20210610213914.vjORPvaBB%akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TMN:  [pYUiu9heXegR43Gkz4ciVDW39ZPlouq6]
X-ClientProxiedBy: PR3P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:102:b6::7) To AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:364::23)
X-Microsoft-Original-Message-ID: <0135a619-f876-7dec-a24f-e292a18f3207@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (84.57.61.94) by PR3P195CA0002.EURP195.PROD.OUTLOOK.COM (2603:10a6:102:b6::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Fri, 11 Jun 2021 04:59:56 +0000
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 47
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 0e4b24f6-9870-480d-c448-08d92c95c245
X-MS-TrafficTypeDiagnostic: VI1EUR04HT156:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FpWBrLJAiYrniaFuBOANpqj0eaL+QQTJCzTU8wsTgmEk5LuuqhDwNYv1QSuNFi8RAe5VYA/bhyf6Ed+zXAIpePr8LB1RabznYPTKYrTMM2Ddj9MFNTV5OxWKTj6zlNXmfh/LCNm3gozJ2+1SIjOBvkTbKXa3DcZj496uxJIWu4U7Y8kkk14qby6YrgNORm7Qydk/s3/9vZljUaoKBO3tPgNNI/cLXae6sYLKb0tflGuG9qQskI3cGWJdfQfrw3UgupDgIg0uEykL2D52GDV7PT13QcmcyArYDGA67Cq6MbygtPdCSWcfTIpFT2y142Q3Rd4A1JC+xx7daZtX3cwVEyNJuiaOEtQZDbGLvQNVgxQlajpSHt7Tg9gevP9XZmBY5Drgo9kXbhrmnYsqRkZrvoy0Dkuwm8wF9vIPnD9RyR5BoZUr+V9ktt+i7OxnAfPm7Yr9rVJa5wJtB43wSbkU38LiwjM9kiHCb0Ap7s/2ecY=
X-MS-Exchange-AntiSpam-MessageData: 7ByVqpYsqCGdDj4CHF0WDJ0MU0S6Snt61K1T8dvMWfclOJ0JHF+LmGUe+38r0gq09RMp2wMEWWcRNFp7gwmBLlcAkH4BtcXxJbre42KTY2f7IwhZp/JDnQAlaNcZPtT1QZVg3OU6leB5KxMZ4Van1A==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e4b24f6-9870-480d-c448-08d92c95c245
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 04:59:57.4321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR04FT014.eop-eur04.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1EUR04HT156
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 6/10/21 11:39 PM, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: exec: fix deadlock in de_thread with ptrace_attach
> has been added to the -mm tree.  Its filename is
>      exec-fix-dead-lock-in-de_thread-with-ptrace_attach.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/exec-fix-dead-lock-in-de_thread-with-ptrace_attach.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/exec-fix-dead-lock-in-de_thread-with-ptrace_attach.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 

Thanks!

Maybe You should also consider those two patches in the same function:

[PATCH] Fix error handling in begin_new_exec
https://lore.kernel.org/linux-fsdevel/87mts2kcrm.fsf@disp2133/T/#t

[PATCH] exec: Copy oldsighand->action under spin-lock
https://lore.kernel.org/linux-fsdevel/202106071617.5713E0A01@keescook/T/#t


Bernd.

> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Bernd Edlinger <bernd.edlinger@hotmail.de>
> Subject: exec: fix deadlock in de_thread with ptrace_attach
> 
> This introduces signal->unsafe_execve_in_progress, which is used to fix
> the case when at least one of the sibling threads is traced, and therefore
> the trace process may deadlock in ptrace_attach, but de_thread will need
> to wait for the tracer to continue execution.
> 
> The solution is to detect this situation and allow ptrace_attach to
> continue, while de_thread() is still waiting for traced zombies to be
> eventually released.  When the current thread changed the ptrace status
> from non-traced to traced, we can simply abort the whole execve and
> restart it by returning -ERESTARTSYS.  This needs to be done before
> changing the thread leader, because the PTRACE_EVENT_EXEC needs to know
> the old thread pid.
> 
> Although it is technically after the point of no return, we just have to
> reset bprm->point_of_no_return here, since at this time only the other
> threads have received a fatal signal, not the current thread.
> 
> The user's point of view it that the whole execve was simply delayed until
> after the ptrace_attach.
> 
> Other threads die quickly since the cred_guard_mutex is released, but a
> deadly signal is already pending.  In case the mutex_lock_killable misses
> the signal, ->unsafe_execve_in_progress makes sure they release the mutex
> immediately and return with -ERESTARTNOINTR.
> 
> This means there is no API change, unlike the previous version of this
> patch which was discussed here:
> 
> https://lore.kernel.org/lkml/b6537ae6-31b1-5c50-f32b-8b8332ace882@hotmail.de/
> 
> See tools/testing/selftests/ptrace/vmaccess.c for a test case that gets
> fixed by this change.
> 
> Note that since the test case was originally designed to test the
> ptrace_attach returning an error in this situation, the test expectation
> needed to be adjusted, to allow the API to succeed at the first attempt.
> 
> Link: https://lkml.kernel.org/r/Message-ID:
> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Will Drewry <wad@chromium.org>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Serge Hallyn <serge@hallyn.com>
> Cc: James Morris <jamorris@linux.microsoft.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Charles Haithcock <chaithco@redhat.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Yafang Shao <laoar.shao@gmail.com>
> Cc: Helge Deller <deller@gmx.de>
> Cc: YiFei Zhu <yifeifz2@illinois.edu>
> Cc: Adrian Reber <areber@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/exec.c                                 |   45 ++++++++++++++++----
>  fs/proc/base.c                            |    6 ++
>  include/linux/sched/signal.h              |   13 +++++
>  kernel/ptrace.c                           |    9 ++++
>  kernel/seccomp.c                          |   12 ++++-
>  tools/testing/selftests/ptrace/vmaccess.c |   25 +++++++----
>  6 files changed, 92 insertions(+), 18 deletions(-)
> 
> --- a/fs/exec.c~exec-fix-dead-lock-in-de_thread-with-ptrace_attach
> +++ a/fs/exec.c
> @@ -1037,6 +1037,8 @@ static int de_thread(struct task_struct
>  	struct signal_struct *sig = tsk->signal;
>  	struct sighand_struct *oldsighand = tsk->sighand;
>  	spinlock_t *lock = &oldsighand->siglock;
> +	unsigned int prev_ptrace = tsk->ptrace;
> +	struct task_struct *t = tsk;
>  
>  	if (thread_group_empty(tsk))
>  		goto no_thread_group;
> @@ -1054,20 +1056,40 @@ static int de_thread(struct task_struct
>  		return -EAGAIN;
>  	}
>  
> +	while_each_thread(tsk, t) {
> +		if (unlikely(t->ptrace) && t != tsk->group_leader)
> +			sig->unsafe_execve_in_progress = true;
> +	}
> +
>  	sig->group_exit_task = tsk;
>  	sig->notify_count = zap_other_threads(tsk);
>  	if (!thread_group_leader(tsk))
>  		sig->notify_count--;
> +	spin_unlock_irq(lock);
>  
> -	while (sig->notify_count) {
> -		__set_current_state(TASK_KILLABLE);
> -		spin_unlock_irq(lock);
> +	if (unlikely(sig->unsafe_execve_in_progress))
> +		mutex_unlock(&sig->cred_guard_mutex);
> +
> +	for (;;) {
> +		set_current_state(TASK_KILLABLE);
> +		if (!sig->notify_count)
> +			break;
>  		schedule();
>  		if (__fatal_signal_pending(tsk))
>  			goto killed;
> -		spin_lock_irq(lock);
>  	}
> -	spin_unlock_irq(lock);
> +	__set_current_state(TASK_RUNNING);
> +
> +	if (unlikely(sig->unsafe_execve_in_progress)) {
> +		if (mutex_lock_killable(&sig->cred_guard_mutex))
> +			goto killed;
> +		sig->unsafe_execve_in_progress = false;
> +		if (!prev_ptrace && tsk->ptrace) {
> +			sig->group_exit_task = NULL;
> +			sig->notify_count = 0;
> +			return -ERESTARTSYS;
> +		}
> +	}
>  
>  	/*
>  	 * At this point all other threads have exited, all we have to
> @@ -1252,8 +1274,11 @@ int begin_new_exec(struct linux_binprm *
>  	 * Make this the only thread in the thread group.
>  	 */
>  	retval = de_thread(me);
> -	if (retval)
> +	if (retval) {
> +		if (retval == -ERESTARTSYS)
> +			bprm->point_of_no_return = false;
>  		goto out;
> +	}
>  
>  	/*
>  	 * Cancel any io_uring activity across execve
> @@ -1460,6 +1485,11 @@ static int prepare_bprm_creds(struct lin
>  	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
>  		return -ERESTARTNOINTR;
>  
> +	if (unlikely(current->signal->unsafe_execve_in_progress)) {
> +		mutex_unlock(&current->signal->cred_guard_mutex);
> +		return -ERESTARTNOINTR;
> +	}
> +
>  	bprm->cred = prepare_exec_creds();
>  	if (likely(bprm->cred))
>  		return 0;
> @@ -1476,7 +1506,8 @@ static void free_bprm(struct linux_binpr
>  	}
>  	free_arg_pages(bprm);
>  	if (bprm->cred) {
> -		mutex_unlock(&current->signal->cred_guard_mutex);
> +		if (!current->signal->unsafe_execve_in_progress)
> +			mutex_unlock(&current->signal->cred_guard_mutex);
>  		abort_creds(bprm->cred);
>  	}
>  	if (bprm->file) {
> --- a/fs/proc/base.c~exec-fix-dead-lock-in-de_thread-with-ptrace_attach
> +++ a/fs/proc/base.c
> @@ -2748,6 +2748,12 @@ static ssize_t proc_pid_attr_write(struc
>  	if (rv < 0)
>  		goto out_free;
>  
> +	if (unlikely(current->signal->unsafe_execve_in_progress)) {
> +		mutex_unlock(&current->signal->cred_guard_mutex);
> +		rv = -ERESTARTNOINTR;
> +		goto out_free;
> +	}
> +
>  	rv = security_setprocattr(PROC_I(inode)->op.lsm,
>  				  file->f_path.dentry->d_name.name, page,
>  				  count);
> --- a/include/linux/sched/signal.h~exec-fix-dead-lock-in-de_thread-with-ptrace_attach
> +++ a/include/linux/sched/signal.h
> @@ -214,6 +214,17 @@ struct signal_struct {
>  #endif
>  
>  	/*
> +	 * Set while execve is executing but is *not* holding
> +	 * cred_guard_mutex to avoid possible dead-locks.
> +	 * The cred_guard_mutex is released *after* de_thread() has
> +	 * called zap_other_threads(), therefore a fatal signal is
> +	 * guaranteed to be already pending in the unlikely event, that
> +	 * current->signal->unsafe_execve_in_progress happens to be
> +	 * true after the cred_guard_mutex was acquired.
> +	 */
> +	bool unsafe_execve_in_progress;
> +
> +	/*
>  	 * Thread is the potential origin of an oom condition; kill first on
>  	 * oom
>  	 */
> @@ -227,6 +238,8 @@ struct signal_struct {
>  	struct mutex cred_guard_mutex;	/* guard against foreign influences on
>  					 * credential calculations
>  					 * (notably. ptrace)
> +					 * Held while execve runs, except when
> +					 * a sibling thread is being traced.
>  					 * Deprecated do not use in new code.
>  					 * Use exec_update_lock instead.
>  					 */
> --- a/kernel/ptrace.c~exec-fix-dead-lock-in-de_thread-with-ptrace_attach
> +++ a/kernel/ptrace.c
> @@ -485,6 +485,14 @@ static int ptrace_traceme(void)
>  {
>  	int ret = -EPERM;
>  
> +	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
> +		return -ERESTARTNOINTR;
> +
> +	if (unlikely(current->signal->unsafe_execve_in_progress)) {
> +		mutex_unlock(&current->signal->cred_guard_mutex);
> +		return -ERESTARTNOINTR;
> +	}
> +
>  	write_lock_irq(&tasklist_lock);
>  	/* Are we already being traced? */
>  	if (!current->ptrace) {
> @@ -500,6 +508,7 @@ static int ptrace_traceme(void)
>  		}
>  	}
>  	write_unlock_irq(&tasklist_lock);
> +	mutex_unlock(&current->signal->cred_guard_mutex);
>  
>  	return ret;
>  }
> --- a/kernel/seccomp.c~exec-fix-dead-lock-in-de_thread-with-ptrace_attach
> +++ a/kernel/seccomp.c
> @@ -1833,9 +1833,15 @@ static long seccomp_set_mode_filter(unsi
>  	 * Make sure we cannot change seccomp or nnp state via TSYNC
>  	 * while another thread is in the middle of calling exec.
>  	 */
> -	if (flags & SECCOMP_FILTER_FLAG_TSYNC &&
> -	    mutex_lock_killable(&current->signal->cred_guard_mutex))
> -		goto out_put_fd;
> +	if (flags & SECCOMP_FILTER_FLAG_TSYNC) {
> +		if (mutex_lock_killable(&current->signal->cred_guard_mutex))
> +			goto out_put_fd;
> +
> +		if (unlikely(current->signal->unsafe_execve_in_progress)) {
> +			mutex_unlock(&current->signal->cred_guard_mutex);
> +			goto out_put_fd;
> +		}
> +	}
>  
>  	spin_lock_irq(&current->sighand->siglock);
>  
> --- a/tools/testing/selftests/ptrace/vmaccess.c~exec-fix-dead-lock-in-de_thread-with-ptrace_attach
> +++ a/tools/testing/selftests/ptrace/vmaccess.c
> @@ -39,8 +39,15 @@ TEST(vmaccess)
>  	f = open(mm, O_RDONLY);
>  	ASSERT_GE(f, 0);
>  	close(f);
> -	f = kill(pid, SIGCONT);
> -	ASSERT_EQ(f, 0);
> +	f = waitpid(-1, NULL, 0);
> +	ASSERT_NE(f, -1);
> +	ASSERT_NE(f, 0);
> +	ASSERT_NE(f, pid);
> +	f = waitpid(-1, NULL, 0);
> +	ASSERT_EQ(f, pid);
> +	f = waitpid(-1, NULL, 0);
> +	ASSERT_EQ(f, -1);
> +	ASSERT_EQ(errno, ECHILD);
>  }
>  
>  TEST(attach)
> @@ -57,22 +64,24 @@ TEST(attach)
>  
>  	sleep(1);
>  	k = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
> -	ASSERT_EQ(errno, EAGAIN);
> -	ASSERT_EQ(k, -1);
> +	ASSERT_EQ(k, 0);
>  	k = waitpid(-1, &s, WNOHANG);
>  	ASSERT_NE(k, -1);
>  	ASSERT_NE(k, 0);
>  	ASSERT_NE(k, pid);
>  	ASSERT_EQ(WIFEXITED(s), 1);
>  	ASSERT_EQ(WEXITSTATUS(s), 0);
> -	sleep(1);
> -	k = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
> -	ASSERT_EQ(k, 0);
>  	k = waitpid(-1, &s, 0);
>  	ASSERT_EQ(k, pid);
>  	ASSERT_EQ(WIFSTOPPED(s), 1);
>  	ASSERT_EQ(WSTOPSIG(s), SIGSTOP);
> -	k = ptrace(PTRACE_DETACH, pid, 0L, 0L);
> +	k = ptrace(PTRACE_CONT, pid, 0L, 0L);
> +	ASSERT_EQ(k, 0);
> +	k = waitpid(-1, &s, 0);
> +	ASSERT_EQ(k, pid);
> +	ASSERT_EQ(WIFSTOPPED(s), 1);
> +	ASSERT_EQ(WSTOPSIG(s), SIGTRAP);
> +	k = ptrace(PTRACE_CONT, pid, 0L, 0L);
>  	ASSERT_EQ(k, 0);
>  	k = waitpid(-1, &s, 0);
>  	ASSERT_EQ(k, pid);
> _
> 
> Patches currently in -mm which might be from bernd.edlinger@hotmail.de are
> 
> exec-fix-dead-lock-in-de_thread-with-ptrace_attach.patch
> 
