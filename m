Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793131529;
	b=qpQ25rswg0MVrHqcmmOXDePT5uPhKaAr1Lr1kw6fte/TX6nihMAQSmOlBV2A6Selm7X5
	 Xeea1LuB6nYLkxQYUNOBtx+cUsb/ilmSuugHdkfthHKZa20KrUyG+jhp4PGTOg6nMdbHh
	 KMKGB6tKbMsKttobnFFD1SogEEnJInjRdul5ptkksTmG2mzpMJIK6pd0Uue+k26AVhHqC
	 Pq5GzeyeZqwcRArURgoGrytDsQxfwD0M6bZE8SmLbon90bSzdL8yi29Yj3WuOJCuTDKLf
	 A8pFF9XPlJYJxiRe49A1N9LaDvZyhP1poYgnfAjPjJWHqGcaOVZruMOCRzdODqg/C8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793131529;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=hl8VACHsCdaZbuFfJ+7MBs8/f6/ByItQtzNveqTgGMw=;
	b=vAdYdvZfNujvAH8FWn+Slg3cTf0GjFkG2UfCFP0U7YxorKiGMZKX6PflYHyEnEPPzdwU
	 m1d/BVLcxALxHABuM2jmY8zIBbeukGQjx9acvwyeaTA1HRiTkusPEbe6ZWidYC20KvDX0
	 5m/aB2GnimYLX/WD+hMKmChkWVK+leWMLPCu6x/ggb5X63lSwBSRZrWurHtsqtjUG3s2x
	 sNxlh4QV9hpwo0qGws7Yl1f3oegO/USqaUn18qvEQuF9iUl/JJ5+FvEhoYFng2h4RcOB9
	 Z/mFW3fJrquZBKzxddsjMbOF8papPiD9jlpODzcNs1J8WS/XS374JO0L2ZuhXWJC2iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=N1PNeRKM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A26606A324;
	Tue, 27 Oct 2026 20:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=N1PNeRKM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674291F01828;
	Tue, 27 Oct 2026 20:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793131528;
	bh=hl8VACHsCdaZbuFfJ+7MBs8/f6/ByItQtzNveqTgGMw=;
	h=Date:To:From:Subject;
	b=N1PNeRKMA/tnCGvoC18cvBI9xDpQgA6jj2w+pDY2C2UKunhPv5TeYaC9ntTEmLa/3
	 oOmdpRs8H7JiOEWJOXLti/kZQ+3JZQqeOBq+O9dJswj7GlD2gRxj3ypKXEhE74LlQs
	 ulzFwE4lxbQSBTGc94mv5z5jkJeXUoX6BlEY68g4=
Date: Tue, 27 Oct 2026 13:05:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,
	shakeel.butt@linux.dev,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,
	hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,
	brendan.jackman@linux.dev,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-dont-undo-a-racing-start_isolate_page_range.patch added to mm-unstable branch
Message-Id: <20261027200528.674291F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/page_alloc: don't undo a racing start_isolate_page_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-dont-undo-a-racing-start_isolate_page_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-dont-undo-a-racing-start_isolate_page_range.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm/page_alloc: don't undo a racing start_isolate_page_range()
Date: Tue, 27 Oct 2026 16:46:27 +0100

Patch series "mm, page_alloc: several stable fixes", v1.

A bunch of fixes from Josef, filtered for page allocator by David.

They seem worthy of Cc: stable to me, but IMHO don't need to be sent
urgently as the issues mostly need root actions (memory offline) to
trigger and/or CONFIG_DEBUG_VM to result in a denial of service.

I have tweaked some commit logs and a comment in one case.


This patch (of 9):

start_isolate_page_range() fails with -EBUSY if one of the pageblocks is
already isolated, i.e. if somebody else is working on it. It restores
the pageblocks which it has isolated itself before it returns, as its
kernel-doc says:

  We then clean up by restoring the migration type on pageblocks we may
  have modified and return -EBUSY to caller. This prevents two threads
  from simultaneously working on overlapping ranges.

alloc_contig_frozen_range() nevertheless calls undo_isolate_page_range()
for the whole range in this case, which clears every isolated pageblock
it finds. The only ones left at this point belong to the other user of
the range:

  CPU0 offline_pages()                CPU1 alloc_contig_frozen_range()
  start_isolate_page_range(A)
    pageblock X: isolated
  migrate ...
                                      start_isolate_page_range(B)
                                        X is isolated: -EBUSY
                                        (own pageblocks restored)
                                      undo_isolate_page_range(B)
                                        X: not isolated any more
  test_pages_isolated(A): -EBUSY
  (again and again)

offline_pages() repeats the migration and test_pages_isolated() until the
latter succeeds, which is now impossible and the task spins until it gets
a signal, while the free pages of X are handed out by the allocator again.

If X is released after the last test_pages_isolated(),
__offline_isolated_pages() takes pages which are accounted as free off
the free lists as MIGRATE_ISOLATE. Thus NR_FREE_PAGES stays too high, or
hits BUG_ON(!PageBuddy(page)) if one of them has been allocated.

For another alloc_contig_frozen_range() or cma_alloc() the result is a
spurious -EBUSY.

Return the error, like the function did until it was reworked.

Link: https://lore.kernel.org/20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org
Link: https://lore.kernel.org/20261027-pgalloc-ai-hotfixes-v1-1-9c7d1aca801e@kernel.org
Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Assisted-by: LLM
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-dont-undo-a-racing-start_isolate_page_range
+++ a/mm/page_alloc.c
@@ -7329,7 +7329,7 @@ int alloc_contig_frozen_range_noprof(uns
 
 	ret = start_isolate_page_range(start, end, mode);
 	if (ret)
-		goto done;
+		return ret;
 
 	drain_all_pages(cc.zone);
 
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-page_alloc-dont-undo-a-racing-start_isolate_page_range.patch
mm-page_alloc-clear-private-of-deferred-free-pages.patch
mm-page_frag-refill-the-cache-for-large-fragments.patch
mm-page_alloc-keep-the-pagesets-of-an-empty-zone.patch
mm-page_alloc-pass-zone-pointer-to-trace_reclaim_retry_zone.patch
mm-compaction-trust-zone-contiguous-only-in-the-span.patch
mm-page_isolation-do-not-take-slab-pages-for-free.patch
mm-memory_hotplug-resize-zones-under-their-seqlock.patch
mm-page_alloc-check-pageblock-pfns-under-span-seqlock.patch

