From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-rc5t583-use-platform_getset_drvdata.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:33:40 -0700
Message-ID: <51db1414.rIiKDu7hCoquUNrH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab3GHTdk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:33:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-rc5t583-use-platform_getset_drvdata.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:33:40 -0700


The patch titled
     Subject: rtc: rtc-rc5t583: use platform_{get,set}_drvdata()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-rc5t583-use-platform_getset_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-rc5t583: use platform_{get,set}_drvdata()

Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rc5t583.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-rc5t583.c~rtc-rtc-rc5t583-use-platform_getset_drvdata drivers/rtc/rtc-rc5t583.c
--- a/drivers/rtc/rtc-rc5t583.c~rtc-rtc-rc5t583-use-platform_getset_drvdata
+++ a/drivers/rtc/rtc-rc5t583.c
@@ -273,7 +273,7 @@ static int rc5t583_rtc_probe(struct plat
  */
 static int rc5t583_rtc_remove(struct platform_device *pdev)
 {
-	struct rc5t583_rtc *rc5t583_rtc = dev_get_drvdata(&pdev->dev);
+	struct rc5t583_rtc *rc5t583_rtc = platform_get_drvdata(pdev);
 
 	rc5t583_rtc_alarm_irq_enable(&rc5t583_rtc->rtc->dev, 0);
 	return 0;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

