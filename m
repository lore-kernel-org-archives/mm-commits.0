From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-pcf8563-introducing-readwrite_block_data.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:38:46 -0700
Message-ID: <53ea6d46.SWjq8NrOCtEyNbqB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:39719 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbaHLTir (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:47 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so1309845vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdonnefort@gmail.com, a.zummo@towertech.it, andrew@lunn.ch, jason@lakedaemon.net, simon.guinot@sequanux.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pcf8563.c: introduce read|write_block_data
has been removed from the -mm tree.  Its filename was
     rtc-rtc-pcf8563-introducing-readwrite_block_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vincent Donnefort <vdonnefort@gmail.com>
Subject: drivers/rtc/rtc-pcf8563.c: introduce read|write_block_data

This functions allow to factorize I2C I/O operations.

Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>
Cc: Simon Guinot <simon.guinot@sequanux.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |   74 +++++++++++++++++++++++-------------
 1 file changed, 48 insertions(+), 26 deletions(-)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-rtc-pcf8563-introducing-readwrite_block_data drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-rtc-pcf8563-introducing-readwrite_block_data
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -69,35 +69,66 @@ struct pcf8563 {
 	int voltage_low; /* incicates if a low_voltage was detected */
 };
 
-/*
- * In the routines that deal directly with the pcf8563 hardware, we use
- * rtc_time -- month 0-11, hour 0-23, yr = calendar year-epoch.
- */
-static int pcf8563_get_datetime(struct i2c_client *client, struct rtc_time *tm)
+static int pcf8563_read_block_data(struct i2c_client *client, unsigned char reg,
+				   unsigned char length, unsigned char *buf)
 {
-	struct pcf8563 *pcf8563 = i2c_get_clientdata(client);
-	unsigned char buf[13] = { PCF8563_REG_ST1 };
-
 	struct i2c_msg msgs[] = {
 		{/* setup read ptr */
 			.addr = client->addr,
 			.len = 1,
-			.buf = buf
+			.buf = &reg,
 		},
-		{/* read status + date */
+		{
 			.addr = client->addr,
 			.flags = I2C_M_RD,
-			.len = 13,
+			.len = length,
 			.buf = buf
 		},
 	};
 
-	/* read registers */
 	if ((i2c_transfer(client->adapter, msgs, 2)) != 2) {
 		dev_err(&client->dev, "%s: read error\n", __func__);
 		return -EIO;
 	}
 
+	return 0;
+}
+
+static int pcf8563_write_block_data(struct i2c_client *client,
+				   unsigned char reg, unsigned char length,
+				   unsigned char *buf)
+{
+	int i, err;
+
+	for (i = 0; i < length; i++) {
+		unsigned char data[2] = { reg + i, buf[i] };
+
+		err = i2c_master_send(client, data, sizeof(data));
+		if (err != sizeof(data)) {
+			dev_err(&client->dev,
+				"%s: err=%d addr=%02x, data=%02x\n",
+				__func__, err, data[0], data[1]);
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * In the routines that deal directly with the pcf8563 hardware, we use
+ * rtc_time -- month 0-11, hour 0-23, yr = calendar year-epoch.
+ */
+static int pcf8563_get_datetime(struct i2c_client *client, struct rtc_time *tm)
+{
+	struct pcf8563 *pcf8563 = i2c_get_clientdata(client);
+	unsigned char buf[9];
+	int err;
+
+	err = pcf8563_read_block_data(client, PCF8563_REG_ST1, 9, buf);
+	if (err)
+		return err;
+
 	if (buf[PCF8563_REG_SC] & PCF8563_SC_LV) {
 		pcf8563->voltage_low = 1;
 		dev_info(&client->dev,
@@ -144,7 +175,7 @@ static int pcf8563_get_datetime(struct i
 static int pcf8563_set_datetime(struct i2c_client *client, struct rtc_time *tm)
 {
 	struct pcf8563 *pcf8563 = i2c_get_clientdata(client);
-	int i, err;
+	int err;
 	unsigned char buf[9];
 
 	dev_dbg(&client->dev, "%s: secs=%d, mins=%d, hours=%d, "
@@ -170,19 +201,10 @@ static int pcf8563_set_datetime(struct i
 
 	buf[PCF8563_REG_DW] = tm->tm_wday & 0x07;
 
-	/* write register's data */
-	for (i = 0; i < 7; i++) {
-		unsigned char data[2] = { PCF8563_REG_SC + i,
-						buf[PCF8563_REG_SC + i] };
