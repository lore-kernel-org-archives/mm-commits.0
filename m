From: akpm@linux-foundation.org
Subject: + libata-core-sff-fix-multiple-assumptions-about-dma.patch added to -mm tree
Date: Thu, 07 Jun 2007 22:36:29 -0700
Message-ID: <200706080536.l585aTfD020125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42620 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935759AbXFHFhS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 01:37:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     libata-core/sff: fix multiple assumptions about DMA
has been added to the -mm tree.  Its filename is
     libata-core-sff-fix-multiple-assumptions-about-dma.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata-core/sff: fix multiple assumptions about DMA
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The ata IRQ ack functions are only used when debugging.  Unfortunately almost
every controller that calls them can cause crashes in some configurations as
there are missing checks for bmdma presence.

In addition ata_port_start insists of installing DMA buffers and pad buffers
for controllers regardless.  The SFF controllers actually need to make that
decision dynamically at controller setup time and all need the same helper -
so we add ata_sff_port_start.  Future patches will switch the SFF drivers to
use this.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    1 
 drivers/ata/libata-sff.c  |   37 ++++++++++++++++++++++++++++--------
 include/linux/libata.h    |    1 
 3 files changed, 31 insertions(+), 8 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-core-sff-fix-multiple-assumptions-about-dma drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-core-sff-fix-multiple-assumptions-about-dma
+++ a/drivers/ata/libata-core.c
@@ -6821,6 +6821,7 @@ EXPORT_SYMBOL_GPL(ata_check_status);
 EXPORT_SYMBOL_GPL(ata_altstatus);
 EXPORT_SYMBOL_GPL(ata_exec_command);
 EXPORT_SYMBOL_GPL(ata_port_start);
+EXPORT_SYMBOL_GPL(ata_sff_port_start);
 EXPORT_SYMBOL_GPL(ata_interrupt);
 EXPORT_SYMBOL_GPL(ata_do_set_mode);
 EXPORT_SYMBOL_GPL(ata_data_xfer);
diff -puN drivers/ata/libata-sff.c~libata-core-sff-fix-multiple-assumptions-about-dma drivers/ata/libata-sff.c
--- a/drivers/ata/libata-sff.c~libata-core-sff-fix-multiple-assumptions-about-dma
+++ a/drivers/ata/libata-sff.c
@@ -80,25 +80,25 @@ u8 ata_dummy_irq_on (struct ata_port *ap
 u8 ata_irq_ack(struct ata_port *ap, unsigned int chk_drq)
 {
 	unsigned int bits = chk_drq ? ATA_BUSY | ATA_DRQ : ATA_BUSY;
-	u8 host_stat, post_stat, status;
+	u8 host_stat = 0, post_stat = 0, status;
 
 	status = ata_busy_wait(ap, bits, 1000);
 	if (status & bits)
 		if (ata_msg_err(ap))
 			printk(KERN_ERR "abnormal status 0x%X\n", status);
 
-	/* get controller status; clear intr, err bits */
-	host_stat = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
-	iowrite8(host_stat | ATA_DMA_INTR | ATA_DMA_ERR,
-		 ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
-
-	post_stat = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
+	if (ap->ioaddr.bmdma_addr) {
+		/* get controller status; clear intr, err bits */
+		host_stat = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
+		iowrite8(host_stat | ATA_DMA_INTR | ATA_DMA_ERR,
+			 ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
 
+		post_stat = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
+	}
 	if (ata_msg_intr(ap))
 		printk(KERN_INFO "%s: irq ack: host_stat 0x%X, new host_stat 0x%X, drv_stat 0x%X\n",
 			__FUNCTION__,
 			host_stat, post_stat, status);
-
 	return status;
 }
 
@@ -516,6 +516,27 @@ void ata_bmdma_post_internal_cmd(struct 
 		ata_bmdma_stop(qc);
 }
 
+/**
+ *	ata_sff_port_start - Set port up for dma.
+ *	@ap: Port to initialize
+ *
+ *	Called just after data structures for each port are
+ *	initialized.  Allocates space for PRD table if the device
+ *	is DMA capable SFF.
+ *
+ *	May be used as the port_start() entry in ata_port_operations.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+
+int ata_sff_port_start(struct ata_port *ap)
+{
+	if (ap->ioaddr.bmdma_addr)
+		return ata_port_start(ap);
+	return 0;
+}
+
 #ifdef CONFIG_PCI
 
 static int ata_resources_present(struct pci_dev *pdev, int port)
diff -puN include/linux/libata.h~libata-core-sff-fix-multiple-assumptions-about-dma include/linux/libata.h
--- a/include/linux/libata.h~libata-core-sff-fix-multiple-assumptions-about-dma
+++ a/include/linux/libata.h
@@ -780,6 +780,7 @@ extern u8 ata_check_status(struct ata_po
 extern u8 ata_altstatus(struct ata_port *ap);
 extern void ata_exec_command(struct ata_port *ap, const struct ata_taskfile *tf);
 extern int ata_port_start (struct ata_port *ap);
+extern int ata_sff_port_start (struct ata_port *ap);
 extern irqreturn_t ata_interrupt (int irq, void *dev_instance);
 extern void ata_data_xfer(struct ata_device *adev, unsigned char *buf,
 			  unsigned int buflen, int write_data);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
ia64-arbitary-speed-tty-ioctl-support.patch
git-libata-all.patch
pata-add-the-mcp73-77-support-to-pata-driver.patch
libata-correct-abuse-of-language.patch
libata-core-sff-fix-multiple-assumptions-about-dma.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
add-pci_try_set_mwi-prism54pci.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
h8300-enable-arbitary-speed-tty-port-setup.patch
arm26-enable-arbitary-speed-tty-ioctls-and-split.patch
m32r-enable-arbitary-speed-tty-rate-setting.patch
etrax-enable-arbitary-speed-setting-on-tty-ports.patch
v850-enable-arbitary-speed-tty-ioctls.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
update-zilog-timeout.patch
edd-switch-to-pci_get-based-api.patch
mpu401-warning-fixes.patch
char-tty_ioctl-use-wait_event_interruptible_timeout.patch
char-tty_ioctl-little-whitespace-cleanup.patch
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
