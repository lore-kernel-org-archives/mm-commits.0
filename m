From: akpm@linux-foundation.org
Subject: [failures]
 mm-vmscan-remove-unnecessary-lruvec-adding.patch removed from -mm tree
Date: Thu, 05 Mar 2020 18:50:41 -0800
Message-ID: <20200306025041.rERhvnYmB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgCFCun (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Mar 2020 21:50:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, alex.shi@linux.alibaba.com, daniel.m.jordan@oracle.com, hannes@cmpxchg.org, hughd@google.com, khlebnikov@yandex-team.ru, kirill@shutemov.name, kravetz@us.ibm.com, mhocko@kernel.org, mm-commits@vger.kernel.org, tj@kernel.org, vdavydov.dev@gmail.com, willy@infradead.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm/vmscan: remove unnecessary lruvec adding
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-unnecessary-lruvec-adding.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/vmscan: remove unnecessary lruvec adding

Patch series "per lruvec lru_lock for memcg", v9.

A partial merge.  The first 6 patches from a 20 patch series.  Some code
cleanups and minimal optimizations.


This patch (of 6):

We don't have to add a freeable page into lru and then remove from it. 
This change saves a couple of actions and makes the moving more clear.

The SetPageLRU needs to be kept here for list intergrity.
Otherwise:
 #0 mave_pages_to_lru              #1 release_pages
                                   if (put_page_testzero())
 if !put_page_testzero
                                     !PageLRU //skip lru_lock
                                       list_add(&page->lru,)
   list_add(&page->lru,) //corrupt

[akpm@linux-foundation.org: coding style fixes]
Link: http://lkml.kernel.org/r/1583146830-169516-2-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <kravetz@us.ibm.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-unnecessary-lruvec-adding
+++ a/mm/vmscan.c
@@ -1838,26 +1838,29 @@ static unsigned noinline_for_stack move_
 	while (!list_empty(list)) {
 		page = lru_to_page(list);
 		VM_BUG_ON_PAGE(PageLRU(page), page);
+		list_del(&page->lru);
 		if (unlikely(!page_evictable(page))) {
-			list_del(&page->lru);
 			spin_unlock_irq(&pgdat->lru_lock);
 			putback_lru_page(page);
 			spin_lock_irq(&pgdat->lru_lock);
 			continue;
 		}
-		lruvec = mem_cgroup_page_lruvec(page, pgdat);
 
+		/*
+		 * The SetPageLRU needs to be kept here for list intergrity.
+		 * Otherwise:
+		 *   #0 mave_pages_to_lru           #1 release_pages
+		 *				    if (put_page_testzero())
+		 *   if !put_page_testzero
+		 *				      !PageLRU //skip lru_lock
+		 *                                      list_add(&page->lru,)
+		 *     list_add(&page->lru,) //corrupt
+		 */
 		SetPageLRU(page);
-		lru = page_lru(page);
-
-		nr_pages = hpage_nr_pages(page);
-		update_lru_size(lruvec, lru, page_zonenum(page), nr_pages);
-		list_move(&page->lru, &lruvec->lists[lru]);
 
-		if (put_page_testzero(page)) {
+		if (unlikely(put_page_testzero(page))) {
 			__ClearPageLRU(page);
 			__ClearPageActive(page);
-			del_page_from_lru_list(page, lruvec, lru);
 
 			if (unlikely(PageCompound(page))) {
 				spin_unlock_irq(&pgdat->lru_lock);
@@ -1865,9 +1868,16 @@ static unsigned noinline_for_stack move_
 				spin_lock_irq(&pgdat->lru_lock);
 			} else
 				list_add(&page->lru, &pages_to_free);
-		} else {
-			nr_moved += nr_pages;
+			continue;
 		}
+
+		lruvec = mem_cgroup_page_lruvec(page, pgdat);
+		lru = page_lru(page);
+		nr_pages = hpage_nr_pages(page);
+
+		update_lru_size(lruvec, lru, page_zonenum(page), nr_pages);
+		list_add(&page->lru, &lruvec->lists[lru]);
+		nr_moved += nr_pages;
 	}
 
 	/*
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

ocfs2-remove-fs_ocfs2_nm.patch
ocfs2-remove-unused-macros.patch
ocfs2-use-ocfs2_sec_bits-in-macro.patch
ocfs2-remove-dlm_lock_is_remote.patch
ocfs2-remove-useless-err.patch
mm-memcg-fold-lock_page_lru-into-commit_charge.patch
mm-page_idle-no-unlikely-double-check-for-idle-page-counting.patch
mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch
mm-thp-clean-up-lru_add_page_tail.patch
mm-thp-narrow-lru-locking.patch
