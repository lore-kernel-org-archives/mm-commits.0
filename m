From: akpm@linux-foundation.org
Subject: + rtc-rtc-pfc2123-add-support-for-devicetree.patch added to -mm
 tree
Date: Fri, 02 Jan 2015 14:24:27 -0800
Message-ID: <54a71a9b.MX4ncWeOhLhz12cD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbbABWY2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jan 2015 17:24:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stillcompiling@gmail.com, a.zummo@towertech.it, grant.likely@linaro.org, mark.rutland@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pcf2123.c: add support for devicetree
has been added to the -mm tree.  Its filename is
     rtc-rtc-pfc2123-add-support-for-devicetree.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-pfc2123-add-support-for-devicetree.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-pfc2123-add-support-for-devicetree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rtc-rtc-pfc2123-add-support-for-devicetree.patch

