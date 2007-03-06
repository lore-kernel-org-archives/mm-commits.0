From: akpm@linux-foundation.org
Subject: - readahead-state-based-method-aging-accounting-vs-zvc-changes.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:46:06 -0800
Message-ID: <200703060146.l261k6YR008265@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45965 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933816AbXCFBqJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:46:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     ZVC writeback: Fix mm and other issues
has been removed from the -mm tree.  Its filename was
     readahead-state-based-method-aging-accounting-vs-zvc-changes.patch

This patch was dropped because it was folded into readahead-state-based-method-aging-accounting.patch

------------------------------------------------------
Subject: ZVC writeback: Fix mm and other issues
From: Christoph Lameter <clameter@sgi.com>

This deals with swap prefetch and various things changed in mm.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~readahead-state-based-method-aging-accounting-vs-zvc-changes mm/page_alloc.c
--- a/mm/page_alloc.c~readahead-state-based-method-aging-accounting-vs-zvc-changes
+++ a/mm/page_alloc.c
@@ -1513,12 +1513,12 @@ unsigned int nr_free_pagecache_pages(voi
 unsigned long nr_free_inactive_pages_node(int nid)
 {
 	enum zone_type i;
-	unsigned long sum = 0;
+	unsigned long sum = node_page_state(nid, NR_FREE_PAGES)
+				+ node_page_state(nid, NR_INACTIVE);
 	struct zone *zones = NODE_DATA(nid)->node_zones;
 
 	for (i = 0; i < MAX_NR_ZONES; i++)
-		sum += zones[i].nr_inactive +
-			zones[i].free_pages - zones[i].pages_low;
+		sum -= zones[i].pages_low;
 
 	return sum;
 }
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
make-try_to_unmap-return-a-special-exit-code.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
