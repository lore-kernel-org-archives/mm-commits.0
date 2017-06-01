From: akpm@linux-foundation.org
Subject: + mm-hwpoison-introduce-memory_failure_hugetlb.patch added to -mm tree
Date: Thu, 01 Jun 2017 15:38:07 -0700
Message-ID: <5930974f.dAR3cZGEHU5GV4I0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41678 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751138AbdFAWiI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2017 18:38:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: introduce memory_failure_hugetlb()
has been added to the -mm tree.  Its filename is
     mm-hwpoison-introduce-memory_failure_hugetlb.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-introduce-memory_failure_hugetlb.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-introduce-memory_failure_hugetlb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1172,33 +1213,22 @@ tmp:
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
-
-	/*
 	 * It's very difficult to mess with pages currently under IO
 	 * and in many cases impossible, so we just avoid it here.
 	 */
@@ -1245,7 +1275,7 @@ identify_page_state:
 				break;
 	res = page_action(ps, p, pfn);
 out:
-	unlock_page(hpage);
+	unlock_page(p);
 	return res;
 }
 EXPORT_SYMBOL_GPL(memory_failure);
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-drop-null-return-check-of-pte_offset_map_lock.patch
mm-hugetlb-prevent-reuse-of-hwpoisoned-free-hugepages.patch
mm-hugetlb-return-immediately-for-hugetlb-page-in-__delete_from_page_cache.patch
mm-hwpoison-change-pagehwpoison-behavior-on-hugetlb-pages.patch
mm-soft-offline-dissolve-free-hugepage-if-soft-offlined.patch
mm-hwpoison-introduce-memory_failure_hugetlb.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error.patch
mm-hugetlb-delete-dequeue_hwpoisoned_huge_page.patch
mm-hwpoison-introduce-idenfity_page_state.patch

