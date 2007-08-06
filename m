From: akpm@linux-foundation.org
Subject: - libata-expose-an-to-user-space.patch removed from -mm tree
Date: Mon, 06 Aug 2007 11:25:21 -0700
Message-ID: <200708061825.l76IPLH4008124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56635 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757815AbXHFSZc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 14:25:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, James.Bottomley@steeleye.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     libata: expose AN to user space
has been removed from the -mm tree.  Its filename was
     libata-expose-an-to-user-space.patch

This patch was dropped because an updated version will be merged

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
@@ -772,6 +772,9 @@ static void ata_scsi_dev_config(struct s
 		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
 	}
 
+	if (dev->flags & ATA_DFLAG_AN)
+		sdev->media_change_notify = 1;
+
 	if (dev->flags & ATA_DFLAG_NCQ) {
 		int depth;
 
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

store-interrupt-value.patch
enable-link-power-management-for-ata-drivers.patch
enable-aggressive-link-power-management-for-ahci.patch
libata-expose-an-to-user-space.patch
scsi-save-disk-in-scsi_device.patch
libata-send-event-when-an-received.patch
ata-ahci-alpm-store-interrupt-value.patch
ata-ahci-alpm-expose-power-management-policy-option-to-users.patch
ata-ahci-alpm-enable-link-power-management-for-ata-drivers.patch
ata-ahci-alpm-enable-link-power-management-for-ata-drivers-fix.patch
ata-ahci-alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
acpiphp_ibm-add-missing-n.patch
cpqphp_ctrlc-remove-dead-code.patch
acpi-bay-send-envp-with-uevent-fix.patch
acpi-dock-send-key=value-pair-instead-of-plain-value.patch
