From: akpm@linux-foundation.org
Subject: + geode-mfgpt-check-irq-before-using-mfgpt-as-clocksource.patch added to -mm tree
Date: Wed, 13 Aug 2008 16:33:25 -0700
Message-ID: <200808132333.m7DNXPWs012188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462AbYHMXfP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 19:35:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JRottmann@LiPPERTEmbedded.de, dilinger@debian.org, johnstul@us.ibm.com, jordan.crouse@amd.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     geode-mfgpt: check IRQ before using MFGPT as clocksource
has been added to the -mm tree.  Its filename is
     geode-mfgpt-check-irq-before-using-mfgpt-as-clocksource.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: geode-mfgpt: check IRQ before using MFGPT as clocksource
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>

Add a simple IRQ autodetection to the AMD Geode MFGPT driver, and more
importantly, add some checks, if IRQs can actually be received on the
chosen line.  This fixes cases where MFGPT is selected as clocksource
though not producing any ticks, so the kernel simply starves during boot.

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: Andres Salomon <dilinger@debian.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/mfgpt_32.c |   52 ++++++++++++++++++++++++-----------
 include/asm-x86/geode.h    |    3 +-
 2 files changed, 39 insertions(+), 16 deletions(-)

diff -puN arch/x86/kernel/mfgpt_32.c~geode-mfgpt-check-irq-before-using-mfgpt-as-clocksource arch/x86/kernel/mfgpt_32.c
--- a/arch/x86/kernel/mfgpt_32.c~geode-mfgpt-check-irq-before-using-mfgpt-as-clocksource
+++ a/arch/x86/kernel/mfgpt_32.c
@@ -33,6 +33,8 @@
 #include <linux/module.h>
 #include <asm/geode.h>
 
+#define MFGPT_DEFAULT_IRQ	7
+
 static struct mfgpt_timer_t {
 	unsigned int avail:1;
 } mfgpt_timers[MFGPT_MAX_TIMERS];
@@ -157,29 +159,48 @@ int geode_mfgpt_toggle_event(int timer, 
 }
 EXPORT_SYMBOL_GPL(geode_mfgpt_toggle_event);
 
-int geode_mfgpt_set_irq(int timer, int cmp, int irq, int enable)
+int geode_mfgpt_set_irq(int timer, int cmp, int *irq, int enable)
 {
-	u32 val, dummy;
-	int offset;
+	u32 zsel, lpc, dummy;
+	int shift;
 
 	if (timer < 0 || timer >= MFGPT_MAX_TIMERS)
 		return -EIO;
 
-	if (geode_mfgpt_toggle_event(timer, cmp, MFGPT_EVENT_IRQ, enable))
+	/*
+	 * Unfortunately, MFGPTs come in pairs sharing their IRQ lines. If VSA
+	 * is using the same CMP of the timer's Siamese twin, the IRQ is set to
+	 * 2, and we mustn't use nor change it.
+	 * XXX: Likewise, 2 Linux drivers might clash if the 2nd overwrites the
+	 * IRQ of the 1st. This can only happen if forcing an IRQ, calling this
+	 * with *irq==0 is safe. Currently there _are_ no 2 drivers.
+	 */
+	rdmsr(MSR_PIC_ZSEL_LOW, zsel, dummy);
+	shift = ((cmp == MFGPT_CMP1 ? 0 : 4) + timer % 4) * 4;
+	if (((zsel >> shift) & 0xF) == 2)
 		return -EIO;
 
-	rdmsr(MSR_PIC_ZSEL_LOW, val, dummy);
+	/* Choose IRQ: if none supplied, keep IRQ already set or use default */
+	if (!*irq)
+		*irq = (zsel >> shift) & 0xF;
+	if (!*irq)
+		*irq = MFGPT_DEFAULT_IRQ;
 
-	offset = (timer % 4) * 4;
-
-	val &= ~((0xF << offset) | (0xF << (offset + 16)));
+	/* Can't use IRQ if it's 0 (=disabled), 2, or routed to LPC */
+	if (*irq < 1 || *irq == 2 || *irq > 15)
+		return -EIO;
+	rdmsr(MSR_PIC_IRQM_LPC, lpc, dummy);
+	if (lpc & (1 << *irq))
+		return -EIO;
 
+	/* All chosen and checked - go for it */
+	if (geode_mfgpt_toggle_event(timer, cmp, MFGPT_EVENT_IRQ, enable))
+		return -EIO;
 	if (enable) {
-		val |= (irq & 0x0F) << (offset);
-		val |= (irq & 0x0F) << (offset + 16);
+		zsel = (zsel & ~(0xF << shift)) | (*irq << shift);
+		wrmsr(MSR_PIC_ZSEL_LOW, zsel, dummy);
 	}
 
-	wrmsr(MSR_PIC_ZSEL_LOW, val, dummy);
 	return 0;
 }
 
@@ -242,7 +263,7 @@ EXPORT_SYMBOL_GPL(geode_mfgpt_alloc_time
 static unsigned int mfgpt_tick_mode = CLOCK_EVT_MODE_SHUTDOWN;
 static u16 mfgpt_event_clock;
 
-static int irq = 7;
+static int irq;
 static int __init mfgpt_setup(char *str)
 {
 	get_option(&str, &irq);
@@ -346,7 +367,7 @@ int __init mfgpt_timer_setup(void)
 	mfgpt_event_clock = timer;
 
 	/* Set up the IRQ on the MFGPT side */
-	if (geode_mfgpt_setup_irq(mfgpt_event_clock, MFGPT_CMP2, irq)) {
+	if (geode_mfgpt_setup_irq(mfgpt_event_clock, MFGPT_CMP2, &irq)) {
 		printk(KERN_ERR "mfgpt-timer:  Could not set up IRQ %d\n", irq);
 		return -EIO;
 	}
@@ -374,13 +395,14 @@ int __init mfgpt_timer_setup(void)
 			&mfgpt_clockevent);
 
 	printk(KERN_INFO
-	       "mfgpt-timer:  registering the MFGPT timer as a clock event.\n");
+	       "mfgpt-timer:  Registering MFGPT timer %d as a clock event, using IRQ %d\n",
+	       timer, irq);
 	clockevents_register_device(&mfgpt_clockevent);
 
 	return 0;
 
 err:
-	geode_mfgpt_release_irq(mfgpt_event_clock, MFGPT_CMP2, irq);
+	geode_mfgpt_release_irq(mfgpt_event_clock, MFGPT_CMP2, &irq);
 	printk(KERN_ERR
 	       "mfgpt-timer:  Unable to set up the MFGPT clock source\n");
 	return -EIO;
diff -puN include/asm-x86/geode.h~geode-mfgpt-check-irq-before-using-mfgpt-as-clocksource include/asm-x86/geode.h
--- a/include/asm-x86/geode.h~geode-mfgpt-check-irq-before-using-mfgpt-as-clocksource
+++ a/include/asm-x86/geode.h
@@ -50,6 +50,7 @@ extern int geode_get_dev_base(unsigned i
 #define MSR_PIC_YSEL_HIGH	0x51400021
 #define MSR_PIC_ZSEL_LOW	0x51400022
 #define MSR_PIC_ZSEL_HIGH	0x51400023
+#define MSR_PIC_IRQM_LPC	0x51400025
 
 #define MSR_MFGPT_IRQ		0x51400028
 #define MSR_MFGPT_NR		0x51400029
@@ -237,7 +238,7 @@ static inline u16 geode_mfgpt_read(int t
 }
 
 extern int geode_mfgpt_toggle_event(int timer, int cmp, int event, int enable);
-extern int geode_mfgpt_set_irq(int timer, int cmp, int irq, int enable);
+extern int geode_mfgpt_set_irq(int timer, int cmp, int *irq, int enable);
 extern int geode_mfgpt_alloc_timer(int timer, int domain);
 
 #define geode_mfgpt_setup_irq(t, c, i) geode_mfgpt_set_irq((t), (c), (i), 1)
_

Patches currently in -mm which might be from JRottmann@LiPPERTEmbedded.de are

geode-mfgpt-check-irq-before-using-mfgpt-as-clocksource.patch

