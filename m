From: akpm@linux-foundation.org
Subject: [merged] rapidio-fix-hang-on-rapidio-doorbell-queue-full-condition.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:09:02 -0800
Message-ID: <201101132011.p0DKBhx6030198__24771.4560515762$1294950578$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757142Ab1AMU3T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:29:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tom@baringforge.com, alexandre.bounine@idt.com, benh@kernel.crashing.org, galak@kernel.crashing.org, grant.likely@secretlab.ca, leoli@freescale.com, micha@neli.hopto.org, mporter@kern


The patch titled
     rapidio: fix hang on RapidIO doorbell queue full condition
has been removed from the -mm tree.  Its filename was
     rapidio-fix-hang-on-rapidio-doorbell-queue-full-condition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: fix hang on RapidIO doorbell queue full condition
From: Thomas Taranowski <tom@baringforge.com>

In fsl_rio_dbell_handler() the code currently simply acknowledges the QFI
queue full interrupt, but does nothing to resolve the queue full
condition.  Instead, it jumps to the end of the isr.  When a queue full
condition occurs, the isr is then re-entered immediately and continually,
forever.

The fix is to just fall through and read out current doorbell entries.

Signed-off-by: Thomas Taranowski <tom@baringforge.com>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-fix-hang-on-rapidio-doorbell-queue-full-condition arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-fix-hang-on-rapidio-doorbell-queue-full-condition
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -973,7 +973,6 @@ fsl_rio_dbell_handler(int irq, void *dev
 	if (dsr & DOORBELL_DSR_QFI) {
 		pr_info("RIO: doorbell queue full\n");
 		out_be32(&priv->msg_regs->dsr, DOORBELL_DSR_QFI);
-		goto out;
 	}
 
 	/* XXX Need to check/dispatch until queue empty */
_

Patches currently in -mm which might be from tom@baringforge.com are

origin.patch

