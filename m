From: akpm@linux-foundation.org
Subject: + rtc-rtc-twl4030-dont-mask-alarm-interrupts-on-shutdown.patch added to -mm tree
Date: Mon, 12 Jan 2009 23:11:42 -0800
Message-ID: <200901130711.n0D7BgJe022918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752493AbZAMHMK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 02:12:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matti.halme@nokia.com, a.zummo@towertech.it, dbrownell@users.sourceforge.net, sameo@openedhand.com, tony@atomide.com


The patch titled
     rtc: rtc-twl4030 don't mask alarm interrupts on shutdown
has been added to the -mm tree.  Its filename is
     rtc-rtc-twl4030-dont-mask-alarm-interrupts-on-shutdown.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: rtc-twl4030 don't mask alarm interrupts on shutdown
From: Matti Halme <matti.halme@nokia.com>

A triggering RTC alarm should be able to power on a device that has been
powered off. This patch enables that on twl4030 by not masking the alarm
interrupt at shutdown.

Signed-off-by: Matti Halme <matti.halme@nokia.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl4030.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-twl4030.c~rtc-rtc-twl4030-dont-mask-alarm-interrupts-on-shutdown drivers/rtc/rtc-twl4030.c
--- a/drivers/rtc/rtc-twl4030.c~rtc-rtc-twl4030-dont-mask-alarm-interrupts-on-shutdown
+++ a/drivers/rtc/rtc-twl4030.c
@@ -482,8 +482,9 @@ static int __devexit twl4030_rtc_remove(
 
 static void twl4030_rtc_shutdown(struct platform_device *pdev)
 {
-	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M |
-			 BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
+	/* mask timer interrupts, but leave alarm interrupts on to enable
+	   power-on when alarm is triggered */
+	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
 }
 
 #ifdef CONFIG_PM
_

Patches currently in -mm which might be from matti.halme@nokia.com are

rtc-rtc-twl4030-dont-mask-alarm-interrupts-on-shutdown.patch

