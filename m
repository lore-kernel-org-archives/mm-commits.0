From: akpm@linux-foundation.org
Subject: [merged] rtc-parisc-rename-p-pointer-to-rtc.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:05 -0700
Message-ID: <200904011842.n31Ig56x009578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932637AbZDASrk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:47:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dannf@hp.com, a.zummo@towertech.it, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     rtc-parisc: rename p pointer to rtc
has been removed from the -mm tree.  Its filename was
     rtc-parisc-rename-p-pointer-to-rtc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-parisc: rename p pointer to rtc
From: dann frazier <dannf@hp.com>

Signed-off-by: dann frazier <dannf@hp.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-parisc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-parisc.c~rtc-parisc-rename-p-pointer-to-rtc drivers/rtc/rtc-parisc.c
--- a/drivers/rtc/rtc-parisc.c~rtc-parisc-rename-p-pointer-to-rtc
+++ a/drivers/rtc/rtc-parisc.c
@@ -38,23 +38,23 @@ static const struct rtc_class_ops parisc
 
 static int __init parisc_rtc_probe(struct platform_device *dev)
 {
-	struct rtc_device *p;
+	struct rtc_device *rtc;
 
-	p = rtc_device_register("rtc-parisc", &dev->dev, &parisc_rtc_ops,
-				THIS_MODULE);
-	if (IS_ERR(p))
-		return PTR_ERR(p);
+	rtc = rtc_device_register("rtc-parisc", &dev->dev, &parisc_rtc_ops,
+				  THIS_MODULE);
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
 
-	platform_set_drvdata(dev, p);
+	platform_set_drvdata(dev, rtc);
 
 	return 0;
 }
 
 static int __exit parisc_rtc_remove(struct platform_device *dev)
 {
-	struct rtc_device *p = platform_get_drvdata(dev);
+	struct rtc_device *rtc = platform_get_drvdata(dev);
 
-	rtc_device_unregister(p);
+	rtc_device_unregister(rtc);
 
 	return 0;
 }
_

Patches currently in -mm which might be from dannf@hp.com are

origin.patch
rtc-parisc-use-rtc_valid_tm-in-parisc_get_time.patch
ipmi-add-oem-message-handling.patch

