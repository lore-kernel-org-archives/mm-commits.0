From: akpm@linux-foundation.org
Subject: [merged] mm-hwpoison-adjust-for-new-thp-refcounting.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:02:53 -0800
Message-ID: <569e966d.qcaFcKX9zcNJZj/3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203AbcASUCx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:02:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: adjust for new thp refcounting
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-adjust-for-new-thp-refcounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hwpoison: adjust for new thp refcounting

Some mm-related BUG_ON()s could trigger from hwpoison code due to recent
changes in thp refcounting rule. This patch fixes them up.

In the new refcounting, we no longer use tail->_mapcount to keep tail's
refcount, and thereby we can simplify get/put_hwpoison_page().

And another change is that tail's refcount is not transferred to the raw
page during thp split (more precisely, in new rule we don't take refcount
on tail page any more.) So when we need thp split, we have to transfer the
refcount properly to the 4kB soft-offlined page before migration.

thp split code goes into core code only when precheck (total_mapcount(head)
== page_count(head) - 1) passes to avoid useless split, where we assume that
one refcount is held by the caller of thp split and the others are taken
via mapping. To meet this assumption, this patch moves thp split part in
soft_offline_page() after get_any_page().

[akpm@linux-foundation.org: remove unneeded #define, per Kirill]
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    2 -
 mm/memory-failure.c |   73 ++++++++++++------------------------------
 2 files changed, 22 insertions(+), 53 deletions(-)

diff -puN include/linux/mm.h~mm-hwpoison-adjust-for-new-thp-refcounting include/linux/mm.h
--- a/include/linux/mm.h~mm-hwpoison-adjust-for-new-thp-refcounting
+++ a/include/linux/mm.h
@@ -2217,7 +2217,7 @@ extern int memory_failure(unsigned long
 extern void memory_failure_queue(unsigned long pfn, int trapno, int flags);
 extern int unpoison_memory(unsigned long pfn);
 extern int get_hwpoison_page(struct page *page);
-extern void put_hwpoison_page(struct page *page);
+#define put_hwpoison_page(page)	put_page(page)
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
 extern void shake_page(struct page *p, int access);
diff -puN mm/memory-failure.c~mm-hwpoison-adjust-for-new-thp-refcounting mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-adjust-for-new-thp-refcounting
+++ a/mm/memory-failure.c
@@ -882,15 +882,7 @@ int get_hwpoison_page(struct page *page)
 {
 	struct page *head = compound_head(page);
 
-	if (PageHuge(head))
-		return get_page_unless_zero(head);
-
-	/*
-	 * Thp tail page has special refcounting rule (refcount of tail pages
-	 * is stored in ->_mapcount,) so we can't call get_page_unless_zero()
-	 * directly for tail pages.
-	 */
-	if (PageTransHuge(head)) {
+	if (!PageHuge(head) && PageTransHuge(head)) {
 		/*
 		 * Non anonymous thp exists only in allocation/free time. We
 		 * can't handle such a case correctly, so let's give it up.
@@ -902,41 +894,12 @@ int get_hwpoison_page(struct page *page)
 				page_to_pfn(page));
 			return 0;
 		}
-
-		if (get_page_unless_zero(head)) {
-			if (PageTail(page))
-				get_page(page);
-			return 1;
-		} else {
-			return 0;
-		}
 	}
 
-	return get_page_unless_zero(page);
+	return get_page_unless_zero(head);
 }
 EXPORT_SYMBOL_GPL(get_hwpoison_page);
 
-/**
- * put_hwpoison_page() - Put refcount for memory error handling:
- * @page:	raw error page (hit by memory error)
- */
-void put_hwpoison_page(struct page *page)
-{
-	struct page *head = compound_head(page);
-
-	if (PageHuge(head)) {
-		put_page(head);
-		return;
-	}
-
-	if (PageTransHuge(head))
-		if (page != head)
-			put_page(head);
-
-	put_page(page);
-}
-EXPORT_SYMBOL_GPL(put_hwpoison_page);
-
 /*
  * Do all that is necessary to remove user space mappings. Unmap
  * the pages and send SIGBUS to the processes if the data was dirty.
@@ -1162,6 +1125,8 @@ int memory_failure(unsigned long pfn, in
 			return -EBUSY;
 		}
 		unlock_page(hpage);
+		get_hwpoison_page(p);
+		put_hwpoison_page(hpage);
 		VM_BUG_ON_PAGE(!page_count(p), p);
 		hpage = compound_head(p);
 	}
@@ -1753,24 +1718,28 @@ int soft_offline_page(struct page *page,
 			put_hwpoison_page(page);
 		return -EBUSY;
 	}
-	if (!PageHuge(page) && PageTransHuge(hpage)) {
-		lock_page(page);
-		ret = split_huge_page(hpage);
-		unlock_page(page);
-		if (unlikely(ret)) {
-			pr_info("soft offline: %#lx: failed to split THP\n",
-				pfn);
-			if (flags & MF_COUNT_INCREASED)
-				put_hwpoison_page(page);
-			return -EBUSY;
-		}
-	}
 
 	get_online_mems();
-
 	ret = get_any_page(page, pfn, flags);
 	put_online_mems();
+
 	if (ret > 0) { /* for in-use pages */
+		if (!PageHuge(page) && PageTransHuge(hpage)) {
+			lock_page(hpage);
+			ret = split_huge_page(hpage);
+			unlock_page(hpage);
+			if (unlikely(ret || PageTransCompound(page) ||
+					!PageAnon(page))) {
+				pr_info("soft offline: %#lx: failed to split THP\n",
+					pfn);
+				if (flags & MF_COUNT_INCREASED)
+					put_hwpoison_page(hpage);
+				return -EBUSY;
+			}
+			get_hwpoison_page(page);
+			put_hwpoison_page(hpage);
+		}
+
 		if (PageHuge(page))
 			ret = soft_offline_huge_page(page, flags);
 		else
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-soft-offline-clean-up-soft_offline_page.patch
mm-soft-offline-exit-with-failure-for-non-anonymous-thp.patch

