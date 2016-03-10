From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 10 Mar 2016 10:57:10 -0800
Message-ID: <56e1c386.95TbFmaV0tg/V1QO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbcCJS5M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2016 13:57:12 -0500
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

 drivers/spi/spi-imx.c |   36 ------------------------------------
 kernel/memremap.c     |    3 ---
 2 files changed, 39 deletions(-)

diff -puN drivers/spi/spi-imx.c~linux-next-git-rejects drivers/spi/spi-imx.c
--- a/drivers/spi/spi-imx.c~linux-next-git-rejects
+++ a/drivers/spi/spi-imx.c
@@ -216,12 +216,6 @@ static bool spi_imx_can_dma(struct spi_m
 	if (!master->dma_rx)
 		return false;
 
-<<<<<<< HEAD
-	if (spi_imx->dma_is_inited && transfer->len >= spi_imx->wml &&
-	    (transfer->len % spi_imx->wml) == 0)
-		return true;
-	return false;
-=======
 	if (!bpw)
 		bpw = spi->bits_per_word;
 
@@ -237,7 +231,6 @@ static bool spi_imx_can_dma(struct spi_m
 		return false;
 
 	return true;
->>>>>>> linux-next/akpm-base
 }
 
 #define MX51_ECSPI_CTRL		0x08
@@ -1015,22 +1008,6 @@ static int spi_imx_dma_transfer(struct s
 	desc_tx->callback_param = (void *)spi_imx;
 	dmaengine_submit(desc_tx);
 	reinit_completion(&spi_imx->dma_tx_completion);
-<<<<<<< HEAD
-
-	/* Trigger the cspi module. */
-	spi_imx->dma_finished = 0;
-
-	/*
-	 * Set these order to avoid potential RX overflow. The overflow may
-	 * happen if we enable SPI HW before starting RX DMA due to rescheduling
-	 * for another task and/or interrupt.
-	 * So RX DMA enabled first to make sure data would be read out from FIFO
-	 * ASAP. TX DMA enabled next to start filling TX FIFO with new data.
-	 * And finaly SPI HW enabled to start actual data transfer.
-	 */
-	dma_async_issue_pending(master->dma_rx);
-=======
->>>>>>> linux-next/akpm-base
 	dma_async_issue_pending(master->dma_tx);
 
 	transfer_timeout = spi_imx_calculate_timeout(spi_imx, transfer->len);
@@ -1042,20 +1019,7 @@ static int spi_imx_dma_transfer(struct s
 		dev_err(spi_imx->dev, "I/O Error in DMA TX\n");
 		dmaengine_terminate_all(master->dma_tx);
 		dmaengine_terminate_all(master->dma_rx);
-<<<<<<< HEAD
-	} else {
-		timeout = wait_for_completion_timeout(
-				&spi_imx->dma_rx_completion, IMX_DMA_TIMEOUT);
-		if (!timeout) {
-			pr_warn("%s %s: I/O Error in DMA RX\n",
-				dev_driver_string(&master->dev),
-				dev_name(&master->dev));
-			spi_imx->devtype_data->reset(spi_imx);
-			dmaengine_terminate_all(master->dma_rx);
-		}
-=======
 		return -ETIMEDOUT;
->>>>>>> linux-next/akpm-base
 	}
 
 	timeout = wait_for_completion_timeout(&spi_imx->dma_rx_completion,
diff -puN kernel/memremap.c~linux-next-git-rejects kernel/memremap.c
--- a/kernel/memremap.c~linux-next-git-rejects
+++ a/kernel/memremap.c
@@ -271,11 +271,8 @@ struct dev_pagemap *find_dev_pagemap(res
 void *devm_memremap_pages(struct device *dev, struct resource *res,
 		struct percpu_ref *ref, struct vmem_altmap *altmap)
 {
-<<<<<<< HEAD
-=======
 	int is_ram = region_intersects(res->start, resource_size(res),
 				       IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE);
->>>>>>> linux-next/akpm-base
 	resource_size_t key, align_start, align_size, align_end;
 	struct dev_pagemap *pgmap;
 	struct page_map *page_map;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
mm-slab-clean-up-debug_pagealloc-processing-code-fix.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
slub-drop-lock-at-the-end-of-free_debug_processing-fix.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch
mm-simplify-lock_page_memcg-fix.patch
sched-add-schedule_timeout_idle.patch
mm-oom_reaper-report-success-failure-fix.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix-fix.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix.patch
mm-slub-query-dynamic-debug_pagealloc-setting-fix.patch
sound-query-dynamic-debug_pagealloc-setting-fix.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch
arch-mn10300-kernel-fpu-nofpuc-needs-asm-elfh.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sscanf-implement-basic-character-sets-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
rapidio-add-mport-char-device-driver-fix.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
kernel-add-kcov-code-coverage-makefile-tweaks.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

