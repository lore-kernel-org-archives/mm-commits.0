Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960CA49E123
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 00:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789084884; cv=none; b=h6gBAaRwpTllqPZohYaUMjW3opXFzOpgJzdTqyugiGmQp8eE7ZEuzD81KklTIPSpdbnuD9xRoJvnrUksdv0eFxouA6n9sk/S+lTDqT7fL/TJ/pD+kiFAXT7ptdZK4D9Twnj8BrOpPpjnexdEa0IKLRybCZP2KMxzCD/+92yTEDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789084884; c=relaxed/simple;
	bh=+KNmu2vTrGO2pu0hYqfs/9ZjNfNFky76LWquyjMz3UQ=;
	h=Date:To:From:Subject:Message-Id; b=hSyhl0oph4XGE5+q0sPD8XTXZ5yY/wf/M1dN96j/a54gZXdONI75sltWJNWSagjZ8WbWmcZhdQgDGtKbfN/z6q0/6cCQWZjIvZUwK9bOIMRpdHSNWIVMECYquj192IbeDEhqjGbHUKrGyPQ/JgWJeHVC6u5fAJXYGKP68hY/fwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cAnTCua9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cAnTCua9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1641F1F000FF;
	Fri, 11 Sep 2026 00:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789084883;
	bh=uUc0HONfQir9cf446TnHMgJmflPhTGeDunr3Zvb8MD8=;
	h=Date:To:From:Subject;
	b=cAnTCua9oEnFNQQO0GH9yUELAcGclAxcpoIJqwmoUayy50eXB22jRea4UoSqqkV86
	 zl1WWamUM+ukJUSjxbBLnr0zJtBuzN2vDCXYR4NAWHFPFPe1azbV45mIAnam0ACNQV
	 cNQA9E8j9FkOnkBOh75OdakFve1T0c/PyPQJia0g=
Date: Thu, 10 Sep 2026 17:01:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,hannes@cmpxchg.org,gourry@gourry.net,brendan.jackman@linux.dev,liuqiqi@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-add-missing-hooks-to-bulk-allocation-path.patch added to mm-new branch
Message-Id: <20260911000123.1641F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: add missing hooks to bulk allocation path
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-add-missing-hooks-to-bulk-allocation-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-add-missing-hooks-to-bulk-allocation-path.patch

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
Suggested-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-add-missing-hooks-to-bulk-allocation-path
+++ a/mm/page_alloc.c
@@ -5273,6 +5273,8 @@ retry_this_zone:
 		nr_account++;
 
 		prep_new_page(page, 0, gfp, ALLOC_DEFAULT);
+		trace_mm_page_alloc(page, 0, gfp, ac.migratetype);
+		kmsan_alloc_page(page, 0, gfp & ~__GFP_RECLAIM);
 		set_page_refcounted(page);
 		page_array[nr_populated++] = page;
 	}
_

Patches currently in -mm which might be from liuqiqi@kylinos.cn are

mm-page_alloc-add-missing-hooks-to-bulk-allocation-path.patch

