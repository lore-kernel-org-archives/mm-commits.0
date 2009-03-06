From: akpm@linux-foundation.org
Subject: + blackfin-serial-driver-merge-the-upstream-adeos-xenomai.patch added to -mm tree
Date: Fri, 06 Mar 2009 14:37:34 -0800
Message-ID: <200903062237.n26MbY2V007071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754942AbZCFWiV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 17:38:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpm@xenomai.org, alan@lxorguk.ukuu.org.uk, cooloney@kernel.org


The patch titled
     blackfin serial driver: merge the upstream adeos/xenomai
has been added to the -mm tree.  Its filename is
     blackfin-serial-driver-merge-the-upstream-adeos-xenomai.patch

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
Subject: blackfin serial driver: merge the upstream adeos/xenomai
From: Philippe Gerum <rpm@xenomai.org>

Add ipipe serial debug function for adeos.

Signed-off-by: Philippe Gerum <rpm@xenomai.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_5xx.c |   45 ++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff -puN drivers/serial/bfin_5xx.c~blackfin-serial-driver-merge-the-upstream-adeos-xenomai drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~blackfin-serial-driver-merge-the-upstream-adeos-xenomai
+++ a/drivers/serial/bfin_5xx.c
@@ -1145,6 +1145,51 @@ static void bfin_serial_console_putchar(
 	SSYNC();
 }
 
+#ifdef CONFIG_IPIPE
+
+#include <stdarg.h>
+
+void __ipipe_serial_debug(const char *fmt, ...)
+{
+	struct bfin_serial_port *uart = &bfin_serial_ports[0];
+	unsigned short status, tmp;
+	int flags, i, count;
+	char buf[128];
+	va_list ap;
+
+	va_start(ap, fmt);
+	vsprintf(buf, fmt, ap);
+	va_end(ap);
+	count = strlen(buf);
+
+	local_irq_save_hw(flags);
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
+
+		UART_PUT_CHAR(uart, buf[i]);
+		if (buf[i] == '\n') {
+			do {
+				status = UART_GET_LSR(uart);
+			} while (!(status & THRE));
+			UART_PUT_CHAR(uart, '\r');
+		}
+	}
+
+	local_irq_restore_hw(flags);
+}
+EXPORT_SYMBOL(__ipipe_serial_debug);
+
+#endif /* CONFIG_IPIPE */
+
 /*
  * Interrupts are disabled on entering
  */
_

Patches currently in -mm which might be from rpm@xenomai.org are

linux-next.patch
blackfin-serial-driver-merge-the-upstream-adeos-xenomai.patch

