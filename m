From: akpm@linux-foundation.org
Subject: + wait-use-exit_trace-only-if-thread_group_leaderzombie.patch
 added to -mm tree
Date: Fri, 21 Feb 2014 13:39:19 -0800
Message-ID: <5307c787.6iEVkZTBymjPUhQ9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912AbaBUVjU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 16:39:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, roland@hack.frob.com, mschmidt@redhat.com, lpoetter@redhat.com, jan.kratochvil@redhat.com, oleg@redhat.com

Subject: + wait-use-exit_trace-only-if-thread_group_leaderzombie.patch added to -mm tree
To: oleg@redhat.com,jan.kratochvil@redhat.com,lpoetter@redhat.com,mschmidt@redhat.com,roland@hack.frob.com,tj@kernel.org,viro@ZenIV.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 13:39:19 -0800


The patch titled
     Subject: wait: use EXIT_TRACE only if thread_group_leader(zombie)
has been added to the -mm tree.  Its filename is
     wait-use-exit_trace-only-if-thread_group_leaderzombie.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/wait-use-exit_trace-only-if-thread_group_leaderzombie.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/wait-use-exit_trace-only-if-thread_group_leaderzombie.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: wait: use EXIT_TRACE only if thread_group_leader(zombie)

wait_task_zombie() always uses EXIT_TRACE/ptrace_unlink() if
ptrace_reparented().  This is suboptimal and a bit confusing: we do not
need do_notify_parent(p) if !thread_group_leader(p) and in this case we
also do not need ptrace_unlink(), we can rely on ptrace_release_task().

Change wait_task_zombie() to check thread_group_leader() along with
ptrace_reparented() and simplify the final p->exit_state transition.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Tested-by: Michal Schmidt <mschmidt@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Lennart Poettering <lpoetter@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN kernel/exit.c~wait-use-exit_trace-only-if-thread_group_leaderzombie kernel/exit.c
--- a/kernel/exit.c~wait-use-exit_trace-only-if-thread_group_leaderzombie
+++ a/kernel/exit.c
@@ -1042,7 +1042,7 @@ static int wait_task_zombie(struct wait_
 	/*
 	 * Move the task's state to DEAD/TRACE, only one thread can do this.
 	 */
-	state = traced ? EXIT_TRACE : EXIT_DEAD;
+	state = traced && thread_group_leader(p) ? EXIT_TRACE : EXIT_DEAD;
 	if (cmpxchg(&p->exit_state, EXIT_ZOMBIE, state) != EXIT_ZOMBIE)
 		return 0;
 	/*
@@ -1142,18 +1142,15 @@ static int wait_task_zombie(struct wait_
 	if (!retval)
 		retval = pid;
 
-	if (traced) {
+	if (state == EXIT_TRACE) {
 		write_lock_irq(&tasklist_lock);
 		/* We dropped tasklist, ptracer could die and untrace */
 		ptrace_unlink(p);
-		/*
-		 * If this is not a sub-thread, notify the parent.
-		 * If parent wants a zombie, don't release it now.
-		 */
-		state = EXIT_DEAD;
-		if (thread_group_leader(p) &&
-		    !do_notify_parent(p, p->exit_signal))
-			state = EXIT_ZOMBIE;
+
+		/* If parent wants a zombie, don't release it now */
+		state = EXIT_ZOMBIE;
+		if (do_notify_parent(p, p->exit_signal))
+			state = EXIT_DEAD;
 		p->exit_state = state;
 		write_unlock_irq(&tasklist_lock);
 	}
_

Patches currently in -mm which might be from oleg@redhat.com are

kthread-ensure-locality-of-task_struct-allocations.patch
wait-fix-reparent_leader-vs-exit_dead-exit_zombie-race.patch
wait-introduce-exit_trace-to-avoid-the-racy-exit_dead-exit_zombie-transition.patch
wait-use-exit_trace-only-if-thread_group_leaderzombie.patch
wait-completely-ignore-the-exit_dead-tasks.patch
wait-swap-exit_zombie-and-exit_dead-to-hide-exit_trace-from-user-space.patch
linux-next.patch

