From: akpm@linux-foundation.org
Subject: + mm-fix-gfp_thisnode-callers-and-clarify.patch added to -mm tree
Date: Tue, 25 Feb 2014 12:58:23 -0800
Message-ID: <530d03ef.iL4hX8elHpBVXuIf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbaBYU6Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Feb 2014 15:58:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, jstancek@redhat.com, hannes@cmpxchg.org

Subject: + mm-fix-gfp_thisnode-callers-and-clarify.patch added to -mm tree
To: hannes@cmpxchg.org,jstancek@redhat.com,mgorman@suse.de,riel@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 25 Feb 2014 12:58:23 -0800


The patch titled
     Subject: mm: fix GFP_THISNODE callers and clarify
has been added to the -mm tree.  Its filename is
     mm-fix-gfp_thisnode-callers-and-clarify.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-gfp_thisnode-callers-and-clarify.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-gfp_thisnode-callers-and-clarify.patch

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
Subject: mm: fix GFP_THISNODE callers and clarify

GFP_THISNODE is for callers that implement their own clever fallback to
remote nodes, and so no direct reclaim is invoked.  There are many current
users that only want node exclusiveness but still want reclaim to make the
allocation happen.  Convert them over to __GFP_THISNODE and update the
documentation to clarify GFP_THISNODE semantics.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Jan Stancek <jstancek@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/uncached.c       |    2 +-
 arch/powerpc/platforms/cell/ras.c |    3 ++-
 drivers/misc/sgi-xp/xpc_uv.c      |    2 +-
 include/linux/gfp.h               |    4 ++++
 include/linux/mmzone.h            |    4 ++--
 include/linux/slab.h              |    2 +-
 kernel/profile.c                  |    4 ++--
 mm/migrate.c                      |   11 ++++++-----
 8 files changed, 19 insertions(+), 13 deletions(-)

diff -puN arch/ia64/kernel/uncached.c~mm-fix-gfp_thisnode-callers-and-clarify arch/ia64/kernel/uncached.c
--- a/arch/ia64/kernel/uncached.c~mm-fix-gfp_thisnode-callers-and-clarify
+++ a/arch/ia64/kernel/uncached.c
@@ -98,7 +98,7 @@ static int uncached_add_chunk(struct unc
 	/* attempt to allocate a granule's worth of cached memory pages */
 
 	page = alloc_pages_exact_node(nid,
-				GFP_KERNEL | __GFP_ZERO | GFP_THISNODE,
+				GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
 				IA64_GRANULE_SHIFT-PAGE_SHIFT);
 	if (!page) {
 		mutex_unlock(&uc_pool->add_chunk_mutex);
diff -puN arch/powerpc/platforms/cell/ras.c~mm-fix-gfp_thisnode-callers-and-clarify arch/powerpc/platforms/cell/ras.c
--- a/arch/powerpc/platforms/cell/ras.c~mm-fix-gfp_thisnode-callers-and-clarify
+++ a/arch/powerpc/platforms/cell/ras.c
@@ -123,7 +123,8 @@ static int __init cbe_ptcal_enable_on_no
 
 	area->nid = nid;
 	area->order = order;
-	area->pages = alloc_pages_exact_node(area->nid, GFP_KERNEL|GFP_THISNODE,
+	area->pages = alloc_pages_exact_node(area->nid,
+						GFP_KERNEL|__GFP_THISNODE,
 						area->order);
 
 	if (!area->pages) {
diff -puN drivers/misc/sgi-xp/xpc_uv.c~mm-fix-gfp_thisnode-callers-and-clarify drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~mm-fix-gfp_thisnode-callers-and-clarify
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -240,7 +240,7 @@ xpc_create_gru_mq_uv(unsigned int mq_siz
 
 	nid = cpu_to_node(cpu);
 	page = alloc_pages_exact_node(nid,
-				      GFP_KERNEL | __GFP_ZERO | GFP_THISNODE,
+				      GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
 				      pg_order);
 	if (page == NULL) {
 		dev_err(xpc_part, "xpc_create_gru_mq_uv() failed to alloc %d "
diff -puN include/linux/gfp.h~mm-fix-gfp_thisnode-callers-and-clarify include/linux/gfp.h
--- a/include/linux/gfp.h~mm-fix-gfp_thisnode-callers-and-clarify
+++ a/include/linux/gfp.h
@@ -123,6 +123,10 @@ struct vm_area_struct;
 			 __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN | \
 			 __GFP_NO_KSWAPD)
 
+/*
+ * GFP_THISNODE does not perform any reclaim, you most likely want to
+ * use __GFP_THISNODE to allocate from a given node without fallback!
+ */
 #ifdef CONFIG_NUMA
 #define GFP_THISNODE	(__GFP_THISNODE | __GFP_NOWARN | __GFP_NORETRY)
 #else
diff -puN include/linux/mmzone.h~mm-fix-gfp_thisnode-callers-and-clarify include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-fix-gfp_thisnode-callers-and-clarify
+++ a/include/linux/mmzone.h
@@ -596,10 +596,10 @@ static inline bool zone_is_empty(struct
 
 /*
  * The NUMA zonelists are doubled because we need zonelists that restrict the
- * allocations to a single node for GFP_THISNODE.
+ * allocations to a single node for __GFP_THISNODE.
  *
  * [0]	: Zonelist with fallback
- * [1]	: No fallback (GFP_THISNODE)
+ * [1]	: No fallback (__GFP_THISNODE)
  */
 #define MAX_ZONELISTS 2
 
diff -puN include/linux/slab.h~mm-fix-gfp_thisnode-callers-and-clarify include/linux/slab.h
--- a/include/linux/slab.h~mm-fix-gfp_thisnode-callers-and-clarify
+++ a/include/linux/slab.h
@@ -410,7 +410,7 @@ static __always_inline void *kmalloc_lar
  *
  * %GFP_NOWAIT - Allocation will not sleep.
  *
- * %GFP_THISNODE - Allocate node-local memory only.
+ * %__GFP_THISNODE - Allocate node-local memory only.
  *
  * %GFP_DMA - Allocation suitable for DMA.
  *   Should only be used for kmalloc() caches. Otherwise, use a
diff -puN kernel/profile.c~mm-fix-gfp_thisnode-callers-and-clarify kernel/profile.c
--- a/kernel/profile.c~mm-fix-gfp_thisnode-callers-and-clarify
+++ a/kernel/profile.c
@@ -549,14 +549,14 @@ static int create_hash_tables(void)
 		struct page *page;
 
 		page = alloc_pages_exact_node(node,
-				GFP_KERNEL | __GFP_ZERO | GFP_THISNODE,
+				GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
 				0);
 		if (!page)
 			goto out_cleanup;
 		per_cpu(cpu_profile_hits, cpu)[1]
 				= (struct profile_hit *)page_address(page);
 		page = alloc_pages_exact_node(node,
-				GFP_KERNEL | __GFP_ZERO | GFP_THISNODE,
+				GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
 				0);
 		if (!page)
 			goto out_cleanup;
diff -puN mm/migrate.c~mm-fix-gfp_thisnode-callers-and-clarify mm/migrate.c
--- a/mm/migrate.c~mm-fix-gfp_thisnode-callers-and-clarify
+++ a/mm/migrate.c
@@ -1158,7 +1158,7 @@ static struct page *new_page_node(struct
 					pm->node);
 	else
 		return alloc_pages_exact_node(pm->node,
-				GFP_HIGHUSER_MOVABLE | GFP_THISNODE, 0);
+				GFP_HIGHUSER_MOVABLE | __GFP_THISNODE, 0);
 }
 
 /*
@@ -1544,9 +1544,9 @@ static struct page *alloc_misplaced_dst_
 	struct page *newpage;
 
 	newpage = alloc_pages_exact_node(nid,
-					 (GFP_HIGHUSER_MOVABLE | GFP_THISNODE |
-					  __GFP_NOMEMALLOC | __GFP_NORETRY |
-					  __GFP_NOWARN) &
+					 (GFP_HIGHUSER_MOVABLE |
+					  __GFP_THISNODE | __GFP_NOMEMALLOC |
+					  __GFP_NORETRY | __GFP_NOWARN) &
 					 ~GFP_IOFS, 0);
 
 	return newpage;
@@ -1747,7 +1747,8 @@ int migrate_misplaced_transhuge_page(str
 		goto out_dropref;
 
 	new_page = alloc_pages_node(node,
-		(GFP_TRANSHUGE | GFP_THISNODE) & ~__GFP_WAIT, HPAGE_PMD_ORDER);
+		(GFP_TRANSHUGE | __GFP_THISNODE) & ~__GFP_WAIT,
+		HPAGE_PMD_ORDER);
 	if (!new_page)
 		goto out_fail;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-thp-fix-infinite-loop-on-memcg-oom.patch
memcg-change-oom_info_lock-to-mutex.patch
swapoff-tmpfs-radix_tree-remember-to-rcu_read_unlock.patch
memcg-fix-endless-loop-in-__mem_cgroup_iter_next.patch
memcg-reparent-charges-of-children-before-processing-parent.patch
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
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
mm-page_alloc-reset-aging-cycle-with-gfp_thisnode.patch
mm-fix-gfp_thisnode-callers-and-clarify.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

