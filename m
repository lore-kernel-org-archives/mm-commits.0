From: akpm@linux-foundation.org
Subject: + mm-memory-failure-set-pagehwpoison-before-migrate_pages.patch
 added to -mm tree
Date: Tue, 04 Aug 2015 16:30:22 -0700
Message-ID: <55c14b0e.A5K4hHJUyCCArCqB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbbHDXaX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2015 19:30:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, dnelson@redhat.com, hughd@google.com, kirill@shutemov.name, rientjes@google.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: set PageHWPoison before migrate_pages()
has been added to the -mm tree.  Its filename is
     mm-memory-failure-set-pagehwpoison-before-migrate_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failure-set-pagehwpoison-before-migrate_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failure-set-pagehwpoison-before-migrate_pages.patch

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
Subject: mm/memory-failure: set PageHWPoison before migrate_pages()

Now page freeing code doesn't consider PageHWPoison as a bad page, so by
setting it before completing the page containment, we can prevent the
error page from being reused just after successful page migration.

I added TTU_IGNORE_HWPOISON for try_to_unmap() to make sure that the page
table entry is transformed into migration entry, not to hwpoison entry.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Dean Nelson <dnelson@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 ++++---
 mm/migrate.c        |    3 ++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failure-set-pagehwpoison-before-migrate_pages mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failure-set-pagehwpoison-before-migrate_pages
+++ a/mm/memory-failure.c
@@ -1659,6 +1659,8 @@ static int __soft_offline_page(struct pa
 		inc_zone_page_state(page, NR_ISOLATED_ANON +
 					page_is_file_cache(page));
 		list_add(&page->lru, &pagelist);
+		if (!TestSetPageHWPoison(page))
+			atomic_long_inc(&num_poisoned_pages);
 		ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
 					MIGRATE_SYNC, MR_MEMORY_FAILURE);
 		if (ret) {
@@ -1673,9 +1675,8 @@ static int __soft_offline_page(struct pa
 				pfn, ret, page->flags);
 			if (ret > 0)
 				ret = -EIO;
-		} else {
-			if (!TestSetPageHWPoison(page))
-				atomic_long_inc(&num_poisoned_pages);
+			if (TestClearPageHWPoison(page))
+				atomic_long_dec(&num_poisoned_pages);
 		}
 	} else {
 		pr_info("soft offline: %#lx: isolation failed: %d, page count %d, type %lx\n",
diff -puN mm/migrate.c~mm-memory-failure-set-pagehwpoison-before-migrate_pages mm/migrate.c
--- a/mm/migrate.c~mm-memory-failure-set-pagehwpoison-before-migrate_pages
+++ a/mm/migrate.c
@@ -880,7 +880,8 @@ static int __unmap_and_move(struct page
 	/* Establish migration ptes or remove ptes */
 	if (page_mapped(page)) {
 		try_to_unmap(page,
-			TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
+			TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS|
+			TTU_IGNORE_HWPOISON);
 		page_was_mapped = 1;
 	}
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-memory-failure-unlock_page-before-put_page.patch
mm-memory-failure-fix-race-in-counting-num_poisoned_pages.patch
mm-memory-failure-give-up-error-handling-for-non-tail-refcounted-thp.patch
mm-check-__pg_hwpoison-separately-from-page_flags_check_at_.patch
mm-memory-failure-set-pagehwpoison-before-migrate_pages.patch
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
mm-compaction-skip-compound-pages-by-order-in-free-scanner.patch
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

