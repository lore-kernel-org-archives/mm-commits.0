From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-88pm80x-remove-unneed-devm_kfree.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:19:21 -0700
Message-ID: <20120801201922.124E320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:42197 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab2HAUTY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:19:24 -0400
Received: by eekd4 with SMTP id d4so347939eek.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:19:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: devendra.aaru@gmail.com, a.zummo@towertech.it, ashish.jangam@kpitcummins.com, dchen@diasemi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc/rtc-88pm80x: remove unneed devm_kfree
has been removed from the -mm tree.  Its filename was
     rtc-rtc-88pm80x-remove-unneed-devm_kfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Devendra Naga <devendra.aaru@gmail.com>
Subject: rtc/rtc-88pm80x: remove unneed devm_kfree

devm_kzalloc() doesn't need a matching devm_kfree(), the freeing mechanism
will trigger when driver unloads.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-88pm80x.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/rtc/rtc-88pm80x.c~rtc-rtc-88pm80x-remove-unneed-devm_kfree drivers/rtc/rtc-88pm80x.c
--- a/drivers/rtc/rtc-88pm80x.c~rtc-rtc-88pm80x-remove-unneed-devm_kfree
+++ a/drivers/rtc/rtc-88pm80x.c
@@ -339,7 +339,6 @@ static int __devinit pm80x_rtc_probe(str
 out_rtc:
 	pm80x_free_irq(chip, info->irq, info);
 out:
-	devm_kfree(&pdev->dev, info);
 	return ret;
 }
 
@@ -349,7 +348,6 @@ static int __devexit pm80x_rtc_remove(st
 	platform_set_drvdata(pdev, NULL);
 	rtc_device_unregister(info->rtc_dev);
 	pm80x_free_irq(info->chip, info->irq, info);
-	devm_kfree(&pdev->dev, info);
 	return 0;
 }
 
_

Patches currently in -mm which might be from devendra.aaru@gmail.com are

origin.patch
linux-next.patch

