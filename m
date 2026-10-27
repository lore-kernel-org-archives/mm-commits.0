Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793131533;
	b=0fRC8Z7Tn0lJfZzXcU/nkpu8OG5Xfi2Pkxy6AHprmutR+VL3GRkQrPqAd2WmyOWQvQLc
	 Rxrl8VMlEU+vYCGwqUsEO/ETjuG6iJEpKslekAaWoPqXz4FRMIslLeQ86tkdygTMJNb1z
	 JUsDQ0bFqmIxF0YGv621m7y/s4D5fRiDuEKfJhId0QdavIQSWpdO8z+c2dr02euRgDbNr
	 WGQP55XoeKa8l+Eju4gar6XkqlwMph1GebD/JMcyqcYQr6AaRSbJLenb35lr8Jxb1c4Wf
	 MnGmURzhEspwspKbcmvzn3P7jqbO9KsE1M3CJTB/DziU1B/NXsOz9Rua7tXUuiBd4EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793131533;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=cIBn8b0DAmTROSiZ+moLia/YE9Eetg9fBdYvl5sNg5Y=;
	b=yie/uz8Es397rjkJVst+OjYFdYL9cSlkedeLQaGtwSAb9bXV3ubFTCaHxC52xTBNbQLu
	 DgjyNEZKquYdVhmT4aalLQjSUU7/ZByCBJ6VFq57d/kX+gSeXKaZYYO2WZBy+MkRBVH7C
	 Jcz/6AdUSrgYkEMX37I7H43hwhWBp568M8hdKFNs52FxQH8aGkkLjyDVuxdjShpceB+EY
	 aWFdw7SmJhPIgDfcLUstsLHWRIdF6tly8WOzcRZtTOAp9KWJkv8jXe/14nK+nYe7N/j5c
	 4H5zApnAfjRYiyzrgTqA8m8WwnLcApXQ3/BZwcNz+rcfjmpCKStWSnZ7xpyFNhoqVuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0QxYDINi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA208606A31A;
	Tue, 27 Oct 2026 20:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0QxYDINi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DB11F01828;
	Tue, 27 Oct 2026 20:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793131532;
	bh=cIBn8b0DAmTROSiZ+moLia/YE9Eetg9fBdYvl5sNg5Y=;
	h=Date:To:From:Subject;
	b=0QxYDINiXF1zjS+h7KHyZaYaAmc1jyz33bNJDzvVPgqD7EQho9LXBOlt0Iph2A30l
	 Hu6QFcx+p5Vjd1IM0mw2plAsKr3w2xITTRIYyddFSHm9we6ZqXTbL/TZWkrthkHN+T
	 DZXe4L2dBQZffgkzyWSpvYHLbMcVDmH86+w9R5WY=
Date: Tue, 27 Oct 2026 13:05:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,
	shakeel.butt@linux.dev,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,
	hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,
	brendan.jackman@linux.dev,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_frag-refill-the-cache-for-large-fragments.patch added to mm-unstable branch
Message-Id: <20261027200532.42DB11F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: page_frag: refill the cache for large fragments
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_frag-refill-the-cache-for-large-fragments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_frag-refill-the-cache-for-large-fragments.patch

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
Subject: mm: page_frag: refill the cache for large fragments
Date: Tue, 27 Oct 2026 16:46:29 +0100

A fragment which is larger than PAGE_SIZE can only be served from the
32K page of a page_frag_cache. If memory is low and the cache had to fall
back to a single page, __page_frag_alloc_align() returns NULL and keeps
that page.

Since the offset counts up, this check comes first and is made whenever
the fragment does not fit behind nc->offset, no matter how big the page
of the cache is. So the cache is never refilled on behalf of a large
fragment: with fragsz = 10000 the first three allocations succeed, the
fourth one and all the following ones fail although memory is plentiful.
nc->offset does not move either, so this lasts until smaller fragments
have used up the rest of the page, which never happens if the cache has
no other user.

The nfp driver allocates its receive buffers with napi_alloc_frag() and
netdev_alloc_frag(). They are larger than a page with a jumbo MTU.

Only give up if the fragment does not fit into the page at all, which is
what the comment describes. The fourth allocation in the scenario above
with a 32k page will thus now proceed to refill the cache.

[vbabka@kernel.org: make the comment more obvious]
Link: https://lore.kernel.org/20261027-pgalloc-ai-hotfixes-v1-3-9c7d1aca801e@kernel.org
Fixes: 8218f62c9c9b ("mm: page_frag: use initial zero offset for page_frag_alloc_align()")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Assisted-by: LLM
Cc: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: <stable@vger.kernel.org>
---

 mm/page_frag_cache.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/mm/page_frag_cache.c~mm-page_frag-refill-the-cache-for-large-fragments
+++ a/mm/page_frag_cache.c
@@ -119,15 +119,20 @@ refill:
 	size = PAGE_SIZE << encoded_page_decode_order(encoded_page);
 	offset = __ALIGN_KERNEL_MASK(nc->offset, ~align_mask);
 	if (unlikely(offset + fragsz > size)) {
-		if (unlikely(fragsz > PAGE_SIZE)) {
+		if (unlikely(fragsz > size)) {
 			/*
-			 * The caller is trying to allocate a fragment
-			 * with fragsz > PAGE_SIZE but the cache isn't big
-			 * enough to satisfy the request, this may
-			 * happen in low memory conditions.
-			 * We don't release the cache page because
-			 * it could make memory pressure worse
-			 * so we simply return NULL here.
+			 * The caller is trying to allocate a fragment that's
+			 * larger than the whole cache page.
+			 *
+			 * Either fragsz is larger than PAGE_FRAG_CACHE_MAX_SIZE
+			 * so this cannot ever succeed.
+			 *
+			 * Or the refill has fallen back to order-0 due to a low
+			 * memory condition. Then we don't want to release the
+			 * cache page to attempt a new large-size refill because
+			 * it could make memory pressure worse.
+			 *
+			 * So in both cases we simply return NULL here.
 			 */
 			return NULL;
 		}
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

