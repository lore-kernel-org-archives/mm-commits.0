From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memory-failure-split-thp-earlier-in-memory-error-handling-v2.patch
 removed from -mm tree
Date: Wed, 24 Jun 2015 16:46:00 -0700
Message-ID: <558b4138.VOl8OIj6a/WUccVW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbbFXXqB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jun 2015 19:46:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory-failure-split-thp-earlier-in-memory-error-handling-v2
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-split-thp-earlier-in-memory-error-handling-v2.patch

This patch was dropped because it was folded into mm-memory-failure-split-thp-earlier-in-memory-error-handling.patch

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm-memory-failure-split-thp-earlier-in-memory-error-handling-v2

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failure-split-thp-earlier-in-memory-error-handling-v2 mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failure-split-thp-earlier-in-memory-error-handling-v2
+++ a/mm/memory-failure.c
@@ -1129,12 +1129,12 @@ int memory_failure(unsigned long pfn, in
 
 	if (!PageHuge(p) && PageTransHuge(hpage)) {
 		if (!PageAnon(hpage)) {
-			pr_info("MCE: %#lx: non anonymous thp", pfn);
+			pr_err("MCE: %#lx: non anonymous thp\n", pfn);
 			put_page(p);
 			return -EBUSY;
 		}
 		if (unlikely(split_huge_page(hpage))) {
-			pr_info("MCE: %#lx: thp split failed", pfn);
+			pr_err("MCE: %#lx: thp split failed\n", pfn);
 			put_page(p);
 			return -EBUSY;
 		}
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hwpoison-add-comment-describing-when-to-add-new-cases.patch
mm-hwpoison-remove-obsolete-notebook-todo-list.patch
mm-memory-failure-split-thp-earlier-in-memory-error-handling.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-v2.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
mm-soft-offline-dont-free-target-page-in-successful-page-migration.patch
mm-memory-failure-me_huge_page-does-nothing-for-thp.patch
mm-hugetlb-introduce-minimum-hugepage-order.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages.patch
memory-failure-export-page_type-and-action-result.patch
memory-failure-change-type-of-action_results-param-3-to-enum.patch
tracing-add-trace-event-for-memory-failure.patch
tracing-add-trace-event-for-memory-failure-fix.patch
mm-hugetlb-document-the-reserve-map-region-tracking-routines.patch
mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-v4.patch
mm-memory-hotplug-print-the-last-vmemmap-region-at-the-end-of-hot-add-memory.patch

