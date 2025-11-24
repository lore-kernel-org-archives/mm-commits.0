Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1027341046
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 22:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764023543; cv=none; b=ngbdOIdM4FFDzTh/coyioePbtmMiBNm665eJNMejN/Ac5WhxtAmJp6PU+Y56N+L5bY9xRJAnFMKmJ5G+uzWJEGR9ZolNTlV5+mZsrB4WYNny4VxQsdSa/8RvxyrjsL0Z92JFCOsGQyEE4EKG7gaotV9IaLidam6cnuLiNT0H+cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764023543; c=relaxed/simple;
	bh=3+//UCjUpI8rHJ7yuyq3fev15aqxR2GTKltpkmpKDKo=;
	h=Date:To:From:Subject:Message-Id; b=MQN9xCMPFW47ZfpL4qOLivA9k439gPOStpeHP2DaWjiHFIuO8v0Un72GQ6JsYw/++S0IDdreAKY0ImgAEVNqc+c0C7qLmDJGO37b8SB3ZlkeVsj9OoS7adilHr6d1zzXf8ooDbqNm+MDnCVPV0dIwKUNyJht4kW0BYWC7mkZpFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JLG6pzFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JLG6pzFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE44C4CEF1;
	Mon, 24 Nov 2025 22:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764023542;
	bh=3+//UCjUpI8rHJ7yuyq3fev15aqxR2GTKltpkmpKDKo=;
	h=Date:To:From:Subject:From;
	b=JLG6pzFHfmnBmAKokJH1XT7q1E97HEXSArTB42FYSyGt+GRXL69r61K9CfPHToL8f
	 R178pAvtNkS98r6BEt8eCtlVl78Q8B7q28ddsygg4UWnm06Qsacpa13B3E9rNljK9p
	 wCEyOWyW9AMiyntXXA70v3ocJ0rh88YH77cjeeTw=
Date: Mon, 24 Nov 2025 14:32:21 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,usamaarif642@gmail.com,richard.weiyang@gmail.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch removed from -mm tree
Message-Id: <20251124223222.7BE44C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch

This patch was dropped because it was folded into mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix
Date: Wed Oct  8 09:10:01 PM PDT 2025

remove unneeded map_anon_folio_pmd_nopf() stub, per Wei & David

Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/huge_mm.h~mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix
+++ a/include/linux/huge_mm.h
@@ -631,11 +631,6 @@ static inline bool unmap_huge_pmd_locked
 	return false;
 }
 
-static inline void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
-		struct vm_area_struct *vma, unsigned long haddr)
-{
-}
-
 #define split_huge_pud(__vma, __pmd, __address)	\
 	do { } while (0)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-correctly-handle-uffd-pte-markers-fix.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch

