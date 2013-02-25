From: akpm@linux-foundation.org
Subject: [merged] mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:48:35 -0800
Message-ID: <20130225204835.B7D0B5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:39244 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab3BYUsi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:48:38 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so345777ghb.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:48:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, satoru.moriya@hds.com, simon.jeons@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: reduce rmap overhead for ex-KSM page copies created on swap faults
has been removed from the -mm tree.  Its filename was
     mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -3044,7 +3044,10 @@ static int do_swap_page(struct mm_struct
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
mm-memmap_init_zone-performance-improvement.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

