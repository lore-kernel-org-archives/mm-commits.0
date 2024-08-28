Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956A41B2530
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 20:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724877969; cv=none; b=B4ATFKkcJIvETlI2jagIbWByd9A1EErjecazahtMbXlqbQI9K1o6eT8j2xpr/LCDaG4Akg8PJXxLmEesIXM0zo5cG43BT59dcfBh0kfsf2SBzCfUWIEdSIh+JLxu2XB1LBtVJWHe93NqE73gi5AuWdWDDMwFLi2w5URUGHSpO78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724877969; c=relaxed/simple;
	bh=IWFu7P1coZVSkcmp80MOvMwPZXJwTzFsUjJibUb8dZY=;
	h=Date:To:From:Subject:Message-Id; b=bSVbNdB9Ez5u9UY+NL6cjbXXoBBdZ+WeuClWGcbnhdYINgDhBWX3ytljYoWVOgZ7K5zHf0rEb0GnU7H9g+dJnvWhIyXyVWjIqdg0Mo5Efqcori9el20vTEm7huRFM2UIjZTS1o3kEFAoumD2la2avJbper7buVTv8mmLu0K5iAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LizRAcgR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LizRAcgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C13CC4CEC1;
	Wed, 28 Aug 2024 20:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724877969;
	bh=IWFu7P1coZVSkcmp80MOvMwPZXJwTzFsUjJibUb8dZY=;
	h=Date:To:From:Subject:From;
	b=LizRAcgRbfhJJL2RyP0PS5Un5qF0nWQmK2ZJimPL5Gt8k1GFCFXNEsXEaFsKu50rG
	 27L7VZDSSJR8kaSjUstJNwugqRkk1oaHMJr4KEixt/LsreD3/x13EfOV5diK7h1102
	 XT44MpShJTtjoglmMLU+pMMGE8lnj6/P3fRCi/MQ=
Date: Wed, 28 Aug 2024 13:46:08 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,mjguzik@gmail.com,dave@stgolabs.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch added to mm-unstable branch
Message-Id: <20240828204609.1C13CC4CEC1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-hugetlb-sort-out-global-lock-annotations-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch

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
Subject: mm-hugetlb-sort-out-global-lock-annotations-fix-fix
Date: Wed Aug 28 01:40:09 PM PDT 2024

DEFINE_SPINLOCK doesn't permit section modifiers at end-of-definition

Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-sort-out-global-lock-annotations-fix-fix
+++ a/mm/hugetlb.c
@@ -72,7 +72,7 @@ static unsigned int default_hugepages_in
  * Protects updates to hugepage_freelists, hugepage_activelist, nr_huge_pages,
  * free_huge_pages, and surplus_huge_pages.
  */
-DEFINE_SPINLOCK(hugetlb_lock) __cacheline_aligned_in_smp;
+__cacheline_aligned_in_smp DEFINE_SPINLOCK(hugetlb_lock);
 
 /*
  * Serializes faults on the same logical page.  This is used to
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-remove-legacy-install_special_mapping-code-checkpatch-fixes.patch
mm-contig_alloc-support-__gfp_comp-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
mm-remove-pageactive-fix.patch
selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

