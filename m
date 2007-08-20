From: akpm@linux-foundation.org
Subject: + i2c-pxa-rename-bit-macro-to-pxa_bit.patch added to -mm tree
Date: Mon, 20 Aug 2007 13:42:26 -0700
Message-ID: <200708202042.l7KKgQYl022232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57335 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761953AbXHTUng (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 16:43:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, khali@linux-fr.org, nico@cam.org


The patch titled
     i2c-pxa, rename BIT macro to PXA_BIT
has been added to the -mm tree.  Its filename is
     i2c-pxa-rename-bit-macro-to-pxa_bit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i2c-pxa, rename BIT macro to PXA_BIT
From: Jiri Slaby <jirislaby@gmail.com>

i2c-pxa, rename BIT macro to PXA_BIT

BIT macro will be global definiton of (1 << x)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nicolas Pitre <nico@cam.org>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-pxa.c |   54 ++++++++++++++++-----------------
 1 files changed, 27 insertions(+), 27 deletions(-)

diff -puN drivers/i2c/busses/i2c-pxa.c~i2c-pxa-rename-bit-macro-to-pxa_bit drivers/i2c/busses/i2c-pxa.c
--- a/drivers/i2c/busses/i2c-pxa.c~i2c-pxa-rename-bit-macro-to-pxa_bit
+++ a/drivers/i2c/busses/i2c-pxa.c
@@ -82,7 +82,7 @@ struct bits {
 	const char *set;
 	const char *unset;
 };
-#define BIT(m, s, u)	{ .mask = m, .set = s, .unset = u }
+#define PXA_BIT(m, s, u)	{ .mask = m, .set = s, .unset = u }
 
 static inline void
 decode_bits(const char *prefix, const struct bits *bits, int num, u32 val)
@@ -97,17 +97,17 @@ decode_bits(const char *prefix, const st
 }
 
 static const struct bits isr_bits[] = {
-	BIT(ISR_RWM,	"RX",		"TX"),
-	BIT(ISR_ACKNAK,	"NAK",		"ACK"),
-	BIT(ISR_UB,	"Bsy",		"Rdy"),
-	BIT(ISR_IBB,	"BusBsy",	"BusRdy"),
-	BIT(ISR_SSD,	"SlaveStop",	NULL),
-	BIT(ISR_ALD,	"ALD",		NULL),
-	BIT(ISR_ITE,	"TxEmpty",	NULL),
-	BIT(ISR_IRF,	"RxFull",	NULL),
-	BIT(ISR_GCAD,	"GenCall",	NULL),
-	BIT(ISR_SAD,	"SlaveAddr",	NULL),
-	BIT(ISR_BED,	"BusErr",	NULL),
+	PXA_BIT(ISR_RWM,	"RX",		"TX"),
+	PXA_BIT(ISR_ACKNAK,	"NAK",		"ACK"),
+	PXA_BIT(ISR_UB,		"Bsy",		"Rdy"),
+	PXA_BIT(ISR_IBB,	"BusBsy",	"BusRdy"),
+	PXA_BIT(ISR_SSD,	"SlaveStop",	NULL),
+	PXA_BIT(ISR_ALD,	"ALD",		NULL),
+	PXA_BIT(ISR_ITE,	"TxEmpty",	NULL),
+	PXA_BIT(ISR_IRF,	"RxFull",	NULL),
+	PXA_BIT(ISR_GCAD,	"GenCall",	NULL),
+	PXA_BIT(ISR_SAD,	"SlaveAddr",	NULL),
+	PXA_BIT(ISR_BED,	"BusErr",	NULL),
 };
 
 static void decode_ISR(unsigned int val)
@@ -117,21 +117,21 @@ static void decode_ISR(unsigned int val)
 }
 
 static const struct bits icr_bits[] = {
-	BIT(ICR_START,  "START",	NULL),
-	BIT(ICR_STOP,   "STOP",		NULL),
-	BIT(ICR_ACKNAK, "ACKNAK",	NULL),
-	BIT(ICR_TB,     "TB",		NULL),
-	BIT(ICR_MA,     "MA",		NULL),
-	BIT(ICR_SCLE,   "SCLE",		"scle"),
-	BIT(ICR_IUE,    "IUE",		"iue"),
-	BIT(ICR_GCD,    "GCD",		NULL),
-	BIT(ICR_ITEIE,  "ITEIE",	NULL),
-	BIT(ICR_IRFIE,  "IRFIE",	NULL),
-	BIT(ICR_BEIE,   "BEIE",		NULL),
-	BIT(ICR_SSDIE,  "SSDIE",	NULL),
-	BIT(ICR_ALDIE,  "ALDIE",	NULL),
-	BIT(ICR_SADIE,  "SADIE",	NULL),
-	BIT(ICR_UR,     "UR",		"ur"),
+	PXA_BIT(ICR_START,  "START",	NULL),
+	PXA_BIT(ICR_STOP,   "STOP",	NULL),
+	PXA_BIT(ICR_ACKNAK, "ACKNAK",	NULL),
+	PXA_BIT(ICR_TB,     "TB",	NULL),
+	PXA_BIT(ICR_MA,     "MA",	NULL),
+	PXA_BIT(ICR_SCLE,   "SCLE",	"scle"),
+	PXA_BIT(ICR_IUE,    "IUE",	"iue"),
+	PXA_BIT(ICR_GCD,    "GCD",	NULL),
+	PXA_BIT(ICR_ITEIE,  "ITEIE",	NULL),
+	PXA_BIT(ICR_IRFIE,  "IRFIE",	NULL),
+	PXA_BIT(ICR_BEIE,   "BEIE",	NULL),
+	PXA_BIT(ICR_SSDIE,  "SSDIE",	NULL),
+	PXA_BIT(ICR_ALDIE,  "ALDIE",	NULL),
+	PXA_BIT(ICR_SADIE,  "SADIE",	NULL),
+	PXA_BIT(ICR_UR,     "UR",		"ur"),
 };
 
 static void decode_ICR(unsigned int val)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

net-add-ath5k-wireless-driver.patch
net-add-ath5k-wireless-driver-fix.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-mxser_new-upgrade-to-110.patch
char-mxser_new-move-to-pci_vdevice.patch
char-mxser_new-remove-useless-comments-in-mxser_cards.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
fs-select-remove-unused-macros.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
shrink_slab-handle-bad-shrinkers.patch
