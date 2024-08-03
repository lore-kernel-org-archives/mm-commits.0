Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009AF13B280
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 05:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722663218; cv=none; b=WsHDwKPyr1E2kztw1SCVGi6AkIxTmoXb9+hyY95S22HYmzAJK5nr9MP1VmizRhiAf7GHzGQ6L4xAZhagBV6ZXQJrnonL8JhKR/IV1UCgbBUyt6WqWMmjA4Rx1HxVQ9n1YkkH3ZgJA3FZ17hnvtzuq7lSBsrCwDoB+37nhkHWdn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722663218; c=relaxed/simple;
	bh=bkTr/MFrt/+48fsrubSVE1PQcHvRW4ylHljHIOQ7tNE=;
	h=Date:To:From:Subject:Message-Id; b=CCBbu1Ea/1AvPTqGaThqQ+2CziB7rmrz271dOpqwhB5ouvLlk4v4pSuptwyfJFQiE46uS5QO5PlTB4sQ1QOeskqO8ufWldMuXXKgZnFuCf0BY6e9SUC3XPQkgpEynIBmzWPhxaKJZe1+Ex95uTqk355E3Pc/4OMsSA2uVj2FyDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mVo3VTnT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mVo3VTnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE1AC116B1;
	Sat,  3 Aug 2024 05:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722663217;
	bh=bkTr/MFrt/+48fsrubSVE1PQcHvRW4ylHljHIOQ7tNE=;
	h=Date:To:From:Subject:From;
	b=mVo3VTnTg3Dil/x7gM5r+q+QRbJKTN1VoV4YMmh9GzKXQbMQaf1CR76J/gT4oaOQD
	 4gvde/sQTtpL5eXz7kfSHbcu7Pmf/vy24AzjTzDTis3A6sJNGXGcR5B4euOFxSLRcm
	 Sp4aSdO84vQlpo/ntQOWpA4VGzW3fRGPxlIGXgaM=
Date: Fri, 02 Aug 2024 22:33:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,svens@linux.ibm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagewalk-introduce-folio_walk_start-folio_walk_end.patch added to mm-unstable branch
Message-Id: <20240803053337.6DE1AC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/pagewalk: introduce folio_walk_start() + folio_walk_end()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pagewalk-introduce-folio_walk_start-folio_walk_end.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalk-introduce-folio_walk_start-folio_walk_end.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/pagewalk: introduce folio_walk_start() + folio_walk_end()
Date: Fri, 2 Aug 2024 17:55:15 +0200

We want to get rid of follow_page(), and have a more reasonable way to
just lookup a folio mapped at a certain address, perform some checks while
still under PTL, and then only conditionally grab a folio reference if
really required.

Further, we might want to get rid of some walk_page_range*() users that
really only want to temporarily lookup a single folio at a single address.

So let's add a new page table walker that does exactly that, similarly to
GUP also being able to walk hugetlb VMAs.

Add folio_walk_end() as a macro for now: the compiler is not easy to
please with the pte_unmap()->kunmap_local().

Note that one difference between follow_page() and get_user_pages(1) is
that follow_page() will not trigger faults to get something mapped.  So
folio_walk is at least currently not a replacement for get_user_pages(1),
but could likely be extended/reused to achieve something similar in the
future.

Link: https://lkml.kernel.org/r/20240802155524.517137-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagewalk.h |   58 ++++++++++
 mm/pagewalk.c            |  202 +++++++++++++++++++++++++++++++++++++
 2 files changed, 260 insertions(+)

--- a/include/linux/pagewalk.h~mm-pagewalk-introduce-folio_walk_start-folio_walk_end
+++ a/include/linux/pagewalk.h
@@ -130,4 +130,62 @@ int walk_page_mapping(struct address_spa
 		      pgoff_t nr, const struct mm_walk_ops *ops,
 		      void *private);
 
+typedef int __bitwise folio_walk_flags_t;
+
+/*
+ * Walk migration entries as well. Careful: a large folio might get split
+ * concurrently.
+ */
+#define FW_MIGRATION			((__force folio_walk_flags_t)BIT(0))
+
+/* Walk shared zeropages (small + huge) as well. */
+#define FW_ZEROPAGE			((__force folio_walk_flags_t)BIT(1))
+
+enum folio_walk_level {
+	FW_LEVEL_PTE,
+	FW_LEVEL_PMD,
+	FW_LEVEL_PUD,
+};
+
+/**
+ * struct folio_walk - folio_walk_start() / folio_walk_end() data
+ * @page:	exact folio page referenced (if applicable)
+ * @level:	page table level identifying the entry type
+ * @pte:	pointer to the page table entry (FW_LEVEL_PTE).
+ * @pmd:	pointer to the page table entry (FW_LEVEL_PMD).
+ * @pud:	pointer to the page table entry (FW_LEVEL_PUD).
+ * @ptl:	pointer to the page table lock.
+ *
+ * (see folio_walk_start() documentation for more details)
+ */
+struct folio_walk {
+	/* public */
+	struct page *page;
+	enum folio_walk_level level;
+	union {
+		pte_t *ptep;
+		pud_t *pudp;
+		pmd_t *pmdp;
+	};
+	union {
+		pte_t pte;
+		pud_t pud;
+		pmd_t pmd;
+	};
+	/* private */
+	struct vm_area_struct *vma;
+	spinlock_t *ptl;
+};
+
+struct folio *folio_walk_start(struct folio_walk *fw,
+		struct vm_area_struct *vma, unsigned long addr,
+		folio_walk_flags_t flags);
+
+#define folio_walk_end(__fw, __vma) do { \
+	spin_unlock((__fw)->ptl); \
+	if (likely((__fw)->level == FW_LEVEL_PTE)) \
+		pte_unmap((__fw)->ptep); \
+	vma_pgtable_walk_end(__vma); \
+} while (0)
+
 #endif /* _LINUX_PAGEWALK_H */
--- a/mm/pagewalk.c~mm-pagewalk-introduce-folio_walk_start-folio_walk_end
+++ a/mm/pagewalk.c
@@ -3,6 +3,8 @@
 #include <linux/highmem.h>
 #include <linux/sched.h>
 #include <linux/hugetlb.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
 
 /*
  * We want to know the real level where a entry is located ignoring any
@@ -654,3 +656,203 @@ int walk_page_mapping(struct address_spa
 
 	return err;
 }
+
+/**
+ * folio_walk_start - walk the page tables to a folio
+ * @fw: filled with information on success.
+ * @vma: the VMA.
+ * @addr: the virtual address to use for the page table walk.
+ * @flags: flags modifying which folios to walk to.
+ *
+ * Walk the page tables using @addr in a given @vma to a mapped folio and
+ * return the folio, making sure that the page table entry referenced by
+ * @addr cannot change until folio_walk_end() was called.
+ *
+ * As default, this function returns only folios that are not special (e.g., not
+ * the zeropage) and never returns folios that are supposed to be ignored by the
+ * VM as documented by vm_normal_page(). If requested, zeropages will be
+ * returned as well.
+ *
+ * As default, this function only considers present page table entries.
+ * If requested, it will also consider migration entries.
+ *
+ * If this function returns NULL it might either indicate "there is nothing" or
+ * "there is nothing suitable".
+ *
+ * On success, @fw is filled and the function returns the folio while the PTL
+ * is still held and folio_walk_end() must be called to clean up,
+ * releasing any held locks. The returned folio must *not* be used after the
+ * call to folio_walk_end(), unless a short-term folio reference is taken before
+ * that call.
+ *
+ * @fw->page will correspond to the page that is effectively referenced by
+ * @addr. However, for migration entries and shared zeropages @fw->page is
+ * set to NULL. Note that large folios might be mapped by multiple page table
+ * entries, and this function will always only lookup a single entry as
+ * specified by @addr, which might or might not cover more than a single page of
+ * the returned folio.
+ *
+ * This function must *not* be used as a naive replacement for
+ * get_user_pages() / pin_user_pages(), especially not to perform DMA or
+ * to carelessly modify page content. This function may *only* be used to grab
+ * short-term folio references, never to grab long-term folio references.
+ *
+ * Using the page table entry pointers in @fw for reading or modifying the
+ * entry should be avoided where possible: however, there might be valid
+ * use cases.
+ *
+ * WARNING: Modifying page table entries in hugetlb VMAs requires a lot of care.
+ * For example, PMD page table sharing might require prior unsharing. Also,
+ * logical hugetlb entries might span multiple physical page table entries,
+ * which *must* be modified in a single operation (set_huge_pte_at(),
+ * huge_ptep_set_*, ...). Note that the page table entry stored in @fw might
+ * not correspond to the first physical entry of a logical hugetlb entry.
+ *
+ * The mmap lock must be held in read mode.
+ *
+ * Return: folio pointer on success, otherwise NULL.
+ */
+struct folio *folio_walk_start(struct folio_walk *fw,
+		struct vm_area_struct *vma, unsigned long addr,
+		folio_walk_flags_t flags)
+{
+	unsigned long entry_size;
+	bool expose_page = true;
+	struct page *page;
+	pud_t *pudp, pud;
+	pmd_t *pmdp, pmd;
+	pte_t *ptep, pte;
+	spinlock_t *ptl;
+	pgd_t *pgdp;
+	p4d_t *p4dp;
+
+	mmap_assert_locked(vma->vm_mm);
+	vma_pgtable_walk_begin(vma);
+
+	if (WARN_ON_ONCE(addr < vma->vm_start || addr >= vma->vm_end))
+		goto not_found;
+
+	pgdp = pgd_offset(vma->vm_mm, addr);
+	if (pgd_none_or_clear_bad(pgdp))
+		goto not_found;
+
+	p4dp = p4d_offset(pgdp, addr);
+	if (p4d_none_or_clear_bad(p4dp))
+		goto not_found;
+
+	pudp = pud_offset(p4dp, addr);
+	pud = pudp_get(pudp);
+	if (pud_none(pud))
+		goto not_found;
+	if (IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES) && pud_leaf(pud)) {
+		ptl = pud_lock(vma->vm_mm, pudp);
+		pud = pudp_get(pudp);
+
+		entry_size = PUD_SIZE;
+		fw->level = FW_LEVEL_PUD;
+		fw->pudp = pudp;
+		fw->pud = pud;
+
+		if (!pud_present(pud) || pud_devmap(pud)) {
+			spin_unlock(ptl);
+			goto not_found;
+		} else if (!pud_leaf(pud)) {
+			spin_unlock(ptl);
+			goto pmd_table;
+		}
+		/*
+		 * TODO: vm_normal_page_pud() will be handy once we want to
+		 * support PUD mappings in VM_PFNMAP|VM_MIXEDMAP VMAs.
+		 */
+		page = pud_page(pud);
+		goto found;
+	}
+
+pmd_table:
+	VM_WARN_ON_ONCE(pud_leaf(*pudp));
+	pmdp = pmd_offset(pudp, addr);
+	pmd = pmdp_get_lockless(pmdp);
+	if (pmd_none(pmd))
+		goto not_found;
+	if (IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES) && pmd_leaf(pmd)) {
+		ptl = pmd_lock(vma->vm_mm, pmdp);
+		pmd = pmdp_get(pmdp);
+
+		entry_size = PMD_SIZE;
+		fw->level = FW_LEVEL_PMD;
+		fw->pmdp = pmdp;
+		fw->pmd = pmd;
+
+		if (pmd_none(pmd)) {
+			spin_unlock(ptl);
+			goto not_found;
+		} else if (!pmd_leaf(pmd)) {
+			spin_unlock(ptl);
+			goto pte_table;
+		} else if (pmd_present(pmd)) {
+			page = vm_normal_page_pmd(vma, addr, pmd);
+			if (page) {
+				goto found;
+			} else if ((flags & FW_ZEROPAGE) &&
+				    is_huge_zero_pmd(pmd)) {
+				page = pfn_to_page(pmd_pfn(pmd));
+				expose_page = false;
+				goto found;
+			}
+		} else if ((flags & FW_MIGRATION) &&
+			   is_pmd_migration_entry(pmd)) {
+			swp_entry_t entry = pmd_to_swp_entry(pmd);
+
+			page = pfn_swap_entry_to_page(entry);
+			expose_page = false;
+			goto found;
+		}
+		spin_unlock(ptl);
+		goto not_found;
+	}
+
+pte_table:
+	VM_WARN_ON_ONCE(pmd_leaf(pmdp_get_lockless(pmdp)));
+	ptep = pte_offset_map_lock(vma->vm_mm, pmdp, addr, &ptl);
+	if (!ptep)
+		goto not_found;
+	pte = ptep_get(ptep);
+
+	entry_size = PAGE_SIZE;
+	fw->level = FW_LEVEL_PTE;
+	fw->ptep = ptep;
+	fw->pte = pte;
+
+	if (pte_present(pte)) {
+		page = vm_normal_page(vma, addr, pte);
+		if (page)
+			goto found;
+		if ((flags & FW_ZEROPAGE) &&
+		    is_zero_pfn(pte_pfn(pte))) {
+			page = pfn_to_page(pte_pfn(pte));
+			expose_page = false;
+			goto found;
+		}
+	} else if (!pte_none(pte)) {
+		swp_entry_t entry = pte_to_swp_entry(pte);
+
+		if ((flags & FW_MIGRATION) &&
+		    is_migration_entry(entry)) {
+			page = pfn_swap_entry_to_page(entry);
+			expose_page = false;
+			goto found;
+		}
+	}
+	pte_unmap_unlock(ptep, ptl);
+not_found:
+	vma_pgtable_walk_end(vma);
+	return NULL;
+found:
+	if (expose_page)
+		/* Note: Offset from the mapped page, not the folio start. */
+		fw->page = nth_page(page, (addr & (entry_size - 1)) >> PAGE_SHIFT);
+	else
+		fw->page = NULL;
+	fw->ptl = ptl;
+	return page_folio(page);
+}
_

Patches currently in -mm which might be from david@redhat.com are

mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch
mm-simplify-arch_make_folio_accessible.patch
mm-gup-convert-to-arch_make_folio_accessible.patch
s390-uv-drop-arch_make_page_accessible.patch
mm-hugetlb-remove-hugetlb_follow_page_mask-leftover.patch
mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap.patch
mm-clarify-folio_likely_mapped_shared-documentation-for-ksm-folios.patch
mm-provide-vm_normal_pagefolio_pmd-with-config_pgtable_has_huge_leaves.patch
mm-pagewalk-introduce-folio_walk_start-folio_walk_end.patch
mm-migrate-convert-do_pages_stat_array-from-follow_page-to-folio_walk.patch
mm-migrate-convert-add_page_for_migration-from-follow_page-to-folio_walk.patch
mm-ksm-convert-get_mergeable_page-from-follow_page-to-folio_walk.patch
mm-ksm-convert-scan_get_next_rmap_item-from-follow_page-to-folio_walk.patch
mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk.patch
s390-uv-convert-gmap_destroy_page-from-follow_page-to-folio_walk.patch
s390-mm-fault-convert-do_secure_storage_access-from-follow_page-to-folio_walk.patch
mm-remove-follow_page.patch
mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch

