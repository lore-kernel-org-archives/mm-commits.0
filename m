From: akpm@osdl.org
Subject: - scsi-megaraid-fix-mmio-casts.patch removed from -mm tree
Date: Wed, 06 Dec 2006 14:23:48 -0800
Message-ID: <200612062223.kB6MNmmn018560@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48258 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937727AbWLFWX6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 17:23:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     SCSI/megaraid: fix MMIO casts
has been removed from the -mm tree.  Its filename was
     scsi-megaraid-fix-mmio-casts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SCSI/megaraid: fix MMIO casts
From: Jeff Garzik <jeff@garzik.org>

megaraid's MMIO RD*/WR* macros directly call readl() and writel() with an
'unsigned long' argument.  This throws a warning, but is otherwise OK because
the 'unsigned long' is really the result of ioremap().  This setup is also OK
because the variable can hold an ioremap cookie /or/ a PCI I/O port (PIO).

However, to fix the warning thrown when readl() and writel() are passed an
unsigned long cookie, I introduce 'void __iomem *mmio_base', holding the same
value as 'base'.  This will silence the warnings, and also cause an oops
whenever these MMIO-only functions are ever accidentally passed an I/O
address.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/megaraid.c |   13 ++++++++-----
 drivers/scsi/megaraid.h |    3 ++-
 2 files changed, 10 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/megaraid.c~scsi-megaraid-fix-mmio-casts drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~scsi-megaraid-fix-mmio-casts
+++ a/drivers/scsi/megaraid.c
@@ -73,10 +73,10 @@ static unsigned short int max_mbox_busy_
 module_param(max_mbox_busy_wait, ushort, 0);
 MODULE_PARM_DESC(max_mbox_busy_wait, "Maximum wait for mailbox in microseconds if busy (default=MBOX_BUSY_WAIT=10)");
 
-#define RDINDOOR(adapter)		readl((adapter)->base + 0x20)
-#define RDOUTDOOR(adapter)		readl((adapter)->base + 0x2C)
-#define WRINDOOR(adapter,value)		writel(value, (adapter)->base + 0x20)
-#define WROUTDOOR(adapter,value)	writel(value, (adapter)->base + 0x2C)
+#define RDINDOOR(adapter)	readl((adapter)->mmio_base + 0x20)
+#define RDOUTDOOR(adapter)	readl((adapter)->mmio_base + 0x2C)
+#define WRINDOOR(adapter,value)	 writel(value, (adapter)->mmio_base + 0x20)
+#define WROUTDOOR(adapter,value) writel(value, (adapter)->mmio_base + 0x2C)
 
 /*
  * Global variables
@@ -1386,7 +1386,8 @@ megaraid_isr_memmapped(int irq, void *de
 
 		handled = 1;
 
-		while( RDINDOOR(adapter) & 0x02 ) cpu_relax();
+		while( RDINDOOR(adapter) & 0x02 )
+			cpu_relax();
 
 		mega_cmd_done(adapter, completed, nstatus, status);
 
@@ -4672,6 +4673,8 @@ megaraid_probe_one(struct pci_dev *pdev,
 		host->host_no, mega_baseport, irq);
 
 	adapter->base = mega_baseport;
+	if (flag & BOARD_MEMMAP)
+		adapter->mmio_base = (void __iomem *) mega_baseport;
 
 	INIT_LIST_HEAD(&adapter->free_list);
 	INIT_LIST_HEAD(&adapter->pending_list);
diff -puN drivers/scsi/megaraid.h~scsi-megaraid-fix-mmio-casts drivers/scsi/megaraid.h
--- a/drivers/scsi/megaraid.h~scsi-megaraid-fix-mmio-casts
+++ a/drivers/scsi/megaraid.h
@@ -801,7 +801,8 @@ typedef struct {
 				   clustering is available */
 	u32	flag;
 
-	unsigned long	base;
+	unsigned long		base;
+	void __iomem		*mmio_base;
 
 	/* mbox64 with mbox not aligned on 16-byte boundry */
 	mbox64_t	*una_mbox64;
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-acpi.patch
git-cpufreq.patch
drm-handle-pci_enable_device-failure.patch
git-input.patch
git-libata-all.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
initializer-entry-defined-twice-in-pata_rz1000.patch
ata_piix-ide-mode-sata-patch-for-intel-ich9.patch
pata_it8213-add-new-driver-for-the-it8213-card.patch
pata_it8213-add-new-driver-for-the-it8213-card-tidy.patch
git-mtd.patch
git-netdev-all.patch
libphy-dont-do-that.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
8139too-force-media-setting-fix.patch
tulip-fix-shutdown-dma-irq-race.patch
git-ioat.patch
git-pciseg.patch
pci-device-ensure-sysdata-initialised-v2.patch
mpt-fusion-handle-pci-layer-error-on-resume.patch
usb-fix-ohcih-over-use-warnings.patch
i2o-more-error-checking.patch
pnp-handle-sysfs-errors.patch
rtc-handle-sysfs-errors.patch
sound-oss-emu10k1-handle-userspace-copy-errors.patch
spi-improve-sysfs-compiler-complaint-handling.patch
via82cxxx-handle-error-condition-properly.patch
isdn-fix-warnings.patch
atyfb-rivafb-minor-fixes.patch
md-conditionalize-some-code.patch
user-of-the-jiffies-rounding-patch-ata-subsystem.patch
e1000-printk-warning-fixes.patch
git-gccbug.patch

