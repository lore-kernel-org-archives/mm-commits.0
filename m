Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCD624169D
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 22:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766269488; cv=none; b=ke+NFlqiGOryOiZYHF8ms2Z3IkvDS+xCIH/sH9CVJJ/E9hp54EtIq11ZlIaGOa6rZxibF1z9cHPD0QLbziPKfQFERD9SHvyLMxLgo8632SNKtzcCKjrLVRpDqzQieVMBP0tkicz+ahRU8SEaHxRA5bnuTB0KxnnHdu43EErXN7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766269488; c=relaxed/simple;
	bh=hgcNqieGWLWZ9IMFewJcT5gIeMkgdRnfwIZxV8qtv9k=;
	h=Date:To:From:Subject:Message-Id; b=CU+jbgsTWdhH2wNJWGCKc5uz5H8Gach/5Dj0v1n6dPTF726pDQJupV6RrG6ohAEUbUjVHMjr+xkPnvKictJU0whjEXNXYCxsStpHStzHJDee94Cydy4pXLyW2k2gZ30ohUiDjf69F6nmJDpCwvK6ePOFTjz6MTMo2L2E9SOKy24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YI/wz2aK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YI/wz2aK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E056CC4CEF5;
	Sat, 20 Dec 2025 22:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766269488;
	bh=hgcNqieGWLWZ9IMFewJcT5gIeMkgdRnfwIZxV8qtv9k=;
	h=Date:To:From:Subject:From;
	b=YI/wz2aKmy8LtrR4u0FGx9a71s/uQ4kVJWY3jrikTjbP8WNesMIOzY/Zp+6zu9rSS
	 FU1kxLt743mcPSMMfIBx63do3z/AkiA00KesVtFcKTYsuMyu5ILhHDUkI5Eq5VmyM9
	 i6v3u6Qrlg1NSNJs8UFzefxsGwa0P+tm5S1xXRNo=
Date: Sat, 20 Dec 2025 14:24:47 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,john@groves.net,gourry@gourry.net,djwong@kernel.org,david@kernel.org,dan.j.williams@intel.com,bsingharora@gmail.com,apopple@nvidia.com,alison.schofield@intel.com,John@Groves.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memremap-fix-spurious-large-folio-warning-for-fs-dax.patch added to mm-hotfixes-unstable branch
Message-Id: <20251220222447.E056CC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memremap: fix spurious large folio warning for FS-DAX
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memremap-fix-spurious-large-folio-warning-for-fs-dax.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memremap-fix-spurious-large-folio-warning-for-fs-dax.patch

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
From: John Groves <John@Groves.net>
Subject: mm/memremap: fix spurious large folio warning for FS-DAX
Date: Fri, 19 Dec 2025 06:37:17 -0600

This patch addresses a warning that I discovered while working on famfs,
which is an fs-dax file system that virtually always does PMD faults (next
famfs patch series coming after the holidays).

However, XFS also does PMD faults in fs-dax mode, and it also triggers the
warning.  It takes some effort to get XFS to do a PMD fault, but
instructions to reproduce it are below.

The VM_WARN_ON_ONCE(folio_test_large(folio)) check in
free_zone_device_folio() incorrectly triggers for MEMORY_DEVICE_FS_DAX
when PMD (2MB) mappings are used.

FS-DAX legitimately creates large file-backed folios when handling PMD
faults.  This is a core feature of FS-DAX that provides significant
performance benefits by mapping 2MB regions directly to persistent memory.
When these mappings are unmapped, the large folios are freed through
free_zone_device_folio(), which triggers the spurious warning.

The warning was introduced by commit that added support for large zone
device private folios.  However, that commit did not account for FS-DAX
file-backed folios, which have always supported large (PMD-sized)
mappings.

The check distinguishes between anonymous folios (which clear
AnonExclusive flags for each sub-page) and file-backed folios.  For
file-backed folios, it assumes large folios are unexpected - but this
assumption is incorrect for FS-DAX.

The fix is to exempt MEMORY_DEVICE_FS_DAX from the large folio warning,
allowing FS-DAX to continue using PMD mappings without triggering false
warnings.

Link: https://lkml.kernel.org/r/20251219123717.39330-1-john@groves.net
Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
Signed-off-by: John Groves <john@groves.net>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memremap.c~mm-memremap-fix-spurious-large-folio-warning-for-fs-dax
+++ a/mm/memremap.c
@@ -427,8 +427,6 @@ void free_zone_device_folio(struct folio
 	if (folio_test_anon(folio)) {
 		for (i = 0; i < nr; i++)
 			__ClearPageAnonExclusive(folio_page(folio, i));
-	} else {
-		VM_WARN_ON_ONCE(folio_test_large(folio));
 	}
 
 	/*
_

Patches currently in -mm which might be from John@Groves.net are

mm-memremap-fix-spurious-large-folio-warning-for-fs-dax.patch

