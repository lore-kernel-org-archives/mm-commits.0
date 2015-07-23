From: akpm@linux-foundation.org
Subject: + mm-memory-failure-fix-race-in-counting-num_poisoned_pages.patch added to -mm tree
Date: Thu, 23 Jul 2015 12:56:07 -0700
Message-ID: <55b146d7.ORbTtXj49SlZ7SDa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbbGWT4I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jul 2015 15:56:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, dnelson@redhat.com, hughd@google.com, kirill@shutemov.name, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: fix race in counting num_poisoned_pages
has been added to the -mm tree.  Its filename is
     mm-memory-failure-fix-race-in-counting-num_poisoned_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failure-fix-race-in-counting-num_poisoned_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failure-fix-race-in-counting-num_poisoned_pages.patch

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
Subject: mm/memory-failure: fix race in counting num_poisoned_pages

When memory_failure() is called on a page which are just freed after page
migration from soft offlining, the counter num_poisoned_pages is raised
twice.  So let's fix it with using TestSetPageHWPoison.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Dean Nelson <dnelson@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failure-fix-race-in-counting-num_poisoned_pages mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failure-fix-race-in-counting-num_poisoned_pages
+++ a/mm/memory-failure.c
@@ -1671,8 +1671,8 @@ static int __soft_offline_page(struct pa
 			if (ret > 0)
 				ret = -EIO;
 		} else {
-			SetPageHWPoison(page);
-			atomic_long_inc(&num_poisoned_pages);
+			if (!TestSetPageHWPoison(page))
+				atomic_long_inc(&num_poisoned_pages);
 		}
 	} else {
 		pr_info("soft offline: %#lx: isolation failed: %d, page count %d, type %lx\n",
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-memory-failure-unlock_page-before-put_page.patch
mm-memory-failure-fix-race-in-counting-num_poisoned_pages.patch
mm-memory-failure-give-up-error-handling-for-non-tail-refcounted-thp.patch
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
mm-madvise-allow-remove-operation-for-hugetlbfs.patch
mm-page_isolation-make-set-unset_migratetype_isolate-file-local.patch
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

