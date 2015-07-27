From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-memory-failure-give-up-error-handling-for-non-tail-refcounted-thp.patch
 removed from -mm tree
Date: Mon, 27 Jul 2015 12:10:28 -0700
Message-ID: <55b68224.2YipCUK7F7/PFgZw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbbG0TK3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jul 2015 15:10:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, dnelson@redhat.com, hughd@google.com, kirill@shutemov.name, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: give up error handling for non-tail-refcounted thp
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-give-up-error-handling-for-non-tail-refcounted-thp.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/memory-failure: give up error handling for non-tail-refcounted thp

"non anonymous thp" case is still racy with freeing thp, which causes
panic due to put_page() for refcount-0 page.  It seems that closing up
this race might be hard (and/or not worth doing,) so let's give up the
error handling for this case.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Dean Nelson <dnelson@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failure-give-up-error-handling-for-non-tail-refcounted-thp mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failure-give-up-error-handling-for-non-tail-refcounted-thp
+++ a/mm/memory-failure.c
@@ -909,6 +909,15 @@ int get_hwpoison_page(struct page *page)
 	 * directly for tail pages.
 	 */
 	if (PageTransHuge(head)) {
+		/*
+		 * Non anonymous thp exists only in allocation/free time. We
+		 * can't handle such a case correctly, so let's give it up.
+		 * This should be better than triggering BUG_ON when kernel
+		 * tries to touch a "partially handled" page.
+		 */
+		if (!PageAnon(head))
+			return 0;
+
 		if (get_page_unless_zero(head)) {
 			if (PageTail(page))
 				get_page(page);
@@ -1134,15 +1143,6 @@ int memory_failure(unsigned long pfn, in
 	}
 
 	if (!PageHuge(p) && PageTransHuge(hpage)) {
-		if (!PageAnon(hpage)) {
-			pr_err("MCE: %#lx: non anonymous thp\n", pfn);
-			if (TestClearPageHWPoison(p))
-				atomic_long_sub(nr_pages, &num_poisoned_pages);
-			put_page(p);
-			if (p != hpage)
-				put_page(hpage);
-			return -EBUSY;
-		}
 		if (unlikely(split_huge_page(hpage))) {
 			pr_err("MCE: %#lx: thp split failed\n", pfn);
 			if (TestClearPageHWPoison(p))
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-memory-failure-check-__pg_hwpoison-separately-from-page_flags_check_at_.patch
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

