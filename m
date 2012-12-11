From: akpm@linux-foundation.org
Subject: [folded-merged] mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:53:26 -0800
Message-ID: <20121211235327.6E1F1200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:59550 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab2LKXxa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:53:30 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so2155wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:53:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, b.zolnierkie@samsung.com, dave@linux.vnet.ibm.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mel@csn.ul.ie, mina86@mina86.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix-fix.patch

This patch was dropped because it was folded into mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix-fix

Propagate
mm-fix-incorrect-nr_free_pages-accounting-appears-like-memory-leak.patch
through mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page.patch

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix-fix
+++ a/mm/page_alloc.c
@@ -1401,7 +1401,7 @@ int capture_free_page(struct page *page,
 		if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
 			return 0;
 
-		__mod_zone_freepage_state(zone, -(1UL << order), mt);
+		__mod_zone_freepage_state(zone, -(1UL << alloc_order), mt);
 	}
 
 	/* Remove page from free list */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-introduce-mm_find_pmd.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7.patch
mm-check-rb_subtree_gap-correctness.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch
mm-vm_unmapped_area-lookup-function.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture.patch
mm-use-vm_unmapped_area-on-mips-architecture.patch
mm-use-vm_unmapped_area-on-arm-architecture.patch
mm-use-vm_unmapped_area-on-sh-architecture.patch
mm-use-vm_unmapped_area-on-sparc32-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages.patch
mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch

