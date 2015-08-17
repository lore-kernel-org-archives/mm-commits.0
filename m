From: akpm@linux-foundation.org
Subject: + mm-hwpoison-introduce-num_poisoned_pages-wrappers.patch added
 to -mm tree
Date: Mon, 17 Aug 2015 13:10:07 -0700
Message-ID: <55d23f9f.m7NTt2jDJM+zWvRy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbbHQUKI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Aug 2015 16:10:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, wanpeng.li@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: introduce num_poisoned_pages wrappers
has been added to the -mm tree.  Its filename is
     mm-hwpoison-introduce-num_poisoned_pages-wrappers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-introduce-num_poisoned_pages-wrappers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-introduce-num_poisoned_pages-wrappers.patch

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

hugetlb-make-the-function-vma_shareable-bool.patch
pagemap-check-permissions-and-capabilities-at-open-time.patch
pagemap-switch-to-the-new-format-and-do-some-cleanup.patch
pagemap-rework-hugetlb-and-thp-report.patch
pagemap-hide-physical-addresses-from-non-privileged-users.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here.patch
pagemap-update-documentation.patch
pagemap-update-documentation-fix.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add.patch
mm-hugetlb-add-region_del-to-delete-a-specific-range-of-entries.patch
mm-hugetlb-expose-hugetlb-fault-mutex-for-use-by-fallocate.patch
hugetlbfs-hugetlb_vmtruncate_list-needs-to-take-a-range-to-delete.patch
hugetlbfs-truncate_hugepages-takes-a-range-of-pages.patch
mm-hugetlb-vma_has_reserves-needs-to-handle-fallocate-hole-punch.patch
mm-hugetlb-alloc_huge_page-handle-areas-hole-punched-by-fallocate.patch
hugetlbfs-new-huge_add_to_page_cache-helper-routine.patch
hugetlbfs-add-hugetlbfs_fallocate.patch
hugetlbfs-add-hugetlbfs_fallocate-fix.patch
mm-madvise-allow-remove-operation-for-hugetlbfs.patch
mempolicy-get-rid-of-duplicated-check-for-vmavm_pfnmap-in-queue_pages_range.patch
mm-page_isolation-make-set-unset_migratetype_isolate-file-local.patch
mm-compaction-more-robust-check-for-scanners-meeting.patch
mm-compaction-simplify-handling-restart-position-in-free-pages-scanner.patch
mm-compaction-encapsulate-resetting-cached-scanner-positions.patch
mm-compaction-always-skip-compound-pages-by-order-in-migrate-scanner.patch
mm-compaction-skip-compound-pages-by-order-in-free-scanner.patch
reverted-selftests-add-hugetlbfstest.patch
selftests-vm-point-to-libhugetlbfs-for-regression-testing.patch
documentation-update-libhugetlbfs-location-and-use-for-testing.patch
mm-hwpoison-fix-fail-to-split-thp-w-refcount-held.patch
mm-hwpoison-fix-pagehwpoison-test-set-race.patch
mm-hwpoison-introduce-put_hwpoison_page-to-put-refcount-for-memory-error-handling.patch
mm-hwpoison-fix-refcount-of-thp-head-page-in-no-injection-case.patch
mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page.patch
mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page-fix.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix-2.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix-3.patch
mm-hwpoison-introduce-num_poisoned_pages-wrappers.patch
mm-hwpoison-fix-race-between-soft_offline_page-and-unpoison_memory.patch
mm-hwpoison-dont-try-to-unpoison-containment-failed-pages.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

