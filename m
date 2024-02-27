Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FC22557F
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 17:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709055482; cv=none; b=I76hWiRXtEBF0Mcxm8LlAaYZQFVOiJDmxI4vB96qgxvXj4aAwBAziylSLW7GKUUUogiOwAO8A9cCL2T36uSUmPRHFTQf/6TOJHsOIdjHPt8jRos0JBJBLTTJ9EkewffSuwRJNo73+67kcJkpHFn+RKpfL/3vUuR0yW5Qe0slNL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709055482; c=relaxed/simple;
	bh=KgX4vjjDPy3iervGCKwb7SAHN/ZiVQLcq2cwGEOphxc=;
	h=Date:To:From:Subject:Message-Id; b=Kr4EkOY8kGJxwgJ9/N5fIaTrT3yfqc8iJuAF77gcSP6WR6SgzrbcrpLboTmg5stWSZd4sYUIDNIsHyHK+I4EHvjzQ8QwT/XZgf49GmesVGVRilHL0ELDTrl5QOyZKFH4Dk8IKfWN0WYBBTgW+bnl1/TtPn8oKVk5olCgRLiE4mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XXonC1X3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XXonC1X3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CC5C433C7;
	Tue, 27 Feb 2024 17:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709055482;
	bh=KgX4vjjDPy3iervGCKwb7SAHN/ZiVQLcq2cwGEOphxc=;
	h=Date:To:From:Subject:From;
	b=XXonC1X3eRChvIpNDaHR9DD+zgNtma86jRq0HKc9TQK/ixVhAgk9HZFjIvdwHfAh3
	 2CNYOc3a00veO9YkMEy0+dUSGekU/perEf4DQ2kc/bQ18Zv2HqlnwjEunq3xJmzjjN
	 pdSm+DvqU2NB4zjEk6bVc1g/QFPruyDSqG0Lt7xA=
Date: Tue, 27 Feb 2024 09:38:01 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,songmuchun@bytedance.com,shy828301@gmail.com,peterx@redhat.com,minchan@kernel.org,mhocko@suse.com,david@redhat.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-keep-mm-in-mm_slot-without-mmf_disable_thp-check.patch added to mm-unstable branch
Message-Id: <20240227173801.D5CC5C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: keep mm in mm_slot without MMF_DISABLE_THP check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-keep-mm-in-mm_slot-without-mmf_disable_thp-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-keep-mm-in-mm_slot-without-mmf_disable_thp-check.patch

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
From: Lance Yang <ioworker0@gmail.com>
Subject: mm/khugepaged: keep mm in mm_slot without MMF_DISABLE_THP check
Date: Tue, 27 Feb 2024 11:51:35 +0800

Previously, we removed the mm from mm_slot and dropped mm_count
if the MMF_THP_DISABLE flag was set. However, we didn't re-add
the mm back after clearing the MMF_THP_DISABLE flag. Additionally,
We add a check for the MMF_THP_DISABLE flag in hugepage_vma_revalidate().

Link: https://lkml.kernel.org/r/20240227035135.54593-1-ioworker0@gmail.com
Fixes: 879c6000e191 ("mm/khugepaged: bypassing unnecessary scans with MMF_DISABLE_THP check")
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Suggested-by: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-keep-mm-in-mm_slot-without-mmf_disable_thp-check
+++ a/mm/khugepaged.c
@@ -920,7 +920,7 @@ static int hugepage_vma_revalidate(struc
 {
 	struct vm_area_struct *vma;
 
-	if (unlikely(hpage_collapse_test_exit(mm)))
+	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
 
 	*vmap = vma = find_vma(mm, address);
@@ -1428,7 +1428,7 @@ static void collect_mm_slot(struct khuge
 
 	lockdep_assert_held(&khugepaged_mm_lock);
 
-	if (hpage_collapse_test_exit_or_disable(mm)) {
+	if (hpage_collapse_test_exit(mm)) {
 		/* free mm_slot */
 		hash_del(&slot->hash);
 		list_del(&slot->mm_node);
@@ -2456,7 +2456,7 @@ breakouterloop_mmap_lock:
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm.
 	 */
-	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
+	if (hpage_collapse_test_exit(mm) || !vma) {
 		/*
 		 * Make sure that if mm_users is reaching zero while
 		 * khugepaged runs here, khugepaged_exit will find
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-khugepaged-keep-mm-in-mm_slot-without-mmf_disable_thp-check.patch

