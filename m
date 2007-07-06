From: akpm@linux-foundation.org
Subject: - libata-support-chips-with-64k-prd-quirk.patch removed from -mm tree
Date: Thu, 05 Jul 2007 17:52:23 -0700
Message-ID: <200707060052.l660qNOP028367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39309 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760001AbXGFA6Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 20:58:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     libata: support chips with 64K PRD quirk
has been removed from the -mm tree.  Its filename was
     libata-support-chips-with-64k-prd-quirk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: support chips with 64K PRD quirk
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Add ata_dumb_qc_prep and supporting logic so that a driver can just
specify it needs to be helped in this area. 64K entries are split
as with drivers/ide.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   79 ++++++++++++++++++++++++++++++++++++
 drivers/ata/pata_cs5520.c |    4 -
 drivers/ata/pata_cs5530.c |    4 -
 drivers/ata/pata_sc1200.c |    4 -
 include/linux/libata.h    |    2 
 5 files changed, 87 insertions(+), 6 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-support-chips-with-64k-prd-quirk drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-support-chips-with-64k-prd-quirk
+++ a/drivers/ata/libata-core.c
@@ -4113,6 +4113,68 @@ static void ata_fill_sg(struct ata_queue
 }
 
 /**
+ *	ata_fill_sg_dumb - Fill PCI IDE PRD table
+ *	@qc: Metadata associated with taskfile to be transferred
+ *
+ *	Fill PCI IDE PRD (scatter-gather) table with segments
+ *	associated with the current disk command. Perform the fill
+ *	so that we avoid writing any length 64K records for
+ *	controllers that don't follow the spec.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ */
+static void ata_fill_sg_dumb(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct scatterlist *sg;
+	unsigned int idx;
+
+	WARN_ON(qc->__sg == NULL);
+	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
+
+	idx = 0;
+	ata_for_each_sg(sg, qc) {
+		u32 addr, offset;
+		u32 sg_len, len, blen;
+
+ 		/* determine if physical DMA addr spans 64K boundary.
+		 * Note h/w doesn't support 64-bit, so we unconditionally
+		 * truncate dma_addr_t to u32.
+		 */
+		addr = (u32) sg_dma_address(sg);
+		sg_len = sg_dma_len(sg);
+
+		while (sg_len) {
+			offset = addr & 0xffff;
+			len = sg_len;
+			if ((offset + sg_len) > 0x10000)
+				len = 0x10000 - offset;
+
+			blen = len & 0xffff;
+			ap->prd[idx].addr = cpu_to_le32(addr);
+			if (blen == 0) {
+				/* Some PATA chipsets like the CS5530 can't
+				   cope with 0x0000 meaning 64K as the spec says */
+				ap->prd[idx].flags_len = cpu_to_le32(0x8000);
+				blen = 0x8000;
+				ap->prd[++idx].addr = cpu_to_le32(addr + 0x8000);
+			}
+			ap->prd[idx].flags_len = cpu_to_le32(blen);
+			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx, addr, len);
+
+			idx++;
+			sg_len -= len;
+			addr += len;
+		}
+	}
+
+	if (idx)
+		ap->prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
+}
+
+/**
  *	ata_check_atapi_dma - Check whether ATAPI DMA can be supported
  *	@qc: Metadata associated with taskfile to check
  *
@@ -4159,6 +4221,23 @@ void ata_qc_prep(struct ata_queued_cmd *
 	ata_fill_sg(qc);
 }
 
+/**
+ *	ata_dumb_qc_prep - Prepare taskfile for submission
+ *	@qc: Metadata associated with taskfile to be prepared
+ *
+ *	Prepare ATA taskfile for submission.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void ata_dumb_qc_prep(struct ata_queued_cmd *qc)
+{
+	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
+		return;
+
+	ata_fill_sg_dumb(qc);
+}
+
 void ata_noop_qc_prep(struct ata_queued_cmd *qc) { }
 
 /**
diff -puN drivers/ata/pata_cs5520.c~libata-support-chips-with-64k-prd-quirk drivers/ata/pata_cs5520.c
--- a/drivers/ata/pata_cs5520.c~libata-support-chips-with-64k-prd-quirk
+++ a/drivers/ata/pata_cs5520.c
@@ -146,7 +146,7 @@ static struct scsi_host_template cs5520_
 	.queuecommand		= ata_scsi_queuecmd,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= LIBATA_MAX_PRD,
+	.sg_tablesize		= LIBATA_DUMB_MAX_PRD,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
@@ -178,7 +178,7 @@ static struct ata_port_operations cs5520
 	.bmdma_start		= ata_bmdma_start,
 	.bmdma_stop		= ata_bmdma_stop,
 	.bmdma_status		= ata_bmdma_status,
-	.qc_prep		= ata_qc_prep,
+	.qc_prep		= ata_dumb_qc_prep,
 	.qc_issue		= ata_qc_issue_prot,
 	.data_xfer		= ata_data_xfer,
 
diff -puN drivers/ata/pata_cs5530.c~libata-support-chips-with-64k-prd-quirk drivers/ata/pata_cs5530.c
--- a/drivers/ata/pata_cs5530.c~libata-support-chips-with-64k-prd-quirk
+++ a/drivers/ata/pata_cs5530.c
@@ -167,7 +167,7 @@ static struct scsi_host_template cs5530_
 	.queuecommand		= ata_scsi_queuecmd,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= LIBATA_MAX_PRD,
+	.sg_tablesize		= LIBATA_DUMB_MAX_PRD,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
@@ -201,7 +201,7 @@ static struct ata_port_operations cs5530
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
 	.cable_detect	= ata_cable_40wire,
 
-	.qc_prep 	= ata_qc_prep,
+	.qc_prep 	= ata_dumb_qc_prep,
 	.qc_issue	= cs5530_qc_issue_prot,
 
 	.data_xfer	= ata_data_xfer,
diff -puN drivers/ata/pata_sc1200.c~libata-support-chips-with-64k-prd-quirk drivers/ata/pata_sc1200.c
--- a/drivers/ata/pata_sc1200.c~libata-support-chips-with-64k-prd-quirk
+++ a/drivers/ata/pata_sc1200.c
@@ -185,7 +185,7 @@ static struct scsi_host_template sc1200_
 	.queuecommand		= ata_scsi_queuecmd,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= LIBATA_MAX_PRD,
+	.sg_tablesize		= LIBATA_DUMB_MAX_PRD,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
@@ -219,7 +219,7 @@ static struct ata_port_operations sc1200
 	.bmdma_stop	= ata_bmdma_stop,
 	.bmdma_status 	= ata_bmdma_status,
 
-	.qc_prep 	= ata_qc_prep,
+	.qc_prep 	= ata_dumb_qc_prep,
 	.qc_issue	= sc1200_qc_issue_prot,
 
 	.data_xfer	= ata_data_xfer,
diff -puN include/linux/libata.h~libata-support-chips-with-64k-prd-quirk include/linux/libata.h
--- a/include/linux/libata.h~libata-support-chips-with-64k-prd-quirk
+++ a/include/linux/libata.h
@@ -116,6 +116,7 @@ static inline struct device *pci_dev_to_
 enum {
 	/* various global constants */
 	LIBATA_MAX_PRD		= ATA_MAX_PRD / 2,
+	LIBATA_DUMB_MAX_PRD	= ATA_MAX_PRD / 4,	/* Worst case */
 	ATA_MAX_PORTS		= 8,
 	ATA_DEF_QUEUE		= 1,
 	/* tag ATA_MAX_QUEUE - 1 is reserved for internal commands */
@@ -785,6 +786,7 @@ extern void ata_data_xfer(struct ata_dev
 			  unsigned int buflen, int write_data);
 extern void ata_data_xfer_noirq(struct ata_device *adev, unsigned char *buf,
 				unsigned int buflen, int write_data);
+extern void ata_dumb_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_noop_qc_prep(struct ata_queued_cmd *qc);
 extern unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
lots-of-architectures-enable-arbitary-speed-tty-support.patch
powerpc-enable-arbitary-speed-tty-ioctls-and-split.patch
nozomi-remove-termios-checks-from-various-old-char-serial-drivers.patch
ia64-arbitary-speed-tty-ioctl-support.patch
git-libata-all.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
pata_hpt3x3-major-reworking-and-testing.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch
ata-use-iomap_name.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
rfcomm-hangup-ttys-before-releasing-rfcomm_dev.patch
fix-gregkh-pci-pci-syscallc-switch-to-refcounting-api.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
ppa-coding-police-and-printk-levels.patch
mos7840c-turn-this-into-a-serial-driver.patch
pl2303-remove-bogus-checks-and-fix-speed-support-to-use.patch
visor-and-whiteheat-remove-bogus-termios-change-checks.patch
mos7720-remove-bogus-no-termios-change-check.patch
io_-remove-bogus-termios-no-change-checks.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh-fix.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
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
intel-rng-undo-mess-made-by-an-80-column-extremist.patch
improve-behaviour-of-spurious-irq-detect.patch
audit-add-tty-input-auditing.patch
audit-add-tty-input-auditing-fix.patch
audit-add-tty-input-auditing-fix-2.patch
revert-vanishing-ioctl-handler-debugging.patch
amiserial-remove-incorrect-no-termios-change-check.patch
genericserial-remove-bogus-optimisation-check-and-dead-code-paths.patch
synclink-remove-bogus-no-change-termios-optimisation.patch
68360serial-remove-broken-optimisation.patch
serial-remove-termios-checks-from-various-old-char-serial.patch
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
stallion-remove-unneeded-lock_kernel.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
driver-edac-add-mips-and-ppc-visibility.patch
driver-edac-mod-race-fix-i82875p.patch
driver-edac-fix-ignored-return-i82875p.patch
include-linux-pci_id-h-add-amd-northbridge-defines.patch
