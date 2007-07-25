From: akpm@linux-foundation.org
Subject: - ata-use-iomap_name.patch removed from -mm tree
Date: Wed, 25 Jul 2007 02:03:51 -0700
Message-ID: <200707250903.l6P93rFt026518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59251 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754208AbXGYJEk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jul 2007 05:04:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ata: use iomap_name()
has been removed from the -mm tree.  Its filename was
     ata-use-iomap_name.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: ata: use iomap_name()
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Use iomap_name() in the libata layer

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   11 ++++++-----
 include/linux/libata.h    |    9 ++++++---
 2 files changed, 12 insertions(+), 8 deletions(-)

diff -puN drivers/ata/libata-core.c~ata-use-iomap_name drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~ata-use-iomap_name
+++ a/drivers/ata/libata-core.c
@@ -6489,6 +6489,7 @@ void ata_host_init(struct ata_host *host
 int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 {
 	int i, rc;
+	char ctlbuf[IOMAP_NAMELEN], cmdbuf[IOMAP_NAMELEN], dmabuf[IOMAP_NAMELEN];
 
 	/* host must have been started */
 	if (!(host->flags & ATA_HOST_STARTED)) {
@@ -6545,13 +6546,13 @@ int ata_host_register(struct ata_host *h
 
 		/* print per-port info to dmesg */
 		if (!ata_port_is_dummy(ap))
-			ata_port_printk(ap, KERN_INFO, "%cATA max %s cmd 0x%p "
-					"ctl 0x%p bmdma 0x%p irq %d\n",
+			ata_port_printk(ap, KERN_INFO, "%cATA max %s cmd %s "
+					"ctl %s bmdma %s irq %d\n",
 					(ap->flags & ATA_FLAG_SATA) ? 'S' : 'P',
 					ata_mode_string(xfer_mask),
-					ap->ioaddr.cmd_addr,
-					ap->ioaddr.ctl_addr,
-					ap->ioaddr.bmdma_addr,
+					iomap_name(ap->ioaddr.cmd_addr, cmdbuf, sizeof(cmdbuf)),
+					iomap_name(ap->ioaddr.ctl_addr, ctlbuf, sizeof(ctlbuf)),
+					iomap_name(ap->ioaddr.bmdma_addr, dmabuf, sizeof(dmabuf)),
 					irq_line);
 		else
 			ata_port_printk(ap, KERN_INFO, "DUMMY\n");
diff -puN include/linux/libata.h~ata-use-iomap_name include/linux/libata.h
--- a/include/linux/libata.h~ata-use-iomap_name
+++ a/include/linux/libata.h
@@ -1122,11 +1122,14 @@ static inline u8 ata_busy_wait(struct at
 
 static inline u8 ata_wait_idle(struct ata_port *ap)
 {
+	char buf[IOMAP_NAMELEN];
 	u8 status = ata_busy_wait(ap, ATA_BUSY | ATA_DRQ, 1000);
 
-	if (status != 0xff && (status & (ATA_BUSY | ATA_DRQ)))
-		DPRINTK("ATA: abnormal status 0x%X on port 0x%p\n",
-			status, ap->ioaddr.status_addr);
+	if (status != 0xff && (status & (ATA_BUSY | ATA_DRQ))) {
+  		if (ata_msg_warn(ap))
+			printk(KERN_WARNING "ATA: abnormal status 0x%X on port %s\n",
+ 				status, iomap_name(ap->ioaddr.status_addr, buf, sizeof(buf)));
+	}
 
 	return status;
 }
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
git-scsi-rc-fixes.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
geode-setup-correct-chipset-access-functions-fix.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer-iomap-allow-space-for-64bit-i-o-ports.patch
ata-use-iomap_name.patch
remove-kconfig-setting-config_debug_shirq.patch
debug-handling-of-early-spurious-interrupts.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
