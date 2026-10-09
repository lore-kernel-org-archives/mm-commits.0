Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B8541A91C;
	Fri,  9 Oct 2026 05:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525562; cv=none; b=JjwKpXGbx6itL4VGbuHDbsbjEUzZYGpQqd15nQlqpm6CCsUTxlaTUEJoIW+r3mxvEBPl4hn9xRrkgKKBz8Sf970URPNfaPCsynureKnZWrooUWW74QIrk+j2RiEuBZXj3h4zfMCGduCCButfaDt0otOsAvHSQR+R/fODg+TGHX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525562; c=relaxed/simple;
	bh=2Q1Trajgp8yS7NnqrcE0k/mBCW5XnDP22sMxhCOW9QY=;
	h=Date:To:From:Subject:Message-Id; b=aB3e52zqEOyX5fgH6XMwlnkbgUlvsJ5Cvk76vn5FfBpa1/dwC0iG6OlI8nd4OmyMRKF//TBtI1BK0ufZpvgiXSD08dAiZpRMewxFPo1p9ESiR0rE89Ko+Xk5VNval5zDr/urek9OACnTDik9bt/S7W8RWAbyGrGo1n3O+ldtAoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0LjM6PDd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0LjM6PDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A2B1F0089A;
	Fri,  9 Oct 2026 05:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525561;
	bh=P+M3EwXC6EZpsWn62MmV5bM6JCrmUlzcdE7XGROA3iE=;
	h=Date:To:From:Subject;
	b=0LjM6PDdN1wzAZt2NhxFR8wpCSuV9I6bVwfOkxu+Dm1SMH9OdHKnxOXAqzgbhNl0y
	 L4u5oZnbwL9EEZlgAtakGaym17UwoTeCidYhJJLU6pgA6z3iQ3J7Lh5ra5PTNWaBSN
	 6NNr52fAi6XYmagOkdquuEvoCwTjss6Uux1R1GOU=
Date: Thu, 08 Oct 2026 22:59:20 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,rakie.kim@sk.com,peterx@redhat.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,jgg@ziepe.ca,jannh@google.com,david@kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-use-vm_normal_folio_pmd-in-cold-pageout-pmd-range.patch removed from -mm tree
Message-Id: <20261009055921.59A2B1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: use vm_normal_folio_pmd() in cold/pageout PMD range
has been removed from the -mm tree.  Its filename was
     mm-madvise-use-vm_normal_folio_pmd-in-cold-pageout-pmd-range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: mm/madvise: use vm_normal_folio_pmd() in cold/pageout PMD range
Date: Sat, 26 Sep 2026 06:51:10 -0400

mmap a VM_MIXEDMAP region whose ->huge_fault installs a PMD through
vmf_insert_pfn_pmd() - mshv_vtl_low does this, and needs CAP_SYS_ADMIN
to open - then:

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

Link: https://lore.kernel.org/20260926105110.2156652-3-gourry@gourry.net
Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when inject")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Assisted-by: LLM
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: <stable@vger.kernel.org> # v6.19+
---

 mm/madvise.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/madvise.c~mm-madvise-use-vm_normal_folio_pmd-in-cold-pageout-pmd-range
+++ a/mm/madvise.c
@@ -394,16 +394,15 @@ static int madvise_cold_or_pageout_pte_r
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

proc-task_mmu-handle-special-pmds-in-clear_refs-and-pagemap.patch
mm-madvise-reclaim-isolated-folios-if-pte-restart-fails.patch
mm-madvise-use-folio_trylock-in-the-cold-pageout-pmd-split.patch
mm-damon-use-damon_get_monitor_folio-for-hugetlb-entries.patch

