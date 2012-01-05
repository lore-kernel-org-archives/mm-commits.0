From: akpm@linux-foundation.org
Subject: + mm-hugetlb-undo-change-to-page-mapcount-in-fault-handler.patch added to -mm tree
Date: Wed, 04 Jan 2012 17:09:24 -0800
Message-ID: <20120105010925.210F320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:41093 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab2AEBJ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2012 20:09:27 -0500
Received: by eaak10 with SMTP id k10so548eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Jan 2012 17:09:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: mm/hugetlb.c: undo change to page mapcount in fault handler
has been added to the -mm tree.  Its filename is
     mm-hugetlb-undo-change-to-page-mapcount-in-fault-handler.patch

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
Subject: mm/hugetlb.c: undo change to page mapcount in fault handler

Page mapcount should be updated only if we are sure that the page ends up
in the page table otherwise we would leak if we couldn't COW due to
reservations or if idx is out of bounds.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-undo-change-to-page-mapcount-in-fault-handler mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-undo-change-to-page-mapcount-in-fault-handler
+++ a/mm/hugetlb.c
@@ -2508,6 +2508,7 @@ static int hugetlb_no_page(struct mm_str
 {
 	struct hstate *h = hstate_vma(vma);
 	int ret = VM_FAULT_SIGBUS;
+	int anon_rmap = 0;
 	pgoff_t idx;
 	unsigned long size;
 	struct page *page;
@@ -2562,14 +2563,13 @@ retry:
 			spin_lock(&inode->i_lock);
 			inode->i_blocks += blocks_per_huge_page(h);
 			spin_unlock(&inode->i_lock);
-			page_dup_rmap(page);
 		} else {
 			lock_page(page);
 			if (unlikely(anon_vma_prepare(vma))) {
 				ret = VM_FAULT_OOM;
 				goto backout_unlocked;
 			}
-			hugepage_add_new_anon_rmap(page, vma, address);
+			anon_rmap = 1;
 		}
 	} else {
 		/*
@@ -2582,7 +2582,6 @@ retry:
 			      VM_FAULT_SET_HINDEX(h - hstates);
 			goto backout_unlocked;
 		}
-		page_dup_rmap(page);
 	}
 
 	/*
@@ -2606,6 +2605,10 @@ retry:
 	if (!huge_pte_none(huge_ptep_get(ptep)))
 		goto backout;
 
+	if (anon_rmap)
+		hugepage_add_new_anon_rmap(page, vma, address);
+	else
+		page_dup_rmap(page);
 	new_pte = make_huge_pte(vma, page, ((vma->vm_flags & VM_WRITE)
 				&& (vma->vm_flags & VM_SHARED)));
 	set_huge_pte_at(mm, address, ptep, new_pte);
_
Subject: Subject: mm/hugetlb.c: undo change to page mapcount in fault handler

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
linux-next.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix.patch
mm-hugetlb-avoid-bogus-counter-of-surplus-huge-page.patch
mm-vmscan-fix-typo-in-isolating-lru-pages.patch
mm-hugetlb-undo-change-to-page-mapcount-in-fault-handler.patch
mm-vmscanc-check-page-order-when-isolating-lru-pages.patch

