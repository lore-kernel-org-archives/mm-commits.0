From: akpm@linux-foundation.org
Subject: + serial-z85c30-avoid-a-hang-at-console-switch-over.patch added to -mm tree
Date: Thu, 12 Jun 2008 16:15:14 -0700
Message-ID: <200806122315.m5CNFFjg012103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754966AbYFLXPd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 19:15:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com


The patch titled
     serial: Z85C30: avoid a hang at console switch-over
has been added to the -mm tree.  Its filename is
     serial-z85c30-avoid-a-hang-at-console-switch-over.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: Z85C30: avoid a hang at console switch-over
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Changes to the generic console support code that happened a while ago
introduced a scenario where the initial console is used in parallel with
the final console during a brief period when switching between the two is
in progress.  During that time a message about the switch-over is printed.

With some combinations of chips, firmware and drivers, such as the Zilog
Z85C30 SCC used with the DECstation, a hang may happen because the
firmware used for the initial console may not expect the state of the chip
after it has been initialised by the driver.  This is not a bug in the
firmware, as some registers it would have to examine are write-only.

This is a workaround for the Z85C30 which reuses the power-management
callback to keep the transmitter of the line associated with the console
enabled.  It reflects the consensus reached in a discussion a while ago.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/zs.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff -puN drivers/serial/zs.c~serial-z85c30-avoid-a-hang-at-console-switch-over drivers/serial/zs.c
--- a/drivers/serial/zs.c~serial-z85c30-avoid-a-hang-at-console-switch-over
+++ a/drivers/serial/zs.c
@@ -787,7 +787,6 @@ static int zs_startup(struct uart_port *
 	zport->regs[1] &= ~RxINT_MASK;
 	zport->regs[1] |= RxINT_ALL | TxINT_ENAB | EXT_INT_ENAB;
 	zport->regs[3] |= RxENABLE;
-	zport->regs[5] |= TxENAB;
 	zport->regs[15] |= BRKIE;
 	write_zsreg(zport, R1, zport->regs[1]);
 	write_zsreg(zport, R3, zport->regs[3]);
@@ -814,7 +813,6 @@ static void zs_shutdown(struct uart_port
 
 	spin_lock_irqsave(&scc->zlock, flags);
 
-	zport->regs[5] &= ~TxENAB;
 	zport->regs[3] &= ~RxENABLE;
 	write_zsreg(zport, R5, zport->regs[5]);
 	write_zsreg(zport, R3, zport->regs[3]);
@@ -959,6 +957,23 @@ static void zs_set_termios(struct uart_p
 	spin_unlock_irqrestore(&scc->zlock, flags);
 }
 
+/*
+ * Hack alert!
+ * Required solely so that the initial PROM-based console
+ * works undisturbed in parallel with this one.
+ */
+static void zs_pm(struct uart_port *uport, unsigned int state,
+		  unsigned int oldstate)
+{
+	struct zs_port *zport = to_zport(uport);
+
+	if (state < 3)
+		zport->regs[5] |= TxENAB;
+	else
+		zport->regs[5] &= ~TxENAB;
+	write_zsreg(zport, R5, zport->regs[5]);
+}
+
 
 static const char *zs_type(struct uart_port *uport)
 {
@@ -1041,6 +1056,7 @@ static struct uart_ops zs_ops = {
 	.startup	= zs_startup,
 	.shutdown	= zs_shutdown,
 	.set_termios	= zs_set_termios,
+	.pm		= zs_pm,
 	.type		= zs_type,
 	.release_port	= zs_release_port,
 	.request_port	= zs_request_port,
@@ -1190,6 +1206,7 @@ static int __init zs_console_setup(struc
 		return ret;
 
 	zs_reset(zport);
+	zs_pm(uport, 0, -1);
 
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
linux-next.patch
ntp-let-update_persistent_clock-sleep.patch
ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch
serial-z85c30-avoid-a-hang-at-console-switch-over.patch
serial-dz11-avoid-a-hang-at-console-switch-over.patch
rtc-m41t80-sort-header-inclusions-for-readability.patch
rtc-m41t80-use-pr_info-as-appropriate.patch

