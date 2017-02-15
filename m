From: akpm@linux-foundation.org
Subject: +
 powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write.patch added to -mm tree
Date: Tue, 14 Feb 2017 16:20:20 -0800
Message-ID: <58a39ec4.pBlr3dYzwzHM9jXZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59402 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750905AbdBOAU1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2017 19:20:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, mgorman@techsingularity.net, michaele@au1.ibm.com, mikey@neuling.org, paulus@samba.org, riel@surriel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm/autonuma: switch ppc64 to its own implementation of saved write
has been added to the -mm tree.  Its filename is
     powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: powerpc/mm/autonuma: switch ppc64 to its own implementation of saved write

With this our protnone becomes a present pte with READ/WRITE/EXEC bit
cleared.  By default we also set _PAGE_PRIVILEGED on such pte.  This is
now used to help us identify a protnone pte that as saved write bit.  For
such pte, we will clear the _PAGE_PRIVILEGED bit.  The pte still remain
non-accessible from both user and kernel.

Link: http://lkml.kernel.org/r/1487050314-3892-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Michael Neuling <mikey@neuling.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <michaele@au1.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/mmu-hash.h |    3 +
 arch/powerpc/include/asm/book3s/64/pgtable.h  |   32 +++++++++++++++-
 2 files changed, 33 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/include/asm/book3s/64/mmu-hash.h~powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write arch/powerpc/include/asm/book3s/64/mmu-hash.h
--- a/arch/powerpc/include/asm/book3s/64/mmu-hash.h~powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write
+++ a/arch/powerpc/include/asm/book3s/64/mmu-hash.h
@@ -16,6 +16,9 @@
 #include <asm/page.h>
 #include <asm/bug.h>
 
+#ifndef __ASSEMBLY__
+#include <linux/mmdebug.h>
+#endif
 /*
  * This is necessary to get the definition of PGTABLE_RANGE which we
  * need for various slices related matters. Note that this isn't the
diff -puN arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write arch/powerpc/include/asm/book3s/64/pgtable.h
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -424,8 +424,8 @@ static inline pte_t pte_clear_soft_dirty
  */
 static inline int pte_protnone(pte_t pte)
 {
-	return (pte_raw(pte) & cpu_to_be64(_PAGE_PRESENT | _PAGE_PRIVILEGED)) ==
-		cpu_to_be64(_PAGE_PRESENT | _PAGE_PRIVILEGED);
+	return (pte_raw(pte) & cpu_to_be64(_PAGE_PRESENT | _PAGE_RWX)) ==
+		cpu_to_be64(_PAGE_PRESENT);
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
@@ -495,6 +495,32 @@ static inline pte_t pte_mkhuge(pte_t pte
 	return pte;
 }
 
+#define pte_mk_savedwrite pte_mk_savedwrite
+static inline pte_t pte_mk_savedwrite(pte_t pte)
+{
+	/*
+	 * Used by Autonuma subsystem to preserve the write bit
+	 * while marking the pte PROT_NONE. Only allow this
+	 * on PROT_NONE pte
+	 */
+	VM_BUG_ON((pte_raw(pte) & cpu_to_be64(_PAGE_PRESENT | _PAGE_RWX | _PAGE_PRIVILEGED)) !=
+		  cpu_to_be64(_PAGE_PRESENT | _PAGE_PRIVILEGED));
+	return __pte(pte_val(pte) & ~_PAGE_PRIVILEGED);
+}
+
+#define pte_savedwrite pte_savedwrite
+static inline bool pte_savedwrite(pte_t pte)
+{
+	/*
+	 * Saved write ptes are prot none ptes that doesn't have
+	 * privileged bit sit. We mark prot none as one which has
+	 * present and pviliged bit set and RWX cleared. To mark
+	 * protnone which used to have _PAGE_WRITE set we clear
+	 * the privileged bit.
+	 */
+	return !(pte_raw(pte) & cpu_to_be64(_PAGE_RWX | _PAGE_PRIVILEGED));
+}
+
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
 	/* FIXME!! check whether this need to be a conditional */
@@ -856,6 +882,7 @@ static inline pte_t *pmdp_ptep(pmd_t *pm
 #define pmd_mkclean(pmd)	pte_pmd(pte_mkclean(pmd_pte(pmd)))
 #define pmd_mkyoung(pmd)	pte_pmd(pte_mkyoung(pmd_pte(pmd)))
 #define pmd_mkwrite(pmd)	pte_pmd(pte_mkwrite(pmd_pte(pmd)))
+#define pmd_mk_savedwrite(pmd)	pte_pmd(pte_mk_savedwrite(pmd_pte(pmd)))
 
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 #define pmd_soft_dirty(pmd)    pte_soft_dirty(pmd_pte(pmd))
@@ -872,6 +899,7 @@ static inline int pmd_protnone(pmd_t pmd
 
 #define __HAVE_ARCH_PMD_WRITE
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
+#define pmd_savedwrite(pmd)	pte_savedwrite(pmd_pte(pmd))
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern pmd_t pfn_pmd(unsigned long pfn, pgprot_t pgprot);
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes.patch
mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte.patch
powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write.patch

