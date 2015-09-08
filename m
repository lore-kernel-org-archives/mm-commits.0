From: akpm@linux-foundation.org
Subject: [merged]
 mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 11:11:50 -0700
Message-ID: <55ef24e6.MuFv7V6k3WV5YiYL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbbIHSLv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:11:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, toshi.kani@hp.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make GUP handle pfn mapping unless FOLL_GET is requested
has been removed from the -mm tree.  Its filename was
     mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: make GUP handle pfn mapping unless FOLL_GET is requested

With DAX, pfn mapping becoming more common.  The patch adjusts GUP code to
cover pfn mapping for cases when we don't need struct page to proceed.

To make it possible, let's change follow_page() code to return -EEXIST
error code if proper page table entry exists, but no corresponding struct
page.  __get_user_page() would ignore the error code and move to the next
page frame.

The immediate effect of the change is working MAP_POPULATE and mlock() on
DAX mappings.

[akpm@linux-foundation.org: fix arm64 build]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Toshi Kani <toshi.kani@hp.com>
Acked-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   60 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 50 insertions(+), 10 deletions(-)

diff -puN mm/gup.c~mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested mm/gup.c
--- a/mm/gup.c~mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested
+++ a/mm/gup.c
@@ -12,7 +12,9 @@
 #include <linux/sched.h>
 #include <linux/rwsem.h>
 #include <linux/hugetlb.h>
+
 #include <asm/pgtable.h>
+#include <asm/tlbflush.h>
 
 #include "internal.h"
 
@@ -32,6 +34,30 @@ static struct page *no_page_table(struct
 	return NULL;
 }
 
+static int follow_pfn_pte(struct vm_area_struct *vma, unsigned long address,
+		pte_t *pte, unsigned int flags)
+{
+	/* No page to get reference */
+	if (flags & FOLL_GET)
+		return -EFAULT;
+
+	if (flags & FOLL_TOUCH) {
+		pte_t entry = *pte;
+
+		if (flags & FOLL_WRITE)
+			entry = pte_mkdirty(entry);
+		entry = pte_mkyoung(entry);
+
+		if (!pte_same(*pte, entry)) {
+			set_pte_at(vma->vm_mm, address, pte, entry);
+			update_mmu_cache(vma, address, pte);
+		}
+	}
+
+	/* Proper page table entry exists, but no corresponding struct page */
+	return -EEXIST;
+}
+
 static struct page *follow_page_pte(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmd, unsigned int flags)
 {
@@ -73,10 +99,21 @@ retry:
 
 	page = vm_normal_page(vma, address, pte);
 	if (unlikely(!page)) {
-		if ((flags & FOLL_DUMP) ||
-		    !is_zero_pfn(pte_pfn(pte)))
-			goto bad_page;
-		page = pte_page(pte);
+		if (flags & FOLL_DUMP) {
+			/* Avoid special (like zero) pages in core dumps */
+			page = ERR_PTR(-EFAULT);
+			goto out;
+		}
+
+		if (is_zero_pfn(pte_pfn(pte))) {
+			page = pte_page(pte);
+		} else {
+			int ret;
+
+			ret = follow_pfn_pte(vma, address, ptep, flags);
+			page = ERR_PTR(ret);
+			goto out;
+		}
 	}
 
 	if (flags & FOLL_GET)
@@ -114,12 +151,9 @@ retry:
 			unlock_page(page);
 		}
 	}
+out:
 	pte_unmap_unlock(ptep, ptl);
 	return page;
-bad_page:
-	pte_unmap_unlock(ptep, ptl);
-	return ERR_PTR(-EFAULT);
-
 no_page:
 	pte_unmap_unlock(ptep, ptl);
 	if (!pte_none(pte))
@@ -489,9 +523,15 @@ retry:
 				goto next_page;
 			}
 			BUG();
-		}
-		if (IS_ERR(page))
+		} else if (PTR_ERR(page) == -EEXIST) {
+			/*
+			 * Proper page table entry exists, but no corresponding
+			 * struct page.
+			 */
+			goto next_page;
+		} else if (IS_ERR(page)) {
 			return i ? i : PTR_ERR(page);
+		}
 		if (pages) {
 			pages[i] = page;
 			flush_anon_page(vma, page, start);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-vma_adjust_trans_huge-adjust-file-backed-vma-too.patch
thp-decrement-refcount-on-huge-zero-page-if-it-is-split.patch
thp-fix-zap_huge_pmd-for-dax.patch
dax-dont-use-set_huge_zero_page.patch
mm-take-i_mmap_lock-in-unmap_mapping_range-for-dax.patch
mm-dax-use-i_mmap_unlock_write-in-do_cow_fault.patch
vm_flags-vm_flags_t-and-__nocast.patch
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
mm-mark-most-vm_operations_struct-const.patch
mm-make-sure-all-file-vmas-have-vm_ops-set.patch
mm-use-vma_is_anonymous-in-create_huge_pmd-and-wp_huge_pmd.patch
mm-madvise-use-vma_is_anonymous-to-check-for-anon-vma.patch

