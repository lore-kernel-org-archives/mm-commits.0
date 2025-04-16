Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C7E223323
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 21:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744838676; cv=none; b=IEkAAIEHh5Kr2u+jVgfP3Yi7DLNb6PbKFc/ysGJGKmBL4vIb+59ksV8oy0iiwy1ZuRIlTG3qt7LJth5FLqnZClhs7MBjzCkLlRnSxh/BOh0F2V9+7OkTqd+htMY4Xg+zMzeZFW5tZ9O0W8EIDyNYWr2z3633m4TAcKqs+Oeefug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744838676; c=relaxed/simple;
	bh=lycU8FX5uTS3sXEBDpAViIoHhH8GwMXBE29BPO0dQCA=;
	h=Date:To:From:Subject:Message-Id; b=a/I/GQ9hKRKkuPeWuFeQ5MH1JeQcuCUBvblGO+oOFgrJKRiRq+MwPethy8gIHF3GLmfo4ZXQpqekVp9KUB40qWiv8SHGxyM+6sEEWj72G2ctVowM7qyc7ZK7wEuCIYaG6NGhyHIKAQjJ5eW8OX1TAHajrPlZKbvcXSh+fR8Fy4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fe4FfVPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fe4FfVPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F72C4CEE4;
	Wed, 16 Apr 2025 21:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744838676;
	bh=lycU8FX5uTS3sXEBDpAViIoHhH8GwMXBE29BPO0dQCA=;
	h=Date:To:From:Subject:From;
	b=fe4FfVPsDYu58719c0rgXOBUOi4lbjvMYh8lmRYJkqGvzskGFF1zAMU3yXacYksue
	 FMuEpfTbLUufBBBajXK+KvR5rseI3SoHGnlKw1D3rurV3J+TabXkoEg47X+B9zLiGb
	 x/Xxcqv8Xz+6NtxYzk3ObrwiGaQS8KOunkt5Ovqk=
Date: Wed, 16 Apr 2025 14:24:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,mcgrof@kernel.org,hca@linux.ibm.com,gor@linux.ibm.com,david@redhat.com,dave@stgolabs.net,aneesh.kumar@kernel.org,a.manzanares@samsung.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache.patch added to mm-new branch
Message-Id: <20250416212436.13F72C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert free_page_and_swap_cache() to free_folio_and_swap_cache()
has been added to the -mm mm-new branch.  Its filename is
     mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: David Hildenbrand <david@redhat.com>
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
@@ -3648,7 +3648,7 @@ after_split:
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

mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache.patch

