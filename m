From: akpm@linux-foundation.org
Subject: - zsc-drain-the-transmission-line.patch removed from -mm tree
Date: Fri, 13 Jul 2007 14:56:13 -0700
Message-ID: <200707132156.l6DLuDl5022921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60466 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756535AbXGMV47 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 17:56:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     zs.c: drain the transmission line
has been removed from the -mm tree.  Its filename was
     zsc-drain-the-transmission-line.patch

This patch was dropped because the drop of zs-move-to-the-serial-subsystem.patch wrecked it

------------------------------------------------------
Subject: zs.c: drain the transmission line
From: "Maciej W. Rozycki" <macro@linux-mips.org>

This is an update to the zs.c driver to make it wait for the transmission
line to become idle before disabling the transmitter or resetting the chip.
 This way the character that is on the way at the time one of these actions
is about to be performed does not get corrupted.

Plus a change to reset the index/data pointer first before issuing a chip
reset just in case the state is wrong when control of the chip is taken the
first time.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/zs.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletion(-)

diff -puN drivers/serial/zs.c~zsc-drain-the-transmission-line drivers/serial/zs.c
--- a/drivers/serial/zs.c~zsc-drain-the-transmission-line
+++ a/drivers/serial/zs.c
@@ -240,10 +240,24 @@ static int zs_transmit_drain(struct zs_p
 	return loops;
 }
 
+static int zs_line_drain(struct zs_port *zport, int irq)
+{
+	struct zs_scc *scc = zport->scc;
+	int loops = 10000;
+
+	while (!(read_zsreg(zport, R1) & ALL_SNT) && loops--) {
+		zs_spin_unlock_cond_irq(&scc->zlock, irq);
+		udelay(2);
+		zs_spin_lock_cond_irq(&scc->zlock, irq);
+	}
+	return loops;
+}
+
 
 static void load_zsregs(struct zs_port *zport, u8 *regs, int irq)
 {
-	zs_transmit_drain(zport, irq);
+	/* Let the current transmission finish.  */
+	zs_line_drain(zport, irq);
 	/* Load 'em up.  */
 	write_zsreg(zport, R3, regs[3] & ~RxENABLE);
 	write_zsreg(zport, R5, regs[5] & ~TxENAB);
@@ -814,6 +828,10 @@ static void zs_reset(struct zs_port *zpo
 	spin_lock_irqsave(&scc->zlock, flags);
 	irq = !irqs_disabled_flags(flags);
 	if (!scc->initialised) {
+		/* Reset the pointer first, just in case...  */
+		read_zsreg(zport, R0);
+		/* And let the current transmission finish.  */
+		zs_line_drain(zport, irq);
 		write_zsreg(zport, R9, FHWRES);
 		udelay(10);
 		write_zsreg(zport, R9, 0);
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
zsc-drain-the-transmission-line.patch
sb1250-duartc-sb1250-duart-serial-support.patch
tgafb-actually-allocate-memory-for-the-pseudo_palette.patch
