From: akpm@linux-foundation.org
Subject: - serial-dz11-avoid-a-hang-at-console-switch-over.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:28:16 -0700
Message-ID: <200807242328.m6ONSGfx011244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756500AbYGXX2c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:28:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     serial: DZ11: avoid a hang at console switch-over
has been removed from the -mm tree.  Its filename was
     serial-dz11-avoid-a-hang-at-console-switch-over.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: DZ11: avoid a hang at console switch-over
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Changes to the generic console support code that happened a while ago
introduced a scenario where the initial console is used in parallel with
the final console during a brief period when switching between the two is
in progress.  During that time a message about the switch-over is printed.

With some combinations of chips, firmware and drivers, such as the DEC
DZ11 clone used with the DECstation, a hang may happen because the
firmware used for the initial console may not expect the state of the chip
after it has been initialised by the driver.

This is a workaround for the DZ11 which reuses the power-management
callback to keep the transmitter of the line associated with the console
enabled.  It reflects the consensus reached in a discussion a while ago.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/dz.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN drivers/serial/dz.c~serial-dz11-avoid-a-hang-at-console-switch-over drivers/serial/dz.c
--- a/drivers/serial/dz.c~serial-dz11-avoid-a-hang-at-console-switch-over
+++ a/drivers/serial/dz.c
@@ -642,6 +642,26 @@ static void dz_set_termios(struct uart_p
 	spin_unlock_irqrestore(&dport->port.lock, flags);
 }
 
+/*
+ * Hack alert!
+ * Required solely so that the initial PROM-based console
+ * works undisturbed in parallel with this one.
+ */
+static void dz_pm(struct uart_port *uport, unsigned int state,
+		  unsigned int oldstate)
+{
+	struct dz_port *dport = to_dport(uport);
+	unsigned long flags;
+
+	spin_lock_irqsave(&dport->port.lock, flags);
+	if (state < 3)
+		dz_start_tx(&dport->port);
+	else
+		dz_stop_tx(&dport->port);
+	spin_unlock_irqrestore(&dport->port.lock, flags);
+}
+
+
 static const char *dz_type(struct uart_port *uport)
 {
 	return "DZ";
@@ -738,6 +758,7 @@ static struct uart_ops dz_ops = {
 	.startup	= dz_startup,
 	.shutdown	= dz_shutdown,
 	.set_termios	= dz_set_termios,
+	.pm		= dz_pm,
 	.type		= dz_type,
 	.release_port	= dz_release_port,
 	.request_port	= dz_request_port,
@@ -861,7 +882,10 @@ static int __init dz_console_setup(struc
 	if (ret)
 		return ret;
 
+	spin_lock_init(&dport->port.lock);	/* For dz_pm().  */
+
 	dz_reset(dport);
+	dz_pm(uport, 0, -1);
 
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
linux-next.patch
ntp-let-update_persistent_clock-sleep.patch
ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch

