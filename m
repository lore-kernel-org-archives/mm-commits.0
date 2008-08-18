From: akpm@linux-foundation.org
Subject: + blackfin-rtc-driver-do-all-initialization-before-we-register-the-rtc-and-make-it-available.patch added to -mm tree
Date: Mon, 18 Aug 2008 14:57:10 -0700
Message-ID: <200808182157.m7ILvAVw014950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752742AbYHRV5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 17:57:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, a.zummo@towertech.it, cooloney@kernel.org


The patch titled
     Blackfin RTC Driver: do all initialization before we register the rtc and make it available
has been added to the -mm tree.  Its filename is
     blackfin-rtc-driver-do-all-initialization-before-we-register-the-rtc-and-make-it-available.patch

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
Subject: Blackfin RTC Driver: do all initialization before we register the rtc and make it available
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-do-all-initialization-before-we-register-the-rtc-and-make-it-available drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-do-all-initialization-before-we-register-the-rtc-and-make-it-available
+++ a/drivers/rtc/rtc-bfin.c
@@ -371,6 +371,7 @@ static int __devinit bfin_rtc_probe(stru
 	if (unlikely(!rtc))
 		return -ENOMEM;
 	platform_set_drvdata(pdev, rtc);
+	device_init_wakeup(dev, 1);
 
 	/* Grab the IRQ and init the hardware */
 	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, IRQF_SHARED, pdev->name, dev);
@@ -386,8 +387,6 @@ static int __devinit bfin_rtc_probe(stru
 		goto err_irq;
 	}
 
-	device_init_wakeup(dev, 1);
