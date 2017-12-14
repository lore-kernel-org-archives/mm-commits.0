From: akpm@linux-foundation.org
Subject: + sparc64-update-pmdp_invalidate-to-return-old-pmd-value.patch
 added to -mm tree
Date: Wed, 13 Dec 2017 16:11:27 -0800
Message-ID: <5a31c1af.mLXBDyjbfTrdSgAI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56912 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdLNAL2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Dec 2017 19:11:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nitin.m.gupta@oracle.com, aarcange@redhat.com, davem@davemloft.net, kirill.shutemov@linux.intel.com, mhocko@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc64: update pmdp_invalidate() to return old pmd value
has been added to the -mm tree.  Its filename is
     sparc64-update-pmdp_invalidate-to-return-old-pmd-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparc64-update-pmdp_invalidate-to-return-old-pmd-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sparc64-update-pmdp_invalidate-to-return-old-pmd-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nitin Gupta <nitin.m.gupta@oracle.com>
Subject: sparc64: update pmdp_invalidate() to return old pmd value

It's required to avoid losing dirty and accessed bits.

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
+	{
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
