From: akpm@linux-foundation.org
Subject: [merged] include-linux-dma-mappingh-add-dma_zalloc_coherent.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:29:04 -0800
Message-ID: <201111072029.pA7KT4LL024782@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:47736 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1KGU3u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:29:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexandre.bounine@idt.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/dma-mapping.h: add dma_zalloc_coherent()
has been removed from the -mm tree.  Its filename was
     include-linux-dma-mappingh-add-dma_zalloc_coherent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/dma-mapping.h: add dma_zalloc_coherent()

Lots of driver code does a dma_alloc_coherent() and then zeroes out the
memory with a memset.  Make it easy for them.

Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt   |    7 +++++++
 include/linux/dma-mapping.h |   10 ++++++++++
 2 files changed, 17 insertions(+)

diff -puN Documentation/DMA-API.txt~include-linux-dma-mappingh-add-dma_zalloc_coherent Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~include-linux-dma-mappingh-add-dma_zalloc_coherent
+++ a/Documentation/DMA-API.txt
@@ -50,6 +50,13 @@ specify the GFP_ flags (see kmalloc) for
 implementation may choose to ignore flags that affect the location of
 the returned memory, like GFP_DMA).
 
+void *
+dma_zalloc_coherent(struct device *dev, size_t size,
+			     dma_addr_t *dma_handle, gfp_t flag)
+
+Wraps dma_alloc_coherent() and also zeroes the returned memory if the
+allocation attempt succeeded.
+
 void
 dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
 			   dma_addr_t dma_handle)
diff -puN include/linux/dma-mapping.h~include-linux-dma-mappingh-add-dma_zalloc_coherent include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~include-linux-dma-mappingh-add-dma_zalloc_coherent
+++ a/include/linux/dma-mapping.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_DMA_MAPPING_H
 #define _LINUX_DMA_MAPPING_H
 
+#include <linux/string.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/dma-attrs.h>
@@ -117,6 +118,15 @@ static inline int dma_set_seg_boundary(s
 		return -EIO;
 }
 
+static inline void *dma_zalloc_coherent(struct device *dev, size_t size,
+					dma_addr_t *dma_handle, gfp_t flag)
+{
+	void *ret = dma_alloc_coherent(dev, size, dma_handle, flag);
+	if (ret)
+		memset(ret, 0, size);
+	return ret;
+}
+
 #ifdef CONFIG_HAS_DMA
 static inline int dma_get_cache_alignment(void)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes-fix.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix.patch
drivers-net-ethernet-oki-semi-pch_gbe-pch_gbeh-remove-unused-macro-pr_fmt.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
kexec-remove-kmsg_dump_kexec.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

