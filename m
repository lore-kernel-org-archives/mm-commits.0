From: akpm@osdl.org
Subject: - debug-workqueue-locking-sanity.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:04:32 -0800
Message-ID: <200612072304.kB7N4WVv030062@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52102 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163855AbWLGXEi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:04:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     debug: workqueue locking sanity
has been removed from the -mm tree.  Its filename was
     debug-workqueue-locking-sanity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: debug: workqueue locking sanity
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Workqueue functions should not leak locks, assert so, printing the
last function ran.

Use macros in lockdep.h to avoid include dependency pains.

[akpm@osdl.org: build fix]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/lockdep.h |    5 +++++
 kernel/workqueue.c      |   13 +++++++++++++
 2 files changed, 18 insertions(+)

diff -puN include/linux/lockdep.h~debug-workqueue-locking-sanity include/linux/lockdep.h
--- a/include/linux/lockdep.h~debug-workqueue-locking-sanity
+++ a/include/linux/lockdep.h
@@ -243,6 +243,8 @@ extern void lock_release(struct lockdep_
 
 # define INIT_LOCKDEP				.lockdep_recursion = 0,
 
+#define lockdep_depth(tsk)	((tsk)->lockdep_depth)
+
 #else /* !LOCKDEP */
 
 static inline void lockdep_off(void)
@@ -277,6 +279,9 @@ static inline int lockdep_internal(void)
  * The class key takes no space if lockdep is disabled:
  */
 struct lock_class_key { };
+
+#define lockdep_depth(tsk)	(0)
+
 #endif /* !LOCKDEP */
 
 #if defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_GENERIC_HARDIRQS)
diff -puN kernel/workqueue.c~debug-workqueue-locking-sanity kernel/workqueue.c
--- a/kernel/workqueue.c~debug-workqueue-locking-sanity
+++ a/kernel/workqueue.c
@@ -30,6 +30,8 @@
 #include <linux/hardirq.h>
 #include <linux/mempolicy.h>
 #include <linux/freezer.h>
+#include <linux/kallsyms.h>
+#include <linux/debug_locks.h>
 
 /*
  * The per-CPU workqueue (if single thread, we always use the first
@@ -253,6 +255,17 @@ static void run_workqueue(struct cpu_wor
 			work_release(work);
 		f(work);
 
+		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
+			printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
+					"%s/0x%08x/%d\n",
+					current->comm, preempt_count(),
+				       	current->pid);
+			printk(KERN_ERR "    last function: ");
+			print_symbol("%s\n", (unsigned long)f);
+			debug_show_held_locks(current);
+			dump_stack();
+		}
+
 		spin_lock_irqsave(&cwq->lock, flags);
 		cwq->remove_sequence++;
 		wake_up(&cwq->work_done);
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
tty-signal-tty-locking.patch
tty-signal-tty-locking-post-viro-trainwreck.patch
tty-signal-tty-locking-post-viro-trainwreck-fix.patch
tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch
tty-signal-tty-locking-3270-fix.patch
do_task_stat-dont-take-tty_mutex.patch
do_acct_process-dont-take-tty_mutex.patch
sys_unshare-remove-a-broken-clone_sighand-code.patch
remove-the-old-bd_mutex-lockdep-annotation.patch
new-bd_mutex-lockdep-annotation.patch
remove-lock_key-approach-to-managing-nested-bd_mutex-locks.patch
simplify-some-aspects-of-bd_mutex-nesting.patch
use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning.patch
avoid-lockdep-warning-in-md.patch
bdev-fix-bd_part_count-leak.patch
lockdep-annotate-nfsd4-recover-code.patch

