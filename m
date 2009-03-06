From: akpm@linux-foundation.org
Subject: + blackfin-serial-driver-add-a-debug-function-to-serial-driver.patch added to -mm tree
Date: Fri, 06 Mar 2009 14:37:02 -0800
Message-ID: <200903062237.n26Mb2vO006997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681AbZCFWhv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 17:37:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: graf.yang@analog.com, alan@lxorguk.ukuu.org.uk, cooloney@kernel.org


The patch titled
     blackfin serial driver: add a debug function to serial driver
has been added to the -mm tree.  Its filename is
     blackfin-serial-driver-add-a-debug-function-to-serial-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin serial driver: add a debug function to serial driver
From: Graf Yang <graf.yang@analog.com>

This is used by several of the succeeding bugfix patches.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_5xx.c |   44 ++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff -puN drivers/serial/bfin_5xx.c~blackfin-serial-driver-add-a-debug-function-to-serial-driver drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~blackfin-serial-driver-add-a-debug-function-to-serial-driver
+++ a/drivers/serial/bfin_5xx.c
@@ -21,6 +21,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/serial_core.h>
+#include <stdarg.h>
 
 #if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
 	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
@@ -1177,6 +1178,49 @@ struct console __init *bfin_earlyserial_
 
 #endif /* CONFIG_EARLY_PRINTK */
 
+#ifdef CONFIG_DEBUG_KERNEL
+void bfin_serial_debug(const char *fmt, ...)
+{
+	struct bfin_serial_port *uart = &bfin_serial_ports[0];
+	unsigned short status, tmp;
+	int flags, i, count;
+	char buf[128];
+	va_list ap;
+
+	if (bfin_serial_console.index < 0)
+		return;		/* Too early. */
+
+	va_start(ap, fmt);
+	vsprintf(buf, fmt, ap);
+	va_end(ap);
+	count = strlen(buf);
+
+	spin_lock_irqsave(&uart->port.lock, flags);
+
+	for (i = 0; i < count; i++) {
+		do {
+			status = UART_GET_LSR(uart);
+		} while (!(status & THRE));
+
+#ifndef CONFIG_BF54x
+		tmp = UART_GET_LCR(uart);
+		tmp &= ~DLAB;
+		UART_PUT_LCR(uart, tmp);
+#endif
+		UART_PUT_CHAR(uart, buf[i]);
+		if (buf[i] == '\n') {
+			do {
+				status = UART_GET_LSR(uart);
+			} while (!(status & THRE));
+			UART_PUT_CHAR(uart, '\r');
+		}
+	}
+
+	spin_unlock_irqrestore(&uart->port.lock, flags);
+}
+EXPORT_SYMBOL(bfin_serial_debug);
+#endif
+
 static struct uart_driver bfin_serial_reg = {
 	.owner			= THIS_MODULE,
 	.driver_name		= "bfin-uart",
_

Patches currently in -mm which might be from graf.yang@analog.com are

linux-next.patch
mtd-cfi-fix-bug-bonnie-error-on-bf548-nor-flash.patch
blackfin-serial-driver-add-a-debug-function-to-serial-driver.patch
blackfin-serial-driver-use-barrier-instead-of-cpu_relax-for-blackfin-smp-like-patch.patch
blackfin-serial-driver-fix-bug-up-arrow-key-works-abnormal-for-bf561-ezkit-board.patch

