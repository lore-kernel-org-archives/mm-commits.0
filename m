From: akpm@linux-foundation.org
Subject: [merged] rtc-parisc-use-platform_driver_probe.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:41:57 -0700
Message-ID: <200904011841.n31Ifv9S009520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934197AbZDATod (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:44:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dannf@hp.com, a.zummo@towertech.it, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     rtc-parisc: use platform_driver_probe
has been removed from the -mm tree.  Its filename was
     rtc-parisc-use-platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-parisc: use platform_driver_probe
From: dann frazier <dannf@hp.com>

This isn't a hotpluggable device, so call platform_driver_probe
directly in parisc_rtc_init

Signed-off-by: dann frazier <dannf@hp.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-parisc.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-parisc.c~rtc-parisc-use-platform_driver_probe drivers/rtc/rtc-parisc.c
--- a/drivers/rtc/rtc-parisc.c~rtc-parisc-use-platform_driver_probe
+++ a/drivers/rtc/rtc-parisc.c
@@ -40,19 +40,14 @@ static const struct rtc_class_ops parisc
 	.set_time = parisc_set_time,
 };
 
-static int __devinit parisc_rtc_probe(struct platform_device *dev)
+static int __init parisc_rtc_probe(struct platform_device *dev)
 {
 	struct rtc_device *p;
 
-	p = kzalloc(sizeof (*p), GFP_KERNEL);
-	if (!p)
-		return -ENOMEM;
-
 	p = rtc_device_register("rtc-parisc", &dev->dev, &parisc_rtc_ops,
 				THIS_MODULE);
 	if (IS_ERR(p)) {
 		int err = PTR_ERR(p);
-		kfree(p);
 		return err;
 	}
 
@@ -61,12 +56,11 @@ static int __devinit parisc_rtc_probe(st
 	return 0;
 }
 
-static int __devexit parisc_rtc_remove(struct platform_device *dev)
+static int __exit parisc_rtc_remove(struct platform_device *dev)
 {
 	struct rtc_device *p = platform_get_drvdata(dev);
 
 	rtc_device_unregister(p);
-	kfree(p);
 
 	return 0;
 }
@@ -82,7 +76,7 @@ static struct platform_driver parisc_rtc
 
 static int __init parisc_rtc_init(void)
 {
-	return platform_driver_register(&parisc_rtc_driver);
+	return platform_driver_probe(&parisc_rtc_driver, parisc_rtc_probe);
 }
 
 static void __exit parisc_rtc_fini(void)
_

Patches currently in -mm which might be from dannf@hp.com are

origin.patch
rtc-parisc-use-rtc_valid_tm-in-parisc_get_time.patch
ipmi-add-oem-message-handling.patch

