Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905A2155C83
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 02:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740537402; cv=none; b=lBcgHDMK4hlz3DpxJrsvrRcbD+b3fTXsCTxmwlppdajGGLztoIKuSXfvrPBgLY6uOZGn2056jyVgIkES5mwYsp293BV/JfdoUUVW3Y6mRKnf5FDJVW7sxbRZEEvltJdWlOY3XVJJZ9PywaQpeeAp13lxT0Zyvz6Rn8VsL022iWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740537402; c=relaxed/simple;
	bh=W2fREgYhBcODMEsNTUYZ+/0jcWivJFGt70pE5JmwYQE=;
	h=Date:To:From:Subject:Message-Id; b=gIeNJfd0+MPcmJ7jSwGK/PvxuAa/nKNvxgkTgKMBCNjbaJMTMYNG/uZaNvyfiexLxucqlymtoCNCFMro55l3isF0TgkO1sc+l7ycxmFhtTMVfUJ56iGhXA0ig60aUgZ5IJXTHEe0Y5kiRoVbx7/3F44AzfqgrE+FdGpWyQB9cTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tTT5pLrp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tTT5pLrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0ABC4CEDD;
	Wed, 26 Feb 2025 02:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740537402;
	bh=W2fREgYhBcODMEsNTUYZ+/0jcWivJFGt70pE5JmwYQE=;
	h=Date:To:From:Subject:From;
	b=tTT5pLrp6u0CujRAcJcp6Ys5KAFnVYxJYdY9Z8pm33vJAkPaqk304cfw22lnw+zg1
	 SbHaIl+dheoWc4EUu/tOG/fih4/bRnbJykAQxDfVu7Upb1N6yyytzIT4RF/j59dgJ1
	 Tla6ceWio/lPsn/lhR4QfkibB+RetLzTPcSQc0yw=
Date: Tue, 25 Feb 2025 18:36:41 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,rppt@kernel.org,riel@surriel.com,peterz@infradead.org,npiggin@gmail.com,muchun.song@linux.dev,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc.patch added to mm-unstable branch
Message-Id: <20250226023642.0F0ABC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pgtable: convert some architectures to use tlb_remove_ptdesc()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: pgtable: convert some architectures to use tlb_remove_ptdesc()
Date: Tue, 25 Feb 2025 11:45:53 +0800

Now, the nine architectures of csky, hexagon, loongarch, m68k, mips,
nios2, openrisc, sh and um do not select CONFIG_MMU_GATHER_RCU_TABLE_FREE,
and just call pagetable_dtor() + tlb_remove_page_ptdesc() (the wrapper of
tlb_remove_page()).  This is the same as the implementation of
tlb_remove_{ptdesc|table}() under !CONFIG_MMU_GATHER_TABLE_FREE, so
convert these architectures to use tlb_remove_ptdesc().

The ultimate goal is to make the architecture only use tlb_remove_ptdesc()
or tlb_remove_table() for page table pages.

Link: https://lkml.kernel.org/r/19db3e8673b67bad2f1df1ab37f1c89d99eacfea.1740454179.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/include/asm/pgalloc.h      |    3 +--
 arch/hexagon/include/asm/pgalloc.h   |    3 +--
 arch/loongarch/include/asm/pgalloc.h |    3 +--
 arch/m68k/include/asm/sun3_pgalloc.h |    3 +--
 arch/mips/include/asm/pgalloc.h      |    3 +--
 arch/nios2/include/asm/pgalloc.h     |    9 ++++-----
 arch/openrisc/include/asm/pgalloc.h  |    3 +--
 arch/sh/include/asm/pgalloc.h        |    3 +--
 arch/um/include/asm/pgalloc.h        |    9 +++------
 9 files changed, 14 insertions(+), 25 deletions(-)

--- a/arch/csky/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc
+++ a/arch/csky/include/asm/pgalloc.h
@@ -63,8 +63,7 @@ static inline pgd_t *pgd_alloc(struct mm
 
 #define __pte_free_tlb(tlb, pte, address)		\
 do {							\
-	pagetable_dtor(page_ptdesc(pte));		\
-	tlb_remove_page_ptdesc(tlb, page_ptdesc(pte));	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte));	\
 } while (0)
 
 extern void pagetable_init(void);
--- a/arch/hexagon/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc
+++ a/arch/hexagon/include/asm/pgalloc.h
@@ -89,8 +89,7 @@ static inline void pmd_populate_kernel(s
 
 #define __pte_free_tlb(tlb, pte, addr)				\
 do {								\
-	pagetable_dtor((page_ptdesc(pte)));			\
-	tlb_remove_page_ptdesc((tlb), (page_ptdesc(pte)));	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte));		\
 } while (0)
 
 #endif
--- a/arch/loongarch/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc
+++ a/arch/loongarch/include/asm/pgalloc.h
@@ -57,8 +57,7 @@ static inline pte_t *pte_alloc_one_kerne
 
 #define __pte_free_tlb(tlb, pte, address)			\
 do {								\
-	pagetable_dtor(page_ptdesc(pte));			\
-	tlb_remove_page_ptdesc((tlb), page_ptdesc(pte));	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte));		\
 } while (0)
 
 #ifndef __PAGETABLE_PMD_FOLDED
--- a/arch/m68k/include/asm/sun3_pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc
+++ a/arch/m68k/include/asm/sun3_pgalloc.h
@@ -19,8 +19,7 @@ extern const char bad_pmd_string[];
 
 #define __pte_free_tlb(tlb, pte, addr)				\
 do {								\
-	pagetable_dtor(page_ptdesc(pte));			\
-	tlb_remove_page_ptdesc((tlb), page_ptdesc(pte));	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte));		\
 } while (0)
 
 static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd, pte_t *pte)
--- a/arch/mips/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc
+++ a/arch/mips/include/asm/pgalloc.h
@@ -50,8 +50,7 @@ extern pgd_t *pgd_alloc(struct mm_struct
 
 #define __pte_free_tlb(tlb, pte, address)			\
 do {								\
-	pagetable_dtor(page_ptdesc(pte));			\
-	tlb_remove_page_ptdesc((tlb), page_ptdesc(pte));	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte));		\
 } while (0)
 
 #ifndef __PAGETABLE_PMD_FOLDED
--- a/arch/nios2/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc
+++ a/arch/nios2/include/asm/pgalloc.h
@@ -28,10 +28,9 @@ static inline void pmd_populate(struct m
 
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 
-#define __pte_free_tlb(tlb, pte, addr)					\
-	do {								\
-		pagetable_dtor(page_ptdesc(pte));			\
-		tlb_remove_page_ptdesc((tlb), (page_ptdesc(pte)));	\
-	} while (0)
+#define __pte_free_tlb(tlb, pte, addr)				\
+do {								\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte));		\
+} while (0)
 
 #endif /* _ASM_NIOS2_PGALLOC_H */
--- a/arch/openrisc/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc
+++ a/arch/openrisc/include/asm/pgalloc.h
@@ -66,8 +66,7 @@ extern pte_t *pte_alloc_one_kernel(struc
 
 #define __pte_free_tlb(tlb, pte, addr)				\
 do {								\
-	pagetable_dtor(page_ptdesc(pte));			\
-	tlb_remove_page_ptdesc((tlb), (page_ptdesc(pte)));	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte));		\
 } while (0)
 
 #endif
--- a/arch/sh/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc
+++ a/arch/sh/include/asm/pgalloc.h
@@ -34,8 +34,7 @@ static inline void pmd_populate(struct m
 
 #define __pte_free_tlb(tlb, pte, addr)				\
 do {								\
-	pagetable_dtor(page_ptdesc(pte));			\
-	tlb_remove_page_ptdesc((tlb), (page_ptdesc(pte)));	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte));		\
 } while (0)
 
 #endif /* __ASM_SH_PGALLOC_H */
--- a/arch/um/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc
+++ a/arch/um/include/asm/pgalloc.h
@@ -27,24 +27,21 @@ extern pgd_t *pgd_alloc(struct mm_struct
 
 #define __pte_free_tlb(tlb, pte, address)			\
 do {								\
-	pagetable_dtor(page_ptdesc(pte));			\
-	tlb_remove_page_ptdesc((tlb), (page_ptdesc(pte)));	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte));		\
 } while (0)
 
 #if CONFIG_PGTABLE_LEVELS > 2
 
 #define __pmd_free_tlb(tlb, pmd, address)			\
 do {								\
-	pagetable_dtor(virt_to_ptdesc(pmd));			\
-	tlb_remove_page_ptdesc((tlb), virt_to_ptdesc(pmd));	\
+	tlb_remove_ptdesc((tlb), virt_to_ptdesc(pmd));		\
 } while (0)
 
 #if CONFIG_PGTABLE_LEVELS > 3
 
 #define __pud_free_tlb(tlb, pud, address)			\
 do {								\
-	pagetable_dtor(virt_to_ptdesc(pud));		\
-	tlb_remove_page_ptdesc((tlb), virt_to_ptdesc(pud));	\
+	tlb_remove_ptdesc((tlb), virt_to_ptdesc(pud));		\
 } while (0)
 
 #endif
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

arm-pgtable-fix-null-pointer-dereference-issue.patch
mm-pgtable-make-generic-tlb_remove_table-use-struct-ptdesc.patch
mm-pgtable-change-pt-parameter-of-tlb_remove_ptdesc-to-struct-ptdesc.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc.patch
riscv-pgtable-unconditionally-use-tlb_remove_ptdesc.patch
x86-pgtable-convert-to-use-tlb_remove_ptdesc.patch
mm-pgtable-remove-tlb_remove_page_ptdesc.patch

