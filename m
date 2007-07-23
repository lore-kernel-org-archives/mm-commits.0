From: akpm@linux-foundation.org
Subject: - rtc-update-and-use-the-max6900-century-byte.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:35:03 -0700
Message-ID: <200707230935.l6N9Z3P1016457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58541 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758865AbXGWJpU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dale@farnsworth.org, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: update and use the MAX6900 century byte
has been removed from the -mm tree.  Its filename was
     rtc-update-and-use-the-max6900-century-byte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc: update and use the MAX6900 century byte
From: "Dale Farnsworth" <dale@farnsworth.org>

We now read and write the century byte in the max6900 chip.  We probably
don't need to do so on Linux-only system, but it's necessary when the chip
is shared by another OS that uses the century byte.

Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max6900.c |   96 +++++++++++++++++++++++++++---------
 1 file changed, 72 insertions(+), 24 deletions(-)

diff -puN drivers/rtc/rtc-max6900.c~rtc-update-and-use-the-max6900-century-byte drivers/rtc/rtc-max6900.c
--- a/drivers/rtc/rtc-max6900.c~rtc-update-and-use-the-max6900-century-byte
+++ a/drivers/rtc/rtc-max6900.c
@@ -31,17 +31,24 @@
 #define MAX6900_REG_DW			5	/* day of week	 1-7  */
 #define MAX6900_REG_YR			6	/* year		00-99 */
 #define MAX6900_REG_CT			7	/* control */
-#define MAX6900_REG_LEN			8
+						/* register 8 is undocumented */
+#define MAX6900_REG_CENTURY		9	/* century */
+#define MAX6900_REG_LEN			10
+
+#define MAX6900_BURST_LEN		8	/* can burst r/w first 8 regs */
 
 #define MAX6900_REG_CT_WP		(1 << 7)	/* Write Protect */
 
+
 /*
  * register read/write commands
  */
 #define MAX6900_REG_CONTROL_WRITE	0x8e
-#define MAX6900_REG_BURST_READ		0xbf
-#define MAX6900_REG_BURST_WRITE		0xbe
+#define MAX6900_REG_CENTURY_WRITE	0x92
+#define MAX6900_REG_CENTURY_READ	0x93
 #define MAX6900_REG_RESERVED_READ	0x96
+#define MAX6900_REG_BURST_WRITE		0xbe
+#define MAX6900_REG_BURST_READ		0xbf
 
 #define MAX6900_IDLE_TIME_AFTER_WRITE	3	/* specification says 2.5 mS */
 
@@ -58,19 +65,32 @@ static int max6900_probe(struct i2c_adap
 
 static int max6900_i2c_read_regs(struct i2c_client *client, u8 *buf)
 {
-	u8 reg_addr[1] = { MAX6900_REG_BURST_READ };
-	struct i2c_msg msgs[2] = {
+	u8 reg_burst_read[1] = { MAX6900_REG_BURST_READ };
+	u8 reg_century_read[1] = { MAX6900_REG_CENTURY_READ };
+	struct i2c_msg msgs[4] = {
 		{
 			.addr	= client->addr,
 			.flags	= 0, /* write */
-			.len	= sizeof(reg_addr),
-			.buf	= reg_addr
+			.len	= sizeof(reg_burst_read),
+			.buf	= reg_burst_read
 		},
 		{
 			.addr	= client->addr,
 			.flags	= I2C_M_RD,
-			.len	= MAX6900_REG_LEN,
+			.len	= MAX6900_BURST_LEN,
 			.buf	= buf
+		},
+		{
+			.addr	= client->addr,
+			.flags	= 0, /* write */
+			.len	= sizeof(reg_century_read),
+			.buf	= reg_century_read
+		},
+		{
+			.addr	= client->addr,
+			.flags	= I2C_M_RD,
+			.len	= sizeof(buf[MAX6900_REG_CENTURY]),
+			.buf	= &buf[MAX6900_REG_CENTURY]
 		}
 	};
 	int rc;
@@ -86,33 +106,58 @@ static int max6900_i2c_read_regs(struct 
 
 static int max6900_i2c_write_regs(struct i2c_client *client, u8 const *buf)
 {
-	u8 i2c_buf[MAX6900_REG_LEN + 1] = { MAX6900_REG_BURST_WRITE };
-	struct i2c_msg msgs[1] = {
+	u8 i2c_century_buf[1 + 1] = { MAX6900_REG_CENTURY_WRITE };
+	struct i2c_msg century_msgs[1] = {
 		{
 			.addr	= client->addr,
 			.flags	= 0, /* write */
-			.len	= MAX6900_REG_LEN + 1,
-			.buf	= i2c_buf
+			.len	= sizeof(i2c_century_buf),
+			.buf	= i2c_century_buf
+		}
+	};
+	u8 i2c_burst_buf[MAX6900_BURST_LEN + 1] = { MAX6900_REG_BURST_WRITE };
+	struct i2c_msg burst_msgs[1] = {
+		{
+			.addr	= client->addr,
+			.flags	= 0, /* write */
+			.len	= sizeof(i2c_burst_buf),
+			.buf	= i2c_burst_buf
 		}
 	};
 	int rc;
 
-	memcpy(&i2c_buf[1], buf, MAX6900_REG_LEN);
+	/*
+	 * We have to make separate calls to i2c_transfer because of
+	 * the need to delay after each write to the chip.  Also,
+	 * we write the century byte first, since we set the write-protect
+	 * bit as part of the burst write.
+	 */
+	i2c_century_buf[1] = buf[MAX6900_REG_CENTURY];
+	rc = i2c_transfer(client->adapter, century_msgs,
+			  ARRAY_SIZE(century_msgs));
+	if (rc != ARRAY_SIZE(century_msgs))
+		goto write_failed;
+	msleep(MAX6900_IDLE_TIME_AFTER_WRITE);
 
-	rc = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
-	if (rc != ARRAY_SIZE(msgs)) {
-		dev_err(&client->dev, "%s: register write failed\n",
-			__FUNCTION__);
-		return -EIO;
-	}
+	memcpy(&i2c_burst_buf[1], buf, MAX6900_BURST_LEN);
+
+	rc = i2c_transfer(client->adapter, burst_msgs, ARRAY_SIZE(burst_msgs));
+	if (rc != ARRAY_SIZE(burst_msgs))
+		goto write_failed;
 	msleep(MAX6900_IDLE_TIME_AFTER_WRITE);
+
 	return 0;
+
+write_failed:
+	dev_err(&client->dev, "%s: register write failed\n",
+		__FUNCTION__);
+	return -EIO;
 }
 
 static int max6900_i2c_validate_client(struct i2c_client *client)
 {
 	u8 regs[MAX6900_REG_LEN];
-	u8 zero_mask[MAX6900_REG_LEN] = {
+	u8 zero_mask[] = {
 		0x80,	/* seconds */
 		0x80,	/* minutes */
 		0x40,	/* hours */
@@ -134,7 +179,7 @@ static int max6900_i2c_validate_client(s
 	if (rc < 0)
 		return rc;
 
-	for (i = 0; i < MAX6900_REG_LEN; ++i) {
+	for (i = 0; i < ARRAY_SIZE(zero_mask); ++i) {
 		if (regs[i] & zero_mask[i])
 			return -ENODEV;
 	}
@@ -156,7 +201,8 @@ static int max6900_i2c_read_time(struct 
 	tm->tm_hour = BCD2BIN(regs[MAX6900_REG_HR] & 0x3f);
 	tm->tm_mday = BCD2BIN(regs[MAX6900_REG_DT]);
 	tm->tm_mon = BCD2BIN(regs[MAX6900_REG_MO]) - 1;
-	tm->tm_year = BCD2BIN(regs[MAX6900_REG_YR]) + 100;
+	tm->tm_year = BCD2BIN(regs[MAX6900_REG_YR]) +
+		      BCD2BIN(regs[MAX6900_REG_CENTURY]) * 100 - 1900;
 	tm->tm_wday = BCD2BIN(regs[MAX6900_REG_DW]);
 
 	return 0;
@@ -189,9 +235,11 @@ static int max6900_i2c_set_time(struct i
 	regs[MAX6900_REG_HR] = BIN2BCD(tm->tm_hour);
 	regs[MAX6900_REG_DT] = BIN2BCD(tm->tm_mday);
 	regs[MAX6900_REG_MO] = BIN2BCD(tm->tm_mon + 1);
-	regs[MAX6900_REG_YR] = BIN2BCD(tm->tm_year - 100);
 	regs[MAX6900_REG_DW] = BIN2BCD(tm->tm_wday);
-	regs[MAX6900_REG_CT] = MAX6900_REG_CT_WP;	/* set write protect */
+	regs[MAX6900_REG_YR] = BIN2BCD(tm->tm_year % 100);
+	regs[MAX6900_REG_CENTURY] = BIN2BCD((tm->tm_year + 1900) / 100);
+	/* set write protect */
+	regs[MAX6900_REG_CT] = MAX6900_REG_CT_WP;
 
 	rc = max6900_i2c_write_regs(client, regs);
 	if (rc < 0)
_

Patches currently in -mm which might be from dale@farnsworth.org are
