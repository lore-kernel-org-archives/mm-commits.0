Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51BE2E40E
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736308358; cv=none; b=Nwu4lxCjjbRhnVNELGCudA0cPFFT5FK6pBiMsifffFrGaxO96+LxtHD7Xm73/J2s21Rhb30DeG7caIDWjVsYiEs1fzzENr0H0GqvCDt2uac5GdX93JBUzlbqgvgJl/4Awq7wLnClFvWBPIF5eS8hmDBbwIYVieGeDXLI6EryGP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736308358; c=relaxed/simple;
	bh=0VlI/1dUcWeeYNBP7DA67OVcpGMGJ4Y4hkEQR2AgadI=;
	h=Date:To:From:Subject:Message-Id; b=k0xX5M3hIhT+7mtMEn4p/iAxV8SoL+HhTf83WQXqdsoZTs2VESIfSGgUviS4ZXKzMhblZkO50ZkNKRO3D7ueudP4adkcXP0of34GG7bKQFJGiNKqIcoLGKlbCyOyg1RGJJRcIuVwZZKtrAULcMtYYKClmQzWLtfXbz7PQxWnDOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kd9z354P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kd9z354P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492C5C4CEE4;
	Wed,  8 Jan 2025 03:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736308358;
	bh=0VlI/1dUcWeeYNBP7DA67OVcpGMGJ4Y4hkEQR2AgadI=;
	h=Date:To:From:Subject:From;
	b=kd9z354PfA5IccCmRtx4lZbczxt0pZ+iLDH5SMnQuwv1VpraR2LQg5q2w7+fOs+q4
	 1vLbEulVSh8xYqUx+7TTf7c6wW97C3LxV1Tzv9+P7lWzQyE4xmab3PS3BBiIqDfBRe
	 qGAMOcvlxuqqC+qC0Df/NFCUyhdoJqdrq1K2JKHQ=
Date: Tue, 07 Jan 2025 19:52:37 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,riel@surriel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,leitao@debian.org,ackerleytng@google.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-stop-using-avoid_reserve-flag-in-fork.patch added to mm-unstable branch
Message-Id: <20250108035238.492C5C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: stop using avoid_reserve flag in fork()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-stop-using-avoid_reserve-flag-in-fork.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-stop-using-avoid_reserve-flag-in-fork.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: stop using avoid_reserve flag in fork()
Date: Tue, 7 Jan 2025 15:39:57 -0500

When fork() and stumble on top of a dma-pinned hugetlb private page, CoW
must happen during fork() to guarantee dma coherency.

In this specific path, hugetlb pages need to be allocated for the child
process.  Stop using avoid_reserve=1 flag here: it's not required to be
used here, as dest_vma (which is destined to be a MAP_PRIVATE hugetlb vma)
will have no private vma resv map, and that will make sure it won't be
able to use a vma reservation later.

No functional change intended with this change.  Said that, it's still
wanted to do this, so as to reduce the usage of avoid_reserve to the only
one user, which is also why this flag was introduced initially in commit
04f2cbe35699 ("hugetlb: guarantee that COW faults for a process that
called mmap(MAP_PRIVATE) on hugetlbfs will succeed").  I don't see whoever
else should set it at all.

Further patch will clean up resv accounting based on this.

Link: https://lkml.kernel.org/r/20250107204002.2683356-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-stop-using-avoid_reserve-flag-in-fork
+++ a/mm/hugetlb.c
@@ -5369,7 +5369,7 @@ again:
 				spin_unlock(src_ptl);
 				spin_unlock(dst_ptl);
 				/* Do not use reserve as it's private owned */
-				new_folio = alloc_hugetlb_folio(dst_vma, addr, 1);
+				new_folio = alloc_hugetlb_folio(dst_vma, addr, 0);
 				if (IS_ERR(new_folio)) {
 					folio_put(pte_folio);
 					ret = PTR_ERR(new_folio);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-avoid_reserve-to-allow-taking-folio-from-subpool.patch
mm-hugetlb-stop-using-avoid_reserve-flag-in-fork.patch
mm-hugetlb-rename-avoid_reserve-to-cow_from_owner.patch
mm-hugetlb-clean-up-map-global-resv-accounting-when-allocate.patch
mm-hugetlb-simplify-vma_has_reserves.patch
mm-hugetlb-drop-vma_has_reserves.patch
mm-hugetlb-unify-restore-reserve-accounting-for-new-allocations.patch

