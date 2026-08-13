Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9421B499F37;
	Thu, 13 Aug 2026 17:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786641236; cv=none; b=crcrwjqqAH2IPQlUK9y5jG+l16PfSVdZd+/x4nV3+MXPMpbqVuQw1LmKOpUjhqkh0NDT8l9sFW+3P8lhG91HdFl0eTcEDwpWwMhKY/U/8QJ6STGQaYbgCR62UH9YPhHoF07OXmAwFPvldRsnwqPDTCDRVrMVzcS8scVKX4vPxvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786641236; c=relaxed/simple;
	bh=POvanSvZmtA4BKJG7+lGBstpYyXVGaGm54KoFuU9LVM=;
	h=Date:To:From:Subject:Message-Id; b=ZvNJfkEAuEmrN4HkRCynbM1GqPZGRE9Si203B0BbStVdUcLmdRyUXE05t1ocFM68RpOcdzkdVIFYz1tOJQ6monSGw8JC0rF5AH1mYPSfM4pt3nzK5alTYFVw18/4eoTrA4J9nWJvX0NPNYb0ZOQfSW0s8gcp8U3YZDi+GIskyVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vcf6RQz7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vcf6RQz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62031F000E9;
	Thu, 13 Aug 2026 17:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786641234;
	bh=oy/n+7hdx0Ntqu4fin93PKlJ8VzR/ZNfW/FjfZzNELU=;
	h=Date:To:From:Subject;
	b=vcf6RQz7VzR7CUmy0FvXnKEDaOa3G7ZTMa5DBfRZRUzD9NFLA47x1KD6M3aLlPt8x
	 D4QhtQYg7jJaXT+pNjgm3S11m39FvkKcelc8yzl7MGWG0hzk6ISc9P9jMtgJqUYZW2
	 vufIwB6eC4NXt+dUCZ7fW9hzGJX6zBRhQ0DJl91U=
Date: Thu, 13 Aug 2026 10:13:53 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,stable@vger.kernel.org,rppt@kernel.org,peterz@infradead.org,mingo@redhat.com,luto@kernel.org,kevin.tian@intel.com,kas@kernel.org,jgg@ziepe.ca,hpa@zytor.com,david@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,baolu.lu@linux.intel.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch removed from -mm tree
Message-Id: <20260813171353.E62031F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm/pat: allocate split page tables as kernel page tables
has been removed from the -mm tree.  Its filename was
     x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: x86/mm/pat: allocate split page tables as kernel page tables
Date: Tue, 21 Jul 2026 13:14:52 +0100

When splitting a large page in CPA in __split_large_page() we allocate a
PTE directly without going through the standard page table allocation
routines such as pte_alloc_one_kernel().

This means the page table constructor is never called nor is the page
table marked as a kernel page table.

The former results in the folio associated with the page table not being
marked as a page table (__pagetable_ctor() is never called thus neither is
__folio_set_pgtable()) nor are statistics updated to reflect it
(lruvec_stat_add_folio() is never called).

The latter issue of failing to mark the page table as a kernel page table
(ptdesc_set_kernel() is never called) is far more problematic.

Since commit 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page
tables") kernel page table freeing has been batched and since the
subsequent commit e37d5a2d60a3 ("iommu/sva: invalidate stale IOTLB entries
for kernel address space") IOTLB cache entries for kernel page tables have
been invalidated upon being freed.

Since split page tables are freed without this invalidation, the IOTLB can
contain stale entries for them.

Resolve the issue by using the ordinary PTE allocation API at split time.

This results in these kernel page tables invoking a page table
constructor, and thus requires a page table destructor.

Since we cannot assume one is always present (early allocated direct map
page tables are not marked as such), we conditionally call
pagetable_dtor_free() if the PG_table folio flag for the ptdesc is set,
otherwise we free the page table via pagetable_free().

Regardless of which path is taken page tables marked as kernel page
tables, which now includes split page tables, take the correct route
through pagetable_free_kernel().

There is a user-visible side effect in that split page tables will appear
in nr_page_table_pages in /proc/vmstat (as do other kernel page tables
allocated after early boot), however this is a positive change.

This issue started being markedly problematic after commit 5ba2f0a15564
("mm: introduce deferred freeing for kernel page tables") so choose this
as the Fixes target.

Link: https://lore.kernel.org/20260721-fix-cpa-kernel-pagetables-v2-1-2b255deed710@kernel.org
Fixes: 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Vishal Moola <vishal.moola@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Baolu Lu <baolu.lu@linux.intel.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat/set_memory.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/arch/x86/mm/pat/set_memory.c~x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables
+++ a/arch/x86/mm/pat/set_memory.c
@@ -440,7 +440,15 @@ static void __cpa_collapse_large_pages(s
 
 	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
 		list_del(&ptdesc->pt_list);
-		pagetable_free(ptdesc);
+		/*
+		 * Only early alloc'd direct map should not be flagged PG_table
+		 * here and those shouldn't be collapsed. However be abundantly
+		 * cautious and handle the !PG_table case too.
+		 */
+		if (PageTable((ptdesc_page(ptdesc))))
+			pagetable_dtor_free(ptdesc);
+		else
+			pagetable_free(ptdesc);
 	}
 }
 
@@ -1139,11 +1147,10 @@ set:
 
 static int
 __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
-		   struct ptdesc *ptdesc)
+		   pte_t *pbase)
 {
 	unsigned long lpaddr, lpinc, ref_pfn, pfn, pfninc = 1;
-	struct page *base = ptdesc_page(ptdesc);
-	pte_t *pbase = (pte_t *)page_address(base);
+	struct page *base = virt_to_page(pbase);
 	unsigned int i, level;
 	pgprot_t ref_prot;
 	bool nx, rw;
@@ -1247,22 +1254,22 @@ __split_large_page(struct cpa_data *cpa,
 static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 			    unsigned long address)
 {
-	struct ptdesc *ptdesc;
+	pte_t *pte;
 
 	if (!debug_pagealloc_enabled())
 		spin_unlock(&cpa_lock);
 	if (cpa->init_mm_read_locked)
 		mmap_read_unlock(&init_mm);
-	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
+	pte = pte_alloc_one_kernel(&init_mm);
 	if (cpa->init_mm_read_locked)
 		mmap_read_lock(&init_mm);
 	if (!debug_pagealloc_enabled())
 		spin_lock(&cpa_lock);
-	if (!ptdesc)
+	if (!pte)
 		return -ENOMEM;
 
-	if (__split_large_page(cpa, kpte, address, ptdesc))
-		pagetable_free(ptdesc);
+	if (__split_large_page(cpa, kpte, address, pte))
+		pte_free_kernel(&init_mm, pte);
 
 	return 0;
 }
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers.patch
mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch
mm-introduce-linear_anon_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-anon-index-if-appropriate.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-vma-fix-self-merge-check-in-copy_vma.patch
tools-testing-vma-add-tests-for-copy_vma-self-merge.patch
mm-propagate-vma-anonymous-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-pgoff-is-anonymous.patch
mm-clean-up-vma_address_end.patch
mm-huge_memory-update-remove_migration_pmd-to-accept-a-folio.patch
mm-migrate-calculate-large-folio-page-index-using-pfn.patch
mm-rmap-use-anon-pgoff-to-track-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-anon-pgoff.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch
maintainers-add-drivers-char-memc-to-mm-misc-memory-mapping-sections.patch

