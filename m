Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA70314D05
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 18:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777054175; cv=none; b=ofghGNxXbMaasu6szunpSbk+ohHn9dLS5d2xycrMCHXJ6QJTRxRdqMqEW5gHV2FHN8ABPBfaAZCW8/DkRmG5mApW2Ibpy6BbkfuFopo4/LqBS7PiC1NXiL9uKRK2JBP06LGZl9z3BHrnrxsRVbbr969fjKbuBROn3g8cY3Kj8oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777054175; c=relaxed/simple;
	bh=NrbBOCnJVqqLILqRpKlDsIlACyWtcjB2wS5fTwXHCu4=;
	h=Date:To:From:Subject:Message-Id; b=J6T7wx0l8f2F57v6t8LbD1nQ4tV6gq8kfKXneWURKgRbNGNk9Xf3L3ihIq6oB9fA9mPphgLKJUuBo1av+b5bR4F23bcUmL1Wf/OyY3bNjN47cpHpPEj+U0a4TSa+z7AL835XCRw0eaeWPVVExZXIIaP4iz1OgjeEUnwILYSuSpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vKrJlDsC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vKrJlDsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8286C19425;
	Fri, 24 Apr 2026 18:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777054175;
	bh=NrbBOCnJVqqLILqRpKlDsIlACyWtcjB2wS5fTwXHCu4=;
	h=Date:To:From:Subject:From;
	b=vKrJlDsCS+T9m7GOt07Ppim9rulLUsLirCqSNi/+b8czFI3awmn6w/7nmgTaIuDE0
	 JS/ctQbIf2Wrm4wnPjFqFus2uj/7ux/B8PvTWL6VuXXoVU++Aubfm4u9243dSXlMP9
	 rLAHuMgMnJXQVQS6JVNfZLs8vsq3E1kh33R6Ay8w=
Date: Fri, 24 Apr 2026 11:09:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-use-align-helpers-for-pmd-alignment.patch added to mm-new branch
Message-Id: <20260424180934.E8286C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: use ALIGN helpers for PMD alignment
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-use-align-helpers-for-pmd-alignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-use-align-helpers-for-pmd-alignment.patch

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/khugepaged: use ALIGN helpers for PMD alignment
Date: Thu, 9 Apr 2026 09:43:22 +0800

PMD alignment in khugepaged is currently implemented using a mix of
rounding helpers and open-coded bitmask operations.

Use ALIGN() and ALIGN_DOWN() consistently for PMD-sized address range
alignment, matching the preferred style for address and size handling.

No functional change intended.

Link: https://lore.kernel.org/20260409014323.2385982-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: Liu Ye <liuye@kylinos.cn>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-use-align-helpers-for-pmd-alignment
+++ a/mm/khugepaged.c
@@ -2875,8 +2875,8 @@ static void collapse_scan_mm_slot(unsign
 			cc->progress++;
 			continue;
 		}
-		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
-		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
+		hstart = ALIGN(vma->vm_start, HPAGE_PMD_SIZE);
+		hend = ALIGN_DOWN(vma->vm_end, HPAGE_PMD_SIZE);
 		if (khugepaged_scan.address > hend) {
 			cc->progress++;
 			continue;
@@ -3192,8 +3192,8 @@ int madvise_collapse(struct vm_area_stru
 	mmgrab(mm);
 	lru_add_drain_all();
 
-	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
-	hend = end & HPAGE_PMD_MASK;
+	hstart = ALIGN(start, HPAGE_PMD_SIZE);
+	hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-memory-failure-use-bool-for-forcekill-state.patch
mm-khugepaged-use-align-helpers-for-pmd-alignment.patch

