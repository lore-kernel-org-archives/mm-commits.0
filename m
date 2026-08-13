Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8D03FCB0C
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 22:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786660980; cv=none; b=na3rJNQkQKXNfwNNh3FZgrJ3q5E3Zdl3SP8BArL5BLQSpeVPO9JB1/vc2DtEW4MFmmENvPJ6FJK/0ZtZFtzdAmExNxnAoVdVYvYchPNcxB+Yy+04YShDlgWDnYQnqUu1wAKaRF1jIbXUlJ3f8OE99uvIDVQ4zBvZERDlaOyxSnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786660980; c=relaxed/simple;
	bh=vqiAzsvi2ri/ZZa0wajLcnajD1dInYntm5wgy+8gi0Q=;
	h=Date:To:From:Subject:Message-Id; b=dH1DP3UKUAQ+WB6zt6P0vfe0J05RFG9OExxsvROnrn24qtZ60IiNMnkj0RrINcMrJzcJ5+Mi0MtAAfdqLloL2q+gfM7r17BibWh7aZH4VsPGHayZl7K6BkJizYA+WRc2Rr38WfuBoG0CP7XB7OWsL++8bVk2UklOcZBGZ0G6jaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Og0vRuQ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Og0vRuQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F212C1F000E9;
	Thu, 13 Aug 2026 22:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786660977;
	bh=iIJb9vxsNIO5gD67iBfYYVXSfWbz+mh2fpB0sS5VAR8=;
	h=Date:To:From:Subject;
	b=Og0vRuQ9oLRazsHmLUUm0KlmMHEgQnMkjJqeHnK3UnRV69WHcGdYXhiewxMf8izye
	 KChEb5vSiArNy3ed5pxQOR0d5rH5b5Z246qX+YHbirJa0Sm0tc3VV71GnrFDL06ugh
	 Oq7itsE5bPv1NoBMPUIoAJz+q/xzygA66YHofhTY=
Date: Thu, 13 Aug 2026 15:42:56 -0700
To: mm-commits@vger.kernel.org,tglx@kernel.org,oleg@redhat.com,brauner@kernel.org,akpm@linux-foundation.org,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] signal-factor-out-the-kernel-reserved-si_code-check.patch removed from -mm tree
Message-Id: <20260813224256.F212C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: signal: factor out the kernel reserved si_code check
has been removed from the -mm tree.  Its filename was
     signal-factor-out-the-kernel-reserved-si_code-check.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
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

prctl-fix-pr_set_mm_auxv-losing-the-forced-at_null-terminator.patch
taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch

