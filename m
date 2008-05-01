From: akpm@linux-foundation.org
Subject: - debugobjects-add-timer-specific-object-debugging-code.patch removed from -mm tree
Date: Thu, 01 May 2008 02:32:59 -0700
Message-ID: <200805010932.m419WxhP031028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755238AbYEAJdg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:33:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, greg@kroah.com, kay.sievers@vrfy.org, mingo@elte.hu, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     debugobjects: add timer specific object debugging code
has been removed from the -mm tree.  Its filename was
     debugobjects-add-timer-specific-object-debugging-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: debugobjects: add timer specific object debugging code
From: Thomas Gleixner <tglx@linutronix.de>

Add calls to the generic object debugging infrastructure and provide fixup
functions which allow to keep the system alive when recoverable problems have
been detected by the object debugging core code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/ieee1284.c |    4 
 fs/aio.c                   |    5 -
 include/linux/poison.h     |    7 +
 include/linux/timer.h      |   23 +++++
 kernel/timer.c             |  153 +++++++++++++++++++++++++++++++++--
 lib/Kconfig.debug          |    8 +
 6 files changed, 187 insertions(+), 13 deletions(-)

diff -puN drivers/parport/ieee1284.c~debugobjects-add-timer-specific-object-debugging-code drivers/parport/ieee1284.c
--- a/drivers/parport/ieee1284.c~debugobjects-add-timer-specific-object-debugging-code
+++ a/drivers/parport/ieee1284.c
@@ -76,7 +76,7 @@ int parport_wait_event (struct parport *
 		   semaphore. */
 		return 1;
 
-	init_timer (&timer);
+	init_timer_on_stack(&timer);
 	timer.expires = jiffies + timeout;
 	timer.function = timeout_waiting_on_port;
 	port_from_cookie[port->number % PARPORT_MAX] = port;
@@ -88,6 +88,8 @@ int parport_wait_event (struct parport *
 		/* Timed out. */
 		ret = 1;
 
+	destroy_timer_on_stack(&timer);
+
 	return ret;
 }
 
diff -puN fs/aio.c~debugobjects-add-timer-specific-object-debugging-code fs/aio.c
--- a/fs/aio.c~debugobjects-add-timer-specific-object-debugging-code
+++ a/fs/aio.c
@@ -1078,9 +1078,7 @@ static void timeout_func(unsigned long d
 
 static inline void init_timeout(struct aio_timeout *to)
 {
-	init_timer(&to->timer);
-	to->timer.data = (unsigned long)to;
-	to->timer.function = timeout_func;
+	setup_timer_on_stack(&to->timer, timeout_func, (unsigned long) to);
 	to->timed_out = 0;
 	to->p = current;
 }
@@ -1213,6 +1211,7 @@ retry:
 	if (timeout)
 		clear_timeout(&to);
 out:
+	destroy_timer_on_stack(&to.timer);
 	return i ? i : ret;
 }
 
diff -puN include/linux/poison.h~debugobjects-add-timer-specific-object-debugging-code include/linux/poison.h
--- a/include/linux/poison.h~debugobjects-add-timer-specific-object-debugging-code
+++ a/include/linux/poison.h
@@ -10,6 +10,13 @@
 #define LIST_POISON1  ((void *) 0x00100100)
 #define LIST_POISON2  ((void *) 0x00200200)
 
+/********** include/linux/timer.h **********/
+/*
+ * Magic number "tsta" to indicate a static timer initializer
+ * for the object debugging code.
+ */
+#define TIMER_ENTRY_STATIC	((void *) 0x74737461)
+
 /********** mm/slab.c **********/
 /*
  * Magic nums for obj red zoning.
diff -puN include/linux/timer.h~debugobjects-add-timer-specific-object-debugging-code include/linux/timer.h
--- a/include/linux/timer.h~debugobjects-add-timer-specific-object-debugging-code
+++ a/include/linux/timer.h
@@ -4,6 +4,7 @@
 #include <linux/list.h>
 #include <linux/ktime.h>
 #include <linux/stddef.h>
+#include <linux/debugobjects.h>
 
 struct tvec_base;
 
@@ -25,6 +26,7 @@ struct timer_list {
 extern struct tvec_base boot_tvec_bases;
 
 #define TIMER_INITIALIZER(_function, _expires, _data) {		\
+		.entry = { .prev = TIMER_ENTRY_STATIC },	\
 		.function = (_function),			\
 		.expires = (_expires),				\
 		.data = (_data),				\
@@ -38,6 +40,17 @@ extern struct tvec_base boot_tvec_bases;
 void init_timer(struct timer_list *timer);
 void init_timer_deferrable(struct timer_list *timer);
 
+#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
+extern void init_timer_on_stack(struct timer_list *timer);
+extern void destroy_timer_on_stack(struct timer_list *timer);
+#else
+static inline void destroy_timer_on_stack(struct timer_list *timer) { }
+static inline void init_timer_on_stack(struct timer_list *timer)
+{
+	init_timer(timer);
+}
+#endif
+
 static inline void setup_timer(struct timer_list * timer,
 				void (*function)(unsigned long),
 				unsigned long data)
@@ -47,6 +60,15 @@ static inline void setup_timer(struct ti
 	init_timer(timer);
 }
 
+static inline void setup_timer_on_stack(struct timer_list *timer,
+					void (*function)(unsigned long),
+					unsigned long data)
+{
+	timer->function = function;
+	timer->data = data;
+	init_timer_on_stack(timer);
+}
+
 /**
  * timer_pending - is a timer pending?
  * @timer: the timer in question
@@ -164,5 +186,4 @@ unsigned long __round_jiffies_relative(u
 unsigned long round_jiffies(unsigned long j);
 unsigned long round_jiffies_relative(unsigned long j);
 
-
 #endif
diff -puN kernel/timer.c~debugobjects-add-timer-specific-object-debugging-code kernel/timer.c
--- a/kernel/timer.c~debugobjects-add-timer-specific-object-debugging-code
+++ a/kernel/timer.c
@@ -320,14 +320,130 @@ static void timer_stats_account_timer(st
 static void timer_stats_account_timer(struct timer_list *timer) {}
 #endif
 
-/**
- * init_timer - initialize a timer.
- * @timer: the timer to be initialized
- *
- * init_timer() must be done to a timer prior calling *any* of the
- * other timer functions.
+#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
+
+static struct debug_obj_descr timer_debug_descr;
+
+/*
+ * fixup_init is called when:
+ * - an active object is initialized
  */
-void init_timer(struct timer_list *timer)
+static int timer_fixup_init(void *addr, enum debug_obj_state state)
+{
+	struct timer_list *timer = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_ACTIVE:
+		del_timer_sync(timer);
+		debug_object_init(timer, &timer_debug_descr);
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
+static int timer_fixup_activate(void *addr, enum debug_obj_state state)
+{
+	struct timer_list *timer = addr;
+
+	switch (state) {
+
+	case ODEBUG_STATE_NOTAVAILABLE:
+		/*
+		 * This is not really a fixup. The timer was
+		 * statically initialized. We just make sure that it
+		 * is tracked in the object tracker.
+		 */
+		if (timer->entry.next == NULL &&
+		    timer->entry.prev == TIMER_ENTRY_STATIC) {
+			debug_object_init(timer, &timer_debug_descr);
+			debug_object_activate(timer, &timer_debug_descr);
+			return 0;
+		} else {
+			WARN_ON_ONCE(1);
+		}
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
+static int timer_fixup_free(void *addr, enum debug_obj_state state)
+{
+	struct timer_list *timer = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_ACTIVE:
+		del_timer_sync(timer);
+		debug_object_free(timer, &timer_debug_descr);
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+static struct debug_obj_descr timer_debug_descr = {
+	.name		= "timer_list",
+	.fixup_init	= timer_fixup_init,
+	.fixup_activate	= timer_fixup_activate,
+	.fixup_free	= timer_fixup_free,
+};
+
+static inline void debug_timer_init(struct timer_list *timer)
+{
+	debug_object_init(timer, &timer_debug_descr);
+}
+
+static inline void debug_timer_activate(struct timer_list *timer)
+{
+	debug_object_activate(timer, &timer_debug_descr);
+}
+
+static inline void debug_timer_deactivate(struct timer_list *timer)
+{
+	debug_object_deactivate(timer, &timer_debug_descr);
+}
+
+static inline void debug_timer_free(struct timer_list *timer)
+{
+	debug_object_free(timer, &timer_debug_descr);
+}
+
+static void __init_timer(struct timer_list *timer);
+
+void init_timer_on_stack(struct timer_list *timer)
+{
+	debug_object_init_on_stack(timer, &timer_debug_descr);
+	__init_timer(timer);
+}
+EXPORT_SYMBOL_GPL(init_timer_on_stack);
+
+void destroy_timer_on_stack(struct timer_list *timer)
+{
+	debug_object_free(timer, &timer_debug_descr);
+}
+EXPORT_SYMBOL_GPL(destroy_timer_on_stack);
+
+#else
+static inline void debug_timer_init(struct timer_list *timer) { }
+static inline void debug_timer_activate(struct timer_list *timer) { }
+static inline void debug_timer_deactivate(struct timer_list *timer) { }
+#endif
+
+static void __init_timer(struct timer_list *timer)
 {
 	timer->entry.next = NULL;
 	timer->base = __raw_get_cpu_var(tvec_bases);
@@ -337,6 +453,19 @@ void init_timer(struct timer_list *timer
 	memset(timer->start_comm, 0, TASK_COMM_LEN);
 #endif
 }
+
+/**
+ * init_timer - initialize a timer.
+ * @timer: the timer to be initialized
+ *
+ * init_timer() must be done to a timer prior calling *any* of the
+ * other timer functions.
+ */
+void init_timer(struct timer_list *timer)
+{
+	debug_timer_init(timer);
+	__init_timer(timer);
+}
 EXPORT_SYMBOL(init_timer);
 
 void init_timer_deferrable(struct timer_list *timer)
@@ -351,6 +480,8 @@ static inline void detach_timer(struct t
 {
 	struct list_head *entry = &timer->entry;
 
+	debug_timer_deactivate(timer);
+
 	__list_del(entry->prev, entry->next);
 	if (clear_pending)
 		entry->next = NULL;
@@ -405,6 +536,8 @@ int __mod_timer(struct timer_list *timer
 		ret = 1;
 	}
 
+	debug_timer_activate(timer);
+
 	new_base = __get_cpu_var(tvec_bases);
 
 	if (base != new_base) {
@@ -450,6 +583,7 @@ void add_timer_on(struct timer_list *tim
 	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
 	timer_set_base(timer, base);
+	debug_timer_activate(timer);
 	internal_add_timer(base, timer);
 	/*
 	 * Check whether the other CPU is idle and needs to be
@@ -1086,11 +1220,14 @@ signed long __sched schedule_timeout(sig
 
 	expire = timeout + jiffies;
 
-	setup_timer(&timer, process_timeout, (unsigned long)current);
+	setup_timer_on_stack(&timer, process_timeout, (unsigned long)current);
 	__mod_timer(&timer, expire);
 	schedule();
 	del_singleshot_timer_sync(&timer);
 
+	/* Remove the timer from the object tracker */
+	destroy_timer_on_stack(&timer);
+
 	timeout = expire - jiffies;
 
  out:
diff -puN lib/Kconfig.debug~debugobjects-add-timer-specific-object-debugging-code lib/Kconfig.debug
--- a/lib/Kconfig.debug~debugobjects-add-timer-specific-object-debugging-code
+++ a/lib/Kconfig.debug
@@ -217,6 +217,14 @@ config DEBUG_OBJECTS_FREE
 	  properly. This can make kmalloc/kfree-intensive workloads
 	  much slower.
 
+config DEBUG_OBJECTS_TIMERS
+	bool "Debug timer objects"
+	depends on DEBUG_OBJECTS
+	help
+	  If you say Y here, additional code will be inserted into the
+	  timer routines to track the life time of timer objects and
+	  validate the timer operations.
+
 config DEBUG_SLAB
 	bool "Debug slab memory allocations"
 	depends on DEBUG_KERNEL && SLAB
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

