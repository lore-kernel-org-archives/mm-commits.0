From: akpm@linux-foundation.org
Subject: + lguest-the-host-code-use-hrtimers.patch added to -mm tree
Date: Tue, 05 Jun 2007 14:19:28 -0700
Message-ID: <200706052119.l55LJStS003228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47535 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932877AbXFEVUM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 17:20:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmorris@namei.org, rusty@rustcorp.com.au, tglx@linutronix.de


The patch titled
     lguest: use hrtimers
has been added to the -mm tree.  Its filename is
     lguest-the-host-code-use-hrtimers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: use hrtimers
From: James Morris <jmorris@namei.org>

Convert lguest to the hrtimer framework, enabling dynamic ticks and high
resolution timers.

(BTW Thomas, is the check for delta < minimum actually required in our
set_next_event function?)

Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/core.c                 |    2 
 drivers/lguest/hypercalls.c           |   10 +--
 drivers/lguest/interrupts_and_traps.c |   34 +++++++++++-
 drivers/lguest/lg.h                   |    6 +-
 drivers/lguest/lguest.c               |   63 ++++++++++++++++++++++--
 drivers/lguest/lguest_user.c          |    3 +
 include/linux/lguest.h                |    5 +
 7 files changed, 106 insertions(+), 17 deletions(-)

diff -puN drivers/lguest/core.c~lguest-the-host-code-use-hrtimers drivers/lguest/core.c
--- a/drivers/lguest/core.c~lguest-the-host-code-use-hrtimers
+++ a/drivers/lguest/core.c
@@ -328,7 +328,7 @@ int run_guest(struct lguest *lg, unsigne
 
 		if (lg->halted) {
 			set_current_state(TASK_INTERRUPTIBLE);
-			schedule_timeout(1);
+			schedule();
 			continue;
 		}
 
diff -puN drivers/lguest/hypercalls.c~lguest-the-host-code-use-hrtimers drivers/lguest/hypercalls.c
--- a/drivers/lguest/hypercalls.c~lguest-the-host-code-use-hrtimers
+++ a/drivers/lguest/hypercalls.c
@@ -44,13 +44,6 @@ static void do_hcall(struct lguest *lg, 
 		else
 			guest_pagetable_flush_user(lg);
 		break;
-	case LHCALL_TIMER_READ: {
-		u32 now = jiffies;
-		mb();
-		regs->eax = now - lg->last_timer;
-		lg->last_timer = now;
-		break;
-	}
 	case LHCALL_GET_WALLCLOCK: {
 		struct timespec ts;
 		ktime_get_real_ts(&ts);
@@ -85,6 +78,9 @@ static void do_hcall(struct lguest *lg, 
 	case LHCALL_LOAD_TLS:
 		guest_load_tls(lg, regs->edx);
 		break;
+	case LHCALL_SET_CLOCKEVENT:
+		guest_set_clockevent(lg, regs->edx);
+		break;
 	case LHCALL_TS:
 		lg->ts = regs->edx;
 		break;
diff -puN drivers/lguest/interrupts_and_traps.c~lguest-the-host-code-use-hrtimers drivers/lguest/interrupts_and_traps.c
--- a/drivers/lguest/interrupts_and_traps.c~lguest-the-host-code-use-hrtimers
+++ a/drivers/lguest/interrupts_and_traps.c
@@ -73,10 +73,6 @@ void maybe_do_interrupt(struct lguest *l
 	if (!lg->lguest_data)
 		return;
 
-	/* If timer has changed, set timer interrupt. */
-	if (jiffies != lg->last_timer)
-		set_bit(0, lg->irqs_pending);
-
 	/* Mask out any interrupts they have blocked. */
 	if (copy_from_user(&blk, lg->lguest_data->blocked_interrupts,
 			   sizeof(blk)))
@@ -240,3 +236,33 @@ void copy_traps(const struct lguest *lg,
 	else
 		default_idt_entry(&idt[i], i, def[i]);
 }
+
+void guest_set_clockevent(struct lguest *lg, unsigned long delta)
+{
+	ktime_t expires;
+
+	if (unlikely(delta == 0)) {
+		/* Clock event device is shutting down. */
+		hrtimer_cancel(&lg->hrt);
+		return;
+	}
+
+	expires = ktime_add_ns(ktime_get_real(), delta);
+	hrtimer_start(&lg->hrt, expires, HRTIMER_MODE_ABS);
+}
+
+static enum hrtimer_restart clockdev_fn(struct hrtimer *timer)
+{
+	struct lguest *lg = container_of(timer, struct lguest, hrt);
+
+	set_bit(0, lg->irqs_pending);
+	if (lg->halted)
+		wake_up_process(lg->tsk);
+	return HRTIMER_NORESTART;
+}
+
+void init_clockdev(struct lguest *lg)
+{
+	hrtimer_init(&lg->hrt, CLOCK_REALTIME, HRTIMER_MODE_ABS);
+	lg->hrt.function = clockdev_fn;
+}
diff -puN drivers/lguest/lg.h~lguest-the-host-code-use-hrtimers drivers/lguest/lg.h
--- a/drivers/lguest/lg.h~lguest-the-host-code-use-hrtimers
+++ a/drivers/lguest/lg.h
@@ -134,7 +134,6 @@ struct lguest
 	u32 cr2;
 	int halted;
 	int ts;
-	u32 last_timer;
 	u32 next_hcall;
 	u32 esp1;
 	u8 ss1;
@@ -174,6 +173,9 @@ struct lguest
 	struct desc_struct idt[FIRST_EXTERNAL_VECTOR+LGUEST_IRQS];
 	struct desc_struct syscall_idt;
 
+	/* Virtual clock device */
+	struct hrtimer hrt;
+
 	/* Pending virtual interrupts */
 	DECLARE_BITMAP(irqs_pending, LGUEST_IRQS);
 };
@@ -202,6 +204,8 @@ void setup_default_idt_entries(struct lg
 			       const unsigned long *def);
 void copy_traps(const struct lguest *lg, struct desc_struct *idt,
 		const unsigned long *def);
+void guest_set_clockevent(struct lguest *lg, unsigned long delta);
+void init_clockdev(struct lguest *lg);
 
 /* segments.c: */
 void setup_default_gdt_entries(struct lguest_ro_state *state);
diff -puN drivers/lguest/lguest.c~lguest-the-host-code-use-hrtimers drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-the-host-code-use-hrtimers
+++ a/drivers/lguest/lguest.c
@@ -26,6 +26,7 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/clocksource.h>
+#include <linux/clockchips.h>
 #include <linux/lguest.h>
 #include <linux/lguest_launcher.h>
 #include <linux/lguest_bus.h>
@@ -359,8 +360,58 @@ static struct clocksource lguest_clock =
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
+/* We also need a "struct clock_event_device": Linux asks us to set it to go
+ * off some time in the future.  Actually, James Morris figured all this out, I
+ * just applied the patch. */
+static int lguest_clockevent_set_next_event(unsigned long delta,
+                                           struct clock_event_device *evt)
+{
+	if (delta < LG_CLOCK_MIN_DELTA) {
+		if (printk_ratelimit())
+			printk(KERN_DEBUG "%s: small delta %lu ns\n",
+			       __FUNCTION__, delta);
+		return -ETIME;
+	}
+	hcall(LHCALL_SET_CLOCKEVENT, delta, 0, 0);
+	return 0;
+}
+
+static void lguest_clockevent_set_mode(enum clock_event_mode mode,
+                                      struct clock_event_device *evt)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		/* A 0 argument shuts the clock down. */
+		hcall(LHCALL_SET_CLOCKEVENT, 0, 0, 0);
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		/* This is what we expect. */
+		break;
+	case CLOCK_EVT_MODE_PERIODIC:
+		BUG();
+	}
+}
+
+/* This describes our primitive timer chip. */
+static struct clock_event_device lguest_clockevent = {
+	.name                   = "lguest",
+	.features               = CLOCK_EVT_FEAT_ONESHOT,
+	.set_next_event         = lguest_clockevent_set_next_event,
+	.set_mode               = lguest_clockevent_set_mode,
+	.rating                 = INT_MAX,
+	.mult                   = 1,
+	.shift                  = 0,
+	.min_delta_ns           = LG_CLOCK_MIN_DELTA,
+	.max_delta_ns           = LG_CLOCK_MAX_DELTA,
+};
+
+/* This is the Guest timer interrupt handler (hardware interrupt 0).  We just
+ * call the clockevent infrastructure and it does whatever needs doing. */
 static void lguest_time_irq(unsigned int irq, struct irq_desc *desc)
 {
+	unsigned long flags;
+
 	/* Check in case host TSC has changed rate. */
 	if (unlikely(tsc_khz != lguest_data.tsc_khz)) {
 		tsc_khz = lguest_data.tsc_khz;
@@ -368,8 +419,11 @@ static void lguest_time_irq(unsigned int
 		__get_cpu_var(sc_data).cyc2ns_scale
 			= (1000000 << CYC2NS_SCALE_FACTOR) / tsc_khz;
 	}
-	do_timer(hcall(LHCALL_TIMER_READ, 0, 0, 0));
-	update_process_times(user_mode_vm(get_irq_regs()));
+
+	/* Don't interrupt us while this is running. */
+	local_irq_save(flags);
+	lguest_clockevent.event_handler(&lguest_clockevent);
+	local_irq_restore(flags);
 }
 
 static void lguest_time_init(void)
@@ -379,7 +433,10 @@ static void lguest_time_init(void)
 	lguest_clock.mult = clocksource_khz2mult(tsc_khz, 22);
 	clocksource_register(&lguest_clock);
 
-	hcall(LHCALL_TIMER_READ, 0, 0, 0);
+	/* We can't set cpumask in the initializer: damn C limitations! */
+	lguest_clockevent.cpumask = cpumask_of_cpu(0);
+	clockevents_register_device(&lguest_clockevent);
+
 	enable_lguest_irq(0);
 }
 
diff -puN drivers/lguest/lguest_user.c~lguest-the-host-code-use-hrtimers drivers/lguest/lguest_user.c
--- a/drivers/lguest/lguest_user.c~lguest-the-host-code-use-hrtimers
+++ a/drivers/lguest/lguest_user.c
@@ -139,6 +139,7 @@ static int initialize(struct file *file,
 
 	setup_regs(lg->regs, args[2]);
 	setup_guest_gdt(lg);
+	init_clockdev(lg);
 	lg->tsk = current;
 	get_task_struct(lg->tsk);
 	lg->mm = get_task_mm(lg->tsk);
@@ -200,6 +201,8 @@ static int close(struct inode *inode, st
 		return 0;
 
 	mutex_lock(&lguest_lock);
+	/* Cancels the hrtimer set via LHCALL_SET_CLOCKEVENT. */
+	hrtimer_cancel(&lg->hrt);
 	release_all_dma(lg);
 	free_guest_pagetable(lg);
 	put_task_struct(lg->tsk);
diff -puN include/linux/lguest.h~lguest-the-host-code-use-hrtimers include/linux/lguest.h
--- a/include/linux/lguest.h~lguest-the-host-code-use-hrtimers
+++ a/include/linux/lguest.h
@@ -15,7 +15,7 @@
 #define LHCALL_LOAD_IDT_ENTRY	6
 #define LHCALL_SET_STACK	7
 #define LHCALL_TS		8
-#define LHCALL_TIMER_READ	9
+#define LHCALL_SET_CLOCKEVENT	9
 #define LHCALL_HALT		10
 #define LHCALL_GET_WALLCLOCK	11
 #define LHCALL_BIND_DMA		12
@@ -24,6 +24,9 @@
 #define LHCALL_SET_PMD		15
 #define LHCALL_LOAD_TLS		16
 
+#define LG_CLOCK_MIN_DELTA	100UL
+#define LG_CLOCK_MAX_DELTA	ULONG_MAX
+
 #define LGUEST_TRAP_ENTRY 0x1F
 
 static inline unsigned long
_

Patches currently in -mm which might be from jmorris@namei.org are

git-net.patch
git-selinux.patch
implement-file-posix-capabilities.patch
implement-file-posix-capabilities-update.patch
lguest-the-host-code-use-tsc.patch
lguest-the-host-code-use-hrtimers.patch
lguest-the-net-driver.patch
lguest-the-documentation-example-launcher.patch
