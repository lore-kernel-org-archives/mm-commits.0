From: akpm@linux-foundation.org
Subject: + scsi-qla2xxx-fix-lock-imbalance.patch added to -mm tree
Date: Fri, 19 Mar 2010 16:56:24 -0700
Message-ID: <201003192356.o2JNuO4s019500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275Ab0CSX5K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:57:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, James.Bottomley@HansenPartnership.com, giridhar.malavali@qlogic.com


The patch titled
     scsi: qla2xxx, fix lock imbalance
has been added to the -mm tree.  Its filename is
     scsi-qla2xxx-fix-lock-imbalance.patch

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
@@ -2388,6 +2388,7 @@ qla24xx_bsg_timeout(struct fc_bsg_job *b
 	return 0;
 
 done:
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	if (bsg_job->request->msgcode == FC_BSG_HST_CT)
 		kfree(sp->fcport);
 	kfree(sp->ctx);
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

