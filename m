From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-tps65910c-rename-irq-to-match-device.patch added to -mm tree
Date: Tue, 20 Nov 2012 12:27:27 -0800
Message-ID: <20121120202727.A2A4D100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:57714 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab2KTU12 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Nov 2012 15:27:28 -0500
Received: by mail-gg0-f202.google.com with SMTP id i4so728663ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Nov 2012 12:27:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sivaramn@nvidia.com, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-tps65910.c: rename irq to match device
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-tps65910c-rename-irq-to-match-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sivaram Nair <sivaramn@nvidia.com>
Subject: drivers/rtc/rtc-tps65910.c: rename irq to match device

A cosmetic change to rename the irq name to match the device name.

Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps65910.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-rename-irq-to-match-device drivers/rtc/rtc-tps65910.c
--- a/drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-rename-irq-to-match-device
+++ a/drivers/rtc/rtc-tps65910.c
@@ -261,7 +261,7 @@ static int __devinit tps65910_rtc_probe(
 
 	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 		tps65910_rtc_interrupt, IRQF_TRIGGER_LOW,
-		"rtc-tps65910", &pdev->dev);
+		dev_name(&pdev->dev), &pdev->dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "IRQ is not free.\n");
 		return ret;
_

Patches currently in -mm which might be from sivaramn@nvidia.com are

drivers-rtc-rtc-tps65910c-rename-irq-to-match-device.patch

