From: akpm@linux-foundation.org
Subject: [merged] cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:33:43 -0800
Message-ID: <200912292133.nBTLXhD0008723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752842AbZL2Vdq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:33:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bzolnier@gmail.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cyclades: allow overriding ISA defaults also when the driver is built-in
has been removed from the -mm tree.  Its filename was
     cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cyclades: allow overriding ISA defaults also when the driver is built-in
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN drivers/char/cyclades.c~cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in
+++ a/drivers/char/cyclades.c
@@ -158,13 +158,11 @@ static unsigned int cy_isa_addresses[] =
 
 #define NR_ISA_ADDRS ARRAY_SIZE(cy_isa_addresses)
 
-#ifdef MODULE
 static long maddr[NR_CARDS];
 static int irq[NR_CARDS];
 
 module_param_array(maddr, long, NULL, 0);
 module_param_array(irq, int, NULL, 0);
-#endif
 
 #endif				/* CONFIG_ISA */
 
@@ -3310,13 +3308,10 @@ static int __init cy_detect_isa(void)
 	unsigned short cy_isa_irq, nboard;
 	void __iomem *cy_isa_address;
 	unsigned short i, j, cy_isa_nchan;
-#ifdef MODULE
 	int isparam = 0;
-#endif
 
 	nboard = 0;
 
-#ifdef MODULE
 	/* Check for module parameters */
 	for (i = 0; i < NR_CARDS; i++) {
 		if (maddr[i] || i) {
@@ -3326,7 +3321,6 @@ static int __init cy_detect_isa(void)
 		if (!maddr[i])
 			break;
 	}
-#endif
 
 	/* scan the address table probing for Cyclom-Y/ISA boards */
 	for (i = 0; i < NR_ISA_ADDRS; i++) {
@@ -3347,11 +3341,10 @@ static int __init cy_detect_isa(void)
 			iounmap(cy_isa_address);
 			continue;
 		}
-#ifdef MODULE
+
 		if (isparam && i < NR_CARDS && irq[i])
 			cy_isa_irq = irq[i];
 		else
-#endif
 			/* find out the board's irq by probing */
 			cy_isa_irq = detect_isa_irq(cy_isa_address);
 		if (cy_isa_irq == 0) {
_

Patches currently in -mm which might be from bzolnier@gmail.com are

linux-next.patch

