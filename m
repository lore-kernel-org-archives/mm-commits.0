From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ds1307-use-dev_dbg-instead-of-pr_debug.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:56 -0700
Message-ID: <20130430185656.738BF31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:50640 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933356Ab3D3S45 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:57 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so87086vcb.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ds1307: use dev_dbg() instead of pr_debug()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1307-use-dev_dbg-instead-of-pr_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ds1307: use dev_dbg() instead of pr_debug()

dev_dbg() is preferred to pr_debug().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-rtc-ds1307-use-dev_dbg-instead-of-pr_debug drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-rtc-ds1307-use-dev_dbg-instead-of-pr_debug
+++ a/drivers/rtc/rtc-ds1307.c
@@ -713,7 +713,7 @@ static int ds1307_probe(struct i2c_clien
 		tmp = ds1307->read_block_data(ds1307->client,
 				DS1337_REG_CONTROL, 2, buf);
 		if (tmp != 2) {
-			pr_debug("read error %d\n", tmp);
+			dev_dbg(&client->dev, "read error %d\n", tmp);
 			err = -EIO;
 			goto exit_free;
 		}
@@ -752,7 +752,7 @@ static int ds1307_probe(struct i2c_clien
 		tmp = i2c_smbus_read_i2c_block_data(ds1307->client,
 				RX8025_REG_CTRL1 << 4 | 0x08, 2, buf);
 		if (tmp != 2) {
-			pr_debug("read error %d\n", tmp);
+			dev_dbg(&client->dev, "read error %d\n", tmp);
 			err = -EIO;
 			goto exit_free;
 		}
@@ -796,7 +796,7 @@ static int ds1307_probe(struct i2c_clien
 			tmp = i2c_smbus_read_i2c_block_data(ds1307->client,
 					RX8025_REG_CTRL1 << 4 | 0x08, 2, buf);
 			if (tmp != 2) {
-				pr_debug("read error %d\n", tmp);
+				dev_dbg(&client->dev, "read error %d\n", tmp);
 				err = -EIO;
 				goto exit_free;
 			}
@@ -824,7 +824,7 @@ read_rtc:
 	/* read RTC registers */
 	tmp = ds1307->read_block_data(ds1307->client, ds1307->offset, 8, buf);
 	if (tmp != 8) {
-		pr_debug("read error %d\n", tmp);
+		dev_dbg(&client->dev, "read error %d\n", tmp);
 		err = -EIO;
 		goto exit_free;
 	}
@@ -866,7 +866,7 @@ read_rtc:
 
 		tmp = i2c_smbus_read_byte_data(client, DS1340_REG_FLAG);
 		if (tmp < 0) {
-			pr_debug("read error %d\n", tmp);
+			dev_dbg(&client->dev, "read error %d\n", tmp);
 			err = -EIO;
 			goto exit_free;
 		}
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

