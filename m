From: akpm@linux-foundation.org
Subject: [merged]
 zsmalloc-use-page-private-instead-of-page-first_page.patch removed from -mm tree
Date: Mon, 09 Nov 2015 11:45:24 -0800
Message-ID: <5640f7d4.tr+j9A6xSmsXwWE6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbbKITpZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:45:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, hughd@google.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, paulmck@linux.vnet.ibm.com, rientjes@google.com, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: use page->private instead of page->first_page
has been removed from the -mm tree.  Its filename was
     zsmalloc-use-page-private-instead-of-page-first_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: zsmalloc: use page->private instead of page->first_page

We are going to rework how compound_head() work. It will not use
page->first_page as we have it now.

The only other user of page->first_page beyond compound pages is
zsmalloc.

Let's use page->private instead of page->first_page here. It occupies
the same storage space.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-use-page-private-instead-of-page-first_page mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-use-page-private-instead-of-page-first_page
+++ a/mm/zsmalloc.c
@@ -16,7 +16,7 @@
  * struct page(s) to form a zspage.
  *
  * Usage of struct page fields:
- *	page->first_page: points to the first component (0-order) page
+ *	page->private: points to the first component (0-order) page
  *	page->index (union with page->freelist): offset of the first object
  *		starting in this page. For the first page, this is
  *		always 0, so we use this field (aka freelist) to point
@@ -26,8 +26,7 @@
  *
  *	For _first_ page only:
  *
- *	page->private (union with page->first_page): refers to the
- *		component page after the first page
+ *	page->private: refers to the component page after the first page
  *		If the page is first_page for huge object, it stores handle.
  *		Look at size_class->huge.
  *	page->freelist: points to the first free object in zspage.
@@ -774,7 +773,7 @@ static struct page *get_first_page(struc
 	if (is_first_page(page))
 		return page;
 	else
-		return page->first_page;
+		return (struct page *)page_private(page);
 }
 
 static struct page *get_next_page(struct page *page)
@@ -959,7 +958,7 @@ static struct page *alloc_zspage(struct
 	 * Allocate individual pages and link them together as:
 	 * 1. first page->private = first sub-page
 	 * 2. all sub-pages are linked together using page->lru
-	 * 3. each sub-page is linked to the first page using page->first_page
+	 * 3. each sub-page is linked to the first page using page->private
 	 *
 	 * For each size class, First/Head pages are linked together using
 	 * page->lru. Also, we set PG_private to identify the first page
@@ -984,7 +983,7 @@ static struct page *alloc_zspage(struct
 		if (i == 1)
 			set_page_private(first_page, (unsigned long)page);
 		if (i >= 1)
-			page->first_page = first_page;
+			set_page_private(page, (unsigned long)first_page);
 		if (i >= 2)
 			list_add(&page->lru, &prev_page->lru);
 		if (i == class->pages_per_zspage - 1)	/* last page */
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages-fix.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-proc-adjust-pss-calculation.patch
rmap-add-argument-to-charge-compound-page.patch
memcg-adjust-to-support-new-thp-refcounting.patch
mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault.patch
mm-adjust-foll_split-for-new-refcounting.patch
mm-handle-pte-mapped-tail-pages-in-gerneric-fast-gup-implementaiton.patch
thp-mlock-do-not-allow-huge-pages-in-mlocked-area.patch
khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes.patch
thp-rename-split_huge_page_pmd-to-split_huge_pmd.patch
mm-vmstats-new-thp-splitting-event.patch
mm-temporally-mark-thp-broken.patch
thp-drop-all-split_huge_page-related-code.patch
mm-drop-tail-page-refcounting.patch
futex-thp-remove-special-case-for-thp-in-get_futex_key.patch
ksm-prepare-to-new-thp-semantics.patch
mm-thp-remove-compound_lock.patch
arm64-thp-remove-infrastructure-for-handling-splitting-pmds.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch
powerpc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch
sparc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
tile-thp-remove-infrastructure-for-handling-splitting-pmds.patch
x86-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-2.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-3.patch
mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages.patch
mm-numa-skip-pte-mapped-thp-on-numa-fault.patch
thp-implement-split_huge_pmd.patch
thp-add-option-to-setup-migration-entries-during-pmd-split.patch
thp-mm-split_huge_page-caller-need-to-lock-page.patch
thp-reintroduce-split_huge_page.patch
thp-reintroduce-split_huge_page-fix-3.patch
migrate_pages-try-to-split-pages-on-qeueuing.patch
thp-introduce-deferred_split_huge_page.patch
mm-re-enable-thp.patch
thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch

