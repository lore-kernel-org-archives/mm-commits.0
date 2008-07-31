From: akpm@linux-foundation.org
Subject: - w1-ds2490c-optimize-ds_set_pullup.patch removed from -mm tree
Date: Wed, 30 Jul 2008 20:02:33 -0700
Message-ID: <200807310302.m6V32XXY000587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762955AbYGaDCh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:02:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     w1: ds2490.c optimize ds_set_pullup
has been removed from the -mm tree.  Its filename was
     w1-ds2490c-optimize-ds_set_pullup.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: ds2490.c optimize ds_set_pullup
From: David Fries <david@fries.net>

Optimize the ds_set_pullup function.  For a strong pullup to be sent the
ds2490 has to have both the strong pullup mode enabled, and the specific
write operation has to have the SPU bit enabled.  Previously the write
always had the SPU bit enabled and both the duration and model was set
when a strong pullup was requested.  Now the strong pullup mode is enabled
at initialization time, the delay is updated only when the value changes,
and the write SPU bit is set only when a strong pullup is required.  This
removes two or three bus transactions per strong pullup request.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds2490.c |   64 +++++++++++++++++++++++-----------
 1 file changed, 45 insertions(+), 19 deletions(-)

diff -puN drivers/w1/masters/ds2490.c~w1-ds2490c-optimize-ds_set_pullup drivers/w1/masters/ds2490.c
--- a/drivers/w1/masters/ds2490.c~w1-ds2490c-optimize-ds_set_pullup
+++ a/drivers/w1/masters/ds2490.c
@@ -141,6 +141,10 @@ struct ds_device
 	 * 0: pullup not active, else duration in milliseconds
 	 */
 	int			spu_sleep;
+	/* spu_bit contains COMM_SPU or 0 depending on if the strong pullup
+	 * should be active or not for writes.
+	 */
+	u16			spu_bit;
 
 	struct w1_bus_master	master;
 };
@@ -311,6 +315,25 @@ static void ds_dump_status(struct ds_dev
 	}
 }
 
+static void ds_reset_device(struct ds_device *dev)
+{
+	ds_send_control_cmd(dev, CTL_RESET_DEVICE, 0);
+	/* Always allow strong pullup which allow individual writes to use
+	 * the strong pullup.
+	 */
+	if (ds_send_control_mode(dev, MOD_PULSE_EN, PULSE_SPUE))
+		printk(KERN_ERR "ds_reset_device: "
+			"Error allowing strong pullup\n");
+	/* Chip strong pullup time was cleared. */
+	if (dev->spu_sleep) {
+		/* lower 4 bits are 0, see ds_set_pullup */
+		u8 del = dev->spu_sleep>>4;
+		if (ds_send_control(dev, COMM_SET_DURATION | COMM_IM, del))
+			printk(KERN_ERR "ds_reset_device: "
+				"Error setting duration\n");
+	}
+}
+
 static int ds_recv_data(struct ds_device *dev, unsigned char *buf, int size)
 {
 	int count, err;
@@ -444,7 +467,7 @@ static int ds_wait_status(struct ds_devi
 
 	if (err >= 16 && st->status & ST_EPOF) {
 		printk(KERN_INFO "Resetting device after ST_EPOF.\n");
-		ds_send_control_cmd(dev, CTL_RESET_DEVICE, 0);
+		ds_reset_device(dev);
 		/* Always dump the device status. */
 		count = 101;
 	}
@@ -509,24 +532,26 @@ static int ds_set_speed(struct ds_device
 
 static int ds_set_pullup(struct ds_device *dev, int delay)
 {
-	int err;
+	int err = 0;
 	u8 del = 1 + (u8)(delay >> 4);
+	/* Just storing delay would not get the trunication and roundup. */
+	int ms = del<<4;
 
-	dev->spu_sleep = 0;
-	err = ds_send_control_mode(dev, MOD_PULSE_EN, delay ? PULSE_SPUE : 0);
-	if (err)
+	/* Enable spu_bit if a delay is set. */
+	dev->spu_bit = delay?COMM_SPU:0;
+	/* If delay is zero, it has already been disabled, if the time is
+	 * the same as the hardware was last programmed to, there is also
+	 * nothing more to do.  Compare with the recalculated value ms
+	 * rather than del or delay which can have a different value.
+	 */
+	if (delay == 0 || ms == dev->spu_sleep)
 		return err;
 
-	if (delay) {
-		err = ds_send_control(dev, COMM_SET_DURATION | COMM_IM, del);
-		if (err)
-			return err;
+	err = ds_send_control(dev, COMM_SET_DURATION | COMM_IM, del);
+	if (err)
+		return err;
 
-		/* Just storing delay would not get the trunication and
-		 * roundup.
-		 */
-		dev->spu_sleep = del<<4;
-	}
+	dev->spu_sleep = ms;
 
 	return err;
 }
@@ -577,11 +602,11 @@ static int ds_write_byte(struct ds_devic
 	struct ds_status st;
 	u8 rbyte;
 
-	err = ds_send_control(dev, COMM_BYTE_IO | COMM_IM | COMM_SPU, byte);
+	err = ds_send_control(dev, COMM_BYTE_IO | COMM_IM | dev->spu_bit, byte);
 	if (err)
 		return err;
 
-	if (dev->spu_sleep)
+	if (dev->spu_bit)
 		msleep(dev->spu_sleep);
 
 	err = ds_wait_status(dev, &st);
@@ -648,11 +673,11 @@ static int ds_write_block(struct ds_devi
 	if (err < 0)
 		return err;
 
-	err = ds_send_control(dev, COMM_BLOCK_IO | COMM_IM | COMM_SPU, len);
+	err = ds_send_control(dev, COMM_BLOCK_IO | COMM_IM | dev->spu_bit, len);
 	if (err)
 		return err;
 
-	if (dev->spu_sleep)
+	if (dev->spu_bit)
 		msleep(dev->spu_sleep);
 
 	ds_wait_status(dev, &st);
@@ -849,7 +874,7 @@ static int ds_w1_init(struct ds_device *
 	 * the input buffer.  This will cause the next read to fail
 	 * see the note in ds_recv_data.
 	 */
-	ds_send_control_cmd(dev, CTL_RESET_DEVICE, 0);
+	ds_reset_device(dev);
 
 	dev->master.data	= dev;
 	dev->master.touch_bit	= &ds9490r_touch_bit;
@@ -892,6 +917,7 @@ static int ds_probe(struct usb_interface
 		return -ENOMEM;
 	}
 	dev->spu_sleep = 0;
+	dev->spu_bit = 0;
 	dev->udev = usb_get_dev(udev);
 	if (!dev->udev) {
 		err = -ENOMEM;
_

Patches currently in -mm which might be from david@fries.net are

w1-ds2490c-optimize-ds_set_pullup.patch
w1-ds2490c-optimize-ds_set_pullup-checkpatch-fixes.patch

