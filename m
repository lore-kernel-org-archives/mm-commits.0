Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AB512B94;
	Thu, 15 Oct 2026 22:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792105101; cv=none; b=oRG42u2BglZUuxC1Fex6M3a8JZ7hWxNFQoDGMi0OmhejRtmILv9PxsoQyLcmRwK94a8eEdlfo9as6xc/wMk9uEnU0169Lp+CJ6IPVV8aV4P3vK8I+z1nwNBpXDle72+yDe2M0yqxgz8rJRahEKGcjULo8YEnlogR+ClftxpTPxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792105101; c=relaxed/simple;
	bh=MdWDHgnFwRQhUR/c2ERsgAqx9qXoa/diigwjMKn9iCo=;
	h=Date:To:From:Subject:Message-Id; b=HA3UK+PcfooCe872P39heAnJap1TRE1Auk1mwD+dfMoi70KtQ1N1vye/ekPzk6yir2+argZ4Ynliddpz+bxvVcCxNxNKeBldBYYzMPMaCBVKjHA4MUuxPJguXAa9GHEi+R7cluMgFPCeUiX2sHHBsUryyRHjubQ5xwByiYSUVVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QbWIhkDm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QbWIhkDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345701F000C4;
	Thu, 15 Oct 2026 22:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792105100;
	bh=9zDsEilw2IExJGDrBfzncpAIgcNkqqLMtTUyydtfZw0=;
	h=Date:To:From:Subject;
	b=QbWIhkDmsYRXzeWI7B/r69PKYos8O3WziI8jKMTLvkb3AKqpRqZjZO7Ej+eFAfWyA
	 cf0TytfCCmn6IlnKD3bapPVc+8LwwREc4oX6ADc12nDCUNxsmMAycELyLT9nuVU5aH
	 zRDbrSMiIrZb0ClMibVRHh7/qqHVzhJ5ce1IPZmI=
Date: Thu, 15 Oct 2026 15:58:19 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mel@csn.ul.ie,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,kas@kernel.org,josef@toxicpanda.com,jannh@google.com,agl@us.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-use-after-free-in-hugetlb_mfill_atomic_pte.patch added to mm-hotfixes-unstable branch
Message-Id: <20261015225820.345701F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix use-after-free in hugetlb_mfill_atomic_pte()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-use-after-free-in-hugetlb_mfill_atomic_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-use-after-free-in-hugetlb_mfill_atomic_pte.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/hugetlb: fix use-after-free in hugetlb_mfill_atomic_pte()
Date: Thu, 15 Oct 2026 18:07:09 +0200

Let's fix another instance where we use a folio after dropping the PTL,
where someone else could e.g., MADV_DONTNEED it once we drop the PTL,
making us trigger a use-after-free on the folio.

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-3-42796911043b@kernel.org
Fixes: cb6acd01e2e4 ("hugetlbfs: fix races and page leaks during migration")
Fixes: 1c9e8def43a3 ("userfaultfd: hugetlbfs: add UFFDIO_COPY support for shared mappings")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: <stable@vger.kernel.org>
---

 mm/hugetlb.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-use-after-free-in-hugetlb_mfill_atomic_pte
+++ a/mm/hugetlb.c
@@ -6489,11 +6489,16 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache(dst_vma, dst_addr, dst_pte);
 
-	spin_unlock(ptl);
 	if (!is_continue)
 		folio_set_hugetlb_migratable(folio);
 	if (vm_shared || is_continue)
 		folio_unlock(folio);
+
+	/*
+	 * Hold the PTL until we're done with the folio: the page table owns the
+	 * folio reference now.
+	 */
+	spin_unlock(ptl);
 	ret = 0;
 out:
 	return ret;
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-fix-use-after-free-in-hugetlb_mfill_atomic_pte.patch
mm-hugetlb-tolerate-uffd-bits-set-without-uffd-for-prot_none-ptes.patch
mm-hugetlb-tolerate-uffd_wp-markers-outside-uffd-wp-vmas.patch
mm-mremap-fix-calling-fixup_hugetlb_reservations-on-the-wrong-vma.patch
arm64-mm-move-__check_safe_pte_update-fix.patch
mm-sparse-move-mem_section-init-to-sparse_extreme_init.patch
mm-sparse-refactor-sparse_sections_init.patch
mm-sparse-move-initialization-of-section-metadata-to-sparse_metadata_init.patch
mm-sparse-rename-and-cleanup-sparse_init_nid.patch
mm-sparse-cleanup-sparse_init_one_section.patch
mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr.patch
mm-sparse-remove-pfn_in_present_section.patch
mm-sparse-move-__highest_used_section_nr-handling.patch
scripts-gdb-mmpy-remove-fallbacks-for-section_has_mem_map-and-section_is_early.patch
mm-sparse-remove-section_marked_present.patch
mm-sparse-remove-flags-parameter-from-sparse_init_one_section.patch
fs-proc-page-clarify-comment-in-get_max_dump_pfn.patch
mm-memory_hotplug-drop-config_have_arch_pfn_valid-handling-from-pfn_to_online_page.patch
vmcoreinfo-export-section_has_mem_map.patch
mm-disallow-ioremaping-ordinary-ram-in-generic_access_phys.patch
mm-userfaultfd-only-allocate-anon_vma-in-cow-mappings.patch

