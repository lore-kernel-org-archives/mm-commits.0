From: akpm@linux-foundation.org
Subject: + numa-fix-proc-pid-numa_maps-for-thp.patch added to -mm tree
Date: Tue, 05 Apr 2016 13:20:35 -0700
Message-ID: <57041e13.PZLyaLPSKjuUsyPG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbcDEUUh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 16:20:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerald.schaefer@de.ibm.com, dan.j.williams@intel.com, dave.hansen@intel.com, hannes@cmpxchg.org, heiko.carstens@de.ibm.com, holzheu@linux.vnet.ibm.com, jmarchan@redhat.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mgorman@suse.de, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, schwidefsky@de.ibm.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: numa: fix /proc/<pid>/numa_maps for THP
has been added to the -mm tree.  Its filename is
     numa-fix-proc-pid-numa_maps-for-thp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/numa-fix-proc-pid-numa_maps-for-thp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/numa-fix-proc-pid-numa_maps-for-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: numa: fix /proc/<pid>/numa_maps for THP

In gather_pte_stats() a THP pmd is cast into a pte, which is wrong because
the layouts may differ depending on the architecture.  On s390 this will
lead to inaccurate numa_maps accounting in /proc because of misguided
pte_present() and pte_dirty() checks on the fake pte.

On other architectures pte_present() and pte_dirty() may work by chance,
but there may be an issue with direct-access (dax) mappings w/o underlying
struct pages when HAVE_PTE_SPECIAL is set and THP is available.  In
vm_normal_page() the fake pte will be checked with pte_special() and
because there is no "special" bit in a pmd, this will always return false
and the VM_PFNMAP | VM_MIXEDMAP checking will be skipped.  On dax mappings
w/o struct pages, an invalid struct page pointer would then be returned
that can crash the kernel.

This patch fixes the numa_maps THP handling by introducing new "_pmd" variants
of the can_gather_numa_stats() and vm_normal_page() functions.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>	[4.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   33 ++++++++++++++++++++++++++++++---
 include/linux/mm.h |    2 ++
 mm/memory.c        |   40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+), 3 deletions(-)

diff -puN fs/proc/task_mmu.c~numa-fix-proc-pid-numa_maps-for-thp fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~numa-fix-proc-pid-numa_maps-for-thp
+++ a/fs/proc/task_mmu.c
@@ -1518,6 +1518,32 @@ static struct page *can_gather_numa_stat
 	return page;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static struct page *can_gather_numa_stats_pmd(pmd_t pmd,
+					      struct vm_area_struct *vma,
+					      unsigned long addr)
+{
+	struct page *page;
+	int nid;
+
+	if (!pmd_present(pmd))
+		return NULL;
+
+	page = vm_normal_page_pmd(vma, addr, pmd);
+	if (!page)
+		return NULL;
+
+	if (PageReserved(page))
+		return NULL;
+
+	nid = page_to_nid(page);
+	if (!node_isset(nid, node_states[N_MEMORY]))
+		return NULL;
+
+	return page;
+}
+#endif
+
 static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
 		unsigned long end, struct mm_walk *walk)
 {
@@ -1527,14 +1553,14 @@ static int gather_pte_stats(pmd_t *pmd,
 	pte_t *orig_pte;
 	pte_t *pte;
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
-		pte_t huge_pte = *(pte_t *)pmd;
 		struct page *page;
 
-		page = can_gather_numa_stats(huge_pte, vma, addr);
+		page = can_gather_numa_stats_pmd(*pmd, vma, addr);
 		if (page)
-			gather_stats(page, md, pte_dirty(huge_pte),
+			gather_stats(page, md, pmd_dirty(*pmd),
 				     HPAGE_PMD_SIZE/PAGE_SIZE);
 		spin_unlock(ptl);
 		return 0;
@@ -1542,6 +1568,7 @@ static int gather_pte_stats(pmd_t *pmd,
 
 	if (pmd_trans_unstable(pmd))
 		return 0;
+#endif
 	orig_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
 	do {
 		struct page *page = can_gather_numa_stats(*pte, vma, addr);
diff -puN include/linux/mm.h~numa-fix-proc-pid-numa_maps-for-thp include/linux/mm.h
--- a/include/linux/mm.h~numa-fix-proc-pid-numa_maps-for-thp
+++ a/include/linux/mm.h
@@ -1140,6 +1140,8 @@ struct zap_details {
 
 struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 		pte_t pte);
+struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
+				pmd_t pmd);
 
 int zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size);
diff -puN mm/memory.c~numa-fix-proc-pid-numa_maps-for-thp mm/memory.c
--- a/mm/memory.c~numa-fix-proc-pid-numa_maps-for-thp
+++ a/mm/memory.c
@@ -789,6 +789,46 @@ out:
 	return pfn_to_page(pfn);
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
+				pmd_t pmd)
+{
+	unsigned long pfn = pmd_pfn(pmd);
+
+	/*
+	 * There is no pmd_special() but there may be special pmds, e.g.
+	 * in a direct-access (dax) mapping, so let's just replicate the
+	 * !HAVE_PTE_SPECIAL case from vm_normal_page() here.
+	 */
+	if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
+		if (vma->vm_flags & VM_MIXEDMAP) {
+			if (!pfn_valid(pfn))
+				return NULL;
+			goto out;
+		} else {
+			unsigned long off;
+			off = (addr - vma->vm_start) >> PAGE_SHIFT;
+			if (pfn == vma->vm_pgoff + off)
+				return NULL;
+			if (!is_cow_mapping(vma->vm_flags))
+				return NULL;
+		}
+	}
+
+	if (is_zero_pfn(pfn))
+		return NULL;
+	if (unlikely(pfn > highest_memmap_pfn))
+		return NULL;
+
+	/*
+	 * NOTE! We still have PageReserved() pages in the page tables.
+	 * eg. VDSO mappings can cause them to exist.
+	 */
+out:
+	return pfn_to_page(pfn);
+}
+#endif
+
 /*
  * copy one vm_area from one task to the other. Assumes the page tables
  * already present in the new task to be cleared in the whole range
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

numa-fix-proc-pid-numa_maps-for-thp.patch

