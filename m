From: akpm@linux-foundation.org
Subject: - libata-scsi-dont-start-hotplug-work-queue-if-hotplug-is-disabled.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:03:51 -0700
Message-ID: <200808210303.m7L33pxB013527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752715AbYHUDEt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:04:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chunbo.luo@windriver.com, jeff@garzik.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     libata-scsi: don't start hotplug work queue if hotplug is disabled
has been removed from the -mm tree.  Its filename was
     libata-scsi-dont-start-hotplug-work-queue-if-hotplug-is-disabled.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libata-scsi: don't start hotplug work queue if hotplug is disabled
From: Chunbo Luo <chunbo.luo@windriver.com>

Previously, queue_delayed_work() was started unconditionally, but if
ATA_PFLAG_SCSI_HOTPLUG is not set and we do this, the work queue may cause
multiple messages like this:

ata3.00: WARNING: ATAPI is not supported with this driver, device ignored.

So now,it is only started when the hotplug flag is actually set.

Signed-off-by: Chunbo Luo <chunbo.luo@windriver.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-scsi.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/ata/libata-scsi.c~libata-scsi-dont-start-hotplug-work-queue-if-hotplug-is-disabled drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~libata-scsi-dont-start-hotplug-work-queue-if-hotplug-is-disabled
+++ a/drivers/ata/libata-scsi.c
@@ -3176,8 +3176,9 @@ void ata_scsi_scan_host(struct ata_port 
 				"                  switching to async\n");
 	}
 
-	queue_delayed_work(ata_aux_wq, &ap->hotplug_task,
-			   round_jiffies_relative(HZ));
+	if (ap->pflags & ATA_PFLAG_SCSI_HOTPLUG)
+		queue_delayed_work(ata_aux_wq, &ap->hotplug_task,
+				round_jiffies_relative(HZ));
 }
 
 /**
_

Patches currently in -mm which might be from chunbo.luo@windriver.com are

libata-scsi-dont-start-hotplug-work-queue-if-hotplug-is-disabled.patch

