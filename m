From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-twlc-add-dt-support-for-rtc-inside-twl4030-twl6030.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:32:42 -0800
Message-ID: <20120111213243.0BAB85C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:60913 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163Ab2AKVco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:32:44 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so32668eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:32:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: b-cousson@ti.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-twl.c: add DT support for RTC inside twl4030/twl6030
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-twlc-add-dt-support-for-rtc-inside-twl4030-twl6030.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Benoit Cousson <b-cousson@ti.com>
Subject: drivers/rtc/rtc-twl.c: add DT support for RTC inside twl4030/twl6030

Add the DT support for the TI rtc-twl present in the twl4030 and twl6030
devices.

Signed-off-by: Benoit Cousson <b-cousson@ti.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/twl-rtc.txt |   12 ++++++++++++
 drivers/rtc/rtc-twl.c                             |   10 ++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff -puN /dev/null Documentation/devicetree/bindings/rtc/twl-rtc.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/twl-rtc.txt
@@ -0,0 +1,12 @@
+* TI twl RTC
+
+The TWL family (twl4030/6030) contains a RTC.
+
+Required properties:
+- compatible : Should be twl4030-rtc
+
+Examples:
+
+rtc@0 {
+    compatible = "ti,twl4030-rtc";
+};
diff -puN drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-add-dt-support-for-rtc-inside-twl4030-twl6030 drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-add-dt-support-for-rtc-inside-twl4030-twl6030
+++ a/drivers/rtc/rtc-twl.c
@@ -550,6 +550,11 @@ static int twl_rtc_resume(struct platfor
 #define twl_rtc_resume  NULL
 #endif
 
+static const struct of_device_id twl_rtc_of_match[] = {
+	{.compatible = "ti,twl4030-rtc", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, twl_rtc_of_match);
 MODULE_ALIAS("platform:twl_rtc");
 
 static struct platform_driver twl4030rtc_driver = {
@@ -559,8 +564,9 @@ static struct platform_driver twl4030rtc
 	.suspend	= twl_rtc_suspend,
 	.resume		= twl_rtc_resume,
 	.driver		= {
-		.owner	= THIS_MODULE,
-		.name	= "twl_rtc",
+		.owner		= THIS_MODULE,
+		.name		= "twl_rtc",
+		.of_match_table = twl_rtc_of_match,
 	},
 };
 
_

Patches currently in -mm which might be from b-cousson@ti.com are

origin.patch
linux-next.patch

