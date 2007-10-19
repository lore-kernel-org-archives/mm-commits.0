From: akpm@linux-foundation.org
Subject: - amba-pl011-rename-bit-macro.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:52:46 -0700
Message-ID: <200710192252.l9JMqkod024301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58604 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966653AbXJSXFR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     amba-pl011, rename BIT macro
has been removed from the -mm tree.  Its filename was
     amba-pl011-rename-bit-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: amba-pl011, rename BIT macro
From: Jiri Slaby <jirislaby@gmail.com>

amba-pl011, rename BIT macro

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/amba-pl011.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

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
