Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672153;
	b=zJjaGi3iZWYw1eortFF0RwUOeYTfVlyHnApkkXTPFviiBb48h2ftqbOFY286WI2UwRsH
	 6ct63KOBNwTuBnnfa7wSq6fWfKU9rtj+FV41g3+pzfCcbQVS4RDBoIQvGiT/zdrsbZPfA
	 DSCYxbQMK6QfggydMoDx561Wd+3IiobXP6OB3ThIUibdtQ7eP4DaEA1zqu7bx6ItFwpi0
	 G69T+INzUzAxdVj6ogbBMAzws/1uDJUy4+vaP+1a1nRkVcLY6j33uWubq6lUTfbAFsIr+
	 ash9Vu74sVWX+PPoxEUKWCXFHiJcqYhSXF/Ak/lRxUuW+xqkuihq76Si1OANtWDhigA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672153;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=k1o7p4J7sgEdfTOjYlivc7GUu4SngMQukxvGtidKIQQ=;
	b=m55hIgTgPi62DmBzhGRxZ2jm50JYL2yxR+E5qecME9YPOXZHLeGTNFbNHWwF4UIqjEe9
	 0dpmnn8B/JgCa9JHhXX39s1jcfo2HtyWlDkwzsihI+5sglT8IM+xf946gPcH/NGYfpwIi
	 1hfYSAUneDx4ayB8z8wQS70cICTTGHG1ID4CtkE6aLV3EIvNNoYxBQHYBx7Z7S1wRrdVB
	 ohp/vLqzcSaG3fzu2WTUX9cyf8kp9qieSETFtgumHMP/A9NRxDHl2VgkCeM5DcAr0kQ0w
	 N9brk0jwhKjy7yuGUzIu8MtpDp2AOMbDYMITiTEP0G8GFpEevox6aZGEEsJUIS6nRSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1331iTxy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C86B606A330;
	Tue,  3 Nov 2026 02:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1331iTxy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2980A1F00919;
	Tue,  3 Nov 2026 02:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672153;
	bh=k1o7p4J7sgEdfTOjYlivc7GUu4SngMQukxvGtidKIQQ=;
	h=Date:To:From:Subject;
	b=1331iTxyaWyX8fySFdbukc+iwm3JSxSBZEJUfet3XD/CeoFyeBT/ZP9Ow4olx2th4
	 QDTot4MINLmd5hqQjy6ogEJwsm6tPOGh7jRV+Z82a0bPm3u/U6+sddWCcOBctq1Mu3
	 vIkyvsHpvHY5SqdhnIm1iUvuRmYMZK3rheeJlG6k=
Date: Mon, 02 Nov 2026 18:15:52 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,mhocko@suse.com,
	mgorman@techsingularity.net,matt@readmodwrite.com,hch@lst.de,
	dipiets@amazon.it,dgc@kernel.org,brendan.jackman@linux.dev,
	balbirs@nvidia.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-do-not-give-all-non-blocking-requests-reserve-access.patch removed from -mm tree
Message-Id: <20261103021553.2980A1F00919@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: page_alloc: do not give all non-blocking requests reserve access
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-do-not-give-all-non-blocking-requests-reserve-access.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: do not give all non-blocking requests reserve access
Date: Wed, 28 Oct 2026 13:15:53 -0400

Patch series "mm: page_alloc: fix reserve access for non-blocking
requests", v2.

Two fixes for how non-blocking allocations interact with the highatomic
reserve.  There are prerequisites for Salvatore's "mm/page_alloc: avoid
direct reclaim and compaction for costly __GFP_NORETRY allocations" [0].

Patch 1 narrows which requests may physically take highatomic pages,
patch 2 narrows which requests may count them in their watermark check.

Both are prerequisites for Salvatore's patch: it clears
__GFP_DIRECT_RECLAIM for costly __GFP_NORETRY requests, which turns every
large page cache folio allocation that reaches the slowpath into a
non-blocking one.  Without patch 1, those requests may fall back to the
highatomic freelists reserved for atomic requests.  Without patch 2, they
count the free highatomic pages in their watermark check while being
served from regular memory, so they can consume regular high-order blocks
below the min watermark by the size of the reserve.  GFP_NOWAIT requests
hit both paths today, so these are existing problems worthy of their own
stable backports; but Salvatore's patch would widen them significantly.

Patch 2 reproduction: a GFP_NOWAIT burst under memory pressure can drain
regular free memory to zero while the highatomic reserve sits idle. 
Measured on a 32G box with an anonymous working set, swap, and a full 290M
reserve, three synthetic bursts drove the 28G Normal zone's regular free
memory to 28M, 0.8M and 0.6M against a 60M min watermark.  Swapout failed
its swap table allocation inside reclaim, reclaim scanned 13M pages to
free 200k, and page faults stalled for tens to hundreds of milliseconds. 
With the fix the burst stops at the min watermark and nothing else
happens.  This was found in review and reproduced synthetically; it has
not been observed in production.

GFP_ATOMIC order-0 requests have a milder version of the same problem:
They are entitled to the reserve but are served regular memory first, so
the fix there has to change the watermark check and the freelist order
together.  Salvatore's change doesn't interact with this, though; fixing
that is left for a separate patch.


This patch (of 2):

281dd25c1a01 ("mm/page_alloc: let GFP_ATOMIC order-0 allocs access
highatomic reserves") accidentally gave all non-blocking allocation
requests access to highatomic reserves, which includes GFP_NOWAIT and
other sites clearing __GFP_DIRECT_RECLAIM.

While this improved atomic request success rate, it's unintentionally
broad and can actually worsen highatomic requests by squandering the
reserves on requests that don't need it.

There are concurrent efforts to clear __GFP_DIRECT_RECLAIM altogether
for costly order __GFP_NORETRY requests, which would then also fall
into this exemption and deplete reserves even faster.

What GFP_ATOMIC has over the others is __GFP_HIGH, which
alloc_flags_slowpath() translates to ALLOC_MIN_RESERVE.

Narrow the exemption to contexts that have both ALLOC_NON_BLOCK |
ALLOC_MIN_RESERVE.

Link: https://lore.kernel.org/20261001082152.2879289-1-dipiets@amazon.it [0]
Link: https://lore.kernel.org/linux-mm/arFBWvzXPYrKuIYi@cmpxchg.org/ [1]
Link: https://lore.kernel.org/linux-mm/20261001082152.2879289-1-dipiets@amazon.it/ [2]
Link: https://lore.kernel.org/20261028171719.2043421-1-hannes@cmpxchg.org
Link: https://lore.kernel.org/20261028171719.2043421-2-hannes@cmpxchg.org
Fixes: 281dd25c1a01 ("mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260904115629.3993331-1-dipiets@amazon.it
Acked-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Salvatore Dipietro <dipiets@amazon.it>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dgc@kernel.org>
Cc: Matt Fleming <matt@readmodwrite.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
---

 mm/page_alloc.c |    4 +++-
 mm/page_alloc.h |    3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-do-not-give-all-non-blocking-requests-reserve-access
+++ a/mm/page_alloc.c
@@ -3241,7 +3241,9 @@ struct page *rmqueue_buddy(struct zone *
 			 * reserves as failing now is worse than failing a
 			 * high-order atomic allocation in the future.
 			 */
-			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
+			if (!page &&
+			    ((alloc_flags & ALLOC_OOM) ||
+			     (alloc_flags & ALLOC_MASK_ATOMIC) == ALLOC_MASK_ATOMIC))
 				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 
 			if (!page) {
--- a/mm/page_alloc.h~mm-page_alloc-do-not-give-all-non-blocking-requests-reserve-access
+++ a/mm/page_alloc.h
@@ -60,6 +60,9 @@
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
+/* Flags that mean GFP_ATOMIC */
+#define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)
+
 /*
  * Structure for holding the mostly immutable allocation parameters passed
  * between functions involved in allocations, including the alloc_pages*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


