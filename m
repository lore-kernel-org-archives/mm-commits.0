From: akpm@linux-foundation.org
Subject: + i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch added to -mm tree
Date: Wed, 09 Jan 2008 22:21:25 -0800
Message-ID: <200801100621.m0A6L5VP008626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46786 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464AbYAJGVo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 01:21:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: me@felipebalbi.com, david-b@pacbell.net, khali@linux-fr.org, tony@atomide.com


The patch titled
     I2C: ISP1301_OMAP: New-style i2c driver updates, part 1
has been added to the -mm tree.  Its filename is
     i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: I2C: ISP1301_OMAP: New-style i2c driver updates, part 1
From: Felipe Balbi <me@felipebalbi.com>

The following two patches updates isp1301_omap.c to new-style i2c driver.  The
patches are against curent linux mailine head.

Tony Lindgren (Cc'ed here) already has a working version of this driver on his
linux-omap git tree.  These are just a rework for them to apply cleanly on
mainline.


This patch:

Based on David Brownell's patch for tps65010, this patch
starts converting isp1301_omap.c to new-style i2c driver.

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/chips/isp1301_omap.c |   60 ++++++++++++++---------------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff -puN drivers/i2c/chips/isp1301_omap.c~i2c-isp1301_omap-new-style-i2c-driver-updates-part-1 drivers/i2c/chips/isp1301_omap.c
--- a/drivers/i2c/chips/isp1301_omap.c~i2c-isp1301_omap-new-style-i2c-driver-updates-part-1
+++ a/drivers/i2c/chips/isp1301_omap.c
@@ -49,7 +49,8 @@ MODULE_LICENSE("GPL");
 
 struct isp1301 {
 	struct otg_transceiver	otg;
-	struct i2c_client	client;
+	struct i2c_client	*client;
+	struct i2c_client	c;
 	void			(*i2c_release)(struct device *dev);
 
 	int			irq;
@@ -153,25 +154,25 @@ static struct i2c_driver isp1301_driver;
 static inline u8
 isp1301_get_u8(struct isp1301 *isp, u8 reg)
 {
-	return i2c_smbus_read_byte_data(&isp->client, reg + 0);
+	return i2c_smbus_read_byte_data(isp->client, reg + 0);
 }
 
 static inline int
 isp1301_get_u16(struct isp1301 *isp, u8 reg)
 {
-	return i2c_smbus_read_word_data(&isp->client, reg);
+	return i2c_smbus_read_word_data(isp->client, reg);
 }
 
 static inline int
 isp1301_set_bits(struct isp1301 *isp, u8 reg, u8 bits)
 {
-	return i2c_smbus_write_byte_data(&isp->client, reg + 0, bits);
+	return i2c_smbus_write_byte_data(isp->client, reg + 0, bits);
 }
 
 static inline int
 isp1301_clear_bits(struct isp1301 *isp, u8 reg, u8 bits)
 {
-	return i2c_smbus_write_byte_data(&isp->client, reg + 1, bits);
+	return i2c_smbus_write_byte_data(isp->client, reg + 1, bits);
 }
 
 /*-------------------------------------------------------------------------*/
@@ -349,10 +350,10 @@ isp1301_defer_work(struct isp1301 *isp, 
 	int status;
 
 	if (isp && !test_and_set_bit(work, &isp->todo)) {
-		(void) get_device(&isp->client.dev);
+		(void) get_device(&isp->client->dev);
 		status = schedule_work(&isp->work);
 		if (!status && !isp->working)
-			dev_vdbg(&isp->client.dev,
+			dev_vdbg(&isp->client->dev,
 				"work item %d may be lost\n", work);
 	}
 }
@@ -1107,7 +1108,7 @@ isp1301_work(struct work_struct *work)
 		/* transfer state from otg engine to isp1301 */
 		if (test_and_clear_bit(WORK_UPDATE_ISP, &isp->todo)) {
 			otg_update_isp(isp);
-			put_device(&isp->client.dev);
+			put_device(&isp->client->dev);
 		}
 #endif
 		/* transfer state from isp1301 to otg engine */
@@ -1115,7 +1116,7 @@ isp1301_work(struct work_struct *work)
 			u8		stat = isp1301_clear_latch(isp);
 
 			isp_update_otg(isp, stat);
-			put_device(&isp->client.dev);
+			put_device(&isp->client->dev);
 		}
 
 		if (test_and_clear_bit(WORK_HOST_RESUME, &isp->todo)) {
@@ -1150,7 +1151,7 @@ isp1301_work(struct work_struct *work)
 			}
 			host_resume(isp);
 			// mdelay(10);
-			put_device(&isp->client.dev);
+			put_device(&isp->client->dev);
 		}
 
 		if (test_and_clear_bit(WORK_TIMER, &isp->todo)) {
@@ -1159,15 +1160,15 @@ isp1301_work(struct work_struct *work)
 			if (!stop)
 				mod_timer(&isp->timer, jiffies + TIMER_JIFFIES);
 #endif
-			put_device(&isp->client.dev);
+			put_device(&isp->client->dev);
 		}
 
 		if (isp->todo)
-			dev_vdbg(&isp->client.dev,
+			dev_vdbg(&isp->client->dev,
 				"work done, todo = 0x%lx\n",
 				isp->todo);
 		if (stop) {
-			dev_dbg(&isp->client.dev, "stop\n");
+			dev_dbg(&isp->client->dev, "stop\n");
 			break;
 		}
 	} while (isp->todo);
@@ -1191,7 +1192,7 @@ static void isp1301_release(struct devic
 {
 	struct isp1301	*isp;
 
-	isp = container_of(dev, struct isp1301, client.dev);
+	isp = container_of(dev, struct isp1301, c.dev);
 
 	/* ugly -- i2c hijacks our memory hook to wait_for_completion() */
 	if (isp->i2c_release)
@@ -1205,7 +1206,7 @@ static int isp1301_detach_client(struct 
 {
 	struct isp1301	*isp;
 
-	isp = container_of(i2c, struct isp1301, client);
+	isp = container_of(i2c, struct isp1301, c);
 
 	isp1301_clear_bits(isp, ISP1301_INTERRUPT_FALLING, ~0);
 	isp1301_clear_bits(isp, ISP1301_INTERRUPT_RISING, ~0);
@@ -1257,7 +1258,7 @@ static int isp1301_otg_enable(struct isp
 	isp1301_set_bits(isp, ISP1301_INTERRUPT_FALLING,
 		INTR_VBUS_VLD | INTR_SESS_VLD | INTR_ID_GND);
 
-	dev_info(&isp->client.dev, "ready for dual-role USB ...\n");
+	dev_info(&isp->client->dev, "ready for dual-role USB ...\n");
 
 	return 0;
 }
@@ -1282,7 +1283,7 @@ isp1301_set_host(struct otg_transceiver 
 
 #ifdef	CONFIG_USB_OTG
 	isp->otg.host = host;
-	dev_dbg(&isp->client.dev, "registered host\n");
+	dev_dbg(&isp->client->dev, "registered host\n");
 	host_suspend(isp);
 	if (isp->otg.gadget)
 		return isp1301_otg_enable(isp);
@@ -1297,7 +1298,7 @@ isp1301_set_host(struct otg_transceiver 
 	if (machine_is_omap_h2())
 		isp1301_set_bits(isp, ISP1301_MODE_CONTROL_1, MC1_DAT_SE0);
 
-	dev_info(&isp->client.dev, "A-Host sessions ok\n");
+	dev_info(&isp->client->dev, "A-Host sessions ok\n");
 	isp1301_set_bits(isp, ISP1301_INTERRUPT_RISING,
 		INTR_ID_GND);
 	isp1301_set_bits(isp, ISP1301_INTERRUPT_FALLING,
@@ -1315,7 +1316,7 @@ isp1301_set_host(struct otg_transceiver 
 	return 0;
 
 #else
-	dev_dbg(&isp->client.dev, "host sessions not allowed\n");
+	dev_dbg(&isp->client->dev, "host sessions not allowed\n");
 	return -EINVAL;
 #endif
 
@@ -1341,7 +1342,7 @@ isp1301_set_peripheral(struct otg_transc
 
 #ifdef	CONFIG_USB_OTG
 	isp->otg.gadget = gadget;
-	dev_dbg(&isp->client.dev, "registered gadget\n");
+	dev_dbg(&isp->client->dev, "registered gadget\n");
 	/* gadget driver may be suspended until vbus_connect () */
 	if (isp->otg.host)
 		return isp1301_otg_enable(isp);
@@ -1364,7 +1365,7 @@ isp1301_set_peripheral(struct otg_transc
 		INTR_SESS_VLD);
 	isp1301_set_bits(isp, ISP1301_INTERRUPT_FALLING,
 		INTR_VBUS_VLD);
-	dev_info(&isp->client.dev, "B-Peripheral sessions ok\n");
+	dev_info(&isp->client->dev, "B-Peripheral sessions ok\n");
 	dump_regs(isp, __FUNCTION__);
 
 	/* If this has a Mini-AB connector, this mode is highly
@@ -1377,7 +1378,7 @@ isp1301_set_peripheral(struct otg_transc
 	return 0;
 
 #else
-	dev_dbg(&isp->client.dev, "peripheral sessions not allowed\n");
+	dev_dbg(&isp->client->dev, "peripheral sessions not allowed\n");
 	return -EINVAL;
 #endif
 }
@@ -1493,12 +1494,13 @@ static int isp1301_probe(struct i2c_adap
 	isp->timer.data = (unsigned long) isp;
 
 	isp->irq = -1;
-	isp->client.addr = address;
-	i2c_set_clientdata(&isp->client, isp);
-	isp->client.adapter = bus;
-	isp->client.driver = &isp1301_driver;
-	strlcpy(isp->client.name, DRIVER_NAME, I2C_NAME_SIZE);
-	i2c = &isp->client;
+	isp->irq_type = 0;
+	isp->c.addr = address;
+	i2c_set_clientdata(&isp->c, isp);
+	isp->c.adapter = bus;
+	isp->c.driver = &isp1301_driver;
+	strlcpy(isp->c.name, DRIVER_NAME, I2C_NAME_SIZE);
+	isp->client = i2c = &isp->c;
 
 	/* if this is a true probe, verify the chip ... */
 	if (kind < 0) {
@@ -1583,7 +1585,7 @@ fail2:
 		goto fail1;
 	}
 
-	isp->otg.dev = &isp->client.dev;
+	isp->otg.dev = &isp->client->dev;
 	isp->otg.label = DRIVER_NAME;
 
 	isp->otg.set_host = isp1301_set_host,
_

Patches currently in -mm which might be from me@felipebalbi.com are

i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-2.patch
