From: akpm@linux-foundation.org
Subject: - powerpc-add-support-for-porta-and-portb-odr-registers.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:37:12 -0800
Message-ID: <200712202337.lBKNbCss018869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48166 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920AbXLTXsq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:48:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jochen@scram.de, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org, scottwood@freescale.com, mm-commits@vger.kernel.org


The patch titled
     powerpc: add support for PORTA and PORTB odr registers
has been removed from the -mm tree.  Its filename was
     powerpc-add-support-for-porta-and-portb-odr-registers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-powerpc.patch
powerpc-add-fixed-phy-support-for-fs_enet.patch
dio-fix-kernel-doc-notation.patch
