From: akpm@linux-foundation.org
Subject: [folded] memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch removed from -mm tree
Date: Wed, 23 Mar 2011 16:19:41 -0700
Message-ID: <201103232319.p2NNJfGD004330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933213Ab1CWXTt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 19:19:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg-remove-direct-page_cgroup-to-page-pointer-fix
has been removed from the -mm tree.  Its filename was
     memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch

This patch was dropped because it was folded into memcg-remove-direct-page_cgroup-to-page-pointer.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-remove-direct-page_cgroup-to-page-pointer-fix
From: Johannes Weiner <hannes@cmpxchg.org>

Move pc -> page linkage checks to the lookup function itself.  I no longer
plan on removing them again, so there is no point in keeping them visible
at the callsites.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c  |    2 --
 mm/page_cgroup.c |   10 ++++++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-direct-page_cgroup-to-page-pointer-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-direct-page_cgroup-to-page-pointer-fix
+++ a/mm/memcontrol.c
@@ -1081,7 +1081,6 @@ unsigned long mem_cgroup_isolate_pages(u
 			continue;
 
 		page = lookup_cgroup_page(pc);
-		VM_BUG_ON(pc != lookup_page_cgroup(page));
 
 		if (unlikely(!PageLRU(page)))
 			continue;
@@ -3346,7 +3345,6 @@ static int mem_cgroup_force_empty_list(s
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 
 		page = lookup_cgroup_page(pc);
-		VM_BUG_ON(pc != lookup_page_cgroup(page));
 
 		ret = mem_cgroup_move_parent(page, pc, mem, GFP_KERNEL);
 		if (ret == -ENOMEM)
diff -puN mm/page_cgroup.c~memcg-remove-direct-page_cgroup-to-page-pointer-fix mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-remove-direct-page_cgroup-to-page-pointer-fix
+++ a/mm/page_cgroup.c
@@ -45,11 +45,14 @@ struct page_cgroup *lookup_page_cgroup(s
 struct page *lookup_cgroup_page(struct page_cgroup *pc)
 {
 	unsigned long pfn;
+	struct page *page;
 	pg_data_t *pgdat;
 
 	pgdat = NODE_DATA(page_cgroup_array_id(pc));
 	pfn = pc - pgdat->node_page_cgroup + pgdat->node_start_pfn;
-	return pfn_to_page(pfn);
+	page = pfn_to_page(pfn);
+	VM_BUG_ON(pc != lookup_page_cgroup(page));
+	return page;
 }
 
 static int __init alloc_node_page_cgroup(int nid)
@@ -117,11 +120,14 @@ struct page_cgroup *lookup_page_cgroup(s
 struct page *lookup_cgroup_page(struct page_cgroup *pc)
 {
 	struct mem_section *section;
+	struct page *page;
 	unsigned long nr;
 
 	nr = page_cgroup_array_id(pc);
 	section = __nr_to_section(nr);
-	return pfn_to_page(pc - section->page_cgroup);
+	page = pfn_to_page(pc - section->page_cgroup);
+	VM_BUG_ON(pc != lookup_page_cgroup(page));
+	return page;
 }
 
 /* __alloc_bootmem...() is protected by !slab_available() */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix-fix.patch
memcg-charged-pages-always-have-valid-per-memcg-zone-info.patch
memcg-remove-memcg-reclaim_param_lock.patch
memcg-keep-only-one-charge-cancelling-function.patch
memcg-keep-only-one-charge-cancelling-function-fix.patch
memcg-convert-per-cpu-stock-from-bytes-to-page-granularity.patch
memcg-convert-uncharge-batching-from-bytes-to-page-granularity.patch
memcg-unify-charge-uncharge-quantities-to-units-of-pages.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-use-native-word-page-statistics-counters.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem-fix.patch
memcg-fix-leak-on-wrong-lru-with-fuse.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch

