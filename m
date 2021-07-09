Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E78C07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD88A613E3
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhGIVgg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:36:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230519AbhGIVgg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:36:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8CD3613D3;
        Fri,  9 Jul 2021 21:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866432;
        bh=nNPnKczz2eKWDdQ5261glWvZOx7xbjlRNcuAcyaqSa8=;
        h=Date:From:To:Subject:From;
        b=1cxQCoILSaoNmYcqZ0MLryLGgJqpdw9+7UfJPwdvo/HsvyyUQ7vS+Qs5G+rxB2+P6
         gfeEtsk2NeKCvxEp/Lzp8HD1An1pb9y0wryv9bqmLOKhT5Uo7dEM4Pv+Ks5+BsOmku
         MU++18/PTDtQXFoqFdv/7W411kBOhI62k6ERAbCA=
Date:   Fri, 09 Jul 2021 14:33:51 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        hughd@google.com, joel@joelfernandes.org, kaleshsingh@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, npiggin@gmail.com, sfr@canb.auug.org.au
Subject:  [merged]
 mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t.patch
 removed from -mm tree
Message-ID: <20210709213351.AuWFsO4R4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename p4d_page_vaddr to p4d_pgtable and make it return pud_t *
has been removed from the -mm tree.  Its filename was
     mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm: rename p4d_page_vaddr to p4d_pgtable and make it return pud_t *

No functional change in this patch.

[aneesh.kumar@linux.ibm.com: m68k build error reported by kernel robot]
  Link: https://lkml.kernel.org/r/87tulxnb2v.fsf@linux.ibm.com
Link: https://lkml.kernel.org/r/20210615110859.320299-2-aneesh.kumar@linux.ibm.com
Link: https://lore.kernel.org/linuxppc-dev/CAHk-=wi+J+iodze9FtjM3Zi4j4OeS+qqbKxME9QN4roxPEXH9Q@mail.gmail.com/
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h                |    4 ++--
 arch/ia64/include/asm/pgtable.h                 |    2 +-
 arch/mips/include/asm/pgtable-64.h              |    4 ++--
 arch/powerpc/include/asm/book3s/64/pgtable.h    |    5 ++++-
 arch/powerpc/include/asm/nohash/64/pgtable-4k.h |    6 +++++-
 arch/powerpc/mm/book3s64/radix_pgtable.c        |    2 +-
 arch/powerpc/mm/pgtable_64.c                    |    2 +-
 arch/sparc/include/asm/pgtable_64.h             |    4 ++--
 arch/x86/include/asm/pgtable.h                  |    4 ++--
 arch/x86/mm/init_64.c                           |    4 ++--
 include/asm-generic/pgtable-nop4d.h             |    2 +-
 include/asm-generic/pgtable-nopud.h             |    2 +-
 include/linux/pgtable.h                         |    2 +-
 13 files changed, 25 insertions(+), 18 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t
+++ a/arch/arm64/include/asm/pgtable.h
@@ -710,9 +710,9 @@ static inline phys_addr_t p4d_page_paddr
 	return __p4d_to_phys(p4d);
 }
 
-static inline unsigned long p4d_page_vaddr(p4d_t p4d)
+static inline pud_t *p4d_pgtable(p4d_t p4d)
 {
-	return (unsigned long)__va(p4d_page_paddr(p4d));
+	return (pud_t *)__va(p4d_page_paddr(p4d));
 }
 
 /* Find an entry in the frst-level page table. */
--- a/arch/ia64/include/asm/pgtable.h~mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t
+++ a/arch/ia64/include/asm/pgtable.h
@@ -281,7 +281,7 @@ ia64_phys_addr_valid (unsigned long addr
 #define p4d_bad(p4d)			(!ia64_phys_addr_valid(p4d_val(p4d)))
 #define p4d_present(p4d)		(p4d_val(p4d) != 0UL)
 #define p4d_clear(p4dp)			(p4d_val(*(p4dp)) = 0UL)
-#define p4d_page_vaddr(p4d)		((unsigned long) __va(p4d_val(p4d) & _PFN_MASK))
+#define p4d_pgtable(p4d)		((pud_t *) __va(p4d_val(p4d) & _PFN_MASK))
 #define p4d_page(p4d)			virt_to_page((p4d_val(p4d) + PAGE_OFFSET))
 #endif
 
--- a/arch/mips/include/asm/pgtable-64.h~mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t
+++ a/arch/mips/include/asm/pgtable-64.h
@@ -209,9 +209,9 @@ static inline void p4d_clear(p4d_t *p4dp
 	p4d_val(*p4dp) = (unsigned long)invalid_pud_table;
 }
 
-static inline unsigned long p4d_page_vaddr(p4d_t p4d)
+static inline pud_t *p4d_pgtable(p4d_t p4d)
 {
-	return p4d_val(p4d);
+	return (pud_t *)p4d_val(p4d);
 }
 
 #define p4d_phys(p4d)		virt_to_phys((void *)p4d_val(p4d))
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1051,7 +1051,10 @@ extern struct page *p4d_page(p4d_t p4d);
 /* Pointers in the page table tree are physical addresses */
 #define __pgtable_ptr_val(ptr)	__pa(ptr)
 
-#define p4d_page_vaddr(p4d)	__va(p4d_val(p4d) & ~P4D_MASKED_BITS)
+static inline pud_t *p4d_pgtable(p4d_t p4d)
+{
+	return (pud_t *)__va(p4d_val(p4d) & ~P4D_MASKED_BITS);
+}
 
 static inline pmd_t *pud_pgtable(pud_t pud)
 {
--- a/arch/powerpc/include/asm/nohash/64/pgtable-4k.h~mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t
+++ a/arch/powerpc/include/asm/nohash/64/pgtable-4k.h
@@ -56,10 +56,14 @@
 #define p4d_none(p4d)		(!p4d_val(p4d))
 #define p4d_bad(p4d)		(p4d_val(p4d) == 0)
 #define p4d_present(p4d)	(p4d_val(p4d) != 0)
-#define p4d_page_vaddr(p4d)	(p4d_val(p4d) & ~P4D_MASKED_BITS)
 
 #ifndef __ASSEMBLY__
 
+static inline pud_t *p4d_pgtable(p4d_t p4d)
+{
+	return (pud_t *) (p4d_val(p4d) & ~P4D_MASKED_BITS);
+}
+
 static inline void p4d_clear(p4d_t *p4dp)
 {
 	*p4dp = __p4d(0);
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -854,7 +854,7 @@ static void __meminit remove_pagetable(u
 			continue;
 		}
 
-		pud_base = (pud_t *)p4d_page_vaddr(*p4d);
+		pud_base = p4d_pgtable(*p4d);
 		remove_pud_table(pud_base, addr, next);
 		free_pud_table(pud_base, p4d);
 	}
--- a/arch/powerpc/mm/pgtable_64.c~mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t
+++ a/arch/powerpc/mm/pgtable_64.c
@@ -105,7 +105,7 @@ struct page *p4d_page(p4d_t p4d)
 		VM_WARN_ON(!p4d_huge(p4d));
 		return pte_page(p4d_pte(p4d));
 	}
-	return virt_to_page(p4d_page_vaddr(p4d));
+	return virt_to_page(p4d_pgtable(p4d));
 }
 #endif
 
--- a/arch/sparc/include/asm/pgtable_64.h~mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -856,8 +856,8 @@ static inline pmd_t *pud_pgtable(pud_t p
 #define pmd_clear(pmdp)			(pmd_val(*(pmdp)) = 0UL)
 #define pud_present(pud)		(pud_val(pud) != 0U)
 #define pud_clear(pudp)			(pud_val(*(pudp)) = 0UL)
-#define p4d_page_vaddr(p4d)		\
-	((unsigned long) __va(p4d_val(p4d)))
+#define p4d_pgtable(p4d)		\
+	((pud_t *) __va(p4d_val(p4d)))
 #define p4d_present(p4d)		(p4d_val(p4d) != 0U)
 #define p4d_clear(p4dp)			(p4d_val(*(p4dp)) = 0UL)
 
--- a/arch/x86/include/asm/pgtable.h~mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t
+++ a/arch/x86/include/asm/pgtable.h
@@ -877,9 +877,9 @@ static inline int p4d_present(p4d_t p4d)
 	return p4d_flags(p4d) & _PAGE_PRESENT;
 }
 
-static inline unsigned long p4d_page_vaddr(p4d_t p4d)
+static inline pud_t *p4d_pgtable(p4d_t p4d)
 {
-	return (unsigned long)__va(p4d_val(p4d) & p4d_pfn_mask(p4d));
+	return (pud_t *)__va(p4d_val(p4d) & p4d_pfn_mask(p4d));
 }
 
 /*
--- a/arch/x86/mm/init_64.c~mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t
+++ a/arch/x86/mm/init_64.c
@@ -194,8 +194,8 @@ static void sync_global_pgds_l4(unsigned
 			spin_lock(pgt_lock);
 
 			if (!p4d_none(*p4d_ref) && !p4d_none(*p4d))
-				BUG_ON(p4d_page_vaddr(*p4d)
-				       != p4d_page_vaddr(*p4d_ref));
+				BUG_ON(p4d_pgtable(*p4d)
+				       != p4d_pgtable(*p4d_ref));
 
 			if (p4d_none(*p4d))
 				set_p4d(p4d, *p4d_ref);
--- a/include/asm-generic/pgtable-nop4d.h~mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t
+++ a/include/asm-generic/pgtable-nop4d.h
@@ -41,7 +41,7 @@ static inline p4d_t *p4d_offset(pgd_t *p
 #define __p4d(x)				((p4d_t) { __pgd(x) })
 
 #define pgd_page(pgd)				(p4d_page((p4d_t){ pgd }))
-#define pgd_page_vaddr(pgd)			(p4d_page_vaddr((p4d_t){ pgd }))
+#define pgd_page_vaddr(pgd)			((unsigned long)(p4d_pgtable((p4d_t){ pgd })))
 
 /*
  * allocating and freeing a p4d is trivial: the 1-entry p4d is
--- a/include/asm-generic/pgtable-nopud.h~mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t
+++ a/include/asm-generic/pgtable-nopud.h
@@ -49,7 +49,7 @@ static inline pud_t *pud_offset(p4d_t *p
 #define __pud(x)				((pud_t) { __p4d(x) })
 
 #define p4d_page(p4d)				(pud_page((pud_t){ p4d }))
-#define p4d_page_vaddr(p4d)			(pud_pgtable((pud_t){ p4d }))
+#define p4d_pgtable(p4d)			((pud_t *)(pud_pgtable((pud_t){ p4d })))
 
 /*
  * allocating and freeing a pud is trivial: the 1-entry pud is
--- a/include/linux/pgtable.h~mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t
+++ a/include/linux/pgtable.h
@@ -114,7 +114,7 @@ static inline pmd_t *pmd_offset(pud_t *p
 #ifndef pud_offset
 static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
 {
-	return (pud_t *)p4d_page_vaddr(*p4d) + pud_index(address);
+	return p4d_pgtable(*p4d) + pud_index(address);
 }
 #define pud_offset pud_offset
 #endif
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


