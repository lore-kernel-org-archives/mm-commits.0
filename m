From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-tile-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:58:04 -0700
Message-ID: <20130430185804.6F0985A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:57186 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933437Ab3D3S6F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:05 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so87006qen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:58:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-tile: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-tile-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-tile: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tile.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-tile.c~rtc-rtc-tile-use-devm_rtc_device_register drivers/rtc/rtc-tile.c
--- a/drivers/rtc/rtc-tile.c~rtc-rtc-tile-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-tile.c
@@ -80,8 +80,8 @@ static int tile_rtc_probe(struct platfor
 {
 	struct rtc_device *rtc;
 
-	rtc = rtc_device_register("tile",
-				  &dev->dev, &tile_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&dev->dev, "tile",
+				&tile_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -96,11 +96,6 @@ static int tile_rtc_probe(struct platfor
  */
 static int tile_rtc_remove(struct platform_device *dev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(dev);
-
-	if (rtc)
-		rtc_device_unregister(rtc);
