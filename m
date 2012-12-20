From: akpm@linux-foundation.org
Subject: + mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch added to -mm tree
Date: Wed, 19 Dec 2012 16:11:41 -0800
Message-ID: <20121220001142.4D18382004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:58734 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab2LTALn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 19:11:43 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so305877yen.3
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 16:11:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, satoru.moriya@hds.com, simon.jeons@gmail.com


The patch titled
     Subject: mm: reduce rmap overhead for ex-KSM page copies created on swap faults
has been added to the -mm tree.  Its filename is
     mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch

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
Subject: mm: reduce rmap overhead for ex-KSM page copies created on swap faults

When ex-KSM pages are faulted from swap cache, the fault handler is not
capable of re-establishing anon_vma-spanning KSM pages.  In this case, a
copy of the page is created instead, just like during a COW break.

These freshly made copies are known to be exclusive to the faulting VMA
and there is no reason to go look for this page in parent and sibling
processes during rmap operations.

Use page_add_new_anon_rmap() for these copies.  This also puts them on the
proper LRU lists and marks them SwapBacked, so we can get rid of doing
this ad-hoc in the KSM copy code.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Simon Jeons <simon.jeons@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Satoru Moriya <satoru.moriya@hds.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c    |    6 ------
 mm/memory.c |    5 ++++-
 2 files changed, 4 insertions(+), 7 deletions(-)

diff -puN mm/ksm.c~mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults mm/ksm.c
--- a/mm/ksm.c~mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults
+++ a/mm/ksm.c
@@ -1590,13 +1590,7 @@ struct page *ksm_does_need_to_copy(struc
 
 		SetPageDirty(new_page);
 		__SetPageUptodate(new_page);
-		SetPageSwapBacked(new_page);
 		__set_page_locked(new_page);
-
-		if (!mlocked_vma_newpage(vma, new_page))
-			lru_cache_add_lru(new_page, LRU_ACTIVE_ANON);
-		else
-			add_page_to_unevictable_list(new_page);
 	}
 
 	return new_page;
diff -puN mm/memory.c~mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults mm/memory.c
--- a/mm/memory.c~mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults
+++ a/mm/memory.c
@@ -3040,7 +3040,10 @@ static int do_swap_page(struct mm_struct
 	}
 	flush_icache_page(vma, page);
 	set_pte_at(mm, address, page_table, pte);
-	do_page_add_anon_rmap(page, vma, address, exclusive);
+	if (swapcache) /* ksm created a completely new copy */
+		page_add_new_anon_rmap(page, vma, address);
+	else
+		do_page_add_anon_rmap(page, vma, address, exclusive);
 	/* It's better to call commit-charge after rmap is established */
 	mem_cgroup_commit_charge_swapin(page, ptr);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-fix-calculation-of-dirtyable-memory.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-memmap_init_zone-performance-improvement.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

