From: akpm@linux-foundation.org
Subject: [merged] vmscan-drop-page_mapping_inuse.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:04:41 -0800
Message-ID: <201003091904.o29J4f4V031058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552Ab0CITFX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:05:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: drop page_mapping_inuse()
has been removed from the -mm tree.  Its filename was
     vmscan-drop-page_mapping_inuse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: drop page_mapping_inuse()
From: Johannes Weiner <hannes@cmpxchg.org>

page_mapping_inuse() is a historic predicate function for pages that are
about to be reclaimed or deactivated.

According to it, a page is in use when it is mapped into page tables OR
part of swap cache OR backing an mmapped file.

This function is used in combination with page_referenced(), which checks
for young bits in ptes and the page descriptor itself for the
PG_referenced bit.  Thus, checking for unmapped swap cache pages is
meaningless as PG_referenced is not set for anonymous pages and unmapped
pages do not have young ptes.  The test makes no difference.

Protecting file pages that are not by themselves mapped but are part of a
mapped file is also a historic leftover for short-lived things like the
exec() code in libc.  However, the VM now does reference accounting and
activation of pages at unmap time and thus the special treatment on
reclaim is obsolete.

This patch drops page_mapping_inuse() and switches the two callsites to
use page_mapped() directly.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: OSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff -puN mm/vmscan.c~vmscan-drop-page_mapping_inuse mm/vmscan.c
--- a/mm/vmscan.c~vmscan-drop-page_mapping_inuse
+++ a/mm/vmscan.c
@@ -262,27 +262,6 @@ unsigned long shrink_slab(unsigned long 
 	return ret;
 }
 
-/* Called without lock on whether page is mapped, so answer is unstable */
-static inline int page_mapping_inuse(struct page *page)
-{
-	struct address_space *mapping;
-
-	/* Page is in somebody's page tables. */
-	if (page_mapped(page))
-		return 1;
-
-	/* Be more reluctant to reclaim swapcache than pagecache */
-	if (PageSwapCache(page))
-		return 1;
-
-	mapping = page_mapping(page);
-	if (!mapping)
-		return 0;
-
-	/* File is mmap'd by somebody? */
-	return mapping_mapped(mapping);
-}
-
 static inline int is_page_cache_freeable(struct page *page)
 {
 	/*
@@ -606,7 +585,7 @@ static enum page_references page_check_r
 	if (vm_flags & VM_LOCKED)
 		return PAGEREF_RECLAIM;
 
-	if (page_mapping_inuse(page))
+	if (page_mapped(page))
 		return PAGEREF_ACTIVATE;
 
 	/* Reclaim if clean, defer dirty pages to writeback */
@@ -1381,7 +1360,7 @@ static void shrink_active_list(unsigned 
 		}
 
 		/* page_referenced clears PageReferenced */
-		if (page_mapping_inuse(page) &&
+		if (page_mapped(page) &&
 		    page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
 			nr_rotated++;
 			/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

bootmem-avoid-dma32-zone-by-default.patch

