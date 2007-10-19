From: akpm@linux-foundation.org
Subject: + dz-fix-locking-issues.patch added to -mm tree
Date: Fri, 19 Oct 2007 14:26:06 -0700
Message-ID: <200710192126.l9JLQ6sx020949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35374 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934007AbXJSV0t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 17:26:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, jirislaby@gmail.com


The patch titled
     dz: fix locking issues
has been added to the -mm tree.  Its filename is
     dz-fix-locking-issues.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dz: fix locking issues
From: "Maciej W. Rozycki" <macro@linux-mips.org>

The ->start_tx(), ->stop_tx() and ->stop_rx() backends are called with the
port's lock already taken.  Remove locking from within them and wrap around
calls as necessary.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/dz.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff -puN drivers/serial/dz.c~dz-fix-locking-issues drivers/serial/dz.c
--- a/drivers/serial/dz.c~dz-fix-locking-issues
+++ a/drivers/serial/dz.c
@@ -108,37 +108,28 @@ static void dz_stop_tx(struct uart_port 
 {
 	struct dz_port *dport = (struct dz_port *)uport;
 	unsigned short tmp, mask = 1 << dport->port.line;
-	unsigned long flags;
 
-	spin_lock_irqsave(&dport->port.lock, flags);
 	tmp = dz_in(dport, DZ_TCR);	/* read the TX flag */
 	tmp &= ~mask;			/* clear the TX flag */
 	dz_out(dport, DZ_TCR, tmp);
-	spin_unlock_irqrestore(&dport->port.lock, flags);
 }
 
 static void dz_start_tx(struct uart_port *uport)
 {
 	struct dz_port *dport = (struct dz_port *)uport;
 	unsigned short tmp, mask = 1 << dport->port.line;
-	unsigned long flags;
 
-	spin_lock_irqsave(&dport->port.lock, flags);
 	tmp = dz_in(dport, DZ_TCR);	/* read the TX flag */
 	tmp |= mask;			/* set the TX flag */
 	dz_out(dport, DZ_TCR, tmp);
-	spin_unlock_irqrestore(&dport->port.lock, flags);
 }
 
 static void dz_stop_rx(struct uart_port *uport)
 {
 	struct dz_port *dport = (struct dz_port *)uport;
-	unsigned long flags;
 
-	spin_lock_irqsave(&dport->port.lock, flags);
 	dport->cflag &= ~DZ_CREAD;
 	dz_out(dport, DZ_LPR, dport->cflag | dport->port.line);
-	spin_unlock_irqrestore(&dport->port.lock, flags);
 }
 
 static void dz_enable_ms(struct uart_port *port)
@@ -268,7 +259,9 @@ static inline void dz_transmit_chars(str
 	}
 	/* If nothing to do or stopped or hardware stopped. */
 	if (uart_circ_empty(xmit) || uart_tx_stopped(&dport->port)) {
+		spin_lock(&dport->port.lock);
 		dz_stop_tx(&dport->port);
+		spin_unlock(&dport->port.lock);
 		return;
 	}
 
@@ -285,8 +278,11 @@ static inline void dz_transmit_chars(str
 		uart_write_wakeup(&dport->port);
 
 	/* Are we are done. */
-	if (uart_circ_empty(xmit))
+	if (uart_circ_empty(xmit)) {
+		spin_lock(&dport->port.lock);
 		dz_stop_tx(&dport->port);
+		spin_unlock(&dport->port.lock);
+	}
 }
 
 /*
@@ -417,7 +413,12 @@ static int dz_startup(struct uart_port *
  */
 static void dz_shutdown(struct uart_port *uport)
 {
-	dz_stop_tx(uport);
+	struct dz_port *dport = (struct dz_port *)uport;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dport->port.lock, flags);
+	dz_stop_tx(&dport->port);
+	spin_unlock_irqrestore(&dport->port.lock, flags);
 }
 
 /*
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
kernel-printkc-concerns-about-the-console-handover.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
