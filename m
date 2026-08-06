Received: from latitanza.investici.org (latitanza.investici.org [185.218.207.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B09648C405
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 18:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.218.207.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786040863; cv=none; b=pYOHEVUddjljMBVy/j6FJO4NKjMOD7rplGrAHq2jxfgsHOBT/Ktg32Fc5ctD+ap7ti6VsE1MstXc5SPwdWqAEZHsC+GdCGeU3QYw28UI6c9rKcmYI9bfmVZMJzr4du/dD6sbak9CYK46K/I96q69JHxufC+wHaQk2RPtGnv/tb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786040863; c=relaxed/simple;
	bh=lmPzGjztyNd69RrNBEkLh8CXUCTgy1LlqzfgMW2cTYU=;
	h=Date:From:To:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=uumBaIPO/ayHYIpBvu/cp9mJFonvHttFodUMKbKGd0DTz8OLSLAkA0qxsbDdFgyL5guLXVFK9vXIyQ6RTmF4Jb04CsCK01J+/YVv/Xiwilkj2LysMVygRXHZin4RnyJ1Ucahw5DvJklUpLs1NgtcQW2arCugtWOlA7wT3ZpEmUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net; spf=pass smtp.mailfrom=grrlz.net; dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b=rOu51B8D; arc=none smtp.client-ip=185.218.207.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grrlz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b="rOu51B8D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1786040858;
	bh=zc/ucHz8C1kz8yWnmvh+iBPHmuhADy6uv6rferqp9DA=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=rOu51B8DQcSjO/2u1vnArmHj4zqHIP7yWk7B8Ee5UWSX+DYFJJI/wAoIzsGz1wjPU
	 xMEL5NAVXHnteI/vDuqK0J3nQRYYnCwdLJMt6JQVbdJJsa6G3wXQo697ZBSaC4Z3m/
	 UMfGL0EkRFbA2RLuF86BYeKXeYrqwlFrMkJPKlcc=
Received: from mx3.investici.org (unknown [127.0.0.1])
	by latitanza.investici.org (Postfix) with ESMTP id 4hGG3Z5Z7KzGpNr;
	Thu, 06 Aug 2026 18:27:38 +0000 (UTC)
Received: by mx3.investici.org (Postfix) id 4hGG3Z31MyzGpNw;
	Thu, 06 Aug 2026 18:27:38 +0000 (UTC)
Date: Thu, 06 Aug 2026 19:27:38 +0100
From: Bradley Morgan <include@grrlz.net>
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 tglx@kernel.org, oleg@redhat.com, brauner@kernel.org,
 akpm@linux-foundation.org
Subject: =?US-ASCII?Q?Re=3A_+_signal-factor-out-the-kernel-reserved-si=5Fc?=
 =?US-ASCII?Q?ode-check=2Epatch_added_to_mm-nonmm-unstable_branch?=
In-Reply-To: <20260806181825.8D1451F000E9@smtp.kernel.org>
References: <20260806181825.8D1451F000E9@smtp.kernel.org>
Message-ID: <631905F7-41C5-48F2-BA83-AF81B31D2128@grrlz.net>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 6 August 2026 19:18:24 BST, Andrew Morton <akpm@linux-foundation.org>
wrote:
>
>The patch titled
>     Subject: signal: factor out the kernel reserved si_code check
>has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>     signal-factor-out-the-kernel-reserved-si_code-check.patch
>
>This patch will shortly appear at
>     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/signal-factor-out-the-kernel-reserved-si_code-check.patch
>
>This patch will later appear in the mm-nonmm-unstable branch at
>    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
>Before you just go and hit "reply", please:
>   a) Consider who else should be cc'ed
>   b) Prefer to cc a suitable mailing list as well
>   c) Ideally: find the original patch on the mailing list and do a
>      reply-to-all to that, adding suitable additional cc's
>
>*** Remember to use Documentation/process/submit-checklist.rst when
>testing your code ***
>
>The -mm tree is included into linux-next via various
>branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>and is updated there most days
>
>------------------------------------------------------
>From: Bradley Morgan <include@grrlz.net>
>Subject: signal: factor out the kernel reserved si_code check
>Date: Thu, 6 Aug 2026 13:30:13 +0000
>
>The check that prevents userspace from sending siginfo with si_code values
>reserved to the kernel is duplicated across do_rt_sigqueueinfo(),
>do_rt_tgsigqueueinfo() and do_pidfd_send_signal().  Move the check into a
>helper so the rule lives in one place.
>
>Link: https://lore.kernel.org/20260806133013.4341-1-include@grrlz.net
>Signed-off-by: Bradley Morgan <include@grrlz.net>
>Reviewed-by: Andrew Morton <akpm@linux-foundation.org>

Thanks for the R-B, Oleg added his A-B btw.

>Cc: Christian Brauner <brauner@kernel.org>
>Cc: Oleg Nesterov <oleg@redhat.com>
>Cc: Thomas Gleixner <tglx@kernel.org>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>---
>
> kernel/signal.c |   25 ++++++++++++++-----------
> 1 file changed, 14 insertions(+), 11 deletions(-)
>
>--- a/kernel/signal.c~signal-factor-out-the-kernel-reserved-si_code-check
>+++ a/kernel/signal.c
>@@ -3944,6 +3944,15 @@ static void prepare_kill_siginfo(int sig
> 	info->si_uid = from_kuid_munged(current_user_ns(), current_uid());
> }
> 
>+/*
>+ * Not even root can pretend to send SI_FROMKERNEL() signals.
>+ * Nor can they impersonate kill()/tgkill(), which have si_pid/uid
>+ */
>+static bool si_code_reserved_to_kernel(int si_code)
>+{
>+	return si_code >= 0 || si_code == SI_TKILL;
>+}
>+
> /**
>  *  sys_kill - send a signal to a process
>  *  @pid: the PID of the process
>@@ -4035,7 +4044,7 @@ static int do_pidfd_send_signal(struct p
> 
> 		/* Only allow sending arbitrary signals to yourself. */
> 		if ((task_pid(current) != pid || type > PIDTYPE_TGID) &&
>-		    (kinfo.si_code >= 0 || kinfo.si_code == SI_TKILL))
>+		    si_code_reserved_to_kernel(kinfo.si_code))
> 			return -EPERM;
> 	} else {
> 		prepare_kill_siginfo(sig, &kinfo, type);
>@@ -4190,11 +4199,8 @@ SYSCALL_DEFINE2(tkill, pid_t, pid, int,
> 
> static int do_rt_sigqueueinfo(pid_t pid, int sig, kernel_siginfo_t *info)
> {
>-	/* Not even root can pretend to send signals from the kernel.
>-	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
>-	 */
>-	if ((info->si_code >= 0 || info->si_code == SI_TKILL) &&
>-	    (task_pid_vnr(current) != pid))
>+	if (si_code_reserved_to_kernel(info->si_code) &&
>+	    task_pid_vnr(current) != pid)
> 		return -EPERM;
> 
> 	/* POSIX.1b doesn't mention process groups.  */
>@@ -4237,11 +4243,8 @@ static int do_rt_tgsigqueueinfo(pid_t tg
> 	if (pid <= 0 || tgid <= 0)
> 		return -EINVAL;
> 
>-	/* Not even root can pretend to send signals from the kernel.
>-	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
>-	 */
>-	if ((info->si_code >= 0 || info->si_code == SI_TKILL) &&
>-	    (task_pid_vnr(current) != pid))
>+	if (si_code_reserved_to_kernel(info->si_code) &&
>+	    task_pid_vnr(current) != pid)
> 		return -EPERM;
> 
> 	return do_send_specific(tgid, pid, sig, info);
>_
>
>Patches currently in -mm which might be from include@grrlz.net are
>
>taskstats-drop-the-dead-null-attribute-check-in-parse.patch
>taskstats-fold-the-two-cpumask-handlers-into-one.patch
>taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch
>signal-factor-out-the-kernel-reserved-si_code-check.patch
>
>

Thanks!
