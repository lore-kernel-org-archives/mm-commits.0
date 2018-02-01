From: akpm@linux-foundation.org
Subject: [merged]
 mm-do-not-lose-dirty-and-access-bits-in-pmdp_invalidate.patch removed from
 -mm tree
Date: Thu, 01 Feb 2018 11:32:31 -0800
Message-ID: <20180201193231.jwJWXVXza%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58682 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753384AbeBATcd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:32:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, davem@davemloft.net, david.daney@cavium.com, hpa@zytor.com, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, nitin.m.gupta@oracle.com, ralf@linux-mips.org, schwidefsky@de.ibm.com, tglx@linutronix.de, vbabka@suse.cz, vgupta@synopsys.com


The patch titled
     Subject: mm: do not lose dirty and accessed bits in pmdp_invalidate()
has been removed from the -mm tree.  Its filename was
     mm-do-not-lose-dirty-and-access-bits-in-pmdp_invalidate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: do not lose dirty and accessed bits in pmdp_invalidate()

Vlastimil noted that pmdp_invalidate() is not atomic and we can lose dirty
and access bits if CPU sets them after pmdp dereference, but before
set_pmd_at().

The patch change pmdp_invalidate() to make the entry non-present
atomically and return previous value of the entry.  This value can be used
to check if CPU set dirty/accessed bits under us.

The race window is very small and I haven't seen any reports that can be
attributed to the bug.  For this reason, I don't think backporting to
stable trees needed.

Link: http://lkml.kernel.org/r/20171213105756.69879-11-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Daney <david.daney@cavium.com>
Cc: David Miller <davem@davemloft.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nitin Gupta <nitin.m.gupta@oracle.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |    2 +-
 mm/pgtable-generic.c          |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/asm-generic/pgtable.h~mm-do-not-lose-dirty-and-access-bits-in-pmdp_invalidate include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-do-not-lose-dirty-and-access-bits-in-pmdp_invalidate
+++ a/include/asm-generic/pgtable.h
@@ -325,7 +325,7 @@ static inline pmd_t generic_pmdp_establi
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_INVALIDATE
-extern void pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
+extern pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 			    pmd_t *pmdp);
 #endif
 
diff -puN mm/pgtable-generic.c~mm-do-not-lose-dirty-and-access-bits-in-pmdp_invalidate mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-do-not-lose-dirty-and-access-bits-in-pmdp_invalidate
+++ a/mm/pgtable-generic.c
@@ -181,12 +181,12 @@ pgtable_t pgtable_trans_huge_withdraw(st
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_INVALIDATE
-void pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
+pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 		     pmd_t *pmdp)
 {
-	pmd_t entry = *pmdp;
-	set_pmd_at(vma->vm_mm, address, pmdp, pmd_mknotpresent(entry));
+	pmd_t old = pmdp_establish(vma, address, pmdp, pmd_mknotpresent(*pmdp));
 	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
+	return old;
 }
 #endif
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


