Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA382BE655
	for <mm-commits@vger.kernel.org>; Fri, 30 Jan 2026 07:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769756467; cv=none; b=pSqHpX2lweT6BUJq8gkvjjo8r4IdIpz8bnDZg+VQpigdxy1sZlU8eBVIMIOsIYxNLz+wgxeqTW0fKXNeyIa8Y6e2/Y4Erk+hlVZhw2UJa5UYtJbsQbCrVH7eFEfjUZn09oJXZF/kH5WXWiWEZfgYWT6Bf1JFvXR+8fqruuIxgW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769756467; c=relaxed/simple;
	bh=w103rtJlJMlXs0EilV5BSB4Ii4iy2qSzEoIZkMmfbzk=;
	h=Date:To:From:Subject:Message-Id; b=lgyqxvqWqb3md0DPneO+IOWbPuMS6PKlBBfT5g/eSKlDycfv8q3tgDnrypNVaYEQOU1F4uD9i8+7ZZErUSPPWiLvaSAkgX/y1xDiZpLzu8MMa9q2Wu9uofEoCcuF4FMmaUty2DA9vbqIDs1267QU8aEbE/5K7odTZ/DWLzQ9Yj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Isgnp8qG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Isgnp8qG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9919C4CEF7;
	Fri, 30 Jan 2026 07:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769756466;
	bh=w103rtJlJMlXs0EilV5BSB4Ii4iy2qSzEoIZkMmfbzk=;
	h=Date:To:From:Subject:From;
	b=Isgnp8qG7LFH+T+ipwahAGRAJS+dzUOrMHHNByMglne4EG7475ei+u6zFXPUbdA/f
	 qDX7HTdGJD7la1aZsGPb97ZFdX392EPBHrf3L7Aa0sSQk3Uox6+NuBgnhq0Y8mMW5a
	 tefJsATtq0gGWYPLQsVNhb36IXnnMJFcDSZLfDLQ=
Date: Thu, 29 Jan 2026 23:01:05 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,hu.shengming@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-avoid-overcounting-bulk-alloc-in-watermark-check.patch added to mm-new branch
Message-Id: <20260130070106.B9919C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: avoid overcounting bulk alloc in watermark check
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-avoid-overcounting-bulk-alloc-in-watermark-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-avoid-overcounting-bulk-alloc-in-watermark-check.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Shengming Hu <hu.shengming@zte.com.cn>
Subject: mm/page_alloc: avoid overcounting bulk alloc in watermark check
Date: Thu, 29 Jan 2026 22:38:14 +0800

alloc_pages_bulk_noprof() only fills NULL slots and already tracks how
many entries are pre-populated via nr_populated.

The fast watermark check was adding nr_pages unconditionally, which can
overestimate the demand.  Use (nr_pages - nr_populated) instead, as an
upper bound on the remaining pages this call can still allocate without
scanning the whole array.

Link: https://lkml.kernel.org/r/tencent_F36C5B5FB4DED98C79D9BDEE1210CD338C06@qq.com
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-avoid-overcounting-bulk-alloc-in-watermark-check
+++ a/mm/page_alloc.c
@@ -5125,7 +5125,7 @@ unsigned long alloc_pages_bulk_noprof(gf
 
 		cond_accept_memory(zone, 0, alloc_flags);
 retry_this_zone:
-		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages;
+		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages - nr_populated;
 		if (zone_watermark_fast(zone, 0,  mark,
 				zonelist_zone_idx(ac.preferred_zoneref),
 				alloc_flags, gfp)) {
_

Patches currently in -mm which might be from hu.shengming@zte.com.cn are

mm-page_alloc-avoid-overcounting-bulk-alloc-in-watermark-check.patch
watchdog-softlockup-fix-sample-ring-index-wrap-in-need_counting_irqs.patch

