Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359A548AE04
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 18:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781031396; cv=none; b=ZVIp4Yi4JWhW7TBr1D7wSFBjowYk8hF4n9bQr80mgclvzpXBpqKWiMWCJceiWm4yHHIRAwb/5f6WqEqU9iaYL+SJiL8rrPLt0e2SyniuY2A8IHytt6UrqN9UPt/lSwD/mKuSrJGOIfxEAEt+w6zq7Ri0xV3YlPni5gD43x/ZEGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781031396; c=relaxed/simple;
	bh=zyUwUkPSwaR33E0ASidIwTDFWsXSM0I6rNun/N/hPTY=;
	h=Date:To:From:Subject:Message-Id; b=aE0CfnCImNUNrrLcZxMZmhmY07fpyTyqCvIX+iRz5SZoBkq1G9UxAnM7MhZjHx+rMDnxQCEcpHybu7PE1nIAbJrBPb8+jNNXiKBtbyEgmRyRe478nLvYP6mQdeNxFKFZptlD6c4/GLKIIbNNWHGhBuEe52CkNr1UItQWDvVATzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CFIdrwip; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CFIdrwip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B1A1F00893;
	Tue,  9 Jun 2026 18:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781031395;
	bh=5WGBAdlSNNdpIE3j8XWB4luJ/SMZyzS8j0N8dmF3ooA=;
	h=Date:To:From:Subject;
	b=CFIdrwipxx4Fl+dGNjs+SF2OTYpKDJ+gV1d7iN0HKapCw5QBJo76zBKboNjUneCjg
	 0IKgEnCh3ZOGN8am4JWsbBjGJ6JENdI8GFMdmhnHW3DeUKYQMYz5UuHPUnXLuEQBCS
	 IxrpS5gxzZN5Jm1MZzmgncP60ggcx8WuqQh2x4wc=
Date: Tue, 09 Jun 2026 11:56:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-pmd-collapse-swap-pte-accounting.patch added to mm-unstable branch
Message-Id: <20260609185634.E3B1A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: fix PMD collapse swap PTE accounting
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-fix-pmd-collapse-swap-pte-accounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-pmd-collapse-swap-pte-accounting.patch

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
From: Lance Yang <lance.yang@linux.dev>
Subject: mm/khugepaged: fix PMD collapse swap PTE accounting
Date: Tue, 9 Jun 2026 20:04:43 +0800

mthp_collapse() uses mthp_present_ptes to decide whether a range has
enough occupied PTEs to try collapse.  Swap PTEs accepted by
collapse_scan_pmd() are counted in unmapped, but are not represented in
mthp_present_ptes.

When lower orders are enabled, collapse_scan_pmd() relaxes max_ptes_none
so the scan can cover the whole PMD and build the bitmap.  mthp_collapse()
then checks the PMD-order candidate using the bitmap.

With max_ptes_none set to 0, a range with 511 present PTEs and one swap
PTE no longer reaches collapse_huge_page(), even though PMD collapse can
handle swap PTEs up to max_ptes_swap.

Account unmapped PTEs only for PMD order.  PMD collapse supports swap PTEs
through max_ptes_swap, while lower-order mTHP collapse does not currently
support non-present PTEs.  Keep non-present PTEs out of the lower-order
eligibility check.

Link: https://lore.kernel.org/20260609120443.71864-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Nico Pache <npache@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-fix-pmd-collapse-swap-pte-accounting
+++ a/mm/khugepaged.c
@@ -1502,6 +1502,14 @@ static enum scan_result mthp_collapse(st
 		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
 						      offset + nr_ptes);
 
+		/*
+		 * Swap PTEs accepted during the scan are counted in @unmapped,
+		 * not in the present-PTE bitmap. Account them for the PMD-order
+		 * candidate.
+		 */
+		if (is_pmd_order(order))
+			nr_occupied_ptes += unmapped;
+
 		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
 			enum scan_result ret;
 
_

Patches currently in -mm which might be from lance.yang@linux.dev are

mm-khugepaged-fix-pmd-collapse-swap-pte-accounting.patch

