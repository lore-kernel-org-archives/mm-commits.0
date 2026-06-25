Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D846A346E56;
	Thu, 25 Jun 2026 21:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782421653; cv=none; b=WoFxqllU0g1ueBvclsf5THYZE3+CJrfzBGKwXK50s4P9cT2EfKL8QQyYmkfaugfZ0X/EdzNqYWESkoAj1vZsf58BFehkte0sfho4FoRM5Ytn/CrjNj82A6JrjOlUVcz3f8i5M6WdGLfkQHMDw9D54TgSeheOBN54mF/zVHA0Cq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782421653; c=relaxed/simple;
	bh=23E2RV/azEBUUn+9JAiL2iJtTFGr1Va2g4zzImFMMNA=;
	h=Date:To:From:Subject:Message-Id; b=fwLXlrT8w+2DPx7rDK02RJkDDKh0qg2CwFfccuqxXo5oHJc0H3lc3pU5sjEAipfgnQ7T8s4pKbueTYTo6+jrmJmdYZbQCdaej392K77pwIMLLp/ZqEGsGBQLhvLOP3/8sIY+QsH/pSDfHzX9/4H5uQ8pW0+HHYWtP/QcIX7Xclo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zh083fRt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zh083fRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2AE1F000E9;
	Thu, 25 Jun 2026 21:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782421651;
	bh=kPq4IjDkfc3/38M+l+jszdFD8I2ZxNfI4z13QLPrDXc=;
	h=Date:To:From:Subject;
	b=zh083fRtiUTYcYIqKXDglCANsjYwQbXieQMxVT8Z7FvrQBv/nt3E1bLp/xJKYpBoJ
	 xlajJu1dtQ/DyL5YKAf6Egv18YtFKj70x2/3DiCmFZEARe9hZhLOJzfXXoz3CYPEtK
	 TgNAqT0nR/QwiYI940ezZAzftxI1FiuJV1YKKEBY=
Date: Thu, 25 Jun 2026 14:07:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,stable@vger.kernel.org,sj@kernel.org,riel@surriel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,harry@kernel.org,david@kernel.org,balbirs@nvidia.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_vma_mapped-fix-device-private-pmd-handling.patch added to mm-hotfixes-unstable branch
Message-Id: <20260625210731.5A2AE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_vma_mapped: fix device-private PMD handling
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_vma_mapped-fix-device-private-pmd-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_vma_mapped-fix-device-private-pmd-handling.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_vma_mapped: fix device-private PMD handling
Date: Wed, 24 Jun 2026 06:53:53 +0000

Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
device-private entries") introduced the concept of device-private PMD
entries, but did not correctly update the rmap walk code to account for
them.

As a result, when page_vma_mapped_walk() encounters device-private PMD
entries, it takes no action other than to acquire the PMD lock and exit.

However this is highly problematic for two reasons - firstly, device
private entries possess a PFN so check_pmd() needs to be called to ensure
an overlapping PFN range.

Secondly, and more importantly, if PVMW_MIGRATION is set the caller
assumes the returned entry is a migration entry, resulting in memory
corruption when the caller tries to interpret the device private entry as
such.

In addition, commit 146287290023 ("mm/huge_memory: implement
device-private THP splitting") allowed device private PMDs to be split
like THP mappings, but again did not update this code path.

As a result, we might race a PMD split prior to acquiring the PMD lock.

This patch addresses all of these issues by invoking check_pmd(), ensuring
PVMW_MIGRATION is not set and checks whether a split raced us we do for
PMD THP and migration entries.

Link: https://lore.kernel.org/20260624065353.1622-1-richard.weiyang@gmail.com
Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: David Hildenbrand <david@kernel.org>
Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped-fix-device-private-pmd-handling
+++ a/mm/page_vma_mapped.c
@@ -269,14 +269,24 @@ restart:
 			/* THP pmd was split under us: handle on pte level */
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
-		} else if (!pmd_present(pmde)) {
-			const softleaf_t entry = softleaf_from_pmd(pmde);
+		} else if (pmd_is_device_private_entry(pmde)) {
+			softleaf_t entry;
+
+			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
+			pmde = *pvmw->pmd;
+			entry = softleaf_from_pmd(pmde);
 
-			if (softleaf_is_device_private(entry)) {
-				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
+			if (likely(softleaf_is_device_private(entry))) {
+				if (pvmw->flags & PVMW_MIGRATION)
+					return not_found(pvmw);
+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
+					return not_found(pvmw);
 				return true;
 			}
-
+			/* device-private pmd was split under us: handle on pte level */
+			spin_unlock(pvmw->ptl);
+			pvmw->ptl = NULL;
+		} else if (!pmd_present(pmde)) {
 			if ((pvmw->flags & PVMW_SYNC) &&
 			    thp_vma_suitable_order(vma, pvmw->address,
 						   PMD_ORDER) &&
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page_vma_mapped-fix-device-private-pmd-handling.patch

