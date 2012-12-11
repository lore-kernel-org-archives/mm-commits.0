From: akpm@linux-foundation.org
Subject: [folded-merged] dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:42:27 -0800
Message-ID: <20121211234228.496F382004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:32883 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2LKXm3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:42:29 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so10149qaq.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:42:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, matthieu.castet@parrot.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix
has been removed from the -mm tree.  Its filename was
     dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch

This patch was dropped because it was folded into dmapool-make-dmapool_debug-detect-corruption-of-free-marker.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix

tidy code, fix comment, use sizeof(page->offset), use pr_err()

Cc: Matthieu Castet <matthieu.castet@parrot.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff -puN mm/dmapool.c~dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix mm/dmapool.c
--- a/mm/dmapool.c~dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix
+++ a/mm/dmapool.c
@@ -336,23 +336,24 @@ void *dma_pool_alloc(struct dma_pool *po
 		int i;
 		u8 *data = retval;
 		/* page->offset is stored in first 4 bytes */
-		for (i = sizeof(int); i < pool->size; i++) {
-			if (data[i] != POOL_POISON_FREED) {
-				if (pool->dev)
-					dev_err(pool->dev,
-							"dma_pool_alloc %s, %p (corruped)\n",
-							pool->name, retval);
-				else
-					printk(KERN_ERR
-							"dma_pool_alloc %s, %p (corruped)\n",
-							pool->name, retval);
-
-				/* we dump the first 4 bytes even if there are not
-				   POOL_POISON_FREED */
-				print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET, 16, 1,
-						data, pool->size, 1);
-				break;
-			}
+		for (i = sizeof(page->offset); i < pool->size; i++) {
+			if (data[i] == POOL_POISON_FREED)
+				continue;
+			if (pool->dev)
+				dev_err(pool->dev,
+					"dma_pool_alloc %s, %p (corruped)\n",
+					pool->name, retval);
+			else
+				pr_err("dma_pool_alloc %s, %p (corruped)\n",
+					pool->name, retval);
+
+			/*
+			 * Dump the first 4 bytes even if they are not
+			 * POOL_POISON_FREED
+			 */
+			print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET, 16, 1,
+					data, pool->size, 1);
+			break;
 		}
 	}
 	memset(retval, POOL_POISON_ALLOCATED, pool->size);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-introduce-mm_find_pmd.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix-fix.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch

