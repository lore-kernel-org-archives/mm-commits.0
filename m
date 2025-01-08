Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A5D1A3A80
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 06:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736317607; cv=none; b=MU/VvBGdS8Xs5qzNIFAbgKpS454/qz11eJiMLcuZ9v4uEXeEM/0noPcSrKHgRApZwrTeGJkfdMi+LQsG+7+9iIuTdr2EmY0Ar0z8HqrFz/A2ftmfmF12aZFFxdd3PcCiM64awPz49Mz+zeCOsYYKGp8/EHSTrYsEJ/v0mqzDNlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736317607; c=relaxed/simple;
	bh=3IMh00H5bg8hflrARJqnwphRk3adpPUSftk5MA0UNy4=;
	h=Date:To:From:Subject:Message-Id; b=VkmQzesoCXCeux0UUeeIkeos4rfoDTqPJ30Dcxfl2IUCZSqgJZ4vjhUEEpfT+4nSCE8K6u54WQY0lyW5kEW2xYR6vKpCZkQN6jefEuq8qkNTL9Suo+K1GWhZD52mAhZfU4MlZznzPin6ZVWsB3nYBVsShLFwygLIp7mF42/3gyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dF0bOyl6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dF0bOyl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B903C4CEE0;
	Wed,  8 Jan 2025 06:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736317607;
	bh=3IMh00H5bg8hflrARJqnwphRk3adpPUSftk5MA0UNy4=;
	h=Date:To:From:Subject:From;
	b=dF0bOyl6hbD85P+204VIOhWAcrfEuUQMj3OCyIQr92du1mowT+Bxt5NBIMslMkzDI
	 Bp4wyqo8QOG6P0sAmOwaXkIedd/lYIKUw5+j7XLv62lRXgDNpziZDvMU3/QFmJNbsZ
	 hQmwa1SDiTVgHLafPVfZkYwr8M/0qjZ8ZRJAshWc=
Date: Tue, 07 Jan 2025 22:26:46 -0800
To: mm-commits@vger.kernel.org,jgg@nvidia.com,david@redhat.com,dan.j.williams@intel.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-redundant-check-for-pci-p2pdma-page.patch added to mm-unstable branch
Message-Id: <20250108062647.4B903C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: remove redundant check for PCI P2PDMA page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-remove-redundant-check-for-pci-p2pdma-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-remove-redundant-check-for-pci-p2pdma-page.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/gup: remove redundant check for PCI P2PDMA page
Date: Tue, 7 Jan 2025 14:42:25 +1100

PCI P2PDMA pages are not mapped with pXX_devmap PTEs therefore the check
in __gup_device_huge() is redundant.  Remove it

Link: https://lkml.kernel.org/r/ec7762407bfe4a1cd41faf89b35ed393b592a816.1736221254.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Dan Wiliams <dan.j.williams@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/gup.c~mm-gup-remove-redundant-check-for-pci-p2pdma-page
+++ a/mm/gup.c
@@ -3016,11 +3016,6 @@ static int gup_fast_devmap_leaf(unsigned
 			break;
 		}
 
-		if (!(flags & FOLL_PCI_P2PDMA) && is_pci_p2pdma_page(page)) {
-			gup_fast_undo_dev_pagemap(nr, nr_start, flags, pages);
-			break;
-		}
-
 		folio = try_grab_folio_fast(page, 1, flags);
 		if (!folio) {
 			gup_fast_undo_dev_pagemap(nr, nr_start, flags, pages);
_

Patches currently in -mm which might be from apopple@nvidia.com are

fuse-fix-dax-truncate-punch_hole-fault-path.patch
fs-dax-return-unmapped-busy-pages-from-dax_layout_busy_page_range.patch
fs-dax-dont-skip-locked-entries-when-scanning-entries.patch
fs-dax-refactor-wait-for-dax-idle-page.patch
fs-dax-create-a-common-implementation-to-break-dax-layouts.patch
fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts.patch
fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount.patch
fs-dax-remove-page_mapping_dax_shared-mapping-flag.patch
mm-gup-remove-redundant-check-for-pci-p2pdma-page.patch
mm-mm_init-move-p2pdma-page-refcount-initialisation-to-p2pdma.patch
mm-allow-compound-zone-device-pages.patch
mm-memory-enhance-insert_page_into_pte_locked-to-create-writable-mappings.patch
mm-memory-add-vmf_insert_page_mkwrite.patch
rmap-add-support-for-pud-sized-mappings-to-rmap.patch
huge_memory-add-vmf_insert_folio_pud.patch
huge_memory-add-vmf_insert_folio_pmd.patch
memremap-add-is_devdax_page-and-is_fsdax_page-helpers.patch
mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch
proc-task_mmu-mark-devdax-and-fsdax-pages-as-always-unpinned.patch
mm-mlock-skip-zone_device-pmds-during-mlock.patch
fs-dax-properly-refcount-fs-dax-pages.patch
device-dax-properly-refcount-device-dax-pages-when-mapping.patch
mm-remove-pxx_devmap-callers.patch
mm-remove-devmap-related-functions-and-page-table-bits.patch
revert-riscv-mm-add-support-for-zone_device.patch

