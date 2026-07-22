Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9AC17C203;
	Wed, 22 Jul 2026 00:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784678565; cv=none; b=kdZIkAof0btLXWO/Zsu1etqWE/tcB6fb5S+Su36dARqQE/+3vF9aEh11CTx4LxDpCdX9y/VboCjw3LsKUtx7naea4KWl30O0708tehaPxngB5rYjJQ501/JalPXwm48r0Ffki07t25IvR5zzI2Ol9ci0/JOmSB3qwWqmhfnweqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784678565; c=relaxed/simple;
	bh=ehgcE+eO/peXgNJbcZKul6FIoEMma9gy0mjfbh52duA=;
	h=Date:To:From:Subject:Message-Id; b=g/9ZduB2FYy9p6F2D8EA6Dt8zeTfIDyqyBjQQnAv2fUSogB670uEKAhkUtFDj4z1M1ojsGmmXPSCjOVch404unO8MwCLqIWOXrBVV0m3/tinCwnK5g9do95dmCHpk5OOnNPszZ23zH30KKvYQRdYDTk9asBXNePDdOpr8OkYBX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DBwsxafX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DBwsxafX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DCE1F000E9;
	Wed, 22 Jul 2026 00:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784678563;
	bh=QU5YJM28eQZeWn51Ggd6g97lmDbVHYE6Aw87akEGuYI=;
	h=Date:To:From:Subject;
	b=DBwsxafXCicflw5rz6GwUVC6WdWQypW9TrC+Trwtvohtcgctg7t+7xKTpxCwr5tPw
	 LdaOkySUnD5NKNDl2uhq1OwoixgBV0//tUDyfryuCiYtq3sZUtZ/XAjrKa1OkGkc6s
	 xX8dII1t8nqnIJLXBMCQ5bavKg41sJycoIX+EmQA=
Date: Tue, 21 Jul 2026 17:02:43 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,stable@vger.kernel.org,rppt@kernel.org,peterz@infradead.org,mingo@redhat.com,luto@kernel.org,kevin.tian@intel.com,kas@kernel.org,jgg@ziepe.ca,hpa@zytor.com,david@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,baolu.lu@linux.intel.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch added to mm-hotfixes-unstable branch
Message-Id: <20260722000243.C8DCE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm/pat: allocate split page tables as kernel page tables
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
@@ -439,7 +439,15 @@ static void __cpa_collapse_large_pages(s
 
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
 
@@ -1138,11 +1146,10 @@ set:
 
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
@@ -1246,18 +1253,18 @@ __split_large_page(struct cpa_data *cpa,
 static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 			    unsigned long address)
 {
-	struct ptdesc *ptdesc;
+	pte_t *pte;
 
 	if (!debug_pagealloc_enabled())
 		spin_unlock(&cpa_lock);
-	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
+	pte = pte_alloc_one_kernel(&init_mm);
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

mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.patch
x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
arm64-remove-redundant-concurrent-ptdump-uaf-mitigation.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-move-alloc-tag-to-mm.patch
mm-move-vma_start_pgoff-into-mmh-and-clean-up.patch
mm-add-kdoc-comments-for-vma_start-last_pgoff.patch
tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch
mm-introduce-and-use-vma_end_pgoff.patch
mm-rmap-update-mm-interval_treec-comments.patch
mm-rmap-parameterise-vma_interval_tree_-by-address_space.patch
mm-rmap-elide-unnecessary-static-inlines-in-interval_treec.patch
mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_.patch
mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma.patch
mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t.patch
mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch
maintainers-move-mm-interval_treec-to-rmap-section.patch
mm-vma-introduce-and-use-vmg_pages-vmg__pgoff.patch
mm-vma-clean-up-anon_vma_compatible.patch
mm-vma-refactor-vmg_adjust_set_range-for-clarity.patch
mm-vma-minor-cleanup-of-expand_.patch
mm-introduce-and-use-linear_page_delta.patch
mm-vma-use-vma_start_pgoff-linear_page_index-in-mm-code.patch
mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel.patch
mm-vma-remove-duplicative-vma_pgoff_offset-helper.patch
mm-use-linear_page_-consistently.patch
mm-vma-introduce-vma_assert_can_modify.patch
mm-vma-add-and-use-vma__pgoff.patch
mm-vma-move-__install_special_mapping-to-vmac.patch
mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch
mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters.patch
mm-vma-update-vmg_adjust_set_range-to-offset-pgoff-instead.patch
mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch
mm-vma-introduce-and-use-vma_set_pgoff.patch
mm-vma-correct-incorrect-vmah-inclusion.patch
mm-vma-use-guard-clauses-in-can_vma_merge_.patch
tools-testing-vma-default-vma-mm-flag-bits-to-64-bit.patch
tools-testing-vma-output-compared-expression-on-assert_.patch
mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch
mm-vma-update-do_mmap-to-use-vma_flags_t.patch
mm-convert-__get_unmapped_area-to-use-vma_flags_t.patch
mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch
mm-prefer-mm-def_vma_flags-in-mm-logic.patch
mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch
mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch
mm-introduce-vma_get_page_prot-and-use-it.patch
mm-vma-update-create_init_stack_vma-to-use-vma_flags_t.patch
mm-vma-convert-miscellaneous-uses-of-vma-flags-in-core-mm.patch
mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch
mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch
mm-mremap-convert-mremap-code-to-use-vma_flags_t.patch
mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch
mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch
mm-mseal-remove-further-superfluous-comments-do_mseal.patch
mm-vma-introduce-vma-virtual-page-offset-field-and-add-helpers.patch
mm-introduce-linear_virt_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-virtual-page-index.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-walk-is-anonymous.patch
mm-introduce-and-use-linear_folio_page_index.patch
mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-virt-pgoff.patch
tools-testing-selftests-mm-test-virtual-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch

