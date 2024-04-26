Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B41E7EF1B
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104019; cv=none; b=RvaRc8jCMqPsIpOkIqGniIkqSryEyeDA7PqDSJVusNZqlpzZnKQ5o55gnaHvI2qVtLEC/1XemgFtO73sOGYy84zp/JGDE6oZKI0JyJnCZwvPFU5xIPbj6waXCaRLBM45Qg+Wsi/Ca6h3WtQgyD4JubaALlzyloL1pGK8tyHeEHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104019; c=relaxed/simple;
	bh=DW6ZXc86chK7ZqBwwsG/MNSp8NIuAlkMUYCiCJOuX5k=;
	h=Date:To:From:Subject:Message-Id; b=idNKGCcH9leWPpUaO/dF35REBfY/ZbtKJ4bNK8TbzeZokW+RCbnT4llgCDb3+HmROZm3J6U1Kv7N1Ss5KKdRDioOyO5L8cEPrlu21/Fvoh4PDagMwojhdUyJfzAh5dUoKh/l92+LWInuwyvGasjpuSNcX/1Dx7zv4K9gHlEK6v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gr/nFiOX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gr/nFiOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F53EC116B1;
	Fri, 26 Apr 2024 04:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104019;
	bh=DW6ZXc86chK7ZqBwwsG/MNSp8NIuAlkMUYCiCJOuX5k=;
	h=Date:To:From:Subject:From;
	b=gr/nFiOXPje8oLOKR8XeUD48m0AdvoUalGlX3EzdUWilHz/KsQsF9car0KYmuUoHd
	 H3a4V3SCxaCOtcSu3+TJm6w61U9rBO9YluxDKldJtNISzD8YsYk59/hWjkIKSwuEwl
	 BzF5+Olyu0wUZXjwvfGJAyJWat4FZJU2EOz59BZo=
Date: Thu, 25 Apr 2024 21:00:18 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch removed from -mm tree
Message-Id: <20240426040019.2F53EC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert arch_clear_hugepage_flags to take a folio
has been removed from the -mm tree.  Its filename was
     mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert arch_clear_hugepage_flags to take a folio
Date: Tue, 26 Mar 2024 17:10:29 +0000

All implementations that aren't no-ops just set a bit in the flags, and we
want to use the folio flags rather than the page flags for that.  Rename
it to arch_clear_hugetlb_flags() while we're touching it so nobody thinks
it's used for THP.

[willy@infradead.org: fix arm64 build]
  Link: https://lkml.kernel.org/r/ZgQvNKGdlDkwhQEX@casper.infradead.org
Link: https://lkml.kernel.org/r/20240326171045.410737-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/hugetlb.h   |    6 +++---
 arch/arm64/include/asm/hugetlb.h |    6 +++---
 arch/riscv/include/asm/hugetlb.h |    6 +++---
 arch/s390/include/asm/hugetlb.h  |    6 +++---
 arch/sh/include/asm/hugetlb.h    |    6 +++---
 include/linux/hugetlb.h          |    6 +++---
 mm/hugetlb.c                     |    4 ++--
 7 files changed, 20 insertions(+), 20 deletions(-)

--- a/arch/arm64/include/asm/hugetlb.h~mm-convert-arch_clear_hugepage_flags-to-take-a-folio
+++ a/arch/arm64/include/asm/hugetlb.h
@@ -18,11 +18,11 @@
 extern bool arch_hugetlb_migration_supported(struct hstate *h);
 #endif
 
-static inline void arch_clear_hugepage_flags(struct page *page)
+static inline void arch_clear_hugetlb_flags(struct folio *folio)
 {
-	clear_bit(PG_dcache_clean, &page->flags);
+	clear_bit(PG_dcache_clean, &folio->flags);
 }
-#define arch_clear_hugepage_flags arch_clear_hugepage_flags
+#define arch_clear_hugetlb_flags arch_clear_hugetlb_flags
 
 pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags);
 #define arch_make_huge_pte arch_make_huge_pte
--- a/arch/arm/include/asm/hugetlb.h~mm-convert-arch_clear_hugepage_flags-to-take-a-folio
+++ a/arch/arm/include/asm/hugetlb.h
@@ -15,10 +15,10 @@
 #include <asm/hugetlb-3level.h>
 #include <asm-generic/hugetlb.h>
 
-static inline void arch_clear_hugepage_flags(struct page *page)
+static inline void arch_clear_hugetlb_flags(struct folio *folio)
 {
-	clear_bit(PG_dcache_clean, &page->flags);
+	clear_bit(PG_dcache_clean, &folio->flags);
 }
-#define arch_clear_hugepage_flags arch_clear_hugepage_flags
+#define arch_clear_hugetlb_flags arch_clear_hugetlb_flags
 
 #endif /* _ASM_ARM_HUGETLB_H */
--- a/arch/riscv/include/asm/hugetlb.h~mm-convert-arch_clear_hugepage_flags-to-take-a-folio
+++ a/arch/riscv/include/asm/hugetlb.h
@@ -5,11 +5,11 @@
 #include <asm/cacheflush.h>
 #include <asm/page.h>
 
-static inline void arch_clear_hugepage_flags(struct page *page)
+static inline void arch_clear_hugetlb_flags(struct folio *folio)
 {
-	clear_bit(PG_dcache_clean, &page->flags);
+	clear_bit(PG_dcache_clean, &folio->flags);
 }
-#define arch_clear_hugepage_flags arch_clear_hugepage_flags
+#define arch_clear_hugetlb_flags arch_clear_hugetlb_flags
 
 #ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
 bool arch_hugetlb_migration_supported(struct hstate *h);
--- a/arch/s390/include/asm/hugetlb.h~mm-convert-arch_clear_hugepage_flags-to-take-a-folio
+++ a/arch/s390/include/asm/hugetlb.h
@@ -39,11 +39,11 @@ static inline int prepare_hugepage_range
 	return 0;
 }
 
-static inline void arch_clear_hugepage_flags(struct page *page)
+static inline void arch_clear_hugetlb_flags(struct folio *folio)
 {
-	clear_bit(PG_arch_1, &page->flags);
+	clear_bit(PG_arch_1, &folio->flags);
 }
-#define arch_clear_hugepage_flags arch_clear_hugepage_flags
+#define arch_clear_hugetlb_flags arch_clear_hugetlb_flags
 
 static inline void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
 				  pte_t *ptep, unsigned long sz)
--- a/arch/sh/include/asm/hugetlb.h~mm-convert-arch_clear_hugepage_flags-to-take-a-folio
+++ a/arch/sh/include/asm/hugetlb.h
@@ -27,11 +27,11 @@ static inline pte_t huge_ptep_clear_flus
 	return *ptep;
 }
 
-static inline void arch_clear_hugepage_flags(struct page *page)
+static inline void arch_clear_hugetlb_flags(struct folio *folio)
 {
-	clear_bit(PG_dcache_clean, &page->flags);
+	clear_bit(PG_dcache_clean, &folio->flags);
 }
-#define arch_clear_hugepage_flags arch_clear_hugepage_flags
+#define arch_clear_hugetlb_flags arch_clear_hugetlb_flags
 
 #include <asm-generic/hugetlb.h>
 
--- a/include/linux/hugetlb.h~mm-convert-arch_clear_hugepage_flags-to-take-a-folio
+++ a/include/linux/hugetlb.h
@@ -836,9 +836,9 @@ static inline int is_hugepage_only_range
 #define is_hugepage_only_range is_hugepage_only_range
 #endif
 
-#ifndef arch_clear_hugepage_flags
-static inline void arch_clear_hugepage_flags(struct page *page) { }
-#define arch_clear_hugepage_flags arch_clear_hugepage_flags
+#ifndef arch_clear_hugetlb_flags
+static inline void arch_clear_hugetlb_flags(struct folio *folio) { }
+#define arch_clear_hugetlb_flags arch_clear_hugetlb_flags
 #endif
 
 #ifndef arch_make_huge_pte
--- a/mm/hugetlb.c~mm-convert-arch_clear_hugepage_flags-to-take-a-folio
+++ a/mm/hugetlb.c
@@ -1726,7 +1726,7 @@ static void add_hugetlb_folio(struct hst
 		 */
 		return;
 
-	arch_clear_hugepage_flags(&folio->page);
+	arch_clear_hugetlb_flags(folio);
 	enqueue_hugetlb_folio(h, folio);
 }
 
@@ -2024,7 +2024,7 @@ void free_huge_folio(struct folio *folio
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
 	} else {
-		arch_clear_hugepage_flags(&folio->page);
+		arch_clear_hugetlb_flags(folio);
 		enqueue_hugetlb_folio(h, folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 	}
_

Patches currently in -mm which might be from willy@infradead.org are

doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch
doc-split-bufferrst-out-of-api-summaryrst-fix.patch
mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch
mm-memory-failure-pass-addr-to-__add_to_kill.patch
mm-return-the-address-from-page_mapped_in_vma.patch
mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch
mm-memory-failure-convert-shake_page-to-shake_folio.patch
mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch
mm-memory-failure-convert-memory_failure-to-use-a-folio.patch
mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch
mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch
mm-memory-failure-use-folio-functions-throughout-collect_procs.patch
mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch
fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch
f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch
memory-failure-remove-calls-to-page_mapping.patch
migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch
userfault-expand-folio-use-in-mfill_atomic_install_pte.patch
mm-remove-page_mapping.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch

