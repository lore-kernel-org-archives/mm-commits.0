From: akpm@linux-foundation.org
Subject: [merged] lockdep-check-that-no-locks-held-at-freeze-time.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:11:49 -0800
Message-ID: <20130228201149.C75995A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:45922 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1ULv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:11:51 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so244850yen.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:11:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msb@chromium.org, benchan@chromium.org, mingo@redhat.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lockdep: check that no locks held at freeze time
has been removed from the -mm tree.  Its filename was
     lockdep-check-that-no-locks-held-at-freeze-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mandeep Singh Baines <msb@chromium.org>
Subject: lockdep: check that no locks held at freeze time

We shouldn't try_to_freeze if locks are held.  Holding a lock can cause a
deadlock if the lock is later acquired in the suspend or hibernate path
(e.g.  by dpm).  Holding a lock can also cause a deadlock in the case of
cgroup_freezer if a lock is held inside a frozen cgroup that is later
acquired by a process outside that group.

[akpm@linux-foundation.org: export debug_check_no_locks_held]
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Ben Chan <benchan@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/debug_locks.h |    4 ++--
 include/linux/freezer.h     |    3 +++
 kernel/exit.c               |    2 +-
 kernel/lockdep.c            |   17 ++++++++---------
 4 files changed, 14 insertions(+), 12 deletions(-)

diff -puN include/linux/debug_locks.h~lockdep-check-that-no-locks-held-at-freeze-time include/linux/debug_locks.h
--- a/include/linux/debug_locks.h~lockdep-check-that-no-locks-held-at-freeze-time
+++ a/include/linux/debug_locks.h
@@ -51,7 +51,7 @@ struct task_struct;
 extern void debug_show_all_locks(void);
 extern void debug_show_held_locks(struct task_struct *task);
 extern void debug_check_no_locks_freed(const void *from, unsigned long len);
-extern void debug_check_no_locks_held(struct task_struct *task);
+extern void debug_check_no_locks_held(void);
 #else
 static inline void debug_show_all_locks(void)
 {
@@ -67,7 +67,7 @@ debug_check_no_locks_freed(const void *f
 }
 
 static inline void
-debug_check_no_locks_held(struct task_struct *task)
+debug_check_no_locks_held(void)
 {
 }
 #endif
diff -puN include/linux/freezer.h~lockdep-check-that-no-locks-held-at-freeze-time include/linux/freezer.h
--- a/include/linux/freezer.h~lockdep-check-that-no-locks-held-at-freeze-time
+++ a/include/linux/freezer.h
@@ -3,6 +3,7 @@
 #ifndef FREEZER_H_INCLUDED
 #define FREEZER_H_INCLUDED
 
+#include <linux/debug_locks.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/atomic.h>
@@ -48,6 +49,8 @@ extern void thaw_kernel_threads(void);
 
 static inline bool try_to_freeze(void)
 {
+	if (!(current->flags & PF_NOFREEZE))
+		debug_check_no_locks_held();
 	might_sleep();
 	if (likely(!freezing(current)))
 		return false;
diff -puN kernel/exit.c~lockdep-check-that-no-locks-held-at-freeze-time kernel/exit.c
--- a/kernel/exit.c~lockdep-check-that-no-locks-held-at-freeze-time
+++ a/kernel/exit.c
@@ -835,7 +835,7 @@ void do_exit(long code)
 	/*
 	 * Make sure we are holding no locks:
 	 */
-	debug_check_no_locks_held(tsk);
+	debug_check_no_locks_held();
 	/*
 	 * We can do this unlocked here. The futex code uses this flag
 	 * just to verify whether the pi state cleanup has been done
diff -puN kernel/lockdep.c~lockdep-check-that-no-locks-held-at-freeze-time kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-check-that-no-locks-held-at-freeze-time
+++ a/kernel/lockdep.c
@@ -4088,7 +4088,7 @@ void debug_check_no_locks_freed(const vo
 }
 EXPORT_SYMBOL_GPL(debug_check_no_locks_freed);
 
-static void print_held_locks_bug(struct task_struct *curr)
+static void print_held_locks_bug(void)
 {
 	if (!debug_locks_off())
 		return;
@@ -4097,22 +4097,21 @@ static void print_held_locks_bug(struct 
 
 	printk("\n");
 	printk("=====================================\n");
-	printk("[ BUG: lock held at task exit time! ]\n");
+	printk("[ BUG: %s/%d still has locks held! ]\n",
+	       current->comm, task_pid_nr(current));
 	print_kernel_ident();
 	printk("-------------------------------------\n");
-	printk("%s/%d is exiting with locks still held!\n",
-		curr->comm, task_pid_nr(curr));
-	lockdep_print_held_locks(curr);
-
+	lockdep_print_held_locks(current);
 	printk("\nstack backtrace:\n");
 	dump_stack();
 }
 
-void debug_check_no_locks_held(struct task_struct *task)
+void debug_check_no_locks_held(void)
 {
-	if (unlikely(task->lockdep_depth > 0))
-		print_held_locks_bug(task);
+	if (unlikely(current->lockdep_depth > 0))
+		print_held_locks_bug();
 }
+EXPORT_SYMBOL_GPL(debug_check_no_locks_held);
 
 void debug_show_all_locks(void)
 {
_

Patches currently in -mm which might be from msb@chromium.org are

origin.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch

