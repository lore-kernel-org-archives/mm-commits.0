From: akpm@linux-foundation.org
Subject: [merged]
 mm-replace-pmd_write-with-pmd_access_permitted-in-fault-gup-paths.patch
 removed from -mm tree
Date: Thu, 30 Nov 2017 12:18:21 -0800
Message-ID: <20171130201821.saTm4g6Go%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51668 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751346AbdK3USX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:18:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dave.hansen@intel.com, jglisse@redhat.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: replace pmd_write with pmd_access_permitted in fault + gup paths
has been removed from the -mm tree.  Its filename was
     mm-replace-pmd_write-with-pmd_access_permitted-in-fault-gup-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: replace pmd_write with pmd_access_permitted in fault + gup paths

The 'access_permitted' helper is used in the gup-fast path and goes beyond
the simple _PAGE_RW check to also:

* validate that the mapping is writable from a protection keys
  standpoint

* validate that the pte has _PAGE_USER set since all fault paths where
  pmd_write is must be referencing user-memory.

Link: http://lkml.kernel.org/r/151043111049.2842.15241454964150083466.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/gup.c |    2 +-
 fs/dax.c            |    3 ++-
 mm/hmm.c            |    4 ++--
 mm/huge_memory.c    |    4 ++--
 mm/memory.c         |    2 +-
 5 files changed, 8 insertions(+), 7 deletions(-)

diff -puN arch/sparc/mm/gup.c~mm-replace-pmd_write-with-pmd_access_permitted-in-fault-gup-paths arch/sparc/mm/gup.c
--- a/arch/sparc/mm/gup.c~mm-replace-pmd_write-with-pmd_access_permitted-in-fault-gup-paths
+++ a/arch/sparc/mm/gup.c
@@ -75,7 +75,7 @@ static int gup_huge_pmd(pmd_t *pmdp, pmd
 	if (!(pmd_val(pmd) & _PAGE_VALID))
 		return 0;
 
-	if (write && !pmd_write(pmd))
+	if (!pmd_access_permitted(pmd, write))
 		return 0;
 
 	refs = 0;
diff -puN fs/dax.c~mm-replace-pmd_write-with-pmd_access_permitted-in-fault-gup-paths fs/dax.c
--- a/fs/dax.c~mm-replace-pmd_write-with-pmd_access_permitted-in-fault-gup-paths
+++ a/fs/dax.c
@@ -627,7 +627,8 @@ static void dax_mapping_entry_mkclean(st
 
 			if (pfn != pmd_pfn(*pmdp))
 				goto unlock_pmd;
-			if (!pmd_dirty(*pmdp) && !pmd_write(*pmdp))
+			if (!pmd_dirty(*pmdp)
+					&& !pmd_access_permitted(*pmdp, WRITE))
 				goto unlock_pmd;
 
 			flush_cache_page(vma, address, pfn);
diff -puN mm/hmm.c~mm-replace-pmd_write-with-pmd_access_permitted-in-fault-gup-paths mm/hmm.c
--- a/mm/hmm.c~mm-replace-pmd_write-with-pmd_access_permitted-in-fault-gup-paths
+++ a/mm/hmm.c
@@ -391,11 +391,11 @@ again:
 		if (pmd_protnone(pmd))
 			return hmm_vma_walk_clear(start, end, walk);
 
-		if (write_fault && !pmd_write(pmd))
+		if (!pmd_access_permitted(pmd, write_fault))
 			return hmm_vma_walk_clear(start, end, walk);
 
 		pfn = pmd_pfn(pmd) + pte_index(addr);
-		flag |= pmd_write(pmd) ? HMM_PFN_WRITE : 0;
+		flag |= pmd_access_permitted(pmd, WRITE) ? HMM_PFN_WRITE : 0;
 		for (; addr < end; addr += PAGE_SIZE, i++, pfn++)
 			pfns[i] = hmm_pfn_t_from_pfn(pfn) | flag;
 		return 0;
diff -puN mm/huge_memory.c~mm-replace-pmd_write-with-pmd_access_permitted-in-fault-gup-paths mm/huge_memory.c
--- a/mm/huge_memory.c~mm-replace-pmd_write-with-pmd_access_permitted-in-fault-gup-paths
+++ a/mm/huge_memory.c
@@ -877,7 +877,7 @@ struct page *follow_devmap_pmd(struct vm
 	 */
 	WARN_ONCE(flags & FOLL_COW, "mm: In follow_devmap_pmd with FOLL_COW set");
 
-	if (flags & FOLL_WRITE && !pmd_write(*pmd))
+	if (!pmd_access_permitted(*pmd, flags & FOLL_WRITE))
 		return NULL;
 
 	if (pmd_present(*pmd) && pmd_devmap(*pmd))
@@ -1393,7 +1393,7 @@ out_unlock:
  */
 static inline bool can_follow_write_pmd(pmd_t pmd, unsigned int flags)
 {
-	return pmd_write(pmd) ||
+	return pmd_access_permitted(pmd, WRITE) ||
 	       ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_dirty(pmd));
 }
 
diff -puN mm/memory.c~mm-replace-pmd_write-with-pmd_access_permitted-in-fault-gup-paths mm/memory.c
--- a/mm/memory.c~mm-replace-pmd_write-with-pmd_access_permitted-in-fault-gup-paths
+++ a/mm/memory.c
@@ -4046,7 +4046,7 @@ static int __handle_mm_fault(struct vm_a
 			if (pmd_protnone(orig_pmd) && vma_is_accessible(vma))
 				return do_huge_pmd_numa_page(&vmf, orig_pmd);
 
-			if (dirty && !pmd_write(orig_pmd)) {
+			if (dirty && !pmd_access_permitted(orig_pmd, WRITE)) {
 				ret = wp_huge_pmd(&vmf, orig_pmd);
 				if (!(ret & VM_FAULT_FALLBACK))
 					return ret;
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


