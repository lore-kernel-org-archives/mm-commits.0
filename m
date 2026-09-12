Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12715364049;
	Sat, 12 Sep 2026 08:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201301; cv=none; b=H1wdtxJ2P99LgP6vFA4Z8uOAKiL/HSAivQU8n8hvnhte41a3MY0yiww7GaB6UcK7GisW+hvWGuWHMcNdGvK9NCmmnNGHohfVL+mjD8iLZg8m65DGtyuv8dwXsGd4tMRhuZsKfvbSUanKP2ejtLlJmialQxu9s0iVhLKDdjEzwDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201301; c=relaxed/simple;
	bh=tNbDh33iPzBEdEFzpDKkRD3XDpZWRyTbtcOuu3Ki9XM=;
	h=Date:To:From:Subject:Message-Id; b=NkZD+UpR3QUclG16epYUPpG6oq6p4R59i8bIwjOIt2tnWbLL6sDZ1s+ptDok1F1fM2/QYdMegHHK+4+u95FjvWhfRaKj7ej4rtOTmlSWJXW4rpMiGMVeaaG/BA47DVPr7R+MHkGonoyI/Zgg+Q6Akoeo72L2kf8e9lm0HsffFb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oCgNs4lR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oCgNs4lR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C3E1F00893;
	Sat, 12 Sep 2026 08:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789201299;
	bh=xBWjB9Q8XezWEMznjwBTvQNS/xDETSDnhPKY9mNZzZk=;
	h=Date:To:From:Subject;
	b=oCgNs4lR6XHyl1DGdbCVYNJjpm8/M33pxXZunci9Nv53vOghAGcj3xicRiBsFDQa3
	 erWHZVlMoxHKE+mOqVZHTsnyo9jFD27u6E3VDdQ5+4s4ZXSsz/YGdVDHUPYrB4mjw2
	 ucqQQDP2ue800fcyDJ2PBwWiWswBGiBI8O43f/RM=
Date: Sat, 12 Sep 2026 01:21:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,rakie.kim@sk.com,peterx@redhat.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,jgg@ziepe.ca,jannh@google.com,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-use-vm_normal_folio_pmd-in-cold-pageout-pmd-range.patch added to mm-new branch
Message-Id: <20260912082139.D6C3E1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: use vm_normal_folio_pmd() in cold/pageout PMD range
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-use-vm_normal_folio_pmd-in-cold-pageout-pmd-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-use-vm_normal_folio_pmd-in-cold-pageout-pmd-range.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Assisted-by: LLM
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
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
mm-mempolicy-use-vm_normal_folio_pmd-in-queue_folios_pmd.patch
mm-madvise-use-vm_normal_folio_pmd-in-cold-pageout-pmd-range.patch
mm-refactor-find_next_best_node-to-find_next_best_node_in.patch
mm-page_alloc-refactor-build_node_zonelist-out-of-build_zonelists.patch

