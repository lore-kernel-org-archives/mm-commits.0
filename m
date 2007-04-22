From: akpm@linux-foundation.org
Subject: + hwmon-w83627ehf-dont-redefine-region_offset.patch added to -mm tree
Date: Sun, 22 Apr 2007 11:43:55 -0700
Message-ID: <200704221843.l3MIhtZV031724@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754248AbXDVSoM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 14:44:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, david.c.hubbard@gmail.com


The patch titled
     hwmon/w83627ehf: Don't redefine REGION_OFFSET
has been added to the -mm tree.  Its filename is
     hwmon-w83627ehf-dont-redefine-region_offset.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hwmon/w83627ehf: Don't redefine REGION_OFFSET
From: Jean Delvare <khali@linux-fr.org>

On ia64, kernel headers define REGION_OFFSET so we can't use that.
Reported by Andrew Morton.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: David Hubbard <david.c.hubbard@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/w83627ehf.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/hwmon/w83627ehf.c~hwmon-w83627ehf-dont-redefine-region_offset drivers/hwmon/w83627ehf.c
--- a/drivers/hwmon/w83627ehf.c~hwmon-w83627ehf-dont-redefine-region_offset
+++ a/drivers/hwmon/w83627ehf.c
@@ -121,9 +121,9 @@ superio_exit(void)
  * ISA constants
  */
 
-#define REGION_ALIGNMENT	~7
-#define REGION_OFFSET		5
-#define REGION_LENGTH		2
+#define IOREGION_ALIGNMENT	~7
+#define IOREGION_OFFSET		5
+#define IOREGION_LENGTH		2
 #define ADDR_REG_OFFSET		5
 #define DATA_REG_OFFSET		6
 
@@ -1194,7 +1194,7 @@ static int w83627ehf_detect(struct i2c_a
 	u8 fan4pin, fan5pin;
 	int i, err = 0;
 
-	if (!request_region(address + REGION_OFFSET, REGION_LENGTH,
+	if (!request_region(address + IOREGION_OFFSET, IOREGION_LENGTH,
 	                    w83627ehf_driver.driver.name)) {
 		err = -EBUSY;
 		goto exit;
@@ -1322,7 +1322,7 @@ exit_remove:
 exit_free:
 	kfree(data);
 exit_release:
-	release_region(address + REGION_OFFSET, REGION_LENGTH);
+	release_region(address + IOREGION_OFFSET, IOREGION_LENGTH);
 exit:
 	return err;
 }
@@ -1337,7 +1337,7 @@ static int w83627ehf_detach_client(struc
 
 	if ((err = i2c_detach_client(client)))
 		return err;
-	release_region(client->addr + REGION_OFFSET, REGION_LENGTH);
+	release_region(client->addr + IOREGION_OFFSET, IOREGION_LENGTH);
 	kfree(data);
 
 	return 0;
@@ -1380,7 +1380,7 @@ static int __init w83627ehf_find(int sio
 	superio_select(W83627EHF_LD_HWM);
 	val = (superio_inb(SIO_REG_ADDR) << 8)
 	    | superio_inb(SIO_REG_ADDR + 1);
-	*addr = val & REGION_ALIGNMENT;
+	*addr = val & IOREGION_ALIGNMENT;
 	if (*addr == 0) {
 		superio_exit();
 		return -ENODEV;
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
hwmon-w83627ehf-dont-redefine-region_offset.patch
x86-msr-add-support-for-safe-variants.patch
git-alsa.patch
git-dvb.patch
apple-smc-driver-hardware-monitoring-and-control.patch
apple-smc-driver-hardware-monitoring-and-control-fix.patch
apple-smc-driver-standardize-and-sanitize-sysfs-tree.patch
apple-smc-driver-implement-key-enumeration.patch
applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue.patch
applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue-fix.patch
git-ieee1394.patch
git-netdev-all.patch
git-net.patch
xtensa-strlcpy-is-smart-enough.patch
oss-strlcpy-is-smart-enough.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
legacy-pc-parports-support-parport-dev.patch
layered-parport-code-uses-parport-dev.patch
clean-up-mutex_trylock-noise.patch
fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch
rivafb-handle-i2c-bus-creation-failure.patch
rivafb-nvidiafb-various-cleanups.patch
rivafb-fixed-reversed-ddc-ports.patch
