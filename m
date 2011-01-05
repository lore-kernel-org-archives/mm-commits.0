From: akpm@linux-foundation.org
Subject: + rapidio-fix-hang-on-rapidio-doorbell-queue-full-condition.patch added to -mm tree
Date: Wed, 05 Jan 2011 15:10:10 -0800
Message-ID: <201101052310.p05NAAiq023637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293Ab1AEXLP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2011 18:11:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tom@baringforge.com, alexandre.bounine@idt.com, benh@kernel.crashing.org, galak@kernel.crashing.org, grant.likely@secretlab.ca, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, stable@kernel.org, thomas.moll@sysgo.com


The patch titled
     rapidio: fix hang on RapidIO doorbell queue full condition
has been added to the -mm tree.  Its filename is
     rapidio-fix-hang-on-rapidio-doorbell-queue-full-condition.patch

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

rapidio-fix-hang-on-rapidio-doorbell-queue-full-condition.patch

