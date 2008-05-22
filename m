From: akpm@linux-foundation.org
Subject: + lcd-push-the-bkl-down-into-the-driver-ioctl-handler.patch added to -mm tree
Date: Thu, 22 May 2008 16:16:26 -0700
Message-ID: <200805222316.m4MNGQI8026611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755986AbYEVXRD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 19:17:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, ralf@linux-mips.org, yoichi_yuasa@tripeaks.co.jp


The patch titled
     lcd: push the BKL down into the driver ioctl handler
has been added to the -mm tree.  Its filename is
     lcd-push-the-bkl-down-into-the-driver-ioctl-handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lcd: push the BKL down into the driver ioctl handler
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/lcd.c |  125 ++++++++++++++++++++++---------------------
 1 file changed, 66 insertions(+), 59 deletions(-)

diff -puN drivers/char/lcd.c~lcd-push-the-bkl-down-into-the-driver-ioctl-handler drivers/char/lcd.c
--- a/drivers/char/lcd.c~lcd-push-the-bkl-down-into-the-driver-ioctl-handler
+++ a/drivers/char/lcd.c
@@ -22,15 +22,15 @@
 #include <linux/sched.h>
 #include <linux/smp_lock.h>
 #include <linux/delay.h>
+#include <linux/smp_lock.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 #include "lcd.h"
 
-static int lcd_ioctl(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long arg);
+static long lcd_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
 static unsigned int lcd_present = 1;
 
@@ -55,11 +55,13 @@ int lcd_register_linkcheck_func(int ifac
 }
 #endif
 
-static int lcd_ioctl(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long arg)
+static long lcd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct lcd_display button_display;
 	unsigned long address, a;
+	long ret = 0;
+
+	lock_kernel();
 
 	switch (cmd) {
 	case LCD_On:
@@ -136,7 +138,7 @@ static int lcd_ioctl(struct inode *inode
 			if (copy_to_user
 			    ((struct lcd_display *) arg, &display,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
+				ret = -EFAULT;
 
 			break;
 		}
@@ -148,14 +150,13 @@ static int lcd_ioctl(struct inode *inode
 			if (copy_from_user
 			    (&display, (struct lcd_display *) arg,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
-
-			a = (display.cursor_address | kLCD_Addr);
-
-			udelay(150);
-			BusyCheck();
-			LCDWriteInst(a);
-
+				ret = -EFAULT;
+			else {
+				a = (display.cursor_address | kLCD_Addr);
+				udelay(150);
+				BusyCheck();
+				LCDWriteInst(a);
+			}
 			break;
 		}
 
@@ -169,11 +170,12 @@ static int lcd_ioctl(struct inode *inode
 			if (copy_to_user
 			    ((struct lcd_display *) arg, &display,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
-			udelay(150);
-			BusyCheck();
-			LCDWriteInst(0x10);
-
+				ret = -EFAULT;
+			else {
+				udelay(150);
+				BusyCheck();
+				LCDWriteInst(0x10);
+			}
 			break;
 		}
 
@@ -183,15 +185,15 @@ static int lcd_ioctl(struct inode *inode
 			if (copy_from_user
 			    (&display, (struct lcd_display *) arg,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
-
-			udelay(150);
-			BusyCheck();
-			LCDWriteData(display.character);
-			udelay(150);
-			BusyCheck();
-			LCDWriteInst(0x10);
-
+				ret = -EFAULT;
+			else {
+				udelay(150);
+				BusyCheck();
+				LCDWriteData(display.character);
+				udelay(150);
+				BusyCheck();
+				LCDWriteInst(0x10);
+			}
 			break;
 		}
 
@@ -221,8 +223,10 @@ static int lcd_ioctl(struct inode *inode
 
 			if (copy_from_user
 			    (&display, (struct lcd_display *) arg,
-			     sizeof(struct lcd_display)))
-				return -EFAULT;
+			     sizeof(struct lcd_display))) {
+				ret = -EFAULT;
+				break;
+			}
 
 			udelay(150);
 			BusyCheck();
@@ -288,7 +292,7 @@ static int lcd_ioctl(struct inode *inode
 			if (copy_to_user
 			    ((struct lcd_display *) arg, &display,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
+				ret = -EFAULT;
 			break;
 		}
 
@@ -301,10 +305,11 @@ static int lcd_ioctl(struct inode *inode
 			if (copy_from_user
 			    (&led_display, (struct lcd_display *) arg,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
-
-			led_state = led_display.leds;
-			LEDSet(led_state);
+				ret = -EFAULT;
+			else {
+				led_state = led_display.leds;
+				LEDSet(led_state);
+			}
 
 			break;
 		}
@@ -321,14 +326,15 @@ static int lcd_ioctl(struct inode *inode
 			if (copy_from_user
 			    (&led_display, (struct lcd_display *) arg,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
+				ret = -EFAULT;
+			else {
+				for (i = 0; i < (int) led_display.leds; i++) {
+					bit = 2 * bit;
+				}
 
-			for (i = 0; i < (int) led_display.leds; i++) {
-				bit = 2 * bit;
+				led_state = led_state | bit;
+				LEDSet(led_state);
 			}
-
-			led_state = led_state | bit;
-			LEDSet(led_state);
 			break;
 		}
 
@@ -343,14 +349,15 @@ static int lcd_ioctl(struct inode *inode
 			if (copy_from_user
 			    (&led_display, (struct lcd_display *) arg,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
+				ret = -EFAULT;
+			else {
+				for (i = 0; i < (int) led_display.leds; i++) {
+					bit = 2 * bit;
+				}
 
-			for (i = 0; i < (int) led_display.leds; i++) {
-				bit = 2 * bit;
+				led_state = led_state & ~bit;
+				LEDSet(led_state);
 			}
-
-			led_state = led_state & ~bit;
-			LEDSet(led_state);
 			break;
 		}
 
@@ -360,7 +367,7 @@ static int lcd_ioctl(struct inode *inode
 			if (copy_to_user
 			    ((struct lcd_display *) arg, &button_display,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
+				ret = -EFAULT;
 			break;
 		}
 
@@ -370,7 +377,7 @@ static int lcd_ioctl(struct inode *inode
 			if (copy_to_user
 			    ((struct lcd_display *) arg, &button_display,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
+				ret = -EFAULT;
 			break;
 		}
 
@@ -383,8 +390,10 @@ static int lcd_ioctl(struct inode *inode
 			 */
 			if (copy_from_user
 			    (&button_display, (struct lcd_display *) arg,
-			     sizeof(button_display)))
-				return -EFAULT;
+			     sizeof(button_display))) {
+				ret = -EFAULT;
+				break;
+			}
 			iface_num = button_display.buttons;
 #if defined(CONFIG_TULIP) && 0
 			if (iface_num >= 0 &&
@@ -400,17 +409,15 @@ static int lcd_ioctl(struct inode *inode
 			if (__copy_to_user
 			    ((struct lcd_display *) arg, &button_display,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
+				ret = -EFAULT;
 			break;
 		}
 
 	default:
-		return -EINVAL;
-
+		ret = -ENOTTY;
 	}
-
-	return 0;
-
+	lock_kernel();
+	return ret;
 }
 
 static int lcd_open(struct inode *inode, struct file *file)
@@ -465,7 +472,7 @@ static ssize_t lcd_read(struct file *fil
 
 static const struct file_operations lcd_fops = {
 	.read = lcd_read,
-	.ioctl = lcd_ioctl,
+	.unlocked_ioctl = lcd_ioctl,
 	.open = lcd_open,
 };
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
serial-fix-enable_irq_wake-disable_irq_wake-imbalance-in-serial_corec.patch
linux-next.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl-fix.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations-cleanup.patch
paride-push-ioctl-down-into-driver.patch
pktcdvd-push-bkl-down-into-driver.patch
efirtc-push-down-the-bkl.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
mwave-ioctl-bkl-pushdown.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch
pcwd-a-couple-of-watchdogs-escaped-conversion.patch
dac960-push-down-bkl.patch
cm4000_cs-switch-to-unlocked_ioctl.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
snapshot-push-bkl-down-into-ioctl-handlers.patch
ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch
dsp56k-bkl-pushdown.patch
lcd-push-the-bkl-down-into-the-driver-ioctl-handler.patch

