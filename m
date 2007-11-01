From: akpm@linux-foundation.org
Subject: + cleanup-after-apus-removal.patch added to -mm tree
Date: Thu, 01 Nov 2007 00:41:07 -0700
Message-ID: <200711010741.lA17f7YA018673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54601 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754228AbXKAHlo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 03:41:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, James.Bottomley@steeleye.com, adaplas@pol.net, bzolnier@gmail.com, geert@linux-m68k.org, kkeil@suse.de


The patch titled
     cleanup after APUS removal
has been added to the -mm tree.  Its filename is
     cleanup-after-apus-removal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 arch/m68k/amiga/chipram.c           |    2 
 drivers/ide/ide-probe.c             |    6 +-
 drivers/isdn/hisax/avm_pci.c        |    8 --
 drivers/scsi/a2091.c                |    3 -
 drivers/scsi/a3000.c                |    3 -
 drivers/scsi/gvp11.c                |    3 -
 drivers/scsi/oktagon_esp.c          |    2 
 drivers/scsi/oktagon_io.S           |   72 --------------------------
 drivers/video/console/fbcon.c       |    2 
 drivers/video/console/fonts.c       |    4 -
 include/asm-m68k/pgtable.h          |    2 
 sound/oss/dmasound/Kconfig          |    2 
 sound/oss/dmasound/dmasound_paula.c |    4 -
 13 files changed, 11 insertions(+), 102 deletions(-)

diff -puN arch/m68k/amiga/chipram.c~cleanup-after-apus-removal arch/m68k/amiga/chipram.c
--- a/arch/m68k/amiga/chipram.c~cleanup-after-apus-removal
+++ a/arch/m68k/amiga/chipram.c
@@ -29,12 +29,10 @@ void __init amiga_chip_init(void)
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
@@ -1057,7 +1057,7 @@ static int init_irq (ide_hwif_t *hwif)
 	 */
 	if (!match || match->irq != hwif->irq) {
 		int sa = 0;
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 		sa = IRQF_SHARED;
 #endif /* __mc68000__ || CONFIG_APUS */
 
@@ -1098,7 +1098,7 @@ static int init_irq (ide_hwif_t *hwif)
 		spin_unlock_irq(&ide_lock);
 	}
 
-#if !defined(__mc68000__) && !defined(CONFIG_APUS)
+#if !defined(__mc68000__)
 	printk("%s at 0x%03lx-0x%03lx,0x%03lx on irq %d", hwif->name,
 		hwif->io_ports[IDE_DATA_OFFSET],
 		hwif->io_ports[IDE_DATA_OFFSET]+7,
@@ -1106,7 +1106,7 @@ static int init_irq (ide_hwif_t *hwif)
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
@@ -270,11 +270,7 @@ hdlc_empty_fifo(struct BCState *bcs, int
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
@@ -335,11 +331,7 @@ hdlc_fill_fifo(struct BCState *bcs)
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
diff -puN drivers/scsi/oktagon_esp.c~cleanup-after-apus-removal drivers/scsi/oktagon_esp.c
--- a/drivers/scsi/oktagon_esp.c~cleanup-after-apus-removal
+++ a/drivers/scsi/oktagon_esp.c
@@ -7,7 +7,7 @@
  */
 
 
-#if defined(CONFIG_AMIGA) || defined(CONFIG_APUS)
+#if defined(CONFIG_AMIGA)
 #define USE_BOTTOM_HALF
 #endif
 
diff -puN drivers/scsi/oktagon_io.S~cleanup-after-apus-removal drivers/scsi/oktagon_io.S
--- a/drivers/scsi/oktagon_io.S~cleanup-after-apus-removal
+++ a/drivers/scsi/oktagon_io.S
@@ -24,77 +24,6 @@ int oktag_from_io(long *addr,long *paddr
  */
 
 
-#ifdef CONFIG_APUS
-
-	.file	"oktagon_io.c"
-
-gcc2_compiled.:
-/*
-	.section ".text"
-*/
-	.align 2
-	.globl oktag_to_io
-	.type	 oktag_to_io,@function
-oktag_to_io:
-	addi 5,5,3
-	srwi 5,5,2
-	cmpwi 1,5,0
-	mr 9,3
-	mr 3,4
-	addi 5,5,-1
-	bc 12,6,.L3
-.L5:
-	cmpwi 1,5,0
-	lwz 0,0(3)
-	addi 3,3,4
-	addi 5,5,-1
-exp1:	stw 0,0(9)
-	bc 4,6,.L5
-.L3:
-ret1:	subf 3,4,3
-	srawi 3,3,2
-	blr
-.Lfe1:
-	.size	 oktag_to_io,.Lfe1-oktag_to_io
-	.align 2
-	.globl oktag_from_io
-	.type	 oktag_from_io,@function
-oktag_from_io:
-	addi 5,5,3
-	srwi 5,5,2
-	cmpwi 1,5,0
-	mr 9,3
-	addi 5,5,-1
-	bc 12,6,.L9
-.L11:
-	cmpwi 1,5,0
-exp2:	lwz 0,0(4)
-	addi 5,5,-1
-	stw 0,0(3)
-	addi 3,3,4
-	bc 4,6,.L11
-.L9:
-ret2:	subf 3,9,3
-	srawi 3,3,2
-	blr
-.Lfe2:
-	.size	 oktag_from_io,.Lfe2-oktag_from_io
-	.ident	"GCC: (GNU) egcs-2.90.29 980515 (egcs-1.0.3 release)"
-
-/*
- * Exception table.
- * Second longword shows where to jump when an exception at the addr the first
- * longword is pointing to is caught.
- */
-
-.section __ex_table,"a"
-	.align	2
-oktagon_except:
-	.long	exp1,ret1
-	.long	exp2,ret2
-
-#else
-
 /*
 The code which follows is for 680x0 based assembler and is meant for
 Linux/m68k. It was created by cross compiling the code using the
@@ -191,4 +120,3 @@ oktagon_except:
 	.long	exp2,ret2
 
 #endif
-#endif
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
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-hwmon.patch
git-input.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-sh64.patch
scsi-advansysc-make-3-functions-static.patch
git-block.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
kernel-taskstatsc-fix-bogus-nlmsg_free.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
scheduled-oss-driver-removal.patch
cleanup-after-apus-removal.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
make-jbd-journalc__journal_abort_hard-static.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch
