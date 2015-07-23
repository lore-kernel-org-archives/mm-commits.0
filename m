From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-page_isolation-make-set-unset_migratetype_isolate-file-local.patch
 removed from -mm tree
Date: Thu, 23 Jul 2015 13:37:11 -0700
Message-ID: <55b15077.8tuqC/kwnqllF3SQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbbGWUhM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jul 2015 16:37:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, iamjoonsoo.kim@lge.com, minchan@kernel.org, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_isolation: make set/unset_migratetype_isolate() file-local
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-make-set-unset_migratetype_isolate-file-local.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm, page_isolation: make set/unset_migratetype_isolate() file-local

Nowaday, set/unset_migratetype_isolate() is defined and used only in
mm/page_isolation, so let's limit the scope within the file.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |    5 -----
 mm/page_isolation.c            |    5 +++--
 2 files changed, 3 insertions(+), 7 deletions(-)

diff -puN include/linux/page-isolation.h~mm-page_isolation-make-set-unset_migratetype_isolate-file-local include/linux/page-isolation.h
--- a/include/linux/page-isolation.h~mm-page_isolation-make-set-unset_migratetype_isolate-file-local
+++ a/include/linux/page-isolation.h
@@ -65,11 +65,6 @@ undo_isolate_page_range(unsigned long st
 int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
 			bool skip_hwpoisoned_pages);
 
-/*
- * Internal functions. Changes pageblock's migrate type.
- */
-int set_migratetype_isolate(struct page *page, bool skip_hwpoisoned_pages);
-void unset_migratetype_isolate(struct page *page, unsigned migratetype);
 struct page *alloc_migrate_target(struct page *page, unsigned long private,
 				int **resultp);
 
diff -puN mm/page_isolation.c~mm-page_isolation-make-set-unset_migratetype_isolate-file-local mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_isolation-make-set-unset_migratetype_isolate-file-local
+++ a/mm/page_isolation.c
@@ -9,7 +9,8 @@
 #include <linux/hugetlb.h>
 #include "internal.h"
 
-int set_migratetype_isolate(struct page *page, bool skip_hwpoisoned_pages)
+static int set_migratetype_isolate(struct page *page,
+				bool skip_hwpoisoned_pages)
 {
 	struct zone *zone;
 	unsigned long flags, pfn;
@@ -72,7 +73,7 @@ out:
 	return ret;
 }
 
-void unset_migratetype_isolate(struct page *page, unsigned migratetype)
+static void unset_migratetype_isolate(struct page *page, unsigned migratetype)
 {
 	struct zone *zone;
 	unsigned long flags, nr_pages;
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

