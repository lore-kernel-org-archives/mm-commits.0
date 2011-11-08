From: akpm@linux-foundation.org
Subject: [to-be-updated] kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch removed from -mm tree
Date: Tue, 08 Nov 2011 14:12:11 -0800
Message-ID: <201111082212.pA8MCBOJ010816@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:53808 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab1KHWMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2011 17:12:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cschan@codeaurora.org, john.stultz@linaro.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/timer.c: use debugobjects to catch deletion of uninitialized timers
has been removed from the -mm tree.  Its filename was
     kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Christine Chan <cschan@codeaurora.org>
Subject: kernel/timer.c: use debugobjects to catch deletion of uninitialized timers

del_timer_sync() calls debug_object_assert_init() to assert that a timer
has been initialized before calling lock_timer_base().  lock_timer_base()
would spin forever on a NULL(uninit-ed) base.  The check is added to
del_timer() to prevent silent failure, even though it would not get stuck
in an infinite loop.

Signed-off-by: Christine Chan <cschan@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |   54 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 5 deletions(-)

diff -puN kernel/timer.c~kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers kernel/timer.c
--- a/kernel/timer.c~kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers
+++ a/kernel/timer.c
@@ -480,12 +480,41 @@ static int timer_fixup_free(void *addr, 
 	}
 }
 
+/*
+ * fixup_assert_init is called when:
+ * - an untracked/uninit-ed object is found
+ */
+static int timer_fixup_assert_init(void *addr, enum debug_obj_state state)
+{
+	struct timer_list *timer = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_NOTAVAILABLE:
+		if (timer->entry.prev == TIMER_ENTRY_STATIC) {
+			/*
+			 * This is not really a fixup. The timer was
+			 * statically initialized. We just make sure that it
+			 * is tracked in the object tracker.
+			 */
+			debug_object_init(timer, &timer_debug_descr);
+			return 0;
+		} else {
+			WARN_ON(1);
+			init_timer(timer);
+			return 1;
+		}
+	default:
+		return 0;
+	}
+}
+
 static struct debug_obj_descr timer_debug_descr = {
-	.name		= "timer_list",
-	.debug_hint	= timer_debug_hint,
-	.fixup_init	= timer_fixup_init,
-	.fixup_activate	= timer_fixup_activate,
-	.fixup_free	= timer_fixup_free,
+	.name			= "timer_list",
+	.debug_hint		= timer_debug_hint,
+	.fixup_init		= timer_fixup_init,
+	.fixup_activate		= timer_fixup_activate,
+	.fixup_free		= timer_fixup_free,
+	.fixup_assert_init	= timer_fixup_assert_init,
 };
 
 static inline void debug_timer_init(struct timer_list *timer)
@@ -508,6 +537,11 @@ static inline void debug_timer_free(stru
 	debug_object_free(timer, &timer_debug_descr);
 }
 
+static inline void debug_timer_assert_init(struct timer_list *timer)
+{
+	debug_object_assert_init(timer, &timer_debug_descr);
+}
+
 static void __init_timer(struct timer_list *timer,
 			 const char *name,
 			 struct lock_class_key *key);
@@ -531,6 +565,7 @@ EXPORT_SYMBOL_GPL(destroy_timer_on_stack
 static inline void debug_timer_init(struct timer_list *timer) { }
 static inline void debug_timer_activate(struct timer_list *timer) { }
 static inline void debug_timer_deactivate(struct timer_list *timer) { }
+static inline void debug_timer_assert_init(struct timer_list *timer) { }
 #endif
 
 static inline void debug_init(struct timer_list *timer)
@@ -552,6 +587,11 @@ static inline void debug_deactivate(stru
 	trace_timer_cancel(timer);
 }
 
+static inline void debug_assert_init(struct timer_list *timer)
+{
+	debug_timer_assert_init(timer);
+}
+
 static void __init_timer(struct timer_list *timer,
 			 const char *name,
 			 struct lock_class_key *key)
@@ -902,6 +942,8 @@ int del_timer(struct timer_list *timer)
 	unsigned long flags;
 	int ret = 0;
 
+	debug_assert_init(timer);
+
 	timer_stats_timer_clear_start_info(timer);
 	if (timer_pending(timer)) {
 		base = lock_timer_base(timer, &flags);
@@ -932,6 +974,8 @@ int try_to_del_timer_sync(struct timer_l
 	unsigned long flags;
 	int ret = -1;
 
+	debug_assert_init(timer);
+
 	base = lock_timer_base(timer, &flags);
 
 	if (base->running_timer == timer)
_

Patches currently in -mm which might be from cschan@codeaurora.org are


