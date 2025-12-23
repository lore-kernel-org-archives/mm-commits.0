Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D0334B415
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 19:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517869; cv=none; b=t28cKiRIOmYOWxzU1tNlmIKWoihyupMo7BjRuq3pej2bLMhoMKy8zdHkN/WVehgpw4/GkeSfHlcd4OA3VmaXybhvzQxfH4/R4M2MAtPI2wMGh7HrxDoZ7StPTa4JBBe0RRLaMIHZHPR08I/6tgmQK1mBuB+c0au2Ma1I9YMh+PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517869; c=relaxed/simple;
	bh=YJzsBLgdKm03AnrOdwOF+GruJrTzzelnUoOuWF+C+Js=;
	h=Date:To:From:Subject:Message-Id; b=HIcDeuLg5ITVBZiylrZSBNmlxypTlgexQ53a+sjsysH5dBqIN/EbE7/5jk6A7vgTO7pXT0SUua43baeJ06XyB3LF8AqBlmVz9CP3Y45OvdUivBXslaeHCiBJkY6FLRfniarLJamqP4sAD4d6IAy5/hjYSSnHdonbpaR0ToSFT2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jJG0yXE4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jJG0yXE4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF02C113D0;
	Tue, 23 Dec 2025 19:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517869;
	bh=YJzsBLgdKm03AnrOdwOF+GruJrTzzelnUoOuWF+C+Js=;
	h=Date:To:From:Subject:From;
	b=jJG0yXE4CaX70D3y0JgMM4AlDYqiZOhipJmBFuUtp5GPDYxkW3EDUIjFFAnY1ME8P
	 dIZgj/eCS87JMp4Yqe1Gtby7V6ca5g+qfQ4lTz0hReqLk6CMMvxv52mGtNNcdCcsB/
	 mABSe3K8Lhuatodzdu2fgaSIKkn3lbgXEL7+1O2M=
Date: Tue, 23 Dec 2025 11:24:28 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,john@groves.net,gourry@gourry.net,djwong@kernel.org,david@kernel.org,dan.j.williams@intel.com,bsingharora@gmail.com,apopple@nvidia.com,alison.schofield@intel.com,John@Groves.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memremap-fix-spurious-large-folio-warning-for-fs-dax.patch removed from -mm tree
Message-Id: <20251223192428.EDF02C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memremap: fix spurious large folio warning for FS-DAX
has been removed from the -mm tree.  Its filename was
     mm-memremap-fix-spurious-large-folio-warning-for-fs-dax.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


