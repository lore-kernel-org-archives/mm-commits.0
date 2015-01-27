From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 27 Jan 2015 12:22:09 -0800
Message-ID: <54c7f371.nLz1dn3DtTNy6rUQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbbA0UWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jan 2015 15:22:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi-dw-mid.c   |    5 -----
 drivers/spi/spi-dw.c       |    5 -----
 drivers/spi/spi-sh-msiof.c |    3 ---
 3 files changed, 13 deletions(-)

diff -puN drivers/spi/spi-dw-mid.c~linux-next-git-rejects drivers/spi/spi-dw-mid.c
--- a/drivers/spi/spi-dw-mid.c~linux-next-git-rejects
+++ a/drivers/spi/spi-dw-mid.c
@@ -270,11 +270,6 @@ int dw_spi_mid_init(struct dw_spi *dws)
 	dws->max_freq = MRST_SPI_CLK_BASE / (clk_cdiv + 1);
 	iounmap(clk_reg);
 
-<<<<<<< HEAD
-	dws->num_cs = 16;
-
-=======
->>>>>>> linux-next/akpm-base
 #ifdef CONFIG_SPI_DW_MID_DMA
 	dws->dma_priv = kzalloc(sizeof(struct mid_dma), GFP_KERNEL);
 	if (!dws->dma_priv)
diff -puN drivers/spi/spi-dw.c~linux-next-git-rejects drivers/spi/spi-dw.c
--- a/drivers/spi/spi-dw.c~linux-next-git-rejects
+++ a/drivers/spi/spi-dw.c
@@ -626,11 +626,6 @@ static void spi_hw_init(struct device *d
 			if (fifo != dw_readw(dws, DW_SPI_TXFLTR))
 				break;
 		}
-<<<<<<< HEAD
-
-		dws->fifo_len = (fifo == 2) ? 0 : fifo - 1;
-=======
->>>>>>> linux-next/akpm-base
 		dw_writew(dws, DW_SPI_TXFLTR, 0);
 
 		dws->fifo_len = (fifo == 2) ? 0 : fifo - 1;
diff -puN drivers/spi/spi-sh-msiof.c~linux-next-git-rejects drivers/spi/spi-sh-msiof.c
--- a/drivers/spi/spi-sh-msiof.c~linux-next-git-rejects
+++ a/drivers/spi/spi-sh-msiof.c
@@ -82,11 +82,8 @@ struct sh_msiof_spi_priv {
 #define MDR1_SYNCMD_LR	 0x30000000 /*   L/R mode */
 #define MDR1_SYNCAC_SHIFT	 25 /* Sync Polarity (1 = Active-low) */
 #define MDR1_BITLSB_SHIFT	 24 /* MSB/LSB First (1 = LSB first) */
-<<<<<<< HEAD
-=======
 #define MDR1_DTDL_SHIFT		 20 /* Data Pin Bit Delay for MSIOF_SYNC */
 #define MDR1_SYNCDL_SHIFT	 16 /* Frame Sync Signal Timing Delay */
->>>>>>> linux-next/akpm-base
 #define MDR1_FLD_MASK	 0x0000000c /* Frame Sync Signal Interval (0-3) */
 #define MDR1_FLD_SHIFT		  2
 #define MDR1_XXSTP	 0x00000001 /* Transmission/Reception Stop on FIFO */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
mm.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

