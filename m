From: akpm@linux-foundation.org
Subject: [merged] mm-rmap-use-rmap_walk-in-page_mkclean.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:13:34 -0800
Message-ID: <52e0266e.l1XRlIFkAnk09ZJ2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54603 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087AbaAVUNf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:13:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mingo@kernel.org, mgorman@suse.de, hughd@google.com, dhillf@gmail.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-rmap-use-rmap_walk-in-page_mkclean.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,dhillf@gmail.com,hughd@google.com,mgorman@suse.de,mingo@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:13:34 -0800


The patch titled
     Subject: mm/rmap: use rmap_walk() in page_mkclean()
has been removed from the -mm tree.  Its filename was
     mm-rmap-use-rmap_walk-in-page_mkclean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/rmap: use rmap_walk() in page_mkclean()

Now, we have an infrastructure in rmap_walk() to handle difference from
   variants of rmap traversing functions.

So, just use it in page_mkclean().

In this patch, I change following things.

1. remove some variants of rmap traversing functions.
    cf> page_mkclean_file
2. mechanical change to use rmap_walk() in page_mkclean().

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   51 ++++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff -puN mm/rmap.c~mm-rmap-use-rmap_walk-in-page_mkclean mm/rmap.c
--- a/mm/rmap.c~mm-rmap-use-rmap_walk-in-page_mkclean
+++ a/mm/rmap.c
@@ -812,12 +812,13 @@ int page_referenced(struct page *page,
 }
 
 static int page_mkclean_one(struct page *page, struct vm_area_struct *vma,
-			    unsigned long address)
+			    unsigned long address, void *arg)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *pte;
 	spinlock_t *ptl;
 	int ret = 0;
+	int *cleaned = arg;
 
 	pte = page_check_address(page, mm, address, &ptl, 1);
 	if (!pte)
@@ -836,44 +837,44 @@ static int page_mkclean_one(struct page
 
 	pte_unmap_unlock(pte, ptl);
 
-	if (ret)
+	if (ret) {
 		mmu_notifier_invalidate_page(mm, address);
+		(*cleaned)++;
+	}
 out:
-	return ret;
+	return SWAP_AGAIN;
 }
 
-static int page_mkclean_file(struct address_space *mapping, struct page *page)
+static bool invalid_mkclean_vma(struct vm_area_struct *vma, void *arg)
 {
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
-	struct vm_area_struct *vma;
-	int ret = 0;
+	if (vma->vm_flags & VM_SHARED)
+		return 0;
 
-	BUG_ON(PageAnon(page));
-
-	mutex_lock(&mapping->i_mmap_mutex);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
-		if (vma->vm_flags & VM_SHARED) {
-			unsigned long address = vma_address(page, vma);
-			ret += page_mkclean_one(page, vma, address);
-		}
-	}
-	mutex_unlock(&mapping->i_mmap_mutex);
-	return ret;
+	return 1;
 }
 
 int page_mkclean(struct page *page)
 {
-	int ret = 0;
+	int cleaned = 0;
+	struct address_space *mapping;
+	struct rmap_walk_control rwc = {
+		.arg = (void *)&cleaned,
+		.rmap_one = page_mkclean_one,
+		.invalid_vma = invalid_mkclean_vma,
+	};
 
 	BUG_ON(!PageLocked(page));
 
-	if (page_mapped(page)) {
-		struct address_space *mapping = page_mapping(page);
-		if (mapping)
-			ret = page_mkclean_file(mapping, page);
-	}
+	if (!page_mapped(page))
+		return 0;
+
+	mapping = page_mapping(page);
+	if (!mapping)
+		return 0;
+
+	rmap_walk(page, &rwc);
 
-	return ret;
+	return cleaned;
 }
 EXPORT_SYMBOL_GPL(page_mkclean);
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-nobootmemc-add-return-value-check-in-__alloc_memory_core_early.patch
mm-free-memblockmemory-in-free_all_bootmem.patch
mm-free-memblockmemory-in-free_all_bootmem-fix.patch

