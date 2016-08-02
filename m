From: akpm@linux-foundation.org
Subject: [folded-merged]
 powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix.patch removed from -mm tree
Date: Tue, 02 Aug 2016 13:48:46 -0700
Message-ID: <57a1072e.6t2PEtQECmDqj9fR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482AbcHBVBt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:01:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, benh@kernel.crashing.org, mpe@ellerman.id.au, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix
has been removed from the -mm tree.  Its filename was
     powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix.patch

This patch was dropped because it was folded into powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix

Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -698,11 +698,6 @@ int fsl_rio_setup(struct platform_device
 			RIO_INB_ATMU_REGS_PORT2_OFFSET));
 
 
-		/* Set to receive any dist ID for serial RapidIO controller. */
-		if (port->phy_type == RIO_PHY_SERIAL)
-			out_be32((priv->regs_win
-				+ RIO_ISR_AACR + i*0x80), RIO_ISR_AACR_AA);
