From: akpm@linux-foundation.org
Subject: - dz-fix-locking-issues.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:06:25 -0800
Message-ID: <200802080806.m18866iI014405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50934 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761796AbYBHITp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     dz: fix locking issues
has been removed from the -mm tree.  Its filename was
     dz-fix-locking-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
