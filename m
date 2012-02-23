From: akpm@linux-foundation.org
Subject: + mm-hugetlb-bail-out-unmapping-after-serving-reference-page.patch added to -mm tree
Date: Thu, 23 Feb 2012 12:06:29 -0800
Message-ID: <20120223200631.6EA25A01B8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:62974 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab2BWUGe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2012 15:06:34 -0500
Received: by vcbf1 with SMTP id f1so201729vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2012 12:06:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: mm: hugetlb: bail out unmapping after serving reference page
has been added to the -mm tree.  Its filename is
     mm-hugetlb-bail-out-unmapping-after-serving-reference-page.patch

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
Subject: mm: hugetlb: bail out unmapping after serving reference page

When unmapping a given VM range, we could bail out if a reference page is
supplied and is unmapped, which is a minor optimization.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/hugetlb.c~mm-hugetlb-bail-out-unmapping-after-serving-reference-page mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-bail-out-unmapping-after-serving-reference-page
+++ a/mm/hugetlb.c
@@ -2280,6 +2280,10 @@ void __unmap_hugepage_range(struct vm_ar
 		if (pte_dirty(pte))
 			set_page_dirty(page);
 		list_add(&page->lru, &page_list);
+
+		/* Bail out after unmapping reference page if supplied */
+		if (ref_page)
+			break;
 	}
 	spin_unlock(&mm->page_table_lock);
 	flush_tlb_range(vma, start, end);
_
Subject: Subject: mm: hugetlb: bail out unmapping after serving reference page

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

