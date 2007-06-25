From: akpm@linux-foundation.org
Subject: - libata-expose-an-to-user-space.patch removed from -mm tree
Date: Mon, 25 Jun 2007 15:47:48 -0700
Message-ID: <200706252247.l5PMlm6N012912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42263 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752689AbXFYWr6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 18:47:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     libata: expose AN to user space
has been removed from the -mm tree.  Its filename was
     libata-expose-an-to-user-space.patch

This patch was dropped because my copy is out of date

------------------------------------------------------
Subject: libata: expose AN to user space
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

If Asynchronous Notification of media change events is supported, pass that
information up to the SCSI layer.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-scsi.c |    3 +++
 1 file changed, 3 insertions(+)

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

git-acpi.patch
libata-expose-an-to-user-space.patch
scsi-save-disk-in-scsi_device.patch
libata-send-event-when-an-received.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
