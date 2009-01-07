From: akpm@linux-foundation.org
Subject: - rtc-rtc-ds1216-fixes.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:19:23 -0800
Message-ID: <200901072219.n07MJNXM018756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758776AbZAGWUa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:20:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.zummo@towertech.it, david-b@pacbell.net, tsbogend@alpha.franken.de, mm-commits@vger.kernel.org


The patch titled
     rtc: rtc-ds1216 fixes
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1216-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: rtc-ds1216 fixes
From: Alessandro Zummo <a.zummo@towertech.it>

Fixes a few issues with the rtc-ds1216 driver

- use rtc_valid_tm

- use platform_driver_probe

- fix init sequence - it was using rtc_unregister_driver where not
  needed.  I also added resource_size and removed an useless pointer
  assignment.

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Tested-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1216.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff -puN drivers/rtc/rtc-ds1216.c~rtc-rtc-ds1216-fixes drivers/rtc/rtc-ds1216.c
--- a/drivers/rtc/rtc-ds1216.c~rtc-rtc-ds1216-fixes
+++ a/drivers/rtc/rtc-ds1216.c
@@ -10,7 +10,7 @@
 #include <linux/platform_device.h>
 #include <linux/bcd.h>
 
-#define DRV_VERSION "0.1"
+#define DRV_VERSION "0.2"
 
 struct ds1216_regs {
 	u8 tsec;
@@ -101,7 +101,8 @@ static int ds1216_rtc_read_time(struct d
 	tm->tm_year = bcd2bin(regs.year);
 	if (tm->tm_year < 70)
 		tm->tm_year += 100;
-	return 0;
+
+	return rtc_valid_tm(tm);
 }
 
 static int ds1216_rtc_set_time(struct device *dev, struct rtc_time *tm)
@@ -138,9 +139,8 @@ static const struct rtc_class_ops ds1216
 	.set_time	= ds1216_rtc_set_time,
 };
 
-static int __devinit ds1216_rtc_probe(struct platform_device *pdev)
+static int __init ds1216_rtc_probe(struct platform_device *pdev)
 {
-	struct rtc_device *rtc;
 	struct resource *res;
 	struct ds1216_priv *priv;
 	int ret = 0;
@@ -152,7 +152,10 @@ static int __devinit ds1216_rtc_probe(st
 	priv = kzalloc(sizeof *priv, GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
-	priv->size = res->end - res->start + 1;
+
+	platform_set_drvdata(pdev, priv);
+
+	priv->size = resource_size(res);
 	if (!request_mem_region(res->start, priv->size, pdev->name)) {
 		ret = -EBUSY;
 		goto out;
@@ -163,22 +166,18 @@ static int __devinit ds1216_rtc_probe(st
 		ret = -ENOMEM;
 		goto out;
 	}
-	rtc = rtc_device_register("ds1216", &pdev->dev,
+	priv->rtc = rtc_device_register("ds1216", &pdev->dev,
 				  &ds1216_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		ret = PTR_ERR(rtc);
+	if (IS_ERR(priv->rtc)) {
+		ret = PTR_ERR(priv->rtc);
 		goto out;
 	}
-	priv->rtc = rtc;
-	platform_set_drvdata(pdev, priv);
 
 	/* dummy read to get clock into a known state */
 	ds1216_read(priv->ioaddr, dummy);
 	return 0;
 
 out:
-	if (priv->rtc)
-		rtc_device_unregister(priv->rtc);
 	if (priv->ioaddr)
 		iounmap(priv->ioaddr);
 	if (priv->baseaddr)
@@ -187,7 +186,7 @@ out:
 	return ret;
 }
 
-static int __devexit ds1216_rtc_remove(struct platform_device *pdev)
+static int __exit ds1216_rtc_remove(struct platform_device *pdev)
 {
 	struct ds1216_priv *priv = platform_get_drvdata(pdev);
 
@@ -203,13 +202,12 @@ static struct platform_driver ds1216_rtc
 		.name	= "rtc-ds1216",
 		.owner	= THIS_MODULE,
 	},
-	.probe		= ds1216_rtc_probe,
-	.remove		= __devexit_p(ds1216_rtc_remove),
+	.remove		= __exit_p(ds1216_rtc_remove),
 };
 
 static int __init ds1216_rtc_init(void)
 {
-	return platform_driver_register(&ds1216_rtc_platform_driver);
+	return platform_driver_probe(&ds1216_rtc_platform_driver, ds1216_rtc_probe);
 }
 
 static void __exit ds1216_rtc_exit(void)
_

Patches currently in -mm which might be from a.zummo@towertech.it are

origin.patch
linux-next.patch
rtc-ds1307-smbus-compatibility.patch
rtc-ds1307-remove-legacy-probe-checks.patch

