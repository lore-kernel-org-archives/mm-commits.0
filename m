From: akpm@linux-foundation.org
Subject: + char-mxser_new-upgrade-to-110.patch added to -mm tree
Date: Wed, 15 Aug 2007 14:31:44 -0700
Message-ID: <200708152131.l7FLVird016017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44435 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933382AbXHOVcV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 17:32:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: mxser_new, upgrade to 1.10
has been added to the -mm tree.  Its filename is
     char-mxser_new-upgrade-to-110.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: mxser_new, upgrade to 1.10
From: Jiri Slaby <jirislaby@gmail.com>

mxser_new, upgrade to 1.10

This adds support for new (5 cards) hardware.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |   32 ++++++++++++++++++++++++--------
 1 files changed, 24 insertions(+), 8 deletions(-)

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

epcac-reformat-comments-and-coding-style-improvements.patch
char-mxser_new-upgrade-to-110.patch
char-mxser_new-move-to-pci_vdevice.patch
char-mxser_new-remove-useless-comments-in-mxser_cards.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
shrink_slab-handle-bad-shrinkers.patch
