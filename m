From: akpm@linux-foundation.org
Subject: + mm-hwpoison-dont-try-to-unpoison-containment-failed-pages.patch added to -mm tree
Date: Mon, 17 Aug 2015 13:10:11 -0700
Message-ID: <55d23fa3.IgLuprjDCOqKAiYN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbbHQUKM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Aug 2015 16:10:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, wanpeng.li@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: don't try to unpoison containment-failed pages
has been added to the -mm tree.  Its filename is
     mm-hwpoison-dont-try-to-unpoison-containment-failed-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-dont-try-to-unpoison-containment-failed-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-dont-try-to-unpoison-containment-failed-pages.patch

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
Subject: mm/hwpoison: don't try to unpoison containment-failed pages

memory_failure() can be called at any page at any time, which means that
we can't eliminate the possibility of containment failure.  In such case
the best option is to leak the page intentionally (and never touch it
later.)

We have an unpoison function for testing, and it cannot handle such
containment-failed pages, which results in kernel panic (visible with
various calltraces.) So this patch suggests that we limit the unpoisonable
pages to properly contained pages and ignore any other ones.

Testers are recommended to keep in mind that there're un-unpoisonable pages
when writing test programs.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Tested-by: Wanpeng Li <wanpeng.li@hotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN mm/memory-failure.c~mm-hwpoison-dont-try-to-unpoison-containment-failed-pages mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-dont-try-to-unpoison-containment-failed-pages
+++ a/mm/memory-failure.c
@@ -1445,6 +1445,22 @@ int unpoison_memory(unsigned long pfn)
 		return 0;
 	}
 
+	if (page_count(page) > 1) {
+		pr_info("MCE: Someone grabs the hwpoison page %#lx\n", pfn);
+		return 0;
+	}
+
+	if (page_mapped(page)) {
+		pr_info("MCE: Someone maps the hwpoison page %#lx\n", pfn);
+		return 0;
+	}
+
+	if (page_mapping(page)) {
+		pr_info("MCE: the hwpoison page has non-NULL mapping %#lx\n",
+			pfn);
+		return 0;
+	}
+
 	/*
 	 * unpoison_memory() can encounter thp only when the thp is being
 	 * worked by memory_failure() and the page lock is not held yet.
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

