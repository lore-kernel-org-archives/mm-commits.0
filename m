From: akpm@linux-foundation.org
Subject: - ahci-crash-fix.patch removed from -mm tree
Date: Fri, 11 May 2007 22:36:43 -0700
Message-ID: <200705120536.l4C5agxI002394@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756537AbXELFgp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:36:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ahci crash fix
has been removed from the -mm tree.  Its filename was
     ahci-crash-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -5982,6 +5982,7 @@ struct ata_port *ata_port_alloc(struct a
 	if (!ap)
 		return NULL;
 
+	ap->pflags |= ATA_PFLAG_INITIALIZING;
 	ap->lock = &host->lock;
 	ap->flags = ATA_FLAG_DISABLED;
 	ap->print_id = -1;
@@ -6350,6 +6351,7 @@ int ata_host_register(struct ata_host *h
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

origin.patch
git-dvb.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
optional-led-trigger-for-libata.patch
drivers-ata-remove-the-wildcard-from-sata_nv-driver.patch
libata-add-support-for-ata_16-on-atapi.patch
pci-quirks-disable-msi-on-rs400-200-and-rs480.patch
