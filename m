Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B243F2C0296
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 07:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783237615; cv=none; b=N3YOla2Ag6wNblzP/ZV5yvdV2QjUE3oidehaHkrevJwYA5aNXii3qfAQtvFgGdRk7a6ztQv5aRaprVZclzDPAS5lrALmt/AIGcH324APJEp7ZheUXbhw83oG41hwM2ZY67nGWR6SGw8wtlESu5MRXnOFC215dH9spFMm2imlOQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783237615; c=relaxed/simple;
	bh=9LSeVHgOnuzl8IomVs/q8T/XGQe65j5L/ZZ5Hh8KVII=;
	h=Date:To:From:Subject:Message-Id; b=HcaWh/XsAj77bBNS9w5IxquGSpRBdSRXG6p7tqoTDkWr5RTy7wRe3LDg5N2pn+N6QA8rELKSkYGpsdIj4/Or59gpciOewD/TZv93SsPgB1uK3Ayv1SMAsTRdx/CaYsj032ymNR/+fceZPKKO8KIhA1ZwoU9ABgrQpXMLKh0sCDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2Yi8h3aq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2Yi8h3aq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475DD1F000E9;
	Sun,  5 Jul 2026 07:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783237614;
	bh=deNlPqcqTN3/EUAWk8XtVlKnn17q4DXNChK+BerYt5U=;
	h=Date:To:From:Subject;
	b=2Yi8h3aq6f+FMfAvs4MMCPpbkAhlM9+drkcggM6pRkcEWD7xXiK5JUqN+5p/HQaIa
	 WRX+32Lper19eC/lLjYqXynmgxb15PTzCcHNFM0+5O6l0+BP5cB3+eZCr8Q5zbjrfz
	 QyimIDK1I5Hm4lh0UE3a2xIQmxhM+rVbBI5pvB1Q=
Date: Sun, 05 Jul 2026 00:46:53 -0700
To: mm-commits@vger.kernel.org,dev.jain@arm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch added to mm-new branch
Message-Id: <20260705074654.475DD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes
Date: Sun Jul  5 12:46:13 AM PDT 2026

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'Commit a98a2f0c8ce1 ("mm/rmap: split migration into its own function")'
#18: 
Commit a98a2f0c8ce1 copied the bug from try_to_unmap_one into

WARNING: braces {} are not necessary for any arm of this statement
#74: FILE: mm/rmap.c:2504:
+		if (folio_test_hugetlb(folio)) {
[...]
+		} else {
[...]

total: 1 errors, 1 warnings, 31 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-rmap-use-huge_ptep_get-in-try_to_migrate_one.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/rmap.c~mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes
+++ a/mm/rmap.c
@@ -2501,11 +2501,10 @@ static bool try_to_migrate_one(struct fo
 		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
 
 		address = pvmw.address;
-		if (folio_test_hugetlb(folio)) {
+		if (folio_test_hugetlb(folio))
 			pteval = huge_ptep_get(mm, address, pvmw.pte);
-		} else {
+		else
 			pteval = ptep_get(pvmw.pte);
-		}
 		if (likely(pte_present(pteval))) {
 			pfn = pte_pfn(pteval);
 		} else {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_vma_mapped-fix-device-private-pmd-handling-fix.patch
mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix.patch
mm-page_owner-add-print_mode-filter-fix.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

