From: akpm@linux-foundation.org
Subject: + rtc-cmosc-build-fix.patch added to -mm tree
Date: Wed, 07 May 2008 14:31:21 -0700
Message-ID: <200805072131.m47LVLkd017429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186AbYEGVcg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 17:32:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crmafra2@gmail.com, crmafra@ift.unesp.br, mingo@elte.hu


The patch titled
     rtc-cmos.c: build fix
has been added to the -mm tree.  Its filename is
     rtc-cmosc-build-fix.patch

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
Subject: rtc-cmos.c: build fix
From: "Carlos R. Mafra" <crmafra2@gmail.com>

The function hpet_rtc_interrupt(..) is to be used only if
CONFIG_HPET_EMULATE_RTC is defined (see arch/x86/kernel/hpet.c), so we define
it to return 0 when !CONFIG_HPET_EMULATE_RTC to avoid build failures.

This function will never be used anyways when !CONFIG_HPET_EMULATE_RTC because
it is inside a if(is_hpet_enabled()) which is never true when
!CONFIG_HPET_EMULATE_RTC.

Signed-off-by: Carlos R. Mafra <crmafra@ift.unesp.br>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c     |    2 --
 drivers/rtc/rtc-cmos.c |    5 ++++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/char/rtc.c~rtc-cmosc-build-fix drivers/char/rtc.c
--- a/drivers/char/rtc.c~rtc-cmosc-build-fix
+++ a/drivers/char/rtc.c
@@ -119,8 +119,6 @@ static irqreturn_t hpet_rtc_interrupt(in
 	return 0;
 }
 #endif
-#else
-extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
 #endif
 
 /*
diff -puN drivers/rtc/rtc-cmos.c~rtc-cmosc-build-fix drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cmosc-build-fix
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

Patches currently in -mm which might be from crmafra2@gmail.com are

rtc-cmosc-build-fix.patch

