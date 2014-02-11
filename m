From: akpm@linux-foundation.org
Subject: + mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix.patch
 added to -mm tree
Date: Tue, 11 Feb 2014 14:26:55 -0800
Message-ID: <52faa3af.pCYRL87SaPpuiIn/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbaBKW04 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 17:26:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org

Subject: + mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix.patch added to -mm tree
To: hannes@cmpxchg.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 14:26:55 -0800


The patch titled
     Subject: mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix
has been added to the -mm tree.  Its filename is
     mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-thp-fix-infinite-loop-on-memcg-oom.patch
memcg-change-oom_info_lock-to-mutex.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-vmstat-fix-up-zone-state-accounting.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
drop_caches-add-some-documentation-and-info-message.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

