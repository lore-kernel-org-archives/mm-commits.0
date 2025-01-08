Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BB91A2872
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 06:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736317635; cv=none; b=tGWBzMfd4DXwQWb5yrUMFoNnuJi5yFXWfvRve8udvaeYK/dnHlachtut0unWixEhfY4MZ5zo8/lpQI331p7dvgvnVUrZajhbXNJbBFOPgNMQh6EAwsS5gIchN3DVcIbcqF9UA12gOS2SgC2SdncAxkhr2nj17oDoKODHTNPHtGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736317635; c=relaxed/simple;
	bh=bp+V1OSDy1BJXVspYdw3/qtApFIjL+insow2jAFV4hs=;
	h=Date:To:From:Subject:Message-Id; b=mjSsjTBqhTHG48Qxylc5tfdNg6GwWUpTKvuHTvccMxfQCHASNfOOs6IoCtjwoawtCrS42ir2SzCxE2mwDbwpJYSLeZ1tkXFujL7Qgqr6ubF1hoaTHUasjcrkd/DEFPTPR+amynY95MOiYwW6av6tGzlqK22QJNYX4hFJ7fCek7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q/allqC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q/allqC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB58C4CED0;
	Wed,  8 Jan 2025 06:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736317633;
	bh=bp+V1OSDy1BJXVspYdw3/qtApFIjL+insow2jAFV4hs=;
	h=Date:To:From:Subject:From;
	b=Q/allqC8n8PeWKpBI5Yvr6ubBQCzFkLZcZESsBWFrmAmTBBqFR2V135r5b2ajfAbf
	 Iu5XumnGyKAaUNHjUje7oGGJ4Yn5tJqEYSoe8QeEwttf8LP3yMEzDljQko0F42tgrl
	 VBAGv7Jz1bzNPX1h0TxGU3V/Hdq0tYi1OzMqrxhk=
Date: Tue, 07 Jan 2025 22:27:12 -0800
To: mm-commits@vger.kernel.org,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-task_mmu-mark-devdax-and-fsdax-pages-as-always-unpinned.patch added to mm-unstable branch
Message-Id: <20250108062713.5AB58C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc/task_mmu: mark devdax and fsdax pages as always unpinned
has been added to the -mm mm-unstable branch.  Its filename is
     proc-task_mmu-mark-devdax-and-fsdax-pages-as-always-unpinned.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-task_mmu-mark-devdax-and-fsdax-pages-as-always-unpinned.patch

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
Subject: proc/task_mmu: mark devdax and fsdax pages as always unpinned
Date: Tue, 7 Jan 2025 14:42:35 +1100

The procfs mmu files such as smaps and pagemap currently ignore devdax and
fsdax pages because these pages are considered special.  A future change
will start treating these as normal pages, meaning they can be exposed via
smaps and pagemap.

The only difference is that devdax and fsdax pages can never be pinned for
DMA via FOLL_LONGTERM, so add an explicit check in pte_is_pinned() to
reflect that.

Link: https://lkml.kernel.org/r/e17a04cf8feaa838e62d0c7d1de97444222b7956.1736221254.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~proc-task_mmu-mark-devdax-and-fsdax-pages-as-always-unpinned
+++ a/fs/proc/task_mmu.c
@@ -1378,7 +1378,7 @@ static inline bool pte_is_pinned(struct
 	if (likely(!test_bit(MMF_HAS_PINNED, &vma->vm_mm->flags)))
 		return false;
 	folio = vm_normal_folio(vma, addr, pte);
-	if (!folio)
+	if (!folio || folio_is_devdax(folio) || folio_is_fsdax(folio))
 		return false;
 	return folio_maybe_dma_pinned(folio);
 }
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

