From: akpm@linux-foundation.org
Subject: [merged]
 rtc-rtc-mc13xxx-remove-unnecessary-platform_set_drvdata.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:32:06 -0700
Message-ID: <51db13b6.JGcDpOpleC65M3w5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3GHTcJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:32:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-mc13xxx-remove-unnecessary-platform_set_drvdata.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:32:06 -0700


The patch titled
     Subject: rtc: rtc-mc13xxx: remove unnecessary platform_set_drvdata()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-mc13xxx-remove-unnecessary-platform_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-mc13xxx: remove unnecessary platform_set_drvdata()

The driver core clears the driver data to NULL after device_release or on
probe failure, since commit 0998d063100 ("device-core: Ensure drvdata =
NULL when no driver is bound").  Thus, it is not needed to manually clear
the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mc13xxx.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/rtc/rtc-mc13xxx.c~rtc-rtc-mc13xxx-remove-unnecessary-platform_set_drvdata drivers/rtc/rtc-mc13xxx.c
--- a/drivers/rtc/rtc-mc13xxx.c~rtc-rtc-mc13xxx-remove-unnecessary-platform_set_drvdata
+++ a/drivers/rtc/rtc-mc13xxx.c
@@ -370,8 +370,6 @@ err_reset_irq_status:
 err_reset_irq_request:
 
 		mc13xxx_unlock(mc13xxx);
-
-		platform_set_drvdata(pdev, NULL);
 	}
 
 	return ret;
@@ -389,8 +387,6 @@ static int __exit mc13xxx_rtc_remove(str
 
 	mc13xxx_unlock(priv->mc13xxx);
 
-	platform_set_drvdata(pdev, NULL);
