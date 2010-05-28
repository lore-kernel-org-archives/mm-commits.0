From: akpm@linux-foundation.org
Subject: + altera_uart-dont-take-spinlock-in-already-protected-functions.patch added to -mm tree
Date: Fri, 28 May 2010 13:39:36 -0700
Message-ID: <201005282039.o4SKdaMo012225@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756766Ab0E1Uj4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 May 2010 16:39:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tklauser@distanz.ch, abbotti@mev.co.uk, alan@lxorguk.ukuu.org.uk, greg@kroah.com, stable@kernel.org, thomas@wytron.com.tw


The patch titled
     altera_uart: don't take spinlock in already protected functions
has been added to the -mm tree.  Its filename is
     altera_uart-dont-take-spinlock-in-already-protected-functions.patch

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
Subject: altera_uart: don't take spinlock in already protected functions
From: Tobias Klauser <tklauser@distanz.ch>

Don't take the port spinlock in uart functions where the serial core
already takes care of locking/unlocking them.

The code would actually lock up on architectures where spinlocks are
implemented (not the case on nios2 where this driver is primarily used
for now, thus this bug didn't trigger).

Also protect calling altera_uart_rx_chars/altera_uart_tx_chars in the
interrupt handler by the port spinlock.

Thanks to Ian Abbott for pointing these issues out.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Thomas Chou <thomas@wytron.com.tw>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/altera_uart.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff -puN drivers/serial/altera_uart.c~altera_uart-dont-take-spinlock-in-already-protected-functions drivers/serial/altera_uart.c
--- a/drivers/serial/altera_uart.c~altera_uart-dont-take-spinlock-in-already-protected-functions
+++ a/drivers/serial/altera_uart.c
@@ -89,15 +89,12 @@ static unsigned int altera_uart_tx_empty
 static unsigned int altera_uart_get_mctrl(struct uart_port *port)
 {
 	struct altera_uart *pp = container_of(port, struct altera_uart, port);
-	unsigned long flags;
 	unsigned int sigs;
 
-	spin_lock_irqsave(&port->lock, flags);
 	sigs =
 	    (readl(port->membase + ALTERA_UART_STATUS_REG) &
 	     ALTERA_UART_STATUS_CTS_MSK) ? TIOCM_CTS : 0;
 	sigs |= (pp->sigs & TIOCM_RTS);
-	spin_unlock_irqrestore(&port->lock, flags);
 
 	return sigs;
 }
@@ -105,49 +102,37 @@ static unsigned int altera_uart_get_mctr
 static void altera_uart_set_mctrl(struct uart_port *port, unsigned int sigs)
 {
 	struct altera_uart *pp = container_of(port, struct altera_uart, port);
-	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
 	pp->sigs = sigs;
 	if (sigs & TIOCM_RTS)
 		pp->imr |= ALTERA_UART_CONTROL_RTS_MSK;
 	else
 		pp->imr &= ~ALTERA_UART_CONTROL_RTS_MSK;
 	writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
-	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 static void altera_uart_start_tx(struct uart_port *port)
 {
 	struct altera_uart *pp = container_of(port, struct altera_uart, port);
-	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
 	pp->imr |= ALTERA_UART_CONTROL_TRDY_MSK;
 	writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
-	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 static void altera_uart_stop_tx(struct uart_port *port)
 {
 	struct altera_uart *pp = container_of(port, struct altera_uart, port);
-	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
 	pp->imr &= ~ALTERA_UART_CONTROL_TRDY_MSK;
 	writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
-	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 static void altera_uart_stop_rx(struct uart_port *port)
 {
 	struct altera_uart *pp = container_of(port, struct altera_uart, port);
-	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
 	pp->imr &= ~ALTERA_UART_CONTROL_RRDY_MSK;
 	writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
-	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 static void altera_uart_break_ctl(struct uart_port *port, int break_state)
@@ -272,10 +257,14 @@ static irqreturn_t altera_uart_interrupt
 	unsigned int isr;
 
 	isr = readl(port->membase + ALTERA_UART_STATUS_REG) & pp->imr;
+
+	spin_lock(&port->lock);
 	if (isr & ALTERA_UART_STATUS_RRDY_MSK)
 		altera_uart_rx_chars(pp);
 	if (isr & ALTERA_UART_STATUS_TRDY_MSK)
 		altera_uart_tx_chars(pp);
+	spin_unlock(&port->lock);
+
 	return IRQ_RETVAL(isr);
 }
 
_

Patches currently in -mm which might be from tklauser@distanz.ch are

origin.patch
linux-next.patch
altera_uart-dont-take-spinlock-in-already-protected-functions.patch
altera_uart-simplify-altera_uart_console_putc.patch

