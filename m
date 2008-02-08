From: akpm@linux-foundation.org
Subject: - dont-operate-with-pid_t-in-rtmutex-tester.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:20:27 -0800
Message-ID: <200802082020.m18KK8dK011140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53075 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892AbYBHUnC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:43:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Don't operate with pid_t in rtmutex tester
has been removed from the -mm tree.  Its filename was
     dont-operate-with-pid_t-in-rtmutex-tester.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Don't operate with pid_t in rtmutex tester
From: Pavel Emelyanov <xemul@openvz.org>

The proper behavior to store task's pid and get this task later is to get the
struct pid pointer and get the task with the pid_task() call.

Make it for rt_mutex_waiter->deadlock_task_pid field.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rtmutex-debug.c  |   12 +++++++++---
 kernel/rtmutex_common.h |    2 +-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff -puN kernel/rtmutex-debug.c~dont-operate-with-pid_t-in-rtmutex-tester kernel/rtmutex-debug.c
--- a/kernel/rtmutex-debug.c~dont-operate-with-pid_t-in-rtmutex-tester
+++ a/kernel/rtmutex-debug.c
@@ -130,7 +130,7 @@ void debug_rt_mutex_deadlock(int detect,
 
 	task = rt_mutex_owner(act_waiter->lock);
 	if (task && task != current) {
-		act_waiter->deadlock_task_pid = task->pid;
+		act_waiter->deadlock_task_pid = get_pid(task_pid(task));
 		act_waiter->deadlock_lock = lock;
 	}
 }
@@ -142,9 +142,12 @@ void debug_rt_mutex_print_deadlock(struc
 	if (!waiter->deadlock_lock || !rt_trace_on)
 		return;
 
-	task = find_task_by_pid(waiter->deadlock_task_pid);
-	if (!task)
+	rcu_read_lock();
+	task = pid_task(waiter->deadlock_task_pid, PIDTYPE_PID);
+	if (!task) {
+		rcu_read_unlock();
 		return;
+	}
 
 	TRACE_OFF_NOLOCK();
 
@@ -173,6 +176,7 @@ void debug_rt_mutex_print_deadlock(struc
 		current->comm, task_pid_nr(current));
 	dump_stack();
 	debug_show_all_locks();
+	rcu_read_unlock();
 
 	printk("[ turning off deadlock detection."
 	       "Please report this trace. ]\n\n");
@@ -203,10 +207,12 @@ void debug_rt_mutex_init_waiter(struct r
 	memset(waiter, 0x11, sizeof(*waiter));
 	plist_node_init(&waiter->list_entry, MAX_PRIO);
 	plist_node_init(&waiter->pi_list_entry, MAX_PRIO);
+	waiter->deadlock_task_pid = NULL;
 }
 
 void debug_rt_mutex_free_waiter(struct rt_mutex_waiter *waiter)
 {
+	put_pid(waiter->deadlock_task_pid);
 	TRACE_WARN_ON(!plist_node_empty(&waiter->list_entry));
 	TRACE_WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
 	TRACE_WARN_ON(waiter->task);
diff -puN kernel/rtmutex_common.h~dont-operate-with-pid_t-in-rtmutex-tester kernel/rtmutex_common.h
--- a/kernel/rtmutex_common.h~dont-operate-with-pid_t-in-rtmutex-tester
+++ a/kernel/rtmutex_common.h
@@ -51,7 +51,7 @@ struct rt_mutex_waiter {
 	struct rt_mutex		*lock;
 #ifdef CONFIG_DEBUG_RT_MUTEXES
 	unsigned long		ip;
-	pid_t			deadlock_task_pid;
+	struct pid		*deadlock_task_pid;
 	struct rt_mutex		*deadlock_lock;
 #endif
 };
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
deprecate-find_task_by_pid-kgdb.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
reiser4.patch
