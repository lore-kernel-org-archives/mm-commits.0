From: akpm@linux-foundation.org
Subject: - char-mxser-add-cp-102uf-support.patch removed from -mm tree
Date: Fri, 04 Jul 2008 00:13:44 -0700
Message-ID: <200807040713.m647DirX018826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbYGDHOw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jul 2008 03:14:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser, add CP-102UF support
has been removed from the -mm tree.  Its filename was
     char-mxser-add-cp-102uf-support.patch

This patch was dropped because Alan's tree destroyed it

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: mxser, add CP-102UF support
From: Jiri Slaby <jirislaby@gmail.com>

Add support for CP-102UF moxa card (update to 1.12 original driver) and
increment this driver version.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/char/mxser.c~char-mxser-add-cp-102uf-support drivers/char/mxser.c
--- a/drivers/char/mxser.c~char-mxser-add-cp-102uf-support
+++ a/drivers/char/mxser.c
@@ -46,7 +46,7 @@
 
 #include "mxser.h"
 
-#define	MXSER_VERSION	"2.0.3"		/* 1.11 */
+#define	MXSER_VERSION	"2.0.4"		/* 1.12 */
 #define	MXSERMAJOR	 174
 #define	MXSERCUMAJOR	 175
 
@@ -72,10 +72,11 @@
 
 #define PCI_DEVICE_ID_CB108	0x1080
 #define PCI_DEVICE_ID_CB114	0x1142
-#define PCI_DEVICE_ID_CP114UL	0x1143
 #define PCI_DEVICE_ID_CB134I	0x1341
-#define PCI_DEVICE_ID_CP138U	0x1380
+#define PCI_DEVICE_ID_CP102UF	0x1023
 #define PCI_DEVICE_ID_POS104UL	0x1044
+#define PCI_DEVICE_ID_CP114UL	0x1143
+#define PCI_DEVICE_ID_CP138U	0x1380
 
 
 #define C168_ASIC_ID    1
@@ -141,7 +142,8 @@ static const struct mxser_cardinfo mxser
 	{ "CB-134I series",	4, },
 	{ "CP-138U series",	8, },
 	{ "POS-104UL series",	4, },
-	{ "CP-114UL series",	4, }
+	{ "CP-114UL series",	4, },
+/*30*/	{ "CP-102UF series",	2, },
 };
 
 /* driver_data correspond to the lines in the structure above
@@ -171,6 +173,7 @@ static struct pci_device_id mxser_pcibrd
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CP138U),	.driver_data = 27 },
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_POS104UL),	.driver_data = 28 },
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CP114UL),	.driver_data = 29 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CP102UF),	.driver_data = 30 },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, mxser_pcibrds);
@@ -1418,7 +1421,6 @@ static int mxser_set_serial_info(struct 
 		info->closing_wait = new_serial.closing_wait * HZ / 100;
 		info->tty->low_latency =
 				(info->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
-		info->tty->low_latency = 0;
 		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST &&
 				(new_serial.baud_base != info->baud_base ||
 				new_serial.custom_divisor !=
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
serial-z85c30-avoid-a-hang-at-console-switch-over.patch
serial-dz11-avoid-a-hang-at-console-switch-over.patch
vt-hold-console_sem-across-sysfs-operations.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
dsp56k-bkl-pushdown.patch
char-mxser-ioctl-cleanup.patch
char-mxser-globals-cleanup.patch
char-mxser-add-cp-102uf-support.patch
char-mxser-update-documentation.patch
char-mxser-prints-cleanup.patch
char-mxser-remove-predefined-isa-support.patch
char-mxser-various-cleanups.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

