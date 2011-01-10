From: akpm@linux-foundation.org
Subject: [merged] drivers-video-i810-i810-i2cc-fix-i2c-bus-handling.patch removed from -mm tree
Date: Mon, 10 Jan 2011 13:30:20 -0800
Message-ID: <201101102132.p0ALWbsB012806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754923Ab1AJVdD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Jan 2011 16:33:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefani@seibold.net, khali@linux-fr.org, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     drivers/video/i810/i810-i2c.c: fix i2c bus handling
has been removed from the -mm tree.  Its filename was
     drivers-video-i810-i810-i2cc-fix-i2c-bus-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/i810/i810-i2c.c: fix i2c bus handling
From: Stefani Seibold <stefani@seibold.net>

Fix a longstanding bug in the i810 frame buffer driver.

The handling of the i2c bus is wrong: A 1 bit should not written to the
i2c, these will be done by switch the i2c to input.  Driving an 1 bit
active is against the i2c spec.

An active driven of a 1 bit will result in very strange error, depending
which side is the more powerful one.  In my case it depends on the
temperature of the Display-Controller-EEprom: With an cold eprom a got the
correct EDID datas, with a warm one some of the 1 bits was 0 :-(

The same bug is also in the intelfb driver in the file
drivers/video/intelfb/intelfb_i2c.c.  The functions intelfb_gpio_setscl()
and intelfb_gpio_setsda() do drive the 1 bit active to the i2c bus.  But
since i have no card which is used by the intelfb driver i cannot fix it.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/i810/i810-i2c.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/video/i810/i810-i2c.c~drivers-video-i810-i810-i2cc-fix-i2c-bus-handling drivers/video/i810/i810-i2c.c
--- a/drivers/video/i810/i810-i2c.c~drivers-video-i810-i810-i2cc-fix-i2c-bus-handling
+++ a/drivers/video/i810/i810-i2c.c
@@ -45,8 +45,10 @@ static void i810i2c_setscl(void *data, i
         struct i810fb_par         *par = chan->par;
 	u8                        __iomem *mmio = par->mmio_start_virtual;
 
-	i810_writel(mmio, chan->ddc_base, (state ? SCL_VAL_OUT : 0) | SCL_DIR |
-		    SCL_DIR_MASK | SCL_VAL_MASK);
+	if (state)
+		i810_writel(mmio, chan->ddc_base, SCL_DIR_MASK | SCL_VAL_MASK);
+	else
+		i810_writel(mmio, chan->ddc_base, SCL_DIR | SCL_DIR_MASK | SCL_VAL_MASK);
 	i810_readl(mmio, chan->ddc_base);	/* flush posted write */
 }
 
@@ -56,8 +58,10 @@ static void i810i2c_setsda(void *data, i
         struct i810fb_par         *par = chan->par;
 	u8                        __iomem *mmio = par->mmio_start_virtual;
 
- 	i810_writel(mmio, chan->ddc_base, (state ? SDA_VAL_OUT : 0) | SDA_DIR |
-		    SDA_DIR_MASK | SDA_VAL_MASK);
+	if (state)
+		i810_writel(mmio, chan->ddc_base, SDA_DIR_MASK | SDA_VAL_MASK);
+	else
+		i810_writel(mmio, chan->ddc_base, SDA_DIR | SDA_DIR_MASK | SDA_VAL_MASK);
 	i810_readl(mmio, chan->ddc_base);	/* flush posted write */
 }
 
_

Patches currently in -mm which might be from stefani@seibold.net are

origin.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes.patch

