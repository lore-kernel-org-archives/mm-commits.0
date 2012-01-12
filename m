From: akpm@linux-foundation.org
Subject: + mm-__count_immobile_pages-make-sure-the-node-is-online.patch added to -mm tree
Date: Thu, 12 Jan 2012 13:26:37 -0800
Message-ID: <20120112212639.5AC3C20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:61360 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab2ALVdL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 16:33:11 -0500
Received: by wibhq12 with SMTP id hq12so81599wib.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 13:33:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de


The patch titled
     Subject: mm: __count_immobile_pages(): make sure the node is online
has been added to the -mm tree.  Its filename is
     mm-__count_immobile_pages-make-sure-the-node-is-online.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm: __count_immobile_pages(): make sure the node is online

page_zone() requires an online node otherwise we are accessing NULL
NODE_DATA.  This is not an issue at the moment because node_zones are
located at the structure beginning but this might change in the future so
better be careful about that.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-__count_immobile_pages-make-sure-the-node-is-online mm/page_alloc.c
--- a/mm/page_alloc.c~mm-__count_immobile_pages-make-sure-the-node-is-online
+++ a/mm/page_alloc.c
@@ -5386,15 +5386,22 @@ __count_immobile_pages(struct zone *zone
 
 bool is_pageblock_removable_nolock(struct page *page)
 {
-	struct zone *zone = page_zone(page);
-	unsigned long pfn = page_to_pfn(page);
+	struct zone *zone;
+	unsigned long pfn;
 
 	/*
 	 * We have to be careful here because we are iterating over memory
 	 * sections which are not zone aware so we might end up outside of
 	 * the zone but still within the section.
+	 * We have to take care about the node as well. If the node is offline
+	 * its NODE_DATA will be NULL - see page_zone.
 	 */
-	if (!zone || zone->zone_start_pfn > pfn ||
+	if (!node_online(page_to_nid(page)))
+		return false;
+
+	zone = page_zone(page);
+	pfn = page_to_pfn(page);
+	if (zone->zone_start_pfn > pfn ||
 			zone->zone_start_pfn + zone->spanned_pages <= pfn)
 		return false;
 
_
Subject: Subject: mm: __count_immobile_pages(): make sure the node is online

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch
mm-__count_immobile_pages-make-sure-the-node-is-online.patch
mm-hugetlb-undo-change-to-page-mapcount-in-fault-handler.patch
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
memcg-fix-pgpgin-pgpgout-documentation.patch
mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch
mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch
mm-memcg-clean-up-fault-accounting.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null-fix.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch
mm-memcg-remove-unneeded-checks-from-newpage_charge.patch
mm-memcg-remove-unneeded-checks-from-uncharge_page.patch
page_cgroup-add-helper-function-to-get-swap_cgroup.patch
page_cgroup-add-helper-function-to-get-swap_cgroup-cleanup.patch
memcg-clean-up-soft_limit_tree-if-allocation-fails.patch
oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm.patch
memcg-simplify-page-cache-charging.patch
memcg-simplify-corner-case-handling-of-lru.patch
memcg-clear-pc-mem_cgorup-if-necessary.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-3.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-page-migration-to-reset_owner.patch
memcg-simplify-lru-handling-by-new-rule.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix-null-mem_cgroup_try_charge.patch
memcg-cleanup-for_each_node_state.patch
page_alloc-break-early-in-check_for_regular_memory.patch
page_cgroup-drop-multi-config_memory_hotplug.patch
memcg-fix-split_huge_page_refcounts.patch
memcg-fix-mem_cgroup_print_bad_page.patch

