From: akpm@linux-foundation.org
Subject: - sata_nv-complain-on-spurious-completion-notifiers.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:52:11 -0800
Message-ID: <200702282352.l1SNqB6r030973@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48203 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601AbXB1XwN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:52:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hancockr@shaw.ca, mm-commits@vger.kernel.org


The patch titled
     sata_nv: complain on spurious completion notifiers
has been removed from the -mm tree.  Its filename was
     sata_nv-complain-on-spurious-completion-notifiers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
libata-add-ncq-blacklist-entries-from-silicon-image-windows.patch
