Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBD18634C
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 00:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782347340; cv=none; b=kaaKA3s42iTujVDw2uB0R53vimqF9b598YPi6NTbJA2hs1rUvlCHgTp0T1NJq0/yxJ/cUyO2karf93IXa2Qqy7B21MDFskhXXHMhZwch/8HJCX21wTZsv81H//m3Vj6rNpq3LUzEugQeaXfX13gP/dJH2yKmasTzPwSTZqY/JLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782347340; c=relaxed/simple;
	bh=Y+v+rsSqJn23p5eEHgT+daxeOb1uvewSE9jgiGU/Izk=;
	h=Date:To:From:Subject:Message-Id; b=HolFjsiB2GymOi9qw2nK+h1FQR8kdLjeBfGVl37DwjuMRcMY6XrGH8at+jGG/KAySXcDn8LBEZq5luN69u7Bhmfl8aEGg410EGKGVf+4XItkBrQ4xOF2+Gokg6kgFSB7ziTbonT5+mBo6OEI/X1MvPQHyLZ07NtQdYEPdTAeFwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XgS8nFH0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XgS8nFH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493C11F000E9;
	Thu, 25 Jun 2026 00:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782347339;
	bh=BX8amXNWhuB0HGKBbJbsSMcAQs/zqPmwlexyYzkVjvI=;
	h=Date:To:From:Subject;
	b=XgS8nFH0+IcyobHcrOTt4in9NhQF5Z6w7KOgoAixv8yiDZUom4JSL70wR/pH9OK4b
	 OrG/5ffVBgIvwfGVXo8ZgV56A3xXLR9dgM/6BLxVnWsaukUtX6zID81T7sQ4QwpGhw
	 sbG8uOvWJx7XQjVlPWEawn91weTv+n/TXsnIqdpk=
Date: Wed, 24 Jun 2026 17:28:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,fvdl@google.com,david@kernel.org,jp.kobryn@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-use-existing-highatomic-reserves-on-the-buddy-fastpath.patch added to mm-hotfixes-unstable branch
Message-Id: <20260625002859.493C11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: use existing highatomic reserves on the buddy fastpath
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-use-existing-highatomic-reserves-on-the-buddy-fastpath.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-use-existing-highatomic-reserves-on-the-buddy-fastpath.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: JP Kobryn <jp.kobryn@linux.dev>
Subject: mm/page_alloc: use existing highatomic reserves on the buddy fastpath
Date: Mon, 22 Jun 2026 17:46:00 -0700

ALLOC_HIGHATOMIC currently provides both access to MIGRATE_HIGHATOMIC free
pages and permission to create new highatomic pageblock reserves.  This
makes it unsuitable for the fastpath.

However, the fastpath can reach rmqueue_buddy() while MIGRATE_HIGHATOMIC
reserves have free pages available.  In this situation, the allocation can
fall back to other migratetypes without trying those reserves first.

Allow high-priority non-blocking allocations to use existing
MIGRATE_HIGHATOMIC reserves on the buddy fastpath without growing them. 
First tighten the criteria for reserving pageblocks so that growth may
only occur in the slowpath.  Then allow fastpath usage by enabling
ALLOC_HIGHATOMIC when the GFP mask describes a non-blocking high-priority
allocation.  This logic has been factored out from gfp_to_alloc_flags() to
a new function gfp_to_alloc_flags_nonblocking().

A UDP receive workload was run with free MIGRATE_HIGHATOMIC pageblocks
available in the target zone.  Before this patch, the workload did not
consume these blocks.  With this patch, eligible order-1 allocations
reaching the buddy path consumed existing MIGRATE_HIGHATOMIC pageblocks,
with no highatomic misses observed.  The workload did not grow highatomic
reserves and NAPI page-frag allocations remained healthy with no failures
or order-0 fallbacks.

Link: https://lore.kernel.org/20260623004600.113347-1-jp.kobryn@linux.dev
Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-existing-highatomic-reserves-on-the-buddy-fastpath
+++ a/mm/page_alloc.c
@@ -3247,10 +3247,11 @@ struct page *rmqueue_buddy(struct zone *
 	} while (check_new_pages(page, order));
 
 	/*
-	 * If this is a high-order atomic allocation then check
-	 * if the pageblock should be reserved for the future
+	 * Slowpath (precarious) high-atomic allocations may reserve
+	 * a pageblock for future use.
 	 */
-	if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
+	if (unlikely((alloc_flags & ALLOC_HIGHATOMIC) &&
+			((alloc_flags & ALLOC_WMARK_MASK) == ALLOC_WMARK_MIN)))
 		reserve_highatomic_pageblock(page, order, zone);
 
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -4474,6 +4475,29 @@ static void wake_all_kswapds(unsigned in
 }
 
 static inline unsigned int
+gfp_to_alloc_flags_nonblocking(gfp_t gfp_mask, unsigned int order)
+{
+	unsigned int alloc_flags = 0;
+
+	if (gfp_mask & __GFP_DIRECT_RECLAIM)
+		return 0;
+
+	/*
+	 * Not worth trying to allocate harder for __GFP_NOMEMALLOC even
+	 * if it can't schedule.
+	 */
+	if (gfp_mask & __GFP_NOMEMALLOC)
+		return 0;
+
+	alloc_flags |= ALLOC_NON_BLOCK;
+
+	if (order > 0 && (gfp_mask & __GFP_HIGH))
+		alloc_flags |= ALLOC_HIGHATOMIC;
+
+	return alloc_flags;
+}
+
+static inline unsigned int
 gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 {
 	unsigned int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
@@ -4495,18 +4519,9 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsig
 	alloc_flags |= (__force int)
 		(gfp_mask & (__GFP_HIGH | __GFP_KSWAPD_RECLAIM));
 
-	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
-		/*
-		 * Not worth trying to allocate harder for __GFP_NOMEMALLOC even
-		 * if it can't schedule.
-		 */
-		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
-			alloc_flags |= ALLOC_NON_BLOCK;
-
-			if (order > 0 && (alloc_flags & ALLOC_MIN_RESERVE))
-				alloc_flags |= ALLOC_HIGHATOMIC;
-		}
+	alloc_flags |= gfp_to_alloc_flags_nonblocking(gfp_mask, order);
 
+	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
 		/*
 		 * Ignore cpuset mems for non-blocking __GFP_HIGH (probably
 		 * GFP_ATOMIC) rather than fail, see the comment for
@@ -5299,6 +5314,7 @@ struct page *__alloc_frozen_pages_noprof
 	 * memory until all local zones are considered.
 	 */
 	alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
+	alloc_flags |= gfp_to_alloc_flags_nonblocking(gfp, order) & ALLOC_HIGHATOMIC;
 
 	/* First allocation attempt */
 	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
_

Patches currently in -mm which might be from jp.kobryn@linux.dev are

mm-page_alloc-use-existing-highatomic-reserves-on-the-buddy-fastpath.patch

