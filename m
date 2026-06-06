Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB944071D7
	for <mm-commits@vger.kernel.org>; Sat,  6 Jun 2026 00:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780704950; cv=none; b=T5pFky5RHbCbxDuY376feWxosRz0iJJI/wuZS0voX1TcSs9NwLqWkO80iHTrvNit0CnReRdAGj7L/sVl1/oolwwVbEdTwQF7YHLid1qw6Jmz+R1cyNsy+Ome/tbUHa2JqrSSpCecuw1ruixZGVfSrWfQyTDIwETlvv0H6aMVfuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780704950; c=relaxed/simple;
	bh=OSVi7ZEmVRRt7OIcLnIN1STZHAbZDNJlcL7+375TvmU=;
	h=Date:To:From:Subject:Message-Id; b=jZXrTDgHZ2WIy6dvHaGscpysZtGOcpDw95CU3bMUEFQZ7upXtCen0bSO8PD2Jq6QCyS1FFp2XcKi1xqbSOzDpH5tqKltD1HqM5vcgSVS50ACrrk3haaeN2hJ5wuZPFAoMo6W7Bk/YCu33VIv/qdHO42rdp661+eZ39Y5HsatU54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X41fFhax; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X41fFhax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6861E1F00893;
	Sat,  6 Jun 2026 00:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780704948;
	bh=P2FeeTR0IKPw1kN1Jusd+nQTTG1PVJVhgWTvaEPUiOU=;
	h=Date:To:From:Subject;
	b=X41fFhaxsZBuiPNoNfNdSXkVVwAPie6/bArw4yow0eVNZygd/Qh1pBrLzZLUk4dVl
	 UQaYiRTvyU83naJimidoKv5JY2LHb0EQwDGftTRc+P7wdOBPfknCG7qwQ4GTqbwJCz
	 Dyyd2JJ4K+yyg1wBwJfjpl+MGZk2mI21JYtE2hmc=
Date: Fri, 05 Jun 2026 17:15:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix.patch removed from -mm tree
Message-Id: <20260606001548.6861E1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: add a clarifying comment and change warn_on
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix.patch

This patch was dropped because it was folded into mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse.patch

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: add a clarifying comment and change warn_on
Date: Tue May 26 05:54:04 2026 -0600

Add a clarifying comment describing how the locking/mmu notifier is
handled and change the WARN_ON_ONCE to VM_WARN_ON_ONCE per davids
suggestion.

Link: https://lore.kernel.org/a48032dd-7881-43c0-b439-5cda6124ea58@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix
+++ a/mm/khugepaged.c
@@ -1291,6 +1291,13 @@ static enum scan_result collapse_huge_pa
 	anon_vma_lock_write(vma->anon_vma);
 	anon_vma_locked = true;
 
+	/*
+	 * Only notify about the PTE range we will actually modify. While we
+	 * temporary unmap the whole PTE table for mTHP collapse, we'll remap
+	 * it later, leaving other PTEs effectively unmodified. The locks we
+	 * hold prevent anybody from stumbling over such temporarily unmapped
+	 * PTE tables.
+	 */
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, start_addr,
 				end_addr);
 	mmu_notifier_invalidate_range_start(&range);
@@ -1356,7 +1363,7 @@ static enum scan_result collapse_huge_pa
 	 */
 	__folio_mark_uptodate(folio);
 	spin_lock(pmd_ptl);
-	WARN_ON_ONCE(!pmd_none(*pmd));
+	VM_WARN_ON_ONCE(!pmd_none(*pmd));
 	if (is_pmd_order(order)) {
 		pgtable = pmd_pgtable(_pmd);
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
_

Patches currently in -mm which might be from npache@redhat.com are

mm-khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch
mm-khugepaged-rework-max_ptes_-handling-with-helper-functions.patch
mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support.patch
mm-khugepaged-require-collapse_huge_page-to-enter-exit-with-the-lock-dropped.patch
mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse.patch
mm-khugepaged-skip-collapsing-mthp-to-smaller-orders.patch
mm-khugepaged-add-per-order-mthp-collapse-failure-statistics.patch
mm-khugepaged-improve-tracepoints-for-mthp-orders.patch
mm-khugepaged-introduce-collapse_allowable_orders-helper-function.patch
mm-khugepaged-introduce-mthp-collapse-support.patch
mm-khugepaged-introduce-mthp-collapse-support-fix.patch
mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse-fix.patch

