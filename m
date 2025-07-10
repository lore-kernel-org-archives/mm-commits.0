Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F642284B2E
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126299; cv=none; b=Qa7U4L04KSGEibdsDn2ebvRZDWIQy4a3tZD8gBTTqC+2VWNbIvQBPyIEhmlaJ3hdSThT8IHLEufPjpP7IooBLPuf8JVjg+tyR/8GSQ4aEGMa4OTMWWCtwNIrOy/PaE6/rPcAx7/zvJTuI6/1DNdkxW6tI9aupG46tpskn5ZKWFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126299; c=relaxed/simple;
	bh=kS0gGM0X8ULvJaDtjLXCVp+WxTjkcbZB+xDgydUan/w=;
	h=Date:To:From:Subject:Message-Id; b=SDSB9r6PuHUl6fx2fdy+4HJDJT4vYgKpfdmLORxG9g5CcPURhpKbFBhvh2ZGW3HzYyHIXUUDBsB02svNvI8izVQBCW2NGQBy6VhUTKmcD1Drhlmyvot64pzrlj0bfAYan1o0ReCNbKKsFn4y5U5o+iwW4ZmivRnwztB5l3Far2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MwCJ0MkO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MwCJ0MkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FFCC4CEF6;
	Thu, 10 Jul 2025 05:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126298;
	bh=kS0gGM0X8ULvJaDtjLXCVp+WxTjkcbZB+xDgydUan/w=;
	h=Date:To:From:Subject:From;
	b=MwCJ0MkOsfw3xO+OkIuvn+eHQMcoHwHAuDrmhihCmhIGDDOUZj7Q+vI8g/QDmyfFr
	 YkKvTrKvl7/udHCVh+9qeLbyWLo+pGyTgoNsnDxm/02U+AmPr4F8hzCk0NdL4YydXC
	 3XOJAah56fOkA9SIaviTTF9+s3y6HEcecu8cjUUI=
Date: Wed, 09 Jul 2025 22:44:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,osalvador@suse.de,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgg@nvidia.com,dev.jain@arm.com,dan.j.williams@intel.com,baolin.wang@linux.alibaba.com,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pmd.patch removed from -mm tree
Message-Id: <20250710054458.D8FFCC4CEF6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: don't mark refcounted folios special in vmf_insert_folio_pmd()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: don't mark refcounted folios special in vmf_insert_folio_pmd()
Date: Fri, 13 Jun 2025 11:27:01 +0200

Marking PMDs that map a "normal" refcounted folios as special is against
our rules documented for vm_normal_page(): normal (refcounted) folios
shall never have the page table mapping marked as special.

Fortunately, there are not that many pmd_special() check that can be
mislead, and most vm_normal_page_pmd()/vm_normal_folio_pmd() users that
would get this wrong right now are rather harmless: e.g., none so far
bases decisions whether to grab a folio reference on that decision.

Well, and GUP-fast will fallback to GUP-slow.  All in all, so far no big
implications as it seems.

Getting this right will get more important as we use
folio_normal_page_pmd() in more places.

Fix it by teaching insert_pfn_pmd() to properly handle folios and pfns --
moving refcount/mapcount/etc handling in there, renaming it to
insert_pmd(), and distinguishing between both cases using a new simple
"struct folio_or_pfn" structure.

Use folio_mk_pmd() to create a pmd for a folio cleanly.

Link: https://lkml.kernel.org/r/20250613092702.1943533-3-david@redhat.com
Fixes: 6c88f72691f8 ("mm/huge_memory: add vmf_insert_folio_pmd()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   59 ++++++++++++++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 19 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pmd
+++ a/mm/huge_memory.c
@@ -1372,9 +1372,17 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 	return __do_huge_pmd_anonymous_page(vmf);
 }
 
-static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
-		pmd_t *pmd, pfn_t pfn, pgprot_t prot, bool write,
-		pgtable_t pgtable)
+struct folio_or_pfn {
+	union {
+		struct folio *folio;
+		pfn_t pfn;
+	};
+	bool is_folio;
+};
+
+static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
+		pmd_t *pmd, struct folio_or_pfn fop, pgprot_t prot,
+		bool write, pgtable_t pgtable)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t entry;
@@ -1382,8 +1390,11 @@ static int insert_pfn_pmd(struct vm_area
 	lockdep_assert_held(pmd_lockptr(mm, pmd));
 
 	if (!pmd_none(*pmd)) {
+		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
+					  pfn_t_to_pfn(fop.pfn);
+
 		if (write) {
-			if (pmd_pfn(*pmd) != pfn_t_to_pfn(pfn)) {
+			if (pmd_pfn(*pmd) != pfn) {
 				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
 				return -EEXIST;
 			}
@@ -1396,11 +1407,20 @@ static int insert_pfn_pmd(struct vm_area
 		return -EEXIST;
 	}
 
-	entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
-	if (pfn_t_devmap(pfn))
-		entry = pmd_mkdevmap(entry);
-	else
-		entry = pmd_mkspecial(entry);
+	if (fop.is_folio) {
+		entry = folio_mk_pmd(fop.folio, vma->vm_page_prot);
+
+		folio_get(fop.folio);
+		folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
+		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
+	} else {
+		entry = pmd_mkhuge(pfn_t_pmd(fop.pfn, prot));
+
+		if (pfn_t_devmap(fop.pfn))
+			entry = pmd_mkdevmap(entry);
+		else
+			entry = pmd_mkspecial(entry);
+	}
 	if (write) {
 		entry = pmd_mkyoung(pmd_mkdirty(entry));
 		entry = maybe_pmd_mkwrite(entry, vma);
@@ -1431,6 +1451,9 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_
 	unsigned long addr = vmf->address & PMD_MASK;
 	struct vm_area_struct *vma = vmf->vma;
 	pgprot_t pgprot = vma->vm_page_prot;
+	struct folio_or_pfn fop = {
+		.pfn = pfn,
+	};
 	pgtable_t pgtable = NULL;
 	spinlock_t *ptl;
 	int error;
@@ -1458,8 +1481,8 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_
 	pfnmap_setup_cachemode_pfn(pfn_t_to_pfn(pfn), &pgprot);
 
 	ptl = pmd_lock(vma->vm_mm, vmf->pmd);
-	error = insert_pfn_pmd(vma, addr, vmf->pmd, pfn, pgprot, write,
-			pgtable);
+	error = insert_pmd(vma, addr, vmf->pmd, fop, pgprot, write,
+			   pgtable);
 	spin_unlock(ptl);
 	if (error && pgtable)
 		pte_free(vma->vm_mm, pgtable);
@@ -1474,6 +1497,10 @@ vm_fault_t vmf_insert_folio_pmd(struct v
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long addr = vmf->address & PMD_MASK;
 	struct mm_struct *mm = vma->vm_mm;
+	struct folio_or_pfn fop = {
+		.folio = folio,
+		.is_folio = true,
+	};
 	spinlock_t *ptl;
 	pgtable_t pgtable = NULL;
 	int error;
@@ -1491,14 +1518,8 @@ vm_fault_t vmf_insert_folio_pmd(struct v
 	}
 
 	ptl = pmd_lock(mm, vmf->pmd);
-	if (pmd_none(*vmf->pmd)) {
-		folio_get(folio);
-		folio_add_file_rmap_pmd(folio, &folio->page, vma);
-		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PMD_NR);
-	}
-	error = insert_pfn_pmd(vma, addr, vmf->pmd,
-			pfn_to_pfn_t(folio_pfn(folio)), vma->vm_page_prot,
-			write, pgtable);
+	error = insert_pmd(vma, addr, vmf->pmd, fop, vma->vm_page_prot,
+			   write, pgtable);
 	spin_unlock(ptl);
 	if (error && pgtable)
 		pte_free(mm, pgtable);
_

Patches currently in -mm which might be from david@redhat.com are

mm-balloon_compaction-we-cannot-have-isolated-pages-in-the-balloon-list.patch
mm-balloon_compaction-convert-balloon_page_delete-to-balloon_page_finalize.patch
mm-zsmalloc-drop-pageisolated-related-vm_bug_ons.patch
mm-page_alloc-let-page-freeing-clear-any-set-page-type.patch
mm-balloon_compaction-make-pageoffline-sticky-until-the-page-is-freed.patch
mm-zsmalloc-make-pagezsmalloc-sticky-until-the-page-is-freed.patch
mm-migrate-rename-isolate_movable_page-to-isolate_movable_ops_page.patch
mm-migrate-rename-putback_movable_folio-to-putback_movable_ops_page.patch
mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page.patch
mm-migrate-remove-folio_test_movable-and-folio_movable_ops.patch
mm-migrate-move-movable_ops-page-handling-out-of-move_to_new_folio.patch
mm-zsmalloc-stop-using-__clearpagemovable.patch
mm-balloon_compaction-stop-using-__clearpagemovable.patch
mm-migrate-remove-__clearpagemovable.patch
mm-migration-remove-pagemovable.patch
mm-rename-__pagemovable-to-page_has_movable_ops.patch
mm-page_isolation-drop-__folio_test_movable-check-for-large-folios.patch
mm-remove-__folio_test_movable.patch
mm-stop-storing-migration_ops-in-page-mapping.patch
mm-convert-movable-flag-in-page-mapping-to-a-page-flag.patch
mm-rename-pg_isolated-to-pg_movable_ops_isolated.patch
mm-page-flags-rename-page_mapping_movable-to-page_mapping_anon_ksm.patch
mm-page-alloc-remove-pagemappingflags.patch
mm-page-flags-remove-folio_mapping_flags.patch
mm-simplify-folio_expected_ref_count.patch
mm-rename-page_mapping_-to-folio_mapping_.patch
docs-mm-convert-from-non-lru-page-migration-to-movable_ops-page-migration.patch
mm-balloon_compaction-movable_ops-doc-updates.patch
mm-balloon_compaction-provide-single-balloon_page_insert-and-balloon_mapping_gfp_mask.patch
mm-convert-fpb_ignore_-into-fpb_respect_.patch
mm-smaller-folio_pte_batch-improvements.patch
mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags.patch
mm-remove-boolean-output-parameters-from-folio_pte_batch_ext.patch
mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch

