From: akpm@linux-foundation.org
Subject: + it8712f_wdt-support-for-16-bit-timeout-values-wdioc_getstatus.patch added to -mm tree
Date: Thu, 14 Feb 2008 20:19:17 -0800
Message-ID: <200802150419.m1F4JHIF019222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45934 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154AbYBOETh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 23:19:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andrew@ishiboo.com, wim@iguana.be


The patch titled
     watchdog: it8712f_wdt support for 16-bit timeout values, WDIOC_GETSTATUS
has been added to the -mm tree.  Its filename is
     it8712f_wdt-support-for-16-bit-timeout-values-wdioc_getstatus.patch

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
Subject: watchdog: it8712f_wdt support for 16-bit timeout values, WDIOC_GETSTATUS
From: Andrew Paprocki <andrew@ishiboo.com>

Add support for 16-bit watchdog timeout values which are available in chip
revisions >= 0x08.  Values <= 65535 are seconds precision, otherwise minutes
precision is used up to a maximum value of 3932100.  Added implementation for
WDIOC_GETSTATUS which checks the WDT status bit in the WDT control register.

Signed-off-by: Andrew Paprocki <andrew@ishiboo.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/it8712f_wdt.c |   76 +++++++++++++++++++++++++------
 1 file changed, 63 insertions(+), 13 deletions(-)

diff -puN drivers/watchdog/it8712f_wdt.c~it8712f_wdt-support-for-16-bit-timeout-values-wdioc_getstatus drivers/watchdog/it8712f_wdt.c
--- a/drivers/watchdog/it8712f_wdt.c~it8712f_wdt-support-for-16-bit-timeout-values-wdioc_getstatus
+++ a/drivers/watchdog/it8712f_wdt.c
@@ -7,7 +7,8 @@
  *
  *	drivers/char/watchdog/scx200_wdt.c
  *	drivers/hwmon/it87.c
- *	IT8712F EC-LPC I/O Preliminary Specification 0.9.2.pdf
+ *	IT8712F EC-LPC I/O Preliminary Specification 0.8.2
+ *	IT8712F EC-LPC I/O Preliminary Specification 0.9.3
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License as
@@ -40,6 +41,7 @@ MODULE_DESCRIPTION("IT8712F Watchdog Dri
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
+static int max_units = 255;
 static int margin = 60;		/* in seconds */
 module_param(margin, int, 0);
 MODULE_PARM_DESC(margin, "Watchdog margin in seconds");
@@ -51,6 +53,7 @@ MODULE_PARM_DESC(nowayout, "Disable watc
 static struct semaphore it8712f_wdt_sem;
 static unsigned expect_close;
 static spinlock_t io_lock;
+static unsigned char revision;
 
 /* Dog Food address - We use the game port address */
 static unsigned short address;
@@ -108,6 +111,15 @@ superio_inw(int reg)
 	return val;
 }
 
+static void
+superio_outw(int val, int reg)
+{
+	outb(reg++, REG);
+	outb((val >> 8) & 0xff, VAL);
+	outb(reg, REG);
+	outb(val & 0xff, VAL);
+}
+
 static inline void
 superio_select(int ldn)
 {
@@ -143,15 +155,33 @@ static void
 it8712f_wdt_update_margin(void)
 {
 	int config = WDT_OUT_KRST | WDT_OUT_PWROK;
+	int units = margin;
 
-	printk(KERN_INFO NAME ": timer margin %d seconds\n", margin);
-
-	/* The timeout register only has 8bits wide */
-	if (margin < 256)
-		config |= WDT_UNIT_SEC;	/* else UNIT are MINUTES */
+	/* Switch to minutes precision if the configured margin
+	 * value does not fit within the register width.
+	 */
+	if (units <= max_units) {
+		config |= WDT_UNIT_SEC; /* else UNIT is MINUTES */
+		printk(KERN_INFO NAME ": timer margin %d seconds\n", units);
+	} else {
+		units /= 60;
+		printk(KERN_INFO NAME ": timer margin %d minutes\n", units);
+	}
 	superio_outb(config, WDT_CONFIG);
 
-	superio_outb((margin > 255) ? (margin / 60) : margin, WDT_TIMEOUT);
+	if (revision >= 0x08)
+		superio_outw(units, WDT_TIMEOUT);
+	else
+		superio_outb(units, WDT_TIMEOUT);
+}
+
+static int
+it8712f_wdt_get_status(void)
+{
+	if (superio_inb(WDT_CONTROL) & 0x01)
+		return WDIOF_CARDRESET;
+	else
+		return 0;
 }
 
 static void
@@ -234,7 +264,7 @@ it8712f_wdt_ioctl(struct inode *inode, s
 		.firmware_version = 1,
 		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	};
-	int new_margin;
+	int value;
 
 	switch (cmd) {
 	default:
@@ -244,17 +274,27 @@ it8712f_wdt_ioctl(struct inode *inode, s
 			return -EFAULT;
 		return 0;
 	case WDIOC_GETSTATUS:
+		superio_enter();
+		superio_select(LDN_GPIO);
+
+		value = it8712f_wdt_get_status();
+
+		superio_exit();
+
+		return put_user(value, p);
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, p);
 	case WDIOC_KEEPALIVE:
 		it8712f_wdt_ping();
 		return 0;
 	case WDIOC_SETTIMEOUT:
-		if (get_user(new_margin, p))
+		if (get_user(value, p))
 			return -EFAULT;
-		if (new_margin < 1)
+		if (value < 1)
+			return -EINVAL;
+		if (value > (max_units * 60))
 			return -EINVAL;
-		margin = new_margin;
+		margin = value;
 		superio_enter();
 		superio_select(LDN_GPIO);
 
@@ -262,6 +302,7 @@ it8712f_wdt_ioctl(struct inode *inode, s
 
 		superio_exit();
 		it8712f_wdt_ping();
+		/* Fall through */
 	case WDIOC_GETTIMEOUT:
 		if (put_user(margin, p))
 			return -EFAULT;
@@ -336,9 +377,18 @@ it8712f_wdt_find(unsigned short *address
 	}
 
 	err = 0;
-	printk(KERN_DEBUG NAME ": Found IT%04xF chip revision %d - "
+	revision = superio_inb(DEVREV) & 0x0f;
+
+	/* Later revisions have 16-bit values per datasheet 0.9.1 */
+	if (revision >= 0x08)
+		max_units = 65535;
+
+	if (margin > (max_units * 60))
+		margin = (max_units * 60);
+
+	printk(KERN_INFO NAME ": Found IT%04xF chip revision %d - "
 		"using DogFood address 0x%x\n",
-		chip_type, superio_inb(DEVREV) & 0x0f, *address);
+		chip_type, revision, *address);
 
 exit:
 	superio_exit();
_

Patches currently in -mm which might be from andrew@ishiboo.com are

git-alsa.patch
it8712f_wdt-support-for-16-bit-timeout-values-wdioc_getstatus.patch
