Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EDC67A0F
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 05:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707369682; cv=none; b=EobWyVXm85WG3aZKo5Sh4+4d5Tabw2AkSuJH/m0bVQG+NYvdvNOl7+DeZf+Miz+ZOIYGtyt5d0Yc56ZRpYoegRUpN7qwE91LSF3dx2CCRpwGkth+oJrdjkWsop/6kHebWpIhgkkJYwLq1e05F6x9lHkItihUBFmRH1f6f0EpOOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707369682; c=relaxed/simple;
	bh=qpdHy6BKLvfHdSrO55lbB7NNwFuP9bA8V8ArYH6gJ48=;
	h=Date:To:From:Subject:Message-Id; b=rgQomZVeHlWEs0h1/mSyUUDrZyKAknxXxdbS/dzpRJO3bRo2ETlu2pwfVD5Ropia81Xeh8V4FpjtdMRRX2g9MOLEqZGqnqXNC0yQNnAk52x4TRMSgRT55hHnToN5F/Wyh4q5/MrA6lhMwgrp9pWVYHMzz/9tz1ZvBKMboC3H0lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N+2UILUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N+2UILUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0102AC43399;
	Thu,  8 Feb 2024 05:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707369682;
	bh=qpdHy6BKLvfHdSrO55lbB7NNwFuP9bA8V8ArYH6gJ48=;
	h=Date:To:From:Subject:From;
	b=N+2UILUjdEoJHPS9pdj7RD5QrmPhwLkWTiQfV6vxusNv84hF2UGEC/Q/VQSbw6IMw
	 6QuYv55XTh5u1gwQPNHej4t7e7+dbbOGTaguKlTwnUeWaIVUH7RPGfFSSfsK4WIOg6
	 TE6pRQLd+ccGJNpQMiyiiCMrb04+puDimqgR3CXA=
Date: Wed, 07 Feb 2024 21:21:21 -0800
To: mm-commits@vger.kernel.org,wangjiexun@tinylab.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-madvise-dont-forget-to-leave-lazy-mmu-mode-in-madvise_cold_or_pageout_pte_range.patch removed from -mm tree
Message-Id: <20240208052122.0102AC43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: don't forget to leave lazy MMU mode in madvise_cold_or_pageout_pte_range()
has been removed from the -mm tree.  Its filename was
     mm-madvise-dont-forget-to-leave-lazy-mmu-mode-in-madvise_cold_or_pageout_pte_range.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: mm/madvise: don't forget to leave lazy MMU mode in madvise_cold_or_pageout_pte_range()
Date: Fri, 26 Jan 2024 12:25:48 +0900

We need to leave lazy MMU mode before unlocking.

Link: https://lkml.kernel.org/r/20240126032608.355899-1-senozhatsky@chromium.org
Fixes: b2f557a21bc8 ("mm/madvise: add cond_resched() in madvise_cold_or_pageout_pte_range()")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jiexun Wang <wangjiexun@tinylab.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/madvise.c~mm-madvise-dont-forget-to-leave-lazy-mmu-mode-in-madvise_cold_or_pageout_pte_range
+++ a/mm/madvise.c
@@ -429,6 +429,7 @@ restart:
 		if (++batch_count == SWAP_CLUSTER_MAX) {
 			batch_count = 0;
 			if (need_resched()) {
+				arch_leave_lazy_mmu_mode();
 				pte_unmap_unlock(start_pte, ptl);
 				cond_resched();
 				goto restart;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


