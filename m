Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAED514ABE
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785297931; cv=none; b=g20y6Bp3oLpyV6KWq84AufZmu0pYJONF+Urn35WGnaH76q3ElBInk3wGmRBsy2cYBT5iWhyp5FtfxjikRMJLy7wd3MUzzG/FOdtuK4L7kN9LjpNSMK9jip8zhW2zMlkOotqi9BbBa48J26y3ji6pcJMTtj3NAGWXSXb1SqPO3aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785297931; c=relaxed/simple;
	bh=qLry2r5KO7ZnPIvPNUsue6slxbAtgLLwKMcVIUMBnSc=;
	h=Date:To:From:Subject:Message-Id; b=GYQMqlV/CPdQBBjMAy0MgQPIXVYLWRromlhE/hLg+chzRG5rMDC2qV2prgZw/o2LZ9zqu6aPnwoIBbYLQ4/3gng6llITlCMDJBC+iCT4+ikxfCvzlZrU8M0JF3B9dat1nnscd0QfKVCldFS0DUlXxzdhX9deaLPqa4PRGur3aPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AQ9pI/Ql; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AQ9pI/Ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D76D1F000E9;
	Wed, 29 Jul 2026 04:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785297930;
	bh=Ed2r1MrLFBspX1nKiqjti/XSAngt9pDQKBaKKK9pcNc=;
	h=Date:To:From:Subject;
	b=AQ9pI/QlSN0g3aC+w4Ci5I9cD/SD3t8d+zjPE8P28e8KV0eWbYU3jYak+dX+0pOrt
	 IGgpilwdZrDD/Q6F5TKNjrrApxVSZJOtuNSYqUzklo+ZsRgv2Fzf+GPl819g2EukW1
	 e4g3fii3z+tNYAJB7gq9H95UTeiFCKAuFWmCuoYQ=
Date: Tue, 28 Jul 2026 21:05:29 -0700
To: mm-commits@vger.kernel.org,dev.jain@arm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20260729040530.5D76D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-rmap-use-huge_ptep_get-in-try_to_migrate_one.patch

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

csky-implement-flush_cache_vmap-in-c.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier.patch
mm-vma-add-and-use-vma__pgoff-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

