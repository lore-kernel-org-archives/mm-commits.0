From: akpm@linux-foundation.org
Subject: + geode-mfgpt-clock-event-device-support.patch added to -mm tree
Date: Thu, 05 Jul 2007 15:26:30 -0700
Message-ID: <200707052226.l65MQUPn022102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59805 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763171AbXGEW1y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 18:27:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, ak@suse.de, alan@lxorguk.ukuu.org.uk, dilinger@debian.org, johnstul@us.ibm.com, jordan.crouse@amd.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     GEODE: MFGPT clock event device support
has been added to the -mm tree.  Its filename is
     geode-mfgpt-clock-event-device-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: GEODE: MFGPT clock event device support
From: Andres Salomon <dilinger@queued.net>

Add support for an MFGPT clock event device; this allows us to use MFGPTs as
the basis for high-resolution timers.

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig        |   10 ++
 arch/i386/kernel/mfgpt.c |  158 +++++++++++++++++++++++++++++++++++++
 2 files changed, 168 insertions(+)

diff -puN arch/i386/Kconfig~geode-mfgpt-clock-event-device-support arch/i386/Kconfig
--- a/arch/i386/Kconfig~geode-mfgpt-clock-event-device-support
+++ a/arch/i386/Kconfig
@@ -1209,6 +1209,16 @@ config SCx200HR_TIMER
 	  processor goes idle (as is done by the scheduler).  The
 	  other workaround is idle=poll boot option.
 
+config GEODE_MFGPT_TIMER
+	bool "Geode Multi-Function General Purpose Timer (MFGPT) events"
+	depends on MGEODE_LX && GENERIC_TIME && GENERIC_CLOCKEVENTS
+	default y
+	help
+	  This driver provides a clock event source based on the MFGPT
+	  timer(s) in the CS5535 and CS5536 companion chip for the geode.
+	  MFGPTs have a better resolution and max interval than the
+	  generic PIT, and are suitable for use as high-res timers.
+
 config K8_NB
 	def_bool y
 	depends on AGP_AMD64
diff -puN arch/i386/kernel/mfgpt.c~geode-mfgpt-clock-event-device-support arch/i386/kernel/mfgpt.c
--- a/arch/i386/kernel/mfgpt.c~geode-mfgpt-clock-event-device-support
+++ a/arch/i386/kernel/mfgpt.c
@@ -48,6 +48,12 @@ static struct mfgpt_timer_t {
 #define MFGPT_HZ  (32000 / MFGPT_DIVISOR)
 #define MFGPT_PERIODIC (MFGPT_HZ / HZ)
 
+#ifdef CONFIG_GEODE_MFGPT_TIMER
+static int __init mfgpt_timer_setup(void);
+#else
+#define mfgpt_timer_setup() (0)
+#endif
+
 /* Allow for disabling of MFGPTs */
 static int disable = 0;
 static int __init mfgpt_disable(char *s)
@@ -82,6 +88,9 @@ int __init geode_mfgpt_detect(void)
 		}
 	}
 
+	/* set up clock event device, if desired */
+	i = mfgpt_timer_setup();
+
 	return count;
 }
 
@@ -198,3 +207,152 @@ int geode_mfgpt_alloc_timer(int timer, i
 	return -1;
 }
 EXPORT_SYMBOL(geode_mfgpt_alloc_timer);
+
+#ifdef CONFIG_GEODE_MFGPT_TIMER
+
+/*
+ * The MFPGT timers on the CS5536 provide us with suitable timers to use
+ * as clock event sources - not as good as a HPET or APIC, but certainly
+ * better then the PIT.  This isn't a general purpose MFGPT driver, but
+ * a simplified one designed specifically to act as a clock event source.
+ * For full details about the MFGPT, please consult the CS5536 data sheet.
+ */
+
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+
+static unsigned int mfgpt_tick_mode = CLOCK_EVT_MODE_SHUTDOWN;
+static u16 mfgpt_event_clock;
+
+static int irq = 7;
+static int __init mfgpt_setup(char *str)
+{
+	get_option(&str, &irq);
+	return 1;
+}
+__setup("mfgpt_irq=", mfgpt_setup);
+
+static inline void mfgpt_disable_timer(u16 clock)
+{
+	u16 val = geode_mfgpt_read(clock, MFGPT_REG_SETUP);
+	geode_mfgpt_write(clock, MFGPT_REG_SETUP, val & ~MFGPT_SETUP_CNTEN);
+}
+
+static int mfgpt_next_event(unsigned long, struct clock_event_device *);
+static void mfgpt_set_mode(enum clock_event_mode, struct clock_event_device *);
+
+static struct clock_event_device mfgpt_clockevent = {
+	.name = "mfgpt-timer",
+	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_mode = mfgpt_set_mode,
+	.set_next_event = mfgpt_next_event,
+	.rating = 250,
+	.cpumask = CPU_MASK_ALL,
+	.shift = 32
+};
+
+static inline void mfgpt_start_timer(u16 clock, u16 delta)
+{
+	geode_mfgpt_write(mfgpt_event_clock, MFGPT_REG_CMP2, (u16) delta);
+	geode_mfgpt_write(mfgpt_event_clock, MFGPT_REG_COUNTER, 0);
+
+	geode_mfgpt_write(mfgpt_event_clock, MFGPT_REG_SETUP,
+			  MFGPT_SETUP_CNTEN | MFGPT_SETUP_CMP2);
+}
+
+static void mfgpt_set_mode(enum clock_event_mode mode,
+			   struct clock_event_device *evt)
+{
+	mfgpt_disable_timer(mfgpt_event_clock);
+
+	if (mode == CLOCK_EVT_MODE_PERIODIC)
+		mfgpt_start_timer(mfgpt_event_clock, MFGPT_PERIODIC);
+
+	mfgpt_tick_mode = mode;
+}
+
+static int mfgpt_next_event(unsigned long delta, struct clock_event_device *evt)
+{
+	mfgpt_start_timer(mfgpt_event_clock, delta);
+	return 0;
+}
+
+/* Assume (foolishly?), that this interrupt was due to our tick */
+
+static irqreturn_t mfgpt_tick(int irq, void *dev_id)
+{
+	if (mfgpt_tick_mode == CLOCK_EVT_MODE_SHUTDOWN)
+		return IRQ_HANDLED;
+
+	/* Turn off the clock */
+	mfgpt_disable_timer(mfgpt_event_clock);
+
+	/* Clear the counter */
+	geode_mfgpt_write(mfgpt_event_clock, MFGPT_REG_COUNTER, 0);
+
+	/* Restart the clock in periodic mode */
+
+	if (mfgpt_tick_mode == CLOCK_EVT_MODE_PERIODIC) {
+		geode_mfgpt_write(mfgpt_event_clock, MFGPT_REG_SETUP,
+				  MFGPT_SETUP_CNTEN | MFGPT_SETUP_CMP2);
+	}
+
+	mfgpt_clockevent.event_handler(&mfgpt_clockevent);
+	return IRQ_HANDLED;
+}
+
+static struct irqaction mfgptirq  = {
+	.handler = mfgpt_tick,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING,
+	.mask = CPU_MASK_NONE,
+	.name = "mfgpt-timer"
+};
+
+static int __init mfgpt_timer_setup(void)
+{
+	int timer, ret;
+	u16 val;
+
+	timer = geode_mfgpt_alloc_timer(MFGPT_TIMER_ANY, MFGPT_DOMAIN_WORKING, THIS_MODULE);
+	if (timer < 0) {
+		printk(KERN_ERR "mfgpt-timer:  Could not allocate a MFPGT timer\n");
+		return -ENODEV;
+	}
+
+	mfgpt_event_clock = timer;
+	/* Set the clock scale and enable the event mode for CMP2 */
+	val = MFGPT_SCALE | (3 << 8);
+
+	geode_mfgpt_write(mfgpt_event_clock, MFGPT_REG_SETUP, val);
+
+	/* Set up the IRQ on the MFGPT side */
+	if (geode_mfgpt_setup_irq(mfgpt_event_clock, MFGPT_CMP2, irq)) {
+		printk(KERN_ERR "mfgpt-timer:  Could not set up IRQ %d\n", irq);
+		return -EIO;
+	}
+
+	/* And register it with the kernel */
+	ret = setup_irq(irq, &mfgptirq);
+
+	if (ret) {
+		printk(KERN_ERR "mfgpt-timer:  Unable to set up the interrupt.\n");
+		goto err;
+	}
+
+	/* Set up the clock event */
+	mfgpt_clockevent.mult = div_sc(MFGPT_HZ, NSEC_PER_SEC, 32);
+	mfgpt_clockevent.min_delta_ns = clockevent_delta2ns(0xF, &mfgpt_clockevent);
+	mfgpt_clockevent.max_delta_ns = clockevent_delta2ns(0xFFFE, &mfgpt_clockevent);
+
+	printk("mfgpt-timer:  registering the MFGT timer as a clock event.\n");
+	clockevents_register_device(&mfgpt_clockevent);
+
+	return 0;
+
+err:
+	geode_mfgpt_release_irq(mfgpt_event_clock, MFGPT_CMP2, irq);
+	printk(KERN_ERR "mfgpt-timer:  Unable to set up the MFGPT clock source\n");
+	return -EIO;
+}
+
+#endif
_

Patches currently in -mm which might be from dilinger@queued.net are

geode-basic-infrastructure-support-for-amd-geode-class.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
