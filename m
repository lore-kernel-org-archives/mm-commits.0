Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACD22AD22
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 21:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741901744; cv=none; b=eKiQhYHeXlgVgKbvrv5gbHC7hWAsvFIx17dWdHLse9MxH3RPGfE+2Me6wec8Ph2Ct4/JdDR+Ld3DIzkm8O/+veGJQIjMq/gB433QNsYV5ULoai/DcSEH+mArTObnf7wfO7ZyFzIkVN9XS2Ad70X2vPumy4ZCGygpHch55sHXsfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741901744; c=relaxed/simple;
	bh=5v+UcjeCCtMEqwTkWmbGx1enpyo54LXPBz6jyysstTI=;
	h=Date:To:From:Subject:Message-Id; b=rRh6N1SaTvyMey9hxSUIJggB6u1mOQrzNHpBJi2SfjloFQeKPbjrSYtoUwHRyKdPLuYqLvHvi8O0U/K1UW7iL+B9Lkace5u03GkhQw8vGzIqxUxkGMydViuPr0yiSMrAIh9cfDDdL4Ra5lfJncqY0VMpYOnSJDJOmBRWVCfSN1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X4gc3lnZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X4gc3lnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4881C4CEE5;
	Thu, 13 Mar 2025 21:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741901743;
	bh=5v+UcjeCCtMEqwTkWmbGx1enpyo54LXPBz6jyysstTI=;
	h=Date:To:From:Subject:From;
	b=X4gc3lnZzpkbLUmwl+q7skjVtc8VWFoCn7ZVTXoFYOI8tTwCE/2fKL97m/iGYHSF/
	 ZQQZceijhBkUbtjpuLkqGUREFiSOWdQ6Yp8gk58JYLPZTTIJGOIt1yYKW2So2Vm4AV
	 P7fRSg8r2flVP8rVqDiFdYdLyVpizgUX6eCD70VI=
Date: Thu, 13 Mar 2025 14:35:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,mgorman@techsingularity.net,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-trace-type-pollution-from-compaction-capturing.patch added to mm-unstable branch
Message-Id: <20250313213543.A4881C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: trace type pollution from compaction capturing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-trace-type-pollution-from-compaction-capturing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-trace-type-pollution-from-compaction-capturing.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: trace type pollution from compaction capturing
Date: Thu, 13 Mar 2025 17:05:33 -0400

When the page allocator places pages of a certain migratetype into blocks
of another type, it has lasting effects on the ability to compact and
defragment down the line.  For improving placement and compaction,
visibility into such events is crucial.

The most common case, allocator fallbacks, is already annotated, but
compaction capturing is also allowed to grab pages of a different type. 
Extend the tracepoint to cover this case.

Link: https://lkml.kernel.org/r/20250313210647.1314586-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-trace-type-pollution-from-compaction-capturing
+++ a/mm/page_alloc.c
@@ -614,6 +614,10 @@ compaction_capture(struct capture_contro
 	    capc->cc->migratetype != MIGRATE_MOVABLE)
 		return false;
 
+	if (migratetype != capc->cc->migratetype)
+		trace_mm_page_alloc_extfrag(page, capc->cc->order, order,
+					    capc->cc->migratetype, migratetype);
+
 	capc->page = page;
 	return true;
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-unshare-v2-only-charge-api-bits-again.patch
mm-memcontrol-move-stray-ratelimit-bits-to-v1.patch
mm-memcontrol-move-memsw-charge-callbacks-to-v1.patch
mm-page_alloc-dont-steal-single-pages-from-biggest-buddy.patch
mm-page_alloc-remove-remnants-of-unlocked-migratetype-updates.patch
mm-page_alloc-group-fallback-functions-together.patch
mm-swap_cgroup-remove-double-initialization-of-locals.patch
mm-compaction-push-watermark-into-compaction_suitable-callers.patch
mm-page_alloc-trace-type-pollution-from-compaction-capturing.patch
mm-page_alloc-defrag_mode.patch
mm-page_alloc-defrag_mode-kswapd-kcompactd-assistance.patch
mm-page_alloc-defrag_mode-kswapd-kcompactd-watermarks.patch

