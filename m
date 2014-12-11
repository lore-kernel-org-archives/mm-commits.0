From: akpm@linux-foundation.org
Subject: [merged] rtc-omap-remove-driver_name-macro.patch removed from -mm tree
Date: Thu, 11 Dec 2014 11:06:33 -0800
Message-ID: <5489eb39.eAcsV+DOd3HTCqZO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45816 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758459AbaLKTGe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:06:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: remove DRIVER_NAME macro
has been removed from the -mm tree.  Its filename was
     rtc-omap-remove-driver_name-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johan Hovold <johan@kernel.org>
Subject: rtc: omap: remove DRIVER_NAME macro

Remove DRIVER_NAME macro which was used for unrelated strings (e.g.
id-table entry and module name), but not for related ones (e.g. module
name and alias).

Also move the module alias to the other module-info entries.

Signed-off-by: Johan Hovold <johan@kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Benot Cousson <bcousson@baylibre.com>
Cc: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Tested-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-remove-driver_name-macro drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-remove-driver_name-macro
+++ a/drivers/rtc/rtc-omap.c
@@ -39,8 +39,6 @@
  * the SoC). See the BOARD-SPECIFIC CUSTOMIZATION comment.
  */
 
-#define	DRIVER_NAME			"omap_rtc"
-
 /* RTC registers */
 #define OMAP_RTC_SECONDS_REG		0x00
 #define OMAP_RTC_MINUTES_REG		0x04
@@ -360,7 +358,7 @@ static struct rtc_class_ops omap_rtc_ops
 
 static const struct platform_device_id omap_rtc_devtype[] = {
 	{
-		.name	= DRIVER_NAME,
+		.name	= "omap_rtc",
 	},
 	[OMAP_RTC_DATA_AM3352_IDX] = {
 		.name	= "am3352-rtc",
@@ -587,12 +585,11 @@ static void omap_rtc_shutdown(struct pla
 	rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, 0);
 }
 
-MODULE_ALIAS("platform:omap_rtc");
 static struct platform_driver omap_rtc_driver = {
 	.remove		= __exit_p(omap_rtc_remove),
 	.shutdown	= omap_rtc_shutdown,
 	.driver		= {
-		.name	= DRIVER_NAME,
+		.name	= "omap_rtc",
 		.owner	= THIS_MODULE,
 		.pm	= &omap_rtc_pm_ops,
 		.of_match_table = omap_rtc_of_match,
@@ -602,5 +599,6 @@ static struct platform_driver omap_rtc_d
 
 module_platform_driver_probe(omap_rtc_driver, omap_rtc_probe);
 
+MODULE_ALIAS("platform:omap_rtc");
 MODULE_AUTHOR("George G. Davis (and others)");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from johan@kernel.org are

origin.patch
linux-next.patch

