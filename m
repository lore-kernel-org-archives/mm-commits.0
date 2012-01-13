From: akpm@linux-foundation.org
Subject: [folded] memcg-clear-pc-mem_cgorup-if-necessary-comments.patch removed from -mm tree
Date: Thu, 12 Jan 2012 16:49:18 -0800
Message-ID: <20120113004918.DDB0D1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:46803 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab2AMAtT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 19:49:19 -0500
Received: by yhjj52 with SMTP id j52so7021yhj.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 16:49:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-clear-pc-mem_cgorup-if-necessary-comments
has been removed from the -mm tree.  Its filename was
     memcg-clear-pc-mem_cgorup-if-necessary-comments.patch

This patch was dropped because it was folded into memcg-clear-pc-mem_cgorup-if-necessary.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: memcg-clear-pc-mem_cgorup-if-necessary-comments

Add comments to the clearing sites.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c        |    9 +++++++++
 mm/swap_state.c |    9 +++++++++
 2 files changed, 18 insertions(+)

diff -puN mm/ksm.c~memcg-clear-pc-mem_cgorup-if-necessary-comments mm/ksm.c
--- a/mm/ksm.c~memcg-clear-pc-mem_cgorup-if-necessary-comments
+++ a/mm/ksm.c
@@ -1572,6 +1572,15 @@ struct page *ksm_does_need_to_copy(struc
 
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
 	if (new_page) {
+		/*
+		 * The memcg-specific accounting when moving
+		 * pages around the LRU lists relies on the
+		 * page's owner (memcg) to be valid.  Usually,
+		 * pages are assigned to a new owner before
+		 * being put on the LRU list, but since this
+		 * is not the case here, the stale owner from
+		 * a previous allocation cycle must be reset.
+		 */
 		mem_cgroup_reset_owner(new_page);
 		copy_user_highpage(new_page, page, address, vma);
 
diff -puN mm/swap_state.c~memcg-clear-pc-mem_cgorup-if-necessary-comments mm/swap_state.c
--- a/mm/swap_state.c~memcg-clear-pc-mem_cgorup-if-necessary-comments
+++ a/mm/swap_state.c
@@ -300,6 +300,15 @@ struct page *read_swap_cache_async(swp_e
 			new_page = alloc_page_vma(gfp_mask, vma, addr);
 			if (!new_page)
 				break;		/* Out of memory */
+			/*
+			 * The memcg-specific accounting when moving
+			 * pages around the LRU lists relies on the
+			 * page's owner (memcg) to be valid.  Usually,
+			 * pages are assigned to a new owner before
+			 * being put on the LRU list, but since this
+			 * is not the case here, the stale owner from
+			 * a previous allocation cycle must be reset.
+			 */
 			mem_cgroup_reset_owner(new_page);
 		}
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-fix-pgpgin-pgpgout-documentation.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch
memcg-clean-up-soft_limit_tree-if-allocation-fails.patch
oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm.patch
memcg-simplify-page-cache-charging.patch
memcg-simplify-corner-case-handling-of-lru.patch
memcg-clear-pc-mem_cgorup-if-necessary.patch
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
vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate.patch
memcg-fix-split_huge_page_refcounts.patch
memcg-fix-mem_cgroup_print_bad_page.patch
mm-rearrange-putback_inactive_pages.patch

