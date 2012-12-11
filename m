From: akpm@linux-foundation.org
Subject: [folded-merged] mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:50:45 -0800
Message-ID: <20121211235046.9EBAB20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:49942 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2LKXuv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:50:51 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so2034bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:50:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, aquini@redhat.com, konrad.wilk@oracle.com, levinsasha928@gmail.com, mel@csn.ul.ie, minchan@kernel.org, mst@redhat.com, riel@redhat.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check-fix
has been removed from the -mm tree.  Its filename was
     mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check-fix.patch

This patch was dropped because it was folded into mm-introduce-a-common-interface-for-balloon-pages-mobility.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check-fix

use PAGE_FLAGS_CHECK_AT_PREP, s/__balloon_page_flags/page_flags_cleared/, small cleanups

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/balloon_compaction.h |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN include/linux/balloon_compaction.h~mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check-fix include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check-fix
+++ a/include/linux/balloon_compaction.h
@@ -41,6 +41,7 @@
 #ifndef _LINUX_BALLOON_COMPACTION_H
 #define _LINUX_BALLOON_COMPACTION_H
 #include <linux/pagemap.h>
+#include <linux/page-flags.h>
 #include <linux/migrate.h>
 #include <linux/gfp.h>
 #include <linux/err.h>
@@ -107,20 +108,18 @@ static inline void balloon_mapping_free(
 }
 
 /*
- * __balloon_page_flags - helper to perform balloon @page ->flags tests.
+ * page_flags_cleared - helper to perform balloon @page ->flags tests.
  *
- * As balloon pages are got from Buddy, and we do not play with page->flags
+ * As balloon pages are obtained from buddy and we do not play with page->flags
  * at driver level (exception made when we get the page lock for compaction),
- * therefore we can safely identify a ballooned page by checking if the
- * NR_PAGEFLAGS rightmost bits from the page->flags are all cleared.
- * This approach also helps on skipping ballooned pages that are locked for
- * compaction or release, thus mitigating their racy check at
- * balloon_page_movable()
+ * we can safely identify a ballooned page by checking if the
+ * PAGE_FLAGS_CHECK_AT_PREP page->flags are all cleared.  This approach also
+ * helps us skip ballooned pages that are locked for compaction or release, thus
+ * mitigating their racy check at balloon_page_movable()
  */
-#define BALLOON_PAGE_FLAGS_MASK       ((1UL << NR_PAGEFLAGS) - 1)
-static inline bool __balloon_page_flags(struct page *page)
+static inline bool page_flags_cleared(struct page *page)
 {
-	return page->flags & BALLOON_PAGE_FLAGS_MASK ? false : true;
+	return !(page->flags & PAGE_FLAGS_CHECK_AT_PREP);
 }
 
 /*
@@ -149,10 +148,10 @@ static inline bool __is_movable_balloon_
 static inline bool balloon_page_movable(struct page *page)
 {
 	/*
-	 * Before dereferencing and testing mapping->flags, lets make sure
+	 * Before dereferencing and testing mapping->flags, let's make sure
 	 * this is not a page that uses ->mapping in a different way
 	 */
-	if (__balloon_page_flags(page) && !page_mapped(page) &&
+	if (page_flags_cleared(page) && !page_mapped(page) &&
 	    page_count(page) == 1)
 		return __is_movable_balloon_page(page);
 
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
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix-fix.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch

