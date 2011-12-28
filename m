From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-twlc-add-dt-support-for-rtc-inside-twl4030-twl6030.patch added to -mm tree
Date: Tue, 27 Dec 2011 16:03:42 -0800
Message-ID: <20111228000343.1F8CF20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:63332 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab1L1ADp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Dec 2011 19:03:45 -0500
Received: by eekc1 with SMTP id c1so403941eek.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Dec 2011 16:03:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: b-cousson@ti.com, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-twl.c: add DT support for RTC inside twl4030/twl6030
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-twlc-add-dt-support-for-rtc-inside-twl4030-twl6030.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/rtc/rtc-twl.c: add DT support for RTC inside twl4030/twl6030

Patches currently in -mm which might be from b-cousson@ti.com are

linux-next.patch
drivers-rtc-rtc-twlc-add-dt-support-for-rtc-inside-twl4030-twl6030.patch

