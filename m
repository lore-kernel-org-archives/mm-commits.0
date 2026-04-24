Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C053C38A72C
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 10:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777028187; cv=none; b=m/frT5hQOMs3wCTOjV5YOkaiLnEBL4Ydw0PD8ihJRyBuFPwf1Fx5VcH6JwO7M/s1Whawd5L9WThZbBHT5R+G8SwccZex+MH1P9Q+cfa8iSDGS9gkLkXnhSey9TL/yysTj9D7xN+x/pr6mfs4vIsZipk4OlIsYqIM2N+MZ1Jcq1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777028187; c=relaxed/simple;
	bh=9v9w7ryLWFD3QeTSwK9OOdVR8XA3HHFLHi8hui0fWX4=;
	h=Date:To:From:Subject:Message-Id; b=evm7fMdNM/VOF/DRtrt7gEk0whN9P0au3gXsIbAS8EDUzUSziUSP6DP3tnYYj2jJf4x1Q3Y/PfSGOmIpAVFsSYXrd/ldkXsQDauM/IizBwOWPh/yoj8izybWHJoWMpYAKsY+tP4bQFyTNb9IWVIDGX9dRerl59AJftCsrKVK17s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yQJmXy7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yQJmXy7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48356C19425;
	Fri, 24 Apr 2026 10:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777028187;
	bh=9v9w7ryLWFD3QeTSwK9OOdVR8XA3HHFLHi8hui0fWX4=;
	h=Date:To:From:Subject:From;
	b=yQJmXy7lXedW/K9o6JkBD7xiCuoKLx+6YOQbXrtfbsiZs/AU0yaTmnUA9mn/wlDRf
	 rtU46s5wAo2iRfpcHtMbubPIIi2GHV+nhbLjoyQ4JIhzt2l6tgoSE5SQkhJ2LaBg/m
	 eXE4HD9BvFnG9ZnBG3YBwzxTuODRXD4uLKcfGYO8=
Date: Fri, 24 Apr 2026 03:56:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,nueralspacetech@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-cleanup-up-pmd-checks-and-warnings.patch added to mm-new branch
Message-Id: <20260424105627.48356C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate_device: cleanup up PMD Checks and warnings
has been added to the -mm mm-new branch.  Its filename is
     mm-migrate_device-cleanup-up-pmd-checks-and-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-cleanup-up-pmd-checks-and-warnings.patch

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
From: Sunny Patel <nueralspacetech@gmail.com>
Subject: mm/migrate_device: cleanup up PMD Checks and warnings
Date: Sun, 19 Apr 2026 23:17:43 +0530

Remove the odd VM_WARN_ON_FOLIO(!folio, folio) usage and replace it with a
simpler VM_WARN_ON_ONCE(!folio) check.

Drop the redundant VM_WARN_ON_ONCE(!pmd_none(*pmdp) &&
!is_huge_zero_pmd(*pmdp)).

Refactor the PMD checks, making the control flow clearer and avoiding
duplicate condition checks.

Link: https://lore.kernel.org/20260419174747.10701-1-nueralspacetech@gmail.com
Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-cleanup-up-pmd-checks-and-warnings
+++ a/mm/migrate_device.c
@@ -801,8 +801,7 @@ static int migrate_vma_insert_huge_pmd_p
 	bool flush = false;
 	unsigned long i;
 
-	VM_WARN_ON_FOLIO(!folio, folio);
-	VM_WARN_ON_ONCE(!pmd_none(*pmdp) && !is_huge_zero_pmd(*pmdp));
+	VM_WARN_ON_ONCE(!folio);
 
 	if (!thp_vma_suitable_order(vma, addr, HPAGE_PMD_ORDER))
 		return -EINVAL;
@@ -859,11 +858,9 @@ static int migrate_vma_insert_huge_pmd_p
 	if (userfaultfd_missing(vma))
 		goto unlock_abort;
 
-	if (!pmd_none(*pmdp)) {
-		if (!is_huge_zero_pmd(*pmdp))
-			goto unlock_abort;
+	if (is_huge_zero_pmd(*pmdp))
 		flush = true;
-	} else if (!pmd_none(*pmdp))
+	else if (!pmd_none(*pmdp))
 		goto unlock_abort;
 
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
_

Patches currently in -mm which might be from nueralspacetech@gmail.com are

mm-migrate_device-cleanup-up-pmd-checks-and-warnings.patch

