From: akpm@linux-foundation.org
Subject: + scsi-be2iscsi-fix-lock-imbalance.patch added to -mm tree
Date: Fri, 19 Mar 2010 16:56:18 -0700
Message-ID: <201003192356.o2JNuIc9019494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275Ab0CSX5F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:57:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, James.Bottomley@HansenPartnership.com, jayamohank@serverengines.com, michaelc@cs.wisc.edu


The patch titled
     scsi: be2iscsi, fix lock imbalance
has been added to the -mm tree.  Its filename is
     scsi-be2iscsi-fix-lock-imbalance.patch

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
Subject: scsi: be2iscsi, fix lock imbalance
From: Jiri Slaby <jslaby@suse.cz>

Stanse found that one error path in mgmt_invalidate_icds omits to unlock
ctrl->mbox_lock. Fix that.

Added in 756d29c8c7ed8887ed7d752371ce2f (Enable async mode for mcc rings)
where the spinlock was moved.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jayamohan Kallickal <jayamohank@serverengines.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/be2iscsi/be_mgmt.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/be2iscsi/be_mgmt.c~scsi-be2iscsi-fix-lock-imbalance drivers/scsi/be2iscsi/be_mgmt.c
--- a/drivers/scsi/be2iscsi/be_mgmt.c~scsi-be2iscsi-fix-lock-imbalance
+++ a/drivers/scsi/be2iscsi/be_mgmt.c
@@ -169,6 +169,7 @@ unsigned char mgmt_invalidate_icds(struc
 		SE_DEBUG(DBG_LVL_1,
 			 "Failed to allocate memory for"
 			 "mgmt_invalidate_icds \n");
+		spin_unlock(&ctrl->mbox_lock);
 		return -1;
 	}
 	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
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

