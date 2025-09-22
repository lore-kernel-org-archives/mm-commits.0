Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E8230DED7
	for <mm-commits@vger.kernel.org>; Mon, 22 Sep 2025 22:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758581319; cv=none; b=It7jUihiCZdAvapAvuEs1C23rUZcMJ0Jh6RY7RIFwZoKs2hRQeJJzfm25KboxiaBXN1KTDniIawDuKiNRFi+uO0W/KstHa3qh9rafh3AKSbeVE/X0rtEOOxkxI1oWlLp+LO1Z6tpe+TLhVY1XOAlUQkxrU2MpxPbt3y/gNHjK+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758581319; c=relaxed/simple;
	bh=9NaxDpyPLqL7CuWSTNJFUc3KmPC3fayb32l4Ztd4C80=;
	h=Date:To:From:Subject:Message-Id; b=fzheDGL8d9K+4FJYJAvQeCwrKWPN+RHYaLJzw0Y3n1sUpeR4qeXnWD0G/uqNJPx5oY4tR/NuJAQhgR/4CqNZDz3A18Uo/cHEL3qWjf8CMPsc6qvxVz/EyAWubHr0IvNgqR+UxZH817DgWWV/QFlb/ynV3qL3Xu8UtR0KE6BAKks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qc8brXFm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qc8brXFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310E3C4CEF0;
	Mon, 22 Sep 2025 22:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758581317;
	bh=9NaxDpyPLqL7CuWSTNJFUc3KmPC3fayb32l4Ztd4C80=;
	h=Date:To:From:Subject:From;
	b=qc8brXFmELappKWjLwErgOpd+33GdjBHYy/1rU1cp2yv26x89GQujE+QFBrWHUmyB
	 tJxisA/KYIcqlZFZLf8/+rTb92ayeVMAMjL72c1rAFa2cJtRSaDtPLKyw6mNq119Jw
	 iSXMpBNBh+hzqT0wEPrB+l6Csmmv5bH/S+x2XXsU=
Date: Mon, 22 Sep 2025 15:48:36 -0700
To: mm-commits@vger.kernel.org,oleg@redhat.com,demiobenour@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-prevent-prctlpr_set_pdeathsig-from-racing-with-parent-process-exit.patch added to mm-nonmm-unstable branch
Message-Id: <20250922224837.310E3C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel: prevent prctl(PR_SET_PDEATHSIG) from racing with parent process exit
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-prevent-prctlpr_set_pdeathsig-from-racing-with-parent-process-exit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-prevent-prctlpr_set_pdeathsig-from-racing-with-parent-process-exit.patch

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
From: Demi Marie Obenour <demiobenour@gmail.com>
Subject: kernel: prevent prctl(PR_SET_PDEATHSIG) from racing with parent process exit
Date: Sat, 13 Sep 2025 18:28:49 -0400

If a process calls prctl(PR_SET_PDEATHSIG) at the same time that the
parent process exits, the child will write to me->pdeath_sig at the same
time the parent is reading it.  Since there is no synchronization, this is
a data race.

Worse, it is possible that a subsequent call to getppid() can continue to
return the previous parent process ID without the parent death signal
being delivered.  This happens in the following scenario:

parent                                                 child

forget_original_parent()                               prctl(PR_SET_PDEATHSIG, SIGKILL)
                                                         sys_prctl()
                                                           me->pdeath_sig = SIGKILL;
                                                       getppid();
  RCU_INIT_POINTER(t->real_parent, reaper);
  if (t->pdeath_signal) /* reads stale me->pdeath_sig */
           group_send_sig_info(t->pdeath_signal, ...);

And in the following:

parent                                                 child

forget_original_parent()
    RCU_INIT_POINTER(t->real_parent, reaper);
    /* also no barrier */
     if (t->pdeath_signal) /* reads stale me->pdeath_sig */
             group_send_sig_info(t->pdeath_signal, ...);

                                                       prctl(PR_SET_PDEATHSIG, SIGKILL)
                                                         sys_prctl()
                                                           me->pdeath_sig = SIGKILL;
                                                       getppid(); /* reads old ppid() */

As a result, the following pattern is racy:

	pid_t parent_pid = getpid();
	pid_t child_pid = fork();
	if (child_pid == -1) {
		/* handle error... */
		return;
	}
	if (child_pid == 0) {
		if (prctl(PR_SET_PDEATHSIG, SIGKILL) != 0) {
			/* handle error */
			_exit(126);
		}
		if (getppid() != parent_pid) {
			/* parent died already */
			raise(SIGKILL);
		}
		/* keep going in child */
	}
	/* keep going in parent */

If the parent is killed at exactly the wrong time, the child process can
(wrongly) stay running.

I didn't manage to reproduce this in my testing, but I'm pretty sure the
race is real.  KCSAN is probably the best way to spot the race.

Fix the bug by holding tasklist_lock for reading whenever pdeath_signal is
being written to.  This prevents races on me->pdeath_sig, and the locking
and unlocking of the rwlock provide the needed memory barriers.  If
prctl(PR_SET_PDEATHSIG) happens before the parent exits, the signal will
be sent.  If it happens afterwards, a subsequent getppid() will return the
new value.

Link: https://lkml.kernel.org/r/20250913-fix-prctl-pdeathsig-race-v1-1-44e2eb426fe9@gmail.com
Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/sys.c~kernel-prevent-prctlpr_set_pdeathsig-from-racing-with-parent-process-exit
+++ a/kernel/sys.c
@@ -2533,7 +2533,17 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 			error = -EINVAL;
 			break;
 		}
+		/*
+		 * Ensure that either:
+		 *
+		 * 1. Subsequent getppid() calls reflect the parent process having died.
+		 * 2. forget_original_parent() will send the new me->pdeath_signal.
+		 *
+		 * Also prevent the read of me->pdeath_signal from being a data race.
+		 */
+		read_lock(&tasklist_lock);
 		me->pdeath_signal = arg2;
+		read_unlock(&tasklist_lock);
 		break;
 	case PR_GET_PDEATHSIG:
 		error = put_user(me->pdeath_signal, (int __user *)arg2);
_

Patches currently in -mm which might be from demiobenour@gmail.com are

kernel-prevent-prctlpr_set_pdeathsig-from-racing-with-parent-process-exit.patch

