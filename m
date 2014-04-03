From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix.patch removed from -mm tree
Date: Thu, 03 Apr 2014 14:06:21 -0700
Message-ID: <533dcd4d.hofrJhRDZfXwO5BG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbaDCVGW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:06:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org

Subject: [folded-merged] mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix.patch removed from -mm tree
To: hannes@cmpxchg.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:06:21 -0700


The patch titled
     Subject: mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix.patch

This patch was dropped because it was folded into mm-keep-page-cache-radix-tree-nodes-in-check.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix

document IRQ-disabling around list_lru API calls

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/workingset.c~mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix mm/workingset.c
--- a/mm/workingset.c~mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix
+++ a/mm/workingset.c
@@ -273,6 +273,7 @@ static unsigned long count_shadow_nodes(
 	unsigned long max_nodes;
 	unsigned long pages;
 
+	/* list_lru lock nests inside IRQ-safe mapping->tree_lock */
 	local_irq_disable();
 	shadow_nodes = list_lru_count_node(&workingset_shadow_nodes, sc->nid);
 	local_irq_enable();
@@ -373,6 +374,7 @@ static unsigned long scan_shadow_nodes(s
 {
 	unsigned long ret;
 
+	/* list_lru lock nests inside IRQ-safe mapping->tree_lock */
 	local_irq_disable();
 	ret =  list_lru_walk_node(&workingset_shadow_nodes, sc->nid,
 				  shadow_lru_isolate, NULL, &sc->nr_to_scan);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
drop_caches-add-some-documentation-and-info-message.patch

