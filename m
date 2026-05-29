Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F28136F418
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027599; cv=none; b=g5rIL5qJRRDzrZKsqQdA8DKVNcPCtOJz3ffVJSRJwUhMUXFLsbs/eM/bV5djNycg2Pn4LwzRtzxlAh1D5LTm7QrF+9G4IWln5KQokFFbtOojsCEg95OqIEKa3q7XOvX/pbtQw+0PsqZAgJbJLMlzOJCxnzqOIyZWkZYTWl3Dslo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027599; c=relaxed/simple;
	bh=8kntTeBuBZO+OZpagCWERaRES2Gp9ViEG9atYmc9cy4=;
	h=Date:To:From:Subject:Message-Id; b=lUHMT3noWlmj7fQWX96GFEgaLlh9h40WXI4Lart+TvU1vys11Oqrl3Mw2f/s7v0aFr/CAEik477zHIBQ4m3HFDhwWCuwD3OmoBDtdj0CF+9f7fzXrArmrp+2T9jpnCK1pprU9/Jfj4c+pi0pVqD1f9RkHCJpf77KUZutwib/R4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MYv8HSsy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MYv8HSsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75111F00893;
	Fri, 29 May 2026 04:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027598;
	bh=Hp1Eu1oosZWcB2jT1z/GVRfzFZfop2RY9/NoLEh/ctQ=;
	h=Date:To:From:Subject;
	b=MYv8HSsyO3IoO1HtlTrSefF4vE7/hEpOa6tz1wA2BmqK3kxwI1cucGBxSQIopM8dN
	 rbfVEeNMswCsSLRQZuZYQGzRtb9sYOS/6vCy39WPyM3/IePJZ7vWnwUsMWVmuiQ3Vs
	 Fn2VGw2iYUJVfn7aLqNr3kENDlU0c5BCwTWX+G6U=
Date: Thu, 28 May 2026 21:06:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,nueralspacetech@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_device-cleanup-up-pmd-checks-and-warnings.patch removed from -mm tree
Message-Id: <20260529040637.E75111F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate_device: cleanup up PMD Checks and warnings
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-cleanup-up-pmd-checks-and-warnings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


