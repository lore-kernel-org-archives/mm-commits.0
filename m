From: akpm@linux-foundation.org
Subject: [merged] mm-hwpoison-remove-incorrect-comment.patch removed from
 -mm tree
Date: Fri, 29 Jul 2016 11:56:57 -0700
Message-ID: <579ba6f9.M/Wjkfd003rkZOlK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbcG2S46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:56:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, mhocko@suse.com, zhanc1@andrew.cmu.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: remove incorrect comments
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-remove-incorrect-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hwpoison: remove incorrect comments

dequeue_hwpoisoned_huge_page() can be called without page lock hold,
so let's remove incorrect comment.

The reason why the page lock is not really needed is that
dequeue_hwpoisoned_huge_page() checks page_huge_active() inside hugetlb_lock,
which allows us to avoid trying to dequeue a hugepage that are just allocated
but not linked to active list yet, even without taking page lock.

Link: http://lkml.kernel.org/r/20160720092901.GA15995@www9186uo.sakura.ne.jp
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Zhan Chen <zhanc1@andrew.cmu.edu>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c        |    1 -
 mm/memory-failure.c |    2 --
 2 files changed, 3 deletions(-)

diff -puN mm/hugetlb.c~mm-hwpoison-remove-incorrect-comment mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hwpoison-remove-incorrect-comment
+++ a/mm/hugetlb.c
@@ -4391,7 +4391,6 @@ follow_huge_pud(struct mm_struct *mm, un
 
 /*
  * This function is called from memory failure code.
- * Assume the caller holds page lock of the head page.
  */
 int dequeue_hwpoisoned_huge_page(struct page *hpage)
 {
diff -puN mm/memory-failure.c~mm-hwpoison-remove-incorrect-comment mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-remove-incorrect-comment
+++ a/mm/memory-failure.c
@@ -741,8 +741,6 @@ static int me_huge_page(struct page *p,
 	 * page->lru because it can be used in other hugepage operations,
 	 * such as __unmap_hugepage_range() and gather_surplus_pages().
 	 * So instead we use page_mapping() and PageAnon().
-	 * We assume that this function is called with page lock held,
-	 * so there is no race between isolation and mapping/unmapping.
 	 */
 	if (!(page_mapping(hpage) || PageAnon(hpage))) {
 		res = dequeue_hwpoisoned_huge_page(hpage);
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are


