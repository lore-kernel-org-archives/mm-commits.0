From: akpm@linux-foundation.org
Subject: +
 mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions.patch added
 to -mm tree
Date: Fri, 22 May 2015 12:28:56 -0700
Message-ID: <555f8378.KfdISIzXty5AK13C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47012 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104AbbEVT25 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 May 2015 15:28:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, benh@kernel.crashing.org, kirill.shutemov@linux.intel.com, mpe@ellerman.id.au, paulus@samba.org, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: split out pmd collapse flush into separate functions
has been added to the -mm tree.  Its filename is
     mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions.patch

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
Subject: mm/thp: split out pmd collapse flush into separate functions

Architectures like ppc64 [1] need to do special things while clearing pmd
before a collapse.  For them this operation is largely different from a
normal hugepage pte clear.  Hence add a separate function to clear pmd
before collapse.  After this patch pmdp_* functions operate only on
hugepage pte, and not on regular pmd_t values pointing to page table.

[1] ppc64 needs to invalidate all the normal page pte mappings we already
have inserted in the hardware hash page table.  But before doing that we
need to make sure there are no parallel hash page table insert going on. 
So we need to do a kick_all_cpus_sync() before flushing the older hash
table entries.  By moving this to a separate function we capture these
details and mention how it is different from a hugepage pte clear.

This patch is a cleanup and only does code movement for clarity.  There
should not be any change in functionality.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/pgtable-ppc64.h |    4 +
 arch/powerpc/mm/pgtable_64.c             |   76 +++++++++++----------
 include/asm-generic/pgtable.h            |   21 +++++
 mm/huge_memory.c                         |    2 
 4 files changed, 67 insertions(+), 36 deletions(-)

diff -puN arch/powerpc/include/asm/pgtable-ppc64.h~mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions arch/powerpc/include/asm/pgtable-ppc64.h
--- a/arch/powerpc/include/asm/pgtable-ppc64.h~mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions
+++ a/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -576,6 +576,10 @@ static inline void pmdp_set_wrprotect(st
 extern void pmdp_splitting_flush(struct vm_area_struct *vma,
 				 unsigned long address, pmd_t *pmdp);
 
+extern pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
+				 unsigned long address, pmd_t *pmdp);
+#define pmdp_collapse_flush pmdp_collapse_flush
+
 #define __HAVE_ARCH_PGTABLE_DEPOSIT
 extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 				       pgtable_t pgtable);
diff -puN arch/powerpc/mm/pgtable_64.c~mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions arch/powerpc/mm/pgtable_64.c
--- a/arch/powerpc/mm/pgtable_64.c~mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions
+++ a/arch/powerpc/mm/pgtable_64.c
@@ -560,41 +560,47 @@ pmd_t pmdp_clear_flush(struct vm_area_st
 	pmd_t pmd;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-	if (pmd_trans_huge(*pmdp)) {
-		pmd = pmdp_get_and_clear(vma->vm_mm, address, pmdp);
-	} else {
-		/*
-		 * khugepaged calls this for normal pmd
-		 */
-		pmd = *pmdp;
-		pmd_clear(pmdp);
-		/*
-		 * Wait for all pending hash_page to finish. This is needed
-		 * in case of subpage collapse. When we collapse normal pages
-		 * to hugepage, we first clear the pmd, then invalidate all
-		 * the PTE entries. The assumption here is that any low level
-		 * page fault will see a none pmd and take the slow path that
-		 * will wait on mmap_sem. But we could very well be in a
-		 * hash_page with local ptep pointer value. Such a hash page
-		 * can result in adding new HPTE entries for normal subpages.
-		 * That means we could be modifying the page content as we
-		 * copy them to a huge page. So wait for parallel hash_page
-		 * to finish before invalidating HPTE entries. We can do this
-		 * by sending an IPI to all the cpus and executing a dummy
-		 * function there.
-		 */
-		kick_all_cpus_sync();
-		/*
-		 * Now invalidate the hpte entries in the range
-		 * covered by pmd. This make sure we take a
-		 * fault and will find the pmd as none, which will
-		 * result in a major fault which takes mmap_sem and
-		 * hence wait for collapse to complete. Without this
-		 * the __collapse_huge_page_copy can result in copying
-		 * the old content.
-		 */
-		flush_tlb_pmd_range(vma->vm_mm, &pmd, address);
-	}
+	VM_BUG_ON(!pmd_trans_huge(*pmdp));
+	pmd = pmdp_get_and_clear(vma->vm_mm, address, pmdp);
+	return pmd;
+}
+
+pmd_t pmdp_collapse_flush(struct vm_area_struct *vma, unsigned long address,
+			  pmd_t *pmdp)
+{
+	pmd_t pmd;
+
+	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+	VM_BUG_ON(pmd_trans_huge(*pmdp));
+
+	pmd = *pmdp;
+	pmd_clear(pmdp);
+	/*
+	 * Wait for all pending hash_page to finish. This is needed
+	 * in case of subpage collapse. When we collapse normal pages
+	 * to hugepage, we first clear the pmd, then invalidate all
+	 * the PTE entries. The assumption here is that any low level
+	 * page fault will see a none pmd and take the slow path that
+	 * will wait on mmap_sem. But we could very well be in a
+	 * hash_page with local ptep pointer value. Such a hash page
+	 * can result in adding new HPTE entries for normal subpages.
+	 * That means we could be modifying the page content as we
+	 * copy them to a huge page. So wait for parallel hash_page
+	 * to finish before invalidating HPTE entries. We can do this
+	 * by sending an IPI to all the cpus and executing a dummy
+	 * function there.
+	 */
+	kick_all_cpus_sync();
+	/*
+	 * Now invalidate the hpte entries in the range
+	 * covered by pmd. This make sure we take a
+	 * fault and will find the pmd as none, which will
+	 * result in a major fault which takes mmap_sem and
+	 * hence wait for collapse to complete. Without this
+	 * the __collapse_huge_page_copy can result in copying
+	 * the old content.
+	 */
+	flush_tlb_pmd_range(vma->vm_mm, &pmd, address);
 	return pmd;
 }
 
diff -puN include/asm-generic/pgtable.h~mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions
+++ a/include/asm-generic/pgtable.h
@@ -189,6 +189,27 @@ extern void pmdp_splitting_flush(struct
 				 unsigned long address, pmd_t *pmdp);
 #endif
 
+#ifndef pmdp_collapse_flush
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
+					unsigned long address,
+					pmd_t *pmdp)
+{
+	return pmdp_clear_flush(vma, address, pmdp);
+}
+#define pmdp_collapse_flush pmdp_collapse_flush
+#else
+static inline pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
+					unsigned long address,
+					pmd_t *pmdp)
+{
+	BUILD_BUG();
+	return *pmdp;
+}
+#define pmdp_collapse_flush pmdp_collapse_flush
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif
+
 #ifndef __HAVE_ARCH_PGTABLE_DEPOSIT
 extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 				       pgtable_t pgtable);
diff -puN mm/huge_memory.c~mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions
+++ a/mm/huge_memory.c
@@ -2525,7 +2525,7 @@ static void collapse_huge_page(struct mm
 	 * huge and small TLB entries for the same virtual address
 	 * to avoid the risk of CPU bugs in that area.
 	 */
-	_pmd = pmdp_clear_flush(vma, address, pmd);
+	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
tracing-mm-dont-trace-kmem_cache_free-on-offline-cpus.patch
mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions.patch
powerpc-mm-use-generic-version-of-pmdp_clear_flush.patch
mm-clarify-that-the-function-operates-on-hugepage-pte.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch

