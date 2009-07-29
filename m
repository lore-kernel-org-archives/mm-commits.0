From: akpm@linux-foundation.org
Subject: + cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch added to -mm tree
Date: Wed, 29 Jul 2009 16:52:36 -0700
Message-ID: <200907292352.n6TNqatW000596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755238AbZG2Xwi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 19:52:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bzolnier@gmail.com, jirislaby@gmail.com


The patch titled
     cyclades: allow overriding ISA defaults also when the driver is built-in
has been added to the -mm tree.  Its filename is
     cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -730,13 +730,11 @@ static unsigned int cy_isa_addresses[] =
 
 #define NR_ISA_ADDRS ARRAY_SIZE(cy_isa_addresses)
 
-#ifdef MODULE
 static long maddr[NR_CARDS];
 static int irq[NR_CARDS];
 
 module_param_array(maddr, long, NULL, 0);
 module_param_array(irq, int, NULL, 0);
-#endif
 
 #endif				/* CONFIG_ISA */
 
@@ -4497,13 +4495,10 @@ static int __init cy_detect_isa(void)
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
@@ -4513,7 +4508,6 @@ static int __init cy_detect_isa(void)
 		if (!maddr[i])
 			break;
 	}
-#endif
 
 	/* scan the address table probing for Cyclom-Y/ISA boards */
 	for (i = 0; i < NR_ISA_ADDRS; i++) {
@@ -4534,11 +4528,10 @@ static int __init cy_detect_isa(void)
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
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch

