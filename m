From: akpm@linux-foundation.org
Subject: [merged] rtc-omap-use-module_platform_driver.patch removed from
 -mm tree
Date: Mon, 20 Apr 2015 12:18:21 -0700
Message-ID: <553550fd./Uip/4PVHrm8VoPH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbbDTTMA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lokeshvutla@ti.com, a.zummo@towertech.it, alexandre.belloni@free-electrons.com, nsekhar@ti.com, paul@pwsan.com, t-kristo@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-omap.c: use module_platform_driver
has been removed from the -mm tree.  Its filename was
     rtc-omap-use-module_platform_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: drivers/rtc/rtc-omap.c: use module_platform_driver

module_platform_driver_probe() prevents driver from requesting probe
deferral.  So using module_platform_drive() to support probe deferral.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-use-module_platform_driver drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-use-module_platform_driver
+++ a/drivers/rtc/rtc-omap.c
@@ -521,7 +521,7 @@ static const struct of_device_id omap_rt
 };
 MODULE_DEVICE_TABLE(of, omap_rtc_of_match);
 
-static int __init omap_rtc_probe(struct platform_device *pdev)
+static int omap_rtc_probe(struct platform_device *pdev)
 {
 	struct omap_rtc	*rtc;
 	struct resource	*res;
@@ -756,6 +756,7 @@ static void omap_rtc_shutdown(struct pla
 }
 
 static struct platform_driver omap_rtc_driver = {
+	.probe		= omap_rtc_probe,
 	.remove		= __exit_p(omap_rtc_remove),
 	.shutdown	= omap_rtc_shutdown,
 	.driver		= {
@@ -766,7 +767,7 @@ static struct platform_driver omap_rtc_d
 	.id_table	= omap_rtc_id_table,
 };
 
-module_platform_driver_probe(omap_rtc_driver, omap_rtc_probe);
+module_platform_driver(omap_rtc_driver);
 
 MODULE_ALIAS("platform:omap_rtc");
 MODULE_AUTHOR("George G. Davis (and others)");
_

Patches currently in -mm which might be from lokeshvutla@ti.com are

origin.patch
linux-next.patch

