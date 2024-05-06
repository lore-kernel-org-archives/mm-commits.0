Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D1D22089
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957066; cv=none; b=GD+QixrEhZnwSglnZUpuz15hXGeF0cTp7gRaFhQ103l+s+5ee5l8A70dP/fWApseT0uIrDWxCRTHPMcSQIbvWkuSIcdWndpLve4Ht6JW4KEt1ws7cX70ndSGPDoZELMkCQzXi6w/msAC98CIrNapYG2v+z8Ah/reGomAY2EBglE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957066; c=relaxed/simple;
	bh=HtHBcYzdf9aO/3j/Ye4zoZBA3pT4YByYAEO7d0f/yqI=;
	h=Date:To:From:Subject:Message-Id; b=tvfQFK4fDbqJB3CXqyhGW+KwMTJYmuPi8ShSN/gc517svKY5Pvg5jDCPPowewHUcvfKVlwZwJRUpWlUz59Mz/FVuLeVSn7kO4PANWlaiHJdMhP9QCky4FgluR9UDiW74GVgKcraI5Y/uLttysvWUmZYnBoXo6xHyQHDVCziTDHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B5yoVwWB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B5yoVwWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781E4C116B1;
	Mon,  6 May 2024 00:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957066;
	bh=HtHBcYzdf9aO/3j/Ye4zoZBA3pT4YByYAEO7d0f/yqI=;
	h=Date:To:From:Subject:From;
	b=B5yoVwWBk/8zkCXS292UM5v6uBvFfJuUlBI3dn8mwd+mRcDfLk3ppNcKzr2nSnbc+
	 4144w/CSp/m4+RhKGhKRMCVZJZxsfVMJy2u8zuPHGOENiApuVD5DuiimTO1G4iEcBa
	 qLVQYXGKcpCoCKCA6ROnux2gQ79CUeF1xme5XvGY=
Date: Sun, 05 May 2024 17:57:45 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmu-convert-pagemap_hugetlb_range-to-work-on-folios.patch removed from -mm tree
Message-Id: <20240506005746.781E4C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: convert pagemap_hugetlb_range() to work on folios
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-convert-pagemap_hugetlb_range-to-work-on-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/task_mmu: convert pagemap_hugetlb_range() to work on folios
Date: Wed, 17 Apr 2024 11:23:12 +0200

Patch series "fs/proc/task_mmu: convert hugetlb functions to work on folis".

Let's convert two more functions, getting rid of two more page_mapcount()
calls.


This patch (of 2):

Let's get rid of another page_mapcount() check and simply use
folio_likely_mapped_shared(), which is precise for hugetlb folios.

While at it, also check for PMD table sharing, like we do in
smaps_hugetlb_range().

No functional change intended, except that we would now detect hugetlb
folios shared via PMD table sharing correctly.

Link: https://lkml.kernel.org/r/20240417092313.753919-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240417092313.753919-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-convert-pagemap_hugetlb_range-to-work-on-folios
+++ a/fs/proc/task_mmu.c
@@ -1578,12 +1578,13 @@ static int pagemap_hugetlb_range(pte_t *
 
 	pte = huge_ptep_get(ptep);
 	if (pte_present(pte)) {
-		struct page *page = pte_page(pte);
+		struct folio *folio = page_folio(pte_page(pte));
 
-		if (!PageAnon(page))
+		if (!folio_test_anon(folio))
 			flags |= PM_FILE;
 
-		if (page_mapcount(page) == 1)
+		if (!folio_likely_mapped_shared(folio) &&
+		    !hugetlb_pmd_shared(ptep))
 			flags |= PM_MMAP_EXCLUSIVE;
 
 		if (huge_pte_uffd_wp(pte))
_

Patches currently in -mm which might be from david@redhat.com are


