From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-em3027c-add-device-tree-support.patch added to
 -mm tree
Date: Mon, 23 Feb 2015 13:55:30 -0800
Message-ID: <54eba1d2.sgJkBDxWDjw0f90P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbbBWVzb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 16:55:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbrobinson@gmail.com, a.zummo@towertech.it, grant.likely@linaro.org, mike@compulab.co.il, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-em3027.c: add device tree support
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-em3027c-add-device-tree-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-em3027c-add-device-tree-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-em3027c-add-device-tree-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Robinson <pbrobinson@gmail.com>
Subject: drivers/rtc/rtc-em3027.c: add device tree support

Set the of_match_table for this driver so that devices can be described in
the device tree.  This device is used in the Trimslice and is already
defined in the Trimslice device tree.

Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Cc: Mike Rapoport <mike@compulab.co.il>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-em3027.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN drivers/rtc/rtc-em3027.c~drivers-rtc-rtc-em3027c-add-device-tree-support drivers/rtc/rtc-em3027.c
--- a/drivers/rtc/rtc-em3027.c~drivers-rtc-rtc-em3027c-add-device-tree-support
+++ a/drivers/rtc/rtc-em3027.c
@@ -15,6 +15,7 @@
 #include <linux/rtc.h>
 #include <linux/bcd.h>
 #include <linux/module.h>
+#include <linux/of.h>
 
 /* Registers */
 #define EM3027_REG_ON_OFF_CTRL	0x00
@@ -135,10 +136,20 @@ static struct i2c_device_id em3027_id[]
 	{ "em3027", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, em3027_id);
+
+#ifdef CONFIG_OF
+static const struct of_device_id em3027_of_match[] = {
+	{ .compatible = "emmicro,em3027", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, em3027_of_match);
+#endif
 
 static struct i2c_driver em3027_driver = {
 	.driver = {
 		   .name = "rtc-em3027",
+		   .of_match_table = of_match_ptr(em3027_of_match),
 	},
 	.probe = &em3027_probe,
 	.id_table = em3027_id,
_

Patches currently in -mm which might be from pbrobinson@gmail.com are

drivers-rtc-rtc-em3027c-add-device-tree-support.patch

