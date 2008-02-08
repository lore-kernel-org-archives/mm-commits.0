From: akpm@linux-foundation.org
Subject: - dz-handle-special-conditions-on-reception-correctly.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:06:27 -0800
Message-ID: <200802080806.m18868Zc014408@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32927 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761535AbYBHITv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     dz: handle special conditions on reception correctly
has been removed from the -mm tree.  Its filename was
     dz-handle-special-conditions-on-reception-correctly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dz: handle special conditions on reception correctly
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Handle the read and ignore status masks correctly.  Handle the BREAK condition
as expected: a framing error with a null character is a BREAK, any other
framing error is a framing error indeed.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/dz.c |   82 ++++++++++++++++++++++--------------------
 drivers/serial/dz.h |    2 +
 2 files changed, 46 insertions(+), 38 deletions(-)

diff -puN drivers/serial/dz.c~dz-handle-special-conditions-on-reception-correctly drivers/serial/dz.c
--- a/drivers/serial/dz.c~dz-handle-special-conditions-on-reception-correctly
+++ a/drivers/serial/dz.c
@@ -166,6 +166,7 @@ static void dz_enable_ms(struct uart_por
  */
 static inline void dz_receive_chars(struct dz_port *dport_in)
 {
+	struct uart_port *uport;
 	struct dz_port *dport;
 	struct tty_struct *tty = NULL;
 	struct uart_icount *icount;
@@ -176,57 +177,56 @@ static inline void dz_receive_chars(stru
 
 	while ((status = dz_in(dport_in, DZ_RBUF)) & DZ_DVAL) {
 		dport = &dz_ports[LINE(status)];
-		tty = dport->port.info->tty;	/* point to the proper dev */
+		uport = &dport->port;
+		tty = uport->info->tty;		/* point to the proper dev */
 
 		ch = UCHAR(status);		/* grab the char */
+		flag = TTY_NORMAL;
 
-		icount = &dport->port.icount;
+		icount = &uport->icount;
 		icount->rx++;
 
-		flag = TTY_NORMAL;
-		if (status & DZ_FERR) {		/* frame error */
+		if (unlikely(status & (DZ_OERR | DZ_FERR | DZ_PERR))) {
+
 			/*
-			 * There is no separate BREAK status bit, so
-			 * treat framing errors as BREAKs for Magic SysRq
-			 * and SAK; normally, otherwise.
+			 * There is no separate BREAK status bit, so treat
+			 * null characters with framing errors as BREAKs;
+			 * normally, otherwise.  For this move the Framing
+			 * Error bit to a simulated BREAK bit.
 			 */
-			if (uart_handle_break(&dport->port))
-				continue;
-			if (dport->port.flags & UPF_SAK)
+			if (!ch) {
+				status |= (status & DZ_FERR) >>
+					  (ffs(DZ_FERR) - ffs(DZ_BREAK));
+				status &= ~DZ_FERR;
+			}
+
+			/* Handle SysRq/SAK & keep track of the statistics. */
+			if (status & DZ_BREAK) {
+				icount->brk++;
+				if (uart_handle_break(uport))
+					continue;
+			} else if (status & DZ_FERR)
+				icount->frame++;
+			else if (status & DZ_PERR)
+				icount->parity++;
+			if (status & DZ_OERR)
+				icount->overrun++;
+
+			status &= uport->read_status_mask;
+			if (status & DZ_BREAK)
 				flag = TTY_BREAK;
-			else
+			else if (status & DZ_FERR)
 				flag = TTY_FRAME;
-		} else if (status & DZ_OERR)	/* overrun error */
-			flag = TTY_OVERRUN;
-		else if (status & DZ_PERR)	/* parity error */
-			flag = TTY_PARITY;
-
-		/* keep track of the statistics */
-		switch (flag) {
-		case TTY_FRAME:
-			icount->frame++;
-			break;
-		case TTY_PARITY:
-			icount->parity++;
-			break;
-		case TTY_OVERRUN:
-			icount->overrun++;
-			break;
-		case TTY_BREAK:
-			icount->brk++;
-			break;
-		default:
-			break;
+			else if (status & DZ_PERR)
+				flag = TTY_PARITY;
+
 		}
 
-		if (uart_handle_sysrq_char(&dport->port, ch))
+		if (uart_handle_sysrq_char(uport, ch))
 			continue;
 
-		if ((status & dport->port.ignore_status_mask) == 0) {
-			uart_insert_char(&dport->port,
-					 status, DZ_OERR, ch, flag);
-			lines_rx[LINE(status)] = 1;
-		}
+		uart_insert_char(uport, status, DZ_OERR, ch, flag);
+		lines_rx[LINE(status)] = 1;
 	}
 	for (i = 0; i < DZ_NB_PORT; i++)
 		if (lines_rx[i])
@@ -556,11 +556,17 @@ static void dz_set_termios(struct uart_p
 	dport->port.read_status_mask = DZ_OERR;
 	if (termios->c_iflag & INPCK)
 		dport->port.read_status_mask |= DZ_FERR | DZ_PERR;
+	if (termios->c_iflag & (BRKINT | PARMRK))
+		dport->port.read_status_mask |= DZ_BREAK;
 
 	/* characters to ignore */
 	uport->ignore_status_mask = 0;
+	if ((termios->c_iflag & (IGNPAR | IGNBRK)) == (IGNPAR | IGNBRK))
+		dport->port.ignore_status_mask |= DZ_OERR;
 	if (termios->c_iflag & IGNPAR)
 		dport->port.ignore_status_mask |= DZ_FERR | DZ_PERR;
+	if (termios->c_iflag & IGNBRK)
+		dport->port.ignore_status_mask |= DZ_BREAK;
 
 	spin_unlock_irqrestore(&dport->port.lock, flags);
 }
diff -puN drivers/serial/dz.h~dz-handle-special-conditions-on-reception-correctly drivers/serial/dz.h
--- a/drivers/serial/dz.h~dz-handle-special-conditions-on-reception-correctly
+++ a/drivers/serial/dz.h
@@ -33,6 +33,8 @@
 #define DZ_FERR        0x2000                 /* Frame error indicator */
 #define DZ_PERR        0x1000                 /* Parity error indicator */
 
+#define DZ_BREAK       0x0800                 /* BREAK event software flag */
+
 #define LINE(x) ((x & DZ_LINE_MASK) >> 8)     /* Get the line number
                                                  from the input buffer */
 #define UCHAR(x) ((unsigned char)(x & DZ_RBUF_MASK))
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
