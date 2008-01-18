From: akpm@linux-foundation.org
Subject: + add-hpet-rtc-emulation-to-rtc_drv_cmos.patch added to -mm tree
Date: Fri, 18 Jan 2008 14:41:43 -0800
Message-ID: <200801182241.m0IMfhtU009058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761915AbYARWmy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jan 2008 17:42:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, Robert.Picco@hp.com, a.zummo@towertech.it, ak@suse.de, david-b@pacbell.net, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     rtc: add HPET RTC emulation to RTC_DRV_CMOS
has been added to the -mm tree.  Its filename is
     add-hpet-rtc-emulation-to-rtc_drv_cmos.patch

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
Subject: rtc: add HPET RTC emulation to RTC_DRV_CMOS
From: Bernhard Walle <bwalle@suse.de>

That patch adds the RTC emulation of the HPET timer to the new RTC_DRV_CMOS. 
The old drivers/char/rtc.ko driver had that functionality and it's important
on new systems.

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

 arch/x86/Kconfig       |    2 
 drivers/rtc/rtc-cmos.c |   79 ++++++++++++++++++++++++++++++++-------
 2 files changed, 67 insertions(+), 14 deletions(-)

diff -puN arch/x86/Kconfig~add-hpet-rtc-emulation-to-rtc_drv_cmos arch/x86/Kconfig
--- a/arch/x86/Kconfig~add-hpet-rtc-emulation-to-rtc_drv_cmos
+++ a/arch/x86/Kconfig
@@ -417,7 +417,7 @@ config HPET_TIMER
 
 config HPET_EMULATE_RTC
 	def_bool y
-	depends on HPET_TIMER && (RTC=y || RTC=m)
+	depends on HPET_TIMER && (RTC=y || RTC=m || RTC_DRV_CMOS=m || RTC_DRV_CMOS=y)
 
 # Mark as embedded because too many people got it wrong.
 # The code disables itself when not needed.
diff -puN drivers/rtc/rtc-cmos.c~add-hpet-rtc-emulation-to-rtc_drv_cmos drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~add-hpet-rtc-emulation-to-rtc_drv_cmos
+++ a/drivers/rtc/rtc-cmos.c
@@ -35,10 +35,22 @@
 #include <linux/spinlock.h>
 #include <linux/platform_device.h>
 #include <linux/mod_devicetable.h>
+#include <asm/hpet.h>
 
 /* this is for "generic access to PC-style RTC" using CMOS_READ/CMOS_WRITE */
 #include <asm-generic/rtc.h>
 
+#ifndef CONFIG_HPET_EMULATE_RTC
+#define is_hpet_enabled()			0
+#define hpet_set_alarm_time(hrs, min, sec) 	do { } while (0)
+#define hpet_set_periodic_freq(arg) 		0
+#define hpet_mask_rtc_irq_bit(arg) 		do { } while (0)
+#define hpet_set_rtc_irq_bit(arg) 		do { } while (0)
+#define hpet_rtc_timer_init() 			do { } while (0)
+#define hpet_register_irq_handler(h) 		0
+#define hpet_unregister_irq_handler(h)		do { } while (0)
+extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
+#endif
 
 struct cmos_rtc {
 	struct rtc_device	*rtc;
@@ -199,6 +211,7 @@ static int cmos_set_alarm(struct device 
 	sec = t->time.tm_sec;
 	sec = (sec < 60) ? BIN2BCD(sec) : 0xff;
 
+	hpet_set_alarm_time(t->time.tm_hour, t->time.tm_min, t->time.tm_sec);
 	spin_lock_irq(&rtc_lock);
 
 	/* next rtc irq must not be from previous alarm setting */
@@ -252,7 +265,8 @@ static int cmos_irq_set_freq(struct devi
 	f = 16 - f;
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	CMOS_WRITE(RTC_REF_CLCK_32KHZ | f, RTC_FREQ_SELECT);
+	if (!hpet_set_periodic_freq(freq))
+		CMOS_WRITE(RTC_REF_CLCK_32KHZ | f, RTC_FREQ_SELECT);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	return 0;
@@ -314,28 +328,37 @@ cmos_rtc_ioctl(struct device *dev, unsig
 	switch (cmd) {
 	case RTC_AIE_OFF:	/* alarm off */
 		rtc_control &= ~RTC_AIE;
+		hpet_mask_rtc_irq_bit(RTC_AIE);
 		break;
 	case RTC_AIE_ON:	/* alarm on */
 		rtc_control |= RTC_AIE;
+		hpet_set_rtc_irq_bit(RTC_AIE);
 		break;
 	case RTC_UIE_OFF:	/* update off */
 		rtc_control &= ~RTC_UIE;
+		hpet_mask_rtc_irq_bit(RTC_UIE);
 		break;
 	case RTC_UIE_ON:	/* update on */
 		rtc_control |= RTC_UIE;
+		hpet_set_rtc_irq_bit(RTC_UIE);
 		break;
 	case RTC_PIE_OFF:	/* periodic off */
 		rtc_control &= ~RTC_PIE;
+		hpet_mask_rtc_irq_bit(RTC_PIE);
 		break;
 	case RTC_PIE_ON:	/* periodic on */
 		rtc_control |= RTC_PIE;
+		hpet_set_rtc_irq_bit(RTC_PIE);
 		break;
 	}
-	CMOS_WRITE(rtc_control, RTC_CONTROL);
+	if (!is_hpet_enabled())
+		CMOS_WRITE(rtc_control, RTC_CONTROL);
+
 	rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
 	rtc_intr &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
 	if (is_intr(rtc_intr))
 		rtc_update_irq(cmos->rtc, 1, rtc_intr);
+
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return 0;
 }
@@ -475,15 +498,25 @@ static irqreturn_t cmos_interrupt(int ir
 	u8		rtc_control;
 
 	spin_lock(&rtc_lock);
-	irqstat = CMOS_READ(RTC_INTR_FLAGS);
-	rtc_control = CMOS_READ(RTC_CONTROL);
-	irqstat &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
+	/*
+	 * In this case it is HPET RTC interrupt handler
+	 * calling us, with the interrupt information
+	 * passed as arg1, instead of irq.
+	 */
+	if (is_hpet_enabled())
+		irqstat = (unsigned long)irq & 0xF0;
+	else {
+		irqstat = CMOS_READ(RTC_INTR_FLAGS);
+		rtc_control = CMOS_READ(RTC_CONTROL);
+		irqstat &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
+	}
 
 	/* All Linux RTC alarms should be treated as if they were oneshot.
 	 * Similar code may be needed in system wakeup paths, in case the
 	 * alarm woke the system.
 	 */
 	if (irqstat & RTC_AIE) {
+		rtc_control = CMOS_READ(RTC_CONTROL);
 		rtc_control &= ~RTC_AIE;
 		CMOS_WRITE(rtc_control, RTC_CONTROL);
 		CMOS_READ(RTC_INTR_FLAGS);
@@ -591,8 +624,9 @@ cmos_do_probe(struct device *dev, struct
 	 * doesn't use 32KHz here ... for portability we might need to
 	 * do something about other clock frequencies.
 	 */
-	CMOS_WRITE(RTC_REF_CLCK_32KHZ | 0x06, RTC_FREQ_SELECT);
 	cmos_rtc.rtc->irq_freq = 1024;
+	if (!hpet_set_periodic_freq(cmos_rtc.rtc->irq_freq))
+		CMOS_WRITE(RTC_REF_CLCK_32KHZ | 0x06, RTC_FREQ_SELECT);
 
 	/* disable irqs.
 	 *
@@ -615,14 +649,31 @@ cmos_do_probe(struct device *dev, struct
 		goto cleanup1;
 	}
 
-	if (is_valid_irq(rtc_irq))
-		retval = request_irq(rtc_irq, cmos_interrupt, IRQF_DISABLED,
-				cmos_rtc.rtc->dev.bus_id,
+	if (is_valid_irq(rtc_irq)) {
+		irq_handler_t rtc_cmos_int_handler;
+
+		if (is_hpet_enabled()) {
+			int err;
+
+			rtc_cmos_int_handler = hpet_rtc_interrupt;
+			err = hpet_register_irq_handler(cmos_interrupt);
+			if (err != 0) {
+				printk(KERN_WARNING "hpet_register_irq_handler "
+						" failed in rtc_init().");
+				goto cleanup1;
+			}
+		} else
+			rtc_cmos_int_handler = cmos_interrupt;
+
+		retval = request_irq(rtc_irq, rtc_cmos_int_handler,
+				IRQF_DISABLED, cmos_rtc.rtc->dev.bus_id,
 				cmos_rtc.rtc);
-	if (retval < 0) {
-		dev_dbg(dev, "IRQ %d is already in use\n", rtc_irq);
-		goto cleanup1;
+		if (retval < 0) {
+			dev_dbg(dev, "IRQ %d is already in use\n", rtc_irq);
+			goto cleanup1;
+		}
 	}
+	hpet_rtc_timer_init();
 
 	/* export at least the first block of NVRAM */
 	nvram.size = address_space - NVRAM_OFFSET;
@@ -677,8 +728,10 @@ static void __exit cmos_do_remove(struct
 
 	sysfs_remove_bin_file(&dev->kobj, &nvram);
 
-	if (is_valid_irq(cmos->irq))
+	if (is_valid_irq(cmos->irq)) {
 		free_irq(cmos->irq, cmos->rtc);
+		hpet_unregister_irq_handler(cmos_interrupt);
+	}
 
 	rtc_device_unregister(cmos->rtc);
 	cmos->rtc = NULL;
_

Patches currently in -mm which might be from bwalle@suse.de are

git-x86.patch
make-config_hpet_emulate_rtc-usable-from-modules.patch
use-the-irq-callback-interface-in-old-rtc-driver.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
introduce-flags-for-reserve_bootmem.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
use-bootmem_exclusive-for-kdump.patch
