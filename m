From: akpm@linux-foundation.org
Subject: - cleanup-after-apus-removal.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:21:22 -0800
Message-ID: <200802070021.m170L3x9006286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59080 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763416AbYBGAqm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:46:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, James.Bottomley@steeleye.com, adaplas@pol.net, bzolnier@gmail.com, geert@linux-m68k.org, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     cleanup after APUS removal
has been removed from the -mm tree.  Its filename was
     cleanup-after-apus-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cleanup after APUS removal
From: Adrian Bunk <bunk@kernel.org>

After the APUS removal, some code can be removed.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Karsten Keil <kkeil@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/amiga/chipram.c           |    2 --
 drivers/ide/ide-probe.c             |    6 +++---
 drivers/isdn/hisax/avm_pci.c        |    8 --------
 drivers/scsi/a2091.c                |    3 +--
 drivers/scsi/a3000.c                |    3 +--
 drivers/scsi/gvp11.c                |    3 +--
 drivers/video/console/fbcon.c       |    2 +-
 drivers/video/console/fonts.c       |    4 ++--
 include/asm-m68k/pgtable.h          |    2 --
 sound/oss/dmasound/Kconfig          |    2 +-
 sound/oss/dmasound/dmasound_paula.c |    4 ----
 11 files changed, 10 insertions(+), 29 deletions(-)

diff -puN arch/m68k/amiga/chipram.c~cleanup-after-apus-removal arch/m68k/amiga/chipram.c
--- a/arch/m68k/amiga/chipram.c~cleanup-after-apus-removal
+++ a/arch/m68k/amiga/chipram.c
@@ -32,12 +32,10 @@ void __init amiga_chip_init(void)
     if (!AMIGAHW_PRESENT(CHIP_RAM))
 	return;
 
-#ifndef CONFIG_APUS_FAST_EXCEPT
     /*
      *  Remove the first 4 pages where PPC exception handlers will be located
      */
     amiga_chip_size -= 0x4000;
-#endif
     chipram_res.end = amiga_chip_size-1;
     request_resource(&iomem_resource, &chipram_res);
 
diff -puN drivers/ide/ide-probe.c~cleanup-after-apus-removal drivers/ide/ide-probe.c
--- a/drivers/ide/ide-probe.c~cleanup-after-apus-removal
+++ a/drivers/ide/ide-probe.c
@@ -1049,7 +1049,7 @@ static int init_irq (ide_hwif_t *hwif)
 	 */
 	if (!match || match->irq != hwif->irq) {
 		int sa = 0;
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 		sa = IRQF_SHARED;
 #endif /* __mc68000__ || CONFIG_APUS */
 
@@ -1072,7 +1072,7 @@ static int init_irq (ide_hwif_t *hwif)
 			hwif->rqsize = 65536;
 	}
 
-#if !defined(__mc68000__) && !defined(CONFIG_APUS)
+#if !defined(__mc68000__)
 	printk("%s at 0x%03lx-0x%03lx,0x%03lx on irq %d", hwif->name,
 		hwif->io_ports[IDE_DATA_OFFSET],
 		hwif->io_ports[IDE_DATA_OFFSET]+7,
@@ -1080,7 +1080,7 @@ static int init_irq (ide_hwif_t *hwif)
 #else
 	printk("%s at 0x%08lx on irq %d", hwif->name,
 		hwif->io_ports[IDE_DATA_OFFSET], hwif->irq);
-#endif /* __mc68000__ && CONFIG_APUS */
+#endif /* __mc68000__ */
 	if (match)
 		printk(" (%sed with %s)",
 			hwif->sharing_irq ? "shar" : "serializ", match->name);
diff -puN drivers/isdn/hisax/avm_pci.c~cleanup-after-apus-removal drivers/isdn/hisax/avm_pci.c
--- a/drivers/isdn/hisax/avm_pci.c~cleanup-after-apus-removal
+++ a/drivers/isdn/hisax/avm_pci.c
@@ -263,11 +263,7 @@ hdlc_empty_fifo(struct BCState *bcs, int
 		outl(idx, cs->hw.avm.cfg_reg + 4);
 		while (cnt < count) {
 #ifdef __powerpc__
-#ifdef CONFIG_APUS
-			*ptr++ = in_le32((unsigned *)(cs->hw.avm.isac +_IO_BASE));
-#else
 			*ptr++ = in_be32((unsigned *)(cs->hw.avm.isac +_IO_BASE));
-#endif /* CONFIG_APUS */
 #else
 			*ptr++ = inl(cs->hw.avm.isac);
 #endif /* __powerpc__ */
@@ -328,11 +324,7 @@ hdlc_fill_fifo(struct BCState *bcs)
 	if (cs->subtyp == AVM_FRITZ_PCI) {
 		while (cnt<count) {
 #ifdef __powerpc__
-#ifdef CONFIG_APUS
-			out_le32((unsigned *)(cs->hw.avm.isac +_IO_BASE), *ptr++);
-#else
 			out_be32((unsigned *)(cs->hw.avm.isac +_IO_BASE), *ptr++);
-#endif /* CONFIG_APUS */
 #else
 			outl(*ptr++, cs->hw.avm.isac);
 #endif /* __powerpc__ */
diff -puN drivers/scsi/a2091.c~cleanup-after-apus-removal drivers/scsi/a2091.c
--- a/drivers/scsi/a2091.c~cleanup-after-apus-removal
+++ a/drivers/scsi/a2091.c
@@ -46,8 +46,7 @@ static int dma_setup(struct scsi_cmnd *c
     struct Scsi_Host *instance = cmd->device->host;
 
     /* don't allow DMA if the physical address is bad */
-    if (addr & A2091_XFER_MASK ||
-	(!dir_in && mm_end_of_chunk (addr, cmd->SCp.this_residual)))
+    if (addr & A2091_XFER_MASK)
     {
 	HDATA(instance)->dma_bounce_len = (cmd->SCp.this_residual + 511)
 	    & ~0x1ff;
diff -puN drivers/scsi/a3000.c~cleanup-after-apus-removal drivers/scsi/a3000.c
--- a/drivers/scsi/a3000.c~cleanup-after-apus-removal
+++ a/drivers/scsi/a3000.c
@@ -54,8 +54,7 @@ static int dma_setup(struct scsi_cmnd *c
      * end of a physical memory chunk, then allocate a bounce
      * buffer
      */
-    if (addr & A3000_XFER_MASK ||
-	(!dir_in && mm_end_of_chunk (addr, cmd->SCp.this_residual)))
+    if (addr & A3000_XFER_MASK)
     {
 	HDATA(a3000_host)->dma_bounce_len = (cmd->SCp.this_residual + 511)
 	    & ~0x1ff;
diff -puN drivers/scsi/gvp11.c~cleanup-after-apus-removal drivers/scsi/gvp11.c
--- a/drivers/scsi/gvp11.c~cleanup-after-apus-removal
+++ a/drivers/scsi/gvp11.c
@@ -54,8 +54,7 @@ static int dma_setup(struct scsi_cmnd *c
     static int scsi_alloc_out_of_range = 0;
 
     /* use bounce buffer if the physical address is bad */
-    if (addr & HDATA(cmd->device->host)->dma_xfer_mask ||
-	(!dir_in && mm_end_of_chunk (addr, cmd->SCp.this_residual)))
+    if (addr & HDATA(cmd->device->host)->dma_xfer_mask)
     {
 	HDATA(cmd->device->host)->dma_bounce_len = (cmd->SCp.this_residual + 511)
 	    & ~0x1ff;
diff -puN drivers/video/console/fbcon.c~cleanup-after-apus-removal drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~cleanup-after-apus-removal
+++ a/drivers/video/console/fbcon.c
@@ -84,7 +84,7 @@
 #ifdef CONFIG_MAC
 #include <asm/macints.h>
 #endif
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 #include <asm/machdep.h>
 #include <asm/setup.h>
 #endif
diff -puN drivers/video/console/fonts.c~cleanup-after-apus-removal drivers/video/console/fonts.c
--- a/drivers/video/console/fonts.c~cleanup-after-apus-removal
+++ a/drivers/video/console/fonts.c
@@ -15,7 +15,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 #include <asm/setup.h>
 #endif
 #include <linux/font.h>
@@ -120,7 +120,7 @@ const struct font_desc *get_default_font
     for(i=0; i<num_fonts; i++) {
 	f = fonts[i];
 	c = f->pref;
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 #ifdef CONFIG_FONT_PEARL_8x8
 	if (MACH_IS_AMIGA && f->idx == PEARL8x8_IDX)
 	    c = 100;
diff -puN include/asm-m68k/pgtable.h~cleanup-after-apus-removal include/asm-m68k/pgtable.h
--- a/include/asm-m68k/pgtable.h~cleanup-after-apus-removal
+++ a/include/asm-m68k/pgtable.h
@@ -107,8 +107,6 @@ extern void *empty_zero_page;
 /* 64-bit machines, beware!  SRB. */
 #define SIZEOF_PTR_LOG2			       2
 
-#define mm_end_of_chunk(addr, len)	0
-
 extern void kernel_set_cachemode(void *addr, unsigned long size, int cmode);
 
 /*
diff -puN sound/oss/dmasound/Kconfig~cleanup-after-apus-removal sound/oss/dmasound/Kconfig
--- a/sound/oss/dmasound/Kconfig~cleanup-after-apus-removal
+++ a/sound/oss/dmasound/Kconfig
@@ -14,7 +14,7 @@ config DMASOUND_ATARI
 
 config DMASOUND_PAULA
 	tristate "Amiga DMA sound support"
-	depends on (AMIGA || APUS) && SOUND
+	depends on AMIGA && SOUND
 	select DMASOUND
 	help
 	  If you want to use the internal audio of your Amiga in Linux, answer
diff -puN sound/oss/dmasound/dmasound_paula.c~cleanup-after-apus-removal sound/oss/dmasound/dmasound_paula.c
--- a/sound/oss/dmasound/dmasound_paula.c~cleanup-after-apus-removal
+++ a/sound/oss/dmasound/dmasound_paula.c
@@ -91,10 +91,6 @@ static irqreturn_t AmiInterrupt(int irq,
      *  power LED are controlled by the same line.
      */
 
-#ifdef CONFIG_APUS
-#define mach_heartbeat	ppc_md.heartbeat
-#endif
-
 static void (*saved_heartbeat)(int) = NULL;
 
 static inline void disable_heartbeat(void)
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
move-edactxt-two-levels-up.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch
