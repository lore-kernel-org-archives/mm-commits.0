From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pcf8563c-add-device-tree-support.patch added to -mm tree
Date: Wed, 25 Jul 2012 13:59:45 -0700
Message-ID: <20120725205946.1E1365C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:51697 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab2GYU7s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jul 2012 16:59:48 -0400
Received: by eaao12 with SMTP id o12so5501eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jul 2012 13:59:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nbowler@elliptictech.com, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-pcf8563.c: add device tree support
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pcf8563c-add-device-tree-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nick Bowler <nbowler@elliptictech.com>
Subject: drivers/rtc/rtc-pcf8563.c: add device tree support

Set the of_match_table for this driver so that devices can be described
in the device tree.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/rtc/rtc-pcf8563.c~drivers-rtc-rtc-pcf8563c-add-device-tree-support drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~drivers-rtc-rtc-pcf8563c-add-device-tree-support
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -19,6 +19,7 @@
 #include <linux/rtc.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/of.h>
 
 #define DRV_VERSION "0.4.3"
 
@@ -285,10 +286,19 @@ static const struct i2c_device_id pcf856
 };
 MODULE_DEVICE_TABLE(i2c, pcf8563_id);
 
+#ifdef CONFIG_OF
+static const struct of_device_id pcf8563_of_match[] __devinitconst = {
+	{ .compatible = "nxp,pcf8563" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, pcf8563_of_match);
+#endif
+
 static struct i2c_driver pcf8563_driver = {
 	.driver		= {
 		.name	= "rtc-pcf8563",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(pcf8563_of_match),
 	},
 	.probe		= pcf8563_probe,
 	.remove		= pcf8563_remove,
_
Subject: Subject: drivers/rtc/rtc-pcf8563.c: add device tree support

Patches currently in -mm which might be from nbowler@elliptictech.com are

drivers-rtc-rtc-pcf8563c-set-owner-field-in-driver-struct.patch
drivers-rtc-rtc-pcf8563c-add-device-tree-support.patch

