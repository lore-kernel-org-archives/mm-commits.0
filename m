From: akpm@linux-foundation.org
Subject: + rtc-ds1307-add-device-tree-support.patch added to -mm tree
Date: Mon, 24 Nov 2014 22:42:53 -0800
Message-ID: <547424ed.S60KI7QToLIqNdR9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbaKYGmb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Nov 2014 01:42:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomas@novotny.cz, a.zummo@towertech.it, grant.likely@linaro.org, robh+dt@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: ds1307: add device tree support
has been added to the -mm tree.  Its filename is
     rtc-ds1307-add-device-tree-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-ds1307-add-device-tree-support.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/rtc-ds1307-add-device-tree-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tomas Novotny <tomas@novotny.cz>
Subject: rtc: ds1307: add device tree support

Note that alarm interrupt and trickle charger are not handled (I have no
hardware with these features).

Only the "common" compatible string for that driver (maxim,ds1307) is
documented, so checkpatch complains for the rest.  If it is better to
document every compatible, I will post a new series with documentation
files pointing to the maxim,ds1307.txt.

Signed-off-by: Tomas Novotny <tomas@novotny.cz>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-add-device-tree-support drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-add-device-tree-support
+++ a/drivers/rtc/rtc-ds1307.c
@@ -18,6 +18,7 @@
 #include <linux/string.h>
 #include <linux/rtc.h>
 #include <linux/bcd.h>
+#include <linux/of.h>
 #include <linux/rtc/ds1307.h>
 
 /*
@@ -1242,10 +1243,31 @@ static int ds1307_remove(struct i2c_clie
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id ds1307_driver_dt_ids[] = {
+	/* driver_data are passed through ds1307_id */
+	{ .compatible = "maxim,ds1307" },
+	{ .compatible = "maxim,ds1337" },
+	{ .compatible = "maxim,ds1338" },
+	{ .compatible = "maxim,ds1339" },
+	{ .compatible = "maxim,ds1388" },
+	{ .compatible = "maxim,ds1340" },
+	{ .compatible = "maxim,ds3231" },
+	{ .compatible = "st,m41t00" },
+	{ .compatible = "microchip,mcp7940x" },
+	{ .compatible = "microchip,mcp7941x" },
+	{ .compatible = "pericom,pt7c4338" },
+	{ .compatible = "epson,rx8025" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ds1307_driver_dt_ids);
+#endif
+
 static struct i2c_driver ds1307_driver = {
 	.driver = {
 		.name	= "rtc-ds1307",
 		.owner	= THIS_MODULE,
+		.of_match_table	= of_match_ptr(ds1307_driver_dt_ids),
 	},
 	.probe		= ds1307_probe,
 	.remove		= ds1307_remove,
_

Patches currently in -mm which might be from tomas@novotny.cz are

rtc-ds1307-add-support-for-mcp7940x-chips.patch
of-add-vendor-prefix-for-pericom-technology.patch
rtc-ds1307-add-device-tree-bindings-documentation.patch
rtc-ds1307-add-device-tree-support.patch

