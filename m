From: akpm@linux-foundation.org
Subject: + mm-close-pagetail-race.patch added to -mm tree
Date: Thu, 13 Feb 2014 13:55:17 -0800
Message-ID: <52fd3f45.kRKXkGF6yTsbPHXl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaBMVzT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Feb 2014 16:55:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, kirill.shutemov@linux.intel.com, cl@linux.com, aquini@redhat.com, aarcange@redhat.com, Holger.Kiehl@dwd.de, rientjes@google.com

Subject: + mm-close-pagetail-race.patch added to -mm tree
To: rientjes@google.com,Holger.Kiehl@dwd.de,aarcange@redhat.com,aquini@redhat.com,cl@linux.com,kirill.shutemov@linux.intel.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,stable@vger.kernel.org,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Thu, 13 Feb 2014 13:55:17 -0800


The patch titled
     Subject: mm: close PageTail race
has been added to the -mm tree.  Its filename is
     mm-close-pagetail-race.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-close-pagetail-race.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-close-pagetail-race.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm: close PageTail race

Since "mm, compaction: avoid isolating pinned pages", it has been possible
for page_count(page) to race with prep_compound_page() by finding
PageTail(page) set with a NULL or dangling page->first_page.

"mm, page_alloc: make first_page visible before PageTail" adds a store
memory barrier to prep_compound_page() to ensure page->first_page is set,
but nothing is preventing compound_head() from seeing a dangling head
page.

This patch uses Andrea's implementation of compound_trans_head() that
deals with such a race and makes it the default compound_head()
implementation.  This includes a read memory barrier that ensures that if
PageTail(head) is true that we return a head page that is neither NULL nor
dangling.

This is the safest way to ensure we see the head page that we are
expecting, PageTail(page) is already in the unlikely() path and the memory
barriers are unfortunately required.

Hugetlbfs is the exception, we don't enforce a store memory barrier during
init since no race is possible.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c      |    4 +-
 drivers/vfio/vfio_iommu_type1.c |    4 +-
 fs/proc/page.c                  |    5 +--
 include/linux/huge_mm.h         |   41 ------------------------------
 include/linux/mm.h              |   14 ++++++++--
 mm/ksm.c                        |    2 -
 mm/memory-failure.c             |    2 -
 mm/swap.c                       |    4 +-
 8 files changed, 22 insertions(+), 54 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~mm-close-pagetail-race drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~mm-close-pagetail-race
+++ a/drivers/block/aoe/aoecmd.c
@@ -874,7 +874,7 @@ bio_pageinc(struct bio *bio)
 		/* Non-zero page count for non-head members of
 		 * compound pages is no longer allowed by the kernel.
 		 */
-		page = compound_trans_head(bv.bv_page);
+		page = compound_head(bv.bv_page);
 		atomic_inc(&page->_count);
 	}
 }
@@ -887,7 +887,7 @@ bio_pagedec(struct bio *bio)
 	struct bvec_iter iter;
 
 	bio_for_each_segment(bv, bio, iter) {
-		page = compound_trans_head(bv.bv_page);
+		page = compound_head(bv.bv_page);
 		atomic_dec(&page->_count);
 	}
 }
diff -puN drivers/vfio/vfio_iommu_type1.c~mm-close-pagetail-race drivers/vfio/vfio_iommu_type1.c
--- a/drivers/vfio/vfio_iommu_type1.c~mm-close-pagetail-race
+++ a/drivers/vfio/vfio_iommu_type1.c
@@ -186,12 +186,12 @@ static bool is_invalid_reserved_pfn(unsi
 	if (pfn_valid(pfn)) {
 		bool reserved;
 		struct page *tail = pfn_to_page(pfn);
-		struct page *head = compound_trans_head(tail);
+		struct page *head = compound_head(tail);
 		reserved = !!(PageReserved(head));
 		if (head != tail) {
 			/*
 			 * "head" is not a dangling pointer
-			 * (compound_trans_head takes care of that)
+			 * (compound_head takes care of that)
 			 * but the hugepage may have been split
 			 * from under us (and we may not hold a
 			 * reference count on the head page so it can
diff -puN fs/proc/page.c~mm-close-pagetail-race fs/proc/page.c
--- a/fs/proc/page.c~mm-close-pagetail-race
+++ a/fs/proc/page.c
@@ -121,9 +121,8 @@ u64 stable_page_flags(struct page *page)
 	 * just checks PG_head/PG_tail, so we need to check PageLRU/PageAnon
 	 * to make sure a given page is a thp, not a non-huge compound page.
 	 */
-	else if (PageTransCompound(page) &&
-		 (PageLRU(compound_trans_head(page)) ||
-		  PageAnon(compound_trans_head(page))))
+	else if (PageTransCompound(page) && (PageLRU(compound_head(page)) ||
+					     PageAnon(compound_head(page))))
 		u |= 1 << KPF_THP;
 
 	/*
diff -puN include/linux/huge_mm.h~mm-close-pagetail-race include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-close-pagetail-race
+++ a/include/linux/huge_mm.h
@@ -157,46 +157,6 @@ static inline int hpage_nr_pages(struct
 		return HPAGE_PMD_NR;
 	return 1;
 }
-/*
- * compound_trans_head() should be used instead of compound_head(),
- * whenever the "page" passed as parameter could be the tail of a
- * transparent hugepage that could be undergoing a
- * __split_huge_page_refcount(). The page structure layout often
- * changes across releases and it makes extensive use of unions. So if
- * the page structure layout will change in a way that
- * page->first_page gets clobbered by __split_huge_page_refcount, the
- * implementation making use of smp_rmb() will be required.
- *
- * Currently we define compound_trans_head as compound_head, because
- * page->private is in the same union with page->first_page, and
- * page->private isn't clobbered. However this also means we're
- * currently leaving dirt into the page->private field of anonymous
- * pages resulting from a THP split, instead of setting page->private
- * to zero like for every other page that has PG_private not set. But
- * anonymous pages don't use page->private so this is not a problem.
- */
-#if 0
-/* This will be needed if page->private will be clobbered in split_huge_page */
-static inline struct page *compound_trans_head(struct page *page)
-{
-	if (PageTail(page)) {
-		struct page *head;
-		head = page->first_page;
-		smp_rmb();
-		/*
-		 * head may be a dangling pointer.
-		 * __split_huge_page_refcount clears PageTail before
-		 * overwriting first_page, so if PageTail is still
-		 * there it means the head pointer isn't dangling.
-		 */
-		if (PageTail(page))
-			return head;
-	}
-	return page;
-}
-#else
-#define compound_trans_head(page) compound_head(page)
-#endif
 
 extern int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				unsigned long addr, pmd_t pmd, pmd_t *pmdp);
@@ -226,7 +186,6 @@ static inline int split_huge_page(struct
 	do { } while (0)
 #define split_huge_page_pmd_mm(__mm, __address, __pmd)	\
 	do { } while (0)
-#define compound_trans_head(page) compound_head(page)
 static inline int hugepage_madvise(struct vm_area_struct *vma,
 				   unsigned long *vm_flags, int advice)
 {
diff -puN include/linux/mm.h~mm-close-pagetail-race include/linux/mm.h
--- a/include/linux/mm.h~mm-close-pagetail-race
+++ a/include/linux/mm.h
@@ -399,8 +399,18 @@ static inline void compound_unlock_irqre
 
 static inline struct page *compound_head(struct page *page)
 {
-	if (unlikely(PageTail(page)))
-		return page->first_page;
+	if (unlikely(PageTail(page))) {
+		struct page *head = page->first_page;
+
+		/*
+		 * page->first_page may be a dangling pointer to an old
+		 * compound page, so recheck that it is still a tail
+		 * page before returning.
+		 */
+		smp_rmb();
+		if (likely(PageTail(page)))
+			return head;
+	}
 	return page;
 }
 
diff -puN mm/ksm.c~mm-close-pagetail-race mm/ksm.c
--- a/mm/ksm.c~mm-close-pagetail-race
+++ a/mm/ksm.c
@@ -444,7 +444,7 @@ static void break_cow(struct rmap_item *
 static struct page *page_trans_compound_anon(struct page *page)
 {
 	if (PageTransCompound(page)) {
-		struct page *head = compound_trans_head(page);
+		struct page *head = compound_head(page);
 		/*
 		 * head may actually be splitted and freed from under
 		 * us but it's ok here.
diff -puN mm/memory-failure.c~mm-close-pagetail-race mm/memory-failure.c
--- a/mm/memory-failure.c~mm-close-pagetail-race
+++ a/mm/memory-failure.c
@@ -1651,7 +1651,7 @@ int soft_offline_page(struct page *page,
 {
 	int ret;
 	unsigned long pfn = page_to_pfn(page);
-	struct page *hpage = compound_trans_head(page);
+	struct page *hpage = compound_head(page);
 
 	if (PageHWPoison(page)) {
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
diff -puN mm/swap.c~mm-close-pagetail-race mm/swap.c
--- a/mm/swap.c~mm-close-pagetail-race
+++ a/mm/swap.c
@@ -98,7 +98,7 @@ static void put_compound_page(struct pag
 	}
 
 	/* __split_huge_page_refcount can run under us */
-	page_head = compound_trans_head(page);
+	page_head = compound_head(page);
 
 	/*
 	 * THP can not break up slab pages so avoid taking
@@ -253,7 +253,7 @@ bool __get_page_tail(struct page *page)
 	 */
 	unsigned long flags;
 	bool got;
-	struct page *page_head = compound_trans_head(page);
+	struct page *page_head = compound_head(page);
 
 	/* Ref to put_compound_page() comment. */
 	if (!__compound_tail_refcounted(page_head)) {
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-thp-fix-infinite-loop-on-memcg-oom.patch
memcg-change-oom_info_lock-to-mutex.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
mm-close-pagetail-race.patch
kthread-ensure-locality-of-task_struct-allocations.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
mm-vmscan-shrink_slab-rename-max_pass-freeable.patch
mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch
mm-compaction-avoid-isolating-pinned-pages.patch
mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch
mm-readaheadc-fix-readahead-fail-for-no-local-memory-and-limit-readahead-pages.patch
mm-utilc-add-kstrimdup.patch
cpusets-allocate-heap-only-when-required.patch
linux-next.patch

