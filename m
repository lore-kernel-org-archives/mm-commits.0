From: akpm@linux-foundation.org
Subject: +
 powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write-v3.patch added to -mm tree
Date: Tue, 21 Feb 2017 14:06:37 -0800
Message-ID: <58acb9ed.vYBhrVECOqu/f0HB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40576 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751906AbdBUWGj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Feb 2017 17:06:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, mgorman@techsingularity.net, michaele@au1.ibm.com, mikey@neuling.org, paulus@samba.org, riel@surriel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write-v3
has been added to the -mm tree.  Its filename is
     powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write-v3.patch

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
Subject: powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write-v3

Link: http://lkml.kernel.org/r/1487498625-10891-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Michael Neuling <mikey@neuling.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <michaele@au1.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/mmu-hash.h |    3 
 arch/powerpc/include/asm/book3s/64/pgtable.h  |   76 +++++++++-------
 2 files changed, 43 insertions(+), 36 deletions(-)

diff -puN arch/powerpc/include/asm/book3s/64/mmu-hash.h~powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write-v3 arch/powerpc/include/asm/book3s/64/mmu-hash.h
--- a/arch/powerpc/include/asm/book3s/64/mmu-hash.h~powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write-v3
+++ a/arch/powerpc/include/asm/book3s/64/mmu-hash.h
@@ -16,9 +16,6 @@
 #include <asm/page.h>
 #include <asm/bug.h>
 
-#ifndef __ASSEMBLY__
-#include <linux/mmdebug.h>
-#endif
 /*
  * This is necessary to get the definition of PGTABLE_RANGE which we
  * need for various slices related matters. Note that this isn't the
diff -puN arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write-v3 arch/powerpc/include/asm/book3s/64/pgtable.h
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write-v3
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1,6 +1,9 @@
 #ifndef _ASM_POWERPC_BOOK3S_64_PGTABLE_H_
 #define _ASM_POWERPC_BOOK3S_64_PGTABLE_H_
 
+#ifndef __ASSEMBLY__
+#include <linux/mmdebug.h>
+#endif
 /*
  * Common bits between hash and Radix page table
  */
@@ -417,15 +420,47 @@ static inline pte_t pte_clear_soft_dirty
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
 #ifdef CONFIG_NUMA_BALANCING
-/*
- * These work without NUMA balancing but the kernel does not care. See the
- * comment in include/asm-generic/pgtable.h . On powerpc, this will only
- * work for user pages and always return true for kernel pages.
- */
 static inline int pte_protnone(pte_t pte)
 {
-	return (pte_raw(pte) & cpu_to_be64(_PAGE_PRESENT | _PAGE_RWX)) ==
-		cpu_to_be64(_PAGE_PRESENT);
+	return (pte_raw(pte) & cpu_to_be64(_PAGE_PRESENT | _PAGE_PTE | _PAGE_RWX)) ==
+		cpu_to_be64(_PAGE_PRESENT | _PAGE_PTE);
+}
+
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
+#define pte_clear_savedwrite pte_clear_savedwrite
+static inline pte_t pte_clear_savedwrite(pte_t pte)
+{
+	/*
+	 * Used by KSM subsystem to make a protnone pte readonly.
+	 */
+	VM_BUG_ON(!pte_protnone(pte));
+	return __pte(pte_val(pte) | _PAGE_PRIVILEGED);
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
+	VM_BUG_ON(!pte_protnone(pte));
+	return !(pte_raw(pte) & cpu_to_be64(_PAGE_RWX | _PAGE_PRIVILEGED));
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
@@ -495,32 +530,6 @@ static inline pte_t pte_mkhuge(pte_t pte
 	return pte;
 }
 
-#define pte_mk_savedwrite pte_mk_savedwrite
-static inline pte_t pte_mk_savedwrite(pte_t pte)
-{
-	/*
-	 * Used by Autonuma subsystem to preserve the write bit
-	 * while marking the pte PROT_NONE. Only allow this
-	 * on PROT_NONE pte
-	 */
-	VM_BUG_ON((pte_raw(pte) & cpu_to_be64(_PAGE_PRESENT | _PAGE_RWX | _PAGE_PRIVILEGED)) !=
-		  cpu_to_be64(_PAGE_PRESENT | _PAGE_PRIVILEGED));
-	return __pte(pte_val(pte) & ~_PAGE_PRIVILEGED);
-}
-
-#define pte_savedwrite pte_savedwrite
-static inline bool pte_savedwrite(pte_t pte)
-{
-	/*
-	 * Saved write ptes are prot none ptes that doesn't have
-	 * privileged bit sit. We mark prot none as one which has
-	 * present and pviliged bit set and RWX cleared. To mark
-	 * protnone which used to have _PAGE_WRITE set we clear
-	 * the privileged bit.
-	 */
-	return !(pte_raw(pte) & cpu_to_be64(_PAGE_RWX | _PAGE_PRIVILEGED));
-}
