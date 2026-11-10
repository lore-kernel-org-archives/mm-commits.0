Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293112;
	b=Fd2/eZ1jBGOsehxsmlObaeHTolkCBDHhW+19eOVWZg4kJ4XDLCCSwTSWMXGKOaXW/H/G
	 lADF/TzxqLplO2yfq5I40yyFUuANUTFt5VW+Y6iFuNnHJav4xluSJSryxRA2LjaFnfzLh
	 vV3fBeguJ8jeP76nTybgjL23q/YnNQnP35gtA821Z2xtpWc2jka62C1dW8+F9p+hwnvtA
	 5Pp2AkK9egAPHsJkhyavyrVkBaekYIFQ3nk34Cj4ZjEwHQmbhQDzAYN45+PFzAQxYEIU0
	 qHOpmD7KpPRf4Ax+MLu268NlCT12W1plZtbb0UN7oOKH51NxhXiJ5I2V7qBavQ9emWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293112;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=FPfmpBvk2G45uhiys+1Km7Pzml9rAJHDpzmmZ6HBn40=;
	b=YDA68RQkibHqqYMrLP5KDrfAegu3a/7qFlpVUqkZQk6v+6l8Wf3CxbX74m031z27IVRl
	 nVqwid+Z6TC9ZMyW92oFV7HZdYvjWDqZKJFn/Vz0tCOKqMHDvtQ/pQxVk1RiVpidXZhyR
	 pRIFkMlqBF+35ZS6GNzfvm0RBjbl0PpY5xTvifYknvBY3a0pmjD8WLtmN01fC1Dxq60Mn
	 JgXlyDMAOD0UR3j1lHwy3CjnB79A1kZZpoC6fhZSpPq4aE80LhkABwPkM7LZphIMOLNPH
	 Z1kbonUgwkl9DXNQAsIUWVtRFadh8lpSvYrGZ9QzDSXk5m2sQH4nY9+seR6M3cAMl0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Q7ID1WlA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C0D606BD69;
	Tue, 10 Nov 2026 06:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Q7ID1WlA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDD91F008A3;
	Tue, 10 Nov 2026 06:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293111;
	bh=FPfmpBvk2G45uhiys+1Km7Pzml9rAJHDpzmmZ6HBn40=;
	h=Date:To:From:Subject;
	b=Q7ID1WlAUxo1za5aaBTsoE1w57AcdfeoCBptM40uMOgdnb1yyRHOQIbdA9rmcybQ5
	 H+T+sgUIgSXpn0Jst204lEPImU+2MM+Bcoe1Hg4whwqfIZIqzUFB6IEVIitllOrbP+
	 AJSZtg2HmxcTxTfttDPHzKlSXe9qjm1dmdZ4M6ww=
Date: Mon, 09 Nov 2026 22:45:10 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,stable@vger.kernel.org,
	pjw@kernel.org,palmer@dabbelt.com,osalvador@suse.de,mark.rutland@arm.com,
	kevin.brodsky@arm.com,david@kernel.org,dave.hansen@intel.com,
	catalin.marinas@arm.com,bjorn@rivosinc.com,azpijr@gmail.com,
	apopple@nvidia.com,aou@eecs.berkeley.edu,anshuman.khandual@arm.com,
	alex@ghiti.fr,agordeev@linux.ibm.com,muchun.song@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-missing-page-table-destructor-in-pagetable_free.patch removed from -mm tree
Message-Id: <20261110064510.EEDD91F008A3@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: fix missing page-table destructor in pagetable_free()
has been removed from the -mm tree.  Its filename was
     mm-fix-missing-page-table-destructor-in-pagetable_free.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: fix missing page-table destructor in pagetable_free()
Date: Fri, 23 Oct 2026 14:34:25 +0800

Patch series "mm: Fix page-table teardown during memory hot-remove", v3.

Memory hot-remove can free page-table pages allocated through paths with
different constructor state. Some paths run the page-table constructor,
while generic sparse-vmemmap population may not. The x86, RISC-V, and
arm64 teardown paths did not handle that distinction consistently,
leaving constructor/destructor accounting unbalanced.

Make pagetable_free() handle any remaining constructor state before
freeing a page-table page. Callers that already ran pagetable_dtor()
have cleared that state, so the destructor is not run twice. The RISC-V
and arm64 fixes then use this common helper for their memory-hot-remove
paths.

The architecture fixes depend on the common MM change in patch 1, so
this remains a single series. I expect it to go through the MM tree,
with review or acks from the relevant architecture maintainers.


This patch (of 4):

Since commit 49f599666420 ("mm: call ctor/dtor for kernel PTEs"),
pte_alloc_one_kernel() runs the page-table constructor for kernel PTE
tables.

HVO (HugeTLB Vmemmap Optimization) uses pte_alloc_one_kernel() when
splitting a PMD. Restoring the vmemmap backing pages does not collapse
the PTE table, so a later memory hot-remove eventually frees it through
pagetable_free() on x86-64. That releases the page without running the
matching destructor and leaves NR_PAGETABLE elevated.

Make pagetable_free() the common free-side primitive for page-table
pages. It checks PageTable() and runs the destructor only when the
constructor state is still present. Callers that explicitly ran
pagetable_dtor() have already cleared PageTable(), so they are not
destructed twice; pages that never ran a constructor are freed directly.

Link: https://lore.kernel.org/20261023063428.3658761-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/20261023063428.3658761-2-songmuchun@bytedance.com
Fixes: 49f599666420 ("mm: call ctor/dtor for kernel PTEs")
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Björn Töpel <bjorn@rivosinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org> # bf9e4e30f353: x86/mm: use pagetable_free()
---

 include/linux/mm.h |   37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

--- a/include/linux/mm.h~mm-fix-missing-page-table-destructor-in-pagetable_free
+++ a/include/linux/mm.h
@@ -3971,23 +3971,6 @@ static inline void pagetable_free_kernel
 	__pagetable_free(pt);
 }
 #endif
-/**
- * pagetable_free - Free pagetables
- * @pt:	The page table descriptor
- *
- * pagetable_free frees the memory of all page tables described by a page
- * table descriptor and the memory for the descriptor itself.
- */
-static inline void pagetable_free(struct ptdesc *pt)
-{
-	if (ptdesc_test_kernel(pt)) {
-		ptdesc_clear_kernel(pt);
-		pagetable_free_kernel(pt);
-	} else {
-		__pagetable_free(pt);
-	}
-}
-
 #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
 #if ALLOC_SPLIT_PTLOCKS
 void __init ptlock_cache_init(void);
@@ -4080,6 +4063,26 @@ static inline void pagetable_dtor(struct
 	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
 }
 
+/**
+ * pagetable_free - Free pagetables
+ * @pt:	The page table descriptor
+ *
+ * pagetable_free frees the memory of all page tables described by a page
+ * table descriptor and the memory for the descriptor itself.
+ */
+static inline void pagetable_free(struct ptdesc *pt)
+{
+	if (PageTable(ptdesc_page(pt)))
+		pagetable_dtor(pt);
+
+	if (ptdesc_test_kernel(pt)) {
+		ptdesc_clear_kernel(pt);
+		pagetable_free_kernel(pt);
+	} else {
+		__pagetable_free(pt);
+	}
+}
+
 static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
 {
 	pagetable_dtor(ptdesc);
_

Patches currently in -mm which might be from muchun.song@linux.dev are

riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch
mm-generalize-kernel-pte-table-allocation.patch
mm-generalize-pmd-page-table-allocation.patch
mm-generalize-pud-page-table-allocation.patch
mm-remove-pagetable_dtor_free.patch
mm-remove-redundant-pagetable_dtor-calls.patch
mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros.patch
mm-hugetlb_vmemmap-unify-vmemmap_splitremap_no_tlb_flush.patch
mm-hugetlb_vmemmap-simplify-vmemmap-head-page-handling.patch
mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch
mm-hugetlb_vmemmap-unify-writable-vmemmap-page-preparation.patch
mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch
mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch
mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch
mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch
mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch
mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch
mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch
mm-hugetlb-fix-validation-of-unsupported-hugetlb-orders.patch
powerpc-mm-make-vmemmap_populate_compound_pages-static.patch
powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch
loongarch-mm-disable-device-dax-vmemmap-optimization.patch
mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch

