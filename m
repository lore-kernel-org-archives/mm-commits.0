Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5881621516B
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188199; cv=none; b=NqvCCDB7K6R0rwigTuMe9xF939kj4YUwykQBxbJMM3+hfvn+mSu5a/Qz4UaYz8s90OyBuHyByJtsMcIphBOgRocpT35ooqgber+Y3KIRnef/Oy19lQwPlf/4JnA2dLvprLcrIz8mZdnSUplVnm1oCknGnqOemXD9mzpkwCyyQtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188199; c=relaxed/simple;
	bh=4B6mGVThsePIASLmRJub1wL9mmobhjEmYvDKnqeGM7U=;
	h=Date:To:From:Subject:Message-Id; b=XSP8ixQN+MLWeCpDQ3Y63sSTZBqa+5wkb+d7h/CiMmcZ2AD+VxEw5SkH/WFlXjTL28fPkKOegj3cyw2sncbquQvk0Q44QDFE4fjqLsxmmWfv0XAL7Pc/NsfhhlWp6jJqGDdKjzGzswo+ShabfFxBKQZW7OuuLjHUmOuLvt/B6ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dTwf9CvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dTwf9CvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2760CC4CEEC;
	Mon, 17 Mar 2025 05:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188199;
	bh=4B6mGVThsePIASLmRJub1wL9mmobhjEmYvDKnqeGM7U=;
	h=Date:To:From:Subject:From;
	b=dTwf9CvODbmRqOUucVSHAmqYFdbE3ncdnOIMJE5twrPRhNqVJvHi7Fojo8VlLPc14
	 JhYQdcG235dGpeqEc1OjXePf/8o53kRCkjGcA3MF0G0exB9TEHyj4nA5D9yT15DKCT
	 IpeCH6tJscCQrgaJbKt8nMGj1oQACSSSrLzNcjg4=
Date: Sun, 16 Mar 2025 22:09:58 -0700
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,sj@kernel.org,si.yanteng@linux.dev,simona.vetter@ffwll.ch,peterz@infradead.org,peterx@redhat.com,pasha.tatashin@soleen.com,oleg@redhat.com,mhiramat@kernel.org,lyude@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kherbst@redhat.com,jhubbard@nvidia.com,jglisse@redhat.com,jgg@nvidia.com,jannh@google.com,dakr@kernel.org,corbet@lwn.net,apopple@nvidia.com,alexs@kernel.org,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-handle-device-exclusive-entries-correctly-in-try_to_migrate_one.patch removed from -mm tree
Message-Id: <20250317050959.2760CC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: handle device-exclusive entries correctly in try_to_migrate_one()
has been removed from the -mm tree.  Its filename was
     mm-rmap-handle-device-exclusive-entries-correctly-in-try_to_migrate_one.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: handle device-exclusive entries correctly in try_to_migrate_one()
Date: Mon, 10 Feb 2025 20:37:53 +0100

Ever since commit b756a3b5e7ea ("mm: device exclusive memory access") we
can return with a device-exclusive entry from page_vma_mapped_walk().

try_to_migrate_one() is not prepared for that, so teach it about these PFN
swap PTEs.  We already handle device-private entries by specializing on
the folio, so we can reshuffle that code to make it work on the PFN swap
PTEs instead.

Get rid of the folio_is_device_private() handling.  Note that we never
currently expect device-private folios with HWPoison flag set at that
point, so add a warning in case that ever changes and we can figure out
what the right thing to do is.

Note that we could currently only run into this case with device-exclusive
entries on THPs.  We still adjust the mapcount on conversion to
device-exclusive; this makes the rmap walk abort early for small folios,
because we'll always have !folio_mapped() with a single device-exclusive
entry.  We'll adjust the mapcount logic once all page_vma_mapped_walk()
users can properly handle device-exclusive entries.

Further note that try_to_migrate() calls MMU notifiers and holds the folio
lock, so any device-exclusive users should be properly prepared for a
device-exclusive PTE to "vanish".

Link: https://lkml.kernel.org/r/20250210193801.781278-12-david@redhat.com
Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
Signed-off-by: David Hildenbrand <david@redhat.com>
Tested-by: Alistair Popple <apopple@nvidia.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
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

 mm/rmap.c |  124 +++++++++++++++++++++-------------------------------
 1 file changed, 51 insertions(+), 73 deletions(-)

--- a/mm/rmap.c~mm-rmap-handle-device-exclusive-entries-correctly-in-try_to_migrate_one
+++ a/mm/rmap.c
@@ -2039,9 +2039,9 @@ static bool try_to_migrate_one(struct fo
 {
 	struct mm_struct *mm = vma->vm_mm;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
+	bool anon_exclusive, writable, ret = true;
 	pte_t pteval;
 	struct page *subpage;
-	bool anon_exclusive, ret = true;
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 	unsigned long pfn;
@@ -2108,24 +2108,19 @@ static bool try_to_migrate_one(struct fo
 		/* Unexpected PMD-mapped THP? */
 		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
 
-		pfn = pte_pfn(ptep_get(pvmw.pte));
-
-		if (folio_is_zone_device(folio)) {
-			/*
-			 * Our PTE is a non-present device exclusive entry and
-			 * calculating the subpage as for the common case would
-			 * result in an invalid pointer.
-			 *
-			 * Since only PAGE_SIZE pages can currently be
-			 * migrated, just set it to page. This will need to be
-			 * changed when hugepage migrations to device private
-			 * memory are supported.
-			 */
-			VM_BUG_ON_FOLIO(folio_nr_pages(folio) > 1, folio);
-			subpage = &folio->page;
+		/*
+		 * Handle PFN swap PTEs, such as device-exclusive ones, that
+		 * actually map pages.
+		 */
+		pteval = ptep_get(pvmw.pte);
+		if (likely(pte_present(pteval))) {
+			pfn = pte_pfn(pteval);
 		} else {
-			subpage = folio_page(folio, pfn - folio_pfn(folio));
+			pfn = swp_offset_pfn(pte_to_swp_entry(pteval));
+			VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
 		}
+
+		subpage = folio_page(folio, pfn - folio_pfn(folio));
 		address = pvmw.address;
 		anon_exclusive = folio_test_anon(folio) &&
 				 PageAnonExclusive(subpage);
@@ -2181,7 +2176,10 @@ static bool try_to_migrate_one(struct fo
 			}
 			/* Nuke the hugetlb page table entry */
 			pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
-		} else {
+			if (pte_dirty(pteval))
+				folio_mark_dirty(folio);
+			writable = pte_write(pteval);
+		} else if (likely(pte_present(pteval))) {
 			flush_cache_page(vma, address, pfn);
 			/* Nuke the page table entry. */
 			if (should_defer_flush(mm, flags)) {
@@ -2199,54 +2197,23 @@ static bool try_to_migrate_one(struct fo
 			} else {
 				pteval = ptep_clear_flush(vma, address, pvmw.pte);
 			}
+			if (pte_dirty(pteval))
+				folio_mark_dirty(folio);
+			writable = pte_write(pteval);
+		} else {
+			pte_clear(mm, address, pvmw.pte);
+			writable = is_writable_device_private_entry(pte_to_swp_entry(pteval));
 		}
 
-		/* Set the dirty flag on the folio now the pte is gone. */
-		if (pte_dirty(pteval))
-			folio_mark_dirty(folio);
+		VM_WARN_ON_FOLIO(writable && folio_test_anon(folio) &&
+				!anon_exclusive, folio);
 
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		if (folio_is_device_private(folio)) {
-			unsigned long pfn = folio_pfn(folio);
-			swp_entry_t entry;
-			pte_t swp_pte;
-
-			if (anon_exclusive)
-				WARN_ON_ONCE(folio_try_share_anon_rmap_pte(folio,
-									   subpage));
-
-			/*
-			 * Store the pfn of the page in a special migration
-			 * pte. do_swap_page() will wait until the migration
-			 * pte is removed and then restart fault handling.
-			 */
-			entry = pte_to_swp_entry(pteval);
-			if (is_writable_device_private_entry(entry))
-				entry = make_writable_migration_entry(pfn);
-			else if (anon_exclusive)
-				entry = make_readable_exclusive_migration_entry(pfn);
-			else
-				entry = make_readable_migration_entry(pfn);
-			swp_pte = swp_entry_to_pte(entry);
+		if (PageHWPoison(subpage)) {
+			VM_WARN_ON_FOLIO(folio_is_device_private(folio), folio);
 
-			/*
-			 * pteval maps a zone device page and is therefore
-			 * a swap pte.
-			 */
-			if (pte_swp_soft_dirty(pteval))
-				swp_pte = pte_swp_mksoft_dirty(swp_pte);
-			if (pte_swp_uffd_wp(pteval))
-				swp_pte = pte_swp_mkuffd_wp(swp_pte);
-			set_pte_at(mm, pvmw.address, pvmw.pte, swp_pte);
-			trace_set_migration_pte(pvmw.address, pte_val(swp_pte),
-						folio_order(folio));
-			/*
-			 * No need to invalidate here it will synchronize on
-			 * against the special swap migration pte.
-			 */
-		} else if (PageHWPoison(subpage)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (folio_test_hugetlb(folio)) {
 				hugetlb_count_sub(folio_nr_pages(folio), mm);
@@ -2256,8 +2223,8 @@ static bool try_to_migrate_one(struct fo
 				dec_mm_counter(mm, mm_counter(folio));
 				set_pte_at(mm, address, pvmw.pte, pteval);
 			}
-
-		} else if (pte_unused(pteval) && !userfaultfd_armed(vma)) {
+		} else if (likely(pte_present(pteval)) && pte_unused(pteval) &&
+			   !userfaultfd_armed(vma)) {
 			/*
 			 * The guest indicated that the page content is of no
 			 * interest anymore. Simply discard the pte, vmscan
@@ -2273,6 +2240,11 @@ static bool try_to_migrate_one(struct fo
 			swp_entry_t entry;
 			pte_t swp_pte;
 
+			/*
+			 * arch_unmap_one() is expected to be a NOP on
+			 * architectures where we could have PFN swap PTEs,
+			 * so we'll not check/care.
+			 */
 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
 				if (folio_test_hugetlb(folio))
 					set_huge_pte_at(mm, address, pvmw.pte,
@@ -2283,8 +2255,6 @@ static bool try_to_migrate_one(struct fo
 				page_vma_mapped_walk_done(&pvmw);
 				break;
 			}
-			VM_BUG_ON_PAGE(pte_write(pteval) && folio_test_anon(folio) &&
-				       !anon_exclusive, subpage);
 
 			/* See folio_try_share_anon_rmap_pte(): clear PTE first. */
 			if (folio_test_hugetlb(folio)) {
@@ -2309,7 +2279,7 @@ static bool try_to_migrate_one(struct fo
 			 * pte. do_swap_page() will wait until the migration
 			 * pte is removed and then restart fault handling.
 			 */
-			if (pte_write(pteval))
+			if (writable)
 				entry = make_writable_migration_entry(
 							page_to_pfn(subpage));
 			else if (anon_exclusive)
@@ -2318,15 +2288,23 @@ static bool try_to_migrate_one(struct fo
 			else
 				entry = make_readable_migration_entry(
 							page_to_pfn(subpage));
-			if (pte_young(pteval))
-				entry = make_migration_entry_young(entry);
-			if (pte_dirty(pteval))
-				entry = make_migration_entry_dirty(entry);
-			swp_pte = swp_entry_to_pte(entry);
-			if (pte_soft_dirty(pteval))
-				swp_pte = pte_swp_mksoft_dirty(swp_pte);
-			if (pte_uffd_wp(pteval))
-				swp_pte = pte_swp_mkuffd_wp(swp_pte);
+			if (likely(pte_present(pteval))) {
+				if (pte_young(pteval))
+					entry = make_migration_entry_young(entry);
+				if (pte_dirty(pteval))
+					entry = make_migration_entry_dirty(entry);
+				swp_pte = swp_entry_to_pte(entry);
+				if (pte_soft_dirty(pteval))
+					swp_pte = pte_swp_mksoft_dirty(swp_pte);
+				if (pte_uffd_wp(pteval))
+					swp_pte = pte_swp_mkuffd_wp(swp_pte);
+			} else {
+				swp_pte = swp_entry_to_pte(entry);
+				if (pte_swp_soft_dirty(pteval))
+					swp_pte = pte_swp_mksoft_dirty(swp_pte);
+				if (pte_swp_uffd_wp(pteval))
+					swp_pte = pte_swp_mkuffd_wp(swp_pte);
+			}
 			if (folio_test_hugetlb(folio))
 				set_huge_pte_at(mm, address, pvmw.pte, swp_pte,
 						hsz);
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

