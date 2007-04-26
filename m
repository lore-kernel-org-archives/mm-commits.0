From: akpm@linux-foundation.org
Subject: + ahci-crash-fix.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:16:25 -0700
Message-ID: <200704260016.l3Q0GP1V016618@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423001AbXDZAQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:16:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com


The patch titled
     ahci crash fix
has been added to the -mm tree.  Its filename is
     ahci-crash-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ahci crash fix
From: Tejun Heo <htejun@gmail.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    2 ++
 drivers/ata/libata-eh.c   |    3 +++
 include/linux/libata.h    |    1 +
 3 files changed, 6 insertions(+)

diff -puN drivers/ata/libata-core.c~ahci-crash-fix drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~ahci-crash-fix
+++ a/drivers/ata/libata-core.c
@@ -5947,6 +5947,7 @@ struct ata_port *ata_port_alloc(struct a
 	if (!ap)
 		return NULL;
 
+	ap->pflags |= ATA_PFLAG_INITIALIZING;
 	ap->lock = &host->lock;
 	ap->flags = ATA_FLAG_DISABLED;
 	ap->print_id = -1;
@@ -6315,6 +6316,7 @@ int ata_host_register(struct ata_host *h
 			ehi->action |= ATA_EH_SOFTRESET;
 			ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
 
+			ap->pflags &= ~ATA_PFLAG_INITIALIZING;
 			ap->pflags |= ATA_PFLAG_LOADING;
 			ata_port_schedule_eh(ap);
 
diff -puN drivers/ata/libata-eh.c~ahci-crash-fix drivers/ata/libata-eh.c
--- a/drivers/ata/libata-eh.c~ahci-crash-fix
+++ a/drivers/ata/libata-eh.c
@@ -568,6 +568,9 @@ void ata_port_schedule_eh(struct ata_por
 {
 	WARN_ON(!ap->ops->error_handler);
 
+	if (ap->pflags & ATA_PFLAG_INITIALIZING)
+		return;
+
 	ap->pflags |= ATA_PFLAG_EH_PENDING;
 	scsi_schedule_eh(ap->scsi_host);
 
diff -puN include/linux/libata.h~ahci-crash-fix include/linux/libata.h
--- a/include/linux/libata.h~ahci-crash-fix
+++ a/include/linux/libata.h
@@ -191,6 +191,7 @@ enum {
 	ATA_PFLAG_LOADING	= (1 << 4), /* boot/loading probe */
 	ATA_PFLAG_UNLOADING	= (1 << 5), /* module is unloading */
 	ATA_PFLAG_SCSI_HOTPLUG	= (1 << 6), /* SCSI hotplug scheduled */
+	ATA_PFLAG_INITIALIZING	= (1 << 7), /* being initialized, don't touch */
 
 	ATA_PFLAG_FLUSH_PORT_TASK = (1 << 16), /* flush port task */
 	ATA_PFLAG_SUSPENDED	= (1 << 17), /* port is suspended (power) */
_

Patches currently in -mm which might be from htejun@gmail.com are

sysfs-oops-workaround.patch
even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
security-prevent-permission-checking-of-file-removal-via-sysfs_remove_group.patch
git-libata-all.patch
ahci-crash-fix.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
optional-led-trigger-for-libata.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
git-scsi-misc.patch
introduce-config_has_dma.patch
