From: akpm@linux-foundation.org
Subject: - scsi-use-irq_handler_t-where-appropriate.patch removed from -mm tree
Date: Tue, 29 May 2007 11:55:33 -0700
Message-ID: <200705291855.l4TItWhN008587@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765280AbXE2S4K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:56:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, andrew.vasquez@qlogic.com, mark_salyzyn@adaptec.com, mm-commits@vger.kernel.org


The patch titled
     SCSI: use irq_handler_t where appropriate
has been removed from the -mm tree.  Its filename was
     scsi-use-irq_handler_t-where-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SCSI: use irq_handler_t where appropriate
From: Jeff Garzik <jeff@garzik.org>

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
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

pci-quirks-fix-msi-disabling-on-rs400-200-and-rs480.patch
git-ieee1394.patch
git-libata-all.patch
git-ubi.patch
git-netdev-all.patch
8139too-force-media-setting-fix.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
use-menuconfig-objects-ii-netdev-general100mbit.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-ioat.patch
remove-pci_dac_dma_-apis.patch
git-pciseg.patch
pci-device-ensure-sysdata-initialised-v2.patch
s390-spinlock-initializer-cleanup.patch
git-scsi-misc.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
add-select-phylib-to-the-ucc_geth-kconfig-option.patch
lguest-the-guest-code-tidyups-update.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups-update.patch
git-gccbug.patch
