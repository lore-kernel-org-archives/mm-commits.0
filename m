From: akpm@osdl.org
Subject: - user-of-the-jiffies-rounding-patch-ata-subsystem.patch removed from -mm tree
Date: Wed, 20 Dec 2006 16:36:57 -0800
Message-ID: <200612210036.kBL0avKP011246@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53381 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161095AbWLUAhF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:37:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     user of the jiffies rounding patch: ATA subsystem
has been removed from the -mm tree.  Its filename was
     user-of-the-jiffies-rounding-patch-ata-subsystem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: user of the jiffies rounding patch: ATA subsystem
From: Arjan van de Ven <arjan@linux.intel.com>

This patch introduces users of the round_jiffies() function: ATA subsystem

This delayed work is of the "about once a second" variety and can be rounded
to coincide with other wakers.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/libata-scsi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/ata/libata-scsi.c~user-of-the-jiffies-rounding-patch-ata-subsystem drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~user-of-the-jiffies-rounding-patch-ata-subsystem
+++ a/drivers/ata/libata-scsi.c
@@ -3011,7 +3011,8 @@ void ata_scsi_hotplug(struct work_struct
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
 		struct ata_device *dev = &ap->device[i];
 		if (ata_dev_enabled(dev) && !dev->sdev) {
-			queue_delayed_work(ata_aux_wq, &ap->hotplug_task, HZ);
+			queue_delayed_work(ata_aux_wq, &ap->hotplug_task,
+				round_jiffies_relative(HZ));
 			break;
 		}
 	}
_

Patches currently in -mm which might be from arjan@linux.intel.com are

git-libata-all.patch
git-netdev-all.patch
user-of-the-jiffies-rounding-code-networking.patch

