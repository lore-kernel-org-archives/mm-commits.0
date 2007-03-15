From: akpm@linux-foundation.org
Subject: + lpfc-avoid-double-free-during-pci-error-failure.patch added to -mm tree
Date: Thu, 15 Mar 2007 13:44:54 -0700
Message-ID: <200703152044.l2FKisXS026039@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40428 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbXCOUy1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 16:54:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linas@austin.ibm.com, James.Smart@Emulex.Com


The patch titled
     lpfc: avoid double-free during PCI error failure
has been added to the -mm tree.  Its filename is
     lpfc-avoid-double-free-during-pci-error-failure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lpfc: avoid double-free during PCI error failure
From: linas@austin.ibm.com (Linas Vepstas)

If a PCI error is detected that cannot be recovered from, there will be a
double call of lpfc_pci_remove_one(), with the second call resulting in a
null-pointer dereference.  The first call occurs in
lpfc_io_error_detected(), and the second call during pci device remove. 
This patch eliminates the first call; its un-needed.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Acked-by: James Smart <James.Smart@Emulex.Com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_init.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/lpfc/lpfc_init.c~lpfc-avoid-double-free-during-pci-error-failure drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c~lpfc-avoid-double-free-during-pci-error-failure
+++ a/drivers/scsi/lpfc/lpfc_init.c
@@ -1817,10 +1817,9 @@ static pci_ers_result_t lpfc_io_error_de
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring  *pring;
 
-	if (state == pci_channel_io_perm_failure) {
-		lpfc_pci_remove_one(pdev);
+	if (state == pci_channel_io_perm_failure)
 		return PCI_ERS_RESULT_DISCONNECT;
-	}
+
 	pci_disable_device(pdev);
 	/*
 	 * There may be I/Os dropped by the firmware.
_

Patches currently in -mm which might be from linas@austin.ibm.com are

s2io-add-pci-error-recovery-support.patch
lpfc-avoid-double-free-during-pci-error-failure.patch
