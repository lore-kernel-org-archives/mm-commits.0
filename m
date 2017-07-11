From: akpm@linux-foundation.org
Subject: [merged]
 mm-hwpoison-introduce-memory_failure_hugetlb.patch removed from -mm tree
Date: Tue, 11 Jul 2017 12:23:09 -0700
Message-ID: <20170711192309.QhsHVNN46%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47562 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933570AbdGKTXK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:23:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: mm: hwpoison: introduce memory_failure_hugetlb()
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-introduce-memory_failure_hugetlb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hwpoison: introduce memory_failure_hugetlb()

memory_failure() is a big function and hard to maintain.  Handling
hugetlb- and non-hugetlb- case in a single function is not good, so this
patch separates PageHuge() branch into a new function, which saves many
PageHuge() check.

Link: http://lkml.kernel.org/r/1496305019-5493-7-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |  134 +++++++++++++++++++++++++-----------------
 1 file changed, 82 insertions(+), 52 deletions(-)

diff -puN mm/memory-failure.c~mm-hwpoison-introduce-memory_failure_hugetlb mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-introduce-memory_failure_hugetlb
+++ a/mm/memory-failure.c
@@ -1009,6 +1009,76 @@ static bool hwpoison_user_mappings(struc
 	return unmap_success;
 }
 
+static int memory_failure_hugetlb(unsigned long pfn, int trapno, int flags)
+{
+	struct page_state *ps;
+	struct page *p = pfn_to_page(pfn);
+	struct page *head = compound_head(p);
+	int res;
+	unsigned long page_flags;
+
+	if (TestSetPageHWPoison(head)) {
+		pr_err("Memory failure: %#lx: already hardware poisoned\n",
+		       pfn);
+		return 0;
+	}
+
+	num_poisoned_pages_inc();
+
+	if (!(flags & MF_COUNT_INCREASED) && !get_hwpoison_page(p)) {
+		/*
+		 * Check "filter hit" and "race with other subpage."
+		 */
+		lock_page(head);
+		if (PageHWPoison(head)) {
+			if ((hwpoison_filter(p) && TestClearPageHWPoison(p))
+			    || (p != head && TestSetPageHWPoison(head))) {
+				num_poisoned_pages_dec();
+				unlock_page(head);
+				return 0;
+			}
+		}
+		unlock_page(head);
+		dissolve_free_huge_page(p);
+		action_result(pfn, MF_MSG_FREE_HUGE, MF_DELAYED);
+		return 0;
+	}
+
+	lock_page(head);
+	page_flags = head->flags;
+
+	if (!PageHWPoison(head)) {
+		pr_err("Memory failure: %#lx: just unpoisoned\n", pfn);
+		num_poisoned_pages_dec();
+		unlock_page(head);
+		put_hwpoison_page(head);
+		return 0;
+	}
+
+	if (!hwpoison_user_mappings(p, pfn, trapno, flags, &head)) {
+		action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
+		res = -EBUSY;
+		goto out;
+	}
+
+	res = -EBUSY;
+
+	for (ps = error_states;; ps++)
+		if ((p->flags & ps->mask) == ps->res)
+			break;
+
+	page_flags |= (p->flags & (1UL << PG_dirty));
+
+	if (!ps->mask)
+		for (ps = error_states;; ps++)
+			if ((page_flags & ps->mask) == ps->res)
+				break;
+	res = page_action(ps, p, pfn);
+out:
+	unlock_page(head);
+	return res;
+}
+
 /**
  * memory_failure - Handle memory failure of a page.
  * @pfn: Page Number of the corrupted page
@@ -1046,33 +1116,22 @@ int memory_failure(unsigned long pfn, in
 	}
 
 	p = pfn_to_page(pfn);
-	orig_head = hpage = compound_head(p);
-
-	/* tmporary check code, to be updated in later patches */
-	if (PageHuge(p)) {
-		if (TestSetPageHWPoison(hpage)) {
-			pr_err("Memory failure: %#lx: already hardware poisoned\n", pfn);
-			return 0;
-		}
-		goto tmp;
-	}
+	if (PageHuge(p))
+		return memory_failure_hugetlb(pfn, trapno, flags);
 	if (TestSetPageHWPoison(p)) {
 		pr_err("Memory failure: %#lx: already hardware poisoned\n",
 			pfn);
 		return 0;
 	}
 
-tmp:
+	orig_head = hpage = compound_head(p);
 	num_poisoned_pages_inc();
 
 	/*
 	 * We need/can do nothing about count=0 pages.
 	 * 1) it's a free page, and therefore in safe hand:
 	 *    prep_new_page() will be the gate keeper.
-	 * 2) it's a free hugepage, which is also safe:
-	 *    an affected hugepage will be dequeued from hugepage freelist,
-	 *    so there's no concern about reusing it ever after.
-	 * 3) it's part of a non-compound high order page.
+	 * 2) it's part of a non-compound high order page.
 	 *    Implies some kernel user: cannot stop them from
 	 *    R/W the page; let's pray that the page has been
 	 *    used and will be freed some time later.
@@ -1083,31 +1142,13 @@ tmp:
 		if (is_free_buddy_page(p)) {
 			action_result(pfn, MF_MSG_BUDDY, MF_DELAYED);
 			return 0;
-		} else if (PageHuge(hpage)) {
-			/*
-			 * Check "filter hit" and "race with other subpage."
-			 */
-			lock_page(hpage);
-			if (PageHWPoison(hpage)) {
-				if ((hwpoison_filter(p) && TestClearPageHWPoison(p))
-				    || (p != hpage && TestSetPageHWPoison(hpage))) {
-					num_poisoned_pages_dec();
-					unlock_page(hpage);
-					return 0;
-				}
-			}
-			res = dequeue_hwpoisoned_huge_page(hpage);
-			action_result(pfn, MF_MSG_FREE_HUGE,
-				      res ? MF_IGNORED : MF_DELAYED);
-			unlock_page(hpage);
-			return res;
 		} else {
 			action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
 			return -EBUSY;
 		}
 	}
 
-	if (!PageHuge(p) && PageTransHuge(hpage)) {
+	if (PageTransHuge(hpage)) {
 		lock_page(p);
 		if (!PageAnon(p) || unlikely(split_huge_page(p))) {
 			unlock_page(p);
@@ -1145,7 +1186,7 @@ tmp:
 		return 0;
 	}
 
-	lock_page(hpage);
+	lock_page(p);
 
 	/*
 	 * The page could have changed compound pages during the locking.
@@ -1175,33 +1216,22 @@ tmp:
 	if (!PageHWPoison(p)) {
 		pr_err("Memory failure: %#lx: just unpoisoned\n", pfn);
 		num_poisoned_pages_dec();
-		unlock_page(hpage);
-		put_hwpoison_page(hpage);
+		unlock_page(p);
+		put_hwpoison_page(p);
 		return 0;
 	}
 	if (hwpoison_filter(p)) {
 		if (TestClearPageHWPoison(p))
 			num_poisoned_pages_dec();
-		unlock_page(hpage);
-		put_hwpoison_page(hpage);
+		unlock_page(p);
+		put_hwpoison_page(p);
 		return 0;
 	}
 
-	if (!PageHuge(p) && !PageTransTail(p) && !PageLRU(p))
+	if (!PageTransTail(p) && !PageLRU(p))
 		goto identify_page_state;
 
 	/*
-	 * For error on the tail page, we should set PG_hwpoison
-	 * on the head page to show that the hugepage is hwpoisoned
-	 */
-	if (PageHuge(p) && PageTail(p) && TestSetPageHWPoison(hpage)) {
-		action_result(pfn, MF_MSG_POISONED_HUGE, MF_IGNORED);
-		unlock_page(hpage);
-		put_hwpoison_page(hpage);
-		return 0;
-	}
