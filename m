From: akpm@linux-foundation.org
Subject: + lockdep-check-that-no-locks-held-at-freeze-time-v2.patch added to -mm tree
Date: Thu, 21 Feb 2013 13:40:55 -0800
Message-ID: <20130221214055.AD03C31C224@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:60372 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3BUVk7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 16:40:59 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so964601ves.3
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 13:40:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: msb@chromium.org, benchan@chromium.org, mingo@redhat.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org


The patch titled
     Subject: lockdep-check-that-no-locks-held-at-freeze-time-v6
has been added to the -mm tree.  Its filename is
     lockdep-check-that-no-locks-held-at-freeze-time-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
vfork-dont-freezer_count-for-in-kernel-users-of-clone_vfork.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
lockdep-check-that-no-locks-held-at-freeze-time-v2.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
coredump-cleanup-the-waiting-for-coredump_finish-code.patch
coredump-use-a-freezable_schedule-for-the-coredump_finish-wait.patch
coredump-abort-core-dump-piping-only-due-to-a-fatal-signal.patch

