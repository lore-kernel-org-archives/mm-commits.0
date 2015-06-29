From: akpm@linux-foundation.org
Subject: [merged]
 procfs-treat-parked-tasks-as-sleeping-for-task-state.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:37:07 -0700
Message-ID: <5591ac73.0yimRAsjgNEGuICt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbbF2UhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:37:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmetcalf@ezchip.com, dzickus@redhat.com, fweisbec@gmail.com, mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: treat parked tasks as sleeping for task state
has been removed from the -mm tree.  Its filename was
     procfs-treat-parked-tasks-as-sleeping-for-task-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: procfs: treat parked tasks as sleeping for task state

Allowing watchdog threads to be parked means that we now have the
opportunity of actually seeing persistent parked threads in the output of
/proc/<pid>/stat and /proc/<pid>/status.  The existing code reported such
threads as "Running", which is kind-of true if you think of the case where
we park them as part of taking cpus offline.  But if we allow parking them
indefinitely, "Running" is pretty misleading, so we report them as
"Sleeping" instead.

We could simply report them with a new string, "Parked", but it feels like
it's a bit risky for userspace to see unexpected new values; the output is
already documented in Documentation/filesystems/proc.txt, and it seems
like a mistake to change that lightly.

The scheduler does report parked tasks with a "P" in debugging output from
sched_show_task() or dump_cpu_task(), but that's a different API. 
Similarly, the trace_ctxwake_* routines report a "P" for parked tasks, but
again, different API.

This change seemed slightly cleaner than updating the task_state_array to
have additional rows.  TASK_DEAD should be subsumed by the exit_state
bits; TASK_WAKEKILL is just a modifier; and TASK_WAKING can very
reasonably be reported as "Running" (as it is now).  Only TASK_PARKED
shows up with unreasonable output here.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/proc/array.c~procfs-treat-parked-tasks-as-sleeping-for-task-state fs/proc/array.c
--- a/fs/proc/array.c~procfs-treat-parked-tasks-as-sleeping-for-task-state
+++ a/fs/proc/array.c
@@ -126,6 +126,14 @@ static inline const char *get_task_state
 {
 	unsigned int state = (tsk->state | tsk->exit_state) & TASK_REPORT;
 
+	/*
+	 * Parked tasks do not run; they sit in __kthread_parkme().
+	 * Without this check, we would report them as running, which is
+	 * clearly wrong, so we report them as sleeping instead.
+	 */
+	if (tsk->state == TASK_PARKED)
+		state = TASK_INTERRUPTIBLE;
+
 	BUILD_BUG_ON(1 + ilog2(TASK_REPORT) != ARRAY_SIZE(task_state_array)-1);
 
 	return task_state_array[fls(state)];
_

Patches currently in -mm which might be from cmetcalf@ezchip.com are

origin.patch
linux-next.patch

