From: akpm@linux-foundation.org
Subject: + scsi-use-irq_handler_t-where-appropriate.patch added to -mm tree
Date: Tue, 01 May 2007 16:54:36 -0700
Message-ID: <200705012354.l41NsaT8009558@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946083AbXEAXyo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2007 19:54:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org


The patch titled
     SCSI: use irq_handler_t where appropriate
has been added to the -mm tree.  Its filename is
     scsi-use-irq_handler_t-where-appropriate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SCSI: use irq_handler_t where appropriate
From: Jeff Garzik <jeff@garzik.org>

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/aacraid.h |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/aacraid/aacraid.h~scsi-use-irq_handler_t-where-appropriate drivers/scsi/aacraid/aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h~scsi-use-irq_handler_t-where-appropriate
+++ a/drivers/scsi/aacraid/aacraid.h
@@ -464,7 +464,7 @@ struct adapter_ops
 	int  (*adapter_restart)(struct aac_dev *dev, int bled);
 	/* Transport operations */
 	int  (*adapter_ioremap)(struct aac_dev * dev, u32 size);
-	irqreturn_t (*adapter_intr)(int irq, void *dev_id);
+	irq_handler_t adapter_intr;
 	/* Packet operations */
 	int  (*adapter_deliver)(struct fib * fib);
 	int  (*adapter_bounds)(struct aac_dev * dev, struct scsi_cmnd * cmd, u64 lba);
diff -puN drivers/scsi/qla2xxx/qla_isr.c~scsi-use-irq_handler_t-where-appropriate drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c~scsi-use-irq_handler_t-where-appropriate
+++ a/drivers/scsi/qla2xxx/qla_isr.c
@@ -1633,7 +1633,7 @@ struct qla_init_msix_entry {
 	uint16_t entry;
 	uint16_t index;
 	const char *name;
-	irqreturn_t (*handler)(int, void *);
+	irq_handler_t handler;
 };
 
 static struct qla_init_msix_entry imsix_entries[QLA_MSIX_ENTRIES] = {
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-arm.patch
git-libata-all.patch
optional-led-trigger-for-libata.patch
ata_timing-ensure-t-cycle-is-always-correct.patch
drivers-ata-remove-the-wildcard-from-sata_nv-driver.patch
8139too-force-media-setting-fix.patch
ne-add-platform_driver.patch
ne-add-platform_driver-fix.patch
ne-mips-use-platform_driver-for-ne-on-rbtx49xx.patch
mips-drop-unnecessary-config_isa-from-rbtx49xx.patch
ibmtr_cs-fix-hang-on-eject.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-e1000.patch
git-ioat.patch
git-r8169.patch
remove-pci_dac_dma_-apis.patch
git-pciseg.patch
pci-device-ensure-sysdata-initialised-v2.patch
scsi-use-irq_handler_t-where-appropriate.patch
introduce-config_has_dma.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
uml-network-interface-hotplug-error-handling.patch
fix-wrong-identifier-name-in-documentation-driver-model-devrestxt.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch
lguest-the-net-driver.patch
git-gccbug.patch
use-menuconfig-objects-libata.patch
use-menuconfig-objects-phy.patch
use-menuconfig-objects-netdev.patch
