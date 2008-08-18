From: akpm@linux-foundation.org
Subject: - scsi-megaraid_sas-add-the-dumy-readl-to-force-pci-flush.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:41:07 -0700
Message-ID: <200808181941.m7IJf7EA008518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934271AbYHRTuU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:50:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Bo.Yang@lsi.com, James.Bottomley@HansenPartnership.com, bo.yang@lsi.com, mm-commits@vger.kernel.org


The patch titled
     scsi: megaraid_sas: add the dumy readl to force PCI flush
has been removed from the -mm tree.  Its filename was
     scsi-megaraid_sas-add-the-dumy-readl-to-force-pci-flush.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: megaraid_sas: add the dumy readl to force PCI flush
From: "Yang, Bo" <Bo.Yang@lsi.com>

MegaRAID SAS Driver get unexpected Interrupt.  Add the dumy readl to force
PCI flush will fix this issue.

Signed-off-by: Bo Yang<bo.yang@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-add-the-dumy-readl-to-force-pci-flush drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-add-the-dumy-readl-to-force-pci-flush
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -198,6 +198,9 @@ megasas_clear_intr_xscale(struct megasas
 	 */
 	writel(status, &regs->outbound_intr_status);
 
+	/* Dummy readl to force pci flush */
+	readl(&regs->outbound_intr_status);
+
 	return 0;
 }
 
@@ -293,6 +296,9 @@ megasas_clear_intr_ppc(struct megasas_re
 	 */
 	writel(status, &regs->outbound_doorbell_clear);
 
+	/* Dummy readl to force pci flush */
+	readl(&regs->outbound_doorbell_clear);
+
 	return 0;
 }
 /**
_

Patches currently in -mm which might be from Bo.Yang@lsi.com are

linux-next.patch
drivers-scsi-megaraid-use-div_round_up.patch

