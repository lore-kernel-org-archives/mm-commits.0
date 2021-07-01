Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC190C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6F6D61468
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238383AbhGABut (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237149AbhGABut (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:50:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CAA261466;
        Thu,  1 Jul 2021 01:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104099;
        bh=m6Locb0iCyr9Wynhmp1bB56/oBZ9LXuJ/1Sl8nbRdjI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yGidbD0Ub/VqMWvfP4welJWOh0CTGrv+70K+o7ZevIgUrGKjFPGFo4SL25S0tDAYD
         /DTckn1gZB/vSmX98Yjmx/BnuAUc2aClUbxtOIr1a6Ehn3S8YgjUArDPFAX1neWbmT
         ruCUNejXBjT6lidoHfoVoRfa839dYEG6q0NENM5M=
Date:   Wed, 30 Jun 2021 18:48:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, almasrymina@google.com,
        axelrasmussen@google.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, torvalds@linux-foundation.org,
        yuehaibing@huawei.com
Subject:  [patch 023/192] mm, hugetlb: fix racy resv_huge_pages
 underflow on UFFDIO_COPY
Message-ID: <20210701014819.Vm-gaPGHW%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mina Almasry <almasrymina@google.com>
Subject: mm, hugetlb: fix racy resv_huge_pages underflow on UFFDIO_COPY

On UFFDIO_COPY, if we fail to copy the page contents while holding the
hugetlb_fault_mutex, we will drop the mutex and return to the caller after
allocating a page that consumed a reservation.  In this case there may be
a fault that double consumes the reservation.  To handle this, we free the
allocated page, fix the reservations, and allocate a temporary hugetlb
page and return that to the caller.  When the caller does the copy outside
of the lock, we again check the cache, and allocate a page consuming the
reservation, and copy over the contents.

Test:
Hacked the code locally such that resv_huge_pages underflows produce
a warning and the copy_huge_page_from_user() always fails, then:

./tools/testing/selftests/vm/userfaultfd hugetlb_shared 10
        2 /tmp/kokonut_test/huge/userfaultfd_test && echo test success
./tools/testing/selftests/vm/userfaultfd hugetlb 10
	2 /tmp/kokonut_test/huge/userfaultfd_test && echo test success

Both tests succeed and produce no warnings. After the
test runs number of free/resv hugepages is correct.

[yuehaibing@huawei.com: remove set but not used variable 'vm_alloc_shared']
  Link: https://lkml.kernel.org/r/20210601141610.28332-1-yuehaibing@huawei.com
[almasrymina@google.com: fix allocation error check and copy func name]
  Link: https://lkml.kernel.org/r/20210605010626.1459873-1-almasrymina@google.com
Link: https://lkml.kernel.org/r/20210528005029.88088-1-almasrymina@google.com
Signed-off-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    4 +++
 mm/hugetlb.c            |   48 +++++++++++++++++++++++++++++-------
 mm/migrate.c            |    2 -
 mm/userfaultfd.c        |   50 --------------------------------------
 4 files changed, 45 insertions(+), 59 deletions(-)

--- a/include/linux/migrate.h~mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy
+++ a/include/linux/migrate.h
@@ -51,6 +51,7 @@ extern int migrate_huge_page_move_mappin
 				  struct page *newpage, struct page *page);
 extern int migrate_page_move_mapping(struct address_space *mapping,
 		struct page *newpage, struct page *page, int extra_count);
+extern void copy_huge_page(struct page *dst, struct page *src);
 #else
 
 static inline void putback_movable_pages(struct list_head *l) {}
@@ -77,6 +78,9 @@ static inline int migrate_huge_page_move
 	return -ENOSYS;
 }
 
+static inline void copy_huge_page(struct page *dst, struct page *src)
+{
+}
 #endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_COMPACTION
--- a/mm/hugetlb.c~mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy
+++ a/mm/hugetlb.c
@@ -30,6 +30,7 @@
 #include <linux/numa.h>
 #include <linux/llist.h>
 #include <linux/cma.h>
+#include <linux/migrate.h>
 
 #include <asm/page.h>
 #include <asm/pgalloc.h>
@@ -5076,20 +5077,17 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
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
 
-	mapping = dst_vma->vm_file->f_mapping;
-	idx = vma_hugecache_offset(h, dst_vma, dst_addr);
-
 	if (is_continue) {
 		ret = -EFAULT;
 		page = find_lock_page(mapping, idx);
@@ -5118,12 +5116,44 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 		/* fallback to copy_from_user outside mmap_lock */
 		if (unlikely(ret)) {
 			ret = -ENOENT;
+			/* Free the allocated page which may have
+			 * consumed a reservation.
+			 */
+			restore_reserve_on_error(h, dst_vma, dst_addr, page);
+			put_page(page);
+
+			/* Allocate a temporary page to hold the copied
+			 * contents.
+			 */
+			page = alloc_huge_page_vma(h, dst_vma, dst_addr);
+			if (!page) {
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
+		if (vm_shared &&
+		    hugetlbfs_pagecache_present(h, dst_vma, dst_addr)) {
+			put_page(*pagep);
+			ret = -EEXIST;
+			*pagep = NULL;
+			goto out;
+		}
+
+		page = alloc_huge_page(dst_vma, dst_addr, 0);
+		if (IS_ERR(page)) {
+			ret = -ENOMEM;
+			*pagep = NULL;
+			goto out;
+		}
+		copy_huge_page(page, *pagep);
+		put_page(*pagep);
 		*pagep = NULL;
 	}
 
--- a/mm/migrate.c~mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy
+++ a/mm/migrate.c
@@ -553,7 +553,7 @@ static void __copy_gigantic_page(struct
 	}
 }
 
-static void copy_huge_page(struct page *dst, struct page *src)
+void copy_huge_page(struct page *dst, struct page *src)
 {
 	int i;
 	int nr_pages;
--- a/mm/userfaultfd.c~mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy
+++ a/mm/userfaultfd.c
@@ -209,7 +209,6 @@ static __always_inline ssize_t __mcopy_a
 					      unsigned long len,
 					      enum mcopy_atomic_mode mode)
 {
-	int vm_alloc_shared = dst_vma->vm_flags & VM_SHARED;
 	int vm_shared = dst_vma->vm_flags & VM_SHARED;
 	ssize_t err;
 	pte_t *dst_pte;
@@ -308,7 +307,6 @@ retry:
 
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		i_mmap_unlock_read(mapping);
-		vm_alloc_shared = vm_shared;
 
 		cond_resched();
 
@@ -346,54 +344,8 @@ retry:
 out_unlock:
 	mmap_read_unlock(dst_mm);
 out:
-	if (page) {
-		/*
-		 * We encountered an error and are about to free a newly
-		 * allocated huge page.
-		 *
-		 * Reservation handling is very subtle, and is different for
-		 * private and shared mappings.  See the routine
-		 * restore_reserve_on_error for details.  Unfortunately, we
-		 * can not call restore_reserve_on_error now as it would
-		 * require holding mmap_lock.
-		 *
-		 * If a reservation for the page existed in the reservation
-		 * map of a private mapping, the map was modified to indicate
-		 * the reservation was consumed when the page was allocated.
-		 * We clear the HPageRestoreReserve flag now so that the global
-		 * reserve count will not be incremented in free_huge_page.
-		 * The reservation map will still indicate the reservation
-		 * was consumed and possibly prevent later page allocation.
-		 * This is better than leaking a global reservation.  If no
-		 * reservation existed, it is still safe to clear
-		 * HPageRestoreReserve as no adjustments to reservation counts
-		 * were made during allocation.
-		 *
-		 * The reservation map for shared mappings indicates which
-		 * pages have reservations.  When a huge page is allocated
-		 * for an address with a reservation, no change is made to
-		 * the reserve map.  In this case HPageRestoreReserve will be
-		 * set to indicate that the global reservation count should be
-		 * incremented when the page is freed.  This is the desired
-		 * behavior.  However, when a huge page is allocated for an
-		 * address without a reservation a reservation entry is added
-		 * to the reservation map, and HPageRestoreReserve will not be
-		 * set. When the page is freed, the global reserve count will
-		 * NOT be incremented and it will appear as though we have
-		 * leaked reserved page.  In this case, set HPageRestoreReserve
-		 * so that the global reserve count will be incremented to
-		 * match the reservation map entry which was created.
-		 *
-		 * Note that vm_alloc_shared is based on the flags of the vma
-		 * for which the page was originally allocated.  dst_vma could
-		 * be different or NULL on error.
-		 */
-		if (vm_alloc_shared)
-			SetHPageRestoreReserve(page);
-		else
-			ClearHPageRestoreReserve(page);
+	if (page)
 		put_page(page);
-	}
 	BUG_ON(copied < 0);
 	BUG_ON(err > 0);
 	BUG_ON(!copied && !err);
_
