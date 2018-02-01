From: akpm@linux-foundation.org
Subject: [merged]
 sparc64-update-pmdp_invalidate-to-return-old-pmd-value.patch removed from
 -mm tree
Date: Thu, 01 Feb 2018 11:32:24 -0800
Message-ID: <20180201193224.2HfIS_ubA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58640 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753556AbeBATc0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:32:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, davem@davemloft.net, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mm-commits@vger.kernel.org, nitin.m.gupta@oracle.com, vbabka@suse.cz


The patch titled
     Subject: sparc64: update pmdp_invalidate() to return old pmd value
has been removed from the -mm tree.  Its filename was
     sparc64-update-pmdp_invalidate-to-return-old-pmd-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nitin Gupta <nitin.m.gupta@oracle.com>
Subject: sparc64: update pmdp_invalidate() to return old pmd value

It's required to avoid losing dirty and accessed bits.

[akpm@linux-foundation.org: add a `do' to the do-while loop]
Link: http://lkml.kernel.org/r/20171213105756.69879-9-kirill.shutemov@linux.intel.com
Signed-off-by: Nitin Gupta <nitin.m.gupta@oracle.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: David Miller <davem@davemloft.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_64.h |    2 +-
 arch/sparc/mm/tlb.c                 |   23 ++++++++++++++++++-----
 2 files changed, 19 insertions(+), 6 deletions(-)

diff -puN arch/sparc/include/asm/pgtable_64.h~sparc64-update-pmdp_invalidate-to-return-old-pmd-value arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~sparc64-update-pmdp_invalidate-to-return-old-pmd-value
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -1010,7 +1010,7 @@ void update_mmu_cache_pmd(struct vm_area
 			  pmd_t *pmd);
 
 #define __HAVE_ARCH_PMDP_INVALIDATE
-extern void pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
+extern pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 			    pmd_t *pmdp);
 
 #define __HAVE_ARCH_PGTABLE_DEPOSIT
diff -puN arch/sparc/mm/tlb.c~sparc64-update-pmdp_invalidate-to-return-old-pmd-value arch/sparc/mm/tlb.c
--- a/arch/sparc/mm/tlb.c~sparc64-update-pmdp_invalidate-to-return-old-pmd-value
+++ a/arch/sparc/mm/tlb.c
@@ -219,17 +219,28 @@ void set_pmd_at(struct mm_struct *mm, un
 	}
 }
 
+static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp, pmd_t pmd)
+{
+	pmd_t old;
+
+	do {
+		old = *pmdp;
+	} while (cmpxchg64(&pmdp->pmd, old.pmd, pmd.pmd) != old.pmd);
+
+	return old;
+}
+
 /*
  * This routine is only called when splitting a THP
  */
-void pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
+pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 		     pmd_t *pmdp)
 {
-	pmd_t entry = *pmdp;
