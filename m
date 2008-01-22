From: akpm@linux-foundation.org
Subject: + char-mxser-add-support-for-cp-114ul.patch added to -mm tree
Date: Tue, 22 Jan 2008 00:53:08 -0800
Message-ID: <200801220852.m0M8qmUH013072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49115 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754704AbYAVIx7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 03:53:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@redhat.com


The patch titled
     Char: mxser, add support for CP-114UL
has been added to the -mm tree.  Its filename is
     char-mxser-add-support-for-cp-114ul.patch

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
Subject: Char: mxser, add support for CP-114UL
From: Jiri Slaby <jirislaby@gmail.com>

Add new card (0x1393:0x1143) support added in 1.11 original driver, also
allow rate change in set_serial_info ioctl (as per 1.11 too).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Reviewed-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff -puN drivers/char/mxser.c~char-mxser-add-support-for-cp-114ul drivers/char/mxser.c
--- a/drivers/char/mxser.c~char-mxser-add-support-for-cp-114ul
+++ a/drivers/char/mxser.c
@@ -1,8 +1,8 @@
 /*
  *          mxser.c  -- MOXA Smartio/Industio family multiport serial driver.
  *
- *      Copyright (C) 1999-2006  Moxa Technologies (support@moxa.com.tw).
- *	Copyright (C) 2006-2007  Jiri Slaby <jirislaby@gmail.com>
+ *      Copyright (C) 1999-2006  Moxa Technologies (support@moxa.com).
+ *	Copyright (C) 2006-2008  Jiri Slaby <jirislaby@gmail.com>
  *
  *      This code is loosely based on the 1.8 moxa driver which is based on
  *	Linux serial driver, written by Linus Torvalds, Theodore T'so and
@@ -47,7 +47,7 @@
 
 #include "mxser.h"
 
-#define	MXSER_VERSION	"2.0.2"		/* 1.10 */
+#define	MXSER_VERSION	"2.0.3"		/* 1.11 */
 #define	MXSERMAJOR	 174
 #define	MXSERCUMAJOR	 175
 
@@ -73,6 +73,7 @@
 
 #define PCI_DEVICE_ID_CB108	0x1080
 #define PCI_DEVICE_ID_CB114	0x1142
+#define PCI_DEVICE_ID_CP114UL	0x1143
 #define PCI_DEVICE_ID_CB134I	0x1341
 #define PCI_DEVICE_ID_CP138U	0x1380
 #define PCI_DEVICE_ID_POS104UL	0x1044
@@ -140,7 +141,8 @@ static const struct mxser_cardinfo mxser
 /*25*/	{ "CB-114 series",	4, },
 	{ "CB-134I series",	4, },
 	{ "CP-138U series",	8, },
-	{ "POS-104UL series",	4, }
+	{ "POS-104UL series",	4, },
+	{ "CP-114UL series",	4, }
 };
 
 /* driver_data correspond to the lines in the structure above
@@ -169,6 +171,7 @@ static struct pci_device_id mxser_pcibrd
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CB134I),	.driver_data = 26 },
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CP138U),	.driver_data = 27 },
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_POS104UL),	.driver_data = 28 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CP114UL),	.driver_data = 29 },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, mxser_pcibrds);
@@ -1188,20 +1191,19 @@ static int mxser_set_serial_info(struct 
 		struct serial_struct __user *new_info)
 {
 	struct serial_struct new_serial;
+	speed_t baud;
 	unsigned long sl_flags;
 	unsigned int flags;
 	int retval = 0;
 
 	if (!new_info || !info->ioaddr)
-		return -EFAULT;
+		return -ENODEV;
 	if (copy_from_user(&new_serial, new_info, sizeof(new_serial)))
 		return -EFAULT;
 
-	if ((new_serial.irq != info->board->irq) ||
-			(new_serial.port != info->ioaddr) ||
-			(new_serial.custom_divisor != info->custom_divisor) ||
-			(new_serial.baud_base != info->baud_base))
-		return -EPERM;
+	if (new_serial.irq != info->board->irq ||
+			new_serial.port != info->ioaddr)
+		return -EINVAL;
 
 	flags = info->flags & ASYNC_SPD_MASK;
 
@@ -1224,6 +1226,13 @@ static int mxser_set_serial_info(struct 
 		info->tty->low_latency =
 				(info->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 		info->tty->low_latency = 0;
+		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST &&
+				(new_serial.baud_base != info->baud_base ||
+				new_serial.custom_divisor !=
+				info->custom_divisor)) {
+			baud = new_serial.baud_base / new_serial.custom_divisor;
+			tty_encode_baud_rate(info->tty, baud, baud);
+		}
 	}
 
 	info->type = new_serial.type;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-watchdog.patch
capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check.patch
maintainers-order-auerswald-alphabetically.patch
phantom-dont-grab-other-devices.patch
driver-ip27-rtc-convert-ioctl-to-unlocked_ioctl-v2.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-rocket-remove-useless-macros.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
char-esp-remove-hangup-and-wakeup-bottomhalves.patch
char-istallion-remove-hangup-bottomhalf.patch
char-specialix-remove-bottomhalves.patch
char-stallion-remove-bottomhalf.patch
char-serial167-remove-bottomhalf.patch
char-riscom8-remove-wakeup-anf-hangup-bottomhalves.patch
mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch
char-mxser-remove-special-baudrate-processing.patch
char-mxser-0-to-null-in-pointer.patch
char-mxser-reorder-mxser_cardinfo-fields.patch
char-mxser-simplify-mxser_get_serial_info.patch
char-mxser-ioctl-cleanup.patch
char-mxser-remove-it.patch
char-mxser-add-support-for-cp-114ul.patch
moxa-first-pass-at-termios-reporting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
