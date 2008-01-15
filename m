From: akpm@linux-foundation.org
Subject: + libata-relocate-sdev-manage_start_stop-configuration.patch added to -mm tree
Date: Tue, 15 Jan 2008 03:07:25 -0800
Message-ID: <200801151107.m0FB75Ka012482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45250 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060AbYAOLHX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 06:07:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, bunk@kernel.org


The patch titled
     libata: relocate sdev->manage_start_stop configuration
has been added to the -mm tree.  Its filename is
     libata-relocate-sdev-manage_start_stop-configuration.patch

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
Subject: libata: relocate sdev->manage_start_stop configuration
From: Tejun Heo <htejun@gmail.com>

After 9b8e8de7, manage_start_stop configuration depends on valid ATA
device.  Move it into ata_scsi_dev_config().  This was detected by the
coverity checker.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-scsi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/ata/libata-scsi.c~libata-relocate-sdev-manage_start_stop-configuration drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~libata-relocate-sdev-manage_start_stop-configuration
+++ a/drivers/ata/libata-scsi.c
@@ -841,6 +841,9 @@ static void ata_scsi_dev_config(struct s
 		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
 	}
 
+	if (dev->class == ATA_DEV_ATA)
+		sdev->manage_start_stop = 1;
+
 	if (dev->flags & ATA_DFLAG_AN)
 		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
 
@@ -872,9 +875,6 @@ int ata_scsi_slave_config(struct scsi_de
 
 	ata_scsi_sdev_config(sdev);
 
-	if (dev->class == ATA_DEV_ATA)
-		sdev->manage_start_stop = 1;
-
 	if (dev)
 		ata_scsi_dev_config(sdev, dev);
 
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
git-kbuild.patch
git-libata-all.patch
libata-xfer_mask-is-unsigned-int-not-unsigned-long.patch
libata-add-toshiba-mk1637gsx-to-spurious-command-completion-list.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
pata_legacy-resychronize-with-upstream-changes-and-resubmit.patch
git-scsi-misc.patch
libata-correct-handling-of-tss-dvd.patch
libata-relocate-sdev-manage_start_stop-configuration.patch
