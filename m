From: akpm@linux-foundation.org
Subject: + serial-bfin_5xx-remove-useless-gpio-handling-with-hard-flow-control.patch added to -mm tree
Date: Mon, 25 Jan 2010 16:11:28 -0800
Message-ID: <201001260011.o0Q0BT9i019455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396Ab0AZALi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 19:11:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sonic.zhang@analog.com, alan@lxorguk.ukuu.org.uk, vapier@gentoo.org


The patch titled
     serial: bfin_5xx: remove useless gpio handling with hard flow control
has been added to the -mm tree.  Its filename is
     serial-bfin_5xx-remove-useless-gpio-handling-with-hard-flow-control.patch

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
Subject: serial: bfin_5xx: remove useless gpio handling with hard flow control
From: Sonic Zhang <sonic.zhang@analog.com>

For UARTs that have dedicated hardware flow control support, there will be
no gpios to request/free as they are part of the normal peripheral pins.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_5xx.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff -puN drivers/serial/bfin_5xx.c~serial-bfin_5xx-remove-useless-gpio-handling-with-hard-flow-control drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~serial-bfin_5xx-remove-useless-gpio-handling-with-hard-flow-control
+++ a/drivers/serial/bfin_5xx.c
@@ -746,15 +746,6 @@ static int bfin_serial_startup(struct ua
 			Status interrupt.\n");
 	}
 
-	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, DRIVER_NAME);
-		gpio_direction_output(uart->cts_pin, 1);
-	}
-	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, DRIVER_NAME);
-		gpio_direction_output(uart->rts_pin, 0);
-	}
-
 	/* CTS RTS PINs are negative assertive. */
 	UART_PUT_MCR(uart, ACTS);
 	UART_SET_IER(uart, EDSSI);
@@ -801,10 +792,6 @@ static void bfin_serial_shutdown(struct 
 		gpio_free(uart->rts_pin);
 #endif
 #ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
-	if (uart->cts_pin >= 0)
-		gpio_free(uart->cts_pin);
-	if (uart->rts_pin >= 0)
-		gpio_free(uart->rts_pin);
 	if (UART_GET_IER(uart) && EDSSI)
 		free_irq(uart->status_irq, uart);
 #endif
@@ -1409,8 +1396,7 @@ static int bfin_serial_remove(struct pla
 			continue;
 		uart_remove_one_port(&bfin_serial_reg, &bfin_serial_ports[i].port);
 		bfin_serial_ports[i].port.dev = NULL;
-#if defined(CONFIG_SERIAL_BFIN_CTSRTS) || \
-	defined(CONFIG_SERIAL_BFIN_HARD_CTSRTS)
+#if defined(CONFIG_SERIAL_BFIN_CTSRTS)
 		gpio_free(bfin_serial_ports[i].cts_pin);
 		gpio_free(bfin_serial_ports[i].rts_pin);
 #endif
_

Patches currently in -mm which might be from sonic.zhang@analog.com are

linux-next.patch
serial-bfin_5xx-remove-useless-gpio-handling-with-hard-flow-control.patch
serial-bfin_5xx-kgdboc-should-accept-gdb-break-only-when-it-is-active.patch
serial-bfin_5xx-pull-in-linux-ioh-for-ioremap-prototypes.patch

