From: akpm@linux-foundation.org
Subject: - legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:15:22 -0700
Message-ID: <200810182315.m9INFMUh028602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752101AbYJRXPs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:15:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, a.zummo@towertech.it, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     legacy rtc:  remove needless/confusing HPET_RTC_IRQ option
has been removed from the -mm tree.  Its filename was
     legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
