Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1323321ABC9;
	Mon, 14 Sep 2026 03:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789356248; cv=none; b=KKUKm3AmaSwoRQ1H5/0c4D1akVoKh05TkqIGJ0D8ysr5SgVDVfEXz2elxj1Txr6tHTT7OpQ3JEkDrflNIz4PUoWGeLYB2QqxarczG6J4bet1dqZrG9oVCnN0rZOxLGBMBn9+H/J8linQ5aHfGIea8uU2T8jvV2bajq+iMDbgz1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789356248; c=relaxed/simple;
	bh=ERzn/YE27YAyKP+ok6f47Y/864rHxlkU5w1h8kYM+Xo=;
	h=Date:To:From:Subject:Message-Id; b=mkPGzTu1dSpVppHuUqjfprurip5CzKAguW7FoBWSG+CwTi5WBe3OJoqFPHa8v9pgwE9CVQJdCyQgZwyYLv6LQc1t5rwJ3DxZR9QFSkb/53K67ev1/T9JHicJpagpsnkoGCytQz3/K4owrvqy5G9vU80yGU2AmMzn4ISZGJmf750=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GOuWkA51; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GOuWkA51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A430D1F000FF;
	Mon, 14 Sep 2026 03:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789356237;
	bh=G+15soKdBTYqfhpIo+yyVkKGc5OoMViuHNAz6Eu0Css=;
	h=Date:To:From:Subject;
	b=GOuWkA51pcNA9kMHGslUTbHwmsxhDZKuQgvKiF0rOvAu+iCvgCifc8D4iMGAslK75
	 cOVCqggR/+3NIXabNMWOvJ5WsB2TFMgdw15KAG4tCeaHHYlvNw1+hvWIP14s7DcMH+
	 g1alYoDGQAVJrz3VRsz/IuRSFk51xRif2EMH60dE=
Date: Sun, 13 Sep 2026 20:23:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,mhocko@suse.com,hannes@cmpxchg.org,brendan.jackman@linux.dev,liuqiqi@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-apply-per-task-gfp-context-in-bulk-allocator.patch added to mm-new branch
Message-Id: <20260914032357.A430D1F000FF@smtp.kernel.org>
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
Date: Mon, 14 Sep 2026 10:45:55 +0800

alloc_pages_bulk_noprof() does not call current_gfp_context(), so per-task
scoped allocation constraints (PF_MEMALLOC_NOIO, PF_MEMALLOC_NOFS,
PF_MEMALLOC_PIN) are not applied on the bulk fast path.

The most direct consequence is PF_MEMALLOC_PIN: without clearing
__GFP_MOVABLE, prepare_alloc_pages() selects MIGRATE_MOVABLE for the PCP
list, and a task under memalloc_pin_save() receives movable pages from the
bulk allocator.

Link: https://lore.kernel.org/20260914024555.138125-1-liuqiqi@kylinos.cn
Fixes: 387ba26fb1cb ("mm/page_alloc: add a bulk page allocator")
Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
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

