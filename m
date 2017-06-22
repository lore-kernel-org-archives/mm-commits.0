From: akpm@linux-foundation.org
Subject: + mm-hugetlb-unclutter-hugetlb-allocation-layers.patch added to
 -mm tree
Date: Thu, 22 Jun 2017 12:41:47 -0700
Message-ID: <594c1d7b.63jGSO3wlLeENTzO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39570 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbdFVTls (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jun 2017 15:41:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mgorman@suse.de, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: unclutter hugetlb allocation layers
has been added to the -mm tree.  Its filename is
     mm-hugetlb-unclutter-hugetlb-allocation-layers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-unclutter-hugetlb-allocation-layers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-unclutter-hugetlb-allocation-layers.patch

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
Subject: mm, hugetlb: unclutter hugetlb allocation layers

Patch series "mm, hugetlb: allow proper node fallback dequeue".

While working on a hugetlb migration issue addressed in a separate
patchset
(http://lkml.kernel.org/r/20170608074553.22152-1-mhocko@kernel.org) I have
noticed that the hugetlb allocations from the preallocated pool are quite
subotimal.  There is no fallback mechanism implemented and no notion of
preferred node.  I have tried to work around it but Vlastimil was right to
push back for a more robust solution.  It seems that such a solution is to
reuse zonelist approach we use for the page alloctor.

This series has 3 patches.  The first one tries to make hugetlb allocation
layers more clear.  The second one implements the zonelist hugetlb pool
allocation and introduces a preferred node semantic which is used by the
migration callbacks.  The last patch is a clean up.


This patch (of 3):

Hugetlb allocation path for fresh huge pages is unnecessarily complex and
it mixes different interfaces between layers.  __alloc_buddy_huge_page is
the central place to perform a new allocation.  It checks for the hugetlb
overcommit and then relies on __hugetlb_alloc_buddy_huge_page to invoke
the page allocator.  This is all good except that __alloc_buddy_huge_page
pushes vma and address down the callchain and so
__hugetlb_alloc_buddy_huge_page has to deal with two different allocation
modes - one for memory policy and other node specific (or to make it more
obscure node non-specific) requests.  This just screams for a
reorganization.

This patch pulls out all the vma specific handling up to
__alloc_buddy_huge_page_with_mpol where it belongs. 
__alloc_buddy_huge_page will get nodemask argument and
__hugetlb_alloc_buddy_huge_page will become a trivial wrapper over the
page allocator.

In short:
__alloc_buddy_huge_page_with_mpol - memory policy handling
  __alloc_buddy_huge_page - overcommit handling and accounting
    __hugetlb_alloc_buddy_huge_page - page allocator layer

Also note that __hugetlb_alloc_buddy_huge_page and its cpuset retry loop
is not really needed because the page allocator already handles the
cpusets update.

Finally __hugetlb_alloc_buddy_huge_page had a special case for node
specific allocations (when no policy is applied and there is a node
given).  This has relied on __GFP_THISNODE to not fallback to a different
node.  alloc_huge_page_node is the only caller which relies on this
behavior so move the __GFP_THISNODE there.

Not only this removes quite some code it also should make those layers
easier to follow and clear wrt responsibilities.

Link: http://lkml.kernel.org/r/20170622193034.28972-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 
 mm/hugetlb.c            |  133 ++++++++------------------------------
 2 files changed, 30 insertions(+), 105 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-unclutter-hugetlb-allocation-layers include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-unclutter-hugetlb-allocation-layers
+++ a/include/linux/hugetlb.h
@@ -349,7 +349,7 @@ struct page *alloc_huge_page(struct vm_a
 struct page *alloc_huge_page_node(struct hstate *h, int nid);
 struct page *alloc_huge_page_noerr(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
-struct page *alloc_huge_page_nodemask(struct hstate *h, const nodemask_t *nmask);
+struct page *alloc_huge_page_nodemask(struct hstate *h, nodemask_t *nmask);
 int huge_add_to_page_cache(struct page *page, struct address_space *mapping,
 			pgoff_t idx);
 
diff -puN mm/hugetlb.c~mm-hugetlb-unclutter-hugetlb-allocation-layers mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-unclutter-hugetlb-allocation-layers
+++ a/mm/hugetlb.c
@@ -1521,82 +1521,19 @@ int dissolve_free_huge_pages(unsigned lo
 	return rc;
 }
 
-/*
- * There are 3 ways this can get called:
- * 1. With vma+addr: we use the VMA's memory policy
- * 2. With !vma, but nid=NUMA_NO_NODE:  We try to allocate a huge
- *    page from any node, and let the buddy allocator itself figure
- *    it out.
- * 3. With !vma, but nid!=NUMA_NO_NODE.  We allocate a huge page
- *    strictly from 'nid'
- */
 static struct page *__hugetlb_alloc_buddy_huge_page(struct hstate *h,
-		struct vm_area_struct *vma, unsigned long addr, int nid)
+		gfp_t gfp_mask, int nid, nodemask_t *nmask)
 {
 	int order = huge_page_order(h);
-	gfp_t gfp = htlb_alloc_mask(h)|__GFP_COMP|__GFP_REPEAT|__GFP_NOWARN;
-	unsigned int cpuset_mems_cookie;
-
-	/*
-	 * We need a VMA to get a memory policy.  If we do not
-	 * have one, we use the 'nid' argument.
-	 *
-	 * The mempolicy stuff below has some non-inlined bits
-	 * and calls ->vm_ops.  That makes it hard to optimize at
-	 * compile-time, even when NUMA is off and it does
-	 * nothing.  This helps the compiler optimize it out.
-	 */
-	if (!IS_ENABLED(CONFIG_NUMA) || !vma) {
-		/*
-		 * If a specific node is requested, make sure to
-		 * get memory from there, but only when a node
-		 * is explicitly specified.
-		 */
-		if (nid != NUMA_NO_NODE)
-			gfp |= __GFP_THISNODE;
-		/*
-		 * Make sure to call something that can handle
-		 * nid=NUMA_NO_NODE
-		 */
-		return alloc_pages_node(nid, gfp, order);
-	}
-
-	/*
-	 * OK, so we have a VMA.  Fetch the mempolicy and try to
-	 * allocate a huge page with it.  We will only reach this
-	 * when CONFIG_NUMA=y.
-	 */
-	do {
-		struct page *page;
-		struct mempolicy *mpol;
-		int nid;
-		nodemask_t *nodemask;
-
-		cpuset_mems_cookie = read_mems_allowed_begin();
-		nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
-		mpol_cond_put(mpol);
-		page = __alloc_pages_nodemask(gfp, order, nid, nodemask);
-		if (page)
-			return page;
-	} while (read_mems_allowed_retry(cpuset_mems_cookie));
 
-	return NULL;
+	gfp_mask |= __GFP_COMP|__GFP_REPEAT|__GFP_NOWARN;
+	if (nid == NUMA_NO_NODE)
+		nid = numa_mem_id();
+	return __alloc_pages_nodemask(gfp_mask, order, nid, nmask);
 }
 
-/*
- * There are two ways to allocate a huge page:
- * 1. When you have a VMA and an address (like a fault)
- * 2. When you have no VMA (like when setting /proc/.../nr_hugepages)
- *
- * 'vma' and 'addr' are only for (1).  'nid' is always NUMA_NO_NODE in
- * this case which signifies that the allocation should be done with
- * respect for the VMA's memory policy.
- *
- * For (2), we ignore 'vma' and 'addr' and use 'nid' exclusively. This
- * implies that memory policies will not be taken in to account.
- */
-static struct page *__alloc_buddy_huge_page(struct hstate *h,
-		struct vm_area_struct *vma, unsigned long addr, int nid)
+static struct page *__alloc_buddy_huge_page(struct hstate *h, gfp_t gfp_mask,
+		int nid, nodemask_t *nmask)
 {
 	struct page *page;
 	unsigned int r_nid;
@@ -1605,15 +1542,6 @@ static struct page *__alloc_buddy_huge_p
 		return NULL;
 
 	/*
-	 * Make sure that anyone specifying 'nid' is not also specifying a VMA.
-	 * This makes sure the caller is picking _one_ of the modes with which
-	 * we can call this function, not both.
-	 */
-	if (vma || (addr != -1)) {
-		VM_WARN_ON_ONCE(addr == -1);
-		VM_WARN_ON_ONCE(nid != NUMA_NO_NODE);
-	}
-	/*
 	 * Assume we will successfully allocate the surplus page to
 	 * prevent racing processes from causing the surplus to exceed
 	 * overcommit
@@ -1646,7 +1574,7 @@ static struct page *__alloc_buddy_huge_p
 	}
 	spin_unlock(&hugetlb_lock);
 
-	page = __hugetlb_alloc_buddy_huge_page(h, vma, addr, nid);
+	page = __hugetlb_alloc_buddy_huge_page(h, gfp_mask, nid, nmask);
 
 	spin_lock(&hugetlb_lock);
 	if (page) {
@@ -1671,26 +1599,23 @@ static struct page *__alloc_buddy_huge_p
 }
 
 /*
- * Allocate a huge page from 'nid'.  Note, 'nid' may be
- * NUMA_NO_NODE, which means that it may be allocated
- * anywhere.
- */
-static
-struct page *__alloc_buddy_huge_page_no_mpol(struct hstate *h, int nid)
-{
-	unsigned long addr = -1;
-
-	return __alloc_buddy_huge_page(h, NULL, addr, nid);
-}
-
-/*
  * Use the VMA's mpolicy to allocate a huge page from the buddy.
  */
 static
 struct page *__alloc_buddy_huge_page_with_mpol(struct hstate *h,
 		struct vm_area_struct *vma, unsigned long addr)
 {
-	return __alloc_buddy_huge_page(h, vma, addr, NUMA_NO_NODE);
+	struct page *page;
+	struct mempolicy *mpol;
+	gfp_t gfp_mask = htlb_alloc_mask(h);
+	int nid;
+	nodemask_t *nodemask;
+
+	nid = huge_node(vma, addr, gfp_mask, &mpol, &nodemask);
+	page = __alloc_buddy_huge_page(h, gfp_mask, nid, nodemask);
+	mpol_cond_put(mpol);
+
+	return page;
 }
 
 /*
@@ -1700,21 +1625,26 @@ struct page *__alloc_buddy_huge_page_wit
  */
 struct page *alloc_huge_page_node(struct hstate *h, int nid)
 {
+	gfp_t gfp_mask = htlb_alloc_mask(h);
 	struct page *page = NULL;
 
+	if (nid != NUMA_NO_NODE)
+		gfp_mask |= __GFP_THISNODE;
+
 	spin_lock(&hugetlb_lock);
 	if (h->free_huge_pages - h->resv_huge_pages > 0)
 		page = dequeue_huge_page_node(h, nid);
 	spin_unlock(&hugetlb_lock);
 
 	if (!page)
-		page = __alloc_buddy_huge_page_no_mpol(h, nid);
+		page = __alloc_buddy_huge_page(h, gfp_mask, nid, NULL);
 
 	return page;
 }
 
-struct page *alloc_huge_page_nodemask(struct hstate *h, const nodemask_t *nmask)
+struct page *alloc_huge_page_nodemask(struct hstate *h, nodemask_t *nmask)
 {
+	gfp_t gfp_mask = htlb_alloc_mask(h);
 	struct page *page = NULL;
 	int node;
 
@@ -1731,13 +1661,7 @@ struct page *alloc_huge_page_nodemask(st
 		return page;
 
 	/* No reservations, try to overcommit */
-	for_each_node_mask(node, *nmask) {
-		page = __alloc_buddy_huge_page_no_mpol(h, node);
-		if (page)
-			return page;
-	}
-
-	return NULL;
+	return __alloc_buddy_huge_page(h, gfp_mask, NUMA_NO_NODE, nmask);
 }
 
 /*
@@ -1765,7 +1689,8 @@ static int gather_surplus_pages(struct h
 retry:
 	spin_unlock(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
-		page = __alloc_buddy_huge_page_no_mpol(h, NUMA_NO_NODE);
+		page = __alloc_buddy_huge_page(h, htlb_alloc_mask(h),
+				NUMA_NO_NODE, NULL);
 		if (!page) {
 			alloc_ok = false;
 			break;
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

