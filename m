Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C0B1A3031
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 06:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736317635; cv=none; b=ank79qFLq//EgvM9z9l0SJthVba8n9jbWx60R5205UMaM68KqgQHfksiPQg5WxRSuZ6+8kw2BVDtuqm2xY/mK9md0vhcPFO++V3BViTontlLjeamQsdyVncKbIvHQgWSUBHNXIVmHwv943yvvOSjx4N9wZhG06zBAC0QY2gt7vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736317635; c=relaxed/simple;
	bh=YLq7JrXkar4fkwSmg+3dXHQ+gK1hqZRcXUh/YAqdPTg=;
	h=Date:To:From:Subject:Message-Id; b=RPjpwx+XOAi3rP/ATvq1eXzWcELigpswYapFL8Z1jGQfwcOQWgOtnfmnQ76oj2D6abOAibzmy1xbtoSAIl6s+4wBjp2fVBiUcaYAvZE9wjwvjk7a/rxCJxzvsfs5Fs0HME2aidi7utazavpvKZukz5Fo0nD708Gv7er8+Zgv/ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zc3Sbmo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zc3Sbmo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4303FC4CEE0;
	Wed,  8 Jan 2025 06:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736317635;
	bh=YLq7JrXkar4fkwSmg+3dXHQ+gK1hqZRcXUh/YAqdPTg=;
	h=Date:To:From:Subject:From;
	b=Zc3Sbmo067HG+fD5kNVmsN0ifYyl5lfYynCruNc15GTwpyK4I48oqyz8L6L27rh5J
	 glw0nlm8tuxTWjhvopTbBmVaHgYZdvK2+EaHezXoaT5OQL1KcLJF/Z/UYpWTt3QPux
	 viEVLa/C6QnW/gP2b5kiH3ikgE90TldBWoEqUVIY=
Date: Tue, 07 Jan 2025 22:27:14 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mlock-skip-zone_device-pmds-during-mlock.patch added to mm-unstable branch
Message-Id: <20250108062715.4303FC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mlock: skip ZONE_DEVICE PMDs during mlock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mlock-skip-zone_device-pmds-during-mlock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mlock-skip-zone_device-pmds-during-mlock.patch

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
Subject: mm/mlock: skip ZONE_DEVICE PMDs during mlock
Date: Tue, 7 Jan 2025 14:42:36 +1100

At present mlock skips ptes mapping ZONE_DEVICE pages.  A future change to
remove pmd_devmap will allow pmd_trans_huge_lock() to return ZONE_DEVICE
folios so make sure we continue to skip those.

Link: https://lkml.kernel.org/r/735ecdeef28a03b0e9114b2435e0ef7af7a73c66.1736221254.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/mlock.c~mm-mlock-skip-zone_device-pmds-during-mlock
+++ a/mm/mlock.c
@@ -368,6 +368,8 @@ static int mlock_pte_range(pmd_t *pmd, u
 		if (is_huge_zero_pmd(*pmd))
 			goto out;
 		folio = pmd_folio(*pmd);
+		if (folio_is_zone_device(folio))
+			goto out;
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_folio(folio);
 		else
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

