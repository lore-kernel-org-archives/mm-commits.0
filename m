Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B1A6C47080
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 00:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6752611CB
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 00:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbhFAAjy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 20:39:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232320AbhFAAjy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 20:39:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B85AB6100A;
        Tue,  1 Jun 2021 00:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622507892;
        bh=v5OyQebw4ui3gaYxZZqqNKNEGPArXaexCF4IqLsdqn0=;
        h=Date:From:To:Subject:From;
        b=wCMP1DKxGua+EfHpIvWXmlNkwD6iWTmc3nZIuVGNiqlnXYV5dvnwrlq5yq9/wKo/+
         9vsfDD/jhnrxnKdWMCEIW4lTyftG+pZRZBz8tnyxYw9Nd7G8tmqRT3zWfs2Ud+WTWh
         6T7x7CgLE9brJhjCUbm2ERvkhbCjMR5ucax/5jz8=
Date:   Mon, 31 May 2021 17:38:12 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, axelrasmussen@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        peterx@redhat.com
Subject:  +
 mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy.patch added to
 -mm tree
Message-ID: <20210601003812.NKdOTadQe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: fix racy resv_huge_pages underflow on UFFDIO_COPY
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: https://lkml.kernel.org/r/20210528005029.88088-1-almasrymina@google.com
Signed-off-by: Mina Almasry <almasrymina@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    4 +++
 mm/hugetlb.c            |   48 ++++++++++++++++++++++++++++++--------
 mm/migrate.c            |    4 +--
 mm/userfaultfd.c        |   48 --------------------------------------
 4 files changed, 46 insertions(+), 58 deletions(-)

--- a/include/linux/migrate.h~mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy
+++ a/include/linux/migrate.h
@@ -51,6 +51,7 @@ extern int migrate_huge_page_move_mappin
 				  struct page *newpage, struct page *page);
 extern int migrate_page_move_mapping(struct address_space *mapping,
 		struct page *newpage, struct page *page, int extra_count);
+extern void migrate_copy_huge_page(struct page *dst, struct page *src);
 #else
 
 static inline void putback_movable_pages(struct list_head *l) {}
@@ -77,6 +78,9 @@ static inline int migrate_huge_page_move
 	return -ENOSYS;
 }
 
+static inline void migrate_copy_huge_page(struct page *dst, struct page *src)
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
@@ -5007,20 +5008,17 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
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
@@ -5049,12 +5047,44 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
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
+		migrate_copy_huge_page(page, *pagep);
+		put_page(*pagep);
 		*pagep = NULL;
 	}
 
--- a/mm/migrate.c~mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy
+++ a/mm/migrate.c
@@ -557,7 +557,7 @@ static void __copy_gigantic_page(struct
 	}
 }
 
-static void copy_huge_page(struct page *dst, struct page *src)
+void migrate_copy_huge_page(struct page *dst, struct page *src)
 {
 	int i;
 	int nr_pages;
@@ -662,7 +662,7 @@ EXPORT_SYMBOL(migrate_page_states);
 void migrate_page_copy(struct page *newpage, struct page *page)
 {
 	if (PageHuge(page) || PageTransHuge(page))
-		copy_huge_page(newpage, page);
+		migrate_copy_huge_page(newpage, page);
 	else
 		copy_highpage(newpage, page);
 
--- a/mm/userfaultfd.c~mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy
+++ a/mm/userfaultfd.c
@@ -346,54 +346,8 @@ retry:
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

Patches currently in -mm which might be from almasrymina@google.com are

mm-hugetlb-fix-simple-resv_huge_pages-underflow-on-uffdio_copy.patch
mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy.patch

