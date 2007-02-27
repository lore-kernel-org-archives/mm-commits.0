From: akpm@linux-foundation.org
Subject: + sata_nv-complain-on-spurious-completion-notifiers.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:39:17 -0800
Message-ID: <200702272039.l1RKdLRJ027689@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50919 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933102AbXB0UmI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:42:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hancockr@shaw.ca


The patch titled
     sata_nv: complain on spurious completion notifiers
has been added to the -mm tree.  Its filename is
     sata_nv-complain-on-spurious-completion-notifiers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sata_nv: complain on spurious completion notifiers
From: Robert Hancock <hancockr@shaw.ca>

Recently Tejun wrote a patch to ahci.c to make it raise a HSM violation if
the drive attempted to complete a tag that wasn't outstanding.  We could
run into the same problem with sata_nv ADMA.  This adds code to raise a HSM
violation error if the controller gives us a notifier tag that isn't
outstanding, since the drive may be issuing spurious completions.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN drivers/ata/sata_nv.c~sata_nv-complain-on-spurious-completion-notifiers drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~sata_nv-complain-on-spurious-completion-notifiers
+++ a/drivers/ata/sata_nv.c
@@ -740,6 +740,17 @@ static int nv_adma_check_cpb(struct ata_
 			DPRINTK("Completing qc from tag %d with err_mask %u\n",cpb_num,
 				qc->err_mask);
 			ata_qc_complete(qc);
+		} else {
+			struct ata_eh_info *ehi = &ap->eh_info;
+			/* Notifier bits set without a command may indicate the drive
+			   is misbehaving. Raise host state machine violation on this
+			   condition. */
+			ata_port_printk(ap, KERN_ERR, "notifier for tag %d with no command?\n",
+				cpb_num);
+			ehi->err_mask |= AC_ERR_HSM;
+			ehi->action |= ATA_EH_SOFTRESET;
+			ata_port_freeze(ap);
+			return 1;
 		}
 	}
 	return 0;
_

Patches currently in -mm which might be from hancockr@shaw.ca are

git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
sata_nv-kill-old-private-bmdma-helper-functions.patch
sata_nv-complain-on-spurious-completion-notifiers.patch
libata-add-ncq-blacklist-entries-from-silicon-image-windows.patch
