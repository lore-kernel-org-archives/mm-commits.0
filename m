Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793156800;
	b=DRoniS8jzLtOWhPfKfinUGix2KD439vyGdAHyyogCvwY86/HP8TN71/6d7jyYl4IJGLM
	 NtVqLiyc7t1VvxEdbbXB6vHxLJviYQB3SHixks4ngrWm4hD6Y2PrM65gPsgu3qdUUE9IJ
	 ScjOXS25Kjye92AcR4eklKVE5cs+SfRvZahldUxggg+23PIkgWwhmIfysa5fJeTJWYUA7
	 TVCG/btSe65WHI59c8EdJ06xmQsr2xNj3o64+pvRRmMuTJtNF4Z9KiCSo9ff3H4AbtGY9
	 caG3C1ZI9ZXR86n5xEyh7tG/3sYcSkKkHE9GbHhTVaKhr0o48gisNBuqSWnuQESIjPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793156800;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ifkSuQflIqHJ+OWVlTOcgo/wo4Hpobi9iK6pGmQoMSw=;
	b=Z7OVjjsuQlMlqj/wyNr0N+X/SfjkmZ/vEHDLAVXpM9/BQuZN8GFV8evRBjVWOlUd+2FI
	 bohgoc/BmwAb3Dp941EzBu6igSmmO9FWJtJQ6rLUjTA1wlAGRRgro44H9pPSfjV6DayG8
	 KUTR//tupjOeepwdGbJHschqQefxv7nflX5+Nj0tUT4Q9gjO2Nx/O2H17Ju5XZ+XPItm1
	 t2UKPYN6/XBIHEl25LtFpnIaMjoyODeMbA/FIOpxKfLw8FKozUMjheEKphra1+KGuAQI7
	 +R5ckZAPoasmwCvYcTbB6KXNxg2s0LIUmPp7GVKMMxzMU0PuCXJQqfT/g36WBRY4+mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=r8qoob6x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0EE606A321
	for <mm-commits@vger.kernel.org>; Wed, 28 Oct 2026 03:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=r8qoob6x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9202C1F01828;
	Wed, 28 Oct 2026 03:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793156799;
	bh=ifkSuQflIqHJ+OWVlTOcgo/wo4Hpobi9iK6pGmQoMSw=;
	h=Date:To:From:Subject;
	b=r8qoob6xAelRnP4E5HTVeQqrpzQohhNCevU7wgmf36F/JCuisSKNE9pWrmNjhlg6H
	 4xiSBD/S4fx5iWnCj3dnWjVTIKqQzizrMVa7K6iO2naPPcLRTPut8F4Ic7WoRUV02m
	 p0CsbjtsQkxqJkT/wGpE9v9/MMYzxKRNKSOToUt8=
Date: Tue, 27 Oct 2026 20:06:39 -0700
To: mm-commits@vger.kernel.org,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_frag-refill-the-cache-for-large-fragments.patch removed from -mm tree
Message-Id: <20261028030639.9202C1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: page_frag: refill the cache for large fragments
has been removed from the -mm tree.  Its filename was
     mm-page_frag-refill-the-cache-for-large-fragments.patch

This patch was dropped because an updated version will be issued

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

mm-page_alloc-keep-the-pagesets-of-an-empty-zone.patch
mm-page_alloc-pass-zone-pointer-to-trace_reclaim_retry_zone.patch
mm-compaction-trust-zone-contiguous-only-in-the-span.patch
mm-page_isolation-do-not-take-slab-pages-for-free.patch
mm-memory_hotplug-resize-zones-under-their-seqlock.patch
mm-page_alloc-check-pageblock-pfns-under-span-seqlock.patch
mm-filemap-dont-lose-a-folio-lock-wakeup-to-a-signal.patch

