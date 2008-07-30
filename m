From: akpm@linux-foundation.org
Subject: + legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch added to -mm tree
Date: Tue, 29 Jul 2008 17:26:44 -0700
Message-ID: <200807300026.m6U0QjC4030043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918AbYG3A12 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 20:27:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, a.zummo@towertech.it, mingo@elte.hu, tglx@linutronix.de


The patch titled
     legacy rtc:  remove needless/confusing HPET_RTC_IRQ option
has been added to the -mm tree.  Its filename is
     legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch

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
Subject: legacy rtc:  remove needless/confusing HPET_RTC_IRQ option
From: David Brownell <dbrownell@users.sourceforge.net>

HPET_RTC_IRQ is no longer needed; HPET_EMULATE_RTC suffices and is more
correct.  (http://bugzilla.kernel.org/show_bug.cgi?id=11111)

Note that when using the legacy RTC driver, platforms don't really do a
dynamic switch between HPET and non-HPET modes based on whether HPET
hardware actually exists ...  only rtc-cmos (using the new RTC framework)
currently switches that way.

So this reflects bitrot in that legacy code, for x86/ia64: kernels with
HPET support configured (e.g.  for a clocksource) can't get IRQs from the
legacy RTC driver unless they really have HPET hardware.  (The obvious
workaround is to not use the legacy RTC driver on those platforms when you
configure HPET ...  unless you know the target really has a HPET.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    9 ---------
 drivers/char/rtc.c   |    2 +-
 2 files changed, 1 insertion(+), 10 deletions(-)

diff -puN drivers/char/Kconfig~legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option drivers/char/Kconfig
--- a/drivers/char/Kconfig~legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option
+++ a/drivers/char/Kconfig
@@ -1043,15 +1043,6 @@ config HPET
 	  open selects one of the timers supported by the HPET.  The timers are
 	  non-periodic and/or periodic.
 
-config HPET_RTC_IRQ
-	bool
-	default HPET_EMULATE_RTC
-	depends on RTC && HPET
-	help
-	  If you say Y here, you will disable RTC_IRQ in drivers/char/rtc.c. It
-	  is assumed the platform called hpet_alloc with the RTC IRQ values for
-	  the HPET timers.
-
 config HPET_MMAP
 	bool "Allow mmap of HPET"
 	default y
diff -puN drivers/char/rtc.c~legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option drivers/char/rtc.c
--- a/drivers/char/rtc.c~legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option
+++ a/drivers/char/rtc.c
@@ -97,7 +97,7 @@ static unsigned long rtc_port;
 static int rtc_irq = PCI_IRQ_NONE;
 #endif
 
-#ifdef	CONFIG_HPET_RTC_IRQ
+#ifdef	CONFIG_HPET_EMULATE_RTC
 #undef	RTC_IRQ
 #endif
 
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

rtc-dont-return-ebusy-when-mutex_lock_interruptible-fails.patch
linux-next.patch
mtd-dataflash-bugfix-binary-page-sizes-now-handled-v3.patch
mtd-dataflash-otp-support.patch
spi-new-orion_spi-driver.patch
genirq-better-warning-on-irqchip-set_type-failure.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch

