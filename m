From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-pfc2123-add-support-for-devicetree.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:18:52 -0800
Message-ID: <54e250ac.LYtrxaPrxzEoxmfA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbbBPUT2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:19:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stillcompiling@gmail.com, a.zummo@towertech.it, grant.likely@linaro.org, mark.rutland@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pcf2123.c: add support for devicetree
has been removed from the -mm tree.  Its filename was
     rtc-rtc-pfc2123-add-support-for-devicetree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joshua Clayton <stillcompiling@gmail.com>
Subject: drivers/rtc/rtc-pcf2123.c: add support for devicetree

Add compatible string "nxp,rtc-pcf2123"
Document the binding

Signed-off-by: Joshua Clayton <stillcompiling@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/nxp,rtc-2123.txt |   16 ++++++++++
 drivers/rtc/rtc-pcf2123.c                              |   10 ++++++
 2 files changed, 26 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/rtc/nxp,rtc-2123.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/nxp,rtc-2123.txt
@@ -0,0 +1,16 @@
+NXP PCF2123 SPI Real Time Clock
+
+Required properties:
+- compatible: should be: "nxp,rtc-pcf2123"
+- reg: should be the SPI slave chipselect address
+
+Optional properties:
+- spi-cs-high: PCF2123 needs chipselect high
+
+Example:
+
+rtc: nxp,rtc-pcf2123@3 {
+	compatible = "nxp,rtc-pcf2123"
+	reg = <3>
+	spi-cs-high;
+};
diff -puN drivers/rtc/rtc-pcf2123.c~rtc-rtc-pfc2123-add-support-for-devicetree drivers/rtc/rtc-pcf2123.c
--- a/drivers/rtc/rtc-pcf2123.c~rtc-rtc-pfc2123-add-support-for-devicetree
+++ a/drivers/rtc/rtc-pcf2123.c
@@ -38,6 +38,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/of.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/rtc.h>
@@ -340,10 +341,19 @@ static int pcf2123_remove(struct spi_dev
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id pcf2123_dt_ids[] = {
+	{ .compatible = "nxp,rtc-pcf2123", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, pcf2123_dt_ids);
+#endif
+
 static struct spi_driver pcf2123_driver = {
 	.driver	= {
 			.name	= "rtc-pcf2123",
 			.owner	= THIS_MODULE,
+			.of_match_table = of_match_ptr(pcf2123_dt_ids),
 	},
 	.probe	= pcf2123_probe,
 	.remove	= pcf2123_remove,
_

Patches currently in -mm which might be from stillcompiling@gmail.com are

origin.patch

