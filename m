Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793131537;
	b=xelY7dO+cS6sZoiY3WXT2NhYcg5cSzMCkBojn0vYKd1ww6abmcJFjw0Ty3TG9I99weo7
	 WNys7z6LClLqaJTDcTwsBwJpvqZdXhRbWw9HXusI1IlUX2sbeN8DFgTR6a6XkZvXLzLov
	 4xJPqmqnx4/PJTL41bw0bTimuaUuvEqqoaQ9t8Hll2EKXI36zQwdHQ74ZNTDSXP/Qg5yj
	 hJqpYkJG2tYnyXBu7PNxdge8C6Mgj81HyfbrjnRNh2Zon35V5tMXoaUapXRVpGo4f9bfs
	 NBKuZxjeVnwvgU3fVk3adwqUrAwLoasc6DD9qf6omzihKUFuoBGY5xjZ0PjKXGslc9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793131537;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=smZHxwQLMO0VfGs7DNHVio37eG+DNgsUwaA5kyPFTXo=;
	b=uqmilfNYGDMEZ5F/hLTw15EqHUnoPckjIa7+UMTnZt0ikOabDtOWT+/HCXjWLCq9o4gc
	 z+nFPF5coM1zTgLhuNquGu6Nkxz2bdDlLUascyDalyNQtRbQyqogn3Rn2WhuoGv3njG9Y
	 QlL2iM/LeEY4Q/mTkF5XhV6M1w4GU69WLv7AGlRD5C/DUAamquIcRYkrNqZ2MBP396hdg
	 0rcLbZtWHvFwJRgPs31U64IF8fJwVidPxW8jJZw+BBOMbYm7tfYjgPc4pmID83SPph2vH
	 YVVBUjaEHP60Xoe1tpCZpRHb0ZEJcsyaAXMLzwfV7mubOrcAP9xFXyH7F2BhAZtpARA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cI7RFzuA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97B2606A31E;
	Tue, 27 Oct 2026 20:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cI7RFzuA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C661F01825;
	Tue, 27 Oct 2026 20:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793131536;
	bh=smZHxwQLMO0VfGs7DNHVio37eG+DNgsUwaA5kyPFTXo=;
	h=Date:To:From:Subject;
	b=cI7RFzuA1NbsdOxXoEGpTclkewRa+E60lE4V45nS3FZklGyNMw7KACnLkAM/IZsFm
	 NysGxFj0smbgTReQnb47KFZ7qy1cEPPSRW+f0aWXdKnQZ/J7bz+uHQnfZ7B3ulIgb9
	 BudS8G/Mdy2OuRgzo+U9GeoC/j/gp/aO+hHvs2ao=
Date: Tue, 27 Oct 2026 13:05:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,
	shakeel.butt@linux.dev,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,
	hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,
	brendan.jackman@linux.dev,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-pass-zone-pointer-to-trace_reclaim_retry_zone.patch added to mm-unstable branch
Message-Id: <20261027200536.25C661F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm, page_alloc: pass zone pointer to trace_reclaim_retry_zone
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-pass-zone-pointer-to-trace_reclaim_retry_zone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-pass-zone-pointer-to-trace_reclaim_retry_zone.patch

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
Subject: mm, page_alloc: pass zone pointer to trace_reclaim_retry_zone
Date: Tue, 27 Oct 2026 16:46:31 +0100

should_reclaim_retry() walks a zonelist and passes the zoneref pointer
to the reclaim_retry_zone tracepoint, which loads the zone from the
entry again to find the node.

Memory hotplug rebuilds the zonelists in place while allocations are
under way. When a zone in front of the zoneref entry has become empty,
the entries move up, and this one can be the end marker by the time the
tracepoint looks at it. zonelist_node_idx() then dereferences a NULL
zone. Short of that, the event can name another zone than the one its
numbers belong to.

Pass the zone pointer instead of the zoneref pointer.

Link: https://lore.kernel.org/20261027-pgalloc-ai-hotfixes-v1-5-9c7d1aca801e@kernel.org
Fixes: d379f01de095 ("oom, trace: add oom detection tracepoints")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Zi Yan <ziy@nvidia.com>
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

 include/trace/events/oom.h |    8 ++++----
 mm/page_alloc.c            |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/trace/events/oom.h~mm-page_alloc-pass-zone-pointer-to-trace_reclaim_retry_zone
+++ a/include/trace/events/oom.h
@@ -33,7 +33,7 @@ TRACE_EVENT(oom_score_adj_update,
 
 TRACE_EVENT(reclaim_retry_zone,
 
-	TP_PROTO(struct zoneref *zoneref,
+	TP_PROTO(struct zone *zone,
 		int order,
 		unsigned long reclaimable,
 		unsigned long available,
@@ -41,7 +41,7 @@ TRACE_EVENT(reclaim_retry_zone,
 		int no_progress_loops,
 		bool wmark_check),
 
-	TP_ARGS(zoneref, order, reclaimable, available, min_wmark, no_progress_loops, wmark_check),
+	TP_ARGS(zone, order, reclaimable, available, min_wmark, no_progress_loops, wmark_check),
 
 	TP_STRUCT__entry(
 		__field(	int, node)
@@ -55,8 +55,8 @@ TRACE_EVENT(reclaim_retry_zone,
 	),
 
 	TP_fast_assign(
-		__entry->node = zonelist_node_idx(zoneref);
-		__entry->zone_idx = zonelist_zone_idx(zoneref);
+		__entry->node = zone_to_nid(zone);
+		__entry->zone_idx = zone_idx(zone);
 		__entry->order = order;
 		__entry->reclaimable = reclaimable;
 		__entry->available = available;
--- a/mm/page_alloc.c~mm-page_alloc-pass-zone-pointer-to-trace_reclaim_retry_zone
+++ a/mm/page_alloc.c
@@ -4675,7 +4675,7 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 		 */
 		wmark = __zone_watermark_ok(zone, order, min_wmark,
 				ac->highest_zoneidx, alloc_flags, available);
-		trace_reclaim_retry_zone(z, order, reclaimable,
+		trace_reclaim_retry_zone(zone, order, reclaimable,
 				available, min_wmark, *no_progress_loops, wmark);
 		if (wmark) {
 			ret = true;
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

