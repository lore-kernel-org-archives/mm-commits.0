From: akpm@linux-foundation.org
Subject: + atmel_serial-use-__raw-i-o-register-access.patch added to -mm tree
Date: Wed, 07 Feb 2007 12:23:54 -0800
Message-ID: <200702072023.l17KNsin026135@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35169 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422771AbXBGUYP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 15:24:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com, andrew@sanpeople.com


The patch titled
     atmel_serial: Use __raw I/O register access
has been added to the -mm tree.  Its filename is
     atmel_serial-use-__raw-i-o-register-access.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atmel_serial: Use __raw I/O register access
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Access to chip-internal registers should always be native-endian.  This is
especially important for AVR32 since it's a big-endian architecture and the
non-raw readl() and writel() macros are defined to do little-endian
accesses.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Acked-by: Andrew Victor <andrew@sanpeople.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |   50 ++++++++++++++++----------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-use-__raw-i-o-register-access drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-use-__raw-i-o-register-access
+++ a/drivers/serial/atmel_serial.c
@@ -73,35 +73,35 @@
 
 #define ATMEL_ISR_PASS_LIMIT	256
 
-#define UART_PUT_CR(port,v)	writel(v, (port)->membase + ATMEL_US_CR)
-#define UART_GET_MR(port)	readl((port)->membase + ATMEL_US_MR)
-#define UART_PUT_MR(port,v)	writel(v, (port)->membase + ATMEL_US_MR)
-#define UART_PUT_IER(port,v)	writel(v, (port)->membase + ATMEL_US_IER)
-#define UART_PUT_IDR(port,v)	writel(v, (port)->membase + ATMEL_US_IDR)
-#define UART_GET_IMR(port)	readl((port)->membase + ATMEL_US_IMR)
-#define UART_GET_CSR(port)	readl((port)->membase + ATMEL_US_CSR)
-#define UART_GET_CHAR(port)	readl((port)->membase + ATMEL_US_RHR)
-#define UART_PUT_CHAR(port,v)	writel(v, (port)->membase + ATMEL_US_THR)
-#define UART_GET_BRGR(port)	readl((port)->membase + ATMEL_US_BRGR)
-#define UART_PUT_BRGR(port,v)	writel(v, (port)->membase + ATMEL_US_BRGR)
-#define UART_PUT_RTOR(port,v)	writel(v, (port)->membase + ATMEL_US_RTOR)
+#define UART_PUT_CR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_CR)
+#define UART_GET_MR(port)	__raw_readl((port)->membase + ATMEL_US_MR)
+#define UART_PUT_MR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_MR)
+#define UART_PUT_IER(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_IER)
+#define UART_PUT_IDR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_IDR)
+#define UART_GET_IMR(port)	__raw_readl((port)->membase + ATMEL_US_IMR)
+#define UART_GET_CSR(port)	__raw_readl((port)->membase + ATMEL_US_CSR)
+#define UART_GET_CHAR(port)	__raw_readl((port)->membase + ATMEL_US_RHR)
+#define UART_PUT_CHAR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_THR)
+#define UART_GET_BRGR(port)	__raw_readl((port)->membase + ATMEL_US_BRGR)
+#define UART_PUT_BRGR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_BRGR)
+#define UART_PUT_RTOR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_RTOR)
 
-// #define UART_GET_CR(port)	readl((port)->membase + ATMEL_US_CR)		// is write-only
+// #define UART_GET_CR(port)	__raw_readl((port)->membase + ATMEL_US_CR)		// is write-only
 
  /* PDC registers */
-#define UART_PUT_PTCR(port,v)	writel(v, (port)->membase + ATMEL_PDC_PTCR)
-#define UART_GET_PTSR(port)	readl((port)->membase + ATMEL_PDC_PTSR)
+#define UART_PUT_PTCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_PTCR)
+#define UART_GET_PTSR(port)	__raw_readl((port)->membase + ATMEL_PDC_PTSR)
 
-#define UART_PUT_RPR(port,v)	writel(v, (port)->membase + ATMEL_PDC_RPR)
-#define UART_GET_RPR(port)	readl((port)->membase + ATMEL_PDC_RPR)
-#define UART_PUT_RCR(port,v)	writel(v, (port)->membase + ATMEL_PDC_RCR)
-#define UART_PUT_RNPR(port,v)	writel(v, (port)->membase + ATMEL_PDC_RNPR)
-#define UART_PUT_RNCR(port,v)	writel(v, (port)->membase + ATMEL_PDC_RNCR)
-
-#define UART_PUT_TPR(port,v)	writel(v, (port)->membase + ATMEL_PDC_TPR)
-#define UART_PUT_TCR(port,v)	writel(v, (port)->membase + ATMEL_PDC_TCR)
-//#define UART_PUT_TNPR(port,v)	writel(v, (port)->membase + ATMEL_PDC_TNPR)
-//#define UART_PUT_TNCR(port,v)	writel(v, (port)->membase + ATMEL_PDC_TNCR)
+#define UART_PUT_RPR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_RPR)
+#define UART_GET_RPR(port)	__raw_readl((port)->membase + ATMEL_PDC_RPR)
+#define UART_PUT_RCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_RCR)
+#define UART_PUT_RNPR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_RNPR)
+#define UART_PUT_RNCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_RNCR)
+
+#define UART_PUT_TPR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_TPR)
+#define UART_PUT_TCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_TCR)
+//#define UART_PUT_TNPR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_TNPR)
+//#define UART_PUT_TNCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_TNCR)
 
 static int (*atmel_open_hook)(struct uart_port *);
 static void (*atmel_close_hook)(struct uart_port *);
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

git-avr32.patch
avr32-fix-build-breakage.patch
arch-avr32-use-array_size-macro-when-appropriate.patch
remove-a-couple-final-references-to-obsolete-verify_area.patch
atmel_serial-use-__raw-i-o-register-access.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
dynamic-kernel-command-line-avr32.patch
