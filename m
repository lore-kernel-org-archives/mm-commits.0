From: akpm@linux-foundation.org
Subject: + i386-pte-xchg-optimization.patch added to -mm tree
Date: Fri, 13 Apr 2007 12:02:06 -0700
Message-ID: <200704131902.l3DJ26aR007064@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46557 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbXDMTCI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 15:02:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach@vmware.com


The patch titled
     i386: pte xchg optimization
has been added to the -mm tree.  Its filename is
     i386-pte-xchg-optimization.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
vmi-logic-error.patch
fix-buslogic-to-stop-using-check_region.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
paravirt_ops-update-maintainers.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-add-common-patching-machinery.patch
paravirt_ops-revert-map_pt_hook.patch
paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages.patch
i386-relocate-vdso-elf-headers-to-match-mapped-location-with-compat_vdso.patch
i386-make-compat_vdso-runtime-selectable.patch
i386-sysenter-arch-pages-fix.patch
i386-acpi-remove-earlyquirk-warning.patch
i386-mcheck-p4-grotesque-and-needless-warning-fix.patch
i386-pgd-clone-under-lock-fix.patch
vmi-supports-compat-vdso.patch
resurrect-the-vmi-lazy-mode-fixes.patch
resurrect-the-vmi-lazy-mode-fixes-fix.patch
vmi-kmap_atomic_pte-fix.patch
vmi-timer-update.patch
i386-pte-drop-ptep_get_and_clear-paravirt-op.patch
i386-pte-clear-optimization.patch
i386-pte-xchg-optimization.patch
i386-pte-simplify-ops.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
