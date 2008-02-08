From: akpm@linux-foundation.org
Subject: - char-mxser-add-support-for-cp-114ul.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:10:13 -0800
Message-ID: <200802080809.m1889sPB014884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56384 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760938AbYBHITb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser, add support for CP-114UL
has been removed from the -mm tree.  Its filename was
     char-mxser-add-support-for-cp-114ul.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-watchdog.patch
moxa-first-pass-at-termios-reporting.patch
char-applicom-use-pci_resource_start.patch
char-applicom-use-pci_match_id.patch
char-applicom-use-pci_match_id-fix.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
