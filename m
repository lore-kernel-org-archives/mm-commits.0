From: akpm@linux-foundation.org
Subject: + mm-do-not-lose-dirty-and-access-bits-in-pmdp_invalidate.patch
 added to -mm tree
Date: Wed, 13 Dec 2017 16:11:39 -0800
Message-ID: <5a31c1bb.cJbENymvjoMFiEs7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56996 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751090AbdLNALl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Dec 2017 19:11:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, davem@davemloft.net, david.daney@cavium.com, hpa@zytor.com, hughd@google.com, mhocko@kernel.org, mingo@kernel.org, nitin.m.gupta@oracle.com, ralf@linux-mips.org, schwidefsky@de.ibm.com, tglx@linutronix.de, vbabka@suse.cz, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not lose dirty and accessed bits in pmdp_invalidate()
has been added to the -mm tree.  Its filename is
     mm-do-not-lose-dirty-and-access-bits-in-pmdp_invalidate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-do-not-lose-dirty-and-access-bits-in-pmdp_invalidate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-do-not-lose-dirty-and-access-bits-in-pmdp_invalidate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

asm-generic-provide-generic_pmdp_establish.patch
arc-use-generic_pmdp_establish-as-pmdp_establish.patch
arm-mm-provide-pmdp_establish-helper.patch
mips-use-generic_pmdp_establish-as-pmdp_establish.patch
x86-mm-provide-pmdp_establish-helper.patch
mm-do-not-lose-dirty-and-access-bits-in-pmdp_invalidate.patch
mm-use-updated-pmdp_invalidate-interface-to-track-dirty-accessed-bits.patch

