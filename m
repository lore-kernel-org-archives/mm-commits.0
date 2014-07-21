From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-isl12022c-device-tree-support.patch added to
 -mm tree
Date: Mon, 21 Jul 2014 16:23:56 -0700
Message-ID: <53cda10c.pLi6FrDsaZZ7O6vR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:55387 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaGUXX5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Jul 2014 19:23:57 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so1763048pdj.2
        for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2014 16:23:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stuartl@vrt.com.au, roman.fietze@telemotive.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-isl12022.c: device tree support
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-isl12022c-device-tree-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-isl12022c-device-tree-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-isl12022c-device-tree-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stuart Longland <stuartl@vrt.com.au>
Subject: drivers/rtc/rtc-isl12022.c: device tree support

Add support for configuring the ISL12022 real-time clock via the Device
tree framework.  This is based on what I've seen in the related ISL12057
driver, it has been tested and works on a Technologic Systems TS-7670
device which uses a ISL12020 RTC device, my device tree looks like this:

	apbx@80040000 {
		i2c0: i2c@80058000 {
			pinctrl-names = "default";
			pinctrl-0 = <&i2c0_pins_a>;
			clock-frequency = <400000>;
			status = "okay";

			isl12022@0x6f {
				compatible = "isl,isl12022";
				reg = <0x6f>;
			};
		};
		... etc
	};

Signed-off-by: Stuart Longland <stuartl@vrt.com.au>
Cc: Roman Fietze <roman.fietze@telemotive.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl12022.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN drivers/rtc/rtc-isl12022.c~drivers-rtc-rtc-isl12022c-device-tree-support drivers/rtc/rtc-isl12022.c
--- a/drivers/rtc/rtc-isl12022.c~drivers-rtc-rtc-isl12022c-device-tree-support
+++ a/drivers/rtc/rtc-isl12022.c
@@ -17,6 +17,8 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/err.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 #define DRV_VERSION "0.1"
 
@@ -271,6 +273,13 @@ static int isl12022_probe(struct i2c_cli
 	return PTR_ERR_OR_ZERO(isl12022->rtc);
 }
 
+#ifdef CONFIG_OF
+static struct of_device_id isl12022_dt_match[] = {
+	{ .compatible = "isl,isl12022" },
+	{ },
+};
+#endif
+
 static const struct i2c_device_id isl12022_id[] = {
 	{ "isl12022", 0 },
 	{ }
@@ -280,6 +289,9 @@ MODULE_DEVICE_TABLE(i2c, isl12022_id);
 static struct i2c_driver isl12022_driver = {
 	.driver		= {
 		.name	= "rtc-isl12022",
+#ifdef CONFIG_OF
+		.of_match_table = of_match_ptr(isl12022_dt_match),
+#endif
 	},
 	.probe		= isl12022_probe,
 	.id_table	= isl12022_id,
_

Patches currently in -mm which might be from stuartl@vrt.com.au are

drivers-rtc-rtc-isl12022c-device-tree-support.patch

