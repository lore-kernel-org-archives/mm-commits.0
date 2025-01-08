Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B05F1A2872
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 06:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736317633; cv=none; b=kCo0CCbSwl9lbzhFtDS40eMQoLAxt6ys38qdxeFTDybamRV3y1keIBdY5xkDPhzN5mQt/7l7CJu3F2BAlNAPPiB81wYto3ZO4JHMsbNTN518zbbAa8EctJwTVgFhjyTCxqedYGQPBQ8WTk0zf9kh9GogSK78C83nbvIE/E+gbkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736317633; c=relaxed/simple;
	bh=h+af5thfB9CjT16HHH3Y9b+tM6qF6TSNtuAZoiZHKlY=;
	h=Date:To:From:Subject:Message-Id; b=Efb/hcsfcofDp945HsILnxEyl9DD+zWDSv+N+SXLV4MsRJEDGcXbvfgk2yB/3IFxKe2Mx0rGC5okr3L05GXSigNcp2BrsCQsbER5M0nDeIXP3eu6BnwfGPZ2072+AZFJ9RYJ7HiYLjkIeBw7hnfQrICpaxeHvYgC878H2rqHCyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=isjLR1i1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="isjLR1i1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867E2C4CED0;
	Wed,  8 Jan 2025 06:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736317631;
	bh=h+af5thfB9CjT16HHH3Y9b+tM6qF6TSNtuAZoiZHKlY=;
	h=Date:To:From:Subject:From;
	b=isjLR1i1ZMq3JauPd0Eutot4z8mw+C5B+lZc0oFZXU9QfSOvuf4G8EjChqMR0/t55
	 EXN14NxK9EGGEL59Q+onawnt1HGL+wjSdU1ZFobAPyAU7DTqK3bp2byzaJxvP4n3D6
	 rgWNKZ5MgU2RwmqCtN7icM0Pem0/G7vfEw4RZ5XI=
Date: Tue, 07 Jan 2025 22:27:11 -0800
To: mm-commits@vger.kernel.org,jhubbard@nvidia.com,david@redhat.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch added to mm-unstable branch
Message-Id: <20250108062711.867E2C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: don't allow FOLL_LONGTERM pinning of FS DAX pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch

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
Subject: mm/gup: don't allow FOLL_LONGTERM pinning of FS DAX pages
Date: Tue, 7 Jan 2025 14:42:34 +1100

Longterm pinning of FS DAX pages should already be disallowed by various
pXX_devmap checks.  However a future change will cause these checks to be
invalid for FS DAX pages so make folio_is_longterm_pinnable() return false
for FS DAX pages.

Link: https://lkml.kernel.org/r/8bd0a8c0f62e2d2d8ece6f445580d20b73e3decd.1736221254.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/mm.h~mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages
+++ a/include/linux/mm.h
@@ -2099,6 +2099,10 @@ static inline bool folio_is_longterm_pin
 	if (folio_is_device_coherent(folio))
 		return false;
 
+	/* DAX must also always allow eviction. */
+	if (folio_is_fsdax(folio))
+		return false;
+
 	/* Otherwise, non-movable zone folios can be pinned. */
 	return !folio_is_zone_movable(folio);
 
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

