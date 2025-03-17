Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1732A59
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188189; cv=none; b=LlV2FV9oX+oWopJmk/WVgTmG64KmT6ydO7wcBinemS6cKZ7sQfiHqPdZMxNRtQpNg8M+n98rMttviTT5WBOLM6dgC6cA0ZwwHoFRh9PXLFhWIA0nIMKNQYw2CP7VUnAbNd0ZuVtXC+rxdoTyN+pCX4eZEgTFCaTChc6GGLuS/cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188189; c=relaxed/simple;
	bh=GneUlj1qUa6VEaBDwavpsDPF3PRpV1+QCEIn/15yKhw=;
	h=Date:To:From:Subject:Message-Id; b=bzkxmVIg81w3+0vR0gYsJLqAegnZqH/BIwKl05Fzd1QKgeo4mxehlV5b9ti4MWQj+XXSpDdup4Xl3TD5Ke2ZL8ByIUr/6m9piUSoFSD+LUZ7xUGwNxLdGYxoNDKFeTwnN2g8QQrs2rpbER3/rjNeH8COgqeRx2HS2vJ6qcrrqpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hdc6dRJ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hdc6dRJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C34C4CEEC;
	Mon, 17 Mar 2025 05:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188188;
	bh=GneUlj1qUa6VEaBDwavpsDPF3PRpV1+QCEIn/15yKhw=;
	h=Date:To:From:Subject:From;
	b=hdc6dRJ2iHWmD2HOb63h2UwJhAhTL6CAtdD20AICp71qZQXdnZGaBVB8riJxOfVWr
	 iOHXUfFkguMGvETVsx06XXo+jOdb9TXyXoeNhJx/PyAVH6DrWDXinOOtI76bGbiTjr
	 FYOPbf3qN3J0T7sWGqGpr0EeT9MCWm2LfPCFytsY=
Date: Sun, 16 Mar 2025 22:09:48 -0700
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,sj@kernel.org,si.yanteng@linux.dev,simona.vetter@ffwll.ch,peterz@infradead.org,peterx@redhat.com,pasha.tatashin@soleen.com,oleg@redhat.com,mhiramat@kernel.org,lyude@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kherbst@redhat.com,jhubbard@nvidia.com,jglisse@redhat.com,jgg@nvidia.com,jannh@google.com,dakr@kernel.org,corbet@lwn.net,apopple@nvidia.com,alexs@kernel.org,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-implement-make_device_exclusive-using-folio_walk-instead-of-rmap-walk.patch removed from -mm tree
Message-Id: <20250317050948.C2C34C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: implement make_device_exclusive() using folio_walk instead of rmap walk
has been removed from the -mm tree.  Its filename was
     mm-rmap-implement-make_device_exclusive-using-folio_walk-instead-of-rmap-walk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: implement make_device_exclusive() using folio_walk instead of rmap walk
Date: Mon, 10 Feb 2025 20:37:46 +0100

We require a writable PTE and only support anonymous folio: we can only
have exactly one PTE pointing at that page, which we can just lookup using
a folio walk, avoiding the rmap walk and the anon VMA lock.

So let's stop doing an rmap walk and perform a folio walk instead, so we
can easily just modify a single PTE and avoid relying on rmap/mapcounts.

We now effectively work on a single PTE instead of multiple PTEs of a
large folio, allowing for conversion of individual PTEs from non-exclusive
to device-exclusive -- note that the opposite direction always works on
single PTEs: restore_exclusive_pte().

With this change, device-exclusive handling is fully compatible with THPs
/ large folios.  We still require PMD-sized THPs to get PTE-mapped, and
supporting PMD-mapped THP (without the PTE-remapping) is a different
endeavour that might not be worth it at this point: it might even have
negative side-effects [1].

This gets rid of the "folio_mapcount()" usage and let's us fix ordinary
rmap walks (migration/swapout) next.  Spell out that messing with the
mapcount is wrong and must be fixed.

[1] https://lkml.kernel.org/r/Z5tI-cOSyzdLjoe_@phenom.ffwll.local

Link: https://lkml.kernel.org/r/20250210193801.781278-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Tested-by: Alistair Popple <apopple@nvidia.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lyude <lyude@redhat.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yanteng Si <si.yanteng@linux.dev>
Cc: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |  200 +++++++++++++++++-----------------------------------
 1 file changed, 67 insertions(+), 133 deletions(-)

--- a/mm/rmap.c~mm-rmap-implement-make_device_exclusive-using-folio_walk-instead-of-rmap-walk
+++ a/mm/rmap.c
@@ -2375,131 +2375,6 @@ void try_to_migrate(struct folio *folio,
 }
 
 #ifdef CONFIG_DEVICE_PRIVATE
-struct make_exclusive_args {
-	struct mm_struct *mm;
-	unsigned long address;
-	void *owner;
-	bool valid;
-};
-
-static bool page_make_device_exclusive_one(struct folio *folio,
-		struct vm_area_struct *vma, unsigned long address, void *priv)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
-	struct make_exclusive_args *args = priv;
-	pte_t pteval;
-	struct page *subpage;
-	bool ret = true;
-	struct mmu_notifier_range range;
-	swp_entry_t entry;
-	pte_t swp_pte;
-	pte_t ptent;
-
-	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0,
-				      vma->vm_mm, address, min(vma->vm_end,
-				      address + folio_size(folio)),
-				      args->owner);
-	mmu_notifier_invalidate_range_start(&range);
-
-	while (page_vma_mapped_walk(&pvmw)) {
-		/* Unexpected PMD-mapped THP? */
-		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
-
-		ptent = ptep_get(pvmw.pte);
-		if (!pte_present(ptent)) {
-			ret = false;
-			page_vma_mapped_walk_done(&pvmw);
-			break;
-		}
-
-		subpage = folio_page(folio,
-				pte_pfn(ptent) - folio_pfn(folio));
-		address = pvmw.address;
-
-		/* Nuke the page table entry. */
-		flush_cache_page(vma, address, pte_pfn(ptent));
-		pteval = ptep_clear_flush(vma, address, pvmw.pte);
-
-		/* Set the dirty flag on the folio now the pte is gone. */
-		if (pte_dirty(pteval))
-			folio_mark_dirty(folio);
-
-		/*
-		 * Check that our target page is still mapped at the expected
-		 * address.
-		 */
-		if (args->mm == mm && args->address == address &&
-		    pte_write(pteval))
-			args->valid = true;
-
-		/*
-		 * Store the pfn of the page in a special migration
-		 * pte. do_swap_page() will wait until the migration
-		 * pte is removed and then restart fault handling.
-		 */
-		if (pte_write(pteval))
-			entry = make_writable_device_exclusive_entry(
-							page_to_pfn(subpage));
-		else
-			entry = make_readable_device_exclusive_entry(
-							page_to_pfn(subpage));
-		swp_pte = swp_entry_to_pte(entry);
-		if (pte_soft_dirty(pteval))
-			swp_pte = pte_swp_mksoft_dirty(swp_pte);
-		if (pte_uffd_wp(pteval))
-			swp_pte = pte_swp_mkuffd_wp(swp_pte);
-
-		set_pte_at(mm, address, pvmw.pte, swp_pte);
-
-		/*
-		 * There is a reference on the page for the swap entry which has
-		 * been removed, so shouldn't take another.
-		 */
-		folio_remove_rmap_pte(folio, subpage, vma);
-	}
-
-	mmu_notifier_invalidate_range_end(&range);
-
-	return ret;
-}
-
-/**
- * folio_make_device_exclusive - Mark the folio exclusively owned by a device.
- * @folio: The folio to replace page table entries for.
- * @mm: The mm_struct where the folio is expected to be mapped.
- * @address: Address where the folio is expected to be mapped.
- * @owner: passed to MMU_NOTIFY_EXCLUSIVE range notifier callbacks
- *
- * Tries to remove all the page table entries which are mapping this
- * folio and replace them with special device exclusive swap entries to
- * grant a device exclusive access to the folio.
- *
- * Context: Caller must hold the folio lock.
- * Return: false if the page is still mapped, or if it could not be unmapped
- * from the expected address. Otherwise returns true (success).
- */
-static bool folio_make_device_exclusive(struct folio *folio,
-		struct mm_struct *mm, unsigned long address, void *owner)
-{
-	struct make_exclusive_args args = {
-		.mm = mm,
-		.address = address,
-		.owner = owner,
-		.valid = false,
-	};
-	struct rmap_walk_control rwc = {
-		.rmap_one = page_make_device_exclusive_one,
-		.done = folio_not_mapped,
-		.anon_lock = folio_lock_anon_vma_read,
-		.arg = &args,
-	};
-
-	rmap_walk(folio, &rwc);
-
-	return args.valid && !folio_mapcount(folio);
-}
-
 /**
  * make_device_exclusive() - Mark a page for exclusive use by a device
  * @mm: mm_struct of associated target process
@@ -2541,22 +2416,31 @@ static bool folio_make_device_exclusive(
 struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
 		void *owner, struct folio **foliop)
 {
-	struct folio *folio;
+	struct mmu_notifier_range range;
+	struct folio *folio, *fw_folio;
+	struct vm_area_struct *vma;
+	struct folio_walk fw;
 	struct page *page;
-	long npages;
+	swp_entry_t entry;
+	pte_t swp_pte;
 
 	mmap_assert_locked(mm);
+	addr = PAGE_ALIGN_DOWN(addr);
 
 	/*
 	 * Fault in the page writable and try to lock it; note that if the
 	 * address would already be marked for exclusive use by a device,
 	 * the GUP call would undo that first by triggering a fault.
+	 *
+	 * If any other device would already map this page exclusively, the
+	 * fault will trigger a conversion to an ordinary
+	 * (non-device-exclusive) PTE and issue a MMU_NOTIFY_EXCLUSIVE.
 	 */
-	npages = get_user_pages_remote(mm, addr, 1,
-				       FOLL_GET | FOLL_WRITE | FOLL_SPLIT_PMD,
-				       &page, NULL);
-	if (npages != 1)
-		return ERR_PTR(npages);
+	page = get_user_page_vma_remote(mm, addr,
+					FOLL_GET | FOLL_WRITE | FOLL_SPLIT_PMD,
+					&vma);
+	if (IS_ERR(page))
+		return page;
 	folio = page_folio(page);
 
 	if (!folio_test_anon(folio) || folio_test_hugetlb(folio)) {
@@ -2569,11 +2453,61 @@ struct page *make_device_exclusive(struc
 		return ERR_PTR(-EBUSY);
 	}
 
-	if (!folio_make_device_exclusive(folio, mm, addr, owner)) {
+	/*
+	 * Inform secondary MMUs that we are going to convert this PTE to
+	 * device-exclusive, such that they unmap it now. Note that the
+	 * caller must filter this event out to prevent livelocks.
+	 */
+	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0,
+				      mm, addr, addr + PAGE_SIZE, owner);
+	mmu_notifier_invalidate_range_start(&range);
+
+	/*
+	 * Let's do a second walk and make sure we still find the same page
+	 * mapped writable. Note that any page of an anonymous folio can
+	 * only be mapped writable using exactly one PTE ("exclusive"), so
+	 * there cannot be other mappings.
+	 */
+	fw_folio = folio_walk_start(&fw, vma, addr, 0);
+	if (fw_folio != folio || fw.page != page ||
+	    fw.level != FW_LEVEL_PTE || !pte_write(fw.pte)) {
+		if (fw_folio)
+			folio_walk_end(&fw, vma);
+		mmu_notifier_invalidate_range_end(&range);
 		folio_unlock(folio);
 		folio_put(folio);
 		return ERR_PTR(-EBUSY);
 	}
+
+	/* Nuke the page table entry so we get the uptodate dirty bit. */
+	flush_cache_page(vma, addr, page_to_pfn(page));
+	fw.pte = ptep_clear_flush(vma, addr, fw.ptep);
+
+	/* Set the dirty flag on the folio now the PTE is gone. */
+	if (pte_dirty(fw.pte))
+		folio_mark_dirty(folio);
+
+	/*
+	 * Store the pfn of the page in a special device-exclusive PFN swap PTE.
+	 * do_swap_page() will trigger the conversion back while holding the
+	 * folio lock.
+	 */
+	entry = make_writable_device_exclusive_entry(page_to_pfn(page));
+	swp_pte = swp_entry_to_pte(entry);
+	if (pte_soft_dirty(fw.pte))
+		swp_pte = pte_swp_mksoft_dirty(swp_pte);
+	/* The pte is writable, uffd-wp does not apply. */
+	set_pte_at(mm, addr, fw.ptep, swp_pte);
+
+	/*
+	 * TODO: The device-exclusive PFN swap PTE holds a folio reference but
+	 * does not count as a mapping (mapcount), which is wrong and must be
+	 * fixed, otherwise RMAP walks don't behave as expected.
+	 */
+	folio_remove_rmap_pte(folio, page, vma);
+
+	folio_walk_end(&fw, vma);
+	mmu_notifier_invalidate_range_end(&range);
 	*foliop = folio;
 	return page;
 }
_

Patches currently in -mm which might be from david@redhat.com are

mm-factor-out-large-folio-handling-from-folio_order-into-folio_large_order.patch
mm-factor-out-large-folio-handling-from-folio_nr_pages-into-folio_large_nr_pages.patch
mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page.patch
mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page-fix.patch
mm-move-hugetlb-specific-things-in-folio-to-page.patch
mm-move-_pincount-in-folio-to-page-on-32bit.patch
mm-move-_entire_mapcount-in-folio-to-page-on-32bit.patch
mm-rmap-pass-dst_vma-to-folio_dup_file_rmap_pte-and-friends.patch
mm-rmap-pass-vma-to-__folio_add_rmap.patch
mm-rmap-abstract-large-mapcount-operations-for-large-folios-hugetlb.patch
bit_spinlock-__always_inline-unlock-functions.patch
mm-rmap-use-folio_large_nr_pages-in-add-remove-functions.patch
mm-rmap-basic-mm-owner-tracking-for-large-folios-hugetlb.patch
mm-copy-on-write-cow-reuse-support-for-pte-mapped-thp.patch
mm-convert-folio_likely_mapped_shared-to-folio_maybe_mapped_shared.patch
mm-config_no_page_mapcount-to-prepare-for-not-maintain-per-page-mapcounts-in-large-folios.patch
fs-proc-page-remove-per-page-mapcount-dependency-for-proc-kpagecount-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-pm_mmap_exclusive-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-mapmax-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-smaps-smaps_rollup-config_no_page_mapcount.patch
mm-stop-maintaining-the-per-page-mapcount-of-large-folios-config_no_page_mapcount.patch

