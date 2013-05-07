From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-x1205c-fix-checkpatch-issues.patch added to -mm tree
Date: Tue, 07 May 2013 15:39:40 -0700
Message-ID: <20130507223940.E0C145A4016@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:50412 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab3EGWjm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 18:39:42 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so121051ves.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 15:39:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-x1205.c: fix checkpatch issues
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-x1205c-fix-checkpatch-issues.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-x1205.c: fix checkpatch issues

Fixes the following types of issues:
ERROR: do not use assignment in if condition
ERROR: open brace '{' following struct go on the same line
ERROR: else should follow close brace '}'
WARNING: please, no space before tabs

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-x1205.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff -puN drivers/rtc/rtc-x1205.c~drivers-rtc-rtc-x1205c-fix-checkpatch-issues drivers/rtc/rtc-x1205.c
--- a/drivers/rtc/rtc-x1205.c~drivers-rtc-rtc-x1205c-fix-checkpatch-issues
+++ a/drivers/rtc/rtc-x1205.c
@@ -4,7 +4,7 @@
  * Copyright 2005 Alessandro Zummo
  *
  * please send all reports to:
- * 	Karen Spearel <kas111 at gmail dot com>
+ *	Karen Spearel <kas111 at gmail dot com>
  *	Alessandro Zummo <a.zummo@towertech.it>
  *
  * based on a lot of other RTC drivers.
@@ -215,12 +215,14 @@ static int x1205_set_datetime(struct i2c
 			buf[i] |= 0x80;
 
 	/* this sequence is required to unlock the chip */
-	if ((xfer = i2c_master_send(client, wel, 3)) != 3) {
+	xfer = i2c_master_send(client, wel, 3);
+	if (xfer != 3) {
 		dev_err(&client->dev, "%s: wel - %d\n", __func__, xfer);
 		return -EIO;
 	}
 
-	if ((xfer = i2c_master_send(client, rwel, 3)) != 3) {
+	xfer = i2c_master_send(client, rwel, 3);
+	if (xfer != 3) {
 		dev_err(&client->dev, "%s: rwel - %d\n", __func__, xfer);
 		return -EIO;
 	}
@@ -269,7 +271,8 @@ static int x1205_set_datetime(struct i2c
 	}
 
 	/* disable further writes */
-	if ((xfer = i2c_master_send(client, diswe, 3)) != 3) {
+	xfer = i2c_master_send(client, diswe, 3);
+	if (xfer != 3) {
 		dev_err(&client->dev, "%s: diswe - %d\n", __func__, xfer);
 		return -EIO;
 	}
@@ -375,8 +378,7 @@ static int x1205_get_atrim(struct i2c_cl
 	return 0;
 }
 
-struct x1205_limit
-{
+struct x1205_limit {
 	unsigned char reg, mask, min, max;
 };
 
@@ -430,7 +432,8 @@ static int x1205_validate_client(struct
 			},
 		};
 
-		if ((xfer = i2c_transfer(client->adapter, msgs, 2)) != 2) {
+		xfer = i2c_transfer(client->adapter, msgs, 2);
+		if (xfer != 2) {
 			dev_err(&client->dev,
 				"%s: could not read register %x\n",
 				__func__, probe_zero_pattern[i]);
@@ -467,7 +470,8 @@ static int x1205_validate_client(struct
 			},
 		};
 
-		if ((xfer = i2c_transfer(client->adapter, msgs, 2)) != 2) {
+		xfer = i2c_transfer(client->adapter, msgs, 2);
+		if (xfer != 2) {
 			dev_err(&client->dev,
 				"%s: could not read register %x\n",
 				__func__, probe_limits_pattern[i].reg);
@@ -548,10 +552,12 @@ static int x1205_rtc_proc(struct device
 {
 	int err, dtrim, atrim;
 
-	if ((err = x1205_get_dtrim(to_i2c_client(dev), &dtrim)) == 0)
+	err = x1205_get_dtrim(to_i2c_client(dev), &dtrim);
+	if (!err)
 		seq_printf(seq, "digital_trim\t: %d ppm\n", dtrim);
 
-	if ((err = x1205_get_atrim(to_i2c_client(dev), &atrim)) == 0)
+	err = x1205_get_atrim(to_i2c_client(dev), &atrim);
+	if (!err)
 		seq_printf(seq, "analog_trim\t: %d.%02d pF\n",
 			atrim / 1000, atrim % 1000);
 	return 0;
@@ -639,7 +645,8 @@ static int x1205_probe(struct i2c_client
 	i2c_set_clientdata(client, rtc);
 
 	/* Check for power failures and eventually enable the osc */
-	if ((err = x1205_get_status(client, &sr)) == 0) {
+	err = x1205_get_status(client, &sr);
+	if (!err) {
 		if (sr & X1205_SR_RTCF) {
 			dev_err(&client->dev,
 				"power failure detected, "
@@ -647,9 +654,9 @@ static int x1205_probe(struct i2c_client
 			udelay(50);
 			x1205_fix_osc(client);
 		}
-	}
-	else
+	} else {
 		dev_err(&client->dev, "couldn't read status\n");
+	}
 
 	err = x1205_sysfs_register(&client->dev);
 	if (err)
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
drivers-rtc-rtc-v3020c-remove-redundant-goto.patch
drivers-rtc-interfacec-fix-checkpatch-errors.patch
drivers-rtc-rtc-at32ap700xc-fix-checkpatch-error.patch
drivers-rtc-rtc-at91rm9200c-include-linux-uaccessh.patch
drivers-rtc-rtc-cmosc-fix-whitespace-related-errors.patch
drivers-rtc-rtc-davincic-fix-whitespace-warning.patch
drivers-rtc-rtc-ds1305c-add-missing-braces-around-sizeof.patch
drivers-rtc-rtc-ds1374c-fix-spacing-related-issues.patch
drivers-rtc-rtc-ds1511c-fix-issues-related-to-spaces-and-braces.patch
drivers-rtc-rtc-ds3234c-fix-whitespace-issue.patch
drivers-rtc-rtc-fm3130c-fix-whitespace-related-issue.patch
drivers-rtc-rtc-m41t80c-fix-spacing-related-issue.patch
drivers-rtc-rtc-max6902c-remove-unwanted-spaces.patch
drivers-rtc-rtc-max77686c-remove-space-before-semicolon.patch
drivers-rtc-rtc-max8997c-remove-space-before-semicolon.patch
drivers-rtc-rtc-mpc5121c-remove-space-before-tab.patch
drivers-rtc-rtc-msm6242c-use-pr_warn.patch
drivers-rtc-rtc-mxcc-fix-checkpatch-error.patch
drivers-rtc-rtc-omapc-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-pcf2123c-remove-space-before-tabs.patch
drivers-rtc-rtc-pcf8583c-move-assignment-outside-if-condition.patch
drivers-rtc-rtc-rs5c313c-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-rs5c313c-fix-spacing-related-issues.patch
drivers-rtc-rtc-v3020c-fix-spacing-issues.patch
drivers-rtc-rtc-vr41xxc-fix-spacing-issues.patch
drivers-rtc-rtc-x1205c-fix-checkpatch-issues.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch

