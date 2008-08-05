From: akpm@linux-foundation.org
Subject: + scsi-megaraid_sas-add-the-dumy-readl-to-force-pci-flush.patch added to -mm tree
Date: Mon, 04 Aug 2008 17:41:36 -0700
Message-ID: <200808050041.m750faPd008270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758836AbYHEAlm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 20:41:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Bo.Yang@lsi.com, James.Bottomley@HansenPartnership.com, bo.yang@lsi.com


The patch titled
     scsi: megaraid_sas: add the dumy readl to force PCI flush
has been added to the -mm tree.  Its filename is
     scsi-megaraid_sas-add-the-dumy-readl-to-force-pci-flush.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: megaraid_sas: add the dumy readl to force PCI flush
From: "Yang, Bo" <Bo.Yang@lsi.com>

MegaRAID SAS Driver get unexpected Interrupt.  Add the dumy readl to force
PCI flush will fix this issue.

Signed-off-by Bo Yang<bo.yang@lsi.com>
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

scsi-megaraid_sas-add-the-dumy-readl-to-force-pci-flush.patch
scsi-megaraid_sas-add-the-shutdown-dcmd-cmd-to-driver-shutdown-routine.patch
scsi-megaraid_sas-add-the-new-controllers-support.patch
scsi-megaraid_sas-add-the-new-controllers-support-checkpatch-fixes.patch
scsi-megaraid_sas-version-and-documentation-update.patch

