From: akpm@linux-foundation.org
Subject: - smc-superio-chip-lpc47n227-not-identified-properly.patch removed from -mm tree
Date: Sun, 25 Mar 2007 17:04:42 -0800
Message-ID: <200703260104.l2Q14gIP008662@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38460 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933307AbXCZBFB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:05:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter.kovar@gmail.com, khali@linux-fr.org, samuel@sortiz.org, mm-commits@vger.kernel.org


The patch titled
     SMC SuperIO Chip LPC47N227 not identified properly
has been removed from the -mm tree.  Its filename was
     smc-superio-chip-lpc47n227-not-identified-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SMC SuperIO Chip LPC47N227 not identified properly
From: Peter Kovar <peter.kovar@gmail.com>

SMC SuperIO Chip LPC47N227 used for IrDA is not detected because its device
identification byte is 0x7A instead of 0x5A.

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/smsc-ircc2.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/irda/smsc-ircc2.c~smc-superio-chip-lpc47n227-not-identified-properly drivers/net/irda/smsc-ircc2.c
--- a/drivers/net/irda/smsc-ircc2.c~smc-superio-chip-lpc47n227-not-identified-properly
+++ a/drivers/net/irda/smsc-ircc2.c
@@ -315,6 +315,7 @@ static struct smsc_chip __initdata lpc_c
 {
 	/* Base address 0x2E or 0x4E */
 	{ "47N227",	KEY55_1|FIR|SERx4,	0x5a, 0x00 },
+	{ "47N227",	KEY55_1|FIR|SERx4,	0x7a, 0x00 },
 	{ "47N267",	KEY55_1|FIR|SERx4,	0x5e, 0x00 },
 	{ NULL }
 };
_

Patches currently in -mm which might be from peter.kovar@gmail.com are

git-net.patch
