From: akpm@linux-foundation.org
Subject: - eink_apollofb-new-driver-for-apollo-eink-controller-cleanup.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:31:51 -0700
Message-ID: <200807252331.m6PNVpHs005218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752183AbYGYXcC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:32:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adaplas@pol.net, jekhor@gmail.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     eink_apollofb-new-driver-for-apollo-eink-controller-cleanup
has been removed from the -mm tree.  Its filename was
     eink_apollofb-new-driver-for-apollo-eink-controller-cleanup.patch

This patch was dropped because it was folded into eink_apollofb-new-driver-for-apollo-eink-controller.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eink_apollofb-new-driver-for-apollo-eink-controller-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Yauhen Kharuzhy <jekhor@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig         |    2 +-
 drivers/video/eink_apollofb.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/Kconfig~eink_apollofb-new-driver-for-apollo-eink-controller-cleanup drivers/video/Kconfig
--- a/drivers/video/Kconfig~eink_apollofb-new-driver-for-apollo-eink-controller-cleanup
+++ a/drivers/video/Kconfig
@@ -727,7 +727,7 @@ config FB_EINK_APOLLO
        select FB_SYS_FOPS
        select FB_DEFERRED_IO
        help
-         This enables support for Apollo eInk display controller.
+	 This enables support for Apollo eInk display controller.
 	 Includes support of deferred IO and 2-bit grayscale mode.
 
 	 Hardware-specific functions have been moved to platform data.
diff -puN drivers/video/eink_apollofb.c~eink_apollofb-new-driver-for-apollo-eink-controller-cleanup drivers/video/eink_apollofb.c
--- a/drivers/video/eink_apollofb.c~eink_apollofb-new-driver-for-apollo-eink-controller-cleanup
+++ a/drivers/video/eink_apollofb.c
@@ -82,8 +82,8 @@ static struct fb_var_screeninfo apollofb
 	.nonstd		= 1,
 };
 
-static inline int apollo_wait_for_ack_value(struct apollofb_par *par,
-		unsigned int value)
+static int apollo_wait_for_ack_value(struct apollofb_par *par,
+					unsigned int value)
 {
 	unsigned long timeout = jiffies + 2 * HZ;
 
@@ -324,7 +324,7 @@ static void apollofb_imageblit(struct fb
 	schedule_delayed_work(&par->deferred_work, info->fbdefio->delay);
 }
 
-int apollofb_cursor(struct fb_info *info, struct fb_cursor *cursor)
+static int apollofb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
uninline-arch_pick_mmap_layout.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
eink_apollofb-new-driver-for-apollo-eink-controller-cleanup.patch
eink_apollofb-new-driver-for-apollo-eink-controller-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller-fix-fix-2.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
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

