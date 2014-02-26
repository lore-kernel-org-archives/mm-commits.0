From: akpm@linux-foundation.org
Subject: +
 wait-wstoppedwcontinued-hangs-if-a-zombie-child-is-traced-by-real_parent.patch added to -mm tree
Date: Wed, 26 Feb 2014 15:45:05 -0800
Message-ID: <530e7c81.tv9CO5CW/QggI59N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbaBZXpG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 18:45:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, roland@hack.frob.com, mschmidt@redhat.com, lpoetter@redhat.com, jan.kratochvil@redhat.com, oleg@redhat.com

Subject: + wait-wstoppedwcontinued-hangs-if-a-zombie-child-is-traced-by-real_parent.patch added to -mm tree
To: oleg@redhat.com,jan.kratochvil@redhat.com,lpoetter@redhat.com,mschmidt@redhat.com,roland@hack.frob.com,tj@kernel.org,viro@ZenIV.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 15:45:05 -0800


The patch titled
     Subject: wait: WSTOPPED|WCONTINUED hangs if a zombie child is traced by real_parent
has been added to the -mm tree.  Its filename is
     wait-wstoppedwcontinued-hangs-if-a-zombie-child-is-traced-by-real_parent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/wait-wstoppedwcontinued-hangs-if-a-zombie-child-is-traced-by-real_parent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/wait-wstoppedwcontinued-hangs-if-a-zombie-child-is-traced-by-real_parent.patch

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
@@ -1364,6 +1364,22 @@ static int wait_consider_task(struct wai
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
@@ -1405,19 +1421,6 @@ static int wait_consider_task(struct wai
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
