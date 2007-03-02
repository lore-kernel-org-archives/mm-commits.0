From: akpm@linux-foundation.org
Subject: + freezer-fix-vfork-problem.patch added to -mm tree
Date: Thu, 01 Mar 2007 16:55:36 -0800
Message-ID: <200703020055.l220taOA028053@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60845 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422668AbXCBA4H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 19:56:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, aneesh.kumar@gmail.com, ego@in.ibm.com, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, pavel@ucw.cz, vatsa@in.ibm.com


The patch titled
     freezer: fix vfork problem
has been added to the -mm tree.  Its filename is
     freezer-fix-vfork-problem.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: freezer: fix vfork problem
From: Rafael J. Wysocki <rjw@sisk.pl>

Currently try_to_freeze_tasks() has to wait until all of the vforked processes
exit and for this reason every user can make it fail.  To fix this problem we
can introduce the additional process flag PF_FREEZER_SKIP to be used by tasks
that do not want to be counted as freezable by the freezer and want to have
TIF_FREEZE set nevertheless.  Then, this flag can be set by tasks using
sys_vfork() before they call wait_for_completion(&vfork) and cleared after
they have woken up.  After clearing it, the tasks should call try_to_freeze()
as soon as possible.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Aneesh Kumar <aneesh.kumar@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/freezer.h |   48 ++++++++++++++++++++++++++++++++++++--
 include/linux/sched.h   |    1 
 kernel/fork.c           |    3 ++
 kernel/power/process.c  |   27 ++++++---------------
 4 files changed, 58 insertions(+), 21 deletions(-)

diff -puN include/linux/freezer.h~freezer-fix-vfork-problem include/linux/freezer.h
--- a/include/linux/freezer.h~freezer-fix-vfork-problem
+++ a/include/linux/freezer.h
@@ -75,7 +75,49 @@ static inline int try_to_freeze(void)
 		return 0;
 }
 
-extern void thaw_some_processes(int all);
+/*
+ * The PF_FREEZER_SKIP flag should be set by a vfork parent right before it
+ * calls wait_for_completion(&vfork) and reset right after it returns from this
+ * function.  Next, the parent should call try_to_freeze() to freeze itself
+ * appropriately in case the child has exited before the freezing of tasks is
+ * complete.  However, we don't want kernel threads to be frozen in unexpected
+ * places, so we allow them to block freeze_processes() instead or to set
+ * PF_NOFREEZE if needed and PF_FREEZER_SKIP is only set for userland vfork
+ * parents.  Fortunately, in the ____call_usermodehelper() case the parent won't
+ * really block freeze_processes(), since ____call_usermodehelper() (the child)
+ * does a little before exec/exit and it can't be frozen before waking up the
+ * parent.
+ */
+
+/*
+ * If the current task is a user space one, tell the freezer not to count it as
+ * freezable.
+ */
+static inline void freezer_do_not_count(void)
+{
+	if (current->mm)
+		current->flags |= PF_FREEZER_SKIP;
+}
+
+/*
+ * If the current task is a user space one, tell the freezer to count it as
+ * freezable again and try to freeze it.
+ */
+static inline void freezer_count(void)
+{
+	if (current->mm) {
+		current->flags &= ~PF_FREEZER_SKIP;
+		try_to_freeze();
+	}
+}
+
+/*
+ * Check if the task should be counted as freezeable by the freezer
+ */
+static inline int freezer_should_skip(struct task_struct *p)
+{
+	return !!(p->flags & PF_FREEZER_SKIP);
+}
 
 #else
 static inline int frozen(struct task_struct *p) { return 0; }
@@ -90,5 +132,7 @@ static inline void thaw_processes(void) 
 
 static inline int try_to_freeze(void) { return 0; }
 
-
+static inline void freezer_do_not_count(void) {}
+static inline void freezer_count(void) {}
+static inline int freezer_should_skip(struct task_struct *p) { return 0; }
 #endif
diff -puN include/linux/sched.h~freezer-fix-vfork-problem include/linux/sched.h
--- a/include/linux/sched.h~freezer-fix-vfork-problem
+++ a/include/linux/sched.h
@@ -1157,6 +1157,7 @@ static inline void put_task_struct(struc
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
+#define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
 
 /*
  * Only the _current_ task can read/write to tsk->flags, but other
diff -puN kernel/fork.c~freezer-fix-vfork-problem kernel/fork.c
--- a/kernel/fork.c~freezer-fix-vfork-problem
+++ a/kernel/fork.c
@@ -39,6 +39,7 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/rcupdate.h>
 #include <linux/ptrace.h>
+#include <linux/freezer.h>
 #include <linux/mount.h>
 #include <linux/audit.h>
 #include <linux/profile.h>
@@ -1406,7 +1407,9 @@ long do_fork(unsigned long clone_flags,
 		}
 
 		if (clone_flags & CLONE_VFORK) {
+			freezer_do_not_count();
 			wait_for_completion(&vfork);
+			freezer_count();
 			if (unlikely (current->ptrace & PT_TRACE_VFORK_DONE)) {
 				current->ptrace_message = nr;
 				ptrace_notify ((PTRACE_EVENT_VFORK_DONE << 8) | SIGTRAP);
diff -puN kernel/power/process.c~freezer-fix-vfork-problem kernel/power/process.c
--- a/kernel/power/process.c~freezer-fix-vfork-problem
+++ a/kernel/power/process.c
@@ -127,22 +127,12 @@ static unsigned int try_to_freeze_tasks(
 				cancel_freezing(p);
 				continue;
 			}
-			if (is_user_space(p)) {
-				if (!freeze_user_space)
-					continue;
-
-				/* Freeze the task unless there is a vfork
-				 * completion pending
-				 */
-				if (!p->vfork_done)
-					freeze_process(p);
-			} else {
-				if (freeze_user_space)
-					continue;
+			if (is_user_space(p) == !freeze_user_space)
+				continue;
 
-				freeze_process(p);
-			}
-			todo++;
+			freeze_process(p);
+			if (!freezer_should_skip(p))
+				todo++;
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
 		yield();			/* Yield is okay here */
@@ -168,7 +158,8 @@ static unsigned int try_to_freeze_tasks(
 				continue;
 
 			task_lock(p);
-			if (freezeable(p) && !frozen(p))
+			if (freezeable(p) && !frozen(p) &&
+			    !freezer_should_skip(p))
 				printk(KERN_ERR " %s\n", p->comm);
 
 			cancel_freezing(p);
@@ -217,9 +208,7 @@ static void thaw_tasks(int thaw_user_spa
 		if (is_user_space(p) == !thaw_user_space)
 			continue;
 
-		if (!thaw_process(p))
-			printk(KERN_WARNING " Strange, %s not stopped\n",
-				p->comm );
+		thaw_process(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
 }
_

Patches currently in -mm which might be from rjw@sisk.pl are

make-xfs-workqueues-nonfreezable.patch
fix-refrigerator-vs-thaw_process-race.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
shrink_slab-handle-bad-shrinkers.patch
