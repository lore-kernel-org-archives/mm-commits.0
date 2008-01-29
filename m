From: akpm@linux-foundation.org
Subject: - make-config_hpet_emulate_rtc-usable-from-modules.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:50:33 -0800
Message-ID: <200801290150.m0T1oY8B027577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36415 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756421AbYA2CAP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 21:00:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, Robert.Picco@hp.com, a.zummo@towertech.it, ak@suse.de, david-b@pacbell.net, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     rtc: make CONFIG_HPET_EMULATE_RTC usable from modules
has been removed from the -mm tree.  Its filename was
     make-config_hpet_emulate_rtc-usable-from-modules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: make CONFIG_HPET_EMULATE_RTC usable from modules
From: Bernhard Walle <bwalle@suse.de>

The new rtc-cmos driver misses HPET support.  If the hardware has HPET
enabled, then interrupts don't work for the rtc-cmos driver which results in
RTC_AIE*, RTC_PIE* and RTC_ALM being unusable.  This affects hwclock from
util-linux-ng at least on i386 since that uses RTC_PIE_ON.  (For x86-64, a
polling method is used for unknown reasons.)

This patch series now

  1. export the functions from arch/x86/kernel/hpet.c that the old char/rtc
     driver uses to work around that problem,

  2. makes it possible to compile the old rtc driver as module, while still
     having CONFIG_HPET_EMULATE_RTC enabled and

  3. makes use of the exported functions in (1) in the new rtc-cmos driver.


This patch:

This patch makes the RTC emulation functions in arch/x86/kernel/hpet.c usable
for kernel modules. It

  - exports the functions (EXPORT_SYMBOL_GPL()),
  - adds an interface to register the interrupt callback function
    instead of using only a fixed callback function and
  - replaces the rtc_get_rtc_time() function which depends on
    CONFIG_RTC with a call to get_rtc_time() which is defined in
    include/asm-generic/rtc.h.

The only dependency to CONFIG_RTC is the call to rtc_interrupt() which is
removed by the next patch. After this, there's no (code) dependency of
this functions to CONFIG_RTC=y any more.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Robert Picco <Robert.Picco@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/hpet.c |   47 ++++++++++++++++++++++++++++++++++++++-
 include/asm-x86/hpet.h |    3 ++
 2 files changed, 49 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/hpet.c~make-config_hpet_emulate_rtc-usable-from-modules arch/x86/kernel/hpet.c
--- a/arch/x86/kernel/hpet.c~make-config_hpet_emulate_rtc-usable-from-modules
+++ a/arch/x86/kernel/hpet.c
@@ -107,6 +107,7 @@ int is_hpet_enabled(void)
 {
 	return is_hpet_capable() && hpet_legacy_int_enabled;
 }
+EXPORT_SYMBOL_GPL(is_hpet_enabled);
 
 /*
  * When the hpet driver (/dev/hpet) is enabled, we need to reserve
@@ -478,6 +479,7 @@ void hpet_disable(void)
  */
 #include <linux/mc146818rtc.h>
 #include <linux/rtc.h>
+#include <asm/rtc.h>
 
 #define DEFAULT_RTC_INT_FREQ	64
 #define DEFAULT_RTC_SHIFT	6
@@ -492,6 +494,38 @@ static unsigned long hpet_default_delta;
 static unsigned long hpet_pie_delta;
 static unsigned long hpet_pie_limit;
 
+static rtc_irq_handler irq_handler;
+
+/*
+ * Registers a IRQ handler.
+ */
+int hpet_register_irq_handler(rtc_irq_handler handler)
+{
+	if (!is_hpet_enabled())
+		return -ENODEV;
+	if (irq_handler)
+		return -EBUSY;
+
+	irq_handler = handler;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hpet_register_irq_handler);
+
+/*
+ * Deregisters the IRQ handler registered with hpet_register_irq_handler()
+ * and does cleanup.
+ */
+void hpet_unregister_irq_handler(rtc_irq_handler handler)
+{
+	if (!is_hpet_enabled())
+		return;
+
+	irq_handler = NULL;
+	hpet_rtc_flags = 0;
+}
+EXPORT_SYMBOL_GPL(hpet_unregister_irq_handler);
+
 /*
  * Timer 1 for RTC emulation. We use one shot mode, as periodic mode
  * is not supported by all HPET implementations for timer 1.
@@ -533,6 +567,7 @@ int hpet_rtc_timer_init(void)
 
 	return 1;
 }
+EXPORT_SYMBOL_GPL(hpet_rtc_timer_init);
 
 /*
  * The functions below are called from rtc driver.
@@ -547,6 +582,7 @@ int hpet_mask_rtc_irq_bit(unsigned long 
 	hpet_rtc_flags &= ~bit_mask;
 	return 1;
 }
+EXPORT_SYMBOL_GPL(hpet_mask_rtc_irq_bit);
 
 int hpet_set_rtc_irq_bit(unsigned long bit_mask)
 {
@@ -562,6 +598,7 @@ int hpet_set_rtc_irq_bit(unsigned long b
 
 	return 1;
 }
+EXPORT_SYMBOL_GPL(hpet_set_rtc_irq_bit);
 
 int hpet_set_alarm_time(unsigned char hrs, unsigned char min,
 			unsigned char sec)
@@ -575,6 +612,7 @@ int hpet_set_alarm_time(unsigned char hr
 
 	return 1;
 }
+EXPORT_SYMBOL_GPL(hpet_set_alarm_time);
 
 int hpet_set_periodic_freq(unsigned long freq)
 {
@@ -593,11 +631,13 @@ int hpet_set_periodic_freq(unsigned long
 	}
 	return 1;
 }
+EXPORT_SYMBOL_GPL(hpet_set_periodic_freq);
 
 int hpet_rtc_dropped_irq(void)
 {
 	return is_hpet_enabled();
 }
+EXPORT_SYMBOL_GPL(hpet_rtc_dropped_irq);
 
 static void hpet_rtc_timer_reinit(void)
 {
@@ -641,9 +681,10 @@ irqreturn_t hpet_rtc_interrupt(int irq, 
 	unsigned long rtc_int_flag = 0;
 
 	hpet_rtc_timer_reinit();
+	memset(&curr_time, 0, sizeof(struct rtc_time));
 
 	if (hpet_rtc_flags & (RTC_UIE | RTC_AIE))
-		rtc_get_rtc_time(&curr_time);
+		get_rtc_time(&curr_time);
 
 	if (hpet_rtc_flags & RTC_UIE &&
 	    curr_time.tm_sec != hpet_prev_update_sec) {
@@ -665,8 +706,12 @@ irqreturn_t hpet_rtc_interrupt(int irq, 
 
 	if (rtc_int_flag) {
 		rtc_int_flag |= (RTC_IRQF | (RTC_NUM_INTS << 8));
+		if (irq_handler)
+			irq_handler(rtc_int_flag, dev_id);
+
 		rtc_interrupt(rtc_int_flag, dev_id);
 	}
 	return IRQ_HANDLED;
 }
+EXPORT_SYMBOL_GPL(hpet_rtc_interrupt);
 #endif
diff -puN include/asm-x86/hpet.h~make-config_hpet_emulate_rtc-usable-from-modules include/asm-x86/hpet.h
--- a/include/asm-x86/hpet.h~make-config_hpet_emulate_rtc-usable-from-modules
+++ a/include/asm-x86/hpet.h
@@ -69,6 +69,7 @@ extern void force_hpet_resume(void);
 
 #include <linux/interrupt.h>
 
+typedef irqreturn_t (*rtc_irq_handler)(int interrupt, void *cookie);
 extern int hpet_mask_rtc_irq_bit(unsigned long bit_mask);
 extern int hpet_set_rtc_irq_bit(unsigned long bit_mask);
 extern int hpet_set_alarm_time(unsigned char hrs, unsigned char min,
@@ -77,6 +78,8 @@ extern int hpet_set_periodic_freq(unsign
 extern int hpet_rtc_dropped_irq(void);
 extern int hpet_rtc_timer_init(void);
 extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
+extern int hpet_register_irq_handler(rtc_irq_handler handler);
+extern void hpet_unregister_irq_handler(rtc_irq_handler handler);
 
 #endif /* CONFIG_HPET_EMULATE_RTC */
 
_

Patches currently in -mm which might be from bwalle@suse.de are

git-x86.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
introduce-flags-for-reserve_bootmem.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
use-bootmem_exclusive-for-kdump.patch
