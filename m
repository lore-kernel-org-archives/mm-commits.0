From: akpm@linux-foundation.org
Subject: - atmel_serial-remove-duplicated-macro-definition.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:55:36 -0700
Message-ID: <200804282155.m3SLtaXZ018115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935439AbYD1Vzp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:55:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: trimarchimichael@yahoo.it, hskinnemoen@atmel.com, trimarchimichael@evidence.eu.com, mm-commits@vger.kernel.org


The patch titled
     atmel_serial: remove duplicated macro definition
has been removed from the -mm tree.  Its filename was
     atmel_serial-remove-duplicated-macro-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_serial: remove duplicated macro definition
From: Michael Trimarchi <trimarchimichael@yahoo.it>

After commit 39d4c922b596633da86878b1a5cc881785b8e5fa (atmel_serial: fix
uart/console concurrent access) the UART_GET_TCR macro got redefined. This
patch removes the duplicated definition.

Signed-off-by: michael trimarchi <trimarchimichael@evidence.eu.com>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-remove-duplicated-macro-definition drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-remove-duplicated-macro-definition
+++ a/drivers/serial/atmel_serial.c
@@ -96,7 +96,6 @@
 
  /* PDC registers */
 #define UART_PUT_PTCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_PTCR)
-#define UART_GET_TCR(port)      __raw_readl((port)->membase + ATMEL_PDC_TCR)
 #define UART_GET_PTSR(port)	__raw_readl((port)->membase + ATMEL_PDC_PTSR)
 
 #define UART_PUT_RPR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_RPR)
_

Patches currently in -mm which might be from trimarchimichael@yahoo.it are

origin.patch
jffs2-summary-allocation-dont-use-vmalloc.patch

