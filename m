From: akpm@linux-foundation.org
Subject: [merged] rtc-bfin-do-not-share-rtc-irq.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:59:01 -0700
Message-ID: <200909231959.n8NJx1AB010082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753801AbZIWT7K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:59:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, a.zummo@towertech.it, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     rtc-bfin: do not share RTC IRQ
has been removed from the -mm tree.  Its filename was
     rtc-bfin-do-not-share-rtc-irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -383,7 +383,7 @@ static int __devinit bfin_rtc_probe(stru
 	}
 
 	/* Grab the IRQ and init the hardware */
-	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, IRQF_SHARED, pdev->name, dev);
+	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, 0, pdev->name, dev);
 	if (unlikely(ret))
 		goto err_reg;
 	/* sometimes the bootloader touched things, but the write complete was not
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

origin.patch
linux-next.patch

