From: akpm@linux-foundation.org
Subject: + serial-16c950-add-preliminary-support-for-9-bit-receive-and-transmit.patch added to -mm tree
Date: Mon, 23 Nov 2009 13:35:11 -0800
Message-ID: <200911232135.nANLZBVw011164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754782AbZKWVfR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 16:35:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jpinkasfeld@aldebaran-robotics.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com


The patch titled
     serial 16c950: add preliminary support for 9-bit receive and transmit
has been added to the -mm tree.  Its filename is
     serial-16c950-add-preliminary-support-for-9-bit-receive-and-transmit.patch

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
Subject: serial 16c950: add preliminary support for 9-bit receive and transmit
From: Joseph Pinkasfeld <jpinkasfeld@aldebaran-robotics.com>

2 bytes must be written or read for transmiting or receiving 9-bit data
first byte LSB is ninth bit, second byte is normal data.

Signed-off-by: pinkasfeld joseph <jpinkasfeld@aldebaran-robotics.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |   54 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 49 insertions(+), 5 deletions(-)

diff -puN drivers/serial/8250.c~serial-16c950-add-preliminary-support-for-9-bit-receive-and-transmit drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-16c950-add-preliminary-support-for-9-bit-receive-and-transmit
+++ a/drivers/serial/8250.c
@@ -137,6 +137,7 @@ struct uart_8250_port {
 	unsigned short		bugs;		/* port bugs */
 	unsigned int		tx_loadsz;	/* transmit fifo load size */
 	unsigned char		acr;
+	unsigned char		nmr;
 	unsigned char		ier;
 	unsigned char		lcr;
 	unsigned char		mcr;
@@ -838,6 +839,7 @@ static void autoconfig_has_efr(struct ua
 	 * recommended for new designs).
 	 */
 	up->acr = 0;
+	up->nmr = 0;
 	serial_out(up, UART_LCR, 0xBF);
 	serial_out(up, UART_EFR, UART_EFR_ECB);
 	serial_out(up, UART_LCR, 0x00);
@@ -1380,8 +1382,8 @@ static void
 receive_chars(struct uart_8250_port *up, unsigned int *status)
 {
 	struct tty_struct *tty = up->port.state->port.tty;
-	unsigned char ch, lsr = *status;
-	int max_count = 256;
+	unsigned char ch, ch9, lsr = *status;
+	int error_break = 0, max_count = 256;
 	char flag;
 
 	do {
@@ -1403,7 +1405,20 @@ receive_chars(struct uart_8250_port *up,
 		lsr |= up->lsr_saved_flags;
 		up->lsr_saved_flags = 0;
 
-		if (unlikely(lsr & UART_LSR_BRK_ERROR_BITS)) {
+		/*
+		 * Due to sharing of bit 2 in LSR depending on 9 bits mode
+		 * bit 2 rise Parity Error or 9th bit read
+		 */
+		error_break = 0 ;
+		if (up->nmr & UART_NMR_9BENB) {
+			if (lsr & UART_LSR_NBM_BRK_ERROR_BITS)
+				error_break = 1;
+		} else {
+			if (lsr & UART_LSR_BRK_ERROR_BITS)
+				error_break = 1;
+		}
+
+		if (unlikely(error_break)) {
 			/*
 			 * For statistics only
 			 */
@@ -1418,7 +1433,8 @@ receive_chars(struct uart_8250_port *up,
 				 */
 				if (uart_handle_break(&up->port))
 					goto ignore_char;
-			} else if (lsr & UART_LSR_PE)
+			} else if ((lsr & UART_LSR_PE) &&
+				!(up->nmr & UART_NMR_9BENB))
 				up->port.icount.parity++;
 			else if (lsr & UART_LSR_FE)
 				up->port.icount.frame++;
@@ -1433,7 +1449,8 @@ receive_chars(struct uart_8250_port *up,
 			if (lsr & UART_LSR_BI) {
 				DEBUG_INTR("handling break....");
 				flag = TTY_BREAK;
-			} else if (lsr & UART_LSR_PE)
+			} else if ((lsr & UART_LSR_PE) &&
+				!(up->nmr & UART_NMR_9BENB))
 				flag = TTY_PARITY;
 			else if (lsr & UART_LSR_FE)
 				flag = TTY_FRAME;
@@ -1441,6 +1458,16 @@ receive_chars(struct uart_8250_port *up,
 		if (uart_handle_sysrq_char(&up->port, ch))
 			goto ignore_char;
 
+		/*
+		 * In 9bit mode Parity error is replace by 9th bit
+		 */
+		if (up->nmr & UART_NMR_9BENB) {
+			if (lsr & UART_LSR_9TH_BIT)
+				ch9 = 1;
+			else
+				ch9 = 0;
+			uart_insert_char(&up->port, lsr, UART_LSR_OE, ch9, flag);
+		}
 		uart_insert_char(&up->port, lsr, UART_LSR_OE, ch, flag);
 
 ignore_char:
@@ -1474,6 +1501,13 @@ static void transmit_chars(struct uart_8
 
 	count = up->tx_loadsz;
 	do {
+		/* first byte contain 9th bit for 9 bit mode */
+		if ((up->nmr  & UART_NMR_9BENB)  && (count > 1) ){
+			serial_out(up, UART_SCR, 0x01 & xmit->buf[xmit->tail]);
+			xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
+			if (uart_circ_empty(xmit))
+				break;
+		}
 		serial_out(up, UART_TX, xmit->buf[xmit->tail]);
 		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
 		up->port.icount.tx++;
@@ -1949,6 +1983,7 @@ static int serial8250_startup(struct uar
 	if (up->port.type == PORT_16C950) {
 		/* Wake up and initialize UART */
 		up->acr = 0;
+		up->nmr = 0;
 		serial_outp(up, UART_LCR, 0xBF);
 		serial_outp(up, UART_EFR, UART_EFR_ECB);
 		serial_outp(up, UART_IER, 0);
@@ -2405,6 +2440,15 @@ serial8250_set_termios(struct uart_port 
 	/* Don't rewrite B0 */
 	if (tty_termios_baud_rate(termios))
 		tty_termios_encode_baud_rate(termios, baud, baud);
+
+	/*
+	 * 9-bit mode control flag on 16c950
+	 */
+	if (termios->c_cflag & CNBENB) {
+		up->nmr |= UART_NMR_9BENB;
+		serial_icr_write(up, UART_NMR, up->nmr);
+	}
+
 }
 
 static void
_

Patches currently in -mm which might be from jpinkasfeld@aldebaran-robotics.com are

serial-add-configuration-c-flag-for-9-bit-mode.patch
serial-16c950-add-preliminary-support-for-9-bit-receive-and-transmit.patch

