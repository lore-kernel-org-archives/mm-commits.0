Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203DD4D8A7
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725422341; cv=none; b=aVMiPmfqtQPcTVnguPm6onQ1yIAqhcaaF8Y14JS0wbQCsllNUeaKa5EwVcDZImphrNNAnOhnz3tXPAz0NbZD8pdALqNcBpF10dNhQ07XtOfU3PmK67YKCin3l7YRrbdL+P6VIf89qR0dceh+sDlnmKRDdnw4NIdrsBKGtT/gmHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725422341; c=relaxed/simple;
	bh=lxaXP4zjrYDxYJA6aXyDcPuL1kYkJGECx4pAxAc69Tk=;
	h=Date:To:From:Subject:Message-Id; b=DBmS+prywpBNJVvFQaSzm8n3RoGnSBh4lx4zOTb3Op4AAvHiQ1LwhCRhz0A8YqJrvJzlKxgBlP/cvCvMoGa57V53GcZ3s0QZNKIpuOIqqVQWLrHrm5TFzNJHtZ3noVFFb3UBZ4JtyreHc44k/l9pT+fyaHUuxQlPYEH5cFOEcnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sv86hA5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sv86hA5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F605C4CEC2;
	Wed,  4 Sep 2024 03:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725422340;
	bh=lxaXP4zjrYDxYJA6aXyDcPuL1kYkJGECx4pAxAc69Tk=;
	h=Date:To:From:Subject:From;
	b=sv86hA5L1Ay7VmN5/WO6YfpUZqjllqIF5KWlvPL8rbU/LtfCQCo0jSUvl7W8gnma1
	 zd7JfRVPQm5RPVflF9LluI/KeAVkc1hXS3y1HKVbtG4lvgNkwZQEAFBFMfSc5u3K3M
	 /n27arz6l1lYtqPWKgCBuwX2cHhETRq9mh37vi3I=
Date: Tue, 03 Sep 2024 20:59:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-remove-pageactive-fix.patch removed from -mm tree
Message-Id: <20240904035900.9F605C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-remove-pageactive-fix
has been removed from the -mm tree.  Its filename was
     mm-remove-pageactive-fix.patch

This patch was dropped because it was folded into mm-remove-pageactive.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-remove-pageactive-fix
Date: Thu Aug 22 11:21:31 AM PDT 2024

fix arch/powerpc/mm/pgtable-frag.c

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202408222044.zZMToCKk-lkp@intel.com/
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/pgtable-frag.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/powerpc/mm/pgtable-frag.c~mm-remove-pageactive-fix
+++ a/arch/powerpc/mm/pgtable-frag.c
@@ -136,10 +136,10 @@ void pte_fragment_free(unsigned long *ta
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 void pte_free_defer(struct mm_struct *mm, pgtable_t pgtable)
 {
-	struct page *page;
+	struct folio *folio;
 
-	page = virt_to_page(pgtable);
-	SetPageActive(page);
+	folio = virt_to_folio(pgtable);
+	folio_set_active(folio);
 	pte_fragment_free((unsigned long *)pgtable, 0);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-remove-pageactive.patch
documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled-fix.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-memory-failure-add-unmap_poisoned_folio-fix.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes.patch

