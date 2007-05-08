From: akpm@linux-foundation.org
Subject: - rtc-add-rtc-class-driver-for-the-maxim-max6900-update.patch removed from -mm tree
Date: Mon, 07 May 2007 21:50:45 -0700
Message-ID: <200705080450.l484ojKI013773@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966662AbXEHEvN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 00:51:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dale@farnsworth.org, a.zummo@towertech.it, david-b@pacbell.net, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     rtc: Add RTC class driver for the Maxim MAX6900 (update)
has been removed from the -mm tree.  Its filename was
     rtc-add-rtc-class-driver-for-the-maxim-max6900-update.patch

This patch was dropped because it was folded into rtc-add-rtc-class-driver-for-the-maxim-max6900.patch

------------------------------------------------------
Subject: rtc: Add RTC class driver for the Maxim MAX6900 (update)
From: Dale Farnsworth <dale@farnsworth.org>

I believe I addressed all of Jean's comments.  I thank Jean for sending
them and apologize for losing the email.  Regarding moving it to the
new-style i2c interface, I think Jean is referring to changes in -mm, but
not yet in mainline.  I will be happy to revisit this driver and make the
changes when the new i2c-core infrastructure goes in.

Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max6900.c |   33 ++++++++++++++++-----------------
 1 files changed, 16 insertions(+), 17 deletions(-)

diff -puN drivers/rtc/rtc-max6900.c~rtc-add-rtc-class-driver-for-the-maxim-max6900-update drivers/rtc/rtc-max6900.c
--- a/drivers/rtc/rtc-max6900.c~rtc-add-rtc-class-driver-for-the-maxim-max6900-update
+++ a/drivers/rtc/rtc-max6900.c
@@ -61,16 +61,16 @@ static int max6900_i2c_read_regs(struct 
 	u8 reg_addr[1] = { MAX6900_REG_BURST_READ };
 	struct i2c_msg msgs[2] = {
 		{
-			client->addr,
-			0, /* write */
-			sizeof(reg_addr),
-			reg_addr
+			.addr	= client->addr,
+			.flags	= 0, /* write */
+			.len	= sizeof(reg_addr),
+			.buf	= reg_addr
 		},
 		{
-			client->addr,
-			I2C_M_RD,
-			MAX6900_REG_LEN,
-			buf
+			.addr	= client->addr,
+			.flags	= I2C_M_RD,
+			.len	= MAX6900_REG_LEN,
+			.buf	= buf
 		}
 	};
 	int rc;
@@ -89,10 +89,10 @@ static int max6900_i2c_write_regs(struct
 	u8 i2c_buf[MAX6900_REG_LEN + 1] = { MAX6900_REG_BURST_WRITE };
 	struct i2c_msg msgs[1] = {
 		{
-			client->addr,
-			0, /* write */
-			MAX6900_REG_LEN + 1,
-			i2c_buf
+			.addr	= client->addr,
+			.flags	= 0, /* write */
+			.len	= MAX6900_REG_LEN + 1,
+			.buf	= i2c_buf
 		}
 	};
 	int rc;
@@ -128,7 +128,7 @@ static int max6900_i2c_validate_client(s
 
 	reserved = i2c_smbus_read_byte_data(client, MAX6900_REG_RESERVED_READ);
 	if (reserved != 0x07)
-			return -ENODEV;
+		return -ENODEV;
 
 	rc = max6900_i2c_read_regs(client, regs);
 	if (rc < 0)
@@ -230,8 +230,8 @@ static struct i2c_driver max6900_driver 
 		.name	= DRV_NAME,
 	},
 	.id		= I2C_DRIVERID_MAX6900,
-	.attach_adapter = &max6900_attach_adapter,
-	.detach_client	= &max6900_detach_client,
+	.attach_adapter = max6900_attach_adapter,
+	.detach_client	= max6900_detach_client,
 };
 
 static const struct rtc_class_ops max6900_rtc_ops = {
@@ -259,8 +259,7 @@ static int max6900_probe(struct i2c_adap
 	client->addr = addr;
 	client->adapter = adapter;
 	client->driver = &max6900_driver;
-	client->flags = 0;
-	strcpy(client->name, DRV_NAME);
+	strlcpy(client->name, DRV_NAME, I2C_NAME_SIZE);
 
 	if (kind < 0) {
 		rc = max6900_i2c_validate_client(client);
_

Patches currently in -mm which might be from dale@farnsworth.org are

origin.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900-update.patch
