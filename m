Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165CC178378
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854764; cv=none; b=t3NuKVgNUEt9P6Pet4I4VLBk5Pigp+DqVjuahul46K8oaZwAgDymra2/gwD9YdnDTTZZFkMXl62ThRahSRbzeZ/CCqQ8SP9coC/rtj0LwKgbIZ0kxv6FYO549TxIgsTjVM+Q0a1BcfDg4DrKfUH5dKbxXxk7Jh5fodsvCwQmGO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854764; c=relaxed/simple;
	bh=HgwreyEZ4+HcjfiT1Qj49j+c6RQ4hQ6r9+aw1BX7f7E=;
	h=Date:To:From:Subject:Message-Id; b=V2LRqxEaqCyTl7D8nxnXceCKcmP6SAvYBA6x/KY7c82tP8D7C+/gFnoo8ZttjLxsfuejc7k5D9xONivyavZ7Qpo3QahcNIDUkLHmA1ux6NLR4He+Jz9E/l6KVI9Tr/NSdtpj0aGknsv4j/byue8U90PfS6BzCGnMSNhDsC7yO0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pnXDlP8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pnXDlP8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E166DC4CECF;
	Wed,  6 Nov 2024 00:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854764;
	bh=HgwreyEZ4+HcjfiT1Qj49j+c6RQ4hQ6r9+aw1BX7f7E=;
	h=Date:To:From:Subject:From;
	b=pnXDlP8/i8W21mX1PsLVPAFMt+3OrnOENWaxaBc1IjdLWzf8FaFY5W3DFZ7gXJQJZ
	 2QzXPVLdQEuV4l/VEzJr+icd90doxnXbkn/ZzSaUwi6QZ9VrqJRssgccUSFoPMZWrt
	 0ihteUgHlOudLVMf/aCPo9xikrn6wDd8VbMYiHS4=
Date: Tue, 05 Nov 2024 16:59:23 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,david@redhat.com,dave.hansen@linux.intel.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-set_pxd_safe-helpers-from-generic-to-platform.patch removed from -mm tree
Message-Id: <20241106005923.E166DC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move set_pxd_safe() helpers from generic to platform
has been removed from the -mm tree.  Its filename was
     mm-move-set_pxd_safe-helpers-from-generic-to-platform.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: move set_pxd_safe() helpers from generic to platform
Date: Thu, 3 Oct 2024 10:18:42 +0530

set_pxd_safe() helpers that serve a specific purpose for both x86 and
riscv platforms, do not need to be in the common memory code.  Otherwise
they just unnecessarily make the common API more complicated.  This moves
the helpers from common code to platform instead.

Link: https://lkml.kernel.org/r/20241003044842.246016-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/pgtable.h |   19 ++++++++++++++
 arch/x86/include/asm/pgtable.h   |   37 ++++++++++++++++++++++++++++
 include/linux/pgtable.h          |   38 -----------------------------
 3 files changed, 56 insertions(+), 38 deletions(-)

--- a/arch/riscv/include/asm/pgtable.h~mm-move-set_pxd_safe-helpers-from-generic-to-platform
+++ a/arch/riscv/include/asm/pgtable.h
@@ -963,6 +963,25 @@ void misc_mem_init(void);
 extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
 #define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
 
+/*
+ * Use set_p*_safe(), and elide TLB flushing, when confident that *no*
+ * TLB flush will be required as a result of the "set". For example, use
+ * in scenarios where it is known ahead of time that the routine is
+ * setting non-present entries, or re-setting an existing entry to the
+ * same value. Otherwise, use the typical "set" helpers and flush the
+ * TLB.
+ */
+#define set_p4d_safe(p4dp, p4d) \
+({ \
+	WARN_ON_ONCE(p4d_present(*p4dp) && !p4d_same(*p4dp, p4d)); \
+	set_p4d(p4dp, p4d); \
+})
+
+#define set_pgd_safe(pgdp, pgd) \
+({ \
+	WARN_ON_ONCE(pgd_present(*pgdp) && !pgd_same(*pgdp, pgd)); \
+	set_pgd(pgdp, pgd); \
+})
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_RISCV_PGTABLE_H */
--- a/arch/x86/include/asm/pgtable.h~mm-move-set_pxd_safe-helpers-from-generic-to-platform
+++ a/arch/x86/include/asm/pgtable.h
@@ -1775,6 +1775,43 @@ bool arch_is_platform_page(u64 paddr);
 #define arch_is_platform_page arch_is_platform_page
 #endif
 
+/*
+ * Use set_p*_safe(), and elide TLB flushing, when confident that *no*
+ * TLB flush will be required as a result of the "set". For example, use
+ * in scenarios where it is known ahead of time that the routine is
+ * setting non-present entries, or re-setting an existing entry to the
+ * same value. Otherwise, use the typical "set" helpers and flush the
+ * TLB.
+ */
+#define set_pte_safe(ptep, pte) \
+({ \
+	WARN_ON_ONCE(pte_present(*ptep) && !pte_same(*ptep, pte)); \
+	set_pte(ptep, pte); \
+})
+
+#define set_pmd_safe(pmdp, pmd) \
+({ \
+	WARN_ON_ONCE(pmd_present(*pmdp) && !pmd_same(*pmdp, pmd)); \
+	set_pmd(pmdp, pmd); \
+})
+
+#define set_pud_safe(pudp, pud) \
+({ \
+	WARN_ON_ONCE(pud_present(*pudp) && !pud_same(*pudp, pud)); \
+	set_pud(pudp, pud); \
+})
+
+#define set_p4d_safe(p4dp, p4d) \
+({ \
+	WARN_ON_ONCE(p4d_present(*p4dp) && !p4d_same(*p4dp, p4d)); \
+	set_p4d(p4dp, p4d); \
+})
+
+#define set_pgd_safe(pgdp, pgd) \
+({ \
+	WARN_ON_ONCE(pgd_present(*pgdp) && !pgd_same(*pgdp, pgd)); \
+	set_pgd(pgdp, pgd); \
+})
 #endif	/* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_PGTABLE_H */
--- a/include/linux/pgtable.h~mm-move-set_pxd_safe-helpers-from-generic-to-platform
+++ a/include/linux/pgtable.h
@@ -1056,44 +1056,6 @@ static inline int pgd_same(pgd_t pgd_a,
 }
 #endif
 
-/*
- * Use set_p*_safe(), and elide TLB flushing, when confident that *no*
- * TLB flush will be required as a result of the "set". For example, use
- * in scenarios where it is known ahead of time that the routine is
- * setting non-present entries, or re-setting an existing entry to the
- * same value. Otherwise, use the typical "set" helpers and flush the
- * TLB.
- */
-#define set_pte_safe(ptep, pte) \
-({ \
-	WARN_ON_ONCE(pte_present(*ptep) && !pte_same(*ptep, pte)); \
-	set_pte(ptep, pte); \
-})
-
-#define set_pmd_safe(pmdp, pmd) \
-({ \
-	WARN_ON_ONCE(pmd_present(*pmdp) && !pmd_same(*pmdp, pmd)); \
-	set_pmd(pmdp, pmd); \
-})
-
-#define set_pud_safe(pudp, pud) \
-({ \
-	WARN_ON_ONCE(pud_present(*pudp) && !pud_same(*pudp, pud)); \
-	set_pud(pudp, pud); \
-})
-
-#define set_p4d_safe(p4dp, p4d) \
-({ \
-	WARN_ON_ONCE(p4d_present(*p4dp) && !p4d_same(*p4dp, p4d)); \
-	set_p4d(p4dp, p4d); \
-})
-
-#define set_pgd_safe(pgdp, pgd) \
-({ \
-	WARN_ON_ONCE(pgd_present(*pgdp) && !pgd_same(*pgdp, pgd)); \
-	set_pgd(pgdp, pgd); \
-})
-
 #ifndef __HAVE_ARCH_DO_SWAP_PAGE
 static inline void arch_do_swap_page_nr(struct mm_struct *mm,
 				     struct vm_area_struct *vma,
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


