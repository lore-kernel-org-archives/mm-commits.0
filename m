From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-mc13783c-fix-off-by-one-for-checking-num_leds.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:30:40 -0800
Message-ID: <20120111213040.A1A0A1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:42148 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933921Ab2AKVal (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:30:41 -0500
Received: by mail-yx0-f202.google.com with SMTP id m1so7711yen.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:30:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, philippe.retornaz@epfl.ch, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-mc13783.c: fix off-by-one for checking num_leds
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-mc13783c-fix-off-by-one-for-checking-num_leds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: drivers/leds/leds-mc13783.c: fix off-by-one for checking num_leds

The LED id begins from 0.  Thus the maximum number of leds should be
MC13783_LED_MAX + 1.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Philippe Retornaz <philippe.retornaz@epfl.ch>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-mc13783.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-mc13783.c~drivers-leds-leds-mc13783c-fix-off-by-one-for-checking-num_leds drivers/leds/leds-mc13783.c
--- a/drivers/leds/leds-mc13783.c~drivers-leds-leds-mc13783c-fix-off-by-one-for-checking-num_leds
+++ a/drivers/leds/leds-mc13783.c
@@ -275,7 +275,7 @@ static int __devinit mc13783_led_probe(s
 		return -ENODEV;
 	}
 
-	if (pdata->num_leds < 1 || pdata->num_leds > MC13783_LED_MAX) {
+	if (pdata->num_leds < 1 || pdata->num_leds > (MC13783_LED_MAX + 1)) {
 		dev_err(&pdev->dev, "Invalid led count %d\n", pdata->num_leds);
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch

