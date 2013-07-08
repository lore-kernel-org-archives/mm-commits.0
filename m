From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-m48t35c-use-ptr_ret.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:34:58 -0700
Message-ID: <51db1462.zl5HpWlD6npQBhQ2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51385 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab3GHTe6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:34:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tsbogend@alpha.franken.de, sachin.kamat@linaro.org

Subject: [merged] drivers-rtc-rtc-m48t35c-use-ptr_ret.patch removed from -mm tree
To: sachin.kamat@linaro.org,tsbogend@alpha.franken.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:34:58 -0700


The patch titled
     Subject: drivers/rtc/rtc-m48t35.c: use PTR_RET()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-m48t35c-use-ptr_ret.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-m48t35.c: use PTR_RET()

Use of PTR_RET() simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m48t35.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-m48t35.c~drivers-rtc-rtc-m48t35c-use-ptr_ret drivers/rtc/rtc-m48t35.c
--- a/drivers/rtc/rtc-m48t35.c~drivers-rtc-rtc-m48t35c-use-ptr_ret
+++ a/drivers/rtc/rtc-m48t35.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/bcd.h>
 #include <linux/io.h>
+#include <linux/err.h>
 
 #define DRV_VERSION		"1.0"
 
@@ -174,10 +175,7 @@ static int m48t35_probe(struct platform_
 
 	priv->rtc = devm_rtc_device_register(&pdev->dev, "m48t35",
 				  &m48t35_ops, THIS_MODULE);
-	if (IS_ERR(priv->rtc))
-		return PTR_ERR(priv->rtc);
