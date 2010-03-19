From: akpm@linux-foundation.org
Subject: + scsi-lpfc-fix-lock-imbalances.patch added to -mm tree
Date: Fri, 19 Mar 2010 16:56:21 -0700
Message-ID: <201003192356.o2JNuLYQ019497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262Ab0CSX47 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:56:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, James.Bottomley@HansenPartnership.com, james.smart@emulex.com


The patch titled
     scsi: lpfc, fix lock imbalances
has been added to the -mm tree.  Its filename is
     scsi-lpfc-fix-lock-imbalances.patch

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
@@ -432,7 +432,7 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *
 	dd_data = cmdiocbq->context1;
 	/* normal completion and timeout crossed paths, already done */
 	if (!dd_data) {
-		spin_unlock_irqrestore(&phba->hbalock, flags);
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		return;
 	}
 
@@ -1195,7 +1195,7 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *p
 	dd_data = cmdiocbq->context1;
 	/* normal completion and timeout crossed paths, already done */
 	if (!dd_data) {
-		spin_unlock_irqrestore(&phba->hbalock, flags);
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		return;
 	}
 
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
linux-next.patch
scsi-be2iscsi-fix-lock-imbalance.patch
scsi-lpfc-fix-lock-imbalances.patch
scsi-qla2xxx-fix-lock-imbalance.patch
gpu-vga_switcheroo-fix-lock-imbalance.patch
dvb-usb-gp8psk-fix-potential-null-derefernce.patch
kernel-user-remove-unreachable-code.patch
edac-add-__init-to-i7core_xeon_pci_fixup.patch

