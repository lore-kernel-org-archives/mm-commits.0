From: akpm@linux-foundation.org
Subject: [folded-dropped] lockdep-check-that-no-locks-held-at-freeze-time-v2.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:40:52 -0800
Message-ID: <20130228004053.4AF5E5A408F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:37203 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3B1Aky (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:40:54 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so139881yhz.3
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:40:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msb@chromium.org, benchan@chromium.org, mingo@redhat.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lockdep-check-that-no-locks-held-at-freeze-time-v6
has been removed from the -mm tree.  Its filename was
     lockdep-check-that-no-locks-held-at-freeze-time-v2.patch

This patch was dropped because it was folded into lockdep-check-that-no-locks-held-at-freeze-time.patch

------------------------------------------------------
From: Mandeep Singh Baines <msb@chromium.org>
Subject: lockdep-check-that-no-locks-held-at-freeze-time-v6

  * Updated changelog explaining why we can't freeze with locks held.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Ben Chan <benchan@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/debug_locks.h |    4 ++--
 include/linux/freezer.h     |    3 ++-
 kernel/exit.c               |    2 +-
 kernel/lockdep.c            |   20 +++++++++-----------
 4 files changed, 14 insertions(+), 15 deletions(-)

diff -puN include/linux/debug_locks.h~lockdep-check-that-no-locks-held-at-freeze-time-v2 include/linux/debug_locks.h
--- a/include/linux/debug_locks.h~lockdep-check-that-no-locks-held-at-freeze-time-v2
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
diff -puN include/linux/freezer.h~lockdep-check-that-no-locks-held-at-freeze-time-v2 include/linux/freezer.h
--- a/include/linux/freezer.h~lockdep-check-that-no-locks-held-at-freeze-time-v2
+++ a/include/linux/freezer.h
@@ -49,7 +49,8 @@ extern void thaw_kernel_threads(void);
 
 static inline bool try_to_freeze(void)
 {
-	debug_check_no_locks_held(current);
+	if (!(current->flags & PF_NOFREEZE))
+		debug_check_no_locks_held();
 	might_sleep();
 	if (likely(!freezing(current)))
 		return false;
diff -puN kernel/exit.c~lockdep-check-that-no-locks-held-at-freeze-time-v2 kernel/exit.c
--- a/kernel/exit.c~lockdep-check-that-no-locks-held-at-freeze-time-v2
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
diff -puN kernel/lockdep.c~lockdep-check-that-no-locks-held-at-freeze-time-v2 kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-check-that-no-locks-held-at-freeze-time-v2
+++ a/kernel/lockdep.c
@@ -4088,7 +4088,7 @@ void debug_check_no_locks_freed(const vo
 }
 EXPORT_SYMBOL_GPL(debug_check_no_locks_freed);
 
-static void print_held_locks_bug(struct task_struct *curr)
+static void print_held_locks_bug(void)
 {
 	if (!debug_locks_off())
 		return;
@@ -4096,22 +4096,20 @@ static void print_held_locks_bug(struct 
 		return;
 
 	printk("\n");
-	printk("=======================================\n");
-	printk("[ BUG: lock held at exit/freeze time! ]\n");
+	printk("=====================================\n");
+	printk("[ BUG: %s/%d still has locks held! ]\n",
+	       current->comm, task_pid_nr(current));
 	print_kernel_ident();
-	printk("---------------------------------------\n");
-	printk("%s/%d is exiting with locks still held!\n",
-		curr->comm, task_pid_nr(curr));
-	lockdep_print_held_locks(curr);
-
+	printk("-------------------------------------\n");
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
 
 void debug_show_all_locks(void)
_

Patches currently in -mm which might be from msb@chromium.org are

lockdep-check-that-no-locks-held-at-freeze-time.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
coredump-use-a-freezable_schedule-for-the-coredump_finish-wait.patch
coredump-use-a-freezable_schedule-for-the-coredump_finish-wait-fix.patch

