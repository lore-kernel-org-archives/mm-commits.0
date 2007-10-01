From: akpm@linux-foundation.org
Subject: - mips-remove-deprecated-irq-flags-sa_.patch removed from -mm tree
Date: Mon, 01 Oct 2007 00:14:43 -0700
Message-ID: <200710010714.l917EhxI004555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46420 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750931AbXJAHVG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2007 03:21:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     MIPS: Remove deprecated IRQ flags (SA_*)
has been removed from the -mm tree.  Its filename was
     mips-remove-deprecated-irq-flags-sa_.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MIPS: Remove deprecated IRQ flags (SA_*)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

A patch to stop using deprecated IRQ flags.  The new IRQF_* macros are used
instead.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/mips/pci/ops-pmcmsp.c~mips-remove-deprecated-irq-flags-sa_ arch/mips/pci/ops-pmcmsp.c
--- a/arch/mips/pci/ops-pmcmsp.c~mips-remove-deprecated-irq-flags-sa_
+++ a/arch/mips/pci/ops-pmcmsp.c
@@ -404,7 +404,7 @@ int msp_pcibios_config_access(unsigned c
 	if (pciirqflag == 0) {
 		request_irq(MSP_INT_PCI,/* Hardcoded internal MSP7120 wiring */
 				bpci_interrupt,
-				SA_SHIRQ | SA_INTERRUPT,
+				IRQF_SHARED | IRQF_DISABLED,
 				"PMC MSP PCI Host",
 				preg);
 		pciirqflag = ~0;
diff -puN arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c~mips-remove-deprecated-irq-flags-sa_ arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c
--- a/arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c~mips-remove-deprecated-irq-flags-sa_
+++ a/arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c
@@ -163,7 +163,7 @@ static int msp_hwbutton_register(struct 
 		CIC_EXT_SET_ACTIVE_HI(cic_ext, hirq->eirq);
 	*CIC_EXT_CFG_REG = cic_ext;
 
-	return request_irq(hirq->irq, hwbutton_handler, SA_INTERRUPT,
+	return request_irq(hirq->irq, hwbutton_handler, IRQF_DISABLED,
 				hirq->name, (void *)hirq);
 }
 
_

Patches currently in -mm which might be from darwish.07@gmail.com are

git-kvm.patch
git-mips.patch
ncr53c8xx-remove-deprecated-irq-flags-sa_.patch
completely-remove-deprecated-irq-flags-sa_.patch
