From: akpm@linux-foundation.org
Subject: + rtc-tx4939-drop-irqf_shared.patch added to -mm tree
Date: Tue, 05 May 2009 15:32:38 -0700
Message-ID: <200905052232.n45MWcJG026385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754434AbZEEWe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 18:34:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc-tx4939: drop IRQF_SHARED
has been added to the -mm tree.  Its filename is
     rtc-tx4939-drop-irqf_shared.patch

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
Subject: rtc-tx4939: drop IRQF_SHARED
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

IRQF_SHARED should not be used with IRQF_DISABLED.  This RTC have a
dedicated irq line to SoC's internal interrupt controller so there is
no reason to use IRQF_SHARED.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tx4939.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-tx4939.c~rtc-tx4939-drop-irqf_shared drivers/rtc/rtc-tx4939.c
--- a/drivers/rtc/rtc-tx4939.c~rtc-tx4939-drop-irqf_shared
+++ a/drivers/rtc/rtc-tx4939.c
@@ -261,10 +261,8 @@ static int __init tx4939_rtc_probe(struc
 
 	tx4939_rtc_cmd(pdata->rtcreg, TX4939_RTCCTL_COMMAND_NOP);
 	if (devm_request_irq(&pdev->dev, irq, tx4939_rtc_interrupt,
-			     IRQF_DISABLED | IRQF_SHARED,
-			     pdev->name, &pdev->dev) < 0) {
+			     IRQF_DISABLED, pdev->name, &pdev->dev) < 0)
 		return -EBUSY;
-	}
 	rtc = rtc_device_register(pdev->name, &pdev->dev,
 				  &tx4939_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch
rtc-rtc-ds1742-nvram-attribute-fix.patch
rtc-tx4939-drop-irqf_shared.patch
rtc-ds1553-drop-irqf_shared.patch
rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2.patch

