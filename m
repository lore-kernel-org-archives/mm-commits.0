From: akpm@linux-foundation.org
Subject: - char-mxser_new-upgrade-to-110.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:43:20 -0700
Message-ID: <200710190343.l9J3hKUc013044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40602 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934495AbXJSDzl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, upgrade to 1.10
has been removed from the -mm tree.  Its filename was
     char-mxser_new-upgrade-to-110.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, upgrade to 1.10
From: Jiri Slaby <jirislaby@gmail.com>

mxser_new, upgrade to 1.10

This adds support for new (5 cards) hardware.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-upgrade-to-110 drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-upgrade-to-110
+++ a/drivers/char/mxser_new.c
@@ -2,7 +2,7 @@
  *          mxser.c  -- MOXA Smartio/Industio family multiport serial driver.
  *
  *      Copyright (C) 1999-2006  Moxa Technologies (support@moxa.com.tw).
- *	Copyright (C) 2006       Jiri Slaby <jirislaby@gmail.com>
+ *	Copyright (C) 2006-2007  Jiri Slaby <jirislaby@gmail.com>
  *
  *      This code is loosely based on the 1.8 moxa driver which is based on
  *	Linux serial driver, written by Linus Torvalds, Theodore T'so and
@@ -48,7 +48,7 @@
 
 #include "mxser_new.h"
 
-#define	MXSER_VERSION	"2.0.1"		/* 1.9.15 */
+#define	MXSER_VERSION	"2.0.2"		/* 1.10 */
 #define	MXSERMAJOR	 174
 #define	MXSERCUMAJOR	 175
 
@@ -72,6 +72,12 @@
 #define UART_MCR_AFE		0x20
 #define UART_LSR_SPECIAL	0x1E
 
+#define PCI_DEVICE_ID_CB108	0x1080
+#define PCI_DEVICE_ID_CB114	0x1142
+#define PCI_DEVICE_ID_CB134I	0x1341
+#define PCI_DEVICE_ID_CP138U	0x1380
+#define PCI_DEVICE_ID_POS104UL	0x1044
+
 
 #define C168_ASIC_ID    1
 #define C104_ASIC_ID    2
@@ -107,30 +113,35 @@ struct mxser_cardinfo {
 };
 
 static const struct mxser_cardinfo mxser_cards[] = {
-	{ 8, "C168 series", },			/* C168-ISA */
+/* 0*/	{ 8, "C168 series", },			/* C168-ISA */
 	{ 4, "C104 series", },			/* C104-ISA */
 	{ 4, "CI-104J series", },		/* CI104J */
 	{ 8, "C168H/PCI series", },		/* C168-PCI */
 	{ 4, "C104H/PCI series", },		/* C104-PCI */
-	{ 4, "C102 series", MXSER_HAS2 },	/* C102-ISA */
+/* 5*/	{ 4, "C102 series", MXSER_HAS2 },	/* C102-ISA */
 	{ 4, "CI-132 series", MXSER_HAS2 },	/* CI132 */
 	{ 4, "CI-134 series", },		/* CI134 */
 	{ 2, "CP-132 series", },		/* CP132 */
 	{ 4, "CP-114 series", },		/* CP114 */
-	{ 4, "CT-114 series", },		/* CT114 */
+/*10*/	{ 4, "CT-114 series", },		/* CT114 */
 	{ 2, "CP-102 series", MXSER_HIGHBAUD },	/* CP102 */
 	{ 4, "CP-104U series", },		/* CP104U */
 	{ 8, "CP-168U series", },		/* CP168U */
 	{ 2, "CP-132U series", },		/* CP132U */
-	{ 4, "CP-134U series", },		/* CP134U */
+/*15*/	{ 4, "CP-134U series", },		/* CP134U */
 	{ 4, "CP-104JU series", },		/* CP104JU */
 	{ 8, "Moxa UC7000 Serial", },		/* RC7000 */
 	{ 8, "CP-118U series", },		/* CP118U */
 	{ 2, "CP-102UL series", },		/* CP102UL */
-	{ 2, "CP-102U series", },		/* CP102U */
+/*20*/	{ 2, "CP-102U series", },		/* CP102U */
 	{ 8, "CP-118EL series", },		/* CP118EL */
 	{ 8, "CP-168EL series", },		/* CP168EL */
-	{ 4, "CP-104EL series", }		/* CP104EL */
+	{ 4, "CP-104EL series", },
+	{ 8, "CB-108 series", },
+/*25*/	{ 4, "CB-114 series", },
+	{ 4, "CB-134I series", },
+	{ 8, "CP-138U series", },
+	{ 4, "POS-104UL series", }
 };
 
 /* driver_data correspond to the lines in the structure above
@@ -172,6 +183,11 @@ static struct pci_device_id mxser_pcibrd
 		.driver_data = 22 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CP104EL),
 		.driver_data = 23 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CB108),	.driver_data = 24 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CB114),	.driver_data = 25 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CB134I),	.driver_data = 26 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CP138U),	.driver_data = 27 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_POS104UL),	.driver_data = 28 },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, mxser_pcibrds);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-wireless.patch
misc-phantom-synchronize_irq-on-suspend.patch
misc-phantom-add-comment-about-openhaptics.patch
misc-phantom-improved-data-passing.patch
fs-select-remove-unused-macros.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
remove-bits_to_type-macro.patch
remove-bits_to_type-macro-fix.patch
remove-asm-bitopsh-includes-reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
