From: akpm@linux-foundation.org
Subject: + mm-migrate-check-before-clear-pageswapcache.patch added to -mm
 tree
Date: Mon, 06 Apr 2015 12:36:20 -0700
Message-ID: <5522e034.61uz7Yc2qR84rFS7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbbDFTgV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2015 15:36:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: check-before-clear PageSwapCache
has been added to the -mm tree.  Its filename is
     mm-migrate-check-before-clear-pageswapcache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-check-before-clear-pageswapcache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-check-before-clear-pageswapcache.patch

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
Subject: mm/migrate: check-before-clear PageSwapCache

With the page flag sanitization patchset, an invalid usage of
ClearPageSwapCache() is detected in migration_page_copy(). 
migrate_page_copy() is shared by both normal and hugepage (both thp and
hugetlb) code path, so let's check PageSwapCache() and clear it if it's
set to avoid misuse of the invalid clear operation.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-migrate-check-before-clear-pageswapcache mm/migrate.c
--- a/mm/migrate.c~mm-migrate-check-before-clear-pageswapcache
+++ a/mm/migrate.c
@@ -537,7 +537,8 @@ void migrate_page_copy(struct page *newp
 	 * Please do not reorder this without considering how mm/ksm.c's
 	 * get_ksm_page() depends upon ksm_migrate_page() and PageSwapCache().
 	 */
-	ClearPageSwapCache(page);
+	if (PageSwapCache(page))
+		ClearPageSwapCache(page);
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-numa-disable-change-protection-for-vmavm_hugetlb.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch
mm-hugetlb-abort-__get_user_pages-if-current-has-been-oom-killed.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place-v3.patch
mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
mm-migrate-check-before-clear-pageswapcache.patch
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
mm-sanitize-page-mapping-for-tail-pages-v2.patch
mm-dont-call-__page_cache_release-for-hugetlb.patch
mm-hugetlb-introduce-pagehugeactive-flag.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix-fix.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

