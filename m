From: akpm@linux-foundation.org
Subject: + hpsa-fix-typo-that-causes-scsi-status-to-be-lost.patch added to -mm tree
Date: Thu, 12 Nov 2009 14:53:56 -0800
Message-ID: <200911122253.nACMruwZ006997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754816AbZKLW4a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 17:56:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com


The patch titled
     hpsa: fix typo that causes scsi status to be lost
has been added to the -mm tree.  Its filename is
     hpsa-fix-typo-that-causes-scsi-status-to-be-lost.patch

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
Subject: hpsa: fix typo that causes scsi status to be lost
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

hpsa: fix typo that causes scsi status to be lost

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/hpsa.c~hpsa-fix-typo-that-causes-scsi-status-to-be-lost drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-fix-typo-that-causes-scsi-status-to-be-lost
+++ a/drivers/scsi/hpsa.c
@@ -987,7 +987,7 @@ static void complete_scsi_command(struct
 
 
 			/* Must be some other type of check condition */
-			cmd->result |= (ei->ScsiStatus < 1);
+			cmd->result |= (ei->ScsiStatus << 1);
 			dev_warn(&h->pdev->dev, "cp %p has check condition: "
 					"unknown type: "
 					"Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
@@ -1010,7 +1010,7 @@ static void complete_scsi_command(struct
 		 */
 		if (ei->ScsiStatus) {
 
-			cmd->result |= (ei->ScsiStatus < 1);
+			cmd->result |= (ei->ScsiStatus << 1);
 			dev_warn(&h->pdev->dev, "cp %p has status 0x%x "
 				"Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
 				"Returning result: 0x%x\n",
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix-hpsa_allow_any-test-for-vendor-id.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
hpsa-fix-use-of-unallocated-memory-for-msa2xxx-enclosure-device-data.patch
hpsa-allocate-the-correct-amount-of-extra-space-for-the-scsi-host.patch
hpsa-use-shost_priv-instead-of-accessing-host-hostdata-directly.patch
hpsa-factor-out-command-submission-sequence.patch
hpsa-factor-out-some-pci_unmap-code.patch
add-thread-to-allow-controllers-to-register-for-rescan-for-new-devices.patch
hpsa-allow-device-rescan-to-be-triggered-via-sysfs.patch
hpsa-make-hpsa_sdev_attrs-static.patch
hpsa-decode-unit-attention-condition-and-retry-commands.patch
hpsa-retry-driver-initiated-commands-on-unit-attention.patch
hpsa-flush-cache-with-interrupts-still-enabled.patch
hpsa-remove-sendcmd-in-no-case-are-we-required-to-poll-for-completions.patch
hpsa-make-fill_cmd-return-void.patch
hpsa-fix-typo-that-causes-scsi-status-to-be-lost.patch

