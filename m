From: akpm@linux-foundation.org
Subject: - i2c-pxa-rename-bit-macro-to-pxa_bit.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:52:38 -0700
Message-ID: <200710192252.l9JMqc07024290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43319 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935173AbXJSXGS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, khali@linux-fr.org, nico@cam.org, mm-commits@vger.kernel.org


The patch titled
     i2c-pxa, rename BIT macro to PXA_BIT
has been removed from the -mm tree.  Its filename was
     i2c-pxa-rename-bit-macro-to-pxa_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 27 insertions(+), 27 deletions(-)

diff -puN drivers/i2c/busses/i2c-pxa.c~i2c-pxa-rename-bit-macro-to-pxa_bit drivers/i2c/busses/i2c-pxa.c
--- a/drivers/i2c/busses/i2c-pxa.c~i2c-pxa-rename-bit-macro-to-pxa_bit
+++ a/drivers/i2c/busses/i2c-pxa.c
@@ -85,7 +85,7 @@ struct bits {
 	const char *set;
 	const char *unset;
 };
-#define BIT(m, s, u)	{ .mask = m, .set = s, .unset = u }
+#define PXA_BIT(m, s, u)	{ .mask = m, .set = s, .unset = u }
 
 static inline void
 decode_bits(const char *prefix, const struct bits *bits, int num, u32 val)
@@ -100,17 +100,17 @@ decode_bits(const char *prefix, const st
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
@@ -120,21 +120,21 @@ static void decode_ISR(unsigned int val)
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

origin.patch
git-dvb.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-wireless.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
remove-asm-bitopsh-includes-reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
