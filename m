From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-twlc-fix-rtcx-wakealarm-attribute-isnt-created.patch
 removed from -mm tree
Date: Mon, 05 Aug 2013 12:05:57 -0700
Message-ID: <51fff795.Yc7/T9LAG44b2Uo7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab3HETF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 15:05:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony@atomide.com, khilman@linaro.org, grygorii.strashko@ti.com

Subject: [merged] drivers-rtc-rtc-twlc-fix-rtcx-wakealarm-attribute-isnt-created.patch removed from -mm tree
To: grygorii.strashko@ti.com,khilman@linaro.org,tony@atomide.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 12:05:57 -0700


The patch titled
     Subject: drivers/rtc/rtc-twl.c: fix: rtcX/wakealarm attribute isn't created
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-twlc-fix-rtcx-wakealarm-attribute-isnt-created.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Grygorii Strashko <grygorii.strashko@ti.com>
Subject: drivers/rtc/rtc-twl.c: fix: rtcX/wakealarm attribute isn't created

The device_init_wakeup() should be called before rtc_device_register(). 
Otherwise, sysfs "sys/class/rtc/rtcX/wakealarm" attribute will not be seen
from User space.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-fix-rtcx-wakealarm-attribute-isnt-created drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-fix-rtcx-wakealarm-attribute-isnt-created
+++ a/drivers/rtc/rtc-twl.c
@@ -524,6 +524,8 @@ static int twl_rtc_probe(struct platform
 	if (ret < 0)
 		goto out1;
 
+	device_init_wakeup(&pdev->dev, 1);
+
 	rtc = rtc_device_register(pdev->name,
 				  &pdev->dev, &twl_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
@@ -542,7 +544,6 @@ static int twl_rtc_probe(struct platform
 	}
 
 	platform_set_drvdata(pdev, rtc);
-	device_init_wakeup(&pdev->dev, 1);
 	return 0;
 
 out2:
_

Patches currently in -mm which might be from grygorii.strashko@ti.com are

linux-next.patch

