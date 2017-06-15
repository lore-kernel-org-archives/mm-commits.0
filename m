From: akpm@linux-foundation.org
Subject: +
 mm-memory_hotplug-simplify-empty-node-mask-handling-in-new_node_page.patch
 added to -mm tree
Date: Thu, 15 Jun 2017 15:27:50 -0700
Message-ID: <594309e6.04wmbenqAn5F/ra8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45996 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751141AbdFOW1v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 18:27:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, js1304@gmail.com, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, vbabka@suse.cz, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: simplify empty node mask handling in new_node_page
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-simplify-empty-node-mask-handling-in-new_node_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-simplify-empty-node-mask-handling-in-new_node_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-simplify-empty-node-mask-handling-in-new_node_page.patch

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
Subject: mm, memory_hotplug: simplify empty node mask handling in new_node_page

new_node_page tries to allocate the target page on a different NUMA node
than the source page.  This makes sense in most cases during the hotplug
because we are likely to offline the whole numa node.  But there are cases
where there are no other nodes to fallback (e.g.  when offlining parts of
the only existing node) and we have to fallback to allocating from the
source node.  The current code does that but it can be simplified by
checking the nmask and updating it before we even try to allocate rather
than special casing it.

This patch shouldn't introduce any functional change.

Link: http://lkml.kernel.org/r/20170608074553.22152-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: zhong jiang <zhongjiang@huawei.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-simplify-empty-node-mask-handling-in-new_node_page mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-simplify-empty-node-mask-handling-in-new_node_page
+++ a/mm/memory_hotplug.c
@@ -1445,7 +1445,15 @@ static struct page *new_node_page(struct
 	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
 	int nid = page_to_nid(page);
 	nodemask_t nmask = node_states[N_MEMORY];
-	struct page *new_page = NULL;
+
+	/*
+	 * try to allocate from a different node but reuse this node if there
+	 * are no other online nodes to be used (e.g. we are offlining a part
+	 * of the only existing node)
+	 */
+	node_clear(nid, nmask);
+	if (nodes_empty(nmask))
+		node_set(nid, nmask);
 
 	/*
 	 * TODO: allocate a destination hugepage from a nearest neighbor node,
@@ -1456,18 +1464,11 @@ static struct page *new_node_page(struct
 		return alloc_huge_page_node(page_hstate(compound_head(page)),
 					next_node_in(nid, nmask));
 
-	node_clear(nid, nmask);
-
 	if (PageHighMem(page)
 	    || (zone_idx(page_zone(page)) == ZONE_MOVABLE))
 		gfp_mask |= __GFP_HIGHMEM;
 
-	if (!nodes_empty(nmask))
-		new_page = __alloc_pages_nodemask(gfp_mask, 0, nid, &nmask);
-	if (!new_page)
-		new_page = __alloc_pages(gfp_mask, 0, nid);
-
-	return new_page;
+	return __alloc_pages_nodemask(gfp_mask, 0, nid, &nmask);
 }
 
 #define NR_OFFLINE_AT_ONCE_PAGES	(256)
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
lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible.patch
netfilter-use-kvmalloc-xt_alloc_table_info.patch

