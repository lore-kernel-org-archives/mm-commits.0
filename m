Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CE5273FE
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 04:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741063940; cv=none; b=VH4RYg3XCqORPIc/IwE+ezFRHyA9l5ZDzPrURi0TW+JnibQ1mZl+74/IY4B7dtcfOS3O7/wgXQzriHyWrh/MoYboK05BiwbfHrpUZnPzQFfdZIx+CnbL68PTaFWdkg9z0WwK9jEopPl1MbBmMPsaf1T9M6WHzRzW9TNbkDSvV9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741063940; c=relaxed/simple;
	bh=PIT9EV0wueE7/ResawFASUBZMeAShUZ/j5PnN22tOsg=;
	h=Date:To:From:Subject:Message-Id; b=OWdIPkhRQHUEQE1M48WHETNlD4SC9KplR72r4brkClyoccWz8MI/eJIe2SO/FeQyWX+OkIBR50tW9PDyWObwV/1PFGG1DJWiRQ9xLAexSy0T+//8mH2X8UzwQOSizLiQj1Leey6BAwPwUZVdLinDLDJfmBq4OUuR84H9AB58Tsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Se0PEymj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Se0PEymj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EA3C4CEE5;
	Tue,  4 Mar 2025 04:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741063939;
	bh=PIT9EV0wueE7/ResawFASUBZMeAShUZ/j5PnN22tOsg=;
	h=Date:To:From:Subject:From;
	b=Se0PEymjC9M9L0/2d0tGxe0fpZZHlOJbOEix4+yJOLITR7AyuCv/vwKeNs1gN5R9y
	 m7sSprUmHwcdjjVbwDTknBZxrXoLos9Pqw0YsCPdkh8jvB/2hOMx9Aqd9u4wxtsxTr
	 cLpfJoEgGWrFa2m7yZLJGOf+0UcOyrogPVdR8kNA=
Date: Mon, 03 Mar 2025 20:52:19 -0800
To: mm-commits@vger.kernel.org,thomas.prescher@cyberus-technology.de,muchun.song@linux.dev,corbet@lwn.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix.patch added to mm-unstable branch
Message-Id: <20250304045219.A1EA3C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix
Date: Mon Mar  3 08:51:01 PM PST 2025

tidy up a comment

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Thomas Prescher <thomas.prescher@cyberus-technology.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix
+++ a/mm/hugetlb.c
@@ -4998,7 +4998,9 @@ void __init hugetlb_bootmem_alloc(void)
 	__hugetlb_bootmem_allocated = true;
 }
 
-/* hugepage_alloc_threads command line parsing
+/*
+ * hugepage_alloc_threads command line parsing.
+ *
  * When set, use this specific number of threads for the boot
  * allocation of hugepages.
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch
userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix.patch
mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry-fix.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params-fix.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
mm-mremap-thread-state-through-move-page-table-operation-fix.patch
mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch

