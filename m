From: akpm@linux-foundation.org
Subject: - i386-pte-xchg-optimization.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:55:35 -0700
Message-ID: <200704281055.l3SAtZd0020188@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965764AbXD1Kzh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     i386: pte xchg optimization
has been removed from the -mm tree.  Its filename was
     i386-pte-xchg-optimization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: pte xchg optimization
From: Zachary Amsden <zach@vmware.com>

In situations where page table updates need only be made locally, and there is
no cross-processor A/D bit races involved, we need not use the heavyweight
xchg instruction to atomically fetch and clear page table entries.  Instead,
we can just read and clear them directly.

This introduces a neat optimization for non-SMP kernels; drop the atomic xchg
operations from page table updates.

Thanks to Michel Lespinasse for noting this potential optimization.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/pgtable-2level.h |   14 ++++++++++++++
 include/asm-i386/pgtable-3level.h |   14 ++++++++++++++
 2 files changed, 28 insertions(+)

diff -puN include/asm-i386/pgtable-2level.h~i386-pte-xchg-optimization include/asm-i386/pgtable-2level.h
--- a/include/asm-i386/pgtable-2level.h~i386-pte-xchg-optimization
+++ a/include/asm-i386/pgtable-2level.h
@@ -41,10 +41,24 @@ static inline void native_pte_clear(stru
 	*xp = __pte(0);
 }
 
+/* local pte updates need not use xchg for locking */
+static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
+{
+	pte_t res;
+
+	res = *ptep;
+	native_pte_clear(NULL, 0, ptep);
+	return res;
+}
+
+#ifdef CONFIG_SMP
 static inline pte_t native_ptep_get_and_clear(pte_t *xp)
 {
 	return __pte(xchg(&xp->pte_low, 0));
 }
+#else
+#define native_ptep_get_and_clear(xp) native_local_ptep_get_and_clear(xp)
+#endif
 
 #define pte_page(x)		pfn_to_page(pte_pfn(x))
 #define pte_none(x)		(!(x).pte_low)
diff -puN include/asm-i386/pgtable-3level.h~i386-pte-xchg-optimization include/asm-i386/pgtable-3level.h
--- a/include/asm-i386/pgtable-3level.h~i386-pte-xchg-optimization
+++ a/include/asm-i386/pgtable-3level.h
@@ -139,6 +139,17 @@ static inline void pud_clear (pud_t * pu
 #define pmd_offset(pud, address) ((pmd_t *) pud_page(*(pud)) + \
 			pmd_index(address))
 
+/* local pte updates need not use xchg for locking */
+static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
+{
+	pte_t res;
+
+	res = *ptep;
+	native_pte_clear(NULL, 0, ptep);
+	return res;
+}
+
+#ifdef CONFIG_SMP
 static inline pte_t native_ptep_get_and_clear(pte_t *ptep)
 {
 	pte_t res;
@@ -150,6 +161,9 @@ static inline pte_t native_ptep_get_and_
 
 	return res;
 }
+#else
+#define native_ptep_get_and_clear(xp) native_local_ptep_get_and_clear(xp)
+#endif
 
 #define __HAVE_ARCH_PTE_SAME
 static inline int pte_same(pte_t a, pte_t b)
_

Patches currently in -mm which might be from zach@vmware.com are

git-acpi.patch
fix-buslogic-to-stop-using-check_region.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
