From: akpm@linux-foundation.org
Subject: + mm-memory-failurec-clean-up-soft_offline_page.patch added to -mm tree
Date: Mon, 28 Jan 2013 14:38:17 -0800
Message-ID: <20130128223818.18EB81E41D6@corp2gmr1-2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:50337 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3A1WiU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 17:38:20 -0500
Received: by mail-we0-f202.google.com with SMTP id t11so214154wey.3
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 14:38:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, fengguang.wu@intel.com, jiang.liu@huawei.com, qiuxishi@huawei.com, tony.luck@intel.com


The patch titled
     Subject: mm/memory-failure.c: clean up soft_offline_page()
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-clean-up-soft_offline_page.patch

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
Subject: mm/memory-failure.c: clean up soft_offline_page()

Currently soft_offline_page() is hard to maintain because it has many
return points and goto statements.  All of this mess come from
get_any_page().  This function should only get page refcount as the name
implies, but it does some page isolating actions like SetPageHWPoison()
and dequeuing hugepage.  This patch corrects it and introduces some
internal subroutines to make soft offlining code more readable and
maintainable.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |  156 +++++++++++++++++++++++-------------------
 1 file changed, 87 insertions(+), 69 deletions(-)

diff -puN mm/memory-failure.c~mm-clean-up-soft_offline_page-re-mm-clean-up-soft_offline_page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-clean-up-soft_offline_page-re-mm-clean-up-soft_offline_page
+++ a/mm/memory-failure.c
@@ -1368,7 +1368,7 @@ static struct page *new_page(struct page
  * that is not free, and 1 for any other page type.
  * For 1 the page is returned with increased page count, otherwise not.
  */
-static int get_any_page(struct page *p, unsigned long pfn, int flags)
+static int __get_any_page(struct page *p, unsigned long pfn, int flags)
 {
 	int ret;
 
@@ -1393,11 +1393,9 @@ static int get_any_page(struct page *p, 
 	if (!get_page_unless_zero(compound_head(p))) {
 		if (PageHuge(p)) {
 			pr_info("%s: %#lx free huge page\n", __func__, pfn);
-			ret = dequeue_hwpoisoned_huge_page(compound_head(p));
+			ret = 0;
 		} else if (is_free_buddy_page(p)) {
 			pr_info("%s: %#lx free buddy page\n", __func__, pfn);
-			/* Set hwpoison bit while page is still isolated */
-			SetPageHWPoison(p);
 			ret = 0;
 		} else {
 			pr_info("%s: %#lx: unknown zero refcount page type %lx\n",
@@ -1413,23 +1411,48 @@ static int get_any_page(struct page *p, 
 	return ret;
 }
 
+static int get_any_page(struct page *page, unsigned long pfn, int flags)
+{
+	int ret = __get_any_page(page, pfn, flags);
+
+	if (ret == 1 && !PageHuge(page) && !PageLRU(page)) {
+		/*
+		 * Try to free it.
+		 */
+		put_page(page);
+		shake_page(page, 1);
+
+		/*
+		 * Did it turn free?
+		 */
+		ret = __get_any_page(page, pfn, 0);
+		if (!PageLRU(page)) {
+			pr_info("soft_offline: %#lx: unknown non LRU page type %lx\n",
+				pfn, page->flags);
+			return -EIO;
+		}
+	}
+	return ret;
+}
+
 static int soft_offline_huge_page(struct page *page, int flags)
 {
 	int ret;
 	unsigned long pfn = page_to_pfn(page);
 	struct page *hpage = compound_head(page);
 
+	/*
+	 * This double-check of PageHWPoison is to avoid the race with
+	 * memory_failure(). See also comment in __soft_offline_page().
+	 */
+	lock_page(hpage);
 	if (PageHWPoison(hpage)) {
+		unlock_page(hpage);
+		put_page(hpage);
 		pr_info("soft offline: %#lx hugepage already poisoned\n", pfn);
-		ret = -EBUSY;
-		goto out;
+		return -EBUSY;
 	}
-
-	ret = get_any_page(page, pfn, flags);
-	if (ret < 0)
-		goto out;
-	if (ret == 0)
-		goto done;
+	unlock_page(hpage);
 
 	/* Keep page count to indicate a given hugepage is isolated. */
 	ret = migrate_huge_page(hpage, new_page, MPOL_MF_MOVE_ALL, false,
@@ -1438,17 +1461,18 @@ static int soft_offline_huge_page(struct
 	if (ret) {
 		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
 			pfn, ret, page->flags);
-		goto out;
+	} else {
+		set_page_hwpoison_huge_page(hpage);
+		dequeue_hwpoisoned_huge_page(hpage);
+		atomic_long_add(1 << compound_trans_order(hpage),
+				&num_poisoned_pages);
 	}
-done:
 	/* keep elevated page count for bad page */
-	atomic_long_add(1 << compound_trans_order(hpage), &num_poisoned_pages);
-	set_page_hwpoison_huge_page(hpage);
-	dequeue_hwpoisoned_huge_page(hpage);
-out:
 	return ret;
 }
 
+static int __soft_offline_page(struct page *page, int flags);
+
 /**
  * soft_offline_page - Soft offline a page.
  * @page: page to offline
@@ -1477,62 +1501,60 @@ int soft_offline_page(struct page *page,
 	unsigned long pfn = page_to_pfn(page);
 	struct page *hpage = compound_trans_head(page);
 
-	if (PageHuge(page)) {
-		ret = soft_offline_huge_page(page, flags);
-		goto out;
+	if (PageHWPoison(page)) {
+		pr_info("soft offline: %#lx page already poisoned\n", pfn);
+		return -EBUSY;
 	}
-	if (PageTransHuge(hpage)) {
+	if (!PageHuge(page) && PageTransHuge(hpage)) {
 		if (PageAnon(hpage) && unlikely(split_huge_page(hpage))) {
 			pr_info("soft offline: %#lx: failed to split THP\n",
 				pfn);
-			ret = -EBUSY;
-			goto out;
+			return -EBUSY;
 		}
 	}
 
-	if (PageHWPoison(page)) {
-		pr_info("soft offline: %#lx page already poisoned\n", pfn);
-		ret = -EBUSY;
-		goto out;
-	}
-
 	ret = get_any_page(page, pfn, flags);
 	if (ret < 0)
-		goto out;
-	if (ret == 0)
-		goto done;
-
-	/*
-	 * Page cache page we can handle?
-	 */
-	if (!PageLRU(page)) {
-		/*
-		 * Try to free it.
-		 */
-		put_page(page);
-		shake_page(page, 1);
-
-		/*
-		 * Did it turn free?
-		 */
-		ret = get_any_page(page, pfn, 0);
-		if (ret < 0)
-			goto out;
-		if (ret == 0)
-			goto done;
-	}
-	if (!PageLRU(page)) {
-		pr_info("soft_offline: %#lx: unknown non LRU page type %lx\n",
-			pfn, page->flags);
-		ret = -EIO;
-		goto out;
+		return ret;
+	if (ret) { /* for in-use pages */
+		if (PageHuge(page))
+			ret = soft_offline_huge_page(page, flags);
+		else
+			ret = __soft_offline_page(page, flags);
+	} else { /* for free pages */
+		if (PageHuge(page)) {
+			set_page_hwpoison_huge_page(hpage);
+			dequeue_hwpoisoned_huge_page(hpage);
+			atomic_long_add(1 << compound_trans_order(hpage),
+					&num_poisoned_pages);
+		} else {
+			SetPageHWPoison(page);
+			atomic_long_inc(&num_poisoned_pages);
+		}
 	}
+	/* keep elevated page count for bad page */
+	return ret;
+}
+
+static int __soft_offline_page(struct page *page, int flags)
+{
+	int ret;
+	unsigned long pfn = page_to_pfn(page);
 
 	/*
-	 * Synchronized using the page lock with memory_failure()
+	 * Check PageHWPoison again inside page lock because PageHWPoison
+	 * is set by memory_failure() outside page lock. Note that
+	 * memory_failure() also double-checks PageHWPoison inside page lock,
+	 * so there's no race between soft_offline_page() and memory_failure().
 	 */
 	lock_page(page);
 	wait_on_page_writeback(page);
+	if (PageHWPoison(page)) {
+		unlock_page(page);
+		put_page(page);
+		pr_info("soft offline: %#lx page already poisoned\n", pfn);
+		return -EBUSY;
+	}
 	/*
 	 * Try to invalidate first. This should work for
 	 * non dirty unmapped page cache pages.
@@ -1545,9 +1567,10 @@ int soft_offline_page(struct page *page,
 	 */
 	if (ret == 1) {
 		put_page(page);
-		ret = 0;
 		pr_info("soft_offline: %#lx: invalidated\n", pfn);
-		goto done;
+		SetPageHWPoison(page);
+		atomic_long_inc(&num_poisoned_pages);
+		return 0;
 	}
 
 	/*
@@ -1575,18 +1598,13 @@ int soft_offline_page(struct page *page,
 				pfn, ret, page->flags);
 			if (ret > 0)
 				ret = -EIO;
+		} else {
+			SetPageHWPoison(page);
+			atomic_long_inc(&num_poisoned_pages);
 		}
 	} else {
 		pr_info("soft offline: %#lx: isolation failed: %d, page count %d, type %lx\n",
 			pfn, ret, page_count(page), page->flags);
 	}
-	if (ret)
-		goto out;
