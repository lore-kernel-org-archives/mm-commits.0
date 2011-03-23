From: akpm@linux-foundation.org
Subject: [merged] rtc-convert-ds1374-to-dev_pm_ops.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:39 -0700
Message-ID: <201103232044.p2NKiFre029056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933475Ab1CWUom (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:44:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, a.zummo@towertech.it, johnstul@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     rtc: convert DS1374 to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     rtc-convert-ds1374-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: convert DS1374 to dev_pm_ops
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

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
@@ -409,32 +410,38 @@ static int __devexit ds1374_remove(struc
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

