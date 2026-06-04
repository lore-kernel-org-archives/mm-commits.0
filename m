Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336B739EB59
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 17:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780594863; cv=none; b=k64UKjtRoF/PnVFxzx/FjFMZ3Kt0P8A8qFXOMy0xnOuwlX6rpUZyiAE53MUoNQ4zEbJc3P8SvhBTALJyz4h2ipxh//wagzFa4SNbyN1Gmcx2LWMTxEyWj2FNN9w26P9/Nh3Faa+IQjZh8dTDQRoLQWkdy4rLBay2i3bKqaEFuoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780594863; c=relaxed/simple;
	bh=06dm3ukjQHDUxbsaQiqeMgsjvxdUkx08QS4mJYg3aDE=;
	h=Date:To:From:Subject:Message-Id; b=TXRExCUpXY1BR/SZiL0Ft/KkumknPW2wBmXC9SeKTREcp0/Wnw78hpAwyARIWp31yK5p8hO/PsYYvGJBjdt4j6GrJphK7qRnT5zVSpQ3mdHJC54Ms1H3pw8SPGKeWvDDxWLbp4CIgkBDUyQUwcS+tpE3FCn6BaqlcobP+kzn1rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vairx2y2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vairx2y2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABFB11F00893;
	Thu,  4 Jun 2026 17:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780594861;
	bh=KBV/E65A1a95/wMT0178t+PVf4J8BHrvVl7uEbzgfkY=;
	h=Date:To:From:Subject;
	b=vairx2y2zScnQuPDFrYLDXTvIt/VwsDfzxjabtJ+zAgkpJ3aAW5hfYUDXTPzOnluY
	 fD5cZ4J/n/JgrJblowjFf/AXfrLviyyKPDMVuHdNcwvQnKUq9qA+XJKGFIeVC3I9V5
	 MhwQ0Obrz4HDLHoq8WnvvD8IQKvq8Ifd9luH47Bw=
Date: Thu, 04 Jun 2026 10:41:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix-2.patch added to mm-unstable branch
Message-Id: <20260604174101.ABFB11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix-2.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix-2
Date: Thu Jun  4 10:35:27 AM PDT 2026

(re)-fix clang warning in collapse_scan_pmd()

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix-2
+++ a/mm/khugepaged.c
@@ -1224,7 +1224,7 @@ static enum scan_result collapse_huge_pa
 	const unsigned long end_addr = start_addr + (PAGE_SIZE << order);
 	LIST_HEAD(compound_pagelist);
 	pmd_t *pmd, _pmd;
-	pte_t *pte;
+	pte_t *pte = NULL;
 	pgtable_t pgtable;
 	struct folio *folio;
 	spinlock_t *pmd_ptl, *pte_ptl;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-switch-deferred-split-shrinker-to-list_lru-fix.patch
mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix-2.patch
sparc-add-_mcount-prototype.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
security-apparmor-apparmorfsc-conditionally-compile-get_loaddata_common_ref.patch

