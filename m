Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE052C8CE
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 02:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782355183; cv=none; b=evrwuF6cJzqTo9ICK/zxSQhLcS30A/nVxe/UvFF5Wd4WCZeSs9bfzeWrpwOZfdmuIp1QXWayaADIDx+zpBEmMjpzzbbajiisvfXhxY+uAs9ikK/GnKTARanJJn42izHEy3oM1+m0A3rQhWIr/CKvxsTlHAjay+s7d/ZkHJC58pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782355183; c=relaxed/simple;
	bh=X5PbTrFOEUlFYTStia9xBlqzbZlNWBsu7g4pM6hOxlU=;
	h=Date:To:From:Subject:Message-Id; b=qPY+clnwBk8MsLpQqqOD+ka/ro8plp62L2tp6hyFn8jUS5u1aqmuhibgpdtWyvx1MKXxmfZPzBRuE2Rb2KysXXfird/AuaOnFGoQ2QOUFhevWIJl+t+CsWAQAANGjq9FgQA1/dray7u62Ft5zDeaP2hU/r6KMGP0oKfFT/hZ2xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TAhHpWO9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TAhHpWO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CF51F000E9;
	Thu, 25 Jun 2026 02:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782355181;
	bh=sIPxtrAL5JiGS+tqR3FWoHxDhSOnHELhPUl4M88hIxs=;
	h=Date:To:From:Subject;
	b=TAhHpWO9z8irnmKRhe/H2HhvK2pPk2ZcZ6RTIBsSzB4kXr0wNMkqaW41T+QVEuwLO
	 5ULDmL+jVcTi/OYsSeUrCHnNqUNK5WbBtZ0Xokj1PtlY2spLCplw927LYqzTc9DtFr
	 ctGh44EYWu4ttkBH1DNxlBm/MNa5U1Fg/hUJ6Kaw=
Date: Wed, 24 Jun 2026 19:39:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,rakie.kim@sk.com,pfalcato@suse.de,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch added to mm-new branch
Message-Id: <20260625023941.C0CF51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-mincore-use-walk_page_range_vma-in-do_mincore-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch

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
Subject: mm-mincore-use-walk_page_range_vma-in-do_mincore-fix
Date: Wed Jun 24 07:35:43 PM PDT 2026

simplify comment, per Pedro

Link: https://lore.kernel.org/ajP9bQhmvR9OX0VE@pedro-suse
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/mincore.c~mm-mincore-use-walk_page_range_vma-in-do_mincore-fix
+++ a/mm/mincore.c
@@ -261,12 +261,7 @@ static long do_mincore(unsigned long add
 	}
 
 	/*
-	 * walk_page_range_vma() does not call walk_page_test(), which
-	 * handles VM_PFNMAP VMA by invoking ->pte_hole() to skip the
-	 * page table walk. Without this check, PFNMAP PTEs would be
-	 * treated as present by mincore_pte_range(), changing the returned
-	 * residency status from the historical "not resident" to "resident".
-	 * Handle VM_PFNMAP explicitly to preserve the original behavior.
+	 * mincore historically reports PFNMAP mappings as non-resident.
 	 */
 	if (vma->vm_flags & VM_PFNMAP) {
 		__mincore_unmapped_range(addr, end, vma, vec);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
security-apparmor-apparmorfsc-conditionally-compile-get_loaddata_common_ref.patch

