From: akpm@linux-foundation.org
Subject: + rtc-bfin-do-not-share-rtc-irq.patch added to -mm tree
Date: Fri, 26 Jun 2009 16:01:51 -0700
Message-ID: <200906262301.n5QN1pru022217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754294AbZFZXB4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 19:01:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, a.zummo@towertech.it, vapier@gentoo.org


The patch titled
     rtc-bfin: do not share RTC IRQ
has been added to the -mm tree.  Its filename is
     rtc-bfin-do-not-share-rtc-irq.patch

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
Subject: rtc-bfin: do not share RTC IRQ
From: Michael Hennerich <michael.hennerich@analog.com>

The Blackfin RTC IRQ is an internal interrupt, so it makes no sense to
have it be shared.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-bfin.c~rtc-bfin-do-not-share-rtc-irq drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~rtc-bfin-do-not-share-rtc-irq
+++ a/drivers/rtc/rtc-bfin.c
@@ -375,7 +375,7 @@ static int __devinit bfin_rtc_probe(stru
 	device_init_wakeup(dev, 1);
 
 	/* Grab the IRQ and init the hardware */
-	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, IRQF_SHARED, pdev->name, dev);
+	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, 0, pdev->name, dev);
 	if (unlikely(ret))
 		goto err;
 	/* sometimes the bootloader touched things, but the write complete was not
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

rtc-bfin-do-not-share-rtc-irq.patch

