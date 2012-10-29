From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-imxdic-add-missing-spin-lock-initialization.patch removed from -mm tree
Date: Mon, 29 Oct 2012 12:50:31 -0700
Message-ID: <20121029195032.30D585C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:41474 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2J2Tuf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 15:50:35 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so345058eek.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 12:50:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlu@pengutronix.de, a.zummo@towertech.it, grant.likely@secretlab.ca, kernel@pengutronix.de, linux@arm.linux.org.uk, stable@vger.kernel.org, stigge@antcom.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-imxdi.c: add missing spin lock initialization
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-imxdic-add-missing-spin-lock-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Luebbe <jlu@pengutronix.de>
Subject: drivers/rtc/rtc-imxdi.c: add missing spin lock initialization

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Roland Stigge <stigge@antcom.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Tested-by: Roland Stigge <stigge@antcom.de>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-imxdi.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-imxdi.c~drivers-rtc-rtc-imxdic-add-missing-spin-lock-initialization drivers/rtc/rtc-imxdi.c
--- a/drivers/rtc/rtc-imxdi.c~drivers-rtc-rtc-imxdic-add-missing-spin-lock-initialization
+++ a/drivers/rtc/rtc-imxdi.c
@@ -392,6 +392,8 @@ static int dryice_rtc_probe(struct platf
 	if (imxdi->ioaddr == NULL)
 		return -ENOMEM;
 
+	spin_lock_init(&imxdi->irq_lock);
+
 	imxdi->irq = platform_get_irq(pdev, 0);
 	if (imxdi->irq < 0)
 		return imxdi->irq;
_

Patches currently in -mm which might be from jlu@pengutronix.de are


