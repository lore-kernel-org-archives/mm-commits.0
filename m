From: akpm@linux-foundation.org
Subject: [patch 010/115] mm: hwpoison: change PageHWPoison behavior
 on hugetlb pages
Date: Mon, 10 Jul 2017 15:47:38 -0700
Message-ID: <20170710224738.VLBhQyMsA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42088 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754910AbdGJWrk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:47:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, mhocko@kernel.org, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hwpoison: change PageHWPoison behavior on hugetlb pages

We'd like to narrow down the error region in memory error on hugetlb
pages.  However, currently we set PageHWPoison flags on all subpages in
the error hugepage and add # of subpages to num_hwpoison_pages, which
doesn't fit our purpose.

So this patch changes the behavior and we only set PageHWPoison on the
head page then increase num_hwpoison_pages only by 1.  This is a
preparation for narrow-down part which comes in later patches.

Link: http://lkml.kernel.org/r/1496305019-5493-4-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    9 ---
 mm/memory-failure.c     |   87 ++++++++++----------------------------
 2 files changed, 24 insertions(+), 72 deletions(-)

diff -puN include/linux/swapops.h~mm-hwpoison-change-pagehwpoison-behavior-on-hugetlb-pages include/linux/swapops.h
--- a/include/linux/swapops.h~mm-hwpoison-change-pagehwpoison-behavior-on-hugetlb-pages
+++ a/include/linux/swapops.h
@@ -196,15 +196,6 @@ static inline void num_poisoned_pages_de
 	atomic_long_dec(&num_poisoned_pages);
 }
 
-static inline void num_poisoned_pages_add(long num)
-{
-	atomic_long_add(num, &num_poisoned_pages);
-}
-
-static inline void num_poisoned_pages_sub(long num)
-{
-	atomic_long_sub(num, &num_poisoned_pages);
-}
 #else
 
 static inline swp_entry_t make_hwpoison_entry(struct page *page)
diff -puN mm/memory-failure.c~mm-hwpoison-change-pagehwpoison-behavior-on-hugetlb-pages mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-change-pagehwpoison-behavior-on-hugetlb-pages
+++ a/mm/memory-failure.c
@@ -1009,22 +1009,6 @@ static bool hwpoison_user_mappings(struc
 	return unmap_success;
 }
 
-static void set_page_hwpoison_huge_page(struct page *hpage)
-{
-	int i;
-	int nr_pages = 1 << compound_order(hpage);
-	for (i = 0; i < nr_pages; i++)
-		SetPageHWPoison(hpage + i);
-}
-
-static void clear_page_hwpoison_huge_page(struct page *hpage)
-{
-	int i;
-	int nr_pages = 1 << compound_order(hpage);
-	for (i = 0; i < nr_pages; i++)
-		ClearPageHWPoison(hpage + i);
-}
-
 /**
  * memory_failure - Handle memory failure of a page.
  * @pfn: Page Number of the corrupted page
@@ -1050,7 +1034,6 @@ int memory_failure(unsigned long pfn, in
 	struct page *hpage;
 	struct page *orig_head;
 	int res;
-	unsigned int nr_pages;
 	unsigned long page_flags;
 
 	if (!sysctl_memory_failure_recovery)
@@ -1064,24 +1047,23 @@ int memory_failure(unsigned long pfn, in
 
 	p = pfn_to_page(pfn);
 	orig_head = hpage = compound_head(p);
+
+	/* tmporary check code, to be updated in later patches */
+	if (PageHuge(p)) {
+		if (TestSetPageHWPoison(hpage)) {
+			pr_err("Memory failure: %#lx: already hardware poisoned\n", pfn);
+			return 0;
+		}
+		goto tmp;
+	}
 	if (TestSetPageHWPoison(p)) {
 		pr_err("Memory failure: %#lx: already hardware poisoned\n",
 			pfn);
 		return 0;
 	}
 
-	/*
-	 * Currently errors on hugetlbfs pages are measured in hugepage units,
-	 * so nr_pages should be 1 << compound_order.  OTOH when errors are on
-	 * transparent hugepages, they are supposed to be split and error
-	 * measurement is done in normal page units.  So nr_pages should be one
-	 * in this case.
-	 */
-	if (PageHuge(p))
-		nr_pages = 1 << compound_order(hpage);
-	else /* normal page or thp */
-		nr_pages = 1;
-	num_poisoned_pages_add(nr_pages);
+tmp:
+	num_poisoned_pages_inc();
 
 	/*
 	 * We need/can do nothing about count=0 pages.
@@ -1109,12 +1091,11 @@ int memory_failure(unsigned long pfn, in
 			if (PageHWPoison(hpage)) {
 				if ((hwpoison_filter(p) && TestClearPageHWPoison(p))
 				    || (p != hpage && TestSetPageHWPoison(hpage))) {
-					num_poisoned_pages_sub(nr_pages);
+					num_poisoned_pages_dec();
 					unlock_page(hpage);
 					return 0;
 				}
 			}
-			set_page_hwpoison_huge_page(hpage);
 			res = dequeue_hwpoisoned_huge_page(hpage);
 			action_result(pfn, MF_MSG_FREE_HUGE,
 				      res ? MF_IGNORED : MF_DELAYED);
@@ -1137,7 +1118,7 @@ int memory_failure(unsigned long pfn, in
 				pr_err("Memory failure: %#lx: thp split failed\n",
 					pfn);
 			if (TestClearPageHWPoison(p))
-				num_poisoned_pages_sub(nr_pages);
+				num_poisoned_pages_dec();
 			put_hwpoison_page(p);
 			return -EBUSY;
 		}
@@ -1193,14 +1174,14 @@ int memory_failure(unsigned long pfn, in
 	 */
 	if (!PageHWPoison(p)) {
 		pr_err("Memory failure: %#lx: just unpoisoned\n", pfn);
-		num_poisoned_pages_sub(nr_pages);
+		num_poisoned_pages_dec();
 		unlock_page(hpage);
 		put_hwpoison_page(hpage);
 		return 0;
 	}
 	if (hwpoison_filter(p)) {
 		if (TestClearPageHWPoison(p))
-			num_poisoned_pages_sub(nr_pages);
+			num_poisoned_pages_dec();
 		unlock_page(hpage);
 		put_hwpoison_page(hpage);
 		return 0;
@@ -1219,14 +1200,6 @@ int memory_failure(unsigned long pfn, in
 		put_hwpoison_page(hpage);
 		return 0;
 	}
-	/*
-	 * Set PG_hwpoison on all pages in an error hugepage,
-	 * because containment is done in hugepage unit for now.
-	 * Since we have done TestSetPageHWPoison() for the head page with
-	 * page lock held, we can safely set PG_hwpoison bits on tail pages.
-	 */
-	if (PageHuge(p))
-		set_page_hwpoison_huge_page(hpage);
 
 	/*
 	 * It's very difficult to mess with pages currently under IO
@@ -1397,7 +1370,6 @@ int unpoison_memory(unsigned long pfn)
 	struct page *page;
 	struct page *p;
 	int freeit = 0;
-	unsigned int nr_pages;
 	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
 					DEFAULT_RATELIMIT_BURST);
 
@@ -1442,8 +1414,6 @@ int unpoison_memory(unsigned long pfn)
 		return 0;
 	}
 
-	nr_pages = 1 << compound_order(page);
-
 	if (!get_hwpoison_page(p)) {
 		/*
 		 * Since HWPoisoned hugepage should have non-zero refcount,
@@ -1473,10 +1443,8 @@ int unpoison_memory(unsigned long pfn)
 	if (TestClearPageHWPoison(page)) {
 		unpoison_pr_info("Unpoison: Software-unpoisoned page %#lx\n",
 				 pfn, &unpoison_rs);
-		num_poisoned_pages_sub(nr_pages);
+		num_poisoned_pages_dec();
 		freeit = 1;
-		if (PageHuge(page))
-			clear_page_hwpoison_huge_page(page);
 	}
 	unlock_page(page);
 
@@ -1608,14 +1576,10 @@ static int soft_offline_huge_page(struct
 			ret = -EIO;
 	} else {
 		/* overcommit hugetlb page will be freed to buddy */
-		if (PageHuge(page)) {
-			set_page_hwpoison_huge_page(hpage);
+		SetPageHWPoison(page);
+		if (PageHuge(page))
 			dequeue_hwpoisoned_huge_page(hpage);
-			num_poisoned_pages_add(1 << compound_order(hpage));
-		} else {
-			SetPageHWPoison(page);
-			num_poisoned_pages_inc();
-		}
+		num_poisoned_pages_inc();
 	}
 	return ret;
 }
@@ -1731,15 +1695,12 @@ static int soft_offline_in_use_page(stru
 
 static void soft_offline_free_page(struct page *page)
 {
-	if (PageHuge(page)) {
-		struct page *hpage = compound_head(page);
+	struct page *head = compound_head(page);
 
-		set_page_hwpoison_huge_page(hpage);
-		if (!dequeue_hwpoisoned_huge_page(hpage))
-			num_poisoned_pages_add(1 << compound_order(hpage));
-	} else {
-		if (!TestSetPageHWPoison(page))
-			num_poisoned_pages_inc();
+	if (!TestSetPageHWPoison(head)) {
+		num_poisoned_pages_inc();
+		if (PageHuge(head))
+			dequeue_hwpoisoned_huge_page(head);
 	}
 }
 
_
