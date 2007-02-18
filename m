From: akpm@linux-foundation.org
Subject: - at91-correct-value-for-at91_rstc_key.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:14:40 -0800
Message-ID: <200702180214.l1I2Een2008301@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55650 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993099AbXBRCPJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:15:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan@linutronix.de, andrew@sanpeople.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     at91: correct value for AT91_RSTC_KEY
has been removed from the -mm tree.  Its filename was
     at91-correct-value-for-at91_rstc_key.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: at91: correct value for AT91_RSTC_KEY
From: Jan Altenberg <jan@linutronix.de>

- Remove a duplicated define for AT91_RSTC_KEY
- Set AT91_RSTC_KEY to the correct value
- Replace the hardcoded keys in at91sam9620.c and at91sam9261.c
  by AT91_RSTC_KEY

Signed-off-by: Jan Altenberg <jan@linutronix.de>
Acked-by: Andrew Victor <andrew@sanpeople.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/at91sam9260.c      |    2 +-
 arch/arm/mach-at91/at91sam9261.c      |    2 +-
 include/asm-arm/arch-at91/at91_rstc.h |    3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/arm/mach-at91/at91sam9260.c~at91-correct-value-for-at91_rstc_key arch/arm/mach-at91/at91sam9260.c
--- a/arch/arm/mach-at91/at91sam9260.c~at91-correct-value-for-at91_rstc_key
+++ a/arch/arm/mach-at91/at91sam9260.c
@@ -247,7 +247,7 @@ static struct at91_gpio_bank at91sam9260
 
 static void at91sam9260_reset(void)
 {
-	at91_sys_write(AT91_RSTC_CR, (0xA5 << 24) | AT91_RSTC_PROCRST | AT91_RSTC_PERRST);
+	at91_sys_write(AT91_RSTC_CR, AT91_RSTC_KEY | AT91_RSTC_PROCRST | AT91_RSTC_PERRST);
 }
 
 
diff -puN arch/arm/mach-at91/at91sam9261.c~at91-correct-value-for-at91_rstc_key arch/arm/mach-at91/at91sam9261.c
--- a/arch/arm/mach-at91/at91sam9261.c~at91-correct-value-for-at91_rstc_key
+++ a/arch/arm/mach-at91/at91sam9261.c
@@ -225,7 +225,7 @@ static struct at91_gpio_bank at91sam9261
 
 static void at91sam9261_reset(void)
 {
-	at91_sys_write(AT91_RSTC_CR, (0xA5 << 24) | AT91_RSTC_PROCRST | AT91_RSTC_PERRST);
+	at91_sys_write(AT91_RSTC_CR, AT91_RSTC_KEY | AT91_RSTC_PROCRST | AT91_RSTC_PERRST);
 }
 
 
diff -puN include/asm-arm/arch-at91/at91_rstc.h~at91-correct-value-for-at91_rstc_key include/asm-arm/arch-at91/at91_rstc.h
--- a/include/asm-arm/arch-at91/at91_rstc.h~at91-correct-value-for-at91_rstc_key
+++ a/include/asm-arm/arch-at91/at91_rstc.h
@@ -17,7 +17,7 @@
 #define		AT91_RSTC_PROCRST	(1 << 0)		/* Processor Reset */
 #define		AT91_RSTC_PERRST	(1 << 2)		/* Peripheral Reset */
 #define		AT91_RSTC_EXTRST	(1 << 3)		/* External Reset */
-#define		AT91_RSTC_KEY		(0xff << 24)		/* KEY Password */
+#define		AT91_RSTC_KEY		(0xa5 << 24)		/* KEY Password */
 
 #define AT91_RSTC_SR		(AT91_RSTC + 0x04)	/* Reset Controller Status Register */
 #define		AT91_RSTC_URSTS		(1 << 0)		/* User Reset Status */
@@ -34,6 +34,5 @@
 #define		AT91_RSTC_URSTEN	(1 << 0)		/* User Reset Enable */
 #define		AT91_RSTC_URSTIEN	(1 << 4)		/* User Reset Interrupt Enable */
 #define		AT91_RSTC_ERSTL		(0xf << 8)		/* External Reset Length */
-#define		AT91_RSTC_KEY		(0xff << 24)		/* KEY Password */
 
 #endif
_

Patches currently in -mm which might be from jan@linutronix.de are

origin.patch
git-arm.patch
git-mips.patch
