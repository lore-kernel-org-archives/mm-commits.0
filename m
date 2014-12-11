From: akpm@linux-foundation.org
Subject: [merged]
 exit-wait-drop-tasklist_lock-before-psig-c-accounting.patch removed from
 -mm tree
Date: Thu, 11 Dec 2014 11:08:14 -0800
Message-ID: <5489eb9e.eZIsQhi+Z2KVQi8L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbaLKTIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:08:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, riel@redhat.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: wait: drop tasklist_lock before psig->c* accounting
has been removed from the -mm tree.  Its filename was
     exit-wait-drop-tasklist_lock-before-psig-c-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: wait: drop tasklist_lock before psig->c* accounting

wait_task_zombie() no longer needs tasklist_lock to accumulate the
psig->c* counters, we can drop it right after cmpxchg(exit_state).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN kernel/exit.c~exit-wait-drop-tasklist_lock-before-psig-c-accounting kernel/exit.c
--- a/kernel/exit.c~exit-wait-drop-tasklist_lock-before-psig-c-accounting
+++ a/kernel/exit.c
@@ -1005,6 +1005,11 @@ static int wait_task_zombie(struct wait_
 		EXIT_TRACE : EXIT_DEAD;
 	if (cmpxchg(&p->exit_state, EXIT_ZOMBIE, state) != EXIT_ZOMBIE)
 		return 0;
+	/*
+	 * We own this thread, nobody else can reap it.
+	 */
+	read_unlock(&tasklist_lock);
+	sched_annotate_sleep();
 
 	/*
 	 * Check thread_group_leader() to exclude the traced sub-threads.
@@ -1064,13 +1069,6 @@ static int wait_task_zombie(struct wait_
 		spin_unlock_irq(&current->sighand->siglock);
 	}
 
-	/*
-	 * Now we are sure this task is interesting, and no other
-	 * thread can reap it because we its state == DEAD/TRACE.
-	 */
-	read_unlock(&tasklist_lock);
-	sched_annotate_sleep();
-
 	retval = wo->wo_rusage
 		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
 	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
remove-unnecessary-is_valid_nodemask.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch
linux-next.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch

