Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E03C11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BE1261D19
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhF2Cpp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:45:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhF2Cpp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:45:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F116361D1D;
        Tue, 29 Jun 2021 02:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934598;
        bh=Z98xaUISPW2IieLzTQVbQin3C2TDqwm/VTCA/QrhC/A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=haWv7+DuuzRjkyZ11vdS1CssgklobGtLbU5AiICZ1LgV6E31ef1Nu0vBECUTBVMoa
         zb/1S9SoJXDheDbVwchx3C4bNXzbt0xEbh1aAR1hGGnuQnutVlsx9vBmslQXhy11TC
         zTP9CW7v3b85Vq9xyqpeZBCFYRFXjWPV8lXNbm2A=
Date:   Mon, 28 Jun 2021 19:43:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de,
        songmuchun@bytedance.com, tony.luck@intel.com,
        torvalds@linux-foundation.org
Subject:  [patch 192/192] mm,hwpoison: make get_hwpoison_page()
 call get_any_page()
Message-ID: <20210629024317.-E02c3csR%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm,hwpoison: make get_hwpoison_page() call get_any_page()

__get_hwpoison_page() could fail to grab refcount by some race condition,
so it's helpful if we can handle it by retrying.  We already have retry
logic, so make get_hwpoison_page() call get_any_page() when called from
memory_failure().

As a result, get_hwpoison_page() can return negative values (i.e.  error
code), so some callers are also changed to handle error cases. 
soft_offline_page() does nothing for -EBUSY because that's enough and
users in userspace can easily handle it.  unpoison_memory() is also
unchanged because it's broken and need thorough fixes (will be done
later).

Link: https://lkml.kernel.org/r/20210603233632.2964832-3-nao.horiguchi@gmail.com
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c        |    2 
 mm/memory-failure.c |  194 +++++++++++++++++++++++-------------------
 2 files changed, 111 insertions(+), 85 deletions(-)

--- a/mm/hugetlb.c~mmhwpoison-make-get_hwpoison_page-call-get_any_page
+++ a/mm/hugetlb.c
@@ -5938,6 +5938,8 @@ int get_hwpoison_huge_page(struct page *
 		*hugetlb = true;
 		if (HPageFreed(page) || HPageMigratable(page))
 			ret = get_page_unless_zero(page);
+		else
+			ret = -EBUSY;
 	}
 	spin_unlock_irq(&hugetlb_lock);
 	return ret;
--- a/mm/memory-failure.c~mmhwpoison-make-get_hwpoison_page-call-get_any_page
+++ a/mm/memory-failure.c
@@ -1117,13 +1117,6 @@ static inline bool HWPoisonHandlable(str
 	return PageLRU(page) || __PageMovable(page);
 }
 
-/**
- * __get_hwpoison_page() - Get refcount for memory error handling:
- * @page:	raw error page (hit by memory error)
- *
- * Return: return 0 if failed to grab the refcount, otherwise true (some
- * non-zero value.)
- */
 static int __get_hwpoison_page(struct page *page)
 {
 	struct page *head = compound_head(page);
@@ -1168,15 +1161,6 @@ static int __get_hwpoison_page(struct pa
 	return 0;
 }
 
-/*
- * Safely get reference count of an arbitrary page.
- *
- * Returns 0 for a free page, 1 for an in-use page,
- * -EIO for a page-type we cannot handle and -EBUSY if we raced with an
- * allocation.
- * We only incremented refcount in case the page was already in-use and it
- * is a known type we can handle.
- */
 static int get_any_page(struct page *p, unsigned long flags)
 {
 	int ret = 0, pass = 0;
@@ -1186,50 +1170,77 @@ static int get_any_page(struct page *p,
 		count_increased = true;
 
 try_again:
-	if (!count_increased && !__get_hwpoison_page(p)) {
-		if (page_count(p)) {
-			/* We raced with an allocation, retry. */
-			if (pass++ < 3)
-				goto try_again;
-			ret = -EBUSY;
-		} else if (!PageHuge(p) && !is_free_buddy_page(p)) {
-			/* We raced with put_page, retry. */
+	if (!count_increased) {
+		ret = __get_hwpoison_page(p);
+		if (!ret) {
+			if (page_count(p)) {
+				/* We raced with an allocation, retry. */
+				if (pass++ < 3)
+					goto try_again;
+				ret = -EBUSY;
+			} else if (!PageHuge(p) && !is_free_buddy_page(p)) {
+				/* We raced with put_page, retry. */
+				if (pass++ < 3)
+					goto try_again;
+				ret = -EIO;
+			}
+			goto out;
+		} else if (ret == -EBUSY) {
+			/* We raced with freeing huge page to buddy, retry. */
 			if (pass++ < 3)
 				goto try_again;
-			ret = -EIO;
+			goto out;
 		}
+	}
+
+	if (PageHuge(p) || HWPoisonHandlable(p)) {
+		ret = 1;
 	} else {
-		if (PageHuge(p) || HWPoisonHandlable(p)) {
-			ret = 1;
-		} else {
-			/*
-			 * A page we cannot handle. Check whether we can turn
-			 * it into something we can handle.
-			 */
-			if (pass++ < 3) {
-				put_page(p);
-				shake_page(p, 1);
-				count_increased = false;
-				goto try_again;
-			}
+		/*
+		 * A page we cannot handle. Check whether we can turn
+		 * it into something we can handle.
+		 */
+		if (pass++ < 3) {
 			put_page(p);
-			ret = -EIO;
+			shake_page(p, 1);
+			count_increased = false;
+			goto try_again;
 		}
+		put_page(p);
+		ret = -EIO;
 	}
-
+out:
 	return ret;
 }
 
-static int get_hwpoison_page(struct page *p, unsigned long flags,
-			     enum mf_flags ctxt)
+/**
+ * get_hwpoison_page() - Get refcount for memory error handling
+ * @p:		Raw error page (hit by memory error)
+ * @flags:	Flags controlling behavior of error handling
+ *
+ * get_hwpoison_page() takes a page refcount of an error page to handle memory
+ * error on it, after checking that the error page is in a well-defined state
+ * (defined as a page-type we can successfully handle the memor error on it,
+ * such as LRU page and hugetlb page).
+ *
+ * Memory error handling could be triggered at any time on any type of page,
+ * so it's prone to race with typical memory management lifecycle (like
+ * allocation and free).  So to avoid such races, get_hwpoison_page() takes
+ * extra care for the error page's state (as done in __get_hwpoison_page()),
+ * and has some retry logic in get_any_page().
+ *
+ * Return: 0 on failure,
+ *         1 on success for in-use pages in a well-defined state,
+ *         -EIO for pages on which we can not handle memory errors,
+ *         -EBUSY when get_hwpoison_page() has raced with page lifecycle
+ *         operations like allocation and free.
+ */
+static int get_hwpoison_page(struct page *p, unsigned long flags)
 {
 	int ret;
 
 	zone_pcp_disable(page_zone(p));
-	if (ctxt == MF_SOFT_OFFLINE)
-		ret = get_any_page(p, flags);
-	else
-		ret = __get_hwpoison_page(p);
+	ret = get_any_page(p, flags);
 	zone_pcp_enable(page_zone(p));
 
 	return ret;
@@ -1418,27 +1429,33 @@ static int memory_failure_hugetlb(unsign
 
 	num_poisoned_pages_inc();
 
-	if (!(flags & MF_COUNT_INCREASED) && !get_hwpoison_page(p, flags, 0)) {
-		/*
-		 * Check "filter hit" and "race with other subpage."
-		 */
-		lock_page(head);
-		if (PageHWPoison(head)) {
-			if ((hwpoison_filter(p) && TestClearPageHWPoison(p))
-			    || (p != head && TestSetPageHWPoison(head))) {
-				num_poisoned_pages_dec();
-				unlock_page(head);
-				return 0;
+	if (!(flags & MF_COUNT_INCREASED)) {
+		res = get_hwpoison_page(p, flags);
+		if (!res) {
+			/*
+			 * Check "filter hit" and "race with other subpage."
+			 */
+			lock_page(head);
+			if (PageHWPoison(head)) {
+				if ((hwpoison_filter(p) && TestClearPageHWPoison(p))
+				    || (p != head && TestSetPageHWPoison(head))) {
+					num_poisoned_pages_dec();
+					unlock_page(head);
+					return 0;
+				}
 			}
+			unlock_page(head);
+			res = MF_FAILED;
+			if (!dissolve_free_huge_page(p) && take_page_off_buddy(p)) {
+				page_ref_inc(p);
+				res = MF_RECOVERED;
+			}
+			action_result(pfn, MF_MSG_FREE_HUGE, res);
+			return res == MF_RECOVERED ? 0 : -EBUSY;
+		} else if (res < 0) {
+			action_result(pfn, MF_MSG_UNKNOWN, MF_IGNORED);
+			return -EBUSY;
 		}
-		unlock_page(head);
-		res = MF_FAILED;
-		if (!dissolve_free_huge_page(p) && take_page_off_buddy(p)) {
-			page_ref_inc(p);
-			res = MF_RECOVERED;
-		}
-		action_result(pfn, MF_MSG_FREE_HUGE, res);
-		return res == MF_RECOVERED ? 0 : -EBUSY;
 	}
 
 	lock_page(head);
@@ -1641,28 +1658,35 @@ try_again:
 	 * In fact it's dangerous to directly bump up page count from 0,
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
-	if (!(flags & MF_COUNT_INCREASED) && !get_hwpoison_page(p, flags, 0)) {
-		if (is_free_buddy_page(p)) {
-			if (take_page_off_buddy(p)) {
-				page_ref_inc(p);
-				res = MF_RECOVERED;
-			} else {
-				/* We lost the race, try again */
-				if (retry) {
-					ClearPageHWPoison(p);
-					num_poisoned_pages_dec();
-					retry = false;
-					goto try_again;
+	if (!(flags & MF_COUNT_INCREASED)) {
+		res = get_hwpoison_page(p, flags);
+		if (!res) {
+			if (is_free_buddy_page(p)) {
+				if (take_page_off_buddy(p)) {
+					page_ref_inc(p);
+					res = MF_RECOVERED;
+				} else {
+					/* We lost the race, try again */
+					if (retry) {
+						ClearPageHWPoison(p);
+						num_poisoned_pages_dec();
+						retry = false;
+						goto try_again;
+					}
+					res = MF_FAILED;
 				}
-				res = MF_FAILED;
+				action_result(pfn, MF_MSG_BUDDY, res);
+				res = res == MF_RECOVERED ? 0 : -EBUSY;
+			} else {
+				action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
+				res = -EBUSY;
 			}
-			action_result(pfn, MF_MSG_BUDDY, res);
-			res = res == MF_RECOVERED ? 0 : -EBUSY;
-		} else {
-			action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
+			goto unlock_mutex;
+		} else if (res < 0) {
+			action_result(pfn, MF_MSG_UNKNOWN, MF_IGNORED);
 			res = -EBUSY;
+			goto unlock_mutex;
 		}
-		goto unlock_mutex;
 	}
 
 	if (PageTransHuge(hpage)) {
@@ -1940,7 +1964,7 @@ int unpoison_memory(unsigned long pfn)
 		return 0;
 	}
 
-	if (!get_hwpoison_page(p, flags, 0)) {
+	if (!get_hwpoison_page(p, flags)) {
 		if (TestClearPageHWPoison(p))
 			num_poisoned_pages_dec();
 		unpoison_pr_info("Unpoison: Software-unpoisoned free page %#lx\n",
@@ -2156,7 +2180,7 @@ int soft_offline_page(unsigned long pfn,
 
 retry:
 	get_online_mems();
-	ret = get_hwpoison_page(page, flags, MF_SOFT_OFFLINE);
+	ret = get_hwpoison_page(page, flags);
 	put_online_mems();
 
 	if (ret > 0) {
_
