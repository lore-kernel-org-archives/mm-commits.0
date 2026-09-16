Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E203B4E88
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 01:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789522534; cv=none; b=Cr5Xe4piWNKOfswWHs4MOpEbMTI+8tPUBDapPPs079Wvn7I0s8JZY6ae3qcsJ7xlDIsIXyG09aI05XxXgIq/NMenMEGOkNJ9NFXk+jAuDV90LFujDnsRGJ55QyVms9e16Lk422aaStDv9Zs7FHrd/UgnDCHqssXi/RNhybzlvGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789522534; c=relaxed/simple;
	bh=GkJvz2WNjxGQSHEza9ey9ho3ZnzM833hpCZoRbU6+IM=;
	h=Date:To:From:Subject:Message-Id; b=q8Swhk2oug+kXIUmypSMj4tI+4kfA3AEILpUfYaBgG9CNnb2+4poFpBUl7pHg0QXTH1NXNBu/zh00phC+Oq7K3bjnGj4EJn1ale1MqYeOcdiupuPC9dq4E2fGSvqhnlZ5uoApT2+sVZmxxecK+pIZAeAhF4eF3Vx0tTnkD/mHvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EFufIFMj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EFufIFMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B8F1F000FF;
	Wed, 16 Sep 2026 01:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789522524;
	bh=qOgSScAhR4lq9nfJwbSQ9mrVq4kYHLW9pcjCDqxlyXI=;
	h=Date:To:From:Subject;
	b=EFufIFMjUU7RAixSw4GpJ2h5GLF5hGhUFnfoh04Pbd1jCs8w7WMm1R+mPZjuH5MW+
	 3PVrK63sNpc3pv3LKU4F5YRYHOG++lKRj5/P9fHYzdCkFgH8tyXADWSPA/qw1o3zaB
	 6qvLSTJb1H9diRZKsn0RwLzyplrxCfNDGk6PECDk=
Date: Tue, 15 Sep 2026 18:35:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,hannes@cmpxchg.org,brendan.jackman@linux.dev,liuqiqi@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-apply-per-task-gfp-context-in-bulk-allocator.patch added to mm-new branch
Message-Id: <20260916013524.C7B8F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: apply per-task GFP context in bulk allocator
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-apply-per-task-gfp-context-in-bulk-allocator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-apply-per-task-gfp-context-in-bulk-allocator.patch

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
From: Qiqi Liu <liuqiqi@kylinos.cn>
Subject: mm/page_alloc: apply per-task GFP context in bulk allocator
Date: Tue, 15 Sep 2026 15:49:28 +0800

alloc_pages_bulk_noprof() does not call current_gfp_context(), so per-task
scoped allocation constraints (PF_MEMALLOC_NOIO, PF_MEMALLOC_NOFS,
PF_MEMALLOC_PIN) are not applied on the bulk fast path.

By ignoring PF_MEMALLOC_NOIO and PF_MEMALLOC_NOFS, the allocation can
theoretically result in a deadlock.

Ignoring PF_MEMALLOC_PIN also has consequences: without clearing
__GFP_MOVABLE, prepare_alloc_pages() selects MIGRATE_MOVABLE for the PCP
list, and a task with PF_MEMALLOC_PIN set receives movable pages from the
bulk allocator.  Once pinned, these pages can no longer be migrated but
remain in MOVABLE pageblocks, violating the mobility contract.  This can
increase fragmentation and interfere with compaction or contiguous-memory
allocations, eventually surfacing as higher allocation latency or
allocation failures under memory pressure.

Found via review of the bulk allocation tracepoint hooks [1].

Link: https://sashiko.dev/#/patchset/20260907120949.418450-1-liuqiqi%40kylinos.cn
Link: https://lore.kernel.org/all/20260907120949.418450-1-liuqiqi@kylinos.cn/ [1]
Link: https://lore.kernel.org/20260915074928.327471-1-liuqiqi@kylinos.cn
Fixes: 387ba26fb1cb ("mm/page_alloc: add a bulk page allocator")
Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_alloc.c~mm-page_alloc-apply-per-task-gfp-context-in-bulk-allocator
+++ a/mm/page_alloc.c
@@ -5201,6 +5201,7 @@ unsigned long alloc_pages_bulk_noprof(gf
 
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
 	gfp &= gfp_allowed_mask;
+	gfp = current_gfp_context(gfp);
 	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
 		goto out;
 
_

Patches currently in -mm which might be from liuqiqi@kylinos.cn are

mm-page_alloc-add-missing-hooks-to-bulk-allocation-path.patch
mm-page_alloc-apply-per-task-gfp-context-in-bulk-allocator.patch

