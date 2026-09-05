Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C032C0298
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 18:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788633353; cv=none; b=PfZjyEvDY9Tp92rcHZTAFw3GnVqgIi6k9UWsw8tJZCjxNypCr+F5lOpoQrElSr0dr+kL1QS2pwWaG0Kf+alBasqUug14Y8GZfoI66+T4CrfYiUX0PN2ZCVJ9XoT9dvCp1mBpD39hRkRSEW+nZveVjdtVusJurMVxP93bZN47FMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788633353; c=relaxed/simple;
	bh=d7UbDf9U3cSWDcKlhJkPSn3c8O5ESKk+gPjDHn7nmUY=;
	h=Date:To:From:Subject:Message-Id; b=O3e/PtYGWs95AiaqVg0iTHNjOyb2HB+2OeMXwh8JI5U/ZL3d1FtF04ZLTwKey2Yxzu/FW7tqzVmNsmDAwvg9OD4snrz/IuCGmEfiCfhcwU20g86qguXL+pDKoB8eHZb70NsnyrQu8lhkOqbKFZNrQFUmxU86evwBu8Bbq/LEldo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o4Lg9VnE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o4Lg9VnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301BC1F00A3A;
	Sat,  5 Sep 2026 18:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788633351;
	bh=sU1RjXNVeN1vqwnBb1NzUZru9j2aFW/a1fDMDuH9oPQ=;
	h=Date:To:From:Subject;
	b=o4Lg9VnEK12S6LeedFvH2jVsFIFZU/Wh08XLfEoYLPAjz825U5TBNRmFJBbN2ER6L
	 uliuOfTiF4glIFXxZ1/kEYfqhZxQMh6iSjda49iP55N/AH7yUNm0OuiQroEOB9IPsA
	 8gR/vjN6AV1GHDskp3M9PIAydkXRemS6pA2vHme8=
Date: Sat, 05 Sep 2026 11:35:50 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,saravanand@crusoe.ai,ryan.roberts@arm.com,peterx@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jgg@ziepe.ca,dev.jain@arm.com,david@kernel.org,clg@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix-2.patch removed from -mm tree
Message-Id: <20260905183551.301BC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: renames for Lorenzo's mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings patch
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix-2.patch

This patch was dropped because it was folded into mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings.patch

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: renames for Lorenzo's mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings patch
Date: Sat, 29 Aug 2026 10:02:02 -0400

rename some functions

Link: https://lore.kernel.org/DL1HIHWYJ7TB.1CY76SJS0V03L@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Cedric Le Goater <clg@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Saravanan D <saravanand@crusoe.ai>
Cc: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix-2
+++ a/mm/huge_memory.c
@@ -118,7 +118,7 @@ static bool vma_is_special_huge(const st
 	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }
 
-static bool vma_bypass_thp_tuneables_file(const struct vm_area_struct *vma,
+static bool vma_file_bypass_thp_tuneables(const struct vm_area_struct *vma,
 		enum tva_type type)
 {
 	const bool has_huge_fault = vma->vm_ops->huge_fault;
@@ -132,7 +132,7 @@ static bool vma_bypass_thp_tuneables_fil
 	return false;
 }
 
-static bool vma_thp_tuneables_allow_file(vm_flags_t vm_flags)
+static bool vma_file_allow_thp_tuneables(vm_flags_t vm_flags)
 {
 	/* THP=always? */
 	if (hugepage_global_always())
@@ -143,11 +143,11 @@ static bool vma_thp_tuneables_allow_file
 	return false;
 }
 
-static bool vma_check_thp_tuneables_file(const struct vm_area_struct *vma,
+static bool vma_file_check_thp_tuneables(const struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type type)
 {
-	return vma_bypass_thp_tuneables_file(vma, type) ||
-		vma_thp_tuneables_allow_file(vm_flags);
+	return vma_file_bypass_thp_tuneables(vma, type) ||
+		vma_file_allow_thp_tuneables(vm_flags);
 }
 
 static bool vma_can_map_huge_file(const struct vm_area_struct *vma,
@@ -159,7 +159,7 @@ static bool vma_can_map_huge_file(const
 	 * Enforce THP collapse requirements as necessary. Anonymous vmas
 	 * were already handled in thp_vma_allowable_orders().
 	 */
-	if (!vma_check_thp_tuneables_file(vma, vm_flags, type))
+	if (!vma_file_check_thp_tuneables(vma, vm_flags, type))
 		return false;
 
 	switch (type) {
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

