Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC74D25D528
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 02:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756260835; cv=none; b=Lm7xYy+PIs2ZYefi8qG5rcGOtFbaojUlE4p0JnExs+Q4uUe2P9PcmVNtkoNLFq59KT5HfQrcna16S6nc/4JhgLvVtjxB1zTe5spUaU4OboxvW3SP4wM7FfmOLQNQ6eqxRuY//WwGycTCwaV42P5VruSW+mQPRGQSufTePYMQpvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756260835; c=relaxed/simple;
	bh=q7vs6/H+MwgABuAmZniibJzhvd9DQCiJWpJHmEAInUs=;
	h=Date:To:From:Subject:Message-Id; b=GEi3f+xIK/i18JTnU5tW7AoqQfpUz30APj2HfMGF89qPYk1aN5MaYNatLPs9firfAoycg4BeKVucG2LXWiDnxQsxRo6RAK/9GUMW7hgWNE8QXmEsksXAHX7dZaWwVsDwHGeaINzJ39MHtefAoq7q6SA3SeCtQaYMNfboaX8xcDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rRgETg9k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rRgETg9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE9DC4CEF1;
	Wed, 27 Aug 2025 02:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756260834;
	bh=q7vs6/H+MwgABuAmZniibJzhvd9DQCiJWpJHmEAInUs=;
	h=Date:To:From:Subject:From;
	b=rRgETg9kwoTnH2UEhK7FVG873+1PxexypAXgRZThYxSpX6bn0uPJmJZs/TDiemFME
	 En3hhr1OxUQm+reYq+jRXiwDVnmwO8LISkOgNFFx87UAtMkByP/dpTWwZO7bsgLy1H
	 KRsrKNbSknx24IiKYOC1N2cgWRBBkuGUDzfnGDiM=
Date: Tue, 26 Aug 2025 19:13:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,hannes@cmpxchg.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-harmonize-should_compact_retry-type.patch added to mm-new branch
Message-Id: <20250827021354.1BE9DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: Harmonize should_compact_retry() type
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-harmonize-should_compact_retry-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-harmonize-should_compact_retry-type.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: Harmonize should_compact_retry() type
Date: Tue, 26 Aug 2025 14:06:54 +0000

Currently order is signed in one version of the function and unsigned in
the other. Tidy that up.

In page_alloc.c, order is unsigned in the vast majority of cases. But,
there is a cluster of exceptions in compaction-related code (probably
stemming from the fact that compact_control.order is signed). So, prefer
local consistency and make this one signed too.

Link: https://lkml.kernel.org/r/20250826-cleanup-should_compact_retry-v1-1-d2ca89727fcf@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-harmonize-should_compact_retry-type
+++ a/mm/page_alloc.c
@@ -4182,7 +4182,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 }
 
 static inline bool
-should_compact_retry(struct alloc_context *ac, unsigned int order, int alloc_flags,
+should_compact_retry(struct alloc_context *ac, int order, int alloc_flags,
 		     enum compact_result compact_result,
 		     enum compact_priority *compact_priority,
 		     int *compaction_retries)
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-remove-is_migrate_highatomic.patch
mm-page_alloc-harmonize-should_compact_retry-type.patch

