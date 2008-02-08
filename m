From: akpm@linux-foundation.org
Subject: - dz-always-check-if-it-is-safe-to-console_putchar.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:06:15 -0800
Message-ID: <200802080805.m1885uEm014384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55624 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760503AbYBHITh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     dz: always check if it is safe to console_putchar()
has been removed from the -mm tree.  Its filename was
     dz-always-check-if-it-is-safe-to-console_putchar.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dz: always check if it is safe to console_putchar()
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Polled transmission is tricky enough with the DZ11 design.  While "loop" is
set to a high value, conceptually you are not allowed to transmit without
checking whether the device offers the right transmission line (yes, it is the
device that selects the line -- the driver has no control over it other than
disabling the transmitter offered if it is the wrong one), so the loop has to
be run at least once.

Well, the '1977 or PDP11 view of how serial lines should be handled...  Except
that the serial interface used to be quite an impressive board back then
rather than chip.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/dz.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/dz.c~dz-always-check-if-it-is-safe-to-console_putchar drivers/serial/dz.c
--- a/drivers/serial/dz.c~dz-always-check-if-it-is-safe-to-console_putchar
+++ a/drivers/serial/dz.c
@@ -685,7 +685,7 @@ static void dz_console_putchar(struct ua
 	iob();
 	spin_unlock_irqrestore(&dport->port.lock, flags);
 
-	while (loops--) {
+	do {
 		trdy = dz_in(dport, DZ_CSR);
 		if (!(trdy & DZ_TRDY))
 			continue;
@@ -696,7 +696,7 @@ static void dz_console_putchar(struct ua
 		dz_out(dport, DZ_TCR, mask);
 		iob();
 		udelay(2);
-	}
+	} while (loops--);
 
 	if (loops)				/* Cannot send otherwise. */
 		dz_out(dport, DZ_TDR, ch);
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
