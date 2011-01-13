From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-max6902-set-driver-data-in-max6902_probe.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:07:26 -0800
Message-ID: <201101132010.p0DKA7DH030031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933710Ab1AMUNM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:13:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     rtc: rtc-max6902 - set driver data in max6902_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-max6902-set-driver-data-in-max6902_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: rtc-max6902 - set driver data in max6902_probe()
From: Axel Lin <axel.lin@gmail.com>

Current implementation does not set driver data in max6902_probe(), thus
calling platform_get_drvdata(spi) in max6902_remove() returns NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max6902.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-max6902.c~rtc-rtc-max6902-set-driver-data-in-max6902_probe drivers/rtc/rtc-max6902.c
--- a/drivers/rtc/rtc-max6902.c~rtc-rtc-max6902-set-driver-data-in-max6902_probe
+++ a/drivers/rtc/rtc-max6902.c
@@ -139,12 +139,13 @@ static int __devinit max6902_probe(struc
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
+	dev_set_drvdata(&spi->dev, rtc);
 	return 0;
 }
 
 static int __devexit max6902_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = platform_get_drvdata(spi);
+	struct rtc_device *rtc = dev_get_drvdata(&spi->dev);
 
 	rtc_device_unregister(rtc);
 	return 0;
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch

