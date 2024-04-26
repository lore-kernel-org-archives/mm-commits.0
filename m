Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C6876408
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103368; cv=none; b=SyOw3rAx0unrUj8e+ggfSSXWCne/JJRUHY+GH7+Ey9g3hjOQcUGivDv+jLTK53W3cZh8l6Rt66nAlXU27nCCU7vRjherz5hidWzfuCkwyiP/qLFgsDk1xp1tGurfLGOnsS4QtYpWENRGjihEHwBzqIbiCoLY3p/EjyaNUmO3qGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103368; c=relaxed/simple;
	bh=TOlWQnbjwz1B5WYYpyMziR151fwuUJDt3S3UokxVB1Q=;
	h=Date:To:From:Subject:Message-Id; b=XQhIbL6Rdx2p23YbV/So7W9rbPog4GM5Y74f8X6mFdRsOvJ5q5UzzpdXtAATYZc/JKnXMPGwkUX70ZIfQfeOhLQiZP9d+gTkNOdfunJiqSlfGwaxbpC38jzr2ZZx3rGamvimyfzKckpXz8w2BQDK3UcWQdKqUkmOxdpiz99pNQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NeWI0LUW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NeWI0LUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CE0C113CD;
	Fri, 26 Apr 2024 03:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103368;
	bh=TOlWQnbjwz1B5WYYpyMziR151fwuUJDt3S3UokxVB1Q=;
	h=Date:To:From:Subject:From;
	b=NeWI0LUWZUgIo5eLcHQAFQ2zkgeofPQ6we0dVft6HwQBtRtF7aiDfV+EjGaaK0EOT
	 PN1FNH67L6g4GIBtAttgzllbg4WZutMOzFnHj3LcnyZgfNu2IAOxb+c9eA92rjSdAV
	 HiKuSGpoIzmegHgP+dE224UQBA8LFftWpVtSBhPs=
Date: Thu, 25 Apr 2024 20:49:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,osalvador@suse.de,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] hugetlb-convert-hugetlb_wp-to-use-struct-vm_fault-fix.patch removed from -mm tree
Message-Id: <20240426034928.20CE0C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: Simplify hugetlb_wp() arguments
has been removed from the -mm tree.  Its filename was
     hugetlb-convert-hugetlb_wp-to-use-struct-vm_fault-fix.patch

This patch was dropped because it was folded into hugetlb-convert-hugetlb_wp-to-use-struct-vm_fault.patch

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: hugetlb: Simplify hugetlb_wp() arguments
Date: Mon, 8 Apr 2024 10:21:44 -0700

simplify the function arguments, per Oscar and Muchun.

Link: https://lkml.kernel.org/r/ZhQtoFNZBNwBCeXn@fedora
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Suggested-by: Muchun Song <muchun.song@linux.dev>
Suggested-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~hugetlb-convert-hugetlb_wp-to-use-struct-vm_fault-fix
+++ a/mm/hugetlb.c
@@ -5918,10 +5918,11 @@ static void unmap_ref_private(struct mm_
  * cannot race with other handlers or page migration.
  * Keep the pte_same checks anyway to make transition from the mutex easier.
  */
-static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
-		       struct folio *pagecache_folio,
+static vm_fault_t hugetlb_wp(struct folio *pagecache_folio,
 		       struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
+	struct mm_struct *mm = vma->vm_mm;
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
 	pte_t pte = huge_ptep_get(vmf->pte);
 	struct hstate *h = hstate_vma(vma);
@@ -6370,7 +6371,7 @@ static vm_fault_t hugetlb_no_page(struct
 	hugetlb_count_add(pages_per_huge_page(h), mm);
 	if ((vmf->flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
 		/* Optimization, do the COW without a second fault */
-		ret = hugetlb_wp(mm, vma, folio, vmf);
+		ret = hugetlb_wp(folio, vmf);
 	}
 
 	spin_unlock(vmf->ptl);
@@ -6583,7 +6584,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 
 	if (flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) {
 		if (!huge_pte_write(vmf.orig_pte)) {
-			ret = hugetlb_wp(mm, vma, pagecache_folio, &vmf);
+			ret = hugetlb_wp(pagecache_folio, &vmf);
 			goto out_put_page;
 		} else if (likely(flags & FAULT_FLAG_WRITE)) {
 			vmf.orig_pte = huge_pte_mkdirty(vmf.orig_pte);
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

hugetlb-convert-hugetlb_fault-to-use-struct-vm_fault.patch
hugetlb-convert-hugetlb_no_page-to-use-struct-vm_fault.patch
hugetlb-convert-hugetlb_wp-to-use-struct-vm_fault.patch

