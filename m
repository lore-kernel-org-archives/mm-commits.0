Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3AC221D86
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 20:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744057518; cv=none; b=JLSayjosRHxc7jng4Pk8A7JZvbc3WyWEXoo/cDU5qMlDO0NEmlSVxUSA+yiZJJwknFyzvGjsim8sEPiPFBVyZt4ZIMr10nUw+2Co6+/zDG4rLJyz+rbhMRITNa4SSty+75t1Drl7VcvgPP/7X8vXIV0GfqJb9wQFT74nNU5AIdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744057518; c=relaxed/simple;
	bh=r8MUnYr5FEzg1vJXJArRomlFe/utVgwDosFrZ6s+NgM=;
	h=Date:To:From:Subject:Message-Id; b=Q5G9InmMoB+keUywKPJA2ge5hY449S7eRS7a9bW3rpiXF4peZKRvYKc0f56Uhtk75l6EFDV9C/pEwkmmgA5/h6PHGYGexQxWTf902/XDiRj7djuBiWKKATvPjA0JVC1DBPnZo8R0f9BBtl5SQ+r8VpgEXAWcztM1ump6EWNXbG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sON+SFJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sON+SFJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34504C4CEEA;
	Mon,  7 Apr 2025 20:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744057518;
	bh=r8MUnYr5FEzg1vJXJArRomlFe/utVgwDosFrZ6s+NgM=;
	h=Date:To:From:Subject:From;
	b=sON+SFJLC8CCRUd4b98FHkE/c+KnmnkOoTKGnpFoWsTWNMqd0xvpIy37SKnZvxr6K
	 eE0tP7Psm98xFn8U0Ijr298Q+ijLTmnxRSxdw7BSgyPx1QGH4Fypv5ALOvmkqwoM2e
	 WtWhERsfmALW+R4sV6qmTI0da01QFeWp/OAi5Iuo=
Date: Mon, 07 Apr 2025 13:25:17 -0700
To: mm-commits@vger.kernel.org,oleg@redhat.com,mjguzik@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + exit-combine-work-under-lock-in-synchronize_group_exit-and-coredump_task_exit.patch added to mm-nonmm-unstable branch
Message-Id: <20250407202518.34504C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: exit: combine work under lock in synchronize_group_exit() and coredump_task_exit()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     exit-combine-work-under-lock-in-synchronize_group_exit-and-coredump_task_exit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/exit-combine-work-under-lock-in-synchronize_group_exit-and-coredump_task_exit.patch

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
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: exit: combine work under lock in synchronize_group_exit() and coredump_task_exit()
Date: Wed, 19 Mar 2025 20:54:36 +0100

This reduces single-threaded overhead as it avoids one lock+irq trip on
exit.

It also improves scalability of spawning and killing threads within one
process (just shy of 5% when doing it on 24 cores on my test jig).

Both routines are moved below kcov and kmsan exit, which should be
harmless.

Link: https://lkml.kernel.org/r/20250319195436.1864415-1-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   68 ++++++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 36 deletions(-)

--- a/kernel/exit.c~exit-combine-work-under-lock-in-synchronize_group_exit-and-coredump_task_exit
+++ a/kernel/exit.c
@@ -415,44 +415,30 @@ kill_orphaned_pgrp(struct task_struct *t
 	}
 }
 
-static void coredump_task_exit(struct task_struct *tsk)
+static void coredump_task_exit(struct task_struct *tsk,
+			       struct core_state *core_state)
 {
-	struct core_state *core_state;
+	struct core_thread self;
 
+	self.task = tsk;
+	if (self.task->flags & PF_SIGNALED)
+		self.next = xchg(&core_state->dumper.next, &self);
+	else
+		self.task = NULL;
 	/*
-	 * Serialize with any possible pending coredump.
-	 * We must hold siglock around checking core_state
-	 * and setting PF_POSTCOREDUMP.  The core-inducing thread
-	 * will increment ->nr_threads for each thread in the
-	 * group without PF_POSTCOREDUMP set.
+	 * Implies mb(), the result of xchg() must be visible
+	 * to core_state->dumper.
 	 */
-	spin_lock_irq(&tsk->sighand->siglock);
-	tsk->flags |= PF_POSTCOREDUMP;
-	core_state = tsk->signal->core_state;
-	spin_unlock_irq(&tsk->sighand->siglock);
-	if (core_state) {
-		struct core_thread self;
-
-		self.task = current;
-		if (self.task->flags & PF_SIGNALED)
-			self.next = xchg(&core_state->dumper.next, &self);
-		else
-			self.task = NULL;
-		/*
-		 * Implies mb(), the result of xchg() must be visible
-		 * to core_state->dumper.
-		 */
-		if (atomic_dec_and_test(&core_state->nr_threads))
-			complete(&core_state->startup);
+	if (atomic_dec_and_test(&core_state->nr_threads))
+		complete(&core_state->startup);
 
-		for (;;) {
-			set_current_state(TASK_IDLE|TASK_FREEZABLE);
-			if (!self.task) /* see coredump_finish() */
-				break;
-			schedule();
-		}
-		__set_current_state(TASK_RUNNING);
+	for (;;) {
+		set_current_state(TASK_IDLE|TASK_FREEZABLE);
+		if (!self.task) /* see coredump_finish() */
+			break;
+		schedule();
 	}
+	__set_current_state(TASK_RUNNING);
 }
 
 #ifdef CONFIG_MEMCG
@@ -876,6 +862,7 @@ static void synchronize_group_exit(struc
 {
 	struct sighand_struct *sighand = tsk->sighand;
 	struct signal_struct *signal = tsk->signal;
+	struct core_state *core_state;
 
 	spin_lock_irq(&sighand->siglock);
 	signal->quick_threads--;
@@ -885,7 +872,19 @@ static void synchronize_group_exit(struc
 		signal->group_exit_code = code;
 		signal->group_stop_count = 0;
 	}
+	/*
+	 * Serialize with any possible pending coredump.
+	 * We must hold siglock around checking core_state
+	 * and setting PF_POSTCOREDUMP.  The core-inducing thread
+	 * will increment ->nr_threads for each thread in the
+	 * group without PF_POSTCOREDUMP set.
+	 */
+	tsk->flags |= PF_POSTCOREDUMP;
+	core_state = signal->core_state;
 	spin_unlock_irq(&sighand->siglock);
+
+	if (unlikely(core_state))
+		coredump_task_exit(tsk, core_state);
 }
 
 void __noreturn do_exit(long code)
@@ -894,15 +893,12 @@ void __noreturn do_exit(long code)
 	int group_dead;
 
 	WARN_ON(irqs_disabled() && system_state != SYSTEM_POWER_OFF);
-
-	synchronize_group_exit(tsk, code);
-
 	WARN_ON(tsk->plug);
 
 	kcov_task_exit(tsk);
 	kmsan_task_exit(tsk);
 
-	coredump_task_exit(tsk);
+	synchronize_group_exit(tsk, code);
 	ptrace_event(PTRACE_EVENT_EXIT, code);
 	user_events_exit(tsk);
 
_

Patches currently in -mm which might be from mjguzik@gmail.com are

exit-combine-work-under-lock-in-synchronize_group_exit-and-coredump_task_exit.patch

