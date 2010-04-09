From: akpm@linux-foundation.org
Subject: [merged] scsi-qla2xxx-fix-lock-imbalance.patch removed from -mm tree
Date: Fri, 09 Apr 2010 10:52:36 -0400
Message-ID: <201004091754.o39Hs6sf002163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755036Ab0DIRyR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2010 13:54:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, James.Bottomley@HansenPartnership.com, giridhar.malavali@qlogic.com, mm-commits@vger.kernel.org


The patch titled
     scsi: qla2xxx, fix lock imbalance
has been removed from the -mm tree.  Its filename was
     scsi-qla2xxx-fix-lock-imbalance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: qla2xxx, fix lock imbalance
From: Jiri Slaby <jslaby@suse.cz>

Stanse found that one error path in qla24xx_bsg_timeout omits to
unlock ha->hardware_lock. Fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_attr.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/qla2xxx/qla_attr.c~scsi-qla2xxx-fix-lock-imbalance drivers/scsi/qla2xxx/qla_attr.c
--- a/drivers/scsi/qla2xxx/qla_attr.c~scsi-qla2xxx-fix-lock-imbalance
+++ a/drivers/scsi/qla2xxx/qla_attr.c
@@ -2393,6 +2393,7 @@ qla24xx_bsg_timeout(struct fc_bsg_job *b
 	return 0;
 
 done:
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	if (bsg_job->request->msgcode == FC_BSG_HST_CT)
 		kfree(sp->fcport);
 	kfree(sp->ctx);
_

Patches currently in -mm which might be from jslaby@suse.cz are

linux-next.patch
gpu-vga_switcheroo-fix-lock-imbalance.patch
dvb-usb-gp8psk-fix-potential-null-derefernce.patch
kernel-user-remove-unreachable-code.patch
edac-add-__init-to-i7core_xeon_pci_fixup.patch

