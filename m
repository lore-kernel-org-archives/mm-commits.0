Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB9015687A
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 21:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712180808; cv=none; b=HDOHZI5QzY+CZrXnB92pma97hFlK0ARlr+ty84JJFEOUj8ZyCYnKfrbBs389/jXd4Y0HoY5O9EsqoChgwMg5rlE7Meoj2kidvJq3BXvTeuB6TSoVJwXuUdAFp2RdIdoKQjf8G7U0FWOi9OCI317Wtt1yeYbfwgsWsn96V+R5G7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712180808; c=relaxed/simple;
	bh=OPCXPWeTrzW9AfkIAaCOMlUvI5WmKz5u4KvyB4BOnUs=;
	h=Date:To:From:Subject:Message-Id; b=J64wIVmv8eDHcyTLPI3Ax3PIdcggu52VPBwhellU7g+Kw1BKujw8okHKOFKjyGL0GgIZhduzWF9hktP3UTBik5XySr58nxgbhTK+xoa1mejMxOPYCkzKJ3k6JMAdOeldWnAdCBnjMDxLTxiXSD3dIpsVmSPwni9br2BHf5Kxykg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KOY0UMi4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KOY0UMi4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01254C433F1;
	Wed,  3 Apr 2024 21:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712180808;
	bh=OPCXPWeTrzW9AfkIAaCOMlUvI5WmKz5u4KvyB4BOnUs=;
	h=Date:To:From:Subject:From;
	b=KOY0UMi4NvtTjRM67s5Wirix6d36e1lnEWQ4tecv/9pPMAmXijfP1opVqjnmmDvi4
	 KqBBoZ3dskwH3tU6piNcZ3vmzERKjBnPmFGlSMRdn2OHavVbJzUActgUrWLux/rhwU
	 btrHZ1ZlRH8hvVuYwaczPrHx1yae1gZoRhxezHj8=
Date: Wed, 03 Apr 2024 14:46:47 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-convert-alloc_buddy_hugetlb_folio-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20240403214648.01254C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: convert alloc_buddy_hugetlb_folio to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-convert-alloc_buddy_hugetlb_folio-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-convert-alloc_buddy_hugetlb_folio-to-use-a-folio.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hugetlb: convert alloc_buddy_hugetlb_folio to use a folio
Date: Tue, 2 Apr 2024 21:06:54 +0100

While this function returned a folio, it was still using __alloc_pages()
and __free_pages().  Use __folio_alloc() and put_folio() instead.  This
actually removes a call to compound_head(), but more importantly, it
prepares us for the move to memdescs.

Link: https://lkml.kernel.org/r/20240402200656.913841-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

--- a/mm/hugetlb.c~hugetlb-convert-alloc_buddy_hugetlb_folio-to-use-a-folio
+++ a/mm/hugetlb.c
@@ -2177,13 +2177,13 @@ static struct folio *alloc_buddy_hugetlb
 		nodemask_t *node_alloc_noretry)
 {
 	int order = huge_page_order(h);
-	struct page *page;
+	struct folio *folio;
 	bool alloc_try_hard = true;
 	bool retry = true;
 
 	/*
-	 * By default we always try hard to allocate the page with
-	 * __GFP_RETRY_MAYFAIL flag.  However, if we are allocating pages in
+	 * By default we always try hard to allocate the folio with
+	 * __GFP_RETRY_MAYFAIL flag.  However, if we are allocating folios in
 	 * a loop (to adjust global huge page counts) and previous allocation
 	 * failed, do not continue to try hard on the same node.  Use the
 	 * node_alloc_noretry bitmap to manage this state information.
@@ -2196,43 +2196,42 @@ static struct folio *alloc_buddy_hugetlb
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 retry:
-	page = __alloc_pages(gfp_mask, order, nid, nmask);
+	folio = __folio_alloc(gfp_mask, order, nid, nmask);
 
-	/* Freeze head page */
-	if (page && !page_ref_freeze(page, 1)) {
-		__free_pages(page, order);
+	if (folio && !folio_ref_freeze(folio, 1)) {
+		folio_put(folio);
 		if (retry) {	/* retry once */
 			retry = false;
 			goto retry;
 		}
 		/* WOW!  twice in a row. */
-		pr_warn("HugeTLB head page unexpected inflated ref count\n");
-		page = NULL;
+		pr_warn("HugeTLB unexpected inflated folio ref count\n");
+		folio = NULL;
 	}
 
 	/*
-	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a page this
-	 * indicates an overall state change.  Clear bit so that we resume
-	 * normal 'try hard' allocations.
+	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
+	 * folio this indicates an overall state change.  Clear bit so
+	 * that we resume normal 'try hard' allocations.
 	 */
-	if (node_alloc_noretry && page && !alloc_try_hard)
+	if (node_alloc_noretry && folio && !alloc_try_hard)
 		node_clear(nid, *node_alloc_noretry);
 
 	/*
-	 * If we tried hard to get a page but failed, set bit so that
+	 * If we tried hard to get a folio but failed, set bit so that
 	 * subsequent attempts will not try as hard until there is an
 	 * overall state change.
 	 */
-	if (node_alloc_noretry && !page && alloc_try_hard)
+	if (node_alloc_noretry && !folio && alloc_try_hard)
 		node_set(nid, *node_alloc_noretry);
 
-	if (!page) {
+	if (!folio) {
 		__count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
 		return NULL;
 	}
 
 	__count_vm_event(HTLB_BUDDY_PGALLOC);
-	return page_folio(page);
+	return folio;
 }
 
 static struct folio *__alloc_fresh_hugetlb_folio(struct hstate *h,
_

Patches currently in -mm which might be from willy@infradead.org are

mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio-fix.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch
proc-rewrite-stable_page_flags-fix.patch
sparc-use-is_huge_zero_pmd.patch
mm-add-is_huge_zero_folio.patch
mm-add-pmd_folio.patch
mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch
mm-convert-huge_zero_page-to-huge_zero_folio.patch
mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch
dax-use-huge_zero_folio.patch
mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch
mm-use-rwsem-assertion-macros-for-mmap_lock.patch
filemap-remove-__set_page_dirty.patch
mm-correct-page_mapped_in_vma-for-large-folios.patch
mm-remove-vma_address.patch
mm-rename-vma_pgoff_address-back-to-vma_address.patch
khugepaged-inline-hpage_collapse_alloc_folio.patch
khugepaged-convert-alloc_charge_hpage-to-alloc_charge_folio.patch
khugepaged-remove-hpage-from-collapse_huge_page.patch
khugepaged-pass-a-folio-to-__collapse_huge_page_copy.patch
khugepaged-remove-hpage-from-collapse_file.patch
khugepaged-use-a-folio-throughout-collapse_file.patch
khugepaged-use-a-folio-throughout-hpage_collapse_scan_file.patch
proc-convert-clear_refs_pte_range-to-use-a-folio.patch
proc-convert-smaps_account-to-use-a-folio.patch
mm-remove-page_idle-and-page_young-wrappers.patch
mm-generate-page_idle_flag-definitions.patch
proc-convert-gather_stats-to-use-a-folio.patch
proc-convert-smaps_page_accumulate-to-use-a-folio.patch
proc-pass-a-folio-to-smaps_page_accumulate.patch
proc-convert-smaps_pmd_entry-to-use-a-folio.patch
mm-remove-struct-page-from-get_shadow_from_swap_cache.patch
hugetlb-convert-alloc_buddy_hugetlb_folio-to-use-a-folio.patch

