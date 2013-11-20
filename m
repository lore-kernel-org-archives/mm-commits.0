From: akpm@linux-foundation.org
Subject: + proc-cleanup-simplify-get_task_state-task_state_array.patch
 added to -mm tree
Date: Wed, 20 Nov 2013 14:03:53 -0800
Message-ID: <528d31c9.Ujf4aX2qwTv+fADZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab3KTWDy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Nov 2013 17:03:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, peterz@infradead.org, mingo@kernel.org, geert@linux-m68k.org, David.Laight@ACULAB.COM, oleg@redhat.com

Subject: + proc-cleanup-simplify-get_task_state-task_state_array.patch added to -mm tree
To: oleg@redhat.com,David.Laight@ACULAB.COM,geert@linux-m68k.org,mingo@kernel.org,peterz@infradead.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 20 Nov 2013 14:03:53 -0800


The patch titled
     Subject: proc: cleanup/simplify get_task_state/task_state_array
has been added to the -mm tree.  Its filename is
     proc-cleanup-simplify-get_task_state-task_state_array.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-cleanup-simplify-get_task_state-task_state_array.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-cleanup-simplify-get_task_state-task_state_array.patch

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
Subject: proc: cleanup/simplify get_task_state/task_state_array

get_task_state() and task_state_array[] look confusing and suboptimal, it
is not clear what it can actually report to user-space and
task_state_array[] blows .data for no reason.

1. state = (tsk->state & TASK_REPORT) | tsk->exit_state is not
   clear. TASK_REPORT is self-documenting but it is not clear
   what ->exit_state can add.

   Move the potential exit_state's (EXIT_ZOMBIE and EXIT_DEAD)
   into TASK_REPORT and use it to calculate the final result.

2. With the change above it is obvious that task_state_array[]
   has the unused entries just to make BUILD_BUG_ON() happy.

   Change this BUILD_BUG_ON() to use TASK_REPORT rather than
   TASK_STATE_MAX and shrink task_state_array[].

3. Turn the "while (state)" loop into fls(state).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c       |   15 +++------------
 include/linux/sched.h |    2 +-
 2 files changed, 4 insertions(+), 13 deletions(-)

diff -puN fs/proc/array.c~proc-cleanup-simplify-get_task_state-task_state_array fs/proc/array.c
--- a/fs/proc/array.c~proc-cleanup-simplify-get_task_state-task_state_array
+++ a/fs/proc/array.c
@@ -140,24 +140,15 @@ static const char * const task_state_arr
 	"t (tracing stop)",	/*   8 */
 	"Z (zombie)",		/*  16 */
 	"X (dead)",		/*  32 */
-	"x (dead)",		/*  64 */
-	"K (wakekill)",		/* 128 */
-	"W (waking)",		/* 256 */
-	"P (parked)",		/* 512 */
 };
 
 static inline const char *get_task_state(struct task_struct *tsk)
 {
-	unsigned int state = (tsk->state & TASK_REPORT) | tsk->exit_state;
-	const char * const *p = &task_state_array[0];
+	unsigned int state = (tsk->state | tsk->exit_state) & TASK_REPORT;
 
-	BUILD_BUG_ON(1 + ilog2(TASK_STATE_MAX) != ARRAY_SIZE(task_state_array));
+	BUILD_BUG_ON(1 + ilog2(TASK_REPORT) != ARRAY_SIZE(task_state_array)-1);
 
-	while (state) {
-		p++;
-		state >>= 1;
-	}
-	return *p;
+	return task_state_array[fls(state)];
 }
 
 static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
diff -puN include/linux/sched.h~proc-cleanup-simplify-get_task_state-task_state_array include/linux/sched.h
--- a/include/linux/sched.h~proc-cleanup-simplify-get_task_state-task_state_array
+++ a/include/linux/sched.h
@@ -164,7 +164,7 @@ extern char ___assert_task_state[1 - 2*!
 /* get_task_state() */
 #define TASK_REPORT		(TASK_RUNNING | TASK_INTERRUPTIBLE | \
 				 TASK_UNINTERRUPTIBLE | __TASK_STOPPED | \
-				 __TASK_TRACED)
+				 __TASK_TRACED | EXIT_ZOMBIE | EXIT_DEAD)
 
 #define task_is_traced(task)	((task->state & __TASK_TRACED) != 0)
 #define task_is_stopped(task)	((task->state & __TASK_STOPPED) != 0)
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
linux-next.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
fork-no-need-to-initialize-child-exit_state.patch
exit_state-kill-task_is_dead.patch

