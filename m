Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD8A127B4D
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711477823; cv=none; b=P1ciea327e0ONLGrfdwZ5nYbPYFi34eOmtEP4bgoJLgi3hJ+du8KT0DhS13jIs+EZDD7KSnrTf/NjyCfWrwL6t2wj6i66bgu9hWVArPaIRpVT0VRlJZzebA0nmaaMcniL0PSf3DaptS5VN5/XZSJmYG/Wgh9rq9FkKV7CQ3G3zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711477823; c=relaxed/simple;
	bh=5/zqV81WVCVhcQs/NjQj81cuf5h8+x6s9SYOWGB7SZ4=;
	h=Date:To:From:Subject:Message-Id; b=JqY89LA8WBJqK2B6a6ZRm1iiwWXDkWLj0CJC6myeBjjIyYUCNrl4kF8SwmeNmLUPThRP+ozn0OACna7HktGU8Xq8OG2RMf7TU9QhK7kIThmnaztkMR5gbiwxk+cNBYfgE6q/796s5EVlk1ILfRyKzsrE58rsDvw25C7ZA9s1hK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ez7Ly8rR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ez7Ly8rR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B564C433F1;
	Tue, 26 Mar 2024 18:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711477822;
	bh=5/zqV81WVCVhcQs/NjQj81cuf5h8+x6s9SYOWGB7SZ4=;
	h=Date:To:From:Subject:From;
	b=Ez7Ly8rRbIQQjKaucEw12hdGm6ugYEDMQPxDKfdHejJydVlDlCU1x12j3mTgna6YO
	 aBYfNKeIT4vXvlOWMOtnkTxMDQV++pNE5iZVzbBM8573ld2EnOQXqW4tqvVcp/Ykuy
	 Zf+DqUyRIjabbky1Gevol7ONZ3n5h/tvDVbVHBdo=
Date: Tue, 26 Mar 2024 11:30:22 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20240326183022.9B564C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert arch_clear_hugepage_flags to take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert arch_clear_hugepage_flags to take a folio
Date: Tue, 26 Mar 2024 17:10:29 +0000

All implementations that aren't no-ops just set a bit in the flags, and we
want to use the folio flags rather than the page flags for that.  Rename
it to arch_clear_hugetlb_flags() while we're touching it so nobody thinks
it's used for THP.

Link: https://lkml.kernel.org/r/20240326171045.410737-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/hugetlb.h   |    6 +++---
 arch/arm64/include/asm/hugetlb.h |    6 +++---
 arch/riscv/include/asm/hugetlb.h |    6 +++---
 arch/s390/include/asm/hugetlb.h  |    6 +++---
 arch/sh/include/asm/hugetlb.h    |    6 +++---
 include/linux/hugetlb.h          |    4 ++--
 mm/hugetlb.c                     |    4 ++--
 7 files changed, 19 insertions(+), 19 deletions(-)

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
@@ -837,8 +837,8 @@ static inline int is_hugepage_only_range
 #endif
 
 #ifndef arch_clear_hugepage_flags
-static inline void arch_clear_hugepage_flags(struct page *page) { }
-#define arch_clear_hugepage_flags arch_clear_hugepage_flags
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

mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch

