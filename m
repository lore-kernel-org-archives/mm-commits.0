From: akpm@linux-foundation.org
Subject: + arm-mm-introduce-special-ptes-for-lpae.patch added to -mm tree
Date: Wed, 01 Oct 2014 14:23:23 -0700
Message-ID: <542c70cb.1GUOBGQCVJZ0d23D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaJAVXY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 17:23:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steve.capper@linaro.org, aarcange@redhat.com, catalin.marinas@arm.com, christoffer.dall@linaro.org, dann.frazier@canonical.com, hughd@google.com, mark.rutland@arm.com, mel@csn.ul.ie, rmk@arm.linux.org.uk, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: mm: introduce special ptes for LPAE
has been added to the -mm tree.  Its filename is
     arm-mm-introduce-special-ptes-for-lpae.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-mm-introduce-special-ptes-for-lpae.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-mm-introduce-special-ptes-for-lpae.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Steve Capper <steve.capper@linaro.org>
Subject: arm: mm: introduce special ptes for LPAE

We need a mechanism to tag ptes as being special, this indicates that no
attempt should be made to access the underlying struct page * associated
with the pte.  This is used by the fast_gup when operating on ptes as it
has no means to access VMAs (that also contain this information)
locklessly.

The L_PTE_SPECIAL bit is already allocated for LPAE, this patch modifies
pte_special and pte_mkspecial to make use of it, and defines
__HAVE_ARCH_PTE_SPECIAL.

This patch also excludes special ptes from the icache/dcache sync logic.

Signed-off-by: Steve Capper <steve.capper@linaro.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dann Frazier <dann.frazier@canonical.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-2level.h |    2 ++
 arch/arm/include/asm/pgtable-3level.h |    7 +++++++
 arch/arm/include/asm/pgtable.h        |    6 ++----
 3 files changed, 11 insertions(+), 4 deletions(-)

diff -puN arch/arm/include/asm/pgtable-2level.h~arm-mm-introduce-special-ptes-for-lpae arch/arm/include/asm/pgtable-2level.h
--- a/arch/arm/include/asm/pgtable-2level.h~arm-mm-introduce-special-ptes-for-lpae
+++ a/arch/arm/include/asm/pgtable-2level.h
@@ -182,6 +182,8 @@ static inline pmd_t *pmd_offset(pud_t *p
 #define pmd_addr_end(addr,end) (end)
 
 #define set_pte_ext(ptep,pte,ext) cpu_set_pte_ext(ptep,pte,ext)
+#define pte_special(pte)	(0)
+static inline pte_t pte_mkspecial(pte_t pte) { return pte; }
 
 /*
  * We don't have huge page support for short descriptors, for the moment
diff -puN arch/arm/include/asm/pgtable-3level.h~arm-mm-introduce-special-ptes-for-lpae arch/arm/include/asm/pgtable-3level.h
--- a/arch/arm/include/asm/pgtable-3level.h~arm-mm-introduce-special-ptes-for-lpae
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -213,6 +213,13 @@ static inline pmd_t *pmd_offset(pud_t *p
 #define pmd_isclear(pmd, val)	(!(pmd_val(pmd) & (val)))
 
 #define pmd_young(pmd)		(pmd_isset((pmd), PMD_SECT_AF))
+#define pte_special(pte)	(pte_isset((pte), L_PTE_SPECIAL))
+static inline pte_t pte_mkspecial(pte_t pte)
+{
+	pte_val(pte) |= L_PTE_SPECIAL;
+	return pte;
+}
+#define	__HAVE_ARCH_PTE_SPECIAL
 
 #define __HAVE_ARCH_PMD_WRITE
 #define pmd_write(pmd)		(pmd_isclear((pmd), L_PMD_SECT_RDONLY))
diff -puN arch/arm/include/asm/pgtable.h~arm-mm-introduce-special-ptes-for-lpae arch/arm/include/asm/pgtable.h
--- a/arch/arm/include/asm/pgtable.h~arm-mm-introduce-special-ptes-for-lpae
+++ a/arch/arm/include/asm/pgtable.h
@@ -226,7 +226,6 @@ static inline pte_t *pmd_page_vaddr(pmd_
 #define pte_dirty(pte)		(pte_isset((pte), L_PTE_DIRTY))
 #define pte_young(pte)		(pte_isset((pte), L_PTE_YOUNG))
 #define pte_exec(pte)		(pte_isclear((pte), L_PTE_XN))
-#define pte_special(pte)	(0)
 
 #define pte_valid_user(pte)	\
 	(pte_valid(pte) && pte_isset((pte), L_PTE_USER) && pte_young(pte))
@@ -245,7 +244,8 @@ static inline void set_pte_at(struct mm_
 	unsigned long ext = 0;
 
 	if (addr < TASK_SIZE && pte_valid_user(pteval)) {
-		__sync_icache_dcache(pteval);
+		if (!pte_special(pteval))
+			__sync_icache_dcache(pteval);
 		ext |= PTE_EXT_NG;
 	}
 
@@ -264,8 +264,6 @@ PTE_BIT_FUNC(mkyoung,   |= L_PTE_YOUNG);
 PTE_BIT_FUNC(mkexec,   &= ~L_PTE_XN);
 PTE_BIT_FUNC(mknexec,   |= L_PTE_XN);
 
-static inline pte_t pte_mkspecial(pte_t pte) { return pte; }
