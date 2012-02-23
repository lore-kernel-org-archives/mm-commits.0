From: akpm@linux-foundation.org
Subject: + mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch added to -mm tree
Date: Thu, 23 Feb 2012 12:13:08 -0800
Message-ID: <20120223201309.42E69A0245@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:48142 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab2BWUNK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2012 15:13:10 -0500
Received: by qcsp5 with SMTP id p5so20282qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2012 12:13:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: mm: hugetlb: cleanup duplicated code in unmapping vm range
has been added to the -mm tree.  Its filename is
     mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm: hugetlb: cleanup duplicated code in unmapping vm range

Fix code duplication in __unmap_hugepage_range(), such as pte_page() and
huge_pte_none().

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range
+++ a/mm/hugetlb.c
@@ -2245,16 +2245,23 @@ void __unmap_hugepage_range(struct vm_ar
 		if (huge_pmd_unshare(mm, &address, ptep))
 			continue;
 
+		pte = huge_ptep_get(ptep);
+		if (huge_pte_none(pte))
+			continue;
+
+		/*
+		 * HWPoisoned hugepage is already unmapped and dropped reference
+		 */
+		if (unlikely(is_hugetlb_entry_hwpoisoned(pte)))
+			continue;
+
+		page = pte_page(pte);
 		/*
 		 * If a reference page is supplied, it is because a specific
 		 * page is being unmapped, not a range. Ensure the page we
 		 * are about to unmap is the actual page of interest.
 		 */
 		if (ref_page) {
-			pte = huge_ptep_get(ptep);
-			if (huge_pte_none(pte))
-				continue;
-			page = pte_page(pte);
 			if (page != ref_page)
 				continue;
 
@@ -2267,16 +2274,6 @@ void __unmap_hugepage_range(struct vm_ar
 		}
 
 		pte = huge_ptep_get_and_clear(mm, address, ptep);
-		if (huge_pte_none(pte))
-			continue;
-
-		/*
-		 * HWPoisoned hugepage is already unmapped and dropped reference
-		 */
-		if (unlikely(is_hugetlb_entry_hwpoisoned(pte)))
-			continue;
-
-		page = pte_page(pte);
 		if (pte_dirty(pte))
 			set_page_dirty(page);
 		list_add(&page->lru, &page_list);
_
Subject: Subject: mm: hugetlb: cleanup duplicated code in unmapping vm range

Patches currently in -mm which might be from dhillf@gmail.com are

mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
vmscan-reclaim-at-order-0-when-compaction-is-enabled.patch
vmscan-kswapd-carefully-call-compaction.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
vmscan-only-defer-compaction-for-failed-order-and-higher.patch
hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch
mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch
mm-vmscan-handle-isolated-pages-with-lru-lock-released.patch
mm-hugetlb-bail-out-unmapping-after-serving-reference-page.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch

