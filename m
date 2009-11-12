From: akpm@linux-foundation.org
Subject: + atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch added to -mm tree
Date: Thu, 12 Nov 2009 14:25:29 -0800
Message-ID: <200911122225.nACMPTWR004788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754706AbZKLW0H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 17:26:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: albin.tonnerre@free-electrons.com, alan@lxorguk.ukuu.org.uk, haavard.skinnemoen@atmel.com, linux@maxim.org.za


The patch titled
     atmel_serial: add poll_get_char and poll_put_char uart_ops
has been added to the -mm tree.  Its filename is
     atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch

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
Subject: atmel_serial: add poll_get_char and poll_put_char uart_ops
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>

Permits using KGDB over the console with the atmel_serial driver.

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops
+++ a/drivers/serial/atmel_serial.c
@@ -1213,6 +1213,24 @@ static int atmel_verify_port(struct uart
 	return ret;
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+static int atmel_poll_get_char(struct uart_port *port)
+{
+	while (!(UART_GET_CSR(port) & ATMEL_US_RXRDY))
+		barrier();
+
+	return UART_GET_CHAR(port);
+}
+
+static void atmel_poll_put_char(struct uart_port *port, unsigned char ch)
+{
+	while (!(UART_GET_CSR(port) & ATMEL_US_TXRDY))
+		barrier();
+
+	UART_PUT_CHAR(port, ch);
+}
+#endif
+
 static struct uart_ops atmel_pops = {
 	.tx_empty	= atmel_tx_empty,
 	.set_mctrl	= atmel_set_mctrl,
@@ -1232,6 +1250,10 @@ static struct uart_ops atmel_pops = {
 	.config_port	= atmel_config_port,
 	.verify_port	= atmel_verify_port,
 	.pm		= atmel_serial_pm,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_get_char	= atmel_poll_get_char,
+	.poll_put_char	= atmel_poll_put_char,
+#endif
 };
 
 /*
_

Patches currently in -mm which might be from albin.tonnerre@free-electrons.com are

linux-next.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops-fix.patch

