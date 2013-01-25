From: akpm@linux-foundation.org
Subject: [merged] profiling-remove-unused-timer-hook.patch removed from -mm tree
Date: Fri, 25 Jan 2013 13:38:07 -0800
Message-ID: <20130125213807.E0C3731C107@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:34879 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab3AYViK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 16:38:10 -0500
Received: by mail-qc0-f201.google.com with SMTP id a22so80991qcs.0
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 13:38:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, abogani@kernel.org, avi@redhat.com, cl@linux.com, cmetcalf@tilera.com, geoff@infradead.org, gilad@benyossef.com, hakanakkan@gmail.com, mingo@kernel.org, paul.gortmaker@windriver.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: profiling: Remove unused timer hook
has been removed from the -mm tree.  Its filename was
     profiling-remove-unused-timer-hook.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: profiling: Remove unused timer hook

The last remaining user was oprofile and its use has been removed a while
ago by bc078e4eab65f ("oprofile: convert oprofile from timer_hook to
hrtimer").

There doesn't seem to be any upstream user of this hook for about two
years now.  And I'm not even aware of any out of tree user.

Let's remove it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/profile.h |   13 -------------
 kernel/profile.c        |   24 ------------------------
 2 files changed, 37 deletions(-)

diff -puN include/linux/profile.h~profiling-remove-unused-timer-hook include/linux/profile.h
--- a/include/linux/profile.h~profiling-remove-unused-timer-hook
+++ a/include/linux/profile.h
@@ -82,9 +82,6 @@ int task_handoff_unregister(struct notif
 int profile_event_register(enum profile_type, struct notifier_block * n);
 int profile_event_unregister(enum profile_type, struct notifier_block * n);
 
-int register_timer_hook(int (*hook)(struct pt_regs *));
-void unregister_timer_hook(int (*hook)(struct pt_regs *));
-
 struct pt_regs;
 
 #else
@@ -135,16 +132,6 @@ static inline int profile_event_unregist
 #define profile_handoff_task(a) (0)
 #define profile_munmap(a) do { } while (0)
 
-static inline int register_timer_hook(int (*hook)(struct pt_regs *))
-{
-	return -ENOSYS;
-}
-
-static inline void unregister_timer_hook(int (*hook)(struct pt_regs *))
-{
-	return;
-}
-
 #endif /* CONFIG_PROFILING */
 
 #endif /* _LINUX_PROFILE_H */
diff -puN kernel/profile.c~profiling-remove-unused-timer-hook kernel/profile.c
--- a/kernel/profile.c~profiling-remove-unused-timer-hook
+++ a/kernel/profile.c
@@ -37,9 +37,6 @@ struct profile_hit {
 #define NR_PROFILE_HIT		(PAGE_SIZE/sizeof(struct profile_hit))
 #define NR_PROFILE_GRP		(NR_PROFILE_HIT/PROFILE_GRPSZ)
 
-/* Oprofile timer tick hook */
-static int (*timer_hook)(struct pt_regs *) __read_mostly;
-
 static atomic_t *prof_buffer;
 static unsigned long prof_len, prof_shift;
 
@@ -208,25 +205,6 @@ int profile_event_unregister(enum profil
 }
 EXPORT_SYMBOL_GPL(profile_event_unregister);
 
-int register_timer_hook(int (*hook)(struct pt_regs *))
-{
-	if (timer_hook)
-		return -EBUSY;
-	timer_hook = hook;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(register_timer_hook);
-
-void unregister_timer_hook(int (*hook)(struct pt_regs *))
-{
-	WARN_ON(hook != timer_hook);
-	timer_hook = NULL;
-	/* make sure all CPUs see the NULL hook */
-	synchronize_sched();  /* Allow ongoing interrupts to complete. */
-}
-EXPORT_SYMBOL_GPL(unregister_timer_hook);
-
