Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B80940F730
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 23:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789686972; cv=none; b=ORBhw8ehkXHhHqiY+XvIzGszJFVGYDU6FIYomraX47LA/WB5txBGfJTdBMTLoVf/EvHfXG7HRkXMmTnBp2L6/9qPD13PQ+DRAr2g3iNHgh5+RzC3vH2L2UWCSV1WQYl4dNdXwjWZyU7mbzIFvgfe0WSVQMWS2iGQqvf1DYlXRX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789686972; c=relaxed/simple;
	bh=I7xK4gJnr0ck9wR3KHKlIX3i8zIV5aEgOYztahDGAp0=;
	h=Date:To:From:Subject:Message-Id; b=tDkC4MDDg35te+qxd8/bOwyJSFQujKV9sUH5C2e7ZWD0+BEZ2aOXx/LE55nG2OiJ+ApBO7RjQI3q4bc56ciih7IJrTa5xmoBvFvCzPvSN1gcgMXXHBLHMwJ76Ur3jw4xjCut0UxtfOH/e271lDWHh2t4ZFxZNaMsRpFEyDtBU88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=np1V6hlz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="np1V6hlz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F691F000FF;
	Thu, 17 Sep 2026 23:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789686963;
	bh=V0Qfi0sziMfMHo5e856aDBZOHfl9lYPcHwof2Bus654=;
	h=Date:To:From:Subject;
	b=np1V6hlz8kxjYKeqZklD9O3B+z7JmT7usfuVelCyfQSw+kSqriFdCJJKUtbnMEdtX
	 WSR6M2jRtiPhUx2UfspaAANeA90sMojczu6EIaEimRUooxSZQUZWVtQ+FWjF4hjCii
	 ITu3aXkoeXMOgIEE89ioQsDAsGml3YaBAdx2gJZE=
Date: Thu, 17 Sep 2026 16:16:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,liam@infradead.org,kas@kernel.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-simplify-pgtable-deposit-detection.patch added to mm-hotfixes-unstable branch
Message-Id: <20260917231603.96F691F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: simplify pgtable deposit detection
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-simplify-pgtable-deposit-detection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-simplify-pgtable-deposit-detection.patch

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
From: Lance Yang <lance.yang@linux.dev>
Subject: mm/huge_memory: simplify pgtable deposit detection
Date: Thu, 17 Sep 2026 13:40:15 +0800

Whether a PMD has a deposited PTE page table only depends on whether the
architecture requires deposits or the VMA is anonymous.

Implement this rule directly in vma_has_deposited_pgtable(), avoiding
mistaking a non-anonymous raw PFN PMD for one with a deposit and
attempting to withdraw a page table that was never deposited.

Link: https://lore.kernel.org/20260917054015.23553-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
---

 mm/huge_memory.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-simplify-pgtable-deposit-detection
+++ a/mm/huge_memory.c
@@ -2514,25 +2514,13 @@ static struct folio *normal_or_softleaf_
 	return pmd_to_softleaf_folio(pmdval);
 }
 
-static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
-		struct folio *folio)
+static bool vma_has_deposited_pgtable(struct vm_area_struct *vma)
 {
-	/* Some architectures require unconditional depositing. */
-	if (arch_needs_pgtable_deposit())
-		return true;
-
-	/*
-	 * Huge zero always deposited except for DAX which handles itself, see
-	 * set_huge_zero_folio().
-	 */
-	if (is_huge_zero_pmd(pmdval))
-		return !vma_is_dax(vma);
-
 	/*
-	 * Otherwise, only anonymous folios are deposited, see
-	 * __do_huge_pmd_anonymous_page().
+	 * PMDs in anonymous VMAs always have a deposited page table. PMDs in
+	 * other VMAs only have one when required by the architecture.
 	 */
-	return folio && folio_test_anon(folio);
+	return arch_needs_pgtable_deposit() || vma_is_anonymous(vma);
 }
 
 /**
@@ -2572,7 +2560,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 
 	is_present = pmd_present(orig_pmd);
 	folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
-	has_deposit = has_deposited_pgtable(vma, orig_pmd, folio);
+	has_deposit = vma_has_deposited_pgtable(vma);
 	if (folio)
 		zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present);
 	if (has_deposit)
_

Patches currently in -mm which might be from lance.yang@linux.dev are

mm-huge_memory-simplify-pgtable-deposit-detection.patch
mm-huge_memory-fix-pgtable-withdrawal-for-huge-zero-pmds.patch

