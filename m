From: akpm@linux-foundation.org
Subject: - add-hrtimer-specific-debugobjects-code.patch removed from -mm tree
Date: Thu, 01 May 2008 02:33:01 -0700
Message-ID: <200805010933.m419X1VJ031098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758131AbYEAJdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:33:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, greg@kroah.com, kay.sievers@vrfy.org, mingo@elte.hu, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     add hrtimer specific debugobjects code
has been removed from the -mm tree.  Its filename was
     add-hrtimer-specific-debugobjects-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add hrtimer specific debugobjects code
From: Thomas Gleixner <tglx@linutronix.de>

hrtimers have now dynamic users in the network code.  Put them under
debugobjects surveillance as well.

Add calls to the generic object debugging infrastructure and provide fixup
functions which allow to keep the system alive when recoverable problems have
been detected by the object debugging core code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hrtimer.h |   15 +++
 kernel/futex.c          |   17 +++
 kernel/hrtimer.c        |  177 +++++++++++++++++++++++++++++++++-----
 3 files changed, 186 insertions(+), 23 deletions(-)

diff -puN include/linux/hrtimer.h~add-hrtimer-specific-debugobjects-code include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~add-hrtimer-specific-debugobjects-code
+++ a/include/linux/hrtimer.h
@@ -266,6 +266,21 @@ extern ktime_t ktime_get_real(void);
 extern void hrtimer_init(struct hrtimer *timer, clockid_t which_clock,
 			 enum hrtimer_mode mode);
 
+#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
+extern void hrtimer_init_on_stack(struct hrtimer *timer, clockid_t which_clock,
+				  enum hrtimer_mode mode);
+
+extern void destroy_hrtimer_on_stack(struct hrtimer *timer);
+#else
+static inline void hrtimer_init_on_stack(struct hrtimer *timer,
+					 clockid_t which_clock,
+					 enum hrtimer_mode mode)
+{
+	hrtimer_init(timer, which_clock, mode);
+}
+static inline void destroy_hrtimer_on_stack(struct hrtimer *timer) { }
+#endif
+
 /* Basic timer operations: */
 extern int hrtimer_start(struct hrtimer *timer, ktime_t tim,
 			 const enum hrtimer_mode mode);
diff -puN kernel/futex.c~add-hrtimer-specific-debugobjects-code kernel/futex.c
--- a/kernel/futex.c~add-hrtimer-specific-debugobjects-code
+++ a/kernel/futex.c
@@ -1266,11 +1266,13 @@ static int futex_wait(u32 __user *uaddr,
 		if (!abs_time)
 			schedule();
 		else {
-			hrtimer_init(&t.timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+			hrtimer_init_on_stack(&t.timer, CLOCK_MONOTONIC,
+						HRTIMER_MODE_ABS);
 			hrtimer_init_sleeper(&t, current);
 			t.timer.expires = *abs_time;
 
-			hrtimer_start(&t.timer, t.timer.expires, HRTIMER_MODE_ABS);
+			hrtimer_start(&t.timer, t.timer.expires,
+						HRTIMER_MODE_ABS);
 			if (!hrtimer_active(&t.timer))
 				t.task = NULL;
 
@@ -1286,6 +1288,8 @@ static int futex_wait(u32 __user *uaddr,
 
 			/* Flag if a timeout occured */
 			rem = (t.task == NULL);
+
+			destroy_hrtimer_on_stack(&t.timer);
 		}
 	}
 	__set_current_state(TASK_RUNNING);
@@ -1367,7 +1371,8 @@ static int futex_lock_pi(u32 __user *uad
 
 	if (time) {
 		to = &timeout;
-		hrtimer_init(&to->timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
+		hrtimer_init_on_stack(&to->timer, CLOCK_REALTIME,
+				      HRTIMER_MODE_ABS);
 		hrtimer_init_sleeper(to, current);
 		to->timer.expires = *time;
 	}
@@ -1581,6 +1586,8 @@ static int futex_lock_pi(u32 __user *uad
 	unqueue_me_pi(&q);
 	futex_unlock_mm(fshared);
 
+	if (to)
+		destroy_hrtimer_on_stack(&to->timer);
 	return ret != -EINTR ? ret : -ERESTARTNOINTR;
 
  out_unlock_release_sem:
@@ -1588,6 +1595,8 @@ static int futex_lock_pi(u32 __user *uad
 
  out_release_sem:
 	futex_unlock_mm(fshared);
+	if (to)
+		destroy_hrtimer_on_stack(&to->timer);
 	return ret;
 
  uaddr_faulted:
@@ -1615,6 +1624,8 @@ static int futex_lock_pi(u32 __user *uad
 	if (!ret && (uval != -EFAULT))
 		goto retry;
 
+	if (to)
+		destroy_hrtimer_on_stack(&to->timer);
 	return ret;
 }
 
diff -puN kernel/hrtimer.c~add-hrtimer-specific-debugobjects-code kernel/hrtimer.c
--- a/kernel/hrtimer.c~add-hrtimer-specific-debugobjects-code
+++ a/kernel/hrtimer.c
@@ -43,6 +43,7 @@
 #include <linux/tick.h>
 #include <linux/seq_file.h>
 #include <linux/err.h>
+#include <linux/debugobjects.h>
 
 #include <asm/uaccess.h>
 
@@ -342,6 +343,115 @@ ktime_t ktime_add_safe(const ktime_t lhs
 	return res;
 }
 
+#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
+
+static struct debug_obj_descr hrtimer_debug_descr;
+
+/*
+ * fixup_init is called when:
+ * - an active object is initialized
+ */
+static int hrtimer_fixup_init(void *addr, enum debug_obj_state state)
+{
+	struct hrtimer *timer = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_ACTIVE:
+		hrtimer_cancel(timer);
+		debug_object_init(timer, &hrtimer_debug_descr);
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+/*
+ * fixup_activate is called when:
+ * - an active object is activated
+ * - an unknown object is activated (might be a statically initialized object)
+ */
+static int hrtimer_fixup_activate(void *addr, enum debug_obj_state state)
+{
+	switch (state) {
+
+	case ODEBUG_STATE_NOTAVAILABLE:
+		WARN_ON_ONCE(1);
+		return 0;
+
+	case ODEBUG_STATE_ACTIVE:
+		WARN_ON(1);
+
+	default:
+		return 0;
+	}
+}
+
+/*
+ * fixup_free is called when:
+ * - an active object is freed
+ */
+static int hrtimer_fixup_free(void *addr, enum debug_obj_state state)
+{
+	struct hrtimer *timer = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_ACTIVE:
+		hrtimer_cancel(timer);
+		debug_object_free(timer, &hrtimer_debug_descr);
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+static struct debug_obj_descr hrtimer_debug_descr = {
+	.name		= "hrtimer",
+	.fixup_init	= hrtimer_fixup_init,
+	.fixup_activate	= hrtimer_fixup_activate,
+	.fixup_free	= hrtimer_fixup_free,
+};
+
+static inline void debug_hrtimer_init(struct hrtimer *timer)
+{
+	debug_object_init(timer, &hrtimer_debug_descr);
+}
+
+static inline void debug_hrtimer_activate(struct hrtimer *timer)
+{
+	debug_object_activate(timer, &hrtimer_debug_descr);
+}
+
+static inline void debug_hrtimer_deactivate(struct hrtimer *timer)
+{
+	debug_object_deactivate(timer, &hrtimer_debug_descr);
+}
+
+static inline void debug_hrtimer_free(struct hrtimer *timer)
+{
+	debug_object_free(timer, &hrtimer_debug_descr);
+}
+
+static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
+			   enum hrtimer_mode mode);
+
+void hrtimer_init_on_stack(struct hrtimer *timer, clockid_t clock_id,
+			   enum hrtimer_mode mode)
+{
+	debug_object_init_on_stack(timer, &hrtimer_debug_descr);
+	__hrtimer_init(timer, clock_id, mode);
+}
+
+void destroy_hrtimer_on_stack(struct hrtimer *timer)
+{
+	debug_object_free(timer, &hrtimer_debug_descr);
+}
+
+#else
+static inline void debug_hrtimer_init(struct hrtimer *timer) { }
+static inline void debug_hrtimer_activate(struct hrtimer *timer) { }
+static inline void debug_hrtimer_deactivate(struct hrtimer *timer) { }
+#endif
+
 /*
  * Check, whether the timer is on the callback pending list
  */
@@ -567,6 +677,7 @@ static inline int hrtimer_enqueue_reprog
 		/* Timer is expired, act upon the callback mode */
 		switch(timer->cb_mode) {
 		case HRTIMER_CB_IRQSAFE_NO_RESTART:
+			debug_hrtimer_deactivate(timer);
 			/*
 			 * We can call the callback from here. No restart
 			 * happens, so no danger of recursion
@@ -581,6 +692,7 @@ static inline int hrtimer_enqueue_reprog
 			 * the tick timer in the softirq ! The calling site
 			 * takes care of this.
 			 */
+			debug_hrtimer_deactivate(timer);
 			return 1;
 		case HRTIMER_CB_IRQSAFE:
 		case HRTIMER_CB_SOFTIRQ:
@@ -735,6 +847,8 @@ static void enqueue_hrtimer(struct hrtim
 	struct hrtimer *entry;
 	int leftmost = 1;
 
+	debug_hrtimer_activate(timer);
+
 	/*
 	 * Find the right place in the rbtree:
 	 */
@@ -831,6 +945,7 @@ remove_hrtimer(struct hrtimer *timer, st
 		 * reprogramming happens in the interrupt handler. This is a
 		 * rare case and less expensive than a smp call.
 		 */
+		debug_hrtimer_deactivate(timer);
 		timer_stats_hrtimer_clear_start_info(timer);
 		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
 		__remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE,
@@ -878,6 +993,7 @@ hrtimer_start(struct hrtimer *timer, kti
 		tim = ktime_add_safe(tim, base->resolution);
 #endif
 	}
+
 	timer->expires = tim;
 
 	timer_stats_hrtimer_set_start_info(timer);
@@ -1011,14 +1127,8 @@ ktime_t hrtimer_get_next_event(void)
 }
 #endif
 
-/**
- * hrtimer_init - initialize a timer to the given clock
- * @timer:	the timer to be initialized
- * @clock_id:	the clock to be used
- * @mode:	timer mode abs/rel
- */
-void hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
-		  enum hrtimer_mode mode)
+static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
+			   enum hrtimer_mode mode)
 {
 	struct hrtimer_cpu_base *cpu_base;
 
@@ -1039,6 +1149,19 @@ void hrtimer_init(struct hrtimer *timer,
 	memset(timer->start_comm, 0, TASK_COMM_LEN);
 #endif
 }
+
+/**
+ * hrtimer_init - initialize a timer to the given clock
+ * @timer:	the timer to be initialized
+ * @clock_id:	the clock to be used
+ * @mode:	timer mode abs/rel
+ */
+void hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
+		  enum hrtimer_mode mode)
+{
+	debug_hrtimer_init(timer);
+	__hrtimer_init(timer, clock_id, mode);
+}
 EXPORT_SYMBOL_GPL(hrtimer_init);
 
 /**
@@ -1072,6 +1195,7 @@ static void run_hrtimer_pending(struct h
 		timer = list_entry(cpu_base->cb_pending.next,
 				   struct hrtimer, cb_entry);
 
+		debug_hrtimer_deactivate(timer);
 		timer_stats_account_hrtimer(timer);
 
 		fn = timer->function;
@@ -1120,6 +1244,7 @@ static void __run_hrtimer(struct hrtimer
 	enum hrtimer_restart (*fn)(struct hrtimer *);
 	int restart;
 
+	debug_hrtimer_deactivate(timer);
 	__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK, 0);
 	timer_stats_account_hrtimer(timer);
 
@@ -1378,22 +1503,27 @@ long __sched hrtimer_nanosleep_restart(s
 {
 	struct hrtimer_sleeper t;
 	struct timespec __user  *rmtp;
+	int ret = 0;
 
-	hrtimer_init(&t.timer, restart->nanosleep.index, HRTIMER_MODE_ABS);
+	hrtimer_init_on_stack(&t.timer, restart->nanosleep.index,
+				HRTIMER_MODE_ABS);
 	t.timer.expires.tv64 = restart->nanosleep.expires;
 
 	if (do_nanosleep(&t, HRTIMER_MODE_ABS))
-		return 0;
+		goto out;
 
 	rmtp = restart->nanosleep.rmtp;
 	if (rmtp) {
-		int ret = update_rmtp(&t.timer, rmtp);
+		ret = update_rmtp(&t.timer, rmtp);
 		if (ret <= 0)
-			return ret;
+			goto out;
 	}
 
 	/* The other values in restart are already filled in */
-	return -ERESTART_RESTARTBLOCK;
+	ret = -ERESTART_RESTARTBLOCK;
+out:
+	destroy_hrtimer_on_stack(&t.timer);
+	return ret;
 }
 
 long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
@@ -1401,20 +1531,23 @@ long hrtimer_nanosleep(struct timespec *
 {
 	struct restart_block *restart;
 	struct hrtimer_sleeper t;
+	int ret = 0;
 
-	hrtimer_init(&t.timer, clockid, mode);
+	hrtimer_init_on_stack(&t.timer, clockid, mode);
 	t.timer.expires = timespec_to_ktime(*rqtp);
 	if (do_nanosleep(&t, mode))
-		return 0;
+		goto out;
 
 	/* Absolute timers do not update the rmtp value and restart: */
-	if (mode == HRTIMER_MODE_ABS)
-		return -ERESTARTNOHAND;
+	if (mode == HRTIMER_MODE_ABS) {
+		ret = -ERESTARTNOHAND;
+		goto out;
+	}
 
 	if (rmtp) {
-		int ret = update_rmtp(&t.timer, rmtp);
+		ret = update_rmtp(&t.timer, rmtp);
 		if (ret <= 0)
-			return ret;
+			goto out;
 	}
 
 	restart = &current_thread_info()->restart_block;
@@ -1423,7 +1556,10 @@ long hrtimer_nanosleep(struct timespec *
 	restart->nanosleep.rmtp = rmtp;
 	restart->nanosleep.expires = t.timer.expires.tv64;
 
-	return -ERESTART_RESTARTBLOCK;
+	ret = -ERESTART_RESTARTBLOCK;
+out:
+	destroy_hrtimer_on_stack(&t.timer);
+	return ret;
 }
 
 asmlinkage long
@@ -1468,6 +1604,7 @@ static void migrate_hrtimer_list(struct 
 	while ((node = rb_first(&old_base->active))) {
 		timer = rb_entry(node, struct hrtimer, node);
 		BUG_ON(hrtimer_callback_running(timer));
+		debug_hrtimer_deactivate(timer);
 		__remove_hrtimer(timer, old_base, HRTIMER_STATE_INACTIVE, 0);
 		timer->base = new_base;
 		/*
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
introduce-explicit-signed-unsigned-64bit-divide.patch
convert-a-few-do_div-user.patch
rename-div64_64-to-div64_u64-ia64.patch
remove-div_long_long_rem.patch
ntp-cleanup-ntpc.patch
ntp-ntp4-user-space-bits-update.patch
ntp-increase-time_freq-resolution.patch
ntp-increase-time_offset-resolution.patch
ntp-support-for-tai.patch
ntp-rename-tick_length_shift-to-ntp_scale_shift.patch
ntp-remove-current_tick_length.patch
ntp-handle-leap-second-via-timer.patch
git-x86.patch
git-x86-fixup.patch
x86_64-restore-mask_bits-in-msi-shutdown.patch
arch-x86-video-fbdevc-add-module_license.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
git-kvm.patch
rename-div64_64-to-div64_u64-kvm.patch
git-sched.patch
aes-x86_64-asm-implementation-optimization.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
x86-ioremap-add-checks-for-virtual-addresses.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch

