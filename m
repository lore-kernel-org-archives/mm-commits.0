From: akpm@linux-foundation.org
Subject: + rtc-convert-ds1374-to-dev_pm_ops.patch added to -mm tree
Date: Mon, 14 Feb 2011 14:50:02 -0800
Message-ID: <201102142250.p1EMo2xE030524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997Ab1BNXMz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Feb 2011 18:12:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, a.zummo@towertech.it, johnstul@us.ibm.com


The patch titled
     From: Mark Brown <broonie@opensource.wolfsonmicro.com>
has been added to the -mm tree.  Its filename is
     rtc-convert-ds1374-to-dev_pm_ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: From: Mark Brown <broonie@opensource.wolfsonmicro.com>


There is a general move to replace bus-specific PM ops with dev_pm_ops in
order to facilitate core improvements. Do this conversion for DS1374.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1374.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-ds1374.c~rtc-convert-ds1374-to-dev_pm_ops drivers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~rtc-convert-ds1374-to-dev_pm_ops
+++ a/drivers/rtc/rtc-ds1374.c
@@ -25,6 +25,7 @@
 #include <linux/bcd.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
+#include <linux/pm.h>
 
 #define DS1374_REG_TOD0		0x00 /* Time of Day */
 #define DS1374_REG_TOD1		0x01
@@ -426,32 +427,38 @@ static int __devexit ds1374_remove(struc
 }
 
 #ifdef CONFIG_PM
-static int ds1374_suspend(struct i2c_client *client, pm_message_t state)
+static int ds1374_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
+
 	if (client->irq >= 0 && device_may_wakeup(&client->dev))
 		enable_irq_wake(client->irq);
 	return 0;
 }
 
-static int ds1374_resume(struct i2c_client *client)
+static int ds1374_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
+
 	if (client->irq >= 0 && device_may_wakeup(&client->dev))
 		disable_irq_wake(client->irq);
 	return 0;
 }
+
+static SIMPLE_DEV_PM_OPS(ds1374_pm, ds1374_suspend, ds1374_resume);
+
+#define DS1374_PM (&ds1374_pm)
 #else
-#define ds1374_suspend	NULL
-#define ds1374_resume	NULL
+#define DS1374_PM NULL
 #endif
 
 static struct i2c_driver ds1374_driver = {
 	.driver = {
 		.name = "rtc-ds1374",
 		.owner = THIS_MODULE,
+		.pm = DS1374_PM,
 	},
 	.probe = ds1374_probe,
-	.suspend = ds1374_suspend,
-	.resume = ds1374_resume,
 	.remove = __devexit_p(ds1374_remove),
 	.id_table = ds1374_id,
 };
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch
leds-convert-bd2802-driver-to-dev_pm_ops.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
rtc-convert-ds1374-to-dev_pm_ops.patch

