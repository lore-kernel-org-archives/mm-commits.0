From: akpm@linux-foundation.org
Subject: [merged] mm-hwpoison-introduce-num_poisoned_pages-wrappers.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:53:05 -0700
Message-ID: <55f08e21.B9tVzIr72mV/4/LQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbbIITxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, wanpeng.li@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: introduce num_poisoned_pages wrappers
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-introduce-num_poisoned_pages-wrappers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/hwpoison: introduce num_poisoned_pages wrappers

num_poisoned_pages counter will be changed outside mm/memory-failure.c by a
subsequent patch, so this patch prepares wrappers to manipulate it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Tested-by: Wanpeng Li <wanpeng.li@hotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |   23 +++++++++++++++++++++++
 mm/memory-failure.c     |   30 ++++++++++++++----------------
 2 files changed, 37 insertions(+), 16 deletions(-)

diff -puN include/linux/swapops.h~mm-hwpoison-introduce-num_poisoned_pages-wrappers include/linux/swapops.h
--- a/include/linux/swapops.h~mm-hwpoison-introduce-num_poisoned_pages-wrappers
+++ a/include/linux/swapops.h
@@ -164,6 +164,9 @@ static inline int is_write_migration_ent
 #endif
 
 #ifdef CONFIG_MEMORY_FAILURE
+
+extern atomic_long_t num_poisoned_pages __read_mostly;
+
 /*
  * Support for hardware poisoned pages
  */
@@ -177,6 +180,26 @@ static inline int is_hwpoison_entry(swp_
 {
 	return swp_type(entry) == SWP_HWPOISON;
 }
+
+static inline void num_poisoned_pages_inc(void)
+{
+	atomic_long_inc(&num_poisoned_pages);
+}
+
+static inline void num_poisoned_pages_dec(void)
+{
+	atomic_long_dec(&num_poisoned_pages);
+}
+
+static inline void num_poisoned_pages_add(long num)
+{
+	atomic_long_add(num, &num_poisoned_pages);
+}
+
+static inline void num_poisoned_pages_sub(long num)
+{
+	atomic_long_sub(num, &num_poisoned_pages);
+}
 #else
 
 static inline swp_entry_t make_hwpoison_entry(struct page *page)
diff -puN mm/memory-failure.c~mm-hwpoison-introduce-num_poisoned_pages-wrappers mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-introduce-num_poisoned_pages-wrappers
+++ a/mm/memory-failure.c
@@ -1121,7 +1121,7 @@ int memory_failure(unsigned long pfn, in
 		nr_pages = 1 << compound_order(hpage);
 	else /* normal page or thp */
 		nr_pages = 1;
-	atomic_long_add(nr_pages, &num_poisoned_pages);
+	num_poisoned_pages_add(nr_pages);
 
 	/*
 	 * We need/can do nothing about count=0 pages.
@@ -1149,7 +1149,7 @@ int memory_failure(unsigned long pfn, in
 			if (PageHWPoison(hpage)) {
 				if ((hwpoison_filter(p) && TestClearPageHWPoison(p))
 				    || (p != hpage && TestSetPageHWPoison(hpage))) {
-					atomic_long_sub(nr_pages, &num_poisoned_pages);
+					num_poisoned_pages_sub(nr_pages);
 					unlock_page(hpage);
 					return 0;
 				}
@@ -1173,7 +1173,7 @@ int memory_failure(unsigned long pfn, in
 			else
 				pr_err("MCE: %#lx: thp split failed\n", pfn);
 			if (TestClearPageHWPoison(p))
-				atomic_long_sub(nr_pages, &num_poisoned_pages);
+				num_poisoned_pages_sub(nr_pages);
 			put_hwpoison_page(p);
 			return -EBUSY;
 		}
@@ -1233,14 +1233,14 @@ int memory_failure(unsigned long pfn, in
 	 */
 	if (!PageHWPoison(p)) {
 		printk(KERN_ERR "MCE %#lx: just unpoisoned\n", pfn);
-		atomic_long_sub(nr_pages, &num_poisoned_pages);
+		num_poisoned_pages_sub(nr_pages);
 		unlock_page(hpage);
 		put_hwpoison_page(hpage);
 		return 0;
 	}
 	if (hwpoison_filter(p)) {
 		if (TestClearPageHWPoison(p))
-			atomic_long_sub(nr_pages, &num_poisoned_pages);
+			num_poisoned_pages_sub(nr_pages);
 		unlock_page(hpage);
 		put_hwpoison_page(hpage);
 		return 0;
@@ -1469,7 +1469,7 @@ int unpoison_memory(unsigned long pfn)
 			return 0;
 		}
 		if (TestClearPageHWPoison(p))
-			atomic_long_dec(&num_poisoned_pages);
+			num_poisoned_pages_dec();
 		pr_info("MCE: Software-unpoisoned free page %#lx\n", pfn);
 		return 0;
 	}
@@ -1483,7 +1483,7 @@ int unpoison_memory(unsigned long pfn)
 	 */
 	if (TestClearPageHWPoison(page)) {
 		pr_info("MCE: Software-unpoisoned page %#lx\n", pfn);
-		atomic_long_sub(nr_pages, &num_poisoned_pages);
+		num_poisoned_pages_sub(nr_pages);
 		freeit = 1;
 		if (PageHuge(page))
 			clear_page_hwpoison_huge_page(page);
@@ -1619,11 +1619,10 @@ static int soft_offline_huge_page(struct
 		if (PageHuge(page)) {
 			set_page_hwpoison_huge_page(hpage);
 			dequeue_hwpoisoned_huge_page(hpage);
-			atomic_long_add(1 << compound_order(hpage),
-					&num_poisoned_pages);
+			num_poisoned_pages_add(1 << compound_order(hpage));
 		} else {
 			SetPageHWPoison(page);
-			atomic_long_inc(&num_poisoned_pages);
+			num_poisoned_pages_inc();
 		}
 	}
 	return ret;
@@ -1662,7 +1661,7 @@ static int __soft_offline_page(struct pa
 		put_hwpoison_page(page);
 		pr_info("soft_offline: %#lx: invalidated\n", pfn);
 		SetPageHWPoison(page);
-		atomic_long_inc(&num_poisoned_pages);
+		num_poisoned_pages_inc();
 		return 0;
 	}
 
@@ -1683,7 +1682,7 @@ static int __soft_offline_page(struct pa
 					page_is_file_cache(page));
 		list_add(&page->lru, &pagelist);
 		if (!TestSetPageHWPoison(page))
-			atomic_long_inc(&num_poisoned_pages);
+			num_poisoned_pages_dec();
 		ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
 					MIGRATE_SYNC, MR_MEMORY_FAILURE);
 		if (ret) {
@@ -1699,7 +1698,7 @@ static int __soft_offline_page(struct pa
 			if (ret > 0)
 				ret = -EIO;
 			if (TestClearPageHWPoison(page))
-				atomic_long_dec(&num_poisoned_pages);
+				num_poisoned_pages_dec();
 		}
 	} else {
 		pr_info("soft offline: %#lx: isolation failed: %d, page count %d, type %lx\n",
@@ -1765,11 +1764,10 @@ int soft_offline_page(struct page *page,
 		if (PageHuge(page)) {
 			set_page_hwpoison_huge_page(hpage);
 			if (!dequeue_hwpoisoned_huge_page(hpage))
-				atomic_long_add(1 << compound_order(hpage),
-					&num_poisoned_pages);
+				num_poisoned_pages_add(1 << compound_order(hpage));
 		} else {
 			if (!TestSetPageHWPoison(page))
-				atomic_long_inc(&num_poisoned_pages);
+				num_poisoned_pages_inc();
 		}
 	}
 	return ret;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps-fix.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5.patch

