From: akpm@linux-foundation.org
Subject: - rtc-x1205-fix-alarm-set.patch removed from -mm tree
Date: Sun, 06 Jul 2008 19:58:11 -0700
Message-ID: <200807070258.m672wBSs004426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752782AbYGGC6Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 22:58:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhamel@adi.co.nz, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     rtc-x1205: Fix alarm set
has been removed from the -mm tree.  Its filename was
     rtc-x1205-fix-alarm-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-x1205: Fix alarm set
From: Michael Hamel <mhamel@adi.co.nz>

I have discovered that the current version of rtc-x1205.c does not work
correctly when asked to set the alarm time by the RTC_WKALM_SET ioctl()
call.  This happens because the alarm registers do not behave like the
current-time registers.  They are non-volatile.  Two things go wrong:

- the X1205 requires a 10 msec delay after any attempt to write to the
  non-volatile registers.  The x1205_set_datetime() routine does the write
  as 8 single-byte writes without any delay.  Only the first write
  succeeds.  The second is NAKed because the chip is busy.

- the X1205 resets the RWEL bit after any write to the non-volatile
  registers.  This would lock out any further writes after the first even
  with a 10msec delay.

I fix this by doing a single 8-byte write and then waiting 10msec for the
chip to be ready.  A side effect of this change is that it will speed up
x1205_rtc_set_time() which uses the same code.

I have also implemented the 'enable' bit in the rtc_wkalm structure, which
the existing driver does not attempt to do.  I have modified both
x1205_rtc_set_alarm() to set the AL0E bit, and x1205_rtc_read_alarm() to
return it.

I have tested this patch on a LinkSys NSLU2 under OpenWRT, but on no other
hardware.  On the NSLU2 the X1205 correctly asserts its IRQ pin when the
alarm time matches the current time.

[akpm@linux-foundation.org: clean up over-parenthesisation]
Signed-off-by: Michael Hamel <mhamel@adi.co.nz>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-x1205.c |  111 +++++++++++++++++++++++++++++++-------
 1 file changed, 91 insertions(+), 20 deletions(-)

diff -puN drivers/rtc/rtc-x1205.c~rtc-x1205-fix-alarm-set drivers/rtc/rtc-x1205.c
--- a/drivers/rtc/rtc-x1205.c~rtc-x1205-fix-alarm-set
+++ a/drivers/rtc/rtc-x1205.c
@@ -71,6 +71,7 @@
 #define X1205_SR_RTCF		0x01	/* Clock failure */
 #define X1205_SR_WEL		0x02	/* Write Enable Latch */
 #define X1205_SR_RWEL		0x04	/* Register Write Enable */
+#define X1205_SR_AL0		0x20	/* Alarm 0 match */
 
 #define X1205_DTR_DTR0		0x01
 #define X1205_DTR_DTR1		0x02
@@ -78,6 +79,8 @@
 
 #define X1205_HR_MIL		0x80	/* Set in ccr.hour for 24 hr mode */
 
+#define X1205_INT_AL0E		0x20	/* Alarm 0 enable */
+
 static struct i2c_driver x1205_driver;
 
 /*
@@ -89,8 +92,8 @@ static int x1205_get_datetime(struct i2c
 				unsigned char reg_base)
 {
 	unsigned char dt_addr[2] = { 0, reg_base };
-
 	unsigned char buf[8];
+	int i;
 
 	struct i2c_msg msgs[] = {
 		{ client->addr, 0, 2, dt_addr },	/* setup read ptr */
@@ -98,7 +101,7 @@ static int x1205_get_datetime(struct i2c
 	};
 
 	/* read date registers */
-	if ((i2c_transfer(client->adapter, &msgs[0], 2)) != 2) {
+	if (i2c_transfer(client->adapter, &msgs[0], 2) != 2) {
 		dev_err(&client->dev, "%s: read error\n", __func__);
 		return -EIO;
 	}
@@ -110,6 +113,11 @@ static int x1205_get_datetime(struct i2c
 		buf[0], buf[1], buf[2], buf[3],
 		buf[4], buf[5], buf[6], buf[7]);
 
+	/* Mask out the enable bits if these are alarm registers */
+	if (reg_base < X1205_CCR_BASE)
+		for (i = 0; i <= 4; i++)
+			buf[i] &= 0x7F;
+
 	tm->tm_sec = BCD2BIN(buf[CCR_SEC]);
 	tm->tm_min = BCD2BIN(buf[CCR_MIN]);
 	tm->tm_hour = BCD2BIN(buf[CCR_HOUR] & 0x3F); /* hr is 0-23 */
@@ -138,7 +146,7 @@ static int x1205_get_status(struct i2c_c
 	};
 
 	/* read status register */
-	if ((i2c_transfer(client->adapter, &msgs[0], 2)) != 2) {
+	if (i2c_transfer(client->adapter, &msgs[0], 2) != 2) {
 		dev_err(&client->dev, "%s: read error\n", __func__);
 		return -EIO;
 	}
@@ -147,10 +155,11 @@ static int x1205_get_status(struct i2c_c
 }
 
 static int x1205_set_datetime(struct i2c_client *client, struct rtc_time *tm,
-				int datetoo, u8 reg_base)
+			int datetoo, u8 reg_base, unsigned char alm_enable)
 {
-	int i, xfer;
+	int i, xfer, nbytes;
 	unsigned char buf[8];
+	unsigned char rdata[10] = { 0, reg_base };
 
 	static const unsigned char wel[3] = { 0, X1205_REG_SR,
 						X1205_SR_WEL };
@@ -189,6 +198,11 @@ static int x1205_set_datetime(struct i2c
 		buf[CCR_Y2K] = BIN2BCD(tm->tm_year / 100);
 	}
 
+	/* If writing alarm registers, set compare bits on registers 0-4 */
+	if (reg_base < X1205_CCR_BASE)
+		for (i = 0; i <= 4; i++)
+			buf[i] |= 0x80;
+
 	/* this sequence is required to unlock the chip */
 	if ((xfer = i2c_master_send(client, wel, 3)) != 3) {
 		dev_err(&client->dev, "%s: wel - %d\n", __func__, xfer);
@@ -200,19 +214,57 @@ static int x1205_set_datetime(struct i2c
 		return -EIO;
 	}
 
+
 	/* write register's data */
-	for (i = 0; i < (datetoo ? 8 : 3); i++) {
-		unsigned char rdata[3] = { 0, reg_base + i, buf[i] };
+	if (datetoo)
+		nbytes = 8;
+	else
+		nbytes = 3;
+	for (i = 0; i < nbytes; i++)
+		rdata[2+i] = buf[i];
+
+	xfer = i2c_master_send(client, rdata, nbytes+2);
+	if (xfer != nbytes+2) {
+		dev_err(&client->dev,
+			"%s: result=%d addr=%02x, data=%02x\n",
+			__func__,
+			 xfer, rdata[1], rdata[2]);
+		return -EIO;
+	}
+
+	/* If we wrote to the nonvolatile region, wait 10msec for write cycle*/
+	if (reg_base < X1205_CCR_BASE) {
+		unsigned char al0e[3] = { 0, X1205_REG_INT, 0 };
+
+		msleep(10);
 
-		xfer = i2c_master_send(client, rdata, 3);
+		/* ...and set or clear the AL0E bit in the INT register */
+
+		/* Need to set RWEL again as the write has cleared it */
+		xfer = i2c_master_send(client, rwel, 3);
 		if (xfer != 3) {
 			dev_err(&client->dev,
-				"%s: xfer=%d addr=%02x, data=%02x\n",
+				"%s: aloe rwel - %d\n",
 				__func__,
-				 xfer, rdata[1], rdata[2]);
+				xfer);
+			return -EIO;
+		}
+
+		if (alm_enable)
+			al0e[2] = X1205_INT_AL0E;
+
+		xfer = i2c_master_send(client, al0e, 3);
+		if (xfer != 3) {
+			dev_err(&client->dev,
+				"%s: al0e - %d\n",
+				__func__,
+				xfer);
 			return -EIO;
 		}
-	};
+
+		/* and wait 10msec again for this write to complete */
+		msleep(10);
+	}
 
 	/* disable further writes */
 	if ((xfer = i2c_master_send(client, diswe, 3)) != 3) {
@@ -230,9 +282,9 @@ static int x1205_fix_osc(struct i2c_clie
 
 	tm.tm_hour = tm.tm_min = tm.tm_sec = 0;
 
-	if ((err = x1205_set_datetime(client, &tm, 0, X1205_CCR_BASE)) < 0)
-		dev_err(&client->dev,
-			"unable to restart the oscillator\n");
+	err = x1205_set_datetime(client, &tm, 0, X1205_CCR_BASE, 0);
+	if (err < 0)
+		dev_err(&client->dev, "unable to restart the oscillator\n");
 
 	return err;
 }
@@ -248,7 +300,7 @@ static int x1205_get_dtrim(struct i2c_cl
 	};
 
 	/* read dtr register */
-	if ((i2c_transfer(client->adapter, &msgs[0], 2)) != 2) {
+	if (i2c_transfer(client->adapter, &msgs[0], 2) != 2) {
 		dev_err(&client->dev, "%s: read error\n", __func__);
 		return -EIO;
 	}
@@ -280,7 +332,7 @@ static int x1205_get_atrim(struct i2c_cl
 	};
 
 	/* read atr register */
-	if ((i2c_transfer(client->adapter, &msgs[0], 2)) != 2) {
+	if (i2c_transfer(client->adapter, &msgs[0], 2) != 2) {
 		dev_err(&client->dev, "%s: read error\n", __func__);
 		return -EIO;
 	}
@@ -403,14 +455,33 @@ static int x1205_validate_client(struct 
 
 static int x1205_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
-	return x1205_get_datetime(to_i2c_client(dev),
-		&alrm->time, X1205_ALM0_BASE);
+	int err;
+	unsigned char intreg, status;
+	static unsigned char int_addr[2] = { 0, X1205_REG_INT };
+	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_msg msgs[] = {
+		{ client->addr, 0, 2, int_addr },        /* setup read ptr */
+		{ client->addr, I2C_M_RD, 1, &intreg },  /* read INT register */
+	};
+
+	/* read interrupt register and status register */
+	if (i2c_transfer(client->adapter, &msgs[0], 2) != 2) {
+		dev_err(&client->dev, "%s: read error\n", __func__);
+		return -EIO;
+	}
+	err = x1205_get_status(client, &status);
+	if (err == 0) {
+		alrm->pending = (status & X1205_SR_AL0) ? 1 : 0;
+		alrm->enabled = (intreg & X1205_INT_AL0E) ? 1 : 0;
+		err = x1205_get_datetime(client, &alrm->time, X1205_ALM0_BASE);
+	}
+	return err;
 }
 
 static int x1205_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	return x1205_set_datetime(to_i2c_client(dev),
-		&alrm->time, 1, X1205_ALM0_BASE);
+		&alrm->time, 1, X1205_ALM0_BASE, alrm->enabled);
 }
 
 static int x1205_rtc_read_time(struct device *dev, struct rtc_time *tm)
@@ -422,7 +493,7 @@ static int x1205_rtc_read_time(struct de
 static int x1205_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	return x1205_set_datetime(to_i2c_client(dev),
-		tm, 1, X1205_CCR_BASE);
+		tm, 1, X1205_CCR_BASE, 0);
 }
 
 static int x1205_rtc_proc(struct device *dev, struct seq_file *seq)
_

Patches currently in -mm which might be from mhamel@adi.co.nz are


