From: akpm@linux-foundation.org
Subject: - i386-pte-clear-optimization.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:55:33 -0700
Message-ID: <200704281055.l3SAtXlA020185@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965760AbXD1Kzf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:55:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     i386: pte clear optimization
has been removed from the -mm tree.  Its filename was
     i386-pte-clear-optimization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-acpi.patch
fix-buslogic-to-stop-using-check_region.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
