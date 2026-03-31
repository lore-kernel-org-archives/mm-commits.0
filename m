Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772CF40855
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917826; cv=none; b=fdIakqGcvh6tkP5nNvnDHOu0xbgT07+uoP9/5b7Sxu9RK9t2j/09/ldhr90gLxuNbK37F6+VVfYuc80qlhfXCoVhS6GngTdAv+Bw5maNX6deIoo+ddqIAfFnFi10ElrUnMPwa1o3xnpeMknSro3RS0wfgjLFM8YYZm4taWUdQVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917826; c=relaxed/simple;
	bh=AQ2Dx8B/92LLaHbmQexIKfu/gIeeGNCdyTjvzaOKd6g=;
	h=Date:To:From:Subject:Message-Id; b=FoBPexpfBBLRhHGR3e23GZ1HtEoucg8iqHYHr8AgXeGrxCaZyAKiBoWl2rVoHD0SyEvsdcioWQ8ODhpNG8dIYeRDKTqbPwqeFgR2SKzmfpHhRhAg8UaXPdN94Jo2vuJe7ECu00X5P91E/K61gBch4j19oKULX7vJjMOhtuUBZO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h7saxLXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h7saxLXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4BAC19423;
	Tue, 31 Mar 2026 00:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917826;
	bh=AQ2Dx8B/92LLaHbmQexIKfu/gIeeGNCdyTjvzaOKd6g=;
	h=Date:To:From:Subject:From;
	b=h7saxLXzXckAjBLuN4iHMCER3b5sbft4q97onx4HUadOByD5dz1jRF6X6Wax2Jd7/
	 AOZVuxAJ0OSs7yjDN/357TlHU3c7UpkXjQTyDft3r++huClizjN3SwYouXw989QLkb
	 MIzQyQXjIrGIQaNgG8GqUt8pT6xWsiYjmIZB++z4=
Date: Mon, 30 Mar 2026 17:43:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-add-a-common-exit-path-to-zap_huge_pmd.patch removed from -mm tree
Message-Id: <20260331004346.4C4BAC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: add a common exit path to zap_huge_pmd()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-add-a-common-exit-path-to-zap_huge_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/huge_memory: add a common exit path to zap_huge_pmd()
Date: Fri, 20 Mar 2026 18:07:22 +0000

Other than when we acquire the PTL, we always need to unlock the PTL, and
optionally need to flush on exit.

The code is currently very duplicated in this respect, so default
flush_needed to false, set it true in the case in which it's required,
then share the same logic for all exit paths.

This also makes flush_needed make more sense as a function-scope value (we
don't need to flush for the PFN map/mixed map, zero huge, error cases for
instance).

Link: https://lkml.kernel.org/r/6b281d8ed972dff0e89bdcbdd810c96c7ae8c9dc.1774029655.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-a-common-exit-path-to-zap_huge_pmd
+++ a/mm/huge_memory.c
@@ -2415,7 +2415,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 		 pmd_t *pmd, unsigned long addr)
 {
 	struct folio *folio = NULL;
-	bool flush_needed = true;
+	bool flush_needed = false;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
 
@@ -2437,19 +2437,18 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 	if (vma_is_special_huge(vma)) {
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
-		spin_unlock(ptl);
-		return true;
+		goto out;
 	}
 	if (is_huge_zero_pmd(orig_pmd)) {
 		if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
-		spin_unlock(ptl);
-		return true;
+		goto out;
 	}
 
 	if (pmd_present(orig_pmd)) {
 		struct page *page = pmd_page(orig_pmd);
 
+		flush_needed = true;
 		folio = page_folio(page);
 		folio_remove_rmap_pmd(folio, page, vma);
 		WARN_ON_ONCE(folio_mapcount(folio) < 0);
@@ -2458,14 +2457,12 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
 
 		folio = softleaf_to_folio(entry);
-		flush_needed = false;
 
 		if (!thp_migration_supported())
 			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
 	} else {
 		WARN_ON_ONCE(true);
-		spin_unlock(ptl);
-		return true;
+		goto out;
 	}
 
 	if (folio_test_anon(folio)) {
@@ -2492,10 +2489,10 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 		folio_put(folio);
 	}
 
+out:
 	spin_unlock(ptl);
 	if (flush_needed)
 		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
-
 	return true;
 }
 
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

