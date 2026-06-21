Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D45223328
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782066753; cv=none; b=L2X1P35psrNaTqeJpraL1XxJK8myCwrxG4HgkWlsieTCZcsdSMDAhnbUCdhKvZzvU6XJkCRpkNPaF4ZnIFJ/f9Ey8xxlPRrgaNaRm0NbGRScBYpnPlzMwWVGf+7naCnMUbC4ZP5yYVg1vYQxJYRbNrKBdNlnWkBUFAO9JaDvMN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782066753; c=relaxed/simple;
	bh=pVhlZrGZUtVIu/OOb9GpZF5tmlxUVyzsKXM3c6Pq2dc=;
	h=Date:To:From:Subject:Message-Id; b=twzErclE5GXBug2QqEKJ6fnLKxMdJJFmdQq2c5sm7I2DMywlto4E7Pvx35JwcNNP85HMkCT0B4+C+hcho4gpbe2I0bUGL8nNZPkEpxwt9YgKmm4I3UIqg4jjoxGSzndQITAH/3fljC4c7HcUipKLyPIR9wAgw/OJUcybc0A5DX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=fail (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P5XDg3Qi reason="signature verification failed"; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P5XDg3Qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451451F00A3A;
	Sun, 21 Jun 2026 18:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782066751;
	bh=rhBlAR8inmCJ/iMRTnymr1aOmvcO6IK4T6pdI9hm0Cg=;
	h=Date:To:From:Subject;
	b=P5XDg3QihUvszKl4nJ2WA+ZXcZDCp0RPEo8V7spKRk21Z+ldl44Qd+honnHJYdnf2
	 1FBXbOCQHmh9ApH4XESPCugEXDrumeY7dofjDNHTkx1k9+ZMDHEfwSN1iwJVpwcTs6
	 wCfs/rtABIqka77IAf8wP0v2MUtaV16PlqhLDQeM=
Date: Sun, 21 Jun 2026 11:32:30 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,ying.huang@linux.alibaba.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,vbabka@suse.cz,usama.arif@linux.dev,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,shivankg@amd.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,rientjes@google.com,richard.weiyang@gmail.com,rdunlap@infradead.org,raquini@redhat.com,rakie.kim@sk.com,pfalcato@suse.de,peterx@redhat.com,mhocko@suse.com,mhiramat@kernel.org,matthew.brost@intel.com,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,jack@suse.cz,jackmanb@google.com,hughd@google.com,hannes@cmpxchg.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,bagasdotme@gmail.co
 m,apopple@nvidia.com,anshuman.khandual@arm.com,aarcange@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support.patch removed from -mm tree
Message-Id: <20260621183231.451451F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: generalize __collapse_huge_page_* for mTHP support
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: mm/khugepaged: generalize __collapse_huge_page_* for mTHP support
Date: Fri, 5 Jun 2026 10:14:11 -0600

generalize the order of the __collapse_huge_page_* and collapse_max_*
functions to support future mTHP collapse.

The current mechanism for determining collapse with the
khugepaged_max_ptes_none value is not designed with mTHP in mind.  This
raises a key design issue: if we support user defined max_pte_none values
(even those scaled by order), a collapse of a lower order can introduces
an feedback loop, or "creep", when max_ptes_none is set to a value greater
than HPAGE_PMD_NR / 2.  [1]

With this configuration, a successful collapse to order N will populate
enough pages to satisfy the collapse condition on order N+1 on the next
scan.  This leads to unnecessary work and memory churn.

To fix this issue introduce a helper function that will limit mTHP
collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1. 
This effectively supports two modes: [2]

- max_ptes_none=0: never collapses if it encounters an empty PTE or a PTE
  that maps the shared zeropage. Consequently, no memory bloat.
- max_ptes_none=511 (on 4k pagesz): Always collapse to the highest
  available mTHP order.

This removes the possibility of "creep", and a warning will be emitted if
any non-supported max_ptes_none value is configured with mTHP enabled. 
Any intermediate value will default mTHP collapse to max_ptes_none=0.

mTHP collapse will not honor the khugepaged_max_ptes_shared or
khugepaged_max_ptes_swap parameters, and will fail if it encounters a
shared or swapped entry.

No functional changes in this patch; however it defines future behavior
for mTHP collapse.

Link: https://lore.kernel.org/20260605161422.213817-5-npache@redhat.com
Link: https://lore.kernel.org/all/e46ab3ab-a3d7-4fb7-9970-d0704bd5d05a@arm.com [1]
Link: https://lore.kernel.org/all/37375ace-5601-4d6c-9dac-d1c8268698e9@redhat.com [2]
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Takashi Iwai (SUSE) <tiwai@suse.de>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |  126 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 93 insertions(+), 33 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support
+++ a/mm/khugepaged.c
@@ -353,30 +353,51 @@ static bool pte_none_or_zero(pte_t pte)
  * the shared zeropage for the given collapse operation.
  * @cc: The collapse control struct
  * @vma: The vma to check for userfaultfd
+ * @order: The folio order being collapsed to
  *
  * Return: Maximum number of empty/shared zeropage PTEs for the collapse operation
  */
 static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
-		struct vm_area_struct *vma)
+		struct vm_area_struct *vma, unsigned int order)
 {
+	const unsigned int max_ptes_none = khugepaged_max_ptes_none;
+
 	if (vma && userfaultfd_armed(vma))
 		return 0;
 	/* for MADV_COLLAPSE, allow any empty/shared zeropage PTEs */
 	if (!cc->is_khugepaged)
 		return HPAGE_PMD_NR;
-	/* For all other cases respect the user defined maximum */
-	return khugepaged_max_ptes_none;
+	/* for PMD collapse, respect the user defined maximum */
+	if (is_pmd_order(order))
+		return max_ptes_none;
+	/*
+	 * for mTHP collapse with the sysctl value set to KHUGEPAGED_MAX_PTES_LIMIT,
+	 * scale the maximum number of PTEs to the order of the collapse.
+	 */
+	if (max_ptes_none == KHUGEPAGED_MAX_PTES_LIMIT)
+		return (1 << order) - 1;
+	/*
+	 * For mTHP collapse of values other than 0 or KHUGEPAGED_MAX_PTES_LIMIT,
+	 * emit a warning and return 0.
+	 */
+	if (max_ptes_none)
+		pr_warn_once("mTHP collapse does not support max_ptes_none"
+		     " values other than 0 or %u, defaulting to 0.\n",
+		     KHUGEPAGED_MAX_PTES_LIMIT);
+	return 0;
 }
 
 /**
  * collapse_max_ptes_shared - Calculate maximum allowed PTEs that map shared
  * anonymous pages for the given collapse operation.
  * @cc: The collapse control struct
+ * @order: The folio order being collapsed to
  *
  * Return: Maximum number of PTEs that map shared anonymous pages for the
  * collapse operation
  */
-static unsigned int collapse_max_ptes_shared(struct collapse_control *cc)
+static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
+		unsigned int order)
 {
 	/*
 	 * For MADV_COLLAPSE, do not restrict the number of PTEs that map shared
@@ -384,6 +405,13 @@ static unsigned int collapse_max_ptes_sh
 	 */
 	if (!cc->is_khugepaged)
 		return HPAGE_PMD_NR;
+	/*
+	 * for mTHP collapse do not allow collapsing anonymous memory pages that
+	 * are shared between processes.
+	 */
+	if (!is_pmd_order(order))
+		return 0;
+	/* for PMD collapse, respect the user defined maximum */
 	return khugepaged_max_ptes_shared;
 }
 
@@ -391,11 +419,13 @@ static unsigned int collapse_max_ptes_sh
  * collapse_max_ptes_swap - Calculate the maximum allowed non-present PTEs or the
  * maximum allowed non-present pagecache entries for the given collapse operation.
  * @cc: The collapse control struct
+ * @order: The folio order being collapsed to
  *
  * Return: Maximum number of non-present PTEs or the maximum allowed non-present
  * pagecache entries for the collapse operation.
  */
-static unsigned int collapse_max_ptes_swap(struct collapse_control *cc)
+static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
+		unsigned int order)
 {
 	/*
 	 * For MADV_COLLAPSE, do not restrict the number PTEs entries or
@@ -403,6 +433,10 @@ static unsigned int collapse_max_ptes_sw
 	 */
 	if (!cc->is_khugepaged)
 		return HPAGE_PMD_NR;
+	/* for mTHP collapse do not allow any non-present PTEs or pagecache entries */
+	if (!is_pmd_order(order))
+		return 0;
+	/* for PMD collapse, respect the user defined maximum */
 	return khugepaged_max_ptes_swap;
 }
 
@@ -599,10 +633,11 @@ static void release_pte_pages(pte_t *pte
 
 static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
-		struct list_head *compound_pagelist)
+		unsigned int order, struct list_head *compound_pagelist)
 {
-	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
-	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);
+	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, order);
+	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, order);
+	const unsigned long nr_pages = 1UL << order;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr = start_addr;
@@ -610,7 +645,7 @@ static enum scan_result __collapse_huge_
 	int none_or_zero = 0, shared = 0, referenced = 0;
 	enum scan_result result = SCAN_FAIL;
 
-	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
+	for (_pte = pte; _pte < pte + nr_pages;
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
@@ -650,6 +685,12 @@ static enum scan_result __collapse_huge_
 
 		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
+			/*
+			 * TODO: Support shared pages without leading to further
+			 * mTHP collapses. Currently bringing in new pages via
+			 * shared may cause a future higher order collapse on a
+			 * rescan of the same range.
+			 */
 			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
@@ -743,18 +784,18 @@ out:
 }
 
 static void __collapse_huge_page_copy_succeeded(pte_t *pte,
-						struct vm_area_struct *vma,
-						unsigned long address,
-						spinlock_t *ptl,
-						struct list_head *compound_pagelist)
+		struct vm_area_struct *vma, unsigned long address,
+		spinlock_t *ptl, unsigned int order,
+		struct list_head *compound_pagelist)
 {
-	unsigned long end = address + HPAGE_PMD_SIZE;
+	const unsigned long nr_pages = 1UL << order;
+	unsigned long end = address + (PAGE_SIZE * nr_pages);
 	struct folio *src, *tmp;
 	pte_t pteval;
 	pte_t *_pte;
 	unsigned int nr_ptes;
 
-	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
+	for (_pte = pte; _pte < pte + nr_pages; _pte += nr_ptes,
 	     address += nr_ptes * PAGE_SIZE) {
 		nr_ptes = 1;
 		pteval = ptep_get(_pte);
@@ -807,11 +848,10 @@ static void __collapse_huge_page_copy_su
 }
 
 static void __collapse_huge_page_copy_failed(pte_t *pte,
-					     pmd_t *pmd,
-					     pmd_t orig_pmd,
-					     struct vm_area_struct *vma,
-					     struct list_head *compound_pagelist)
+		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
+		unsigned int order, struct list_head *compound_pagelist)
 {
+	const unsigned long nr_pages = 1UL << order;
 	spinlock_t *pmd_ptl;
 
 	/*
@@ -827,7 +867,7 @@ static void __collapse_huge_page_copy_fa
 	 * Release both raw and compound pages isolated
 	 * in __collapse_huge_page_isolate.
 	 */
-	release_pte_pages(pte, pte + HPAGE_PMD_NR, compound_pagelist);
+	release_pte_pages(pte, pte + nr_pages, compound_pagelist);
 }
 
 /*
@@ -847,16 +887,17 @@ static void __collapse_huge_page_copy_fa
  */
 static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
 		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
-		unsigned long address, spinlock_t *ptl,
+		unsigned long address, spinlock_t *ptl, unsigned int order,
 		struct list_head *compound_pagelist)
 {
+	const unsigned long nr_pages = 1UL << order;
 	unsigned int i;
 	enum scan_result result = SCAN_SUCCEED;
 
 	/*
 	 * Copying pages' contents is subject to memory poison at any iteration.
 	 */
-	for (i = 0; i < HPAGE_PMD_NR; i++) {
+	for (i = 0; i < nr_pages; i++) {
 		pte_t pteval = ptep_get(pte + i);
 		struct page *page = folio_page(folio, i);
 		unsigned long src_addr = address + i * PAGE_SIZE;
@@ -875,10 +916,10 @@ static enum scan_result __collapse_huge_
 
 	if (likely(result == SCAN_SUCCEED))
 		__collapse_huge_page_copy_succeeded(pte, vma, address, ptl,
-						    compound_pagelist);
+						    order, compound_pagelist);
 	else
 		__collapse_huge_page_copy_failed(pte, pmd, orig_pmd, vma,
-						 compound_pagelist);
+						 order, compound_pagelist);
 
 	return result;
 }
@@ -1051,16 +1092,20 @@ static enum scan_result check_pmd_still_
  * Bring missing pages in from swap, to complete THP collapse.
  * Only done if khugepaged_scan_pmd believes it is worthwhile.
  *
+ * For mTHP orders the function bails on the first swap entry, because
+ * faulting pages back in during collapse could re-populate PTEs that
+ * push a later scan over the threshold for a higher-order collapse.
+ *
  * Called and returns without pte mapped or spinlocks held.
  * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
  */
 static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long start_addr, pmd_t *pmd,
-		int referenced)
+		struct vm_area_struct *vma, unsigned long start_addr,
+		pmd_t *pmd, int referenced, unsigned int order)
 {
 	int swapped_in = 0;
 	vm_fault_t ret = 0;
-	unsigned long addr, end = start_addr + (HPAGE_PMD_NR * PAGE_SIZE);
+	unsigned long addr, end = start_addr + (PAGE_SIZE << order);
 	enum scan_result result;
 	pte_t *pte = NULL;
 	spinlock_t *ptl;
@@ -1092,6 +1137,19 @@ static enum scan_result __collapse_huge_
 		    pte_present(vmf.orig_pte))
 			continue;
 
+		/*
+		 * TODO: Support swapin without leading to further mTHP
+		 * collapses. Currently bringing in new pages via swapin may
+		 * cause a future higher order collapse on a rescan of the same
+		 * range.
+		 */
+		if (!is_pmd_order(order)) {
+			pte_unmap(pte);
+			mmap_read_unlock(mm);
+			result = SCAN_EXCEED_SWAP_PTE;
+			goto out;
+		}
+
 		vmf.pte = pte;
 		vmf.ptl = ptl;
 		ret = do_swap_page(&vmf);
@@ -1217,7 +1275,7 @@ static enum scan_result collapse_huge_pa
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
 		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
-						     referenced);
+						     referenced, HPAGE_PMD_ORDER);
 		if (result != SCAN_SUCCEED)
 			goto out_nolock;
 	}
@@ -1265,6 +1323,7 @@ static enum scan_result collapse_huge_pa
 	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
 	if (pte) {
 		result = __collapse_huge_page_isolate(vma, address, pte, cc,
+						      HPAGE_PMD_ORDER,
 						      &compound_pagelist);
 		spin_unlock(pte_ptl);
 	} else {
@@ -1295,6 +1354,7 @@ static enum scan_result collapse_huge_pa
 
 	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
 					   vma, address, pte_ptl,
+					   HPAGE_PMD_ORDER,
 					   &compound_pagelist);
 	pte_unmap(pte);
 	if (unlikely(result != SCAN_SUCCEED))
@@ -1330,9 +1390,9 @@ static enum scan_result collapse_scan_pm
 		struct vm_area_struct *vma, unsigned long start_addr,
 		bool *lock_dropped, struct collapse_control *cc)
 {
-	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
-	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);
-	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc);
+	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
+	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
+	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
 	int none_or_zero = 0, shared = 0, referenced = 0;
@@ -2386,8 +2446,8 @@ static enum scan_result collapse_scan_fi
 		unsigned long addr, struct file *file, pgoff_t start,
 		struct collapse_control *cc)
 {
-	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL);
-	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc);
+	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
+	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
 	XA_STATE(xas, &mapping->i_pages, start);
_

Patches currently in -mm which might be from npache@redhat.com are


