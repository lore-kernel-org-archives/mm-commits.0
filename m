Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D31D347FD7
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 18:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776968085; cv=none; b=VLvlSENFCxzGL6ZRYDvLtZVWPDJojtDWum0R6pIWYTEKdue1OsvLDNKnqZIvppKsPDMG87bpNhKkR9QI6AbtIwHIY28Lm1zT/TlwXLYLH6mrsn39JuZ+AcrxvwPcl3aM4Ok7wBfmVF56mFGx9GY+Vlt0PGZEVUUU72GlQl4hcBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776968085; c=relaxed/simple;
	bh=GknNBr5IMDxXV3GzEXSvEewNu9E5t/kli5AIbidACig=;
	h=Date:To:From:Subject:Message-Id; b=RE5LcWhBICXEVcWmucV4EDJI7BvN8529QYawpFLoyEX/JW48ggjXmaAdhze2+AB1AtowPklEelCSt30TdbqfEjz9RBp4UqwB7Ory/LTlzdSuskbFer/qgGi9WGBUXwlycQasOwd+E6auwKYWretSpc69jn9cIPzz8PKbb6OEWvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iMsrWF6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iMsrWF6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8EAC2BCAF;
	Thu, 23 Apr 2026 18:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776968085;
	bh=GknNBr5IMDxXV3GzEXSvEewNu9E5t/kli5AIbidACig=;
	h=Date:To:From:Subject:From;
	b=iMsrWF6NqyZOa7kg1OGjGAM2XPjqFtgj/LMLSDIKcrhsSZ8qwDelNqlIWj6hV4nv4
	 YKF5+MX4pXtBQ2DjsiBdVnZlNADC5Dfkg3WGBFnbAuzbJRv0E7xi2ebsgbL3jh02xn
	 YjJbnXzNdSXd6mtWFTL3eqt76PbD5PotJLxit3VI=
Date: Thu, 23 Apr 2026 11:14:44 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-remove-sc-file_taken.patch added to mm-new branch
Message-Id: <20260423181445.0F8EAC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: remove sc->file_taken
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-remove-sc-file_taken.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-remove-sc-file_taken.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/vmscan: remove sc->file_taken
Date: Fri, 24 Apr 2026 01:43:23 +0800

No one is using it now, just remove it.

Link: https://lore.kernel.org/20260424-mglru-reclaim-v6-12-a57622d770c3@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Leno Hou <lenohou@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yafang <laoar.shao@gmail.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-sc-file_taken
+++ a/mm/vmscan.c
@@ -173,7 +173,6 @@ struct scan_control {
 		unsigned int congested;
 		unsigned int writeback;
 		unsigned int immediate;
-		unsigned int file_taken;
 		unsigned int taken;
 	} nr;
 
@@ -2040,8 +2039,6 @@ static unsigned long shrink_inactive_lis
 	sc->nr.writeback += stat.nr_writeback;
 	sc->nr.immediate += stat.nr_immediate;
 	sc->nr.taken += nr_taken;
-	if (file)
-		sc->nr.file_taken += nr_taken;
 
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-consolidate-common-code-for-retrieving-evictable-size.patch
mm-mglru-rename-variables-related-to-aging-and-rotation.patch
mm-mglru-relocate-the-lru-scan-batch-limit-to-callers.patch
mm-mglru-restructure-the-reclaim-loop.patch
mm-mglru-scan-and-count-the-exact-number-of-folios.patch
mm-mglru-use-a-smaller-batch-for-reclaim.patch
mm-mglru-dont-abort-scan-immediately-right-after-aging.patch
mm-mglru-remove-redundant-swap-constrained-check-upon-isolation.patch
mm-mglru-use-the-common-routine-for-dirty-writeback-reactivation.patch
mm-mglru-simplify-and-improve-dirty-writeback-handling.patch
mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch
mm-vmscan-remove-sc-file_taken.patch
mm-vmscan-remove-sc-unqueued_dirty.patch
mm-vmscan-unify-writeback-reclaim-statistic-and-throttling.patch

