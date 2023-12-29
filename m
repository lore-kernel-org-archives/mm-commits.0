Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF6813FE3
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fDIJ/W6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEADC433C8;
	Fri, 29 Dec 2023 20:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880091;
	bh=H2+fwlcQN8ZWYjFAn06Z0HcvePdY4IXuwnJKCpCi4S4=;
	h=Date:To:From:Subject:From;
	b=fDIJ/W6CsPuVQ9PmNulWqgLPPqLonZ84u1A3q7qoHCDeGw47NoPwbZwaDPJvTFniH
	 o2aAxmq4UzvdRygL+pO3L/LdveEGWTFGfUJ/SvtHHcoOOJCzPSsREIWwMrQXoJIUCi
	 r+b5D6+LLvEjjIFUP7+2uRJ+LH7RKeEOQrjT9i48=
Date: Fri, 29 Dec 2023 12:01:31 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-page_add_file_rmap-folio_add_file_rmap_.patch removed from -mm tree
Message-Id: <20231229200131.CFEADC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: page_add_file_rmap() -> folio_add_file_rmap_[pte|pmd]()
has been removed from the -mm tree.  Its filename was
     mm-memory-page_add_file_rmap-folio_add_file_rmap_.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: page_add_file_rmap() -> folio_add_file_rmap_[pte|pmd]()
Date: Wed, 20 Dec 2023 23:44:32 +0100

Let's convert insert_page_into_pte_locked() and do_set_pmd().  While at
it, perform some folio conversion.

Link: https://lkml.kernel.org/r/20231220224504.646757-9-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-memory-page_add_file_rmap-folio_add_file_rmap_
+++ a/mm/memory.c
@@ -1859,12 +1859,14 @@ static int validate_page_before_insert(s
 static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
 			unsigned long addr, struct page *page, pgprot_t prot)
 {
+	struct folio *folio = page_folio(page);
+
 	if (!pte_none(ptep_get(pte)))
 		return -EBUSY;
 	/* Ok, finally just insert the thing.. */
-	get_page(page);
+	folio_get(folio);
 	inc_mm_counter(vma->vm_mm, mm_counter_file(page));
-	page_add_file_rmap(page, vma, false);
+	folio_add_file_rmap_pte(folio, page, vma);
 	set_pte_at(vma->vm_mm, addr, pte, mk_pte(page, prot));
 	return 0;
 }
@@ -4410,6 +4412,7 @@ static void deposit_prealloc_pte(struct
 
 vm_fault_t do_set_pmd(struct vm_fault *vmf, struct page *page)
 {
+	struct folio *folio = page_folio(page);
 	struct vm_area_struct *vma = vmf->vma;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
@@ -4419,8 +4422,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
 		return ret;
 
-	page = compound_head(page);
-	if (compound_order(page) != HPAGE_PMD_ORDER)
+	if (page != &folio->page || folio_order(folio) != HPAGE_PMD_ORDER)
 		return ret;
 
 	/*
@@ -4429,7 +4431,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	 * check.  This kind of THP just can be PTE mapped.  Access to
 	 * the corrupted subpage should trigger SIGBUS as expected.
 	 */
-	if (unlikely(PageHasHWPoisoned(page)))
+	if (unlikely(folio_test_has_hwpoisoned(folio)))
 		return ret;
 
 	/*
@@ -4453,7 +4455,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 
 	add_mm_counter(vma->vm_mm, mm_counter_file(page), HPAGE_PMD_NR);
-	page_add_file_rmap(page, vma, true);
+	folio_add_file_rmap_pmd(folio, page, vma);
 
 	/*
 	 * deposit and withdraw with pmd lock held
_

Patches currently in -mm which might be from david@redhat.com are


