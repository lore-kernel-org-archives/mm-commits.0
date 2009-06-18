From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ds1307-add-ds1388.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:44:17 -0700
Message-ID: <200906182244.n5IMiHF1003286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758586AbZFRWo3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:44:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Joakim.Tjernlund@transmode.se, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: rtc-ds1307 add ds1388
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1307-add-ds1388.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: rtc-ds1307 add ds1388
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>

Extend the ds1307 driver to support ds1388 too.

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-rtc-ds1307-add-ds1388 drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-rtc-ds1307-add-ds1388
+++ a/drivers/rtc/rtc-ds1307.c
@@ -31,6 +31,7 @@ enum ds_type {
 	ds_1338,
 	ds_1339,
 	ds_1340,
+	ds_1388,
 	m41t00,
 	rx_8025,
 	// rs5c372 too?  different address...
@@ -94,6 +95,7 @@ enum ds_type {
 
 
 struct ds1307 {
+	u8			offset; /* register's offset */
 	u8			regs[11];
 	enum ds_type		type;
 	unsigned long		flags;
@@ -138,6 +140,7 @@ static const struct i2c_device_id ds1307
 	{ "ds1337", ds_1337 },
 	{ "ds1338", ds_1338 },
 	{ "ds1339", ds_1339 },
+	{ "ds1388", ds_1388 },
 	{ "ds1340", ds_1340 },
 	{ "m41t00", m41t00 },
 	{ "rx8025", rx_8025 },
@@ -291,7 +294,7 @@ static int ds1307_get_time(struct device
 
 	/* read the RTC date and time registers all at once */
 	tmp = ds1307->read_block_data(ds1307->client,
-		DS1307_REG_SECS, 7, ds1307->regs);
+		ds1307->offset, 7, ds1307->regs);
 	if (tmp != 7) {
 		dev_err(dev, "%s error %d\n", "read", tmp);
 		return -EIO;
@@ -367,7 +370,8 @@ static int ds1307_set_time(struct device
 		"write", buf[0], buf[1], buf[2], buf[3],
 		buf[4], buf[5], buf[6]);
 
-	result = ds1307->write_block_data(ds1307->client, 0, 7, buf);
+	result = ds1307->write_block_data(ds1307->client,
+		ds1307->offset, 7, buf);
 	if (result < 0) {
 		dev_err(dev, "%s error %d\n", "write", result);
 		return result;
@@ -632,9 +636,12 @@ static int __devinit ds1307_probe(struct
 	if (!(ds1307 = kzalloc(sizeof(struct ds1307), GFP_KERNEL)))
 		return -ENOMEM;
 
-	ds1307->client = client;
 	i2c_set_clientdata(client, ds1307);
-	ds1307->type = id->driver_data;
+
+	ds1307->client	= client;
+	ds1307->type	= id->driver_data;
+	ds1307->offset	= 0;
+
 	buf = ds1307->regs;
 	if (i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK)) {
 		ds1307->read_block_data = i2c_smbus_read_i2c_block_data;
@@ -751,6 +758,9 @@ static int __devinit ds1307_probe(struct
 						  hour);
 		}
 		break;
+	case ds_1388:
+		ds1307->offset = 1; /* Seconds starts at 1 */
+		break;
 	default:
 		break;
 	}
@@ -814,6 +824,7 @@ read_rtc:
 	case rx_8025:
 	case ds_1337:
 	case ds_1339:
+	case ds_1388:
 		break;
 	}
 
_

Patches currently in -mm which might be from Joakim.Tjernlund@transmode.se are

origin.patch

