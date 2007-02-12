From: akpm@linux-foundation.org
Subject: - atmel_serial-use-__raw-i-o-register-access.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:43:54 -0800
Message-ID: <200702122243.l1CMhsYT013538@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44953 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030256AbXBLWoT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:44:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, andrew@sanpeople.com, mm-commits@vger.kernel.org


The patch titled
     atmel_serial: Use __raw I/O register access
has been removed from the -mm tree.  Its filename was
     atmel_serial-use-__raw-i-o-register-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 25 insertions(+), 25 deletions(-)

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

origin.patch
git-arm.patch
git-avr32.patch
git-mtd.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
