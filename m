Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988D448BD24
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 18:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786040309; cv=none; b=iLMDslFMFIkogMYK7KoGlm9UoO4QHY46aYupxZat5JUaidnOM8a3Pbz/5bvc54QTGE0oc5N35FKd+HgaURABcibgniXVOMQqPixWhvHc0V0zDYaEBitTwKqy6EiSb+5bZywM/9bfoDF/JaaN9YkS5Xj7c90xH9iUb4RVb3Sl6is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786040309; c=relaxed/simple;
	bh=ql+U1vlHcMwN7OA3KAbHpOy7Q4AXqy6uE2KPp38E+jM=;
	h=Date:To:From:Subject:Message-Id; b=pxsoK3YLD4wyVCCe4I/8mWnb+K2kfh0qF3AQ819OkJP7dssmKnRrTDkqN8arwzpbDgKXhpp27WHv34+lzjk73AYXZmoOtZhJg4ncdfMGZkjPgPX6I2L/rUgScEy2qOvWMbHRrZTlIHB0bloFYT8Hwc7edaVTKwvuWWT0n5MBgOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0UyL/exr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0UyL/exr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1451F000E9;
	Thu,  6 Aug 2026 18:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786040305;
	bh=wXSycEQ4dSQMGQVV5OpxvsgURelvJ8e2Lr/v+dw2BF4=;
	h=Date:To:From:Subject;
	b=0UyL/exrj4WAuK6RPJD72z1Yh4VWmzTv8ZHaEAY+OJaQXsluwea0Cn7nV7s9iYePi
	 Ph7e6EMipAn5GcJaQCuILyQvmKyo1Ivv1wgMBqd9NHBkeXUiuhZuuyKg9E3is3uSaJ
	 izAErD1VY0TlAAB7bKf08yjqmnUw/97Z2jI4A6BU=
Date: Thu, 06 Aug 2026 11:18:24 -0700
To: mm-commits@vger.kernel.org,tglx@kernel.org,oleg@redhat.com,brauner@kernel.org,akpm@linux-foundation.org,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + signal-factor-out-the-kernel-reserved-si_code-check.patch added to mm-nonmm-unstable branch
Message-Id: <20260806181825.8D1451F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: signal: factor out the kernel reserved si_code check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     signal-factor-out-the-kernel-reserved-si_code-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/signal-factor-out-the-kernel-reserved-si_code-check.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Bradley Morgan <include@grrlz.net>
Subject: signal: factor out the kernel reserved si_code check
Date: Thu, 6 Aug 2026 13:30:13 +0000

The check that prevents userspace from sending siginfo with si_code values
reserved to the kernel is duplicated across do_rt_sigqueueinfo(),
do_rt_tgsigqueueinfo() and do_pidfd_send_signal().  Move the check into a
helper so the rule lives in one place.

Link: https://lore.kernel.org/20260806133013.4341-1-include@grrlz.net
Signed-off-by: Bradley Morgan <include@grrlz.net>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/kernel/signal.c~signal-factor-out-the-kernel-reserved-si_code-check
+++ a/kernel/signal.c
@@ -3944,6 +3944,15 @@ static void prepare_kill_siginfo(int sig
 	info->si_uid = from_kuid_munged(current_user_ns(), current_uid());
 }
 
+/*
+ * Not even root can pretend to send SI_FROMKERNEL() signals.
+ * Nor can they impersonate kill()/tgkill(), which have si_pid/uid
+ */
+static bool si_code_reserved_to_kernel(int si_code)
+{
+	return si_code >= 0 || si_code == SI_TKILL;
+}
+
 /**
  *  sys_kill - send a signal to a process
  *  @pid: the PID of the process
@@ -4035,7 +4044,7 @@ static int do_pidfd_send_signal(struct p
 
 		/* Only allow sending arbitrary signals to yourself. */
 		if ((task_pid(current) != pid || type > PIDTYPE_TGID) &&
-		    (kinfo.si_code >= 0 || kinfo.si_code == SI_TKILL))
+		    si_code_reserved_to_kernel(kinfo.si_code))
 			return -EPERM;
 	} else {
 		prepare_kill_siginfo(sig, &kinfo, type);
@@ -4190,11 +4199,8 @@ SYSCALL_DEFINE2(tkill, pid_t, pid, int,
 
 static int do_rt_sigqueueinfo(pid_t pid, int sig, kernel_siginfo_t *info)
 {
-	/* Not even root can pretend to send signals from the kernel.
-	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
-	 */
-	if ((info->si_code >= 0 || info->si_code == SI_TKILL) &&
-	    (task_pid_vnr(current) != pid))
+	if (si_code_reserved_to_kernel(info->si_code) &&
+	    task_pid_vnr(current) != pid)
 		return -EPERM;
 
 	/* POSIX.1b doesn't mention process groups.  */
@@ -4237,11 +4243,8 @@ static int do_rt_tgsigqueueinfo(pid_t tg
 	if (pid <= 0 || tgid <= 0)
 		return -EINVAL;
 
-	/* Not even root can pretend to send signals from the kernel.
-	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
-	 */
-	if ((info->si_code >= 0 || info->si_code == SI_TKILL) &&
-	    (task_pid_vnr(current) != pid))
+	if (si_code_reserved_to_kernel(info->si_code) &&
+	    task_pid_vnr(current) != pid)
 		return -EPERM;
 
 	return do_send_specific(tgid, pid, sig, info);
_

Patches currently in -mm which might be from include@grrlz.net are

taskstats-drop-the-dead-null-attribute-check-in-parse.patch
taskstats-fold-the-two-cpumask-handlers-into-one.patch
taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch
signal-factor-out-the-kernel-reserved-si_code-check.patch

