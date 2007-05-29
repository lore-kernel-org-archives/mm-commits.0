From: akpm@linux-foundation.org
Subject: - saa7111-fix-picture-settings-cache-bug.patch removed from -mm tree
Date: Tue, 29 May 2007 11:53:55 -0700
Message-ID: <200705291853.l4TIrsZ3008486@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:32909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762038AbXE2Sy1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:54:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmk@arm.linux.org.uk, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     saa7111: fix picture settings cache bug
has been removed from the -mm tree.  Its filename was
     saa7111-fix-picture-settings-cache-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: saa7111: fix picture settings cache bug
From: Russell King <rmk@arm.linux.org.uk>

If the SAA7111 device is powered down, and requires re-initialisation when
the V4L device is opened (as on the NetWinder), the SAA7111 driver gets
completely confused about the current settings.

The problem is centred around the way the driver keeps _two_ cached copies
of the current settings - one of the struct video_picture settings, and one
of the registers.

When the decoder is re-initailised, the cached register settings are
overwritten, as are the values in the hardware registers.  However, the
cached video_picture settings are not.

Resolve this by removing the useless and buggy second level of caching for
video_picture.  Instead, provide a function which updates register values
if and only if the value we are going to write to the register has changed.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/saa7111.c |   49 ++++++++++++--------------------
 1 files changed, 19 insertions(+), 30 deletions(-)

diff -puN drivers/media/video/saa7111.c~saa7111-fix-picture-settings-cache-bug drivers/media/video/saa7111.c
--- a/drivers/media/video/saa7111.c~saa7111-fix-picture-settings-cache-bug
+++ a/drivers/media/video/saa7111.c
@@ -75,10 +75,6 @@ struct saa7111 {
 	int norm;
 	int input;
 	int enable;
-	int bright;
-	int contrast;
-	int hue;
-	int sat;
 };
 
 #define   I2C_SAA7111        0x48
@@ -96,6 +92,17 @@ saa7111_write (struct i2c_client *client
 	return i2c_smbus_write_byte_data(client, reg, value);
 }
 
+static inline void
+saa7111_write_if_changed(struct i2c_client *client, u8 reg, u8 value)
+{
+	struct saa7111 *decoder = i2c_get_clientdata(client);
+
+	if (decoder->reg[reg] != value) {
+		decoder->reg[reg] = value;
+		i2c_smbus_write_byte_data(client, reg, value);
+	}
+}
+
 static int
 saa7111_write_block (struct i2c_client *client,
 		     const u8          *data,
@@ -439,28 +446,14 @@ saa7111_command (struct i2c_client *clie
 	{
 		struct video_picture *pic = arg;
 
-		if (decoder->bright != pic->brightness) {
-			/* We want 0 to 255 we get 0-65535 */
-			decoder->bright = pic->brightness;
-			saa7111_write(client, 0x0a, decoder->bright >> 8);
-		}
-		if (decoder->contrast != pic->contrast) {
-			/* We want 0 to 127 we get 0-65535 */
-			decoder->contrast = pic->contrast;
-			saa7111_write(client, 0x0b,
-				      decoder->contrast >> 9);
-		}
-		if (decoder->sat != pic->colour) {
-			/* We want 0 to 127 we get 0-65535 */
-			decoder->sat = pic->colour;
-			saa7111_write(client, 0x0c, decoder->sat >> 9);
-		}
-		if (decoder->hue != pic->hue) {
-			/* We want -128 to 127 we get 0-65535 */
-			decoder->hue = pic->hue;
-			saa7111_write(client, 0x0d,
-				      (decoder->hue - 32768) >> 8);
-		}
+		/* We want 0 to 255 we get 0-65535 */
+		saa7111_write_if_changed(client, 0x0a, pic->brightness >> 8);
+		/* We want 0 to 127 we get 0-65535 */
+		saa7111_write(client, 0x0b, pic->contrast >> 9);
+		/* We want 0 to 127 we get 0-65535 */
+		saa7111_write(client, 0x0c, pic->colour >> 9);
+		/* We want -128 to 127 we get 0-65535 */
+		saa7111_write(client, 0x0d, (pic->hue - 32768) >> 8);
 	}
 		break;
 
@@ -524,10 +517,6 @@ saa7111_detect_client (struct i2c_adapte
 	decoder->norm = VIDEO_MODE_NTSC;
 	decoder->input = 0;
 	decoder->enable = 1;
-	decoder->bright = 32768;
-	decoder->contrast = 32768;
-	decoder->hue = 32768;
-	decoder->sat = 32768;
 	i2c_set_clientdata(client, decoder);
 
 	i = i2c_attach_client(client);
_

Patches currently in -mm which might be from rmk@arm.linux.org.uk are

at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
git-dvb.patch
git-md-accel.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
serial-use-resource_size_t-for-port-io-addresses.patch
update-zilog-timeout.patch
