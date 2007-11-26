From: akpm@linux-foundation.org
Subject: + powerpc-add-support-for-porta-and-portb-odr-registers.patch added to -mm tree
Date: Mon, 26 Nov 2007 15:32:26 -0800
Message-ID: <200711262332.lAQNWQ2t028763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37763 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756117AbXKZXci (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 18:32:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jochen@scram.de, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org, scottwood@freescale.com


The patch titled
     powerpc: add support for PORTA and PORTB odr registers
has been added to the -mm tree.  Its filename is
     powerpc-add-support-for-porta-and-portb-odr-registers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc: add support for PORTA and PORTB odr registers
From: Jochen Friedrich <jochen@scram.de>

PORTA and PORTB have odr registers, as well. However, the PORTB odr
register is only 16bit.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
Acked-by: Scott Wood <scottwood@freescale.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/commproc.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/sysdev/commproc.c~powerpc-add-support-for-porta-and-portb-odr-registers arch/powerpc/sysdev/commproc.c
--- a/arch/powerpc/sysdev/commproc.c~powerpc-add-support-for-porta-and-portb-odr-registers
+++ a/arch/powerpc/sysdev/commproc.c
@@ -408,7 +408,7 @@ EXPORT_SYMBOL(cpm_dpram_phys);
 #endif /* !CONFIG_PPC_CPM_NEW_BINDING */
 
 struct cpm_ioport16 {
-	__be16 dir, par, sor, dat, intr;
+	__be16 dir, par, odr_sor, dat, intr;
 	__be16 res[3];
 };
 
@@ -438,6 +438,13 @@ static void cpm1_set_pin32(int port, int
 	else
 		clrbits32(&iop->par, pin);
 
+	if (port == CPM_PORTB) {
+		if (flags & CPM_PIN_OPENDRAIN)
+			setbits16(&mpc8xx_immr->im_cpm.cp_pbodr, pin);
+		else
+			clrbits16(&mpc8xx_immr->im_cpm.cp_pbodr, pin);
+	}
+
 	if (port == CPM_PORTE) {
 		if (flags & CPM_PIN_SECONDARY)
 			setbits32(&iop->sor, pin);
@@ -471,11 +478,17 @@ static void cpm1_set_pin16(int port, int
 	else
 		clrbits16(&iop->par, pin);
 
+	if (port == CPM_PORTA) {
+		if (flags & CPM_PIN_OPENDRAIN)
+			setbits16(&iop->odr_sor, pin);
+		else
+			clrbits16(&iop->odr_sor, pin);
+	}
 	if (port == CPM_PORTC) {
 		if (flags & CPM_PIN_SECONDARY)
-			setbits16(&iop->sor, pin);
+			setbits16(&iop->odr_sor, pin);
 		else
-			clrbits16(&iop->sor, pin);
+			clrbits16(&iop->odr_sor, pin);
 	}
 }
 
_

Patches currently in -mm which might be from jochen@scram.de are

powerpc-kill-non-existent-symbols-from-ksyms-and-commproch.patch
powerpc-fix-typo-ifdef-ifndef.patch
powerpc-add-support-for-porta-and-portb-odr-registers.patch
