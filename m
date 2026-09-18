Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D52466B17;
	Fri, 18 Sep 2026 05:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789710232; cv=none; b=AVbYz4XaP5r8yC3/28vj1rzHUjBIy9/3t9MvNEtJNSpUOhNuYL6Y7CHe65DmgzZRiYkpZHfQJJ8BHN8gI/L7cOb0bosuA1XxwLyYgEv1zVdkTkTHJKAZBULdoyW9hGyVzSYe3Z6XxqwniXT64HgbSw4ZGCO2Fshbg5IvkPxxV80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789710232; c=relaxed/simple;
	bh=wF618LWWJpb9x1F/ZFY4fXGlrX2e+v7jxa+VH2HGr+U=;
	h=Date:To:From:Subject:Message-Id; b=CtPxyENrjnwW3juE4j/1XZk0cDSEmKf+2BhTq5alXtGSkvByNi0gdlFbNI0VHErsfRqYyKpFqZVTsEFrTSiZycmiy6naCiw/diwxzGBoTv/rQ/+tZmWn4RjMlMEcI1TGQA7kW6cNZ6FlXUJW68jJCeXfAtcrwVBJ9tkOJZ0uqJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2hCWlSWT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2hCWlSWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB761F00893;
	Fri, 18 Sep 2026 05:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789710231;
	bh=7QcIDhVTCKkOv8SUP+wxeT7c/0RoKju/urrcuuKv7PQ=;
	h=Date:To:From:Subject;
	b=2hCWlSWTZeK5fOYK4534uxbmialNuckE4lWFXueCFiMJW6100G7vfmbfylD+cwqPQ
	 7gB/LgPRXRnkRcNxW4C2zw3BxyTeLHa/KHhs1PDaljgSXhtrsHN7d0gbJKMn0dOUXV
	 hdw6L4FUeeOK4guKQ715trWJZ5OxL8s1l5g0iTWY=
Date: Thu, 17 Sep 2026 22:43:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,ryan.roberts@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,zcgao@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-ops-common-use-a-page-aligned-address-in-damon_ptep_mkold.patch removed from -mm tree
Message-Id: <20260918054351.2FB761F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/ops-common: use a page-aligned address in damon_ptep_mkold()
has been removed from the -mm tree.  Its filename was
     mm-damon-ops-common-use-a-page-aligned-address-in-damon_ptep_mkold.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Gao <zcgao@amazon.com>
Subject: mm/damon/ops-common: use a page-aligned address in damon_ptep_mkold()
Date: Thu, 3 Sep 2026 17:28:27 -0700

__damon_va_prepare_access_check() picks a random byte address within the
region and stores it in r->sampling_addr.  damon_va_mkold() passes it into
a page table walk, which hands it to damon_ptep_mkold() as the address of
the page to sample:

  damon_va_mkold(mm, r->sampling_addr)
    damon_va_walk_page_range(mm, addr, addr + 1)
      damon_mkold_pmd_entry()
        damon_ptep_mkold(pte, vma, addr)
          ptep_test_and_clear_young(vma, addr, pte)
          mmu_notifier_clear_young(mm, addr, addr + PAGE_SIZE)

For arm64, before commit 6f0e1142173a ("arm64: mm: support batch clearing
of the young flag for large folios"), the contpte helper walked exactly
CONT_PTES entries from the aligned-down page table pointer and used @addr
only to pass down to each entry, so an unaligned value was harmless:

        ptep = contpte_align_down(ptep);
        addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
        for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)

Now the range to walk is derived from @addr instead: end = addr + nr *
PAGE_SIZE, rounded up to CONT_PTE_SIZE.  For a sample in the last page of
a contpte block, the sub-page offset puts end just past the block
boundary, so the round-up lands a whole block further and the walk clears
PTE_AF in CONT_PTES entries beyond the sampled block.  For the last block
in a page table page, those entries are past the end of that page, so the
walk writes into the page that follows.

Triggered by the full 7.1/7.2 kernel selftest suite on arm64 (EC2
c/m6g.4xlarge).  The kernel sometimes crashes at or shortly after the
DAMON test.

What the overrun does depends on the page that happens to follow the page
table, so there is no single signature.  If that page is read-only, the
write faults in the sampling path itself:

  Unable to handle kernel write to read-only memory at virtual address ffff0003c5d2d000
    FSC = 0x0f: level 3 permission fault
    CM = 0, WnR = 1, TnD = 0, TagAccess = 0
  CPU: 10 UID: 0 PID: 3487 Comm: kdamond.2
  pc : contpte_test_and_clear_young_ptes+0x70/0xc0
  lr : damon_ptep_mkold+0x1e8/0x1f8
  Call trace:
   contpte_test_and_clear_young_ptes+0x70/0xc0 (P)
   damon_mkold_pmd_entry+0x150/0x170
   walk_pmd_range+0x110/0x2b0
   walk_pud_range+0x10c/0x208
   walk_pgd_range+0x134/0x258
   __walk_page_range+0x98/0x1b0
   walk_page_range_vma_unsafe+0x90/0x148
   walk_page_range_vma+0x28/0x40
   damon_va_walk_page_range+0x114/0x2b8
   damon_va_prepare_access_checks+0xec/0x1a8
   kdamond_fn+0x534/0x770
   kthread+0x128/0x138
   ret_from_fork+0x10/0x20

Otherwise the page is writable, the PTE_AF clearing succeeds silently and
the damage only surfaces later, in whatever happened to own the page, so
the backtrace is unrelated to DAMON and differs between runs.

Pass a page-aligned address to the ptep_test_and_clear_young() call in
damon_ptep_mkold(), which is the only place DAMON can reach
contpte_test_and_clear_young_ptes() from.  Nothing else sees the aligned
address, and r->sampling_addr itself is left as is, so the sampling and
region bookkeeping semantics are unchanged.

Link: https://lore.kernel.org/20260904002829.116381-1-sj@kernel.org
Fixes: 6f0e1142173a ("arm64: mm: support batch clearing of the young flag for large folios")
Signed-off-by: Nathan Gao <zcgao@amazon.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
---

 mm/damon/ops-common.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-use-a-page-aligned-address-in-damon_ptep_mkold
+++ a/mm/damon/ops-common.c
@@ -61,7 +61,12 @@ void damon_ptep_mkold(pte_t *pte, struct
 	 * device aspects.
 	 */
 	if (likely(pte_present(pteval)))
-		young |= ptep_test_and_clear_young(vma, addr, pte);
+		/*
+		 * Arch implementation of ptep_test_and_clear_young() may
+		 * require aligned @addr
+		 */
+		young |= ptep_test_and_clear_young(vma, PAGE_ALIGN_DOWN(addr),
+				pte);
 	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
 	if (young)
 		folio_set_young(folio);
_

Patches currently in -mm which might be from zcgao@amazon.com are


