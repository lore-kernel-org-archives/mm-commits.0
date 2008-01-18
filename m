From: akpm@linux-foundation.org
Subject: + use-the-irq-callback-interface-in-old-rtc-driver.patch added to -mm tree
Date: Fri, 18 Jan 2008 14:41:41 -0800
Message-ID: <200801182241.m0IMfg5r009053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46310 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761578AbYARWmY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jan 2008 17:42:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, Robert.Picco@hp.com, a.zummo@towertech.it, ak@suse.de, david-b@pacbell.net, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     rtc: use the IRQ callback interface in (old) RTC driver
has been added to the -mm tree.  Its filename is
     use-the-irq-callback-interface-in-old-rtc-driver.patch

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
Subject: rtc: use the IRQ callback interface in (old) RTC driver
From: Bernhard Walle <bwalle@suse.de>

That function uses the new registration callback mechanism which was added in
the previous patch in the old RTC driver.  It also removes the direct
rtc_interrupt() call from arch/x86/kernel/hpetc.c so that there's finally no
(code) dependency to CONFIG_RTC in arch/x86/kernel/hpet.c.

Because of this, it's possible to compile the drivers/char/rtc.ko driver as
module and still use the HPET emulation functionality.  This is also expressed
in Kconfig.

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

 arch/x86/Kconfig       |    2 +-
 arch/x86/kernel/hpet.c |    2 --
 drivers/char/rtc.c     |   15 ++++++++++++++-
 3 files changed, 15 insertions(+), 4 deletions(-)

diff -puN arch/x86/Kconfig~use-the-irq-callback-interface-in-old-rtc-driver arch/x86/Kconfig
--- a/arch/x86/Kconfig~use-the-irq-callback-interface-in-old-rtc-driver
+++ a/arch/x86/Kconfig
@@ -417,7 +417,7 @@ config HPET_TIMER
 
 config HPET_EMULATE_RTC
 	def_bool y
-	depends on HPET_TIMER && RTC=y
+	depends on HPET_TIMER && (RTC=y || RTC=m)
 
 # Mark as embedded because too many people got it wrong.
 # The code disables itself when not needed.
diff -puN arch/x86/kernel/hpet.c~use-the-irq-callback-interface-in-old-rtc-driver arch/x86/kernel/hpet.c
--- a/arch/x86/kernel/hpet.c~use-the-irq-callback-interface-in-old-rtc-driver
+++ a/arch/x86/kernel/hpet.c
@@ -708,8 +708,6 @@ irqreturn_t hpet_rtc_interrupt(int irq, 
 		rtc_int_flag |= (RTC_IRQF | (RTC_NUM_INTS << 8));
 		if (irq_handler)
 			irq_handler(rtc_int_flag, dev_id);
-
-		rtc_interrupt(rtc_int_flag, dev_id);
 	}
 	return IRQ_HANDLED;
 }
diff -puN drivers/char/rtc.c~use-the-irq-callback-interface-in-old-rtc-driver drivers/char/rtc.c
--- a/drivers/char/rtc.c~use-the-irq-callback-interface-in-old-rtc-driver
+++ a/drivers/char/rtc.c
@@ -110,6 +110,8 @@ static int rtc_has_irq = 1;
 #define hpet_set_rtc_irq_bit(arg)		0
 #define hpet_rtc_timer_init()			do { } while (0)
 #define hpet_rtc_dropped_irq()			0
+#define hpet_register_irq_handler(h)		0
+#define hpet_unregister_irq_handler(h)		0
 #ifdef RTC_IRQ
 static irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
 {
@@ -1027,7 +1029,15 @@ no_irq:
 
 #ifdef RTC_IRQ
 	if (is_hpet_enabled()) {
+		int err;
+
 		rtc_int_handler_ptr = hpet_rtc_interrupt;
+		err = hpet_register_irq_handler(rtc_interrupt);
+		if (err != 0) {
+			printk(KERN_WARNING "hpet_register_irq_handler failed "
+					"in rtc_init().");
+			return err;
+		}
 	} else {
 		rtc_int_handler_ptr = rtc_interrupt;
 	}
@@ -1050,6 +1060,7 @@ no_irq:
 	if (misc_register(&rtc_dev)) {
 #ifdef RTC_IRQ
 		free_irq(RTC_IRQ, NULL);
+		hpet_unregister_irq_handler(rtc_interrupt);
 		rtc_has_irq = 0;
 #endif
 		rtc_release_region();
@@ -1141,8 +1152,10 @@ static void __exit rtc_exit(void)
 #else
 	rtc_release_region();
 #ifdef RTC_IRQ
-	if (rtc_has_irq)
+	if (rtc_has_irq) {
 		free_irq(RTC_IRQ, NULL);
+		hpet_unregister_irq_handler(hpet_rtc_interrupt);
+	}
 #endif
 #endif /* CONFIG_SPARC32 */
 }
_

Patches currently in -mm which might be from bwalle@suse.de are

git-x86.patch
make-config_hpet_emulate_rtc-usable-from-modules.patch
use-the-irq-callback-interface-in-old-rtc-driver.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
introduce-flags-for-reserve_bootmem.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
use-bootmem_exclusive-for-kdump.patch
