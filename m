From: akpm@linux-foundation.org
Subject: + libata-expose-an-to-user-space.patch added to -mm tree
Date: Wed, 08 Aug 2007 12:25:02 -0700
Message-ID: <200708081925.l78JP2hD026523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37781 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475AbXHHTZN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 15:25:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com, James.Bottomley@steeleye.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     libata: expose AN to user space
has been added to the -mm tree.  Its filename is
     libata-expose-an-to-user-space.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: expose AN to user space
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

If Asynchronous Notification of media change events is supported, pass that
information up to the SCSI layer.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-scsi.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN drivers/ata/libata-scsi.c~libata-expose-an-to-user-space drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~libata-expose-an-to-user-space
+++ a/drivers/ata/libata-scsi.c
@@ -844,6 +844,9 @@ static void ata_scsi_dev_config(struct s
 		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
 	}
 
+	if (dev->flags & ATA_DFLAG_AN)
+		sdev->media_change_notify = 1;
+
 	if (dev->flags & ATA_DFLAG_NCQ) {
 		int depth;
 
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

git-libata-all.patch
alpm-store-interrupt-value.patch
alpm-enable-link-power-management-for-ata-drivers.patch
alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
libata-check-for-an-support.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
libata-send-event-when-an-received.patch
acpiphp_ibm-add-missing-n.patch
cpqphp_ctrlc-remove-dead-code.patch
acpi-bay-send-envp-with-uevent-fix.patch
acpi-dock-send-key=value-pair-instead-of-plain-value.patch
