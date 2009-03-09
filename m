From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 09 Mar 2009 16:02:58 -0700
Message-ID: <200903092320.n29NKjIO019240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752045AbZCIXVW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Mar 2009 19:21:22 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n29NKnWK014802
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 9 Mar 2009 16:20:50 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/Kconfig            |    3 
 drivers/ide/at91_ide.c         |   77 --------
 drivers/ide/ide-io.c           |   51 -----
 drivers/ide/ide-iops.c         |  274 -------------------------------
 drivers/ide/ide-probe.c        |   20 --
 drivers/watchdog/orion5x_wdt.c |    5 
 drivers/watchdog/rc32434_wdt.c |   99 -----------
 include/linux/ide.h            |    5 
 8 files changed, 534 deletions(-)

diff -puN drivers/ide/Kconfig~linux-next-git-rejects drivers/ide/Kconfig
--- a/drivers/ide/Kconfig~linux-next-git-rejects
+++ a/drivers/ide/Kconfig
@@ -731,14 +731,11 @@ config BLK_DEV_IDE_AT91
 	tristate "Atmel AT91 (SAM9, CAP9, AT572D940HF) IDE support"
 	depends on ARM && ARCH_AT91 && !ARCH_AT91RM9200 && !ARCH_AT91X40
 	select IDE_TIMINGS
-<<<<<<< HEAD:drivers/ide/Kconfig
 
 config IDE_ARM
 	tristate "ARM IDE support"
 	depends on ARM && (ARCH_RPC || ARCH_SHARK)
 	default y
-=======
->>>>>>> FETCH_HEAD:drivers/ide/Kconfig
 
 config BLK_DEV_IDE_ICSIDE
 	tristate "ICS IDE interface support"
diff -puN drivers/ide/at91_ide.c~linux-next-git-rejects drivers/ide/at91_ide.c
--- a/drivers/ide/at91_ide.c~linux-next-git-rejects
+++ a/drivers/ide/at91_ide.c
@@ -185,70 +185,22 @@ static void ide_mm_outb(u8 value, unsign
 	writeb(value, (void __iomem *) port);
 }
 
-<<<<<<< HEAD:drivers/ide/at91_ide.c
-static void at91_ide_tf_load(ide_drive_t *drive, ide_task_t *task)
-=======
 static void at91_ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
->>>>>>> FETCH_HEAD:drivers/ide/at91_ide.c
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	struct ide_taskfile *tf = &task->tf;
-<<<<<<< HEAD:drivers/ide/at91_ide.c
-	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
-
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
-		HIHI = 0xFF;
-
-	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
-=======
 	u8 HIHI = (cmd->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
 
 	if (cmd->tf_flags & IDE_FTFLAG_FLAGGED)
 		HIHI = 0xFF;
 
 	if (cmd->tf_flags & IDE_FTFLAG_OUT_DATA) {
->>>>>>> FETCH_HEAD:drivers/ide/at91_ide.c
 		u16 data = (tf->hob_data << 8) | tf->data;
 
 		at91_ide_output_data(drive, NULL, &data, 2);
 	}
 
-<<<<<<< HEAD:drivers/ide/at91_ide.c
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
-		ide_mm_outb(tf->hob_feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
-		ide_mm_outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
-		ide_mm_outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
-		ide_mm_outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
-		ide_mm_outb(tf->hob_lbah, io_ports->lbah_addr);
-
-	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
-		ide_mm_outb(tf->feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
-		ide_mm_outb(tf->nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
-		ide_mm_outb(tf->lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
-		ide_mm_outb(tf->lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
-		ide_mm_outb(tf->lbah, io_ports->lbah_addr);
-
-	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		ide_mm_outb((tf->device & HIHI) | drive->select, io_ports->device_addr);
-}
-
-static void at91_ide_tf_read(ide_drive_t *drive, ide_task_t *task)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
-
-	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
-=======
 	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
 		ide_mm_outb(tf->hob_feature, io_ports->feature_addr);
 	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
@@ -282,7 +234,6 @@ static void at91_ide_tf_read(ide_drive_t
 	struct ide_taskfile *tf = &cmd->tf;
 
 	if (cmd->tf_flags & IDE_FTFLAG_IN_DATA) {
->>>>>>> FETCH_HEAD:drivers/ide/at91_ide.c
 		u16 data;
 
 		at91_ide_input_data(drive, NULL, &data, 2);
@@ -293,33 +244,6 @@ static void at91_ide_tf_read(ide_drive_t
 	/* be sure we're looking at the low order bits */
 	ide_mm_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
-<<<<<<< HEAD:drivers/ide/at91_ide.c
-	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
-		tf->feature = ide_mm_inb(io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
-		tf->nsect  = ide_mm_inb(io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
-		tf->lbal   = ide_mm_inb(io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
-		tf->lbam   = ide_mm_inb(io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
-		tf->lbah   = ide_mm_inb(io_ports->lbah_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
-		tf->device = ide_mm_inb(io_ports->device_addr);
-
-	if (task->tf_flags & IDE_TFLAG_LBA48) {
-		ide_mm_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
-
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
-			tf->hob_feature = ide_mm_inb(io_ports->feature_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect   = ide_mm_inb(io_ports->nsect_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal    = ide_mm_inb(io_ports->lbal_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam    = ide_mm_inb(io_ports->lbam_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-=======
 	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
 		tf->feature = ide_mm_inb(io_ports->feature_addr);
 	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
@@ -345,7 +269,6 @@ static void at91_ide_tf_read(ide_drive_t
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
 			tf->hob_lbam    = ide_mm_inb(io_ports->lbam_addr);
 		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
->>>>>>> FETCH_HEAD:drivers/ide/at91_ide.c
 			tf->hob_lbah    = ide_mm_inb(io_ports->lbah_addr);
 	}
 }
diff -puN drivers/ide/ide-io.c~linux-next-git-rejects drivers/ide/ide-io.c
--- a/drivers/ide/ide-io.c~linux-next-git-rejects
+++ a/drivers/ide/ide-io.c
@@ -870,57 +870,6 @@ out_early:
 	return irq_ret;
 }
 EXPORT_SYMBOL_GPL(ide_intr);
-<<<<<<< HEAD:drivers/ide/ide-io.c
-
-/**
- *	ide_do_drive_cmd	-	issue IDE special command
- *	@drive: device to issue command
- *	@rq: request to issue
- *
- *	This function issues a special IDE device request
- *	onto the request queue.
- *
- *	the rq is queued at the head of the request queue, displacing
- *	the currently-being-processed request and this function
- *	returns immediately without waiting for the new rq to be
- *	completed.  This is VERY DANGEROUS, and is intended for
- *	careful use by the ATAPI tape/cdrom driver code.
- */
-
-void ide_do_drive_cmd(ide_drive_t *drive, struct request *rq)
-{
-	struct request_queue *q = drive->queue;
-	unsigned long flags;
-
-	drive->hwif->rq = NULL;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	__elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 0);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-}
-EXPORT_SYMBOL(ide_do_drive_cmd);
-
-void ide_pktcmd_tf_load(ide_drive_t *drive, u32 tf_flags, u16 bcount, u8 dma)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	ide_task_t task;
-
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_OUT_LBAH | IDE_TFLAG_OUT_LBAM |
-			IDE_TFLAG_OUT_FEATURE | tf_flags;
-	task.tf.feature = dma;		/* Use PIO/DMA */
-	task.tf.lbam    = bcount & 0xff;
-	task.tf.lbah    = (bcount >> 8) & 0xff;
-
-	ide_tf_dump(drive->name, &task.tf);
-	hwif->tp_ops->set_irq(hwif, 1);
-	SELECT_MASK(drive, 0);
-	hwif->tp_ops->tf_load(drive, &task);
-}
-
-EXPORT_SYMBOL_GPL(ide_pktcmd_tf_load);
-=======
->>>>>>> FETCH_HEAD:drivers/ide/ide-io.c
 
 void ide_pad_transfer(ide_drive_t *drive, int write, int len)
 {
diff -puN drivers/ide/ide-iops.c~linux-next-git-rejects drivers/ide/ide-iops.c
--- a/drivers/ide/ide-iops.c~linux-next-git-rejects
+++ a/drivers/ide/ide-iops.c
@@ -50,280 +50,6 @@ void SELECT_MASK(ide_drive_t *drive, int
 		port_ops->maskproc(drive, mask);
 }
 
-<<<<<<< HEAD:drivers/ide/ide-iops.c
-void ide_exec_command(ide_hwif_t *hwif, u8 cmd)
-{
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		writeb(cmd, (void __iomem *)hwif->io_ports.command_addr);
-	else
-		outb(cmd, hwif->io_ports.command_addr);
-}
-EXPORT_SYMBOL_GPL(ide_exec_command);
-
-u8 ide_read_status(ide_hwif_t *hwif)
-{
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		return readb((void __iomem *)hwif->io_ports.status_addr);
-	else
-		return inb(hwif->io_ports.status_addr);
-}
-EXPORT_SYMBOL_GPL(ide_read_status);
-
-u8 ide_read_altstatus(ide_hwif_t *hwif)
-{
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		return readb((void __iomem *)hwif->io_ports.ctl_addr);
-	else
-		return inb(hwif->io_ports.ctl_addr);
-}
-EXPORT_SYMBOL_GPL(ide_read_altstatus);
-
-void ide_set_irq(ide_hwif_t *hwif, int on)
-{
-	u8 ctl = ATA_DEVCTL_OBS;
-
-	if (on == 4) { /* hack for SRST */
-		ctl |= 4;
-		on &= ~4;
-	}
-
-	ctl |= on ? 0 : 2;
-
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		writeb(ctl, (void __iomem *)hwif->io_ports.ctl_addr);
-	else
-		outb(ctl, hwif->io_ports.ctl_addr);
-}
-EXPORT_SYMBOL_GPL(ide_set_irq);
-
-void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
-	void (*tf_outb)(u8 addr, unsigned long port);
-	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
-
-	if (mmio)
-		tf_outb = ide_mm_outb;
-	else
-		tf_outb = ide_outb;
-
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
-		HIHI = 0xFF;
-
-	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
-		u16 data = (tf->hob_data << 8) | tf->data;
-
-		if (mmio)
-			writew(data, (void __iomem *)io_ports->data_addr);
-		else
-			outw(data, io_ports->data_addr);
-	}
-
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
-		tf_outb(tf->hob_feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
-		tf_outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
-		tf_outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
-		tf_outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
-		tf_outb(tf->hob_lbah, io_ports->lbah_addr);
-
-	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
-		tf_outb(tf->feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
-		tf_outb(tf->nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
-		tf_outb(tf->lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
-		tf_outb(tf->lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
-		tf_outb(tf->lbah, io_ports->lbah_addr);
-
-	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		tf_outb((tf->device & HIHI) | drive->select,
-			 io_ports->device_addr);
-}
-EXPORT_SYMBOL_GPL(ide_tf_load);
-
-void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
-	void (*tf_outb)(u8 addr, unsigned long port);
-	u8 (*tf_inb)(unsigned long port);
-	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-
-	if (mmio) {
-		tf_outb = ide_mm_outb;
-		tf_inb  = ide_mm_inb;
-	} else {
-		tf_outb = ide_outb;
-		tf_inb  = ide_inb;
-	}
-
-	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
-		u16 data;
-
-		if (mmio)
-			data = readw((void __iomem *)io_ports->data_addr);
-		else
-			data = inw(io_ports->data_addr);
-
-		tf->data = data & 0xff;
-		tf->hob_data = (data >> 8) & 0xff;
-	}
-
-	/* be sure we're looking at the low order bits */
-	tf_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
-
-	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
-		tf->feature = tf_inb(io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
-		tf->nsect  = tf_inb(io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
-		tf->lbal   = tf_inb(io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
-		tf->lbam   = tf_inb(io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
-		tf->lbah   = tf_inb(io_ports->lbah_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
-		tf->device = tf_inb(io_ports->device_addr);
-
-	if (task->tf_flags & IDE_TFLAG_LBA48) {
-		tf_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
-
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
-			tf->hob_feature = tf_inb(io_ports->feature_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect   = tf_inb(io_ports->nsect_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal    = tf_inb(io_ports->lbal_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam    = tf_inb(io_ports->lbam_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah    = tf_inb(io_ports->lbah_addr);
-	}
-}
-EXPORT_SYMBOL_GPL(ide_tf_read);
-
-/*
- * Some localbus EIDE interfaces require a special access sequence
- * when using 32-bit I/O instructions to transfer data.  We call this
- * the "vlb_sync" sequence, which consists of three successive reads
- * of the sector count register location, with interrupts disabled
- * to ensure that the reads all happen together.
- */
-static void ata_vlb_sync(unsigned long port)
-{
-	(void)inb(port);
-	(void)inb(port);
-	(void)inb(port);
-}
-
-/*
- * This is used for most PIO data transfers *from* the IDE interface
- *
- * These routines will round up any request for an odd number of bytes,
- * so if an odd len is specified, be sure that there's at least one
- * extra byte allocated for the buffer.
- */
-void ide_input_data(ide_drive_t *drive, struct request *rq, void *buf,
-		    unsigned int len)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	unsigned long data_addr = io_ports->data_addr;
-	u8 io_32bit = drive->io_32bit;
-	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-
-	len++;
-
-	if (io_32bit) {
-		unsigned long uninitialized_var(flags);
-
-		if ((io_32bit & 2) && !mmio) {
-			local_irq_save(flags);
-			ata_vlb_sync(io_ports->nsect_addr);
-		}
-
-		if (mmio)
-			__ide_mm_insl((void __iomem *)data_addr, buf, len / 4);
-		else
-			insl(data_addr, buf, len / 4);
-
-		if ((io_32bit & 2) && !mmio)
-			local_irq_restore(flags);
-
-		if ((len & 3) >= 2) {
-			if (mmio)
-				__ide_mm_insw((void __iomem *)data_addr,
-						(u8 *)buf + (len & ~3), 1);
-			else
-				insw(data_addr, (u8 *)buf + (len & ~3), 1);
-		}
-	} else {
-		if (mmio)
-			__ide_mm_insw((void __iomem *)data_addr, buf, len / 2);
-		else
-			insw(data_addr, buf, len / 2);
-	}
-}
-EXPORT_SYMBOL_GPL(ide_input_data);
-
-/*
- * This is used for most PIO data transfers *to* the IDE interface
- */
-void ide_output_data(ide_drive_t *drive, struct request *rq, void *buf,
-		     unsigned int len)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	unsigned long data_addr = io_ports->data_addr;
-	u8 io_32bit = drive->io_32bit;
-	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-
-	len++;
-
-	if (io_32bit) {
-		unsigned long uninitialized_var(flags);
-
-		if ((io_32bit & 2) && !mmio) {
-			local_irq_save(flags);
-			ata_vlb_sync(io_ports->nsect_addr);
-		}
-
-		if (mmio)
-			__ide_mm_outsl((void __iomem *)data_addr, buf, len / 4);
-		else
-			outsl(data_addr, buf, len / 4);
-
-		if ((io_32bit & 2) && !mmio)
-			local_irq_restore(flags);
-
-		if ((len & 3) >= 2) {
-			if (mmio)
-				__ide_mm_outsw((void __iomem *)data_addr,
-						 (u8 *)buf + (len & ~3), 1);
-			else
-				outsw(data_addr, (u8 *)buf + (len & ~3), 1);
-		}
-	} else {
-		if (mmio)
-			__ide_mm_outsw((void __iomem *)data_addr, buf, len / 2);
-		else
-			outsw(data_addr, buf, len / 2);
-	}
-}
-EXPORT_SYMBOL_GPL(ide_output_data);
-
-=======
->>>>>>> FETCH_HEAD:drivers/ide/ide-iops.c
 u8 ide_read_error(ide_drive_t *drive)
 {
 	struct ide_cmd cmd;
diff -puN drivers/ide/ide-probe.c~linux-next-git-rejects drivers/ide/ide-probe.c
--- a/drivers/ide/ide-probe.c~linux-next-git-rejects
+++ a/drivers/ide/ide-probe.c
@@ -837,29 +837,9 @@ static int ide_port_setup_devices(ide_hw
 static int init_irq (ide_hwif_t *hwif)
 {
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-<<<<<<< HEAD:drivers/ide/ide-probe.c
-	irq_handler_t irq_handler;
-	int sa = 0;
-
-	mutex_lock(&ide_cfg_mtx);
-	spin_lock_init(&hwif->lock);
-
-	init_timer(&hwif->timer);
-	hwif->timer.function = &ide_timer_expiry;
-	hwif->timer.data = (unsigned long)hwif;
-
-	irq_handler = hwif->host->irq_handler;
-	if (irq_handler == NULL)
-		irq_handler = ide_intr;
-
-#if defined(__mc68000__)
-	sa = IRQF_SHARED;
-#endif /* __mc68000__ */
-=======
 	struct ide_host *host = hwif->host;
 	irq_handler_t irq_handler = host->irq_handler;
 	int sa = host->irq_flags;
->>>>>>> FETCH_HEAD:drivers/ide/ide-probe.c
 
 	if (irq_handler == NULL)
 		irq_handler = ide_intr;
diff -puN drivers/watchdog/orion5x_wdt.c~linux-next-git-rejects drivers/watchdog/orion5x_wdt.c
--- a/drivers/watchdog/orion5x_wdt.c~linux-next-git-rejects
+++ a/drivers/watchdog/orion5x_wdt.c
@@ -31,12 +31,7 @@
 #define  WDT_EN			0x0010
 #define WDT_VAL			(TIMER_VIRT_BASE + 0x0024)
 
-<<<<<<< HEAD:drivers/watchdog/orion5x_wdt.c
-#define ORION5X_TCLK		166666667
-#define WDT_MAX_DURATION	(0xffffffff / ORION5X_TCLK)
-=======
 #define WDT_MAX_CYCLE_COUNT	0xffffffff
->>>>>>> FETCH_HEAD:drivers/watchdog/orion5x_wdt.c
 #define WDT_IN_USE		0
 #define WDT_OK_TO_CLOSE		1
 
diff -puN drivers/watchdog/rc32434_wdt.c~linux-next-git-rejects drivers/watchdog/rc32434_wdt.c
--- a/drivers/watchdog/rc32434_wdt.c~linux-next-git-rejects
+++ a/drivers/watchdog/rc32434_wdt.c
@@ -17,26 +17,6 @@
  *
  */
 
-<<<<<<< HEAD:drivers/watchdog/rc32434_wdt.c
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/fs.h>
-#include <linux/mm.h>
-#include <linux/miscdevice.h>
-#include <linux/watchdog.h>
-#include <linux/reboot.h>
-#include <linux/smp_lock.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/uaccess.h>
-
-#include <asm/bootinfo.h>
-#include <asm/time.h>
-#include <asm/mach-rc32434/integ.h>
-
-#define VERSION "0.4"
-=======
 #include <linux/module.h>		/* For module specific items */
 #include <linux/moduleparam.h>		/* For new moduleparam's */
 #include <linux/types.h>		/* For standard types (like size_t) */
@@ -56,7 +36,6 @@
 #define PFX KBUILD_MODNAME ": "
 
 #define VERSION "1.0"
->>>>>>> FETCH_HEAD:drivers/watchdog/rc32434_wdt.c
 
 static struct {
 	unsigned long inuse;
@@ -81,12 +60,9 @@ extern unsigned int idt_cpu_freq;
 #define WATCHDOG_TIMEOUT 20
 
 static int timeout = WATCHDOG_TIMEOUT;
-<<<<<<< HEAD:drivers/watchdog/rc32434_wdt.c
-=======
 module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout, "Watchdog timeout value, in seconds (default="
 		WATCHDOG_TIMEOUT ")");
->>>>>>> FETCH_HEAD:drivers/watchdog/rc32434_wdt.c
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
@@ -99,50 +75,6 @@ MODULE_PARM_DESC(nowayout, "Watchdog can
 
 static int rc32434_wdt_set(int new_timeout)
 {
-<<<<<<< HEAD:drivers/watchdog/rc32434_wdt.c
-	u32 or, nand;
-
-	/* zero the counter before enabling */
-	writel(0, &wdt_reg->wtcount);
-
-	/* don't generate a non-maskable interrupt,
-	 * do a warm reset instead */
-	nand = 1 << RC32434_ERR_WNE;
-	or = 1 << RC32434_ERR_WRE;
-
-	/* reset the ERRCS timeout bit in case it's set */
-	nand |= 1 << RC32434_ERR_WTO;
-
-	SET_BITS(wdt_reg->errcs, or, nand);
-
-	/* reset WTC timeout bit and enable WDT */
-	nand = 1 << RC32434_WTC_TO;
-	or = 1 << RC32434_WTC_EN;
-
-	SET_BITS(wdt_reg->wtc, or, nand);
-}
-
-static void rc32434_wdt_stop(void)
-{
-	/* Disable WDT */
-	SET_BITS(wdt_reg->wtc, 0, 1 << RC32434_WTC_EN);
-}
-
-static int rc32434_wdt_set(int new_timeout)
-{
-	int max_to = WTCOMP2SEC((u32)-1);
-
-	if (new_timeout < 0 || new_timeout > max_to) {
-		printk(KERN_ERR KBUILD_MODNAME
-			": timeout value must be between 0 and %d",
-			max_to);
-		return -EINVAL;
-	}
-	timeout = new_timeout;
-	writel(SEC2WTCOMP(timeout), &wdt_reg->wtcompare);
-
-	return 0;
-=======
 	int max_to = WTCOMP2SEC((u32)-1);
 
 	if (new_timeout < 0 || new_timeout > max_to) {
@@ -199,18 +131,13 @@ static void rc32434_wdt_stop(void)
 
 	spin_unlock(&rc32434_wdt_device.io_lock);
 	printk(KERN_INFO PFX "Stopped watchdog timer.\n");
->>>>>>> FETCH_HEAD:drivers/watchdog/rc32434_wdt.c
 }
 
 static void rc32434_wdt_ping(void)
 {
-<<<<<<< HEAD:drivers/watchdog/rc32434_wdt.c
-	writel(0, &wdt_reg->wtcount);
-=======
 	spin_lock(&rc32434_wdt_device.io_lock);
 	writel(0, &wdt_reg->wtcount);
 	spin_unlock(&rc32434_wdt_device.io_lock);
->>>>>>> FETCH_HEAD:drivers/watchdog/rc32434_wdt.c
 }
 
 static int rc32434_wdt_open(struct inode *inode, struct file *file)
@@ -233,13 +160,8 @@ static int rc32434_wdt_release(struct in
 		rc32434_wdt_stop();
 		module_put(THIS_MODULE);
 	} else {
-<<<<<<< HEAD:drivers/watchdog/rc32434_wdt.c
-		printk(KERN_CRIT KBUILD_MODNAME
-			": device closed unexpectedly. WDT will not stop !\n");
-=======
 		printk(KERN_CRIT PFX
 			"device closed unexpectedly. WDT will not stop!\n");
->>>>>>> FETCH_HEAD:drivers/watchdog/rc32434_wdt.c
 		rc32434_wdt_ping();
 	}
 	clear_bit(0, &rc32434_wdt_device.inuse);
@@ -283,14 +205,9 @@ static long rc32434_wdt_ioctl(struct fil
 		.identity =		"RC32434_WDT Watchdog",
 	};
 	switch (cmd) {
-<<<<<<< HEAD:drivers/watchdog/rc32434_wdt.c
-	case WDIOC_KEEPALIVE:
-		rc32434_wdt_ping();
-=======
 	case WDIOC_GETSUPPORT:
 		if (copy_to_user(argp, &ident, sizeof(ident)))
 			return -EFAULT;
->>>>>>> FETCH_HEAD:drivers/watchdog/rc32434_wdt.c
 		break;
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
@@ -345,13 +262,8 @@ static struct miscdevice rc32434_wdt_mis
 	.fops	= &rc32434_wdt_fops,
 };
 
-<<<<<<< HEAD:drivers/watchdog/rc32434_wdt.c
-static char banner[] __devinitdata = KERN_INFO KBUILD_MODNAME
-		": Watchdog Timer version " VERSION ", timer margin: %d sec\n";
-=======
 static char banner[] __devinitdata = KERN_INFO PFX
 		"Watchdog Timer version " VERSION ", timer margin: %d sec\n";
->>>>>>> FETCH_HEAD:drivers/watchdog/rc32434_wdt.c
 
 static int __devinit rc32434_wdt_probe(struct platform_device *pdev)
 {
@@ -370,8 +282,6 @@ static int __devinit rc32434_wdt_probe(s
 		return -ENXIO;
 	}
 
-<<<<<<< HEAD:drivers/watchdog/rc32434_wdt.c
-=======
 	spin_lock_init(&rc32434_wdt_device.io_lock);
 
 	/* Make sure the watchdog is not running */
@@ -386,7 +296,6 @@ static int __devinit rc32434_wdt_probe(s
 			WTCOMP2SEC((u32)-1));
 	}
 
->>>>>>> FETCH_HEAD:drivers/watchdog/rc32434_wdt.c
 	ret = misc_register(&rc32434_wdt_miscdev);
 	if (ret < 0) {
 		printk(KERN_ERR PFX "failed to register watchdog device\n");
@@ -409,13 +318,6 @@ static int __devexit rc32434_wdt_remove(
 	return 0;
 }
 
-<<<<<<< HEAD:drivers/watchdog/rc32434_wdt.c
-static struct platform_driver rc32434_wdt = {
-	.probe	= rc32434_wdt_probe,
-	.remove	= __devexit_p(rc32434_wdt_remove),
-	.driver	= {
-		.name = "rc32434_wdt",
-=======
 static void rc32434_wdt_shutdown(struct platform_device *pdev)
 {
 	rc32434_wdt_stop();
@@ -427,7 +329,6 @@ static struct platform_driver rc32434_wd
 	.shutdown	= rc32434_wdt_shutdown,
 	.driver		= {
 			.name = "rc32434_wdt",
->>>>>>> FETCH_HEAD:drivers/watchdog/rc32434_wdt.c
 	}
 };
 
diff -puN include/linux/ide.h~linux-next-git-rejects include/linux/ide.h
--- a/include/linux/ide.h~linux-next-git-rejects
+++ a/include/linux/ide.h
@@ -838,10 +838,6 @@ struct ide_host {
 	ide_hwif_t	*ports[MAX_HOST_PORTS + 1];
 	unsigned int	n_ports;
 	struct device	*dev[2];
-<<<<<<< HEAD:include/linux/ide.h
-	unsigned int	(*init_chipset)(struct pci_dev *);
-	irq_handler_t	irq_handler;
-=======
 
 	int		(*init_chipset)(struct pci_dev *);
 
@@ -850,7 +846,6 @@ struct ide_host {
 
 	irq_handler_t	irq_handler;
 
->>>>>>> FETCH_HEAD:include/linux/ide.h
 	unsigned long	host_flags;
 
 	int		irq_flags;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mtd_dataflash-fix-probing-of-at45db321c-chips-checkpatch-fixes.patch
fix-fixpoint-divide-exception-in-acct_update_integrals-checkpatch-fixes.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
git-acpi-vs-git-cpufreq.patch
i-need-old-gcc.patch
toshiba_acpi-add-full-hotkey-support-fix.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
arch-x86-mm-iomap_32c-fix-warning.patch
kernel-auditscc-fix-warning.patch
early-platform-driver-v3.patch
sysfs-dont-block-indefinitely-for-unmapped-files.patch
drivers-gpu-drm-drm_infoc-fix-warnings.patch
drivers-media-video-zoran-zoran_driverc-fix-printk-warning.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
leds-add-bd2802gu-led-driver.patch
mmc-add-extended-csd-register-to-debugfs.patch
mtd-rbtx4939-add-mtd-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2-checkpatch-fixes.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
vfs-simple_set_mnt-should-return-void.patch
libfs-make-simple_read_from_buffer-conventional-fix.patch
vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held-checkpatch-fixes.patch
xtensa-add-flat-support-checkpatch-fixes.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page-fix.patch
mm-fix-proc_dointvec_userhz_jiffies-breakage-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
do_pipe-drop-its-last-user-in-arch-alpha-checkpatch-fixes.patch
alpha-convert-u64-to-unsigned-long-long-fix.patch
alpha-convert-u64-to-unsigned-long-long-fix-2.patch
alpha-convert-u64-to-unsigned-long-long-fix-3-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
ubd-stop-defintining-major_nr-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios-fix.patch
rtc-test-before-subtraction-on-unsigned-fix.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cirrusfb-convert-printks-to-dev_foo-fix.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
cirrusfb-fix-clock-doubling-fix.patch
fbdev-uninline-lock_fb_info.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-checkpatch-fixes.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-simplification.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix-checkpatch-fixes.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
nilfs2-segment-buffer-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

