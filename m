Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB90175D45
	for <mm-commits@vger.kernel.org>; Tue,  3 Sep 2024 20:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725394736; cv=none; b=qNrSAYGCIaTHdl+vQ29heV7UGVj/MFTX/hkdqdOXJvVNzD5du+NqxG4aQsmw3Ev9Gj8AqA/fdlPum7AowG7ij4GtLVdLmm2NJdF+Wr/wxKspkHVaV7OIHQf9cSUpTRMV7M3v2s4BxwHe+P2uQpc7nRAIVuh1654pWHsmUKFlHR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725394736; c=relaxed/simple;
	bh=6XuvqcMZNxC1g+vX3l7iNK5rTNJHQtY9reDuz86NWGw=;
	h=Date:To:From:Subject:Message-Id; b=XNwrEHBVxGIdMuMS+1xu8Lm1B12OPgP7wleZv65SDtKDCAyIATzSYAnR+sXivJo5aA7TQbK1bCKGXB2cQr7iecKIEF8RM8neAMo+Hs5oT93bez/t1eFwSHgUXNX6RucKzdbrfOyYSvl360ivJrbPKop/j5nugBLh4qzmQ40LHos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RzUExGkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RzUExGkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A98AC4CEC4;
	Tue,  3 Sep 2024 20:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725394736;
	bh=6XuvqcMZNxC1g+vX3l7iNK5rTNJHQtY9reDuz86NWGw=;
	h=Date:To:From:Subject:From;
	b=RzUExGkQaA3PfW7hETEqwrCrQcRW2evnRqRAprCKTCGNpYwdq6vHCnahZVmQHZNzl
	 bN+7rl1AL+/XHUmm9GMbEPgjmGjFxx5JcFIZRmbQYdEsGLy2LKHN90FroYdSHn1e6R
	 PJjKaoqnFZRUWvR1/1/UwL2ChMnixtyhNSsX6wf4=
Date: Tue, 03 Sep 2024 13:18:55 -0700
To: mm-commits@vger.kernel.org,riel@surriel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20240903201856.5A98AC4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes
Date: Tue Sep  3 01:17:51 PM PDT 2024

ERROR: code indent should use tabs where possible
#215: FILE: mm/shmem.c:1676:
+^I^I       ^I^I^I^Ishmem_huge_force, vma, vm_flags);$

WARNING: please, no space before tabs
#215: FILE: mm/shmem.c:1676:
+^I^I       ^I^I^I^Ishmem_huge_force, vma, vm_flags);$

ERROR: code indent should use tabs where possible
#254: FILE: mm/shmem.c:2439:
+^I       ^Istruct folio **foliop, enum sgp_type sgp)$

WARNING: please, no space before tabs
#254: FILE: mm/shmem.c:2439:
+^I       ^Istruct folio **foliop, enum sgp_type sgp)$

total: 2 errors, 2 warnings, 263 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mmtmpfs-consider-end-of-file-write-in-shmem_is_huge.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes
+++ a/mm/shmem.c
@@ -1673,7 +1673,7 @@ unsigned long shmem_allowable_huge_order
 		return 0;
 
 	global_huge = shmem_huge_global_enabled(inode, index, write_end,
-		       				shmem_huge_force, vma, vm_flags);
+					shmem_huge_force, vma, vm_flags);
 	if (!vma || !vma_is_anon_shmem(vma)) {
 		/*
 		 * For tmpfs, we now only support PMD sized THP if huge page
@@ -2436,7 +2436,7 @@ unlock:
  * Return: 0 if successful, else a negative error code.
  */
 int shmem_get_folio(struct inode *inode, pgoff_t index, loff_t write_end,
-	       	struct folio **foliop, enum sgp_type sgp)
+		    struct folio **foliop, enum sgp_type sgp)
 {
 	return shmem_get_folio_gfp(inode, index, write_end, foliop, sgp,
 			mapping_gfp_mask(inode->i_mapping), NULL, NULL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-contig_alloc-support-__gfp_comp-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix-fix.patch
mm-remove-pageactive-fix.patch
documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled-fix.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-memory-failure-add-unmap_poisoned_folio-fix.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes.patch

