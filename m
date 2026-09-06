Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44223515D0;
	Sun,  6 Sep 2026 02:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788661269; cv=none; b=qpP3hqfBZ3V6VpId4LhMfryCm2JYvalyQFMgPlAYCJ4H7Kitef13NoLyj4NhgUMVgFd9E+SRj2HcJgSXs10O40rPgicPNFR0tJ1ohJG/7NEU+HdZ8vWZ/p1Gx1CAvaG7XdAvnD2jQp3pt1d314AcP/5XMMC6b9MR5WQZpmAP9Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788661269; c=relaxed/simple;
	bh=VwC/moHV3gO6v1K0dYD8s5ePunbjQ2UbAuY6/SxRDGM=;
	h=Date:To:From:Subject:Message-Id; b=HtUiuXgdNB1MtPmMbtfGzwseZJ6AVJLbNBJDiZhWpBR7mTOOoeO4DklnsUROw98gqom+LxQPlbwzMwHC8tEItaUpgo9+acaQnfmKwMLnB98BoV80VRQnGmkSeJ9RnEygdHq8q+mS0W3ohEJ2e9G3hXLE9qJ4rab2TKtUJG1rayc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wMai3k2n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wMai3k2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7981F00A3A;
	Sun,  6 Sep 2026 02:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788661267;
	bh=6AjcLBECKuqmISJ7Inwb1of+H4FR5as5IUxEHdYAj7Q=;
	h=Date:To:From:Subject;
	b=wMai3k2nteVKXdZVbWTzNk7C3dX1Nyn3QJ0vzhAAwKMloh8Zw20tuuw5IiGmKkIK8
	 7ZitJMp95Po/qEsXkT2rRStqyhjjZWfKFuqHbJcfTXd19zPTcZQZiJHhO7rHP6byOj
	 YTC33OuuF23aDE7SKe6PJnQ01vwxsC+Z18Nf4xj0=
Date: Sat, 05 Sep 2026 19:21:06 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,ryan.roberts@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,zcgao@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-ops-common-use-a-page-aligned-address-in-damon_ptep_mkold.patch added to mm-hotfixes-unstable branch
Message-Id: <20260906022107.3C7981F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/ops-common: use a page-aligned address in damon_ptep_mkold()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-ops-common-use-a-page-aligned-address-in-damon_ptep_mkold.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-ops-common-use-a-page-aligned-address-in-damon_ptep_mkold.patch

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
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-damon-ops-common-use-a-page-aligned-address-in-damon_ptep_mkold.patch

