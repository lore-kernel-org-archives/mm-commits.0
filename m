From: akpm@linux-foundation.org
Subject: + rtc-remove-and-clarify-unneeded-externs.patch added to -mm tree
Date: Thu, 08 May 2008 12:47:13 -0700
Message-ID: <200805081947.m48JlDLI002523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702AbYEHTs0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 15:48:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crmafra@ift.unesp.br, mingo@elte.hu, tglx@linutronix.de


The patch titled
     rtc: remove and clarify unneeded externs
has been added to the -mm tree.  Its filename is
     rtc-remove-and-clarify-unneeded-externs.patch

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
@@ -119,8 +119,6 @@ static irqreturn_t hpet_rtc_interrupt(in
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

rtc-remove-and-clarify-unneeded-externs.patch

