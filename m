From: akpm@linux-foundation.org
Subject: + bh1780gli-convert-to-dev-pm-ops.patch added to -mm tree
Date: Tue, 18 Jan 2011 16:01:24 -0800
Message-ID: <201101190001.p0J01OSx014689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967Ab1ASAB1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 19:01:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shubhrajyoti@ti.com


The patch titled
     bh1780gli: convert to dev pm ops
has been added to the -mm tree.  Its filename is
     bh1780gli-convert-to-dev-pm-ops.patch

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
Subject: bh1780gli: convert to dev pm ops
From: Shubhrajyoti Datta <shubhrajyoti@ti.com>

Signed-off-by: Shubhrajyoti Datta <shubhrajyoti@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/bh1780gli.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/misc/bh1780gli.c~bh1780gli-convert-to-dev-pm-ops drivers/misc/bh1780gli.c
--- a/drivers/misc/bh1780gli.c~bh1780gli-convert-to-dev-pm-ops
+++ a/drivers/misc/bh1780gli.c
@@ -196,10 +196,11 @@ static int __devexit bh1780_remove(struc
 }
 
 #ifdef CONFIG_PM
-static int bh1780_suspend(struct i2c_client *client, pm_message_t mesg)
+static int bh1780_suspend(struct device *dev)
 {
 	struct bh1780_data *ddata;
 	int state, ret;
+	struct i2c_client *client = to_i2c_client(dev);
 
 	ddata = i2c_get_clientdata(client);
 	state = bh1780_read(ddata, BH1780_REG_CONTROL, "CONTROL");
@@ -217,14 +218,14 @@ static int bh1780_suspend(struct i2c_cli
 	return 0;
 }
 
-static int bh1780_resume(struct i2c_client *client)
+static int bh1780_resume(struct device *dev)
 {
 	struct bh1780_data *ddata;
 	int state, ret;
+	struct i2c_client *client = to_i2c_client(dev);
 
 	ddata = i2c_get_clientdata(client);
 	state = ddata->power_state;
-
 	ret = bh1780_write(ddata, BH1780_REG_CONTROL, state,
 				"CONTROL");
 
@@ -233,9 +234,7 @@ static int bh1780_resume(struct i2c_clie
 
 	return 0;
 }
-#else
-#define bh1780_suspend NULL
-#define bh1780_resume NULL
+static SIMPLE_DEV_PM_OPS(bh1780_pm, bh1780_suspend, bh1780_resume);
 #endif /* CONFIG_PM */
 
 static const struct i2c_device_id bh1780_id[] = {
@@ -247,11 +246,12 @@ static struct i2c_driver bh1780_driver =
 	.probe		= bh1780_probe,
 	.remove		= bh1780_remove,
 	.id_table	= bh1780_id,
-	.suspend	= bh1780_suspend,
-	.resume		= bh1780_resume,
 	.driver = {
-		.name = "bh1780"
-	},
+		.name = "bh1780",
+#ifdef CONFIG_PM
+		.pm	= &bh1780_pm,
+#endif
+},
 };
 
 static int __init bh1780_init(void)
_

Patches currently in -mm which might be from shubhrajyoti@ti.com are

origin.patch
bh1780gli-convert-to-dev-pm-ops.patch

