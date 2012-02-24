From: akpm@linux-foundation.org
Subject: + rtc-ds1307-generalise-ram-size-and-offset.patch added to -mm tree
Date: Fri, 24 Feb 2012 12:16:25 -0800
Message-ID: <20120224201625.CD1BCA00B1@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:51502 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab2BXUQ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2012 15:16:28 -0500
Received: by wgbds12 with SMTP id ds12so92270wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2012 12:16:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Austin.Boyle@aviatnet.com, alessandro.zummo@towertech.it, danders.dev@gmail.com, w.sang@pengutronix.de


The patch titled
     Subject: rtc: ds1307: generalise ram size and offset
has been added to the -mm tree.  Its filename is
     rtc-ds1307-generalise-ram-size-and-offset.patch

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
Subject: rtc: ds1307: generalise ram size and offset

Generalise NVRAM to support RAM with other size and offset, such as the 64
bytes of SRAM on the mcp7941x.

Signed-off-by: Austin Boyle <Austin.Boyle@aviatnet.com>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: David Anders <danders.dev@gmail.com>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   78 ++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 31 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-generalise-ram-size-and-offset drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-generalise-ram-size-and-offset
+++ a/drivers/rtc/rtc-ds1307.c
@@ -105,6 +105,8 @@ enum ds_type {
 struct ds1307 {
 	u8			offset; /* register's offset */
 	u8			regs[11];
+	u16			nvram_offset;
+	struct bin_attribute	*nvram;
 	enum ds_type		type;
 	unsigned long		flags;
 #define HAS_NVRAM	0		/* bit 0 == sysfs file active */
@@ -119,19 +121,22 @@ struct ds1307 {
 };
 
 struct chip_desc {
-	unsigned		nvram56:1;
 	unsigned		alarm:1;
+	u16			nvram_offset;
+	u16			nvram_size;
 };
 
 static const struct chip_desc chips[last_ds_type] = {
 	[ds_1307] = {
-		.nvram56	= 1,
+		.nvram_offset	= 8,
+		.nvram_size	= 56,
 	},
 	[ds_1337] = {
 		.alarm		= 1,
 	},
 	[ds_1338] = {
-		.nvram56	= 1,
+		.nvram_offset	= 8,
+		.nvram_size	= 56,
 	},
 	[ds_1339] = {
 		.alarm		= 1,
@@ -139,6 +144,11 @@ static const struct chip_desc chips[last
 	[ds_3231] = {
 		.alarm		= 1,
 	},
+	[mcp7941x] = {
+		/* this is battery backed SRAM */
+		.nvram_offset	= 0x20,
+		.nvram_size	= 0x40,
+	},
 };
 
 static const struct i2c_device_id ds1307_id[] = {
@@ -543,8 +553,6 @@ static const struct rtc_class_ops ds13xx
 
 /*----------------------------------------------------------------------*/
 
-#define NVRAM_SIZE	56
-
 static ssize_t
 ds1307_nvram_read(struct file *filp, struct kobject *kobj,
 		struct bin_attribute *attr,
@@ -557,14 +565,15 @@ ds1307_nvram_read(struct file *filp, str
 	client = kobj_to_i2c_client(kobj);
 	ds1307 = i2c_get_clientdata(client);
 
-	if (unlikely(off >= NVRAM_SIZE))
+	if (unlikely(off >= ds1307->nvram->size))
 		return 0;
-	if ((off + count) > NVRAM_SIZE)
-		count = NVRAM_SIZE - off;
+	if ((off + count) > ds1307->nvram->size)
+		count = ds1307->nvram->size - off;
 	if (unlikely(!count))
 		return count;
 
-	result = ds1307->read_block_data(client, 8 + off, count, buf);
+	result = ds1307->read_block_data(client, ds1307->nvram_offset + off,
+								count, buf);
 	if (result < 0)
 		dev_err(&client->dev, "%s error %d\n", "nvram read", result);
 	return result;
@@ -582,14 +591,15 @@ ds1307_nvram_write(struct file *filp, st
 	client = kobj_to_i2c_client(kobj);
 	ds1307 = i2c_get_clientdata(client);
 
-	if (unlikely(off >= NVRAM_SIZE))
+	if (unlikely(off >= ds1307->nvram->size))
 		return -EFBIG;
-	if ((off + count) > NVRAM_SIZE)
-		count = NVRAM_SIZE - off;
+	if ((off + count) > ds1307->nvram->size)
+		count = ds1307->nvram->size - off;
 	if (unlikely(!count))
 		return count;
 
-	result = ds1307->write_block_data(client, 8 + off, count, buf);
+	result = ds1307->write_block_data(client, ds1307->nvram_offset + off,
+								count, buf);
 	if (result < 0) {
 		dev_err(&client->dev, "%s error %d\n", "nvram write", result);
 		return result;
@@ -597,17 +607,6 @@ ds1307_nvram_write(struct file *filp, st
 	return count;
 }
 
-static struct bin_attribute nvram = {
-	.attr = {
-		.name	= "nvram",
-		.mode	= S_IRUGO | S_IWUSR,
-	},
-
-	.read	= ds1307_nvram_read,
-	.write	= ds1307_nvram_write,
-	.size	= NVRAM_SIZE,
-};
-
 /*----------------------------------------------------------------------*/
 
 static int __devinit ds1307_probe(struct i2c_client *client,
@@ -894,16 +893,31 @@ read_rtc:
 		dev_dbg(&client->dev, "got IRQ %d\n", client->irq);
 	}
 
-	if (chip->nvram56) {
-		err = sysfs_create_bin_file(&client->dev.kobj, &nvram);
-		if (err == 0) {
-			set_bit(HAS_NVRAM, &ds1307->flags);
-			dev_info(&client->dev, "56 bytes nvram\n");
+	if (chip->nvram_size) {
+		ds1307->nvram = kzalloc(sizeof(struct bin_attribute),
+							GFP_KERNEL);
+		if (!ds1307->nvram) {
+			err = -ENOMEM;
+			goto exit_nvram;
+		}
+		ds1307->nvram->attr.name = "nvram";
+		ds1307->nvram->attr.mode = S_IRUGO | S_IWUSR;
+		ds1307->nvram->read = ds1307_nvram_read,
+		ds1307->nvram->write = ds1307_nvram_write,
+		ds1307->nvram->size = chip->nvram_size;
+		ds1307->nvram_offset = chip->nvram_offset;
+		err = sysfs_create_bin_file(&client->dev.kobj, ds1307->nvram);
+		if (err) {
+			kfree(ds1307->nvram);
+			goto exit_nvram;
 		}
+		set_bit(HAS_NVRAM, &ds1307->flags);
+		dev_info(&client->dev, "%d bytes nvram\n", ds1307->nvram->size);
 	}
 
 	return 0;
 
+exit_nvram:
 exit_irq:
 	rtc_device_unregister(ds1307->rtc);
 exit_free:
@@ -920,8 +934,10 @@ static int __devexit ds1307_remove(struc
 		cancel_work_sync(&ds1307->work);
 	}
 
-	if (test_and_clear_bit(HAS_NVRAM, &ds1307->flags))
-		sysfs_remove_bin_file(&client->dev.kobj, &nvram);
+	if (test_and_clear_bit(HAS_NVRAM, &ds1307->flags)) {
+		sysfs_remove_bin_file(&client->dev.kobj, ds1307->nvram);
+		kfree(ds1307->nvram);
+	}
 
 	rtc_device_unregister(ds1307->rtc);
 	kfree(ds1307);
_
Subject: Subject: rtc: ds1307: generalise ram size and offset

Patches currently in -mm which might be from Austin.Boyle@aviatnet.com are

rtc-ds1307-refactor-chip_desc-table.patch
rtc-ds1307-simplify-irq-setup-code.patch
rtc-ds1307-comment-and-format-cleanup.patch
rtc-ds1307-generalise-ram-size-and-offset.patch

