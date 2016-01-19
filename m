From: akpm@linux-foundation.org
Subject: [merged] mm-soft-offline-clean-up-soft_offline_page.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:14:25 -0800
Message-ID: <569e9921.mSP8uSljIDJAwfTg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: soft-offline: clean up soft_offline_page()
has been removed from the -mm tree.  Its filename was
     mm-soft-offline-clean-up-soft_offline_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: soft-offline: clean up soft_offline_page()

soft_offline_page() has some deeply indented code, that's the sign of
demand for cleanup.  So let's do this.  No functionality change.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   78 +++++++++++++++++++++++++-----------------
 1 file changed, 47 insertions(+), 31 deletions(-)

diff -puN mm/memory-failure.c~mm-soft-offline-clean-up-soft_offline_page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-soft-offline-clean-up-soft_offline_page
+++ a/mm/memory-failure.c
@@ -1684,6 +1684,49 @@ static int __soft_offline_page(struct pa
 	return ret;
 }
 
+static int soft_offline_in_use_page(struct page *page, int flags)
+{
+	int ret;
+	struct page *hpage = compound_head(page);
+
+	if (!PageHuge(page) && PageTransHuge(hpage)) {
+		lock_page(hpage);
+		ret = split_huge_page(hpage);
+		unlock_page(hpage);
+		if (unlikely(ret || PageTransCompound(page) ||
+			     !PageAnon(page))) {
+			pr_info("soft offline: %#lx: failed to split THP\n",
+				page_to_pfn(page));
+			if (flags & MF_COUNT_INCREASED)
+				put_hwpoison_page(hpage);
+			return -EBUSY;
+		}
+		get_hwpoison_page(page);
+		put_hwpoison_page(hpage);
+	}
+
+	if (PageHuge(page))
+		ret = soft_offline_huge_page(page, flags);
+	else
+		ret = __soft_offline_page(page, flags);
+
+	return ret;
+}
+
+static void soft_offline_free_page(struct page *page)
+{
+	if (PageHuge(page)) {
+		struct page *hpage = compound_head(page);
+
+		set_page_hwpoison_huge_page(hpage);
+		if (!dequeue_hwpoisoned_huge_page(hpage))
+			num_poisoned_pages_add(1 << compound_order(hpage));
+	} else {
+		if (!TestSetPageHWPoison(page))
+			num_poisoned_pages_inc();
+	}
+}
+
 /**
  * soft_offline_page - Soft offline a page.
  * @page: page to offline
@@ -1710,7 +1753,6 @@ int soft_offline_page(struct page *page,
 {
 	int ret;
 	unsigned long pfn = page_to_pfn(page);
-	struct page *hpage = compound_head(page);
 
 	if (PageHWPoison(page)) {
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
@@ -1723,36 +1765,10 @@ int soft_offline_page(struct page *page,
 	ret = get_any_page(page, pfn, flags);
 	put_online_mems();
 
-	if (ret > 0) { /* for in-use pages */
-		if (!PageHuge(page) && PageTransHuge(hpage)) {
-			lock_page(hpage);
-			ret = split_huge_page(hpage);
-			unlock_page(hpage);
-			if (unlikely(ret || PageTransCompound(page) ||
-					!PageAnon(page))) {
-				pr_info("soft offline: %#lx: failed to split THP\n",
-					pfn);
-				if (flags & MF_COUNT_INCREASED)
-					put_hwpoison_page(hpage);
-				return -EBUSY;
-			}
-			get_hwpoison_page(page);
-			put_hwpoison_page(hpage);
-		}
+	if (ret > 0)
+		ret = soft_offline_in_use_page(page, flags);
+	else if (ret == 0)
+		soft_offline_free_page(page);
 
-		if (PageHuge(page))
-			ret = soft_offline_huge_page(page, flags);
-		else
-			ret = __soft_offline_page(page, flags);
-	} else if (ret == 0) { /* for free pages */
-		if (PageHuge(page)) {
-			set_page_hwpoison_huge_page(hpage);
-			if (!dequeue_hwpoisoned_huge_page(hpage))
-				num_poisoned_pages_add(1 << compound_order(hpage));
-		} else {
-			if (!TestSetPageHWPoison(page))
-				num_poisoned_pages_inc();
-		}
-	}
 	return ret;
 }
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are


