From: akpm@linux-foundation.org
Subject: - dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:39:33 -0700
Message-ID: <200807252339.m6PNdXAW005461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753547AbYGYXkI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:40:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, avi@qumranet.com, fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, muli@il.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x
has been removed from the -mm tree.  Its filename was
     dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch

This patch was dropped because it was folded into dma-mapping-add-the-device-argument-to-dma_mapping_error.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x
From: Andrew Morton <akpm@linux-foundation.org>

this is getting a bit boring.

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Avi Kivity <avi@qumranet.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/bnx2x_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN /dev/null /dev/null
diff -puN drivers/net/bnx2.c~dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x drivers/net/bnx2.c
diff -puN drivers/net/bnx2x_main.c~dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x drivers/net/bnx2x_main.c
--- a/drivers/net/bnx2x_main.c~dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x
+++ a/drivers/net/bnx2x_main.c
@@ -1020,7 +1020,7 @@ static inline int bnx2x_alloc_rx_sge(str
 
 	mapping = pci_map_page(bp->pdev, page, 0, BCM_PAGE_SIZE*PAGES_PER_SGE,
 			       PCI_DMA_FROMDEVICE);
-	if (unlikely(dma_mapping_error(mapping))) {
+	if (unlikely(dma_mapping_error(&bp->pdev->dev, mapping))) {
 		__free_pages(page, PAGES_PER_SGE_SHIFT);
 		return -ENOMEM;
 	}
@@ -1048,7 +1048,7 @@ static inline int bnx2x_alloc_rx_skb(str
 
 	mapping = pci_map_single(bp->pdev, skb->data, bp->rx_buf_use_size,
 				 PCI_DMA_FROMDEVICE);
-	if (unlikely(dma_mapping_error(mapping))) {
+	if (unlikely(dma_mapping_error(&bp->pdev->dev, mapping))) {
 		dev_kfree_skb(skb);
 		return -ENOMEM;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
uninline-arch_pick_mmap_layout.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-pasemi_mac.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sdhci-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-infiniband.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-more-sparc.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-ibmvscsi.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary-checkpatch-fixes.patch
tpm-increase-size-of-internal-tpm-response-buffers-checkpatch-fixes.patch
memstick-allow-set_param-method-to-return-an-error-code-checkpatch-fixes.patch
memstick-use-fully-asynchronous-request-processing-fix.patch
full-conversion-to-early_initcall-interface-remove-old-interface-cleanup.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
gru-driver-v3-hardware-data-structures-fix.patch
gru-driver-v3-hardware-data-structures-fix-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
define-page_file_cache-function-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-units-fix.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-page-statistics-units-fix.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
introduce-__get_user_pages-fix.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
slb-drop-kmem-cache-argument-from-constructor-ubifs.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

