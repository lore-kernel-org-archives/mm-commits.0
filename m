Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1882956773
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970529; cv=none; b=qFgm6zF6YH9awScWnRYA//49c9D5PJqKSLZOrvAIAzIcaRiEd3GzVeRP/gHqnskTpkE0fRFUxwG/xuCgGwAex5hhs4OwOfrVN6Rz48emJyl2cRdYE0XTXkk+4QP0RCjm9Bh4R8tqOyKDS+6i7f8V72CKgslbK9cXNdzBt642RHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970529; c=relaxed/simple;
	bh=cz/OgjC12bvEQXMRV0SEo7ZIrtWcoYME1vBoU+aAs6Q=;
	h=Date:To:From:Subject:Message-Id; b=lbJ/1JEnJoWHjido+Hj2I2NyQBFNakvka8oJ3EebUec89MHmorsDfG5qI/wWlxudGmQjwXlpsHoGfVtXXLXg3Sqo+WL484IJkiD8T6AqzXByFNZGjblTmlCoJ088ZzUTrSiHUF7gGtcRODi3z1nZoVHRZwzN7DCqhHTgF/jX9c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gh9NqkOP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gh9NqkOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9ECC433C7;
	Tue, 23 Jan 2024 00:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970528;
	bh=cz/OgjC12bvEQXMRV0SEo7ZIrtWcoYME1vBoU+aAs6Q=;
	h=Date:To:From:Subject:From;
	b=Gh9NqkOP8mpivM/ITds95TyCqq4V8Wy3OXvQs05Nf+VrqekKlWhuHhczGjL3KP+1N
	 aor8NpKtBSqMBoFvLhHC/QknMmdaQVS2yCgnPcS3PPOMJDa3DytUE3a9x9XUS049zT
	 sO9nB3EbhE+Fl27sHfMdyzTbl27vjqTKCjgcwOU4=
Date: Mon, 22 Jan 2024 16:42:05 -0800
To: mm-commits@vger.kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ptrace_attach-shift-sendsigstop-into-ptrace_set_stopped.patch added to mm-nonmm-unstable branch
Message-Id: <20240123004208.6C9ECC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ptrace_attach: shift send(SIGSTOP) into ptrace_set_stopped()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ptrace_attach-shift-sendsigstop-into-ptrace_set_stopped.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ptrace_attach-shift-sendsigstop-into-ptrace_set_stopped.patch

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
Subject: ptrace_attach: shift send(SIGSTOP) into ptrace_set_stopped()
Date: Mon, 22 Jan 2024 18:16:31 +0100

Turn send_sig_info(SIGSTOP) into send_signal_locked(SIGSTOP) and move it
from ptrace_attach() to ptrace_set_stopped().

This looks more logical and avoids lock(siglock) right after unlock().

Link: https://lkml.kernel.org/r/20240122171631.GA29844@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/kernel/ptrace.c~ptrace_attach-shift-sendsigstop-into-ptrace_set_stopped
+++ a/kernel/ptrace.c
@@ -375,10 +375,13 @@ static int check_ptrace_options(unsigned
 	return 0;
 }
 
-static inline void ptrace_set_stopped(struct task_struct *task)
+static inline void ptrace_set_stopped(struct task_struct *task, bool seize)
 {
 	guard(spinlock)(&task->sighand->siglock);
 
+	/* SEIZE doesn't trap tracee on attach */
+	if (!seize)
+		send_signal_locked(SIGSTOP, SEND_SIG_PRIV, task, PIDTYPE_PID);
 	/*
 	 * If the task is already STOPPED, set JOBCTL_TRAP_STOP and
 	 * TRAPPING, and kick it so that it transits to TRACED.  TRAPPING
@@ -457,14 +460,8 @@ static int ptrace_attach(struct task_str
 				return -EPERM;
 
 			task->ptrace = flags;
-
 			ptrace_link(task, current);
-
-			/* SEIZE doesn't trap tracee on attach */
-			if (!seize)
-				send_sig_info(SIGSTOP, SEND_SIG_PRIV, task);
-
-			ptrace_set_stopped(task);
+			ptrace_set_stopped(task, seize);
 		}
 	}
 
_

Patches currently in -mm which might be from oleg@redhat.com are

getrusage-move-thread_group_cputime_adjusted-outside-of-lock_task_sighand.patch
getrusage-use-sig-stats_lock.patch
ptrace_attach-shift-sendsigstop-into-ptrace_set_stopped.patch

