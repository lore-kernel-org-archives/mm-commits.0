Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95048C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011138; cv=none; b=qCyYiRbnPkQFvF8CCDF58fIUgGWjHFIjf0KaK3wjlYeaCsnKX+vaH0kVRes5j8ZjNtGS/WkSPj5uHODzpislAJ++Q9xyRCbKuIgo+sMEhmcJLHR5jUIm2Ch3n9oRAnvN1Avh83mLcRfD1eFYn67LaT3pylZtEo6mr5Q11JFSVyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011138; c=relaxed/simple;
	bh=sJgnyyAsTVMspCwqcsJH936i0r1rcBHxneib74/9IB0=;
	h=Date:To:From:Subject:Message-Id; b=I7QjI4+qRlcTgV9KlfUW6dEJ3zupXzGKkGlh3r9LDLFgYzySOPVWDrioryjkgYiY3DIKd4lSA4nAZk+u4rXFocg7j9VQdHZwdXbE/wEk/3VU0M6W+9a5ocwSv8jTFa6VH83Xi1d42qzVWM7ZaNDZShEYrv6G1bPJDbtoLpA3yQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DC9tSwq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DC9tSwq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BED6C4CEE4;
	Mon, 12 May 2025 00:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011138;
	bh=sJgnyyAsTVMspCwqcsJH936i0r1rcBHxneib74/9IB0=;
	h=Date:To:From:Subject:From;
	b=DC9tSwq+/R+sFo3tMhg8blmNw4heEH/+5eR3XfEUym6LO2JtILgzYO7wi85EMpJze
	 4Afwhc0nRoUUjxWzrdz7gPfXtM9vTrnvtCmtxhzjQHWSs/4iKASBxht0GwPaw5Ft3k
	 SBZPRCa1aJ7AVtZRVUeVmk/VsuAhDSq38Mee8R+A=
Date: Sun, 11 May 2025 17:52:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,mcgrof@kernel.org,hca@linux.ibm.com,gor@linux.ibm.com,david@redhat.com,dave@stgolabs.net,aneesh.kumar@kernel.org,a.manzanares@samsung.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache.patch removed from -mm tree
Message-Id: <20250512005218.6BED6C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert free_page_and_swap_cache() to free_folio_and_swap_cache()
has been removed from the -mm tree.  Its filename was
     mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Fan Ni <fan.ni@samsung.com>
Subject: mm: convert free_page_and_swap_cache() to free_folio_and_swap_cache()
Date: Wed, 16 Apr 2025 13:12:15 -0700

free_page_and_swap_cache() takes a struct page pointer as input parameter,
but it will immediately convert it to folio and all operations following
within use folio instead of page.  It makes more sense to pass in folio
directly.

Convert free_page_and_swap_cache() to free_folio_and_swap_cache() to
consume folio directly.

Link: https://lkml.kernel.org/r/20250416201720.41678-1-nifan.cxl@gmail.com
Signed-off-by: Fan Ni <fan.ni@samsung.com>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/tlb.h |    4 ++--
 include/linux/swap.h        |    8 +++-----
 mm/huge_memory.c            |    2 +-
 mm/khugepaged.c             |    2 +-
 mm/swap_state.c             |    8 +++-----
 5 files changed, 10 insertions(+), 14 deletions(-)

--- a/arch/s390/include/asm/tlb.h~mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache
+++ a/arch/s390/include/asm/tlb.h
@@ -40,7 +40,7 @@ static inline bool __tlb_remove_folio_pa
 /*
  * Release the page cache reference for a pte removed by
  * tlb_ptep_clear_flush. In both flush modes the tlb for a page cache page
- * has already been freed, so just do free_page_and_swap_cache.
+ * has already been freed, so just do free_folio_and_swap_cache.
  *
  * s390 doesn't delay rmap removal.
  */
@@ -49,7 +49,7 @@ static inline bool __tlb_remove_page_siz
 {
 	VM_WARN_ON_ONCE(delay_rmap);
 
-	free_page_and_swap_cache(page);
+	free_folio_and_swap_cache(page_folio(page));
 	return false;
 }
 
--- a/include/linux/swap.h~mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache
+++ a/include/linux/swap.h
@@ -450,7 +450,7 @@ static inline unsigned long total_swapca
 }
 
 void free_swap_cache(struct folio *folio);
-void free_page_and_swap_cache(struct page *);
+void free_folio_and_swap_cache(struct folio *folio);
 void free_pages_and_swap_cache(struct encoded_page **, int);
 /* linux/mm/swapfile.c */
 extern atomic_long_t nr_swap_pages;
@@ -520,10 +520,8 @@ static inline void put_swap_device(struc
 
 #define si_swapinfo(val) \
 	do { (val)->freeswap = (val)->totalswap = 0; } while (0)
-/* only sparc can not include linux/pagemap.h in this file
- * so leave put_page and release_pages undeclared... */
-#define free_page_and_swap_cache(page) \
-	put_page(page)
+#define free_folio_and_swap_cache(folio) \
+	folio_put(folio)
 #define free_pages_and_swap_cache(pages, nr) \
 	release_pages((pages), (nr));
 
--- a/mm/huge_memory.c~mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache
+++ a/mm/huge_memory.c
@@ -3653,7 +3653,7 @@ after_split:
 		 * requires taking the lru_lock so we do the put_page
 		 * of the tail pages after the split is complete.
 		 */
-		free_page_and_swap_cache(&new_folio->page);
+		free_folio_and_swap_cache(new_folio);
 	}
 	return ret;
 }
--- a/mm/khugepaged.c~mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache
+++ a/mm/khugepaged.c
@@ -746,7 +746,7 @@ static void __collapse_huge_page_copy_su
 			ptep_clear(vma->vm_mm, address, _pte);
 			folio_remove_rmap_pte(src, src_page, vma);
 			spin_unlock(ptl);
-			free_page_and_swap_cache(src_page);
+			free_folio_and_swap_cache(src);
 		}
 	}
 
--- a/mm/swap_state.c~mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache
+++ a/mm/swap_state.c
@@ -232,13 +232,11 @@ void free_swap_cache(struct folio *folio
 }
 
 /*
- * Perform a free_page(), also freeing any swap cache associated with
- * this page if it is the last user of the page.
+ * Freeing a folio and also freeing any swap cache associated with
+ * this folio if it is the last user.
  */
-void free_page_and_swap_cache(struct page *page)
+void free_folio_and_swap_cache(struct folio *folio)
 {
-	struct folio *folio = page_folio(page);
-
 	free_swap_cache(folio);
 	if (!is_huge_zero_folio(folio))
 		folio_put(folio);
_

Patches currently in -mm which might be from fan.ni@samsung.com are

khugepaged-pass-folio-instead-of-head-page-to-trace-events.patch
mm-hugetlb-pass-folio-instead-of-page-to-unmap_ref_private.patch
mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-hugetlb-convert-use-of-struct-page-to-folio-in-__unmap_hugepage_range.patch

