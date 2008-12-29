From: akpm@linux-foundation.org
Subject: - input-add-tsc2007-based-touchscreen-driver-update.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:19:04 -0800
Message-ID: <200812291919.mBTJJ4t7031345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752162AbYL2TTs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:19:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kwangwoo.lee@gmail.com, dtor@mail.ru, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     input-add-tsc2007-based-touchscreen-driver update
has been removed from the -mm tree.  Its filename was
     input-add-tsc2007-based-touchscreen-driver-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input-add-tsc2007-based-touchscreen-driver update
From: "Kwangwoo Lee" <kwangwoo.lee@gmail.com>

Signed-off-by: Kwangwoo Lee <kwangwoo.lee@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Acked-by: Jean Delvare <khali@linux-fr.org>	[i2c parts]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/tsc2007.c |  110 ++++++++++----------------
 1 file changed, 44 insertions(+), 66 deletions(-)

diff -puN drivers/input/touchscreen/tsc2007.c~input-add-tsc2007-based-touchscreen-driver-update drivers/input/touchscreen/tsc2007.c
--- a/drivers/input/touchscreen/tsc2007.c~input-add-tsc2007-based-touchscreen-driver-update
+++ a/drivers/input/touchscreen/tsc2007.c
@@ -20,18 +20,13 @@
  *  published by the Free Software Foundation.
  */
 
-#include <linux/hwmon.h>
-#include <linux/init.h>
-#include <linux/err.h>
-#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/hrtimer.h>
+#include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
-#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/i2c/tsc2007.h>
-#include <linux/io.h>
-
-#include <asm/irq.h>
 
 #define TS_POLL_DELAY	(10 * 1000)	/* ns delay before the first sample */
 #define TS_POLL_PERIOD	(5 * 1000)	/* ns delay between samples */
@@ -92,46 +87,32 @@ struct tsc2007 {
 	void			(*clear_penirq)(void);
 };
 
-static int tsc2007_xfer(void *tsc, unsigned char cmd)
+static inline int tsc2007_xfer(struct tsc2007 *tsc, u8 cmd)
 {
-	struct tsc2007    *ts     = tsc;
-	struct i2c_client *client = ts->client;
-
-	unsigned char  rbuf[2];
-	unsigned short val;
-	int result;
-
-	result = i2c_master_send(client, &cmd, 1);
-	if (result != 1) {
-		dev_err(&client->dev, "send failed, cmd 0x%x\n", cmd);
-		goto cmd_fail;
-	}
+	s32 data;
+	u16 val;
 
-	result = i2c_master_recv(client, rbuf, 2);
-	if (result != 2) {
-		dev_err(&client->dev, "recv failed, cmd 0x%x\n", cmd);
-		goto cmd_fail;
+	data = i2c_smbus_read_word_data(tsc->client, cmd);
+	if (data < 0) {
+		dev_err(&tsc->client->dev, "i2c io error: %d\n", data);
+		return data;
 	}
 
-	rbuf[1] = (rbuf[1] >> 4) | ((rbuf[0] & 0x0f) << 4);
-	rbuf[0] = rbuf[0] >> 4;
-
-	val = *((unsigned short *) rbuf);
-	val = be16_to_cpu(val);
-
-	dev_dbg(&client->dev, "cmd [0x%x], rbuf [0x%x, 0x%x] => val [%u]\n",
-		cmd, rbuf[0], rbuf[1], val);
+	/* The protocol and raw data format from i2c interface:
+	 * S Addr Wr [A] Comm [A] S Addr Rd [A] [DataLow] A [DataHigh] NA P
+	 * Where DataLow has [D11-D4], DataHigh has [D3-D0 << 4 | Dummy 4bit].
+	 */
+	val = swab16(data) >> 4;
 
-	return (int) val;
+	dev_dbg(&tsc->client->dev, "data: 0x%x, val: 0x%x\n", data, val);
 
-cmd_fail:
-	return -EIO;
+	return val;
 }
 
 static void tsc2007_send_event(void *tsc)
 {
 	struct tsc2007	*ts = tsc;
-	u32		Rt;
+	u32		rt;
 	u16		x, y, z1, z2;
 
 	x = ts->tc.x;
@@ -145,21 +126,21 @@ static void tsc2007_send_event(void *tsc
 
 	if (likely(x && z1)) {
 		/* compute touch pressure resistance using equation #1 */
-		Rt = z2;
-		Rt -= z1;
-		Rt *= x;
-		Rt *= ts->x_plate_ohms;
-		Rt /= z1;
-		Rt = (Rt + 2047) >> 12;
+		rt = z2;
+		rt -= z1;
+		rt *= x;
+		rt *= ts->x_plate_ohms;
+		rt /= z1;
+		rt = (rt + 2047) >> 12;
 	} else
-		Rt = 0;
+		rt = 0;
 
 	/* Sample found inconsistent by debouncing or pressure is beyond
 	 * the maximum. Don't report it to user space, repeat at least
 	 * once more the measurement
 	 */
-	if (Rt > MAX_12BIT) {
-		dev_dbg(&ts->client->dev, "ignored pressure %d\n", Rt);
+	if (rt > MAX_12BIT) {
+		dev_dbg(&ts->client->dev, "ignored pressure %d\n", rt);
 
 		hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
 			      HRTIMER_MODE_REL);
@@ -174,7 +155,7 @@ static void tsc2007_send_event(void *tsc
 	 * The only safe way to check for the pen up condition is in the
 	 * timer by reading the pen signal state (it's a GPIO _and_ IRQ).
 	 */
-	if (Rt) {
+	if (rt) {
 		struct input_dev *input = ts->input;
 
 		if (!ts->pendown) {
@@ -186,12 +167,12 @@ static void tsc2007_send_event(void *tsc
 
 		input_report_abs(input, ABS_X, x);
 		input_report_abs(input, ABS_Y, y);
-		input_report_abs(input, ABS_PRESSURE, Rt);
+		input_report_abs(input, ABS_PRESSURE, rt);
 
 		input_sync(input);
 
 		dev_dbg(&ts->client->dev, "point(%4d,%4d), pressure (%4u)\n",
-			x, y, Rt);
+			x, y, rt);
 	}
 
 	hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
@@ -200,20 +181,18 @@ static void tsc2007_send_event(void *tsc
 
 static int tsc2007_read_values(struct tsc2007 *tsc)
 {
-	struct tsc2007	*ts = tsc;
-
 	/* y- still on; turn on only y+ (and ADC) */
-	ts->tc.y = tsc2007_xfer(ts, READ_Y);
+	tsc->tc.y = tsc2007_xfer(tsc, READ_Y);
 
 	/* turn y- off, x+ on, then leave in lowpower */
-	ts->tc.x = tsc2007_xfer(ts, READ_X);
+	tsc->tc.x = tsc2007_xfer(tsc, READ_X);
 
 	/* turn y+ off, x- on; we'll use formula #1 */
-	ts->tc.z1 = tsc2007_xfer(ts, READ_Z1);
-	ts->tc.z2 = tsc2007_xfer(ts, READ_Z2);
+	tsc->tc.z1 = tsc2007_xfer(tsc, READ_Z1);
+	tsc->tc.z2 = tsc2007_xfer(tsc, READ_Z2);
 
 	/* power down */
-	tsc2007_xfer(ts, PWRDOWN);
+	tsc2007_xfer(tsc, PWRDOWN);
 	return 0;
 }
 
@@ -269,7 +248,6 @@ static irqreturn_t tsc2007_irq(int irq, 
 static int tsc2007_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
 	struct tsc2007		*ts;
 	struct tsc2007_platform_data *pdata;
 	struct input_dev	*input_dev;
@@ -281,8 +259,8 @@ static int tsc2007_probe(struct i2c_clie
 		return -EINVAL;
 	}
 
-	if (!i2c_check_functionality(adapter,
-			I2C_FUNC_I2C | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
+	if (!i2c_check_functionality(client->adapter,
+		I2C_FUNC_SMBUS_READ_WORD_DATA))
 		return -EIO;
 
 	ts = kzalloc(sizeof(struct tsc2007), GFP_KERNEL);
@@ -302,7 +280,7 @@ static int tsc2007_probe(struct i2c_clie
 
 	spin_lock_init(&ts->lock);
 
-	ts->model 	      = pdata->model;
+	ts->model             = pdata->model;
 	ts->x_plate_ohms      = pdata->x_plate_ohms;
 	ts->get_pendown_state = pdata->get_pendown_state;
 	ts->clear_penirq      = pdata->clear_penirq;
@@ -324,10 +302,10 @@ static int tsc2007_probe(struct i2c_clie
 	tsc2007_read_values(ts);
 
 	ts->irq = client->irq;
-	if (request_irq(ts->irq, tsc2007_irq, 0,
-			client->dev.driver->name, ts)) {
+	err = request_irq(ts->irq, tsc2007_irq, 0,
+			client->dev.driver->name, ts);
+	if (err < 0) {
 		dev_err(&client->dev, "irq %d busy?\n", ts->irq);
-		err = -EBUSY;
 		goto err_free_mem;
 	}
 
@@ -371,9 +349,9 @@ static struct i2c_device_id tsc2007_idta
 MODULE_DEVICE_TABLE(i2c, tsc2007_idtable);
 
 static struct i2c_driver tsc2007_driver = {
-	.driver 	= {
-		.owner		= THIS_MODULE,
-		.name		= "tsc2007"
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "tsc2007"
 	},
 	.id_table	= tsc2007_idtable,
 	.probe		= tsc2007_probe,
_

Patches currently in -mm which might be from kwangwoo.lee@gmail.com are

linux-next.patch

