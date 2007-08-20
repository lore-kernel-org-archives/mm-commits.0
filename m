From: akpm@linux-foundation.org
Subject: + amba-pl011-rename-bit-macro.patch added to -mm tree
Date: Mon, 20 Aug 2007 13:42:32 -0700
Message-ID: <200708202042.l7KKgW1s022238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59355 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761084AbXHTUmk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 16:42:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     amba-pl011, rename BIT macro
has been added to the -mm tree.  Its filename is
     amba-pl011-rename-bit-macro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: amba-pl011, rename BIT macro
From: Jiri Slaby <jirislaby@gmail.com>

amba-pl011, rename BIT macro

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/amba-pl011.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/serial/amba-pl011.c~amba-pl011-rename-bit-macro drivers/serial/amba-pl011.c
--- a/drivers/serial/amba-pl011.c~amba-pl011-rename-bit-macro
+++ a/drivers/serial/amba-pl011.c
@@ -263,15 +263,15 @@ static unsigned int pl01x_get_mctrl(stru
 	unsigned int result = 0;
 	unsigned int status = readw(uap->port.membase + UART01x_FR);
 
-#define BIT(uartbit, tiocmbit)		\
+#define TIOCMBIT(uartbit, tiocmbit)	\
 	if (status & uartbit)		\
 		result |= tiocmbit
 
-	BIT(UART01x_FR_DCD, TIOCM_CAR);
-	BIT(UART01x_FR_DSR, TIOCM_DSR);
-	BIT(UART01x_FR_CTS, TIOCM_CTS);
-	BIT(UART011_FR_RI, TIOCM_RNG);
-#undef BIT
+	TIOCMBIT(UART01x_FR_DCD, TIOCM_CAR);
+	TIOCMBIT(UART01x_FR_DSR, TIOCM_DSR);
+	TIOCMBIT(UART01x_FR_CTS, TIOCM_CTS);
+	TIOCMBIT(UART011_FR_RI, TIOCM_RNG);
+#undef TIOCMBIT
 	return result;
 }
 
@@ -282,18 +282,18 @@ static void pl011_set_mctrl(struct uart_
 
 	cr = readw(uap->port.membase + UART011_CR);
 
-#define	BIT(tiocmbit, uartbit)		\
+#define	TIOCMBIT(tiocmbit, uartbit)		\
 	if (mctrl & tiocmbit)		\
 		cr |= uartbit;		\
 	else				\
 		cr &= ~uartbit
 
-	BIT(TIOCM_RTS, UART011_CR_RTS);
-	BIT(TIOCM_DTR, UART011_CR_DTR);
-	BIT(TIOCM_OUT1, UART011_CR_OUT1);
-	BIT(TIOCM_OUT2, UART011_CR_OUT2);
-	BIT(TIOCM_LOOP, UART011_CR_LBE);
-#undef BIT
+	TIOCMBIT(TIOCM_RTS, UART011_CR_RTS);
+	TIOCMBIT(TIOCM_DTR, UART011_CR_DTR);
+	TIOCMBIT(TIOCM_OUT1, UART011_CR_OUT1);
+	TIOCMBIT(TIOCM_OUT2, UART011_CR_OUT2);
+	TIOCMBIT(TIOCM_LOOP, UART011_CR_LBE);
+#undef TIOCMBIT
 
 	writew(cr, uap->port.membase + UART011_CR);
 }
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
