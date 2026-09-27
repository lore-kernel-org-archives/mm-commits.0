Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E33F3BB130
	for <mm-commits@vger.kernel.org>; Sun, 27 Sep 2026 21:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790545258; cv=none; b=eiSs0GwGcgDcV5AHWapjZGVa2MrjD4u2tHan6gOUbkvO760TidrtVCDSUQgxh7vnJwNpwlPh2VwzVVU2Hkbjv0HNlFkJkedtLBQmSaIdEqIQM2/JOss5bo0eb8rWtHi9EVwWO7nR1fUoEEqQc1UEXRtnSIz3F5jf5vvnSBYzcG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790545258; c=relaxed/simple;
	bh=zsESWuGBCSewB0EmXl7HETVpMqRL7+6v5wLUOme3yDI=;
	h=Date:To:From:Subject:Message-Id; b=UEuRYS23zL8EwmaFsIFoeVjfh/XZ/Z4Gd7+ONEDUSFLewhU5ZC0ZrJp99q8qpmODTTHf1nvIrgq+gb7wqHgFOnEUNQeVZG+LOUmpbp7MUNr9h4BotR4Um5eE6Ei/MsiD4TaULBAQJgRSqGBhQSx3k50UWuh01BEEtLlOigwDNK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lwzGm5p4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lwzGm5p4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0B91F00893;
	Sun, 27 Sep 2026 21:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790545257;
	bh=JDXEnd5h28A5HTFtMi9RT8naIXqhtOpgOkHXOJtdlX4=;
	h=Date:To:From:Subject;
	b=lwzGm5p4guvLW6yYIypT5WK1CsVsgYrA05Wm79qW2W3eiS0OAO6FypFD4RK0IVCly
	 b1YTjhM07wbIqRqOKCDafme+0VX44ap1c1e++v1ldctNEndGfTiHp4CTIuVbHkk5NG
	 JOvvI98bLXxFaLsU1mP6FtCFnoLEmMXqjqKfkOIA=
Date: Sun, 27 Sep 2026 14:40:56 -0700
To: mm-commits@vger.kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-madvise-use-vm_normal_folio_pmd-in-cold-pageout-pmd-range.patch removed from -mm tree
Message-Id: <20260927214056.EB0B91F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: use vm_normal_folio_pmd() in cold/pageout PMD range
has been removed from the -mm tree.  Its filename was
     mm-madvise-use-vm_normal_folio_pmd-in-cold-pageout-pmd-range.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: mm/madvise: use vm_normal_folio_pmd() in cold/pageout PMD range
Date: Fri, 11 Sep 2026 23:48:33 -0400

mmap a VM_MIXEDMAP region whose ->huge_fault installs a PMD through
vmf_insert_pfn_pmd() - mshv_vtl_low does this, and needs CAP_SYS_ADMIN to
open - then:

  madvise(p, PMD_SIZE, MADV_PAGEOUT);

With a stand-in module for the driver:

  BUG: unable to handle page fault for address: fffff587c0000008
  RIP: 0010:madvise_cold_or_pageout_pte_range+0x410/0x9b0
   walk_pgd_range+0x52b/0xaf0
   __walk_page_range+0x6a/0x1d0
   walk_page_range_vma_unsafe+0x8e/0x120
   madvise_pageout+0xb2/0x180
   madvise_vma_behavior+0x46b/0xa90
   do_madvise+0x108/0x190
   __x64_sys_madvise+0x26/0x30

Nothing validates the pfn on the way in:

  can_madv_lru_vma()     rejects VM_PFNMAP, but not VM_MIXEDMAP
  can_fault()            *pfn = vmf->pgoff & ~(mask >> PAGE_SHIFT);
  vmf_insert_pfn_pmd()   no pfn_valid() check
  pmd_folio()            pfn_to_page() -> unpopulated vmemmap

Even with a valid pfn the path is wrong.  The mapping carries no rmap, so
folio_maybe_mapped_shared() sees mapcount 0, and the walker goes on to
folio_deactivate(), or folio_isolate_lru() plus reclaim_pages(), against a
folio this mapping does not own.

Use vm_normal_folio_pmd() and skip on NULL, as the PTE half of this same
walker already does with vm_normal_folio().  This also filters the huge
zero PMD, so its separate check is no longer needed.

Link: https://lore.kernel.org/20260912034833.2952750-3-gourry@gourry.net
Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when inject")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org> # v6.19+
---

 mm/madvise.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/madvise.c~mm-madvise-use-vm_normal_folio_pmd-in-cold-pageout-pmd-range
+++ a/mm/madvise.c
@@ -395,16 +395,15 @@ static int madvise_cold_or_pageout_pte_r
 			return 0;
 
 		orig_pmd = *pmd;
-		if (is_huge_zero_pmd(orig_pmd))
-			goto huge_unlock;
-
 		if (unlikely(!pmd_present(orig_pmd))) {
 			VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
 					!pmd_is_device_private_entry(orig_pmd));
 			goto huge_unlock;
 		}
 
-		folio = pmd_folio(orig_pmd);
+		folio = vm_normal_folio_pmd(vma, addr, orig_pmd);
+		if (!folio)
+			goto huge_unlock;
 
 		if (folio_is_zone_device(folio))
 			goto huge_unlock;
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-mempolicy-take-a-cpuset-cookie-for-the-interleave-node-count.patch
mm-mempolicy-use-srcu-for-the-weighted-interleave-state.patch
mm-mempolicy-stop-copying-the-nodemask-in-the-interleave-paths.patch
mm-huge_memory-skip-zone-device-folios-in-madvise_free_huge_pmd.patch
mm-madvise-skip-zone-device-folios-in-cold-pageout-pmd-range.patch
mm-mempolicy-skip-zone-device-folios-when-queueing-folios.patch
mm-memory_hotplug-factor-out-node_is_memoryless.patch
mm-refactor-find_next_best_node-to-find_next_best_node_in.patch
mm-page_alloc-refactor-build_node_zonelist-out-of-build_zonelists.patch
proc-task_mmu-handle-special-pmds-in-clear_refs-and-pagemap.patch
mm-madvise-reclaim-isolated-folios-if-pte-restart-fails.patch
mm-madvise-use-folio_trylock-in-the-cold-pageout-pmd-split.patch

