From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-imxdic-add-missing-spin-lock-initialization.patch added to -mm tree
Date: Wed, 24 Oct 2012 13:20:28 -0700
Message-ID: <20121024202029.3D1595C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:45137 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933789Ab2JXUUc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Oct 2012 16:20:32 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so60530eek.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Oct 2012 13:20:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlu@pengutronix.de, a.zummo@towertech.it, grant.likely@secretlab.ca, kernel@pengutronix.de, linux@arm.linux.org.uk, stable@vger.kernel.org, stigge@antcom.de


The patch titled
     Subject: drivers/rtc/rtc-imxdi.c: add missing spin lock initialization
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-imxdic-add-missing-spin-lock-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Luebbe <jlu@pengutronix.de>
Subject: drivers/rtc/rtc-imxdi.c: add missing spin lock initialization

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Roland Stigge <stigge@antcom.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
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

drivers-rtc-rtc-imxdic-add-missing-spin-lock-initialization.patch

