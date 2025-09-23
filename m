Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317782550D8
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597503; cv=none; b=a4o1h5jJYswGNO2Tu/N/JhlQ4m27oz5CHG9csmhmwld98EWDBRM3v8LnVTdqtd4I/31ccMHd1qAy/xJXCW4i/krQYxYOtAaXTe7EeS0iPkPPbgctYlEJ4qw7RrQAqINUgNd8gG9V57ETYbL7hMFBtkO+fvZeEfMVazMM00EerVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597503; c=relaxed/simple;
	bh=zZQsoVwKCQInmBxwtdEonRvSfI1cMLQBKQQcxF7iIZk=;
	h=Date:To:From:Subject:Message-Id; b=ppmj9EJlBwQScIbfpckgPzQ/cn+AtHgn1ZFticD/rUHe5FRF544dsXbofTWOmNci+wrKL5x4zVEHHHoJDPMKvbZBZoUbfIKtOy3hQoCa+S3dBYwvSKLAxBhSiBuW//Az6mX4DXBQqRGeQFEzAxhFFcJ319wWN/wh7MOAfEVyWiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=be2uSv1I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="be2uSv1I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04A5C116B1;
	Tue, 23 Sep 2025 03:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597503;
	bh=zZQsoVwKCQInmBxwtdEonRvSfI1cMLQBKQQcxF7iIZk=;
	h=Date:To:From:Subject:From;
	b=be2uSv1ITykYralnZicTRnGwhksxjTSHTzoW5ovLDDcHk6KzE9arREZtDuZYfVP6m
	 MbnQFfK3TMG7DMSFhl9ENzjsIZs+q407o/moo+oNta3KAZLQAu/tNc83kv97hvcAYB
	 uUqj6nA31cmKtVwmeVItcYnvmKANiMUcyQsoI1M0=
Date: Mon, 22 Sep 2025 20:18:22 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kirill@shutemov.name,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-do-not-fail-collapse_pte_mapped_thp-on-scan_pmd_null.patch removed from -mm tree
Message-Id: <20250923031822.F04A5C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: do not fail collapse_pte_mapped_thp() on SCAN_PMD_NULL
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-do-not-fail-collapse_pte_mapped_thp-on-scan_pmd_null.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
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

mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary.patch
mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one.patch
mm-rmap-mlock-large-folios-in-try_to_unmap_one.patch
mm-fault-try-to-map-the-entire-file-folio-in-finish_fault.patch
mm-rmap-improve-mlock-tracking-for-large-folios.patch

