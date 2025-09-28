Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140CB72608
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759084631; cv=none; b=mozfiQpfw11UbMSY01NT2dAMSSG7kdTB33EZPuWB4MiErrtSoal8wPMpcc3Esm5+5o4v19O7xk+HHLcNBeTTiaVko6X1MIpkXIr2VGwRqmn8Jr1OoXF/aLEbIe8DadVmR2CZEOPMmYa3JN0juDzUECnOM0ARP6FGFG+ESWblQ54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759084631; c=relaxed/simple;
	bh=1Mn5v6lOD6aKc88K8awu4MhZdSgCvI81Zud92dIhHEg=;
	h=Date:To:From:Subject:Message-Id; b=P+2EL1822AOJYhSzbLqW2tY40ZOfYTd6GYfGCgz9JKYVHo8sl9laUF8s3i52YUoDa4YlXmrrgOekt+zkeM/z818/fWQ0YtzobK+NH9e2AHdLKufsHUnCM6vCLZq/GjTx+P/exHpaxT8V45ikz+rumHrlGN8M0CvoNwqy3NuEAK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z46EIwgC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z46EIwgC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92AD1C4CEF7;
	Sun, 28 Sep 2025 18:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759084630;
	bh=1Mn5v6lOD6aKc88K8awu4MhZdSgCvI81Zud92dIhHEg=;
	h=Date:To:From:Subject:From;
	b=z46EIwgCFe1tByulQBHTt2hSxJ/00SsGtKLxmyCakwjrxvTxw5QObQ/5sERVkQAFX
	 8+ikpbYh+fqUpGSa//c7iBnf5cJD9hsCLXxo73QMNh/HREdsFH/bWJoYH8l3ALS2Dl
	 Yf2cK2QWEsWVH7UlOXtn4A4jPOuR+1kSQoLl0cOI=
Date: Sun, 28 Sep 2025 11:37:10 -0700
To: mm-commits@vger.kernel.org,oleg@redhat.com,mjguzik@gmail.com,demiobenour@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-prevent-prctlpr_set_pdeathsig-from-racing-with-parent-process-exit.patch removed from -mm tree
Message-Id: <20250928183710.92AD1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel: prevent prctl(PR_SET_PDEATHSIG) from racing with parent process exit
has been removed from the -mm tree.  Its filename was
     kernel-prevent-prctlpr_set_pdeathsig-from-racing-with-parent-process-exit.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/sys.c~kernel-prevent-prctlpr_set_pdeathsig-from-racing-with-parent-process-exit
+++ a/kernel/sys.c
@@ -2488,7 +2488,17 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
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


