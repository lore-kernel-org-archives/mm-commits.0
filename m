Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B628627A93A
	for <mm-commits@vger.kernel.org>; Mon, 15 Sep 2025 23:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757980209; cv=none; b=Pk19WJxIZvtGPtGCnW+SyDGLoENAMe02lxbQhPfXsRnY87nii52gmugkisXLhGUB61FFBpI7NqpM1tBArftl3IgmNTMD7QHwAN55JPS04AiFJm9McrqFpVwPehXftLRgMZ7zQCjHSKlbBcDr+TgVnM4p88Dpsuq9lJgNsXQvjYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757980209; c=relaxed/simple;
	bh=Gn0JjxkyPXN5701bmUcGfNOBFEKDzyM+UZvBmy8fTfE=;
	h=Date:To:From:Subject:Message-Id; b=H0nUwGUKqsnjEfZTqcKl1a/sg4HgOcu+e9jzJO4zqoAqnoXWB3uAitzhLRCeGwEidszJenylilgbGqVmUXu74SjUzHTLMVEw8lhi0veeGtcYjPrm1XjFYWt9jf7EP0eRujzh562RSaBQM3U3AXq2gIGWUuqytA5ualucKhl3fjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UQZytSkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UQZytSkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1749FC4CEF1;
	Mon, 15 Sep 2025 23:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757980209;
	bh=Gn0JjxkyPXN5701bmUcGfNOBFEKDzyM+UZvBmy8fTfE=;
	h=Date:To:From:Subject:From;
	b=UQZytSkhMoH9sMlU081epRM4BMXgDv1g+QJk3V5WyA4rZs39RZO2kTwsXkZFNuLC+
	 bVzFieOVWR3OaNPNSqCNovHYz7cDd+2KMpsu1AwyoRM3C0TO7r1XOSEiwgR7aIEB1X
	 qaemz7z9ICny9DeCl5okw+RYOtwKSOp9Boepks9E=
Date: Mon, 15 Sep 2025 16:50:08 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kirill@shutemov.name,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-do-not-fail-collapse_pte_mapped_thp-on-scan_pmd_null.patch added to mm-new branch
Message-Id: <20250915235009.1749FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: do not fail collapse_pte_mapped_thp() on SCAN_PMD_NULL
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-do-not-fail-collapse_pte_mapped_thp-on-scan_pmd_null.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-do-not-fail-collapse_pte_mapped_thp-on-scan_pmd_null.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm/khugepaged: do not fail collapse_pte_mapped_thp() on SCAN_PMD_NULL
Date: Mon, 15 Sep 2025 14:52:53 +0100

MADV_COLLAPSE on a file mapping behaves inconsistently depending on if PMD
page table is installed or not.

Consider following example:

	p = mmap(NULL, 2UL << 20, PROT_READ | PROT_WRITE,
		 MAP_SHARED, fd, 0);
	err = madvise(p, 2UL << 20, MADV_COLLAPSE);

fd is a populated tmpfs file.

The result depends on the address that the kernel returns on mmap().  If
it is located in an existing PMD table, the madvise() will succeed. 
However, if the table does not exist, it will fail with -EINVAL.

This occurs because find_pmd_or_thp_or_none() returns SCAN_PMD_NULL when a
page table is missing, which causes collapse_pte_mapped_thp() to fail.

SCAN_PMD_NULL and SCAN_PMD_NONE should be treated the same in
collapse_pte_mapped_thp(): install the PMD leaf entry and allocate page
tables as needed.

Link: https://lkml.kernel.org/r/v5ivpub6z2n2uyemlnxgbilzs52ep4lrary7lm7o6axxoneb75@yfacfl5rkzeh
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-do-not-fail-collapse_pte_mapped_thp-on-scan_pmd_null
+++ a/mm/khugepaged.c
@@ -1460,15 +1460,32 @@ static void collect_mm_slot(struct khuge
 static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
 			pmd_t *pmdp, struct folio *folio, struct page *page)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	struct vm_fault vmf = {
 		.vma = vma,
 		.address = addr,
 		.flags = 0,
-		.pmd = pmdp,
 	};
+	pgd_t *pgdp;
+	p4d_t *p4dp;
+	pud_t *pudp;
 
 	mmap_assert_locked(vma->vm_mm);
 
+	if (!pmdp) {
+		pgdp = pgd_offset(mm, addr);
+		p4dp = p4d_alloc(mm, pgdp, addr);
+		if (!p4dp)
+			return SCAN_FAIL;
+		pudp = pud_alloc(mm, p4dp, addr);
+		if (!pudp)
+			return SCAN_FAIL;
+		pmdp = pmd_alloc(mm, pudp, addr);
+		if (!pmdp)
+			return SCAN_FAIL;
+	}
+
+	vmf.pmd = pmdp;
 	if (do_set_pmd(&vmf, folio, page))
 		return SCAN_FAIL;
 
@@ -1544,6 +1561,7 @@ int collapse_pte_mapped_thp(struct mm_st
 	switch (result) {
 	case SCAN_SUCCEED:
 		break;
+	case SCAN_PMD_NULL:
 	case SCAN_PMD_NONE:
 		/*
 		 * All pte entries have been removed and pmd cleared.
_

Patches currently in -mm which might be from kas@kernel.org are

mm-khugepaged-do-not-fail-collapse_pte_mapped_thp-on-scan_pmd_null.patch

