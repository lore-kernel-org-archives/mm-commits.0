Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B603D407CEF
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525497; cv=none; b=a5+qP0Dmf8swDmUI1bCig/jNpgsWrCGFcXZEa3fIQN2hp3iOQQGFYm6e+ZxFC40xyZcsmKjmJTeiA6ayE5UwOMkyq3QAyRVkah8tI07ZjIriarnpxFgq8Rr+pY3yKJM7YBLaGAoU7thXiSTvch/50S0EorUq8iQszg6VXbzASQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525497; c=relaxed/simple;
	bh=We9O2bT3x1IEvAWapqVncTJPeyFnSEWm5RvIjP+aKbs=;
	h=Date:To:From:Subject:Message-Id; b=nq2FwWiYC0J3xqIm1Zr6EaK4VsHy86X17DB2kJmTm2hjfvcH30FEk8XF7fp4jTb64wwuTCui4xPS9WgEyyYY3Ifm1MLxRHRxt9Bs1VkVxh7XTMoLFeZt1Xr8NE1j6fh1vB+3fDEY0Ni7TUlhf0d4K+M1LrdrFbIr0hrmtbXq4OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XUEhmL6l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XUEhmL6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7E01F00893;
	Fri,  9 Oct 2026 05:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525496;
	bh=fFOfq5sGyVrsB/fARjUM7kmJ+2kVQT2jCdfeaSsvzy4=;
	h=Date:To:From:Subject;
	b=XUEhmL6lhuRI7Tfq+XjR7sJGmTVjFxbDwuIuLwzPLF10TCl/SJo86So+s3Jx59e5z
	 NQG8PuN5fDlHw6a5cKtV99RnkiAb9b5sr4Yn/Q4JJJ/cq+qHMRU3xw5/0q6oqusK0R
	 3n/K9iTDGZKXcBI17oo+BUy1Fmv2qzE7uxIsHP9w=
Date: Thu, 08 Oct 2026 22:58:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,hannes@cmpxchg.org,gourry@gourry.net,brendan.jackman@linux.dev,liuqiqi@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-add-missing-hooks-to-bulk-allocation-path.patch removed from -mm tree
Message-Id: <20261009055816.8C7E01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: add missing hooks to bulk allocation path
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-missing-hooks-to-bulk-allocation-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qiqi Liu <liuqiqi@kylinos.cn>
Subject: mm: page_alloc: add missing hooks to bulk allocation path
Date: Tue, 8 Sep 2026 18:23:56 +0800

The bulk allocation path in alloc_pages_bulk_noprof() currently misses
trace_mm_page_alloc() and kmsan_alloc_page() calls, leaving bulk-allocated
pages invisible to ftrace/BPF/perf and leaving KMSAN shadow memory stale.

Add both calls in the bulk loop to match the standard allocation path,
placing them before set_page_refcounted() for consistency.  The gfp mask
passed to kmsan_alloc_page() is stripped of __GFP_RECLAIM because the bulk
loop runs under the PCP spinlock, and KMSAN's stack depot allocation must
not sleep.

Both are no-ops when their respective features are disabled, so there
is no overhead in production kernels.

Link: https://lore.kernel.org/20260908102356.344075-1-liuqiqi@kylinos.cn
Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-add-missing-hooks-to-bulk-allocation-path
+++ a/mm/page_alloc.c
@@ -5261,6 +5261,8 @@ retry_this_zone:
 		nr_account++;
 
 		prep_new_page(page, 0, gfp, ALLOC_DEFAULT);
+		trace_mm_page_alloc(page, 0, gfp, ac.migratetype);
+		kmsan_alloc_page(page, 0, gfp & ~__GFP_RECLAIM);
 		set_page_refcounted(page);
 		page_array[nr_populated++] = page;
 	}
_

Patches currently in -mm which might be from liuqiqi@kylinos.cn are

mm-page_alloc-apply-per-task-gfp-context-in-bulk-allocator.patch

