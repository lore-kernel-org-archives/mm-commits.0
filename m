From: akpm@linux-foundation.org
Subject: [merged]
 wait-wstoppedwcontinued-hangs-if-a-zombie-child-is-traced-by-real_parent.patch removed from -mm tree
Date: Tue, 08 Apr 2014 14:22:13 -0700
Message-ID: <53446885.IOH57lbG15Lkulfi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753AbaDHVWO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:22:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, roland@hack.frob.com, mschmidt@redhat.com, lpoetter@redhat.com, jan.kratochvil@redhat.com, oleg@redhat.com

Subject: [merged] wait-wstoppedwcontinued-hangs-if-a-zombie-child-is-traced-by-real_parent.patch removed from -mm tree
To: oleg@redhat.com,jan.kratochvil@redhat.com,lpoetter@redhat.com,mschmidt@redhat.com,roland@hack.frob.com,tj@kernel.org,viro@ZenIV.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:22:13 -0700


The patch titled
     Subject: wait: WSTOPPED|WCONTINUED hangs if a zombie child is traced by real_parent
has been removed from the -mm tree.  Its filename was
     wait-wstoppedwcontinued-hangs-if-a-zombie-child-is-traced-by-real_parent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: wait: WSTOPPED|WCONTINUED hangs if a zombie child is traced by real_parent

"A zombie is only visible to its ptracer" logic in wait_consider_task()
is very wrong. Trivial test-case:

	#include <unistd.h>
	#include <sys/ptrace.h>
	#include <sys/wait.h>
	#include <assert.h>

	int main(void)
	{
		int child = fork();

		if (!child) {
			assert(ptrace(PTRACE_TRACEME, 0,0,0) == 0);
			return 0x23;
		}

		assert(waitid(P_ALL, child, NULL, WEXITED | WNOWAIT) == 0);
		assert(waitid(P_ALL, 0, NULL, WSTOPPED) == -1);
		return 0;
	}

it hangs in waitpid(WSTOPPED) despite the fact it has a single zombie
child.  This is because wait_consider_task(ptrace => 0) sees p->ptrace and
cleares ->notask_error assuming that the debugger should detach and notify
us.

Change wait_consider_task(ptrace => 0) to pretend that ptrace == T if the
child is traced by us.  This really simplifies the logic and allows us to
do more fixes, see the next changes.  This also hides the unwanted group
stop state automatically, we can remove another ptrace_reparented() check.

Unfortunately, this adds the following behavioural changes:

	1. Before this patch wait(WEXITED | __WNOTHREAD) does not reap
	   a natural child if it is traced by the caller's sub-thread.

	   Hopefully nobody will ever notice this change, and I think
	   that nobody should rely on this behaviour anyway.

	2. SIGNAL_STOP_CONTINUED is no longer hidden from debugger if
	   it is real parent.

	   While this change comes as a side effect, I think it is good
	   by itself. The group continued state can not be consumed by
	   another process in this case, it doesn't depend on ptrace,
	   it doesn't make sense to hide it from real parent.

	   Perhaps we should add the thread_group_leader() check before
	   wait_task_continued()? May be, but this shouldn't depend on
	   ptrace_reparented().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Lennart Poettering <lpoetter@redhat.com>
Cc: Michal Schmidt <mschmidt@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff -puN kernel/exit.c~wait-wstoppedwcontinued-hangs-if-a-zombie-child-is-traced-by-real_parent kernel/exit.c
--- a/kernel/exit.c~wait-wstoppedwcontinued-hangs-if-a-zombie-child-is-traced-by-real_parent
+++ a/kernel/exit.c
@@ -1362,6 +1362,22 @@ static int wait_consider_task(struct wai
 		return 0;
 	}
 
+	if (likely(!ptrace) && unlikely(p->ptrace)) {
+		/*
+		 * If it is traced by its real parent's group, just pretend
+		 * the caller is ptrace_do_wait() and reap this child if it
+		 * is zombie.
+		 *
+		 * This also hides group stop state from real parent; otherwise
+		 * a single stop can be reported twice as group and ptrace stop.
+		 * If a ptracer wants to distinguish these two events for its
+		 * own children it should create a separate process which takes
+		 * the role of real parent.
+		 */
+		if (!ptrace_reparented(p))
+			ptrace = 1;
+	}
+
 	/* slay zombie? */
 	if (p->exit_state == EXIT_ZOMBIE) {
 		/*
@@ -1403,19 +1419,6 @@ static int wait_consider_task(struct wai
 			wo->notask_error = 0;
 	} else {
 		/*
-		 * If @p is ptraced by a task in its real parent's group,
-		 * hide group stop/continued state when looking at @p as
-		 * the real parent; otherwise, a single stop can be
-		 * reported twice as group and ptrace stops.
-		 *
-		 * If a ptracer wants to distinguish the two events for its
-		 * own children, it should create a separate process which
-		 * takes the role of real parent.
-		 */
-		if (likely(!ptrace) && p->ptrace && !ptrace_reparented(p))
-			return 0;
