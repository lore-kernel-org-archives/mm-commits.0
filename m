Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CEB9478
	for <mm-commits@vger.kernel.org>; Mon, 15 Sep 2025 19:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757965657; cv=none; b=g0vA7uhAmwVDj5di7qtFgllrNmlFgqWgma/imWo5VJx10FVfe7fAF2CbVxulNZwH9m6iNoUxRFuFb+50+uLmBJDX57Q32AhJgTr1K+3khViDn8b0Zr/E8FmNAG2NOhIW77gCiEU4vWzgcA+ZU4mVv4SsxMVr6HM6sro6jUo267g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757965657; c=relaxed/simple;
	bh=beGQznMU+SaBBZJJi8HgYraxym/MT8mo1MUlGReYVMo=;
	h=Date:To:From:Subject:Message-Id; b=P1f6AtqD2ksvY4D3P7Ncxg8QsN07A6zomvrAddcslyOBEMjilw2yKoKihNOH4pZZ2fODdnOGKcFVg/zrwKX5wK2RhB7tILmC6WzXbY1Z9Wi/NsPfwfaJ2pymziWfU1ppd7eJnbJ4+wbbKies6aIeGufUETSj5GhUjf1cK9XWy2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0hz/oDVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0hz/oDVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814B0C4CEF1;
	Mon, 15 Sep 2025 19:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757965656;
	bh=beGQznMU+SaBBZJJi8HgYraxym/MT8mo1MUlGReYVMo=;
	h=Date:To:From:Subject:From;
	b=0hz/oDVeqXt3yHUT25uEXnU3qhfpPD59pPzBRhJC6pRRcqSOfI9E4xeer4keknqdJ
	 ACxIPElWDzrOTrCga4AeypiA08MwyeKmOzHVLrNSfmi9F6uNoTo0Ys/A1TerHZNbus
	 csZ3R6YvWZQkXvtjbeM2v4ejd+GaZHEL+p/7Dkak=
Date: Mon, 15 Sep 2025 12:47:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-do-not-fail-collapse_pte_mapped_thp-on-scan_pmd_null.patch added to mm-new branch
Message-Id: <20250915194736.814B0C4CEF1@smtp.kernel.org>
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
Date: Fri, 12 Sep 2025 17:58:11 +0100

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

Link: https://lkml.kernel.org/r/xhan2av3fyl7qpsl4bhjtds2zeegrl57ehtc5grtkua3c3v3nz@vain5s6gpycl
Fixes: 7d8faaf15545 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-do-not-fail-collapse_pte_mapped_thp-on-scan_pmd_null
+++ a/mm/khugepaged.c
@@ -1476,6 +1476,28 @@ static int set_huge_pmd(struct vm_area_s
 	return SCAN_SUCCEED;
 }
 
+static int install_huge_pmd(struct vm_area_struct *vma, unsigned long haddr,
+			    pmd_t *pmd, struct folio *folio)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+
+	pgd = pgd_offset(mm, haddr);
+	p4d = p4d_alloc(mm, pgd, haddr);
+	if (!p4d)
+		return SCAN_FAIL;
+	pud = pud_alloc(mm, p4d, haddr);
+	if (!pud)
+		return SCAN_FAIL;
+	pmd = pmd_alloc(mm, pud, haddr);
+	if (!pmd)
+		return SCAN_FAIL;
+
+	return set_huge_pmd(vma, haddr, pmd, folio, &folio->page);
+}
+
 /**
  * collapse_pte_mapped_thp - Try to collapse a pte-mapped THP for mm at
  * address haddr.
@@ -1544,6 +1566,7 @@ int collapse_pte_mapped_thp(struct mm_st
 	switch (result) {
 	case SCAN_SUCCEED:
 		break;
+	case SCAN_PMD_NULL:
 	case SCAN_PMD_NONE:
 		/*
 		 * All pte entries have been removed and pmd cleared.
@@ -1688,7 +1711,7 @@ int collapse_pte_mapped_thp(struct mm_st
 maybe_install_pmd:
 	/* step 5: install pmd entry */
 	result = install_pmd
-			? set_huge_pmd(vma, haddr, pmd, folio, &folio->page)
+			? install_huge_pmd(vma, haddr, pmd, folio)
 			: SCAN_SUCCEED;
 	goto drop_folio;
 abort:
_

Patches currently in -mm which might be from kas@kernel.org are

mm-khugepaged-do-not-fail-collapse_pte_mapped_thp-on-scan_pmd_null.patch

