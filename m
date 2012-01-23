From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-undo-change-to-page-mapcount-in-fault-handler.patch removed from -mm tree
Date: Mon, 23 Jan 2012 12:21:45 -0800
Message-ID: <20120123202145.9BB241E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:58337 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab2AWUVq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2012 15:21:46 -0500
Received: by mail-gy0-f202.google.com with SMTP id g20so288772ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jan 2012 12:21:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: undo change to page mapcount in fault handler
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-undo-change-to-page-mapcount-in-fault-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch

