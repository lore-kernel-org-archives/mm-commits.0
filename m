From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ds1307c-generalise-ram-size-and-offset.patch added to -mm tree
Date: Wed, 01 Feb 2012 15:57:49 -0800
Message-ID: <20120201235749.82C2CA0146@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:47518 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab2BAX5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2012 18:57:50 -0500
Received: by yenl2 with SMTP id l2so208338yen.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Feb 2012 15:57:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Austin.Boyle@aviatnet.com, Joakim.Tjernlund@transmode.se, a.zummo@towertech.it, danders.dev@gmail.com, w.sang@pengutronix.de


The patch titled
     Subject: drivers/rtc/rtc-ds1307.c: generalise ram size and offset
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1307c-generalise-ram-size-and-offset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Austin Boyle <Austin.Boyle@aviatnet.com>
Subject: drivers/rtc/rtc-ds1307.c: generalise ram size and offset

Generalise NVRAM to support RAM with other size and offset, such as the 64
bytes of SRAM on the mcp7941x.  Register offsets are added to chip
description instead of being hard-coded into probe function.

Signed-off-by: Austin Boyle <Austin.Boyle@aviatnet.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: David Anders <danders.dev@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   62 +++++++++++++++++++++++++------------
 1 file changed, 42 insertions(+), 20 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~drivers-rtc-rtc-ds1307c-generalise-ram-size-and-offset drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~drivers-rtc-rtc-ds1307c-generalise-ram-size-and-offset
+++ a/drivers/rtc/rtc-ds1307.c
@@ -102,6 +102,8 @@ enum ds_type {
 
 struct ds1307 {
 	u8			offset; /* register's offset */
+	u16			nvram_offset;
+	u16			nvram_size;
 	u8			regs[11];
 	enum ds_type		type;
 	unsigned long		flags;
@@ -117,26 +119,37 @@ struct ds1307 {
 };
 
 struct chip_desc {
-	unsigned		nvram56:1;
 	unsigned		alarm:1;
+	u8			offset;
+	u16			nvram_offset;
+	u16			nvram_size;
 };
 
 static const struct chip_desc chips[last_ds_type] = {
 	[ds_1307] = {
-		.nvram56	= 1,
+		.nvram_offset	= 8,
+		.nvram_size	= 56, /* 56 bytes NVRAM */
 	},
 	[ds_1337] = {
 		.alarm		= 1,
 	},
 	[ds_1338] = {
-		.nvram56	= 1,
+		.nvram_offset	= 8,
+		.nvram_size	= 56, /* 56 bytes NVRAM */
 	},
 	[ds_1339] = {
 		.alarm		= 1,
 	},
+	[ds_1388] = {
+		.offset		= 1, /* seconds starts at 1 */
+	},
 	[ds_3231] = {
 		.alarm		= 1,
 	},
+	[mcp7941x] = {
+		.nvram_offset	= 0x20,
+		.nvram_size	= 64, /* 64 bytes SRAM */
+	},
 };
 
 static const struct i2c_device_id ds1307_id[] = {
@@ -535,8 +548,6 @@ static const struct rtc_class_ops ds13xx
 
 /*----------------------------------------------------------------------*/
 
-#define NVRAM_SIZE	56
-
 static ssize_t
 ds1307_nvram_read(struct file *filp, struct kobject *kobj,
 		struct bin_attribute *attr,
@@ -549,14 +560,15 @@ ds1307_nvram_read(struct file *filp, str
 	client = kobj_to_i2c_client(kobj);
 	ds1307 = i2c_get_clientdata(client);
 
-	if (unlikely(off >= NVRAM_SIZE))
+	if (unlikely(off >= ds1307->nvram_size))
 		return 0;
-	if ((off + count) > NVRAM_SIZE)
-		count = NVRAM_SIZE - off;
+	if ((off + count) > ds1307->nvram_size)
+		count = ds1307->nvram_size - off;
 	if (unlikely(!count))
 		return count;
 
-	result = ds1307->read_block_data(client, 8 + off, count, buf);
+	result = ds1307->read_block_data(client, ds1307->nvram_offset + off,
+								count, buf);
 	if (result < 0)
 		dev_err(&client->dev, "%s error %d\n", "nvram read", result);
 	return result;
@@ -574,14 +586,15 @@ ds1307_nvram_write(struct file *filp, st
 	client = kobj_to_i2c_client(kobj);
 	ds1307 = i2c_get_clientdata(client);
 
-	if (unlikely(off >= NVRAM_SIZE))
+	if (unlikely(off >= ds1307->nvram_size))
 		return -EFBIG;
-	if ((off + count) > NVRAM_SIZE)
-		count = NVRAM_SIZE - off;
+	if ((off + count) > ds1307->nvram_size)
+		count = ds1307->nvram_size - off;
 	if (unlikely(!count))
 		return count;
 
-	result = ds1307->write_block_data(client, 8 + off, count, buf);
+	result = ds1307->write_block_data(client, ds1307->nvram_offset + off,
+								count, buf);
 	if (result < 0) {
 		dev_err(&client->dev, "%s error %d\n", "nvram write", result);
 		return result;
@@ -597,7 +610,6 @@ static struct bin_attribute nvram = {
 
 	.read	= ds1307_nvram_read,
 	.write	= ds1307_nvram_write,
-	.size	= NVRAM_SIZE,
 };
 
 /*----------------------------------------------------------------------*/
@@ -631,7 +643,19 @@ static int __devinit ds1307_probe(struct
 
 	ds1307->client	= client;
 	ds1307->type	= id->driver_data;
-	ds1307->offset	= 0;
+
+	if (chip && chip->offset)
+		ds1307->offset = chip->offset;
+	else
+		ds1307->offset = 0;
+	if (chip && chip->nvram_size)
+		ds1307->nvram_size = chip->nvram_size;
+	else
+		ds1307->nvram_size = 0;
+	if (chip && chip->nvram_offset)
+		ds1307->nvram_offset = chip->nvram_offset;
+	else
+		ds1307->nvram_offset = 0;
 
 	buf = ds1307->regs;
 	if (i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK)) {
@@ -748,9 +772,6 @@ static int __devinit ds1307_probe(struct
 						  hour);
 		}
 		break;
-	case ds_1388:
-		ds1307->offset = 1; /* Seconds starts at 1 */
-		break;
 	default:
 		break;
 	}
@@ -882,11 +903,12 @@ read_rtc:
 		dev_dbg(&client->dev, "got IRQ %d\n", client->irq);
 	}
 
-	if (chip && chip->nvram56) {
+	if (chip && chip->nvram_size) {
+		nvram.size = ds1307->nvram_size;
 		err = sysfs_create_bin_file(&client->dev.kobj, &nvram);
 		if (err == 0) {
 			set_bit(HAS_NVRAM, &ds1307->flags);
-			dev_info(&client->dev, "56 bytes nvram\n");
+			dev_info(&client->dev, "%zd bytes nvram\n", nvram.size);
 		}
 	}
 
_
Subject: Subject: drivers/rtc/rtc-ds1307.c: generalise ram size and offset

Patches currently in -mm which might be from Austin.Boyle@aviatnet.com are

drivers-rtc-rtc-ds1307c-generalise-ram-size-and-offset.patch

