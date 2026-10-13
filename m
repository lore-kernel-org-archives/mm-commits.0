Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8C018C02E
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865937; cv=none; b=C155GZM/7mJmOkaH9V/C+0pHmraZuaXpANAzUdVCqRg2JAQUiaAUseRxjz4GoOik0mIHGPvWijUoVyZITXXninlIR1QG9cJnZkoWDjGCXRxveZ1XtApUNQ93K/sl5doHdgTJwv060Puozt8x7lQlvao8progxibBHX41ROdlpwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865937; c=relaxed/simple;
	bh=uiknFBF5msasHBXd2Rbvm9YJCpywstPodlBmVvbR54k=;
	h=Date:To:From:Subject:Message-Id; b=Z6cvUnLC9ZquKZ/0FHYFXSih0bC9Dbe9c4gnMgAZNuiSprAic/qPdyEhWwHjBm5b5DJik3A3XaPW4nDdDQaD037t/EfXQyR17xpHnvHponsxvuzrBMsvxbta5NN5z5eH1iKIwaZewNPndSVzIduMeMI8Z5IHulWcAU11aZ7YayE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wfE3hp2V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wfE3hp2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921D41F00898;
	Tue, 13 Oct 2026 04:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865936;
	bh=FkyjY4T4W4vLeJogYfkr7+Ks4ThHj0YdW5xyjoCVVD4=;
	h=Date:To:From:Subject;
	b=wfE3hp2VxMU4Uh4iG7kFzbTMvzJoYRzNvBgIHLHVinVsGi230juMAhFr/lVxHo3/U
	 mtyVByfgHG4PkOSd6jR/a4Y7bTiEQuYqC44XQTkazaFcJNj8wEYUVVL0FB9a+M9M9O
	 APXe7ZASg+9B0wninsQ4o7WYChy2dAWZCxJMyVUM=
Date: Mon, 12 Oct 2026 21:32:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,liam@infradead.org,kas@kernel.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-simplify-pgtable-deposit-detection.patch removed from -mm tree
Message-Id: <20261013043216.921D41F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: simplify pgtable deposit detection
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-simplify-pgtable-deposit-detection.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: mm/huge_memory: simplify pgtable deposit detection
Date: Thu, 17 Sep 2026 13:40:15 +0800

Whether a PMD has a deposited PTE page table only depends on whether the
architecture requires deposits or the VMA is anonymous.

Implement this rule directly in vma_has_deposited_pgtable(), avoiding
mistaking a non-anonymous raw PFN PMD for one with a deposit and
attempting to withdraw a page table that was never deposited.

There is no known in-tree workload that triggers this.  Mostly a
defensive/simplifying change.

Link: https://lore.kernel.org/20260917054015.23553-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
---

 mm/huge_memory.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-simplify-pgtable-deposit-detection
+++ a/mm/huge_memory.c
@@ -2520,25 +2520,13 @@ static struct folio *normal_or_softleaf_
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
@@ -2578,7 +2566,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 
 	is_present = pmd_present(orig_pmd);
 	folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
-	has_deposit = has_deposited_pgtable(vma, orig_pmd, folio);
+	has_deposit = vma_has_deposited_pgtable(vma);
 	if (folio)
 		zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present);
 	if (has_deposit)
_

Patches currently in -mm which might be from lance.yang@linux.dev are


