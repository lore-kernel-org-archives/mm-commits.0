Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132A8320CC1
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 11:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755603464; cv=none; b=Koh9eFqNx+vvCTHH88fZScad1x1I7ESzTrMcVtC5TaXhGgcRN8PDRL2ja9stXHOOnsonDHmB1jApX7Kxr/psNgolSi4elr0AOXPRnXJKr5fiowLNU1exDQZ1WGY49Cm9DR5bPAsZIfAZq/o20J9JGXXgWLym5ayh/UmAKw0g+Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755603464; c=relaxed/simple;
	bh=fy3djch+/qGywQ75KHuWrpscrh15G6eduxsRX37BQFw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=FuR4Rh3Bc5+obUkaj1BFr2V0Nh6D2fxp6m88E52TyjRMbVjwvnNK0JvmE9ECJ1t4O+BEDjuhgTIq8QZRNstGb6uWESdZnxR9o1hlvxEVfen1Nlkg25rsFA8wtJxsC2LWINKpb0Iiht06tHhOax1dkeZNKadBN1x5dcid/tpEF/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fBkDjo4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fBkDjo4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEB7C113D0;
	Tue, 19 Aug 2025 11:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755603463;
	bh=fy3djch+/qGywQ75KHuWrpscrh15G6eduxsRX37BQFw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=fBkDjo4+8ygaxaw2jvxWOCUZcG3lff0twQ1kV/23HkAyq2gBLfOsISXt6i4j7vIP6
	 VlBAhMG0oVFl8zjYtLRvy6Doh4kdzBwaNEGn9zHKtvlFNUuiRCdctmrvu5o2woaiOu
	 d91nHkSYmTx6rmQD98sLMw+S/ML7o6dCcwRultb/puIPr0u/gljpJFrYVHQ98clK1e
	 16EytU5xruaQYoO/qFa9jAZZM1aMsVVq4asHjpLwrPUuEMxQpT87hN5AXh3Mjl0jfl
	 11PEFJPgPHu73iuBEKLvQMO2BAbDgQ0yG7V/uP4Isv9OzE9S4odPrHBmCy0M3Oseau
	 7SKIKoDQ4ccMw==
Date: Tue, 19 Aug 2025 13:37:39 +0200
From: Christian Brauner <brauner@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, mjguzik@gmail.com, 
	gaoxiang17@xiaomi.com, oleg@redhat.com
Subject: Re: + pid-change-task_state-to-use-task_ppid_nr_ns.patch added to
 mm-nonmm-unstable branch
Message-ID: <20250819-polster-aufkreuzen-fbe16c668b4e@brauner>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250812013451.369B4C4CEED@smtp.kernel.org>
 <20250812013449.475A8C4CEF6@smtp.kernel.org>
 <20250812013446.EB2DAC4CEF5@smtp.kernel.org>
 <20250812013445.046F8C4CEED@smtp.kernel.org>

Andrew, would you please drop these four patches I'm taking them through
the pid{fs} tree.

On Mon, Aug 11, 2025 at 06:34:50PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: pid: change task_state() to use task_ppid_nr_ns()
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      pid-change-task_state-to-use-task_ppid_nr_ns.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pid-change-task_state-to-use-task_ppid_nr_ns.patch
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
> From: Oleg Nesterov <oleg@redhat.com>
> Subject: pid: change task_state() to use task_ppid_nr_ns()
> Date: Sun, 10 Aug 2025 19:36:20 +0200
> 
> To simplify the code.
> 
> Note that only tpid and max_fds really need rcu_read_lock(), we could move
> task_ppid_nr_ns/task_tgid_nr_ns/task_numa_group_id/get_task_cred outside
> of rcu read section.
> 
> Link: https://lkml.kernel.org/r/20250810173620.GA20007@redhat.com
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: gaoxiang17 <gaoxiang17@xiaomi.com>
> Cc: Mateusz Guzik <mjguzik@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/proc/array.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> --- a/fs/proc/array.c~pid-change-task_state-to-use-task_ppid_nr_ns
> +++ a/fs/proc/array.c
> @@ -157,13 +157,11 @@ static inline void task_state(struct seq
>  	unsigned int max_fds = 0;
>  
>  	rcu_read_lock();
> -	ppid = pid_alive(p) ?
> -		task_tgid_nr_ns(rcu_dereference(p->real_parent), ns) : 0;
> -
>  	tracer = ptrace_parent(p);
>  	if (tracer)
>  		tpid = task_pid_nr_ns(tracer, ns);
>  
> +	ppid = task_ppid_nr_ns(p, ns);
>  	tgid = task_tgid_nr_ns(p, ns);
>  	ngid = task_numa_group_id(p);
>  	cred = get_task_cred(p);
> _
> 
> Patches currently in -mm which might be from oleg@redhat.com are
> 
> pid-make-__task_pid_nr_nsns-=-null-safe-for-zombie-callers.patch
> pid-introduce-task_ppid_vnr.patch
> pid-change-bacct_add_tsk-to-use-task_ppid_nr_ns.patch
> pid-change-task_state-to-use-task_ppid_nr_ns.patch
> 

On Mon, Aug 11, 2025 at 06:34:48PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: pid: change bacct_add_tsk() to use task_ppid_nr_ns()
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      pid-change-bacct_add_tsk-to-use-task_ppid_nr_ns.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pid-change-bacct_add_tsk-to-use-task_ppid_nr_ns.patch
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
> From: Oleg Nesterov <oleg@redhat.com>
> Subject: pid: change bacct_add_tsk() to use task_ppid_nr_ns()
> Date: Sun, 10 Aug 2025 19:36:15 +0200
> 
> To simplify the code.
> 
> Link: https://lkml.kernel.org/r/20250810173615.GA20000@redhat.com
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: gaoxiang17 <gaoxiang17@xiaomi.com>
> Cc: Mateusz Guzik <mjguzik@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/tsacct.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- a/kernel/tsacct.c~pid-change-bacct_add_tsk-to-use-task_ppid_nr_ns
> +++ a/kernel/tsacct.c
> @@ -57,12 +57,11 @@ void bacct_add_tsk(struct user_namespace
>  	stats->ac_sched	 = tsk->policy;
>  	stats->ac_pid	 = task_pid_nr_ns(tsk, pid_ns);
>  	stats->ac_tgid   = task_tgid_nr_ns(tsk, pid_ns);
> +	stats->ac_ppid	 = task_ppid_nr_ns(tsk, pid_ns);
>  	rcu_read_lock();
>  	tcred = __task_cred(tsk);
>  	stats->ac_uid	 = from_kuid_munged(user_ns, tcred->uid);
>  	stats->ac_gid	 = from_kgid_munged(user_ns, tcred->gid);
> -	stats->ac_ppid	 = pid_alive(tsk) ?
> -		task_tgid_nr_ns(rcu_dereference(tsk->real_parent), pid_ns) : 0;
>  	rcu_read_unlock();
>  
>  	task_cputime(tsk, &utime, &stime);
> _
> 
> Patches currently in -mm which might be from oleg@redhat.com are
> 
> pid-make-__task_pid_nr_nsns-=-null-safe-for-zombie-callers.patch
> pid-introduce-task_ppid_vnr.patch
> pid-change-bacct_add_tsk-to-use-task_ppid_nr_ns.patch
> pid-change-task_state-to-use-task_ppid_nr_ns.patch
> 

On Mon, Aug 11, 2025 at 06:34:46PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: pid: introduce task_ppid_vnr()
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      pid-introduce-task_ppid_vnr.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pid-introduce-task_ppid_vnr.patch
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
> From: Oleg Nesterov <oleg@redhat.com>
> Subject: pid: introduce task_ppid_vnr()
> Date: Sun, 10 Aug 2025 19:36:10 +0200
> 
> For consistency with other task_xid_vnr() helpers.
> 
> Link: https://lkml.kernel.org/r/20250810173610.GA19995@redhat.com
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: gaoxiang17 <gaoxiang17@xiaomi.com>
> Cc: Mateusz Guzik <mjguzik@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/pidfs.c          |    2 +-
>  include/linux/pid.h |    5 +++++
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> --- a/fs/pidfs.c~pid-introduce-task_ppid_vnr
> +++ a/fs/pidfs.c
> @@ -397,7 +397,7 @@ static long pidfd_info(struct file *file
>  	 * the fields are set correctly, or return ESRCH to avoid providing
>  	 * incomplete information. */
>  
> -	kinfo.ppid = task_ppid_nr_ns(task, NULL);
> +	kinfo.ppid = task_ppid_vnr(task);
>  	kinfo.tgid = task_tgid_vnr(task);
>  	kinfo.pid = task_pid_vnr(task);
>  	kinfo.mask |= PIDFD_INFO_PID;
> --- a/include/linux/pid.h~pid-introduce-task_ppid_vnr
> +++ a/include/linux/pid.h
> @@ -310,6 +310,11 @@ static inline pid_t task_ppid_nr_ns(cons
>  	return pid;
>  }
>  
> +static inline pid_t task_ppid_vnr(const struct task_struct *tsk)
> +{
> +	return task_ppid_nr_ns(tsk, NULL);
> +}
> +
>  static inline pid_t task_ppid_nr(const struct task_struct *tsk)
>  {
>  	return task_ppid_nr_ns(tsk, &init_pid_ns);
> _
> 
> Patches currently in -mm which might be from oleg@redhat.com are
> 
> pid-make-__task_pid_nr_nsns-=-null-safe-for-zombie-callers.patch
> pid-introduce-task_ppid_vnr.patch
> pid-change-bacct_add_tsk-to-use-task_ppid_nr_ns.patch
> pid-change-task_state-to-use-task_ppid_nr_ns.patch
> 

On Mon, Aug 11, 2025 at 06:34:44PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: pid: make __task_pid_nr_ns(ns => NULL) safe for zombie callers
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      pid-make-__task_pid_nr_nsns-=-null-safe-for-zombie-callers.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pid-make-__task_pid_nr_nsns-=-null-safe-for-zombie-callers.patch
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
> From: Oleg Nesterov <oleg@redhat.com>
> Subject: pid: make __task_pid_nr_ns(ns => NULL) safe for zombie callers
> Date: Sun, 10 Aug 2025 19:36:04 +0200
> 
> task_pid_vnr(another_task) will crash if the caller was already reaped. 
> The pid_alive(current) check can't really help, the parent/debugger can
> call release_task() right after this check.
> 
> This also means that even task_ppid_nr_ns(current, NULL) is not safe,
> pid_alive() only ensures that it is safe to dereference ->real_parent.
> 
> Change __task_pid_nr_ns() to ensure ns != NULL.
> 
> Link: https://lore.kernel.org/all/20250802022123.3536934-1-gxxa03070307@gmail.com/
> Link: https://lkml.kernel.org/r/20250810173604.GA19991@redhat.com
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Originally-by: 高翔 <gaoxiang17@xiaomi.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Mateusz Guzik <mjguzik@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/pid.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/kernel/pid.c~pid-make-__task_pid_nr_nsns-=-null-safe-for-zombie-callers
> +++ a/kernel/pid.c
> @@ -514,7 +514,8 @@ pid_t __task_pid_nr_ns(struct task_struc
>  	rcu_read_lock();
>  	if (!ns)
>  		ns = task_active_pid_ns(current);
> -	nr = pid_nr_ns(rcu_dereference(*task_pid_ptr(task, type)), ns);
> +	if (ns)
> +		nr = pid_nr_ns(rcu_dereference(*task_pid_ptr(task, type)), ns);
>  	rcu_read_unlock();
>  
>  	return nr;
> _
> 
> Patches currently in -mm which might be from oleg@redhat.com are
> 
> pid-make-__task_pid_nr_nsns-=-null-safe-for-zombie-callers.patch
> pid-introduce-task_ppid_vnr.patch
> pid-change-bacct_add_tsk-to-use-task_ppid_nr_ns.patch
> pid-change-task_state-to-use-task_ppid_nr_ns.patch
> 
