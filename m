Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE2F51007
	for <mm-commits@vger.kernel.org>; Thu, 11 Jan 2024 20:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bad/MOJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6631FC433C7;
	Thu, 11 Jan 2024 20:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705005164;
	bh=NWY243hdhqpCkZSCgzaCthhY77qcfk/n7g3hnnYZ0ic=;
	h=Date:To:From:Subject:From;
	b=Bad/MOJRS6Jrh6p+6FBdvA4KqOpl5crhi/ZUKfT/cOzDEXOBQl6kmrWI+yswlAFwU
	 1wLnWQt51Q1gg84BoLGZxYIRON2obTxWXxFDeL1svWzjCTzWXYRbRAPGoM3+/+slfM
	 Gl0X7/bePf2HOkQZGYy9ma7F0AHIgxDcxC4hkA0A=
Date: Thu, 11 Jan 2024 12:32:43 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-mm_counter_file-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20240111203244.6631FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert mm_counter_file() to take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-mm_counter_file-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-mm_counter_file-to-take-a-folio.patch

This patch will later appear in the mm-unstable branch at
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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: convert mm_counter_file() to take a folio
Date: Thu, 11 Jan 2024 15:24:29 +0000

Now all callers of mm_counter_file() have a folio, convert
mm_counter_file() to take a folio.  Saves a call to compound_head() hidden
inside PageSwapBacked().

Link: https://lkml.kernel.org/r/20240111152429.3374566-11-willy@infradead.org
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    8 ++++----
 kernel/events/uprobes.c |    2 +-
 mm/huge_memory.c        |    4 ++--
 mm/khugepaged.c         |    4 ++--
 mm/memory.c             |   10 +++++-----
 mm/rmap.c               |    2 +-
 6 files changed, 15 insertions(+), 15 deletions(-)

--- a/include/linux/mm.h~mm-convert-mm_counter_file-to-take-a-folio
+++ a/include/linux/mm.h
@@ -2595,10 +2595,10 @@ static inline void dec_mm_counter(struct
 	mm_trace_rss_stat(mm, member);
 }
 
-/* Optimized variant when page is already known not to be PageAnon */
-static inline int mm_counter_file(struct page *page)
+/* Optimized variant when folio is already known not to be anon */
+static inline int mm_counter_file(struct folio *folio)
 {
-	if (PageSwapBacked(page))
+	if (folio_test_swapbacked(folio))
 		return MM_SHMEMPAGES;
 	return MM_FILEPAGES;
 }
@@ -2607,7 +2607,7 @@ static inline int mm_counter(struct foli
 {
 	if (folio_test_anon(folio))
 		return MM_ANONPAGES;
-	return mm_counter_file(&folio->page);
+	return mm_counter_file(folio);
 }
 
 static inline unsigned long get_mm_rss(struct mm_struct *mm)
--- a/kernel/events/uprobes.c~mm-convert-mm_counter_file-to-take-a-folio
+++ a/kernel/events/uprobes.c
@@ -188,7 +188,7 @@ static int __replace_page(struct vm_area
 		dec_mm_counter(mm, MM_ANONPAGES);
 
 	if (!folio_test_anon(old_folio)) {
-		dec_mm_counter(mm, mm_counter_file(old_page));
+		dec_mm_counter(mm, mm_counter_file(old_folio));
 		inc_mm_counter(mm, MM_ANONPAGES);
 	}
 
--- a/mm/huge_memory.c~mm-convert-mm_counter_file-to-take-a-folio
+++ a/mm/huge_memory.c
@@ -1921,7 +1921,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		} else {
 			if (arch_needs_pgtable_deposit())
 				zap_deposited_table(tlb->mm, pmd);
-			add_mm_counter(tlb->mm, mm_counter_file(&folio->page),
+			add_mm_counter(tlb->mm, mm_counter_file(folio),
 				       -HPAGE_PMD_NR);
 		}
 
@@ -2446,7 +2446,7 @@ static void __split_huge_pmd_locked(stru
 			folio_remove_rmap_pmd(folio, page, vma);
 			folio_put(folio);
 		}
-		add_mm_counter(mm, mm_counter_file(&folio->page), -HPAGE_PMD_NR);
+		add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
 		return;
 	}
 
--- a/mm/khugepaged.c~mm-convert-mm_counter_file-to-take-a-folio
+++ a/mm/khugepaged.c
@@ -1634,7 +1634,7 @@ int collapse_pte_mapped_thp(struct mm_st
 	/* step 3: set proper refcount and mm_counters. */
 	if (nr_ptes) {
 		folio_ref_sub(folio, nr_ptes);
-		add_mm_counter(mm, mm_counter_file(&folio->page), -nr_ptes);
+		add_mm_counter(mm, mm_counter_file(folio), -nr_ptes);
 	}
 
 	/* step 4: remove empty page table */
@@ -1665,7 +1665,7 @@ abort:
 	if (nr_ptes) {
 		flush_tlb_mm(mm);
 		folio_ref_sub(folio, nr_ptes);
-		add_mm_counter(mm, mm_counter_file(&folio->page), -nr_ptes);
+		add_mm_counter(mm, mm_counter_file(folio), -nr_ptes);
 	}
 	if (start_pte)
 		pte_unmap_unlock(start_pte, ptl);
--- a/mm/memory.c~mm-convert-mm_counter_file-to-take-a-folio
+++ a/mm/memory.c
@@ -966,7 +966,7 @@ copy_present_pte(struct vm_area_struct *
 	} else if (page) {
 		folio_get(folio);
 		folio_dup_file_rmap_pte(folio, page);
-		rss[mm_counter_file(page)]++;
+		rss[mm_counter_file(folio)]++;
 	}
 
 	/*
@@ -1873,7 +1873,7 @@ static int insert_page_into_pte_locked(s
 		return -EBUSY;
 	/* Ok, finally just insert the thing.. */
 	folio_get(folio);
-	inc_mm_counter(vma->vm_mm, mm_counter_file(page));
+	inc_mm_counter(vma->vm_mm, mm_counter_file(folio));
 	folio_add_file_rmap_pte(folio, page, vma);
 	set_pte_at(vma->vm_mm, addr, pte, mk_pte(page, prot));
 	return 0;
@@ -3178,7 +3178,7 @@ static vm_fault_t wp_page_copy(struct vm
 	if (likely(vmf->pte && pte_same(ptep_get(vmf->pte), vmf->orig_pte))) {
 		if (old_folio) {
 			if (!folio_test_anon(old_folio)) {
-				dec_mm_counter(mm, mm_counter_file(&old_folio->page));
+				dec_mm_counter(mm, mm_counter_file(old_folio));
 				inc_mm_counter(mm, MM_ANONPAGES);
 			}
 		} else {
@@ -4463,7 +4463,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	if (write)
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 
-	add_mm_counter(vma->vm_mm, mm_counter_file(page), HPAGE_PMD_NR);
+	add_mm_counter(vma->vm_mm, mm_counter_file(folio), HPAGE_PMD_NR);
 	folio_add_file_rmap_pmd(folio, page, vma);
 
 	/*
@@ -4526,7 +4526,7 @@ void set_pte_range(struct vm_fault *vmf,
 		folio_add_new_anon_rmap(folio, vma, addr);
 		folio_add_lru_vma(folio, vma);
 	} else {
-		add_mm_counter(vma->vm_mm, mm_counter_file(page), nr);
+		add_mm_counter(vma->vm_mm, mm_counter_file(folio), nr);
 		folio_add_file_rmap_ptes(folio, page, nr, vma);
 	}
 	set_ptes(vma->vm_mm, addr, vmf->pte, entry, nr);
--- a/mm/rmap.c~mm-convert-mm_counter_file-to-take-a-folio
+++ a/mm/rmap.c
@@ -1903,7 +1903,7 @@ static bool try_to_unmap_one(struct foli
 			 *
 			 * See Documentation/mm/mmu_notifier.rst
 			 */
-			dec_mm_counter(mm, mm_counter_file(&folio->page));
+			dec_mm_counter(mm, mm_counter_file(folio));
 		}
 discard:
 		if (unlikely(folio_test_hugetlb(folio)))
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-use-nth_page-in-clear-copy_subpage.patch
s390-use-pfn_swap_entry_folio-in-ptep_zap_swap_entry.patch
mm-use-pfn_swap_entry_folio-in-__split_huge_pmd_locked.patch
mm-use-pfn_swap_entry_to_folio-in-zap_huge_pmd.patch
mm-use-pfn_swap_entry_folio-in-copy_nonpresent_pte.patch
mm-convert-to-should_zap_page-to-should_zap_folio.patch
mm-convert-mm_counter-to-take-a-folio.patch
mm-convert-mm_counter_file-to-take-a-folio.patch

