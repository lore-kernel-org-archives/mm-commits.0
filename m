From: akpm@linux-foundation.org
Subject: [merged] scsi-lpfc-fix-lock-imbalances.patch removed from -mm tree
Date: Fri, 09 Apr 2010 10:52:33 -0400
Message-ID: <201004091754.o39Hs395002158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595Ab0DIRyL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2010 13:54:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, James.Bottomley@HansenPartnership.com, james.smart@emulex.com, mm-commits@vger.kernel.org


The patch titled
     scsi: lpfc, fix lock imbalances
has been removed from the -mm tree.  Its filename was
     scsi-lpfc-fix-lock-imbalances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: lpfc, fix lock imbalances
From: Jiri Slaby <jslaby@suse.cz>

Stanse found that two error paths in lpfc_bsg_rport_els_cmp and
lpfc_issue_ct_rsp_cmp omits to unlock phba->ct_ev_lock.  It is because
they wrongly unlock phba->hbalock instead.  Fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: James Smart <james.smart@emulex.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_bsg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/lpfc/lpfc_bsg.c~scsi-lpfc-fix-lock-imbalances drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c~scsi-lpfc-fix-lock-imbalances
+++ a/drivers/scsi/lpfc/lpfc_bsg.c
@@ -433,7 +433,7 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *
 	dd_data = cmdiocbq->context1;
 	/* normal completion and timeout crossed paths, already done */
 	if (!dd_data) {
-		spin_unlock_irqrestore(&phba->hbalock, flags);
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		return;
 	}
 
@@ -1196,7 +1196,7 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *p
 	dd_data = cmdiocbq->context1;
 	/* normal completion and timeout crossed paths, already done */
 	if (!dd_data) {
-		spin_unlock_irqrestore(&phba->hbalock, flags);
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		return;
 	}
 
_

Patches currently in -mm which might be from jslaby@suse.cz are

linux-next.patch
gpu-vga_switcheroo-fix-lock-imbalance.patch
dvb-usb-gp8psk-fix-potential-null-derefernce.patch
kernel-user-remove-unreachable-code.patch
edac-add-__init-to-i7core_xeon_pci_fixup.patch

