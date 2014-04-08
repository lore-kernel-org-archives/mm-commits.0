From: akpm@linux-foundation.org
Subject: [merged]
 wait-use-exit_trace-only-if-thread_group_leaderzombie.patch removed from
 -mm tree
Date: Tue, 08 Apr 2014 14:20:37 -0700
Message-ID: <53446825.lhoXdzCaK9tJL3K/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739AbaDHVUi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:20:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, roland@hack.frob.com, mschmidt@redhat.com, lpoetter@redhat.com, jan.kratochvil@redhat.com, oleg@redhat.com

Subject: [merged] wait-use-exit_trace-only-if-thread_group_leaderzombie.patch removed from -mm tree
To: oleg@redhat.com,jan.kratochvil@redhat.com,lpoetter@redhat.com,mschmidt@redhat.com,roland@hack.frob.com,tj@kernel.org,viro@ZenIV.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:20:37 -0700


The patch titled
     Subject: wait: use EXIT_TRACE only if thread_group_leader(zombie)
has been removed from the -mm tree.  Its filename was
     wait-use-exit_trace-only-if-thread_group_leaderzombie.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1040,7 +1040,7 @@ static int wait_task_zombie(struct wait_
 	/*
 	 * Move the task's state to DEAD/TRACE, only one thread can do this.
 	 */
-	state = traced ? EXIT_TRACE : EXIT_DEAD;
+	state = traced && thread_group_leader(p) ? EXIT_TRACE : EXIT_DEAD;
 	if (cmpxchg(&p->exit_state, EXIT_ZOMBIE, state) != EXIT_ZOMBIE)
 		return 0;
 	/*
@@ -1140,18 +1140,15 @@ static int wait_task_zombie(struct wait_
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

origin.patch

