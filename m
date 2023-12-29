Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5006A14006
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PELNz0pI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBA4C433C9;
	Fri, 29 Dec 2023 20:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880110;
	bh=yIcdwbZoxy/8rXMxiaGHeYrzzyWyZhNI7LsBu92YTqs=;
	h=Date:To:From:Subject:From;
	b=PELNz0pIF9homLmdxbBwxoedQkgD7g4svtYSt5NeEcmgHp9b24Jz3QzRUuHgIpyOk
	 BBiYfi//4FPZdXTtZTjI9yDHC1lbEI4FboMpxrjL/Z8FJ+ocL74H+UEiNsWBxwDbiM
	 XZEhRHehDo96u/WxK5yXAww5deB/1CFYo+9SgFfQ=
Date: Fri, 29 Dec 2023 12:01:49 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-page_remove_rmap-folio_remove_rmap_pte.patch removed from -mm tree
Message-Id: <20231229200150.1CBA4C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: page_remove_rmap() -> folio_remove_rmap_pte()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-page_remove_rmap-folio_remove_rmap_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/khugepaged: page_remove_rmap() -> folio_remove_rmap_pte()
Date: Wed, 20 Dec 2023 23:44:50 +0100

Let's convert __collapse_huge_page_copy_succeeded() and
collapse_pte_mapped_thp().  While at it, perform some more folio
conversion in __collapse_huge_page_copy_succeeded().

We can get rid of release_pte_page().

Link: https://lkml.kernel.org/r/20231220224504.646757-27-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-page_remove_rmap-folio_remove_rmap_pte
+++ a/mm/khugepaged.c
@@ -494,11 +494,6 @@ static void release_pte_folio(struct fol
 	folio_putback_lru(folio);
 }
 
-static void release_pte_page(struct page *page)
-{
-	release_pte_folio(page_folio(page));
-}
-
 static void release_pte_pages(pte_t *pte, pte_t *_pte,
 		struct list_head *compound_pagelist)
 {
@@ -687,6 +682,7 @@ static void __collapse_huge_page_copy_su
 						spinlock_t *ptl,
 						struct list_head *compound_pagelist)
 {
+	struct folio *src_folio;
 	struct page *src_page;
 	struct page *tmp;
 	pte_t *_pte;
@@ -708,16 +704,17 @@ static void __collapse_huge_page_copy_su
 			}
 		} else {
 			src_page = pte_page(pteval);
-			if (!PageCompound(src_page))
-				release_pte_page(src_page);
+			src_folio = page_folio(src_page);
+			if (!folio_test_large(src_folio))
+				release_pte_folio(src_folio);
 			/*
 			 * ptl mostly unnecessary, but preempt has to
 			 * be disabled to update the per-cpu stats
-			 * inside page_remove_rmap().
+			 * inside folio_remove_rmap_pte().
 			 */
 			spin_lock(ptl);
 			ptep_clear(vma->vm_mm, address, _pte);
-			page_remove_rmap(src_page, vma, false);
+			folio_remove_rmap_pte(src_folio, src_page, vma);
 			spin_unlock(ptl);
 			free_page_and_swap_cache(src_page);
 		}
@@ -1625,7 +1622,7 @@ int collapse_pte_mapped_thp(struct mm_st
 		 * PTE dirty? Shmem page is already dirty; file is read-only.
 		 */
 		ptep_clear(mm, addr, pte);
-		page_remove_rmap(page, vma, false);
+		folio_remove_rmap_pte(folio, page, vma);
 		nr_ptes++;
 	}
 
_

Patches currently in -mm which might be from david@redhat.com are


