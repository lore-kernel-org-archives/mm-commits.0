From: akpm@linux-foundation.org
Subject: - rtc-remove-and-clarify-unneeded-externs.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:30:18 -0700
Message-ID: <200807242330.m6ONUITB011489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756060AbYGXXb1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crmafra@ift.unesp.br, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     rtc: remove and clarify unneeded externs
has been removed from the -mm tree.  Its filename was
     rtc-remove-and-clarify-unneeded-externs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: remove and clarify unneeded externs
From: Carlos R. Mafra <crmafra@ift.unesp.br>

When CONFIG_HPET_EMULATE_RTC is defined the external declaration of
hpet_rtc_interrupt is redundant due to the inclusion of hpet.h.

When !CONFIG_HPET_EMULATE_RTC we make it clear that hpet_rtc_interrupt is
not used by defining it to return zero.

Signed-off-by: Carlos R. Mafra <crmafra@ift.unesp.br>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c     |    2 --
 drivers/rtc/rtc-cmos.c |    5 ++++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/char/rtc.c~rtc-remove-and-clarify-unneeded-externs drivers/char/rtc.c
--- a/drivers/char/rtc.c~rtc-remove-and-clarify-unneeded-externs
+++ a/drivers/char/rtc.c
@@ -121,8 +121,6 @@ static irqreturn_t hpet_rtc_interrupt(in
 	return 0;
 }
 #endif
-#else
-extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
 #endif
 
 /*
diff -puN drivers/rtc/rtc-cmos.c~rtc-remove-and-clarify-unneeded-externs drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-remove-and-clarify-unneeded-externs
+++ a/drivers/rtc/rtc-cmos.c
@@ -52,7 +52,10 @@
 #define hpet_rtc_timer_init() 			do { } while (0)
 #define hpet_register_irq_handler(h) 		0
 #define hpet_unregister_irq_handler(h)		do { } while (0)
-extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
+static irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
+{
+	return 0;
+}
 #endif
 
 struct cmos_rtc {
_

Patches currently in -mm which might be from crmafra@ift.unesp.br are

origin.patch

