Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA2A7EF06
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104077; cv=none; b=DRzKdUOerdvcuDUmTH3Le1haQ6eMATM6WxjBgJs5InB3OJLLEC3/TuHCr61cRz5mf5ZbSwvj79ZdlxxMj7gPrEFrHGc8saaFpN5PIJQCfMHgBnrrDYX6CHa6Je+V1hHMJPGCA/jCSAUchG4kmgtHq6omxYT5ZAvW1AWo3wOpoxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104077; c=relaxed/simple;
	bh=FKIEmfRU78vJ+bTbSaUw5+zteUQwlMxR5h/wKxL1DSs=;
	h=Date:To:From:Subject:Message-Id; b=bkbgS+rNoUAMc+uzLl85ZR87QU8iD/rKGisOF2m4KHgfAoHYVJyDq28WoWTi9qbvYEecprX+7VQ10UTbZXc8rznRBf2wJssSHgvPCk5ZMs9KIAR8ut2NYa6LdaTh2/bfIJjF6zwrs4H2/KQaKq7VfCzjcAEVZA42Od/0KryFJtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nuVFkpNk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nuVFkpNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91EEC113CD;
	Fri, 26 Apr 2024 04:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104076;
	bh=FKIEmfRU78vJ+bTbSaUw5+zteUQwlMxR5h/wKxL1DSs=;
	h=Date:To:From:Subject:From;
	b=nuVFkpNkkmxNbrpRj78YrPj6c3Od7jLQ2ww16sLWh2p5z1S5UP38736s/TBpaFODN
	 fzcTPMEUyeUtxjsOlboqpY0RSYuyICuPvBngSuNY/qdbvJHslBe2PaIWLwC6JaykI5
	 kDPvnSDAMyOeEJV3AcPePnq/rbfm13+42Wl6sb7A=
Date: Thu, 25 Apr 2024 21:01:15 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,davem@davemloft.net,andreas@gaisler.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-prot-parameter-from-move_pte.patch removed from -mm tree
Message-Id: <20240426040116.A91EEC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove "prot" parameter from move_pte()
has been removed from the -mm tree.  Its filename was
     mm-remove-prot-parameter-from-move_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: remove "prot" parameter from move_pte()
Date: Wed, 27 Mar 2024 15:33:01 +0100

The "prot" parameter is unused, and using it instead of what's stored in
that particular PTE would very likely be wrong.  Let's simply remove it.

Link: https://lkml.kernel.org/r/20240327143301.741807-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_64.h |    2 +-
 include/linux/pgtable.h             |    2 +-
 mm/mremap.c                         |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/sparc/include/asm/pgtable_64.h~mm-remove-prot-parameter-from-move_pte
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -957,7 +957,7 @@ static inline void set_ptes(struct mm_st
 
 #ifdef DCACHE_ALIASING_POSSIBLE
 #define __HAVE_ARCH_MOVE_PTE
-#define move_pte(pte, prot, old_addr, new_addr)				\
+#define move_pte(pte, old_addr, new_addr)				\
 ({									\
 	pte_t newpte = (pte);						\
 	if (tlb_type != hypervisor && pte_present(pte)) {		\
--- a/include/linux/pgtable.h~mm-remove-prot-parameter-from-move_pte
+++ a/include/linux/pgtable.h
@@ -1079,7 +1079,7 @@ static inline void arch_swap_restore(swp
 #endif
 
 #ifndef __HAVE_ARCH_MOVE_PTE
-#define move_pte(pte, prot, old_addr, new_addr)	(pte)
+#define move_pte(pte, old_addr, new_addr)	(pte)
 #endif
 
 #ifndef pte_accessible
--- a/mm/mremap.c~mm-remove-prot-parameter-from-move_pte
+++ a/mm/mremap.c
@@ -205,7 +205,7 @@ static int move_ptes(struct vm_area_stru
 		 */
 		if (pte_present(pte))
 			force_flush = true;
-		pte = move_pte(pte, new_vma->vm_page_prot, old_addr, new_addr);
+		pte = move_pte(pte, old_addr, new_addr);
 		pte = move_soft_dirty_pte(pte);
 		set_pte_at(mm, new_addr, new_pte, pte);
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

