From: akpm@linux-foundation.org
Subject: + libata-expose-an-to-user-space.patch added to -mm tree
Date: Wed, 09 May 2007 22:12:26 -0700
Message-ID: <200705100512.l4A5CQF2012736@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755412AbXEJFMe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 01:12:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com


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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-scsi.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/ata/libata-scsi.c~libata-expose-an-to-user-space drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~libata-expose-an-to-user-space
+++ a/drivers/ata/libata-scsi.c
@@ -899,6 +899,9 @@ static void ata_scsi_dev_config(struct s
 		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
 	}
 
+	if (dev->flags & ATA_DFLAG_AN)
+		sdev->media_change_notify = 1;
+
 	if (dev->flags & ATA_DFLAG_NCQ) {
 		int depth;
 
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

origin.patch
acpi-dock-cleanup-the-uid-patch.patch
acpi-dock-fix-opps-after-dock-driver-fails-to-initialize.patch
acpi-dock-use-dynamically-allocated-platform-device.patch
acpi-dock-add-immediate_undock-option.patch
acpi-dock-unsuppress-uevents.patch
acpi-dock-send-envp-with-uevent.patch
acpi-bay-unsuppress-uevents.patch
libata-check-for-an-support.patch
genhd-expose-an-to-user-space.patch
scsi-expose-an-to-user-space.patch
libata-expose-an-to-user-space.patch
genhd-send-async-notification-on-media-change.patch
scsi-save-disk-in-scsi_device.patch
libata-send-event-when-an-received.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
