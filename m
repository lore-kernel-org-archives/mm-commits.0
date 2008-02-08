From: akpm@linux-foundation.org
Subject: - dzc-use-a-helper-to-cast-from-struct-uart_port.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:06:32 -0800
Message-ID: <200802080806.m1886DT6014414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43126 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760767AbYBHITu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     dz.c: Use a helper to cast from "struct uart_port *"
has been removed from the -mm tree.  Its filename was
     dzc-use-a-helper-to-cast-from-struct-uart_port.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dz.c: Use a helper to cast from "struct uart_port *"
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Replace all casts from "struct uart_port *" to "struct dz_port *" with a
construct based on container_of().  This makes the conversion work
irrespective of where the former struct is located within the latter.

By popular request I have implemented it as an inline function rather than
a macro this time.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/dz.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff -puN drivers/serial/dz.c~dzc-use-a-helper-to-cast-from-struct-uart_port drivers/serial/dz.c
--- a/drivers/serial/dz.c~dzc-use-a-helper-to-cast-from-struct-uart_port
+++ a/drivers/serial/dz.c
@@ -68,6 +68,11 @@ struct dz_port {
 
 static struct dz_port dz_ports[DZ_NB_PORT];
 
+static inline struct dz_port *to_dport(struct uart_port *uport)
+{
+	return container_of(uport, struct dz_port, port);
+}
+
 /*
  * ------------------------------------------------------------
  * dz_in () and dz_out ()
@@ -106,7 +111,7 @@ static inline void dz_out(struct dz_port
 
 static void dz_stop_tx(struct uart_port *uport)
 {
-	struct dz_port *dport = (struct dz_port *)uport;
+	struct dz_port *dport = to_dport(uport);
 	unsigned short tmp, mask = 1 << dport->port.line;
 
 	tmp = dz_in(dport, DZ_TCR);	/* read the TX flag */
@@ -116,7 +121,7 @@ static void dz_stop_tx(struct uart_port 
 
 static void dz_start_tx(struct uart_port *uport)
 {
-	struct dz_port *dport = (struct dz_port *)uport;
+	struct dz_port *dport = to_dport(uport);
 	unsigned short tmp, mask = 1 << dport->port.line;
 
 	tmp = dz_in(dport, DZ_TCR);	/* read the TX flag */
@@ -126,7 +131,7 @@ static void dz_start_tx(struct uart_port
 
 static void dz_stop_rx(struct uart_port *uport)
 {
-	struct dz_port *dport = (struct dz_port *)uport;
+	struct dz_port *dport = to_dport(uport);
 
 	dport->cflag &= ~DZ_RXENAB;
 	dz_out(dport, DZ_LPR, dport->cflag);
@@ -349,7 +354,7 @@ static unsigned int dz_get_mctrl(struct 
 	/*
 	 * FIXME: Handle the 3100/5000 as appropriate. --macro
 	 */
-	struct dz_port *dport = (struct dz_port *)uport;
+	struct dz_port *dport = to_dport(uport);
 	unsigned int mctrl = TIOCM_CAR | TIOCM_DSR | TIOCM_CTS;
 
 	if (dport->port.line == DZ_MODEM) {
@@ -365,7 +370,7 @@ static void dz_set_mctrl(struct uart_por
 	/*
 	 * FIXME: Handle the 3100/5000 as appropriate. --macro
 	 */
-	struct dz_port *dport = (struct dz_port *)uport;
+	struct dz_port *dport = to_dport(uport);
 	unsigned short tmp;
 
 	if (dport->port.line == DZ_MODEM) {
@@ -387,7 +392,7 @@ static void dz_set_mctrl(struct uart_por
  */
 static int dz_startup(struct uart_port *uport)
 {
-	struct dz_port *dport = (struct dz_port *)uport;
+	struct dz_port *dport = to_dport(uport);
 	unsigned long flags;
 	unsigned short tmp;
 
@@ -413,7 +418,7 @@ static int dz_startup(struct uart_port *
  */
 static void dz_shutdown(struct uart_port *uport)
 {
-	struct dz_port *dport = (struct dz_port *)uport;
+	struct dz_port *dport = to_dport(uport);
 	unsigned long flags;
 
 	spin_lock_irqsave(&dport->port.lock, flags);
@@ -435,7 +440,7 @@ static void dz_shutdown(struct uart_port
  */
 static unsigned int dz_tx_empty(struct uart_port *uport)
 {
-	struct dz_port *dport = (struct dz_port *)uport;
+	struct dz_port *dport = to_dport(uport);
 	unsigned short tmp, mask = 1 << dport->port.line;
 
 	tmp = dz_in(dport, DZ_TCR);
@@ -450,7 +455,7 @@ static void dz_break_ctl(struct uart_por
 	 * FIXME: Can't access BREAK bits in TDR easily;
 	 * reuse the code for polled TX. --macro
 	 */
-	struct dz_port *dport = (struct dz_port *)uport;
+	struct dz_port *dport = to_dport(uport);
 	unsigned long flags;
 	unsigned short tmp, mask = 1 << dport->port.line;
 
@@ -505,7 +510,7 @@ static int dz_encode_baud_rate(unsigned 
 static void dz_set_termios(struct uart_port *uport, struct ktermios *termios,
 			   struct ktermios *old_termios)
 {
-	struct dz_port *dport = (struct dz_port *)uport;
+	struct dz_port *dport = to_dport(uport);
 	unsigned long flags;
 	unsigned int cflag, baud;
 	int bflag;
@@ -685,7 +690,7 @@ static void dz_reset(struct dz_port *dpo
  */
 static void dz_console_putchar(struct uart_port *uport, int ch)
 {
-	struct dz_port *dport = (struct dz_port *)uport;
+	struct dz_port *dport = to_dport(uport);
 	unsigned long flags;
 	unsigned short csr, tcr, trdy, mask;
 	int loops = 10000;
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
