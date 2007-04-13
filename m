From: akpm@linux-foundation.org
Subject: + i386-pte-clear-optimization.patch added to -mm tree
Date: Fri, 13 Apr 2007 12:02:04 -0700
Message-ID: <200704131902.l3DJ24LV007061@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46550 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137AbXDMTCG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 15:02:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach@vmware.com


The patch titled
     i386: pte clear optimization
has been added to the -mm tree.  Its filename is
     i386-pte-clear-optimization.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: pte clear optimization
From: Zachary Amsden <zach@vmware.com>

When exiting from an address space, no special hypervisor notification of page
table updates needs to occur; direct page table hypervisors, such as Xen,
switch to another address space first (init_mm) and unprotects the page tables
to avoid the cost of trapping to the hypervisor for each pte_clear.  Shadow
mode hypervisors, such as VMI and lhype don't need to do the extra work of
calling through paravirt-ops, and can just directly clear the page table
entries without notifiying the hypervisor, since all the page tables are about
to be freed.

So introduce native_pte_clear functions which bypass any paravirt-ops
notification.  This results in a significant performance win for VMI and
removes some indirect calls from zap_pte_range.

Note the 3-level paging already had a native_pte_clear function, thus
demanding argument conformance and extra args for the 2-level definition.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/pgtable-2level.h |    5 +++++
 include/asm-i386/pgtable.h        |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN include/asm-i386/pgtable-2level.h~i386-pte-clear-optimization include/asm-i386/pgtable-2level.h
--- a/include/asm-i386/pgtable-2level.h~i386-pte-clear-optimization
+++ a/include/asm-i386/pgtable-2level.h
@@ -36,6 +36,11 @@ static inline void native_set_pmd(pmd_t 
 #define pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
 #define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
 
+static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *xp)
+{
+	*xp = __pte(0);
+}
+
 static inline pte_t native_ptep_get_and_clear(pte_t *xp)
 {
 	return __pte(xchg(&xp->pte_low, 0));
diff -puN include/asm-i386/pgtable.h~i386-pte-clear-optimization include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~i386-pte-clear-optimization
+++ a/include/asm-i386/pgtable.h
@@ -344,7 +344,7 @@ static inline pte_t ptep_get_and_clear_f
 	pte_t pte;
 	if (full) {
 		pte = *ptep;
-		pte_clear(mm, addr, ptep);
+		native_pte_clear(mm, addr, ptep);
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
