From: akpm@linux-foundation.org
Subject: + i386-pte-simplify-ops.patch added to -mm tree
Date: Fri, 13 Apr 2007 12:02:08 -0700
Message-ID: <200704131902.l3DJ28WO007067@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46563 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143AbXDMTCK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 15:02:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach@vmware.com


The patch titled
     i386: pte simplify ops
has been added to the -mm tree.  Its filename is
     i386-pte-simplify-ops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: pte simplify ops
From: Zachary Amsden <zach@vmware.com>

Add comment and condense code to make use of native_local_ptep_get_and_clear
function.  Also, it turns out the 2-level and 3-level paging definitions were
identical, so move the common definition into pgtable.h

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/pgtable-2level.h |   10 ----------
 include/asm-i386/pgtable-3level.h |   10 ----------
 include/asm-i386/pgtable.h        |   17 +++++++++++++++--
 3 files changed, 15 insertions(+), 22 deletions(-)

diff -puN include/asm-i386/pgtable-2level.h~i386-pte-simplify-ops include/asm-i386/pgtable-2level.h
--- a/include/asm-i386/pgtable-2level.h~i386-pte-simplify-ops
+++ a/include/asm-i386/pgtable-2level.h
@@ -41,16 +41,6 @@ static inline void native_pte_clear(stru
 	*xp = __pte(0);
 }
 
-/* local pte updates need not use xchg for locking */
-static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
-{
-	pte_t res;
-
-	res = *ptep;
-	native_pte_clear(NULL, 0, ptep);
-	return res;
-}
-
 #ifdef CONFIG_SMP
 static inline pte_t native_ptep_get_and_clear(pte_t *xp)
 {
diff -puN include/asm-i386/pgtable-3level.h~i386-pte-simplify-ops include/asm-i386/pgtable-3level.h
--- a/include/asm-i386/pgtable-3level.h~i386-pte-simplify-ops
+++ a/include/asm-i386/pgtable-3level.h
@@ -139,16 +139,6 @@ static inline void pud_clear (pud_t * pu
 #define pmd_offset(pud, address) ((pmd_t *) pud_page(*(pud)) + \
 			pmd_index(address))
 
-/* local pte updates need not use xchg for locking */
-static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
-{
-	pte_t res;
-
-	res = *ptep;
-	native_pte_clear(NULL, 0, ptep);
-	return res;
-}
-
 #ifdef CONFIG_SMP
 static inline pte_t native_ptep_get_and_clear(pte_t *ptep)
 {
diff -puN include/asm-i386/pgtable.h~i386-pte-simplify-ops include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~i386-pte-simplify-ops
+++ a/include/asm-i386/pgtable.h
@@ -269,6 +269,16 @@ extern void vmalloc_sync_all(void);
 #define pte_update_defer(mm, addr, ptep)	do { } while (0)
 #endif
 
+/* local pte updates need not use xchg for locking */
+static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
+{
+	pte_t res = *ptep;
+
+	/* Pure native function needs no input for mm, addr */
+	native_pte_clear(NULL, 0, ptep);
+	return res;
+}
+
 /*
  * We only update the dirty/accessed state if we set
  * the dirty bit by hand in the kernel, since the hardware
@@ -343,8 +353,11 @@ static inline pte_t ptep_get_and_clear_f
 {
 	pte_t pte;
 	if (full) {
-		pte = *ptep;
-		native_pte_clear(mm, addr, ptep);
+		/*
+		 * Full address destruction in progress; paravirt does not
+		 * care about updates and native needs no locking
+		 */
+		pte = native_local_ptep_get_and_clear(ptep);
 	} else {
 		pte = ptep_get_and_clear(mm, addr, ptep);
 	}
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
