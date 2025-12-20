Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2341F17E8
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 22:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766271029; cv=none; b=BdLrXwDN0gbCziA35iQfABRutc6vRu+xjpICDN00CesDIfaWFPAi2CS7OUdSy+y9Pc4MU+SN2CBwk5zGhw+1R8u9IC1YtewxGj9Y3aothJJzyHbY8AxG2e1ycebtKRB/2rSFTpxaKbyjsJZ7GTYUZ2B9Io2ACng77Yo6dkB0ETc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766271029; c=relaxed/simple;
	bh=EGqbhctAoAD63gZIunvVfyoaX7tCVhofw7HENZTsfEk=;
	h=Date:To:From:Subject:Message-Id; b=DsiHEp7a2D45flLKldmzu7K4DS8XHsyhwMJZzmcS49PK2FeFsrdCNgQNmuDiw/DvjPi2UTpFZrAZYFBKPPbH1wwBtll4Lrp69rck5To/foU74cOSc/eNEHpr9na22Zd/heTsVWljk42xY/jY5P12udAnmu/hWxonCuXgyWfuK7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CP4sjTKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CP4sjTKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6A9C4CEF5;
	Sat, 20 Dec 2025 22:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766271028;
	bh=EGqbhctAoAD63gZIunvVfyoaX7tCVhofw7HENZTsfEk=;
	h=Date:To:From:Subject:From;
	b=CP4sjTKjrJhZiMBIKMw5TsDP0/MAHARLDHD0RGFzru4jmdfCIY1Pc+UUlIzZ6Z+vt
	 Zz7iE3bKYGRAgeNg1VEdgRb0pjn00BRiHPmHQx0PS091/1vNjf0Li1ccIx119Z5nnm
	 XKbrvFAbz3PCIaWcyrncK8tRXANFBixtroGECsOY=
Date: Sat, 20 Dec 2025 14:50:27 -0800
To: mm-commits@vger.kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,apopple@nvidia.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-no-longer-used-gup_fast_undo_dev_pagemap.patch added to mm-new branch
Message-Id: <20251220225028.5D6A9C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: remove no longer used gup_fast_undo_dev_pagemap
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-remove-no-longer-used-gup_fast_undo_dev_pagemap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-remove-no-longer-used-gup_fast_undo_dev_pagemap.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/gup: remove no longer used gup_fast_undo_dev_pagemap
Date: Fri, 19 Dec 2025 19:46:00 +0800

This helper is no longer used after commit fd2825b0760a ("mm/gup: remove
pXX_devmap usage from get_user_pages()").

Link: https://lkml.kernel.org/r/20251219-gup-cleanup-v1-1-348a70d9eecb@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/mm/gup.c~mm-gup-remove-no-longer-used-gup_fast_undo_dev_pagemap
+++ a/mm/gup.c
@@ -2806,17 +2806,6 @@ static bool gup_fast_folio_allowed(struc
 	return !reject_file_backed || shmem_mapping(mapping);
 }
 
-static void __maybe_unused gup_fast_undo_dev_pagemap(int *nr, int nr_start,
-		unsigned int flags, struct page **pages)
-{
-	while ((*nr) - nr_start) {
-		struct folio *folio = page_folio(pages[--(*nr)]);
-
-		folio_clear_referenced(folio);
-		gup_put_folio(folio, 1, flags);
-	}
-}
-
 #ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
 /*
  * GUP-fast relies on pte change detection to avoid concurrent pgtable
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-rename-__read_swap_cache_async-to-swap_cache_alloc_folio.patch
mm-swap-split-swap-cache-preparation-loop-into-a-standalone-helper.patch
mm-swap-never-bypass-the-swap-cache-even-for-swp_synchronous_io.patch
mm-swap-always-try-to-free-swap-cache-for-swp_synchronous_io-devices.patch
mm-swap-simplify-the-code-and-reduce-indention.patch
mm-swap-free-the-swap-cache-after-folio-is-mapped.patch
mm-shmem-never-bypass-the-swap-cache-for-swp_synchronous_io.patch
mm-swap-swap-entry-of-a-bad-slot-should-not-be-considered-as-swapped-out.patch
mm-swap-consolidate-cluster-reclaim-and-usability-check.patch
mm-swap-split-locked-entry-duplicating-into-a-standalone-helper.patch
mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer.patch
mm-swap-remove-workaround-for-unsynchronized-swap-map-cache-state.patch
mm-swap-cleanup-swap-entry-management-workflow.patch
mm-swap-add-folio-to-swap-cache-directly-on-allocation.patch
mm-swap-check-swap-table-directly-for-checking-cache.patch
mm-swap-clean-up-and-improve-swap-entries-freeing.patch
mm-swap-drop-the-swap_has_cache-flag.patch
mm-swap-remove-no-longer-needed-_swap_info_get.patch
mm-gup-remove-no-longer-used-gup_fast_undo_dev_pagemap.patch

