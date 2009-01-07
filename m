From: akpm@linux-foundation.org
Subject: - dma_alloc_coherent-clean-it-up.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:21:00 -0800
Message-ID: <200901072221.n07ML0hC020183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761613AbZAGWWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:22:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dbaryshkov@gmail.com, hannes@cmpxchg.org, jbarnes@virtuousgeek.org, lg@denx.de, penberg@cs.helsinki.fi, penguin-kernel@i-love.sakura.ne.jp, mm-commits@vger.


The patch titled
     dma_alloc_coherent: clean it up
has been removed from the -mm tree.  Its filename was
     dma_alloc_coherent-clean-it-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma_alloc_coherent: clean it up
From: Andrew Morton <akpm@linux-foundation.org>

This thing was rather stupidly coded.  Rework it all prior to making
changes.

Also, rename local variable `page': kernel readers expect something called
`page' to have type `struct page *'.

Cc: Guennadi Liakhovetski <lg@denx.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma-coherent.c |   54 +++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 25 deletions(-)

diff -puN kernel/dma-coherent.c~dma_alloc_coherent-clean-it-up kernel/dma-coherent.c
--- a/kernel/dma-coherent.c~dma_alloc_coherent-clean-it-up
+++ a/kernel/dma-coherent.c
@@ -109,34 +109,38 @@ EXPORT_SYMBOL(dma_mark_declared_memory_o
 int dma_alloc_from_coherent(struct device *dev, ssize_t size,
 				       dma_addr_t *dma_handle, void **ret)
 {
-	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
+	struct dma_coherent_mem *mem;
 	int order = get_order(size);
+	int pageno;
+
+	if (!dev)
+		return 0;
+	mem = dev->dma_mem;
+	if (!mem)
+		return 0;
 
-	if (mem) {
-		int page = bitmap_find_free_region(mem->bitmap, mem->size,
-						     order);
-		if (page >= 0) {
-			/*
-			 * Memory was found in the per-device arena.
-			 */
-			*dma_handle = mem->device_base + (page << PAGE_SHIFT);
-			*ret = mem->virt_base + (page << PAGE_SHIFT);
-			memset(*ret, 0, size);
-		} else if (mem->flags & DMA_MEMORY_EXCLUSIVE) {
-			/*
-			 * The per-device arena is exhausted and we are not
-			 * permitted to fall back to generic memory.
-			 */
-			*ret = NULL;
-		} else {
-			/*
-			 * The per-device arena is exhausted and we are
-			 * permitted to fall back to generic memory.
-			 */
-			 return 0;
-		}
+	pageno = bitmap_find_free_region(mem->bitmap, mem->size, order);
+	if (pageno >= 0) {
+		/*
+		 * Memory was found in the per-device arena.
+		 */
+		*dma_handle = mem->device_base + (pageno << PAGE_SHIFT);
+		*ret = mem->virt_base + (pageno << PAGE_SHIFT);
+		memset(*ret, 0, size);
+	} else if (mem->flags & DMA_MEMORY_EXCLUSIVE) {
+		/*
+		 * The per-device arena is exhausted and we are not
+		 * permitted to fall back to generic memory.
+		 */
+		*ret = NULL;
+	} else {
+		/*
+		 * The per-device arena is exhausted and we are
+		 * permitted to fall back to generic memory.
+		 */
+		 return 0;
 	}
-	return (mem != NULL);
+	return 1;
 }
 EXPORT_SYMBOL(dma_alloc_from_coherent);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
smp_call_function_single-be-slightly-less-stupid.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
w1-allow-master-io-commands-fix.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
kmemleak-add-the-base-support-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

