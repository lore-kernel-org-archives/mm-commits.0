From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-check-for-page-allocation-failure-before-vmlist-insertion.patch removed from -mm tree
Date: Fri, 09 Dec 2011 12:08:37 -0800
Message-ID: <201112092008.pB9K8b8j014780@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:38322 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab1LIUIl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 15:08:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, lnx1138@linux.vnet.ibm.com, riel@redhat.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: check for page allocation failure before vmlist insertion
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-check-for-page-allocation-failure-before-vmlist-insertion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmalloc: check for page allocation failure before vmlist insertion

Commit f5252e00 ("mm: avoid null pointer access in vm_struct via
/proc/vmallocinfo") adds newly allocated vm_structs to the vmlist after it
is fully initialised.  Unfortunately, it did not check that
__vmalloc_area_node() successfully populated the area.  In the event of
allocation failure, the vmalloc area is freed but the pointer to freed
memory is inserted into the vmlist leading to a a crash later in
get_vmalloc_info().

This patch adds a check for ____vmalloc_area_node() failure within
__vmalloc_node_range.  It does not use "goto fail" as in the previous
error path as a warning was already displayed by __vmalloc_area_node()
before it called vfree in its failure path.

Credit goes to Luciano Chavez for doing all the real work of identifying
exactly where the problem was.

If accepted, this should be considered a -stable candidate.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Luciano Chavez <lnx1138@linux.vnet.ibm.com>
Tested-by: Luciano Chavez <lnx1138@linux.vnet.ibm.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>		[3.1.x+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmalloc.c~mm-vmalloc-check-for-page-allocation-failure-before-vmlist-insertion mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-check-for-page-allocation-failure-before-vmlist-insertion
+++ a/mm/vmalloc.c
@@ -1633,6 +1633,8 @@ void *__vmalloc_node_range(unsigned long
 		goto fail;
 
 	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
+	if (!addr)
+		return NULL;
 
 	/*
 	 * In this function, newly allocated vm_struct is not added
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-avoid-livelock-on-__gfp_fs-allocations-v2.patch
mm-more-intensive-memory-corruption-debug.patch
mm-more-intensive-memory-corruption-debug-fix.patch
pm-hibernate-do-not-count-debug-pages-as-savable.patch
slub-min-order-when-debug_guardpage_minorder-0.patch
mm-debug-test-for-online-nid-when-allocating-on-single-node.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-try-to-distribute-dirty-pages-fairly-across-zones.patch
mm-filemap-pass-__gfp_write-from-grab_cache_page_write_begin.patch
btrfs-pass-__gfp_write-for-buffered-write-page-allocations.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch
mm-fix-off-by-two-in-__zone_watermark_ok.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma.patch

