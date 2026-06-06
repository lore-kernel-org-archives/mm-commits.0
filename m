Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2CC3EA66
	for <mm-commits@vger.kernel.org>; Sat,  6 Jun 2026 00:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780704951; cv=none; b=kjt33Ctdqh5XmWbq8OHOsKUx0JfCz8O05NdVTPDenADF0B49K8emddoe0GxXEVzrc4GNk09Fmk4OOkVjRtp8NeVcjfUCqj7k2Md17WFEBIRWlcQ9THhM1p/NaMp3dC8Cavoh54YKi9hRsI2o/uuuFrnnaLJsoBIExN2ZkX8deUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780704951; c=relaxed/simple;
	bh=s6tEjtSeed1ylmFNly53OxCjSb0nUi5i3r0gOkKhpZg=;
	h=Date:To:From:Subject:Message-Id; b=aiZXmkTlWa6Z5InafkXz+xp867uLJRfgaRIQp8q1vEwAxQu2tI0h9UX7mRpp6/PGJriUaIgid6Uzzy816vUsBl9Er9UQzTQ3WC92JPkegn51Jz1Mco5DhmgWu8otNTf2zFr15+m1i89FoR1n0TRMInrbjDrymgR3Kj9OtZnJRLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vKbIr8cj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vKbIr8cj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1D21F00898;
	Sat,  6 Jun 2026 00:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780704949;
	bh=AU5hwxPY4srJ+4LROt1E8b4MMbOnCCYWyxc1qx1rKiU=;
	h=Date:To:From:Subject;
	b=vKbIr8cja4x5JIrfpCxPjjm7T2hpKAC9Xk6++mWzSXOWDDTnWxHY9GndAv0viZ8ec
	 jhwxYepDdD1JyoIFmJCgazbMx08lrWRDMlTOo1JKQ65fmBrG32HqsOFLJ7HlHwlkmT
	 mtBl7RerYwBm2n61iYhx7ey5f5ATDta9Ix9ooIOQ=
Date: Fri, 05 Jun 2026 17:15:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix-2.patch removed from -mm tree
Message-Id: <20260606001549.AA1D21F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix-2
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix-2.patch

This patch was dropped because it was folded into mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse.patch

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

mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
security-apparmor-apparmorfsc-conditionally-compile-get_loaddata_common_ref.patch
sparc-add-_mcount-prototype.patch

