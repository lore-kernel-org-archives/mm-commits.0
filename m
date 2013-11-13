From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:38:11 -0800
Message-ID: <5283e333.XI7RfIC+2Nk1K9mZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3KMUiM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, liwanp@linux.vnet.ibm.com, gong.chen@linux.intel.com, ak@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: [merged] mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,ak@linux.intel.com,gong.chen@linux.intel.com,liwanp@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:11 -0800


The patch titled
     Subject: mm/memory-failure.c: move set_migratetype_isolate() outside get_any_page()
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/memory-failure.c: move set_migratetype_isolate() outside get_any_page()

Chen Gong pointed out that set/unset_migratetype_isolate() was done in
different functions in mm/memory-failure.c, which makes the code less
readable/maintainable.  So this patch does it in soft_offline_page().

With this patch, we get to hold lock_memory_hotplug() longer but it's not
a problem because races between memory hotplug and soft offline are very
rare.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Chen, Gong <gong.chen@linux.intel.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page
+++ a/mm/memory-failure.c
@@ -1423,19 +1423,6 @@ static int __get_any_page(struct page *p
 		return 1;
 
 	/*
-	 * The lock_memory_hotplug prevents a race with memory hotplug.
-	 * This is a big hammer, a better would be nicer.
-	 */
-	lock_memory_hotplug();
-
-	/*
-	 * Isolate the page, so that it doesn't get reallocated if it
-	 * was free. This flag should be kept set until the source page
-	 * is freed and PG_hwpoison on it is set.
-	 */
-	if (get_pageblock_migratetype(p) != MIGRATE_ISOLATE)
-		set_migratetype_isolate(p, true);
-	/*
 	 * When the target page is a free hugepage, just remove it
 	 * from free hugepage list.
 	 */
@@ -1455,7 +1442,6 @@ static int __get_any_page(struct page *p
 		/* Not a free page */
 		ret = 1;
 	}
-	unlock_memory_hotplug();
 	return ret;
 }
 
@@ -1654,15 +1640,28 @@ int soft_offline_page(struct page *page,
 		}
 	}
 
+	/*
+	 * The lock_memory_hotplug prevents a race with memory hotplug.
+	 * This is a big hammer, a better would be nicer.
+	 */
+	lock_memory_hotplug();
+
+	/*
+	 * Isolate the page, so that it doesn't get reallocated if it
+	 * was free. This flag should be kept set until the source page
+	 * is freed and PG_hwpoison on it is set.
+	 */
+	if (get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
+		set_migratetype_isolate(page, true);
+
 	ret = get_any_page(page, pfn, flags);
-	if (ret < 0)
-		goto unset;
-	if (ret) { /* for in-use pages */
+	unlock_memory_hotplug();
+	if (ret > 0) { /* for in-use pages */
 		if (PageHuge(page))
 			ret = soft_offline_huge_page(page, flags);
 		else
 			ret = __soft_offline_page(page, flags);
-	} else { /* for free pages */
+	} else if (ret == 0) { /* for free pages */
 		if (PageHuge(page)) {
 			set_page_hwpoison_huge_page(hpage);
 			dequeue_hwpoisoned_huge_page(hpage);
@@ -1673,7 +1672,6 @@ int soft_offline_page(struct page *page,
 			atomic_long_inc(&num_poisoned_pages);
 		}
 	}
-unset:
 	unset_migratetype_isolate(page, MIGRATE_MOVABLE);
 	return ret;
 }
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch

