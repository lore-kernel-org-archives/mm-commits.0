From: akpm@linux-foundation.org
Subject: + rtc-ds1553-drop-irqf_shared.patch added to -mm tree
Date: Tue, 05 May 2009 15:32:41 -0700
Message-ID: <200905052232.n45MWf4d026390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754690AbZEEWfD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 18:35:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc-ds1553: drop IRQF_SHARED
has been added to the -mm tree.  Its filename is
     rtc-ds1553-drop-irqf_shared.patch

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
Subject: rtc-ds1553: drop IRQF_SHARED
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

IRQF_SHARED should not be used with IRQF_DISABLED.  There is no in-tree
user of this driver and only out-of-tree user I know uses a dedicated irq
line for this RTC.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1553.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ds1553.c~rtc-ds1553-drop-irqf_shared drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~rtc-ds1553-drop-irqf_shared
+++ a/drivers/rtc/rtc-ds1553.c
@@ -329,8 +329,7 @@ static int __devinit ds1553_rtc_probe(st
 	if (pdata->irq > 0) {
 		writeb(0, ioaddr + RTC_INTERRUPTS);
 		if (request_irq(pdata->irq, ds1553_rtc_interrupt,
-				IRQF_DISABLED | IRQF_SHARED,
-				pdev->name, pdev) < 0) {
+				IRQF_DISABLED, pdev->name, pdev) < 0) {
 			dev_warn(&pdev->dev, "interrupt not available.\n");
 			pdata->irq = 0;
 		}
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch
rtc-rtc-ds1742-nvram-attribute-fix.patch
rtc-tx4939-drop-irqf_shared.patch
rtc-ds1553-drop-irqf_shared.patch
rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2.patch

