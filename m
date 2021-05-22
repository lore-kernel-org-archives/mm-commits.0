Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF67DC2B9F2
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 22:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AC1261183
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 22:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhEVWUY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 18:20:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231428AbhEVWUX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 18:20:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 695EC610C9;
        Sat, 22 May 2021 22:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621721938;
        bh=TJM4DJ2zv2SVwbGVsnvofcfs0vSGA4QWkPjuLgNTh9Q=;
        h=Date:From:To:Subject:From;
        b=Seu/ZFMvd5Yn37X16V6sOZfqlcg60t95O7w2p1zX/OcFZGE0vYLMSLdwCmhZ8oyYC
         mfnEjrM8raI57jc9OK1iQX1TwAHAjAvq+RXad5kXqLpPwnnOFRSEPNLCiO4yW7qxqz
         /fnEgMw124EFHYDosJvvtVZjdo/WxAq/gMQqprB4=
Date:   Sat, 22 May 2021 15:18:58 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, axelrasmussen@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        peterx@redhat.com
Subject:  [to-be-updated]
 mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy.patch removed from
 -mm tree
Message-ID: <20210522221858.JB1jcKnnA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: fix resv_huge_pages underflow on UFFDIO_COPY
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mina Almasry <almasrymina@google.com>
Subject: mm, hugetlb: fix resv_huge_pages underflow on UFFDIO_COPY

The userfaultfd hugetlb tests detect a resv_huge_pages underflow. This
happens when hugetlb_mcopy_atomic_pte() is called with !is_continue on
an index for which we already have a page in the cache. When this
happens, we allocate a second page, double consuming the reservation,
and then fail to insert the page into the cache and return -EEXIST.

To fix this, we first if there exists a page in the cache which already
consumed the reservation, and return -EEXIST immediately if so.

Secondly, if we fail to copy the page contents while holding the
hugetlb_fault_mutex, we will drop the mutex and return to the caller
after allocating a page that consumed a reservation. In this case there
may be a fault that double consumes the reservation. To handle this, we
free the allocated page, fix the reservations, and allocate a temporary
hugetlb page and return that to the caller. When the caller does the
copy outside of the lock, we again check the cache, and allocate a page
consuming the reservation, and copy over the contents.

Test:
Hacked the code locally such that resv_huge_pages underflows produce
a warning and the copy_huge_page_from_user() always fails, then:

./tools/testing/selftests/vm/userfaultfd hugetlb_shared 10
	2 /tmp/kokonut_test/huge/userfaultfd_test && echo test success
./tools/testing/selftests/vm/userfaultfd hugetlb 10
	2 /tmp/kokonut_test/huge/userfaultfd_test && echo test success

Both tests succeed and produce no warnings. After the test runs
number of free/resv hugepages is correct.

Link: https://lkml.kernel.org/r/20210521074433.931380-1-almasrymina@google.com
Signed-off-by: Mina Almasry <almasrymina@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 +
 mm/hugetlb.c            |  103 ++++++++++++++++++++++++++++++++++----
 mm/migrate.c            |   39 ++------------
 3 files changed, 103 insertions(+), 43 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy
+++ a/include/linux/hugetlb.h
@@ -195,6 +195,8 @@ unsigned long hugetlb_change_protection(
 bool is_hugetlb_entry_migration(pte_t pte);
 void hugetlb_unshare_all_pmds(struct vm_area_struct *vma);
 
+void hugetlb_copy_page(struct page *dst, struct page *src);
+
 #else /* !CONFIG_HUGETLB_PAGE */
 
 static inline void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
@@ -385,6 +387,8 @@ static inline vm_fault_t hugetlb_fault(s
 
 static inline void hugetlb_unshare_all_pmds(struct vm_area_struct *vma) { }
 
+static inline void hugetlb_copy_page(struct page *dst, struct page *src);
+
 #endif /* !CONFIG_HUGETLB_PAGE */
 /*
  * hugepages at page global directory. If arch support
--- a/mm/hugetlb.c~mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy
+++ a/mm/hugetlb.c
@@ -81,6 +81,45 @@ struct mutex *hugetlb_fault_mutex_table
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
 
+/*
+ * Gigantic pages are so large that we do not guarantee that page++ pointer
+ * arithmetic will work across the entire page.  We need something more
+ * specialized.
+ */
+static void __copy_gigantic_page(struct page *dst, struct page *src,
+				 int nr_pages)
+{
+	int i;
+	struct page *dst_base = dst;
+	struct page *src_base = src;
+
+	for (i = 0; i < nr_pages;) {
+		cond_resched();
+		copy_highpage(dst, src);
+
+		i++;
+		dst = mem_map_next(dst, dst_base, i);
+		src = mem_map_next(src, src_base, i);
+	}
+}
+
+void hugetlb_copy_page(struct page *dst, struct page *src)
+{
+	int i;
+	struct hstate *h = page_hstate(src);
+	int nr_pages = pages_per_huge_page(h);
+
+	if (unlikely(nr_pages > MAX_ORDER_NR_PAGES)) {
+		__copy_gigantic_page(dst, src, nr_pages);
+		return;
+	}
+
+	for (i = 0; i < nr_pages; i++) {
+		cond_resched();
+		copy_highpage(dst + i, src + i);
+	}
+}
+
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
 	if (spool->count)
@@ -4869,19 +4908,20 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 			    struct page **pagep)
 {
 	bool is_continue = (mode == MCOPY_ATOMIC_CONTINUE);
-	struct address_space *mapping;
-	pgoff_t idx;
+	struct hstate *h = hstate_vma(dst_vma);
+	struct address_space *mapping = dst_vma->vm_file->f_mapping;
+	pgoff_t idx = vma_hugecache_offset(h, dst_vma, dst_addr);
 	unsigned long size;
 	int vm_shared = dst_vma->vm_flags & VM_SHARED;
-	struct hstate *h = hstate_vma(dst_vma);
 	pte_t _dst_pte;
 	spinlock_t *ptl;
-	int ret;
+	int ret = -ENOMEM;
 	struct page *page;
 	int writable;
-
-	mapping = dst_vma->vm_file->f_mapping;
-	idx = vma_hugecache_offset(h, dst_vma, dst_addr);
+	struct mempolicy *mpol;
+	nodemask_t *nodemask;
+	gfp_t gfp_mask = htlb_alloc_mask(h);
+	int node = huge_node(dst_vma, dst_addr, gfp_mask, &mpol, &nodemask);
 
 	if (is_continue) {
 		ret = -EFAULT;
@@ -4889,7 +4929,14 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 		if (!page)
 			goto out;
 	} else if (!*pagep) {
-		ret = -ENOMEM;
+		/* If a page already exists, then it's UFFDIO_COPY for
+		 * a non-missing case. Return -EEXIST.
+		 */
+		if (hugetlbfs_pagecache_present(h, dst_vma, dst_addr)) {
+			ret = -EEXIST;
+			goto out;
+		}
+
 		page = alloc_huge_page(dst_vma, dst_addr, 0);
 		if (IS_ERR(page))
 			goto out;
@@ -4901,12 +4948,48 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 		/* fallback to copy_from_user outside mmap_lock */
 		if (unlikely(ret)) {
 			ret = -ENOENT;
+			/* Free the allocated page which may have
+			 * consumed a reservation.
+			 */
+			restore_reserve_on_error(h, dst_vma, dst_addr, page);
+			if (!HPageRestoreReserve(page)) {
+				if (unlikely(hugetlb_unreserve_pages(
+					    mapping->host, idx, idx + 1, 1)))
+					hugetlb_fix_reserve_counts(
+						mapping->host);
+			}
+			put_page(page);
+
+			/* Allocate a temporary page to hold the copied
+			 * contents.
+			 */
+			page = alloc_migrate_huge_page(h, gfp_mask, node,
+						       nodemask);
+			if (IS_ERR(page)) {
+				ret = -ENOMEM;
+				goto out;
+			}
 			*pagep = page;
-			/* don't free the page */
+			/* Set the outparam pagep and return to the caller to
+			 * copy the contents outside the lock. Don't free the
+			 * page.
+			 */
 			goto out;
 		}
 	} else {
-		page = *pagep;
+		if (hugetlbfs_pagecache_present(h, dst_vma, dst_addr)) {
+			put_page(*pagep);
+			ret = -EEXIST;
+			goto out;
+		}
+
+		page = alloc_huge_page(dst_vma, dst_addr, 0);
+		if (IS_ERR(page)) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		__copy_gigantic_page(page, *pagep, pages_per_huge_page(h));
+		put_page(*pagep);
 		*pagep = NULL;
 	}
 
--- a/mm/migrate.c~mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy
+++ a/mm/migrate.c
@@ -528,28 +528,6 @@ int migrate_huge_page_move_mapping(struc
 	return MIGRATEPAGE_SUCCESS;
 }
 
-/*
- * Gigantic pages are so large that we do not guarantee that page++ pointer
- * arithmetic will work across the entire page.  We need something more
- * specialized.
- */
-static void __copy_gigantic_page(struct page *dst, struct page *src,
-				int nr_pages)
-{
-	int i;
-	struct page *dst_base = dst;
-	struct page *src_base = src;
-
-	for (i = 0; i < nr_pages; ) {
-		cond_resched();
-		copy_highpage(dst, src);
-
-		i++;
-		dst = mem_map_next(dst, dst_base, i);
-		src = mem_map_next(src, src_base, i);
-	}
-}
-
 static void copy_huge_page(struct page *dst, struct page *src)
 {
 	int i;
@@ -557,19 +535,14 @@ static void copy_huge_page(struct page *
 
 	if (PageHuge(src)) {
 		/* hugetlbfs page */
-		struct hstate *h = page_hstate(src);
-		nr_pages = pages_per_huge_page(h);
-
-		if (unlikely(nr_pages > MAX_ORDER_NR_PAGES)) {
-			__copy_gigantic_page(dst, src, nr_pages);
-			return;
-		}
-	} else {
-		/* thp page */
-		BUG_ON(!PageTransHuge(src));
-		nr_pages = thp_nr_pages(src);
+		hugetlb_copy_page(dst, src);
+		return;
 	}
 
+	/* thp page */
+	BUG_ON(!PageTransHuge(src));
+	nr_pages = thp_nr_pages(src);
+
 	for (i = 0; i < nr_pages; i++) {
 		cond_resched();
 		copy_highpage(dst + i, src + i);
_

Patches currently in -mm which might be from almasrymina@google.com are


