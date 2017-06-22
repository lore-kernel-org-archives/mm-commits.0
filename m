From: akpm@linux-foundation.org
Subject: +
 hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask.patch
 added to -mm tree
Date: Thu, 22 Jun 2017 12:41:50 -0700
Message-ID: <594c1d7e.EeUho0GzJZGDU+Cz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39584 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752392AbdFVTlv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jun 2017 15:41:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mgorman@suse.de, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: add support for preferred node to alloc_huge_page_nodemask
has been added to the -mm tree.  Its filename is
     hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: hugetlb: add support for preferred node to alloc_huge_page_nodemask

alloc_huge_page_nodemask tries to allocate from any numa node in the
allowed node mask starting from lower numa nodes.  This might lead to
filling up those low NUMA nodes while others are not used.  We can reduce
this risk by introducing a concept of the preferred node similar to what
we have in the regular page allocator.  We will start allocating from the
preferred nid and then iterate over all allowed nodes in the zonelist
order until we try them all.

This is mimicing the page allocator logic except it operates on per-node
mempools.  dequeue_huge_page_vma already does this so distill the zonelist
logic into a more generic dequeue_huge_page_nodemask and use it in
alloc_huge_page_nodemask.

This will allow us to use proper per numa distance fallback also for
alloc_huge_page_node which can use alloc_huge_page_nodemask now and we can
get rid of alloc_huge_page_node helper which doesn't have any user
anymore.

Link: http://lkml.kernel.org/r/20170622193034.28972-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 +-
 include/linux/migrate.h |    2 
 mm/hugetlb.c            |   88 +++++++++++++++++++-------------------
 3 files changed, 48 insertions(+), 47 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask
+++ a/include/linux/hugetlb.h
@@ -349,7 +349,8 @@ struct page *alloc_huge_page(struct vm_a
 struct page *alloc_huge_page_node(struct hstate *h, int nid);
 struct page *alloc_huge_page_noerr(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
-struct page *alloc_huge_page_nodemask(struct hstate *h, nodemask_t *nmask);
+struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
+				nodemask_t *nmask);
 int huge_add_to_page_cache(struct page *page, struct address_space *mapping,
 			pgoff_t idx);
 
@@ -525,7 +526,7 @@ static inline void set_huge_swap_pte_at(
 struct hstate {};
 #define alloc_huge_page(v, a, r) NULL
 #define alloc_huge_page_node(h, nid) NULL
-#define alloc_huge_page_nodemask(h, nmask) NULL
+#define alloc_huge_page_nodemask(h, preferred_nid, nmask) NULL
 #define alloc_huge_page_noerr(v, a, r) NULL
 #define alloc_bootmem_huge_page(h) NULL
 #define hstate_file(f) NULL
diff -puN include/linux/migrate.h~hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask include/linux/migrate.h
--- a/include/linux/migrate.h~hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask
+++ a/include/linux/migrate.h
@@ -38,7 +38,7 @@ static inline struct page *new_page_node
 
 	if (PageHuge(page))
 		return alloc_huge_page_nodemask(page_hstate(compound_head(page)),
-				nodemask);
+				preferred_nid, nodemask);
 
 	if (PageHighMem(page)
 	    || (zone_idx(page_zone(page)) == ZONE_MOVABLE))
diff -puN mm/hugetlb.c~hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask
+++ a/mm/hugetlb.c
@@ -887,19 +887,39 @@ static struct page *dequeue_huge_page_no
 	return page;
 }
 
-static struct page *dequeue_huge_page_node(struct hstate *h, int nid)
+static struct page *dequeue_huge_page_nodemask(struct hstate *h, gfp_t gfp_mask, int nid,
+		nodemask_t *nmask)
 {
-	struct page *page;
-	int node;
+	unsigned int cpuset_mems_cookie;
+	struct zonelist *zonelist;
+	struct zone *zone;
+	struct zoneref *z;
+	int node = -1;
 
-	if (nid != NUMA_NO_NODE)
-		return dequeue_huge_page_node_exact(h, nid);
+	zonelist = node_zonelist(nid, gfp_mask);
+
+retry_cpuset:
+	cpuset_mems_cookie = read_mems_allowed_begin();
+	for_each_zone_zonelist_nodemask(zone, z, zonelist, gfp_zone(gfp_mask), nmask) {
+		struct page *page;
+
+		if (!cpuset_zone_allowed(zone, gfp_mask))
+			continue;
+		/*
+		 * no need to ask again on the same node. Pool is node rather than
+		 * zone aware
+		 */
+		if (zone_to_nid(zone) == node)
+			continue;
+		node = zone_to_nid(zone);
 
-	for_each_online_node(node) {
 		page = dequeue_huge_page_node_exact(h, node);
 		if (page)
 			return page;
 	}
+	if (unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
+		goto retry_cpuset;
+
 	return NULL;
 }
 
@@ -917,15 +937,11 @@ static struct page *dequeue_huge_page_vm
 				unsigned long address, int avoid_reserve,
 				long chg)
 {
-	struct page *page = NULL;
+	struct page *page;
 	struct mempolicy *mpol;
-	nodemask_t *nodemask;
 	gfp_t gfp_mask;
+	nodemask_t *nodemask;
 	int nid;
-	struct zonelist *zonelist;
-	struct zone *zone;
-	struct zoneref *z;
-	unsigned int cpuset_mems_cookie;
 
 	/*
 	 * A child process with MAP_PRIVATE mappings created by their parent
@@ -940,32 +956,15 @@ static struct page *dequeue_huge_page_vm
 	if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
 		goto err;
 
-retry_cpuset:
-	cpuset_mems_cookie = read_mems_allowed_begin();
 	gfp_mask = htlb_alloc_mask(h);
 	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
-	zonelist = node_zonelist(nid, gfp_mask);
-
-	for_each_zone_zonelist_nodemask(zone, z, zonelist,
-						MAX_NR_ZONES - 1, nodemask) {
-		if (cpuset_zone_allowed(zone, gfp_mask)) {
-			page = dequeue_huge_page_node(h, zone_to_nid(zone));
-			if (page) {
-				if (avoid_reserve)
-					break;
-				if (!vma_has_reserves(vma, chg))
-					break;
-
-				SetPagePrivate(page);
-				h->resv_huge_pages--;
-				break;
-			}
-		}
+	page = dequeue_huge_page_nodemask(h, gfp_mask, nid, nodemask);
+	if (page && !avoid_reserve && vma_has_reserves(vma, chg)) {
+		SetPagePrivate(page);
+		h->resv_huge_pages--;
 	}
 
 	mpol_cond_put(mpol);
-	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
-		goto retry_cpuset;
 	return page;
 
 err:
@@ -1633,7 +1632,7 @@ struct page *alloc_huge_page_node(struct
 
 	spin_lock(&hugetlb_lock);
 	if (h->free_huge_pages - h->resv_huge_pages > 0)
-		page = dequeue_huge_page_node(h, nid);
+		page = dequeue_huge_page_nodemask(h, gfp_mask, nid, NULL);
 	spin_unlock(&hugetlb_lock);
 
 	if (!page)
@@ -1642,26 +1641,27 @@ struct page *alloc_huge_page_node(struct
 	return page;
 }
 
-struct page *alloc_huge_page_nodemask(struct hstate *h, nodemask_t *nmask)
+
+struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
+		nodemask_t *nmask)
 {
 	gfp_t gfp_mask = htlb_alloc_mask(h);
-	struct page *page = NULL;
-	int node;
 
 	spin_lock(&hugetlb_lock);
 	if (h->free_huge_pages - h->resv_huge_pages > 0) {
-		for_each_node_mask(node, *nmask) {
-			page = dequeue_huge_page_node_exact(h, node);
-			if (page)
-				break;
+		struct page *page;
+
+		page = dequeue_huge_page_nodemask(h, gfp_mask, preferred_nid, nmask);
+		if (page) {
+			spin_unlock(&hugetlb_lock);
+			return page;
 		}
 	}
 	spin_unlock(&hugetlb_lock);
-	if (page)
-		return page;
 
 	/* No reservations, try to overcommit */
-	return __alloc_buddy_huge_page(h, gfp_mask, NUMA_NO_NODE, nmask);
+
+	return __alloc_buddy_huge_page(h, gfp_mask, preferred_nid, nmask);
 }
 
 /*
_

Patches currently in -mm which might be from mhocko@suse.com are

fs-file-replace-alloc_fdmem-with-kvmalloc-alternative.patch
mm-remove-return-value-from-init_currently_empty_zone.patch
mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable.patch
mm-drop-page_initialized-check-from-get_nid_for_pfn.patch
mm-memory_hotplug-get-rid-of-is_zone_device_section.patch
mm-memory_hotplug-split-up-register_one_node.patch
mm-memory_hotplug-consider-offline-memblocks-removable.patch
mm-consider-zone-which-is-not-fully-populated-to-have-holes.patch
mm-consider-zone-which-is-not-fully-populated-to-have-holes-fix.patch
mm-compaction-skip-over-holes-in-__reset_isolation_suitable.patch
mm-__first_valid_page-skip-over-offline-pages.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo-fix.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch
mm-memory_hotplug-fix-mmop_online_keep-behavior.patch
mm-memory_hotplug-do-not-assume-zone_normal-is-default-kernel-zone.patch
mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory.patch
mm-memory_hotplug-fix-the-section-mismatch-warning.patch
mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch
mm-adaptive-hash-table-scaling-fix.patch
mm-memory_hotplug-drop-artificial-restriction-on-online-offline.patch
mm-memory_hotplug-drop-config_movable_node.patch
mm-memory_hotplug-move-movable_node-to-the-hotplug-proper.patch
mm-make-pr_set_thp_disable-immediately-active.patch
mm-memory_hotplug-simplify-empty-node-mask-handling-in-new_node_page.patch
hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration.patch
mm-unify-new_node_page-and-alloc_migrate_target.patch
mm-memcg-fix-potential-undefined-behavior-in-mem_cgroup_event_ratelimit.patch
mm-hugetlb-unclutter-hugetlb-allocation-layers.patch
hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask.patch
mm-hugetlb-soft_offline-use-new_page_nodemask-for-soft-offline-migration.patch
lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible.patch
netfilter-use-kvmalloc-xt_alloc_table_info.patch

