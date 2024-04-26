Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D09B7EF08
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104011; cv=none; b=NZVtV3Ng6esNaZiBD+nnmtYgfS3InY8ig11Y8a0M/00dbJQRwx6ntvo/ojGttHfb5FQZc90fzvdIXJByjfN4QaYmX31qsw5uqGtWX5L/4wB+unmWROjprGp1LMajI2PyaRBttjocppObo88L3aEDO5ZeKWaryAbUfba+3mLtsnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104011; c=relaxed/simple;
	bh=2C4tjQ6hpf2r0z21NjS9yO3b+eWeupiwdA7Pjjrs5u8=;
	h=Date:To:From:Subject:Message-Id; b=jNsT453HxEuZLycc1v2f0TDez/6CYCdC8swDNNHLGtCYpIilFXREcbUKy9NkL9jn3vB9dYshROw+XZUK0EW00TjOxo/SCllqJ28IYTo7BXGTEn0sZ7eTg6oSH2N4LBZxnNOsB5qVtKE4gZqGC01waYJFkvdpev7eIZfCHplg1gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WL+JT1Wu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WL+JT1Wu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41936C113CD;
	Fri, 26 Apr 2024 04:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104011;
	bh=2C4tjQ6hpf2r0z21NjS9yO3b+eWeupiwdA7Pjjrs5u8=;
	h=Date:To:From:Subject:From;
	b=WL+JT1WuZctbJNle4bPRTKIrQVXrslpipZU1itCQ2hr5S9JxbcgRB4KaGXnOuWCzF
	 MlMxtFULqFXXSgDF6bnTSg2zEvRSglTPr0oP4ab6qJzn+qeUUkaIql/O13O6B1d6qS
	 y+0cDfz3W0AA9VD9rlH6zg0VM4K3jYyPmc+4I8Nk=
Date: Thu, 25 Apr 2024 21:00:10 -0700
To: mm-commits@vger.kernel.org,xrivendell7@gmail.com,samsun1006219@gmail.com,rppt@kernel.org,mszeredi@redhat.com,lstoakes@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch removed from -mm tree
Message-Id: <20240426040011.41936C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: merge folio_is_secretmem() and folio_fast_pin_allowed() into gup_fast_folio_allowed()
has been removed from the -mm tree.  Its filename was
     mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: merge folio_is_secretmem() and folio_fast_pin_allowed() into gup_fast_folio_allowed()
Date: Tue, 26 Mar 2024 15:32:10 +0100

folio_is_secretmem() is currently only used during GUP-fast.  Nowadays,
folio_fast_pin_allowed() performs similar checks during GUP-fast and
contains a lot of careful handling -- READ_ONCE() -- , sanity checks --
lockdep_assert_irqs_disabled() -- and helpful comments on how this
handling is safe and correct.

So let's merge folio_is_secretmem() into folio_fast_pin_allowed().  Rename
folio_fast_pin_allowed() to gup_fast_folio_allowed(), to better match the
new semantics.

Link: https://lkml.kernel.org/r/20240326143210.291116-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: xingwei lee <xrivendell7@gmail.com>
Cc: yue sun <samsun1006219@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/secretmem.h |   21 +--------------
 mm/gup.c                  |   48 +++++++++++++++++++++---------------
 2 files changed, 30 insertions(+), 39 deletions(-)

--- a/include/linux/secretmem.h~mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed
+++ a/include/linux/secretmem.h
@@ -6,25 +6,8 @@
 
 extern const struct address_space_operations secretmem_aops;
 
-static inline bool folio_is_secretmem(struct folio *folio)
+static inline bool secretmem_mapping(struct address_space *mapping)
 {
-	struct address_space *mapping;
-
-	/*
-	 * Using folio_mapping() is quite slow because of the actual call
-	 * instruction.
-	 * We know that secretmem pages are not compound, so we can
-	 * save a couple of cycles here.
-	 */
-	if (folio_test_large(folio))
-		return false;
-
-	mapping = (struct address_space *)
-		((unsigned long)folio->mapping & ~PAGE_MAPPING_FLAGS);
-
-	if (!mapping || mapping != folio->mapping)
-		return false;
-
 	return mapping->a_ops == &secretmem_aops;
 }
 
@@ -38,7 +21,7 @@ static inline bool vma_is_secretmem(stru
 	return false;
 }
 
-static inline bool folio_is_secretmem(struct folio *folio)
+static inline bool secretmem_mapping(struct address_space *mapping)
 {
 	return false;
 }
--- a/mm/gup.c~mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed
+++ a/mm/gup.c
@@ -2468,12 +2468,14 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
 #ifdef CONFIG_HAVE_FAST_GUP
 
 /*
- * Used in the GUP-fast path to determine whether a pin is permitted for a
- * specific folio.
+ * Used in the GUP-fast path to determine whether GUP is permitted to work on
+ * a specific folio.
  *
  * This call assumes the caller has pinned the folio, that the lowest page table
  * level still points to this folio, and that interrupts have been disabled.
  *
+ * GUP-fast must reject all secretmem folios.
+ *
  * Writing to pinned file-backed dirty tracked folios is inherently problematic
  * (see comment describing the writable_file_mapping_allowed() function). We
  * therefore try to avoid the most egregious case of a long-term mapping doing
@@ -2483,25 +2485,34 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
  * in the fast path, so instead we whitelist known good cases and if in doubt,
  * fall back to the slow path.
  */
-static bool folio_fast_pin_allowed(struct folio *folio, unsigned int flags)
+static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
 {
+	bool reject_file_backed = false;
 	struct address_space *mapping;
+	bool check_secretmem = false;
 	unsigned long mapping_flags;
 
 	/*
 	 * If we aren't pinning then no problematic write can occur. A long term
 	 * pin is the most egregious case so this is the one we disallow.
 	 */
-	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=
+	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) ==
 	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
-		return true;
+		reject_file_backed = true;
+
+	/* We hold a folio reference, so we can safely access folio fields. */
 
-	/* The folio is pinned, so we can safely access folio fields. */
+	/* secretmem folios are always order-0 folios. */
+	if (IS_ENABLED(CONFIG_SECRETMEM) && !folio_test_large(folio))
+		check_secretmem = true;
+
+	if (!reject_file_backed && !check_secretmem)
+		return true;
 
 	if (WARN_ON_ONCE(folio_test_slab(folio)))
 		return false;
 
-	/* hugetlb mappings do not require dirty-tracking. */
+	/* hugetlb neither requires dirty-tracking nor can be secretmem. */
 	if (folio_test_hugetlb(folio))
 		return true;
 
@@ -2537,10 +2548,12 @@ static bool folio_fast_pin_allowed(struc
 
 	/*
 	 * At this point, we know the mapping is non-null and points to an
-	 * address_space object. The only remaining whitelisted file system is
-	 * shmem.
+	 * address_space object.
 	 */
-	return shmem_mapping(mapping);
+	if (check_secretmem && secretmem_mapping(mapping))
+		return false;
+	/* The only remaining allowed file system is shmem. */
+	return !reject_file_backed || shmem_mapping(mapping);
 }
 
 static void __maybe_unused undo_dev_pagemap(int *nr, int nr_start,
@@ -2626,18 +2639,13 @@ static int gup_pte_range(pmd_t pmd, pmd_
 		if (!folio)
 			goto pte_unmap;
 
-		if (unlikely(folio_is_secretmem(folio))) {
-			gup_put_folio(folio, 1, flags);
-			goto pte_unmap;
-		}
-
 		if (unlikely(pmd_val(pmd) != pmd_val(*pmdp)) ||
 		    unlikely(pte_val(pte) != pte_val(ptep_get(ptep)))) {
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
 
-		if (!folio_fast_pin_allowed(folio, flags)) {
+		if (!gup_fast_folio_allowed(folio, flags)) {
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
@@ -2834,7 +2842,7 @@ static int gup_hugepte(pte_t *ptep, unsi
 		return 0;
 	}
 
-	if (!folio_fast_pin_allowed(folio, flags)) {
+	if (!gup_fast_folio_allowed(folio, flags)) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
@@ -2905,7 +2913,7 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 		return 0;
 	}
 
-	if (!folio_fast_pin_allowed(folio, flags)) {
+	if (!gup_fast_folio_allowed(folio, flags)) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
@@ -2949,7 +2957,7 @@ static int gup_huge_pud(pud_t orig, pud_
 		return 0;
 	}
 
-	if (!folio_fast_pin_allowed(folio, flags)) {
+	if (!gup_fast_folio_allowed(folio, flags)) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
@@ -2994,7 +3002,7 @@ static int gup_huge_pgd(pgd_t orig, pgd_
 		return 0;
 	}
 
-	if (!folio_fast_pin_allowed(folio, flags)) {
+	if (!gup_fast_folio_allowed(folio, flags)) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
_

Patches currently in -mm which might be from david@redhat.com are

drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map.patch
mm-pass-vma-instead-of-mm-to-follow_pte.patch
mm-follow_pte-improvements.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again-fix.patch
mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte.patch
mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating.patch
mm-track-mapcount-of-large-folios-in-single-value.patch
mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios-fix.patch
mm-memory-use-folio_mapcount-in-zap_present_folio_ptes.patch
mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check.patch
mm-memory-failure-use-folio_mapcount-in-hwpoison_user_mappings.patch
mm-page_alloc-use-folio_mapped-in-__alloc_contig_migrate_range.patch
mm-migrate-use-folio_likely_mapped_shared-in-add_page_for_migration.patch
sh-mm-cache-use-folio_mapped-in-copy_from_user_page.patch
mm-filemap-use-folio_mapcount-in-filemap_unaccount_folio.patch
mm-migrate_device-use-folio_mapcount-in-migrate_vma_check_page.patch
trace-events-page_ref-trace-the-raw-page-mapcount-value.patch
xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios.patch
mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio.patch
documentation-admin-guide-cgroup-v1-memoryrst-dont-reference-page_mapcount.patch
mm-ksm-rename-get_ksm_page_flags-to-ksm_get_folio_flags.patch
mm-ksm-remove-page_mapcount-usage-in-stable_tree_search.patch
fs-proc-task_mmu-convert-pagemap_hugetlb_range-to-work-on-folios.patch
fs-proc-task_mmu-convert-smaps_hugetlb_range-to-work-on-folios.patch
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation.patch
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation-v2.patch
mm-khugepaged-replace-page_mapcount-check-by-folio_likely_mapped_shared.patch
loongarch-tlb-fix-error-parameter-ptep-set-but-not-used-due-to-__tlb_remove_tlb_entry.patch

