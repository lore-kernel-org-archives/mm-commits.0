From: akpm@linux-foundation.org
Subject: + serial-mcf-dont-take-spinlocks-in-already-protected-functions.patch added to -mm tree
Date: Mon, 14 Jun 2010 12:12:47 -0700
Message-ID: <201006141912.o5EJClVX025753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753829Ab0FNTNB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 15:13:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ygeorgie@gmail.com, alan@lxorguk.ukuu.org.uk, gerg@uclinux.org, greg@kroah.com


The patch titled
     serial: mcf: don't take spinlocks in already protected functions
has been added to the -mm tree.  Its filename is
     serial-mcf-dont-take-spinlocks-in-already-protected-functions.patch

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
Subject: serial: mcf: don't take spinlocks in already protected functions
From: Yury Georgievskiy <ygeorgie@gmail.com>

Don't take the port spinlock in uart functions where the serial core
already takes care of locking/unlocking them.

The code would actually lock up on architectures where spinlocks are
implemented.

Also protect calling mcf_rx_chars/mcf_tx_chars in the interrupt handler by
the port spinlock and use IRQ_RETVAL to return from isr.

Signed-off-by: Yury Georgievskiy <ygeorgie@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/mcf.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff -puN drivers/serial/mcf.c~serial-mcf-dont-take-spinlocks-in-already-protected-functions drivers/serial/mcf.c
--- a/drivers/serial/mcf.c~serial-mcf-dont-take-spinlocks-in-already-protected-functions
+++ a/drivers/serial/mcf.c
@@ -70,16 +70,14 @@ static unsigned int mcf_tx_empty(struct 
 static unsigned int mcf_get_mctrl(struct uart_port *port)
 {
 	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
-	unsigned long flags;
 	unsigned int sigs;
 
-	spin_lock_irqsave(&port->lock, flags);
 	sigs = (readb(port->membase + MCFUART_UIPR) & MCFUART_UIPR_CTS) ?
 		0 : TIOCM_CTS;
 	sigs |= (pp->sigs & TIOCM_RTS);
 	sigs |= (mcf_getppdcd(port->line) ? TIOCM_CD : 0);
 	sigs |= (mcf_getppdtr(port->line) ? TIOCM_DTR : 0);
-	spin_unlock_irqrestore(&port->lock, flags);
+
 	return sigs;
 }
 
@@ -88,16 +86,13 @@ static unsigned int mcf_get_mctrl(struct
 static void mcf_set_mctrl(struct uart_port *port, unsigned int sigs)
 {
 	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
-	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
 	pp->sigs = sigs;
 	mcf_setppdtr(port->line, (sigs & TIOCM_DTR));
 	if (sigs & TIOCM_RTS)
 		writeb(MCFUART_UOP_RTS, port->membase + MCFUART_UOP1);
 	else
 		writeb(MCFUART_UOP_RTS, port->membase + MCFUART_UOP0);
-	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 /****************************************************************************/
@@ -105,12 +100,9 @@ static void mcf_set_mctrl(struct uart_po
 static void mcf_start_tx(struct uart_port *port)
 {
 	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
-	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
 	pp->imr |= MCFUART_UIR_TXREADY;
 	writeb(pp->imr, port->membase + MCFUART_UIMR);
-	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 /****************************************************************************/
@@ -118,12 +110,9 @@ static void mcf_start_tx(struct uart_por
 static void mcf_stop_tx(struct uart_port *port)
 {
 	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
-	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
 	pp->imr &= ~MCFUART_UIR_TXREADY;
 	writeb(pp->imr, port->membase + MCFUART_UIMR);
-	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 /****************************************************************************/
@@ -131,12 +120,9 @@ static void mcf_stop_tx(struct uart_port
 static void mcf_stop_rx(struct uart_port *port)
 {
 	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
-	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
 	pp->imr &= ~MCFUART_UIR_RXREADY;
 	writeb(pp->imr, port->membase + MCFUART_UIMR);
-	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 /****************************************************************************/
@@ -368,11 +354,15 @@ static irqreturn_t mcf_interrupt(int irq
 	unsigned int isr;
 
 	isr = readb(port->membase + MCFUART_UISR) & pp->imr;
+
+	spin_lock(&port->lock);
 	if (isr & MCFUART_UIR_RXREADY)
 		mcf_rx_chars(pp);
 	if (isr & MCFUART_UIR_TXREADY)
 		mcf_tx_chars(pp);
-	return IRQ_HANDLED;
+	spin_unlock(&port->lock);
+
+	return IRQ_RETVAL(isr);
 }
 
 /****************************************************************************/
_

Patches currently in -mm which might be from ygeorgie@gmail.com are

serial-mcf-dont-take-spinlocks-in-already-protected-functions.patch
serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix.patch

