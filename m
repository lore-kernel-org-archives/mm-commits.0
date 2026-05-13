Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFF83264E9
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 23:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778714878; cv=none; b=Ku21va1k3J8i+UVjByMm3Fb478gnkcbeaqn0k1JysomXxeMGNxAIHhgGkzfCJ6vU7InkPafHNWjZQjdo4WQzB2KIxAN05yLeMMO+QhJdT0G5YfnJ1X96ZhIevl8LEOGOLzrJx+65Qok+DtHnBj32Ds+u/OoVhLxfvV9VrICcNLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778714878; c=relaxed/simple;
	bh=SYv/WNkd7MbMkiwIqe5qLPhsIG7sMlIkTT5SOU1LBgo=;
	h=Date:To:From:Subject:Message-Id; b=K50O30h1khGwIvt+NIR7RARy7GhQfeScDJZfhsY/ZrK4bFOiNO8/As9tJceKjCY6JfoKz3KtF6p5UATosD4YHxu13UKbmvJObLIg77lV1f5boPYxnQbALKj2pP3radsfRZ/yIpE1/NPMLQpnUWb7CWDfOA9/KHITbw/jTyLnpIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ksAUIKXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ksAUIKXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85A4C19425;
	Wed, 13 May 2026 23:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778714877;
	bh=SYv/WNkd7MbMkiwIqe5qLPhsIG7sMlIkTT5SOU1LBgo=;
	h=Date:To:From:Subject:From;
	b=ksAUIKXV/OHxGHkSHlF9OIU3GA5kzysR7mCYlWyFOg0syJTzfcHdPIzMLesMyZsCY
	 BuMM3H69Y6i0pI4QNhoBrTZjEKJIkFqgbWpPC/b6MAhFf336b3MigL3C8G33hs7lMt
	 0oUIJl1urBx8L+eZP3ZI0bdg16+4SownYPTFNogo=
Date: Wed, 13 May 2026 16:27:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,chenwandun@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-avoid-underflow-in-madvise_collapse-for-sub-pmd-madv_collapse.patch added to mm-new branch
Message-Id: <20260513232757.A85A4C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: avoid underflow in madvise_collapse for sub-PMD MADV_COLLAPSE
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-avoid-underflow-in-madvise_collapse-for-sub-pmd-madv_collapse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-avoid-underflow-in-madvise_collapse-for-sub-pmd-madv_collapse.patch

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
From: Chen Wandun <chenwandun@lixiang.com>
Subject: mm/khugepaged: avoid underflow in madvise_collapse for sub-PMD MADV_COLLAPSE
Date: Wed, 13 May 2026 13:54:28 +0800

madvise_collapse() computes the THP-aligned window:

    hstart = ALIGN(start, HPAGE_PMD_SIZE); 	/* round up */
    hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);	/* round down */

The following case will cause hstart > hend, and result in underflow in
the return statement, avoid it by returning zero early when hstart > hend.
The return value is due to input is valid to madvise(), and there is
nothing to collapse.

    madvise(PMD-aligned + PAGE_SIZE, PAGE_SIZE, MADV_COLLAPSE);

In addition, kmalloc_obj(), mmgrab() and lru_add_drain_all() are
unnecessary when hstart == hend, so skip these operations by returning
early too.

Link: https://lore.kernel.org/20260513055428.1664898-1-chenwandun@lixiang.com
Signed-off-by: Chen Wandun <chenwandun@lixiang.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-avoid-underflow-in-madvise_collapse-for-sub-pmd-madv_collapse
+++ a/mm/khugepaged.c
@@ -3202,6 +3202,12 @@ int madvise_collapse(struct vm_area_stru
 	if (!collapse_allowable_orders(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
 		return -EINVAL;
 
+	hstart = ALIGN(start, HPAGE_PMD_SIZE);
+	hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
+
+	if (hstart >= hend)
+		return 0;
+
 	cc = kmalloc_obj(*cc);
 	if (!cc)
 		return -ENOMEM;
@@ -3211,9 +3217,6 @@ int madvise_collapse(struct vm_area_stru
 	mmgrab(mm);
 	lru_add_drain_all();
 
-	hstart = ALIGN(start, HPAGE_PMD_SIZE);
-	hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
-
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;
 
_

Patches currently in -mm which might be from chenwandun@lixiang.com are

mm-khugepaged-avoid-underflow-in-madvise_collapse-for-sub-pmd-madv_collapse.patch

