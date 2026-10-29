Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793250803;
	b=taEDc4lbeIdKGRXbLaQzvUMcOPnYBq6IW5Y00ggDoZBrMdzOlJrC71rk5W2+kLPpM+tf
	 J+0gu0rJTGv5qPVvDkVRSnMAuLI3BlDXfeiA8jlGxoM581Lmj5XmAM1MQF9PDph8ES5Wy
	 jCeBWZNnj8fjBQawYWc0xh0+5L6c7t3JtcGx9NjA+K8gkYZp9suH6o2LVdyyqK60QIoqK
	 97d6TRNKseqGzVRPOiSwmqFdsiMUyB5wtmtAb4MT6SgW0aQhl+UajM9Mdb6fcfL4BO3fp
	 +4Vgb5m+g11XAqST7S7Gk4taQeCpLiZw9x9OOls2qq57AzujswwNBfeQYkZijUJ2Pug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793250803;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=R9xnMVQaYvc/wIq7HzNbGnxz22Hfq7AsQhC1RGuat7o=;
	b=fES77DkcZui7+P0BnwmUl3K1DAh4/5rEqrO1+RSQaes9q6lQm1owttzQFhvqqPuCHxks
	 JkVpZlHgiMrya+58JdidxZ9vFZN+pvAgzcfhpIqD6nHcoCZ3jYCTAJfg+cP4w/VkD3XNK
	 WGQbicgbbIRH05V9tQfUnO8jfH1YJy/E4DnmBNeclcAk75HMGk3hOabcwfycLxLqXRYta
	 IX2PBXg1UHWInr7YLmLLGN39SvNX1NF4JLdOhtwqI1loOGgGZ56yELrJgYwTob72dckDK
	 O5Rl+R3ybJu9l124JjdK0hK3M9Kt5uI6GTdhOZcm10UMWR5aU2Dz6OjdBtZsbZFt8eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rK26Dpfy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA77606A31A;
	Thu, 29 Oct 2026 05:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rK26Dpfy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054381F01825;
	Thu, 29 Oct 2026 05:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793250802;
	bh=R9xnMVQaYvc/wIq7HzNbGnxz22Hfq7AsQhC1RGuat7o=;
	h=Date:To:From:Subject;
	b=rK26DpfyYTVRcr3dCY3ZHXllJQieb+J4p4T8Sj336d/Vnh3yKgZRau9+sirsV3ebG
	 aar0HrUkifHQPYr0jEsFMn1yd1TlP1fJGJ56vrXNjXSTct+RbLWvLMSarEAcbwL8O1
	 BllJ4ZZbjSEz7R8jXPW8BBbTUIXg9uMnfZfjEr0c=
Date: Wed, 28 Oct 2026 22:13:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,
	sashiko-bot@kernel.org,mhocko@suse.com,mgorman@techsingularity.net,
	matt@readmodwrite.com,hch@lst.de,dipiets@amazon.it,dgc@kernel.org,
	brendan.jackman@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-do-not-give-all-non-blocking-requests-reserve-access.patch added to mm-hotfixes-unstable branch
Message-Id: <20261029051322.054381F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: page_alloc: do not give all non-blocking requests reserve access
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-do-not-give-all-non-blocking-requests-reserve-access.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-do-not-give-all-non-blocking-requests-reserve-access.patch

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
Cc: Vlastimil Babka <vbabka@kernel.org>
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

mm-page_alloc-do-not-give-all-non-blocking-requests-reserve-access.patch
mm-page_alloc-remove-alloc_non_block-from-alloc_reserves.patch

