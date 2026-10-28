Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793156802;
	b=IjW65jqQaGUzYcMHfElKEpeRyF+7NgYm7qiJ7Ao806TQ4ycvkgJMUaKt1N1V5ryBRyK8
	 sfr/ZuDq/nkk6KZFju67raTRlADG+W1cCD5rbf39yJSzenaJC1C4eBiuT5HK9IG9KwY6X
	 TJjb8NvRxCVHfPkWw3Pvkxuk/TBDifMlcpfs1Gwbj3PHLNvS5LbOPmQY4cIsxWwKevXES
	 aULbO3I9lOYGqJPzC26GxJXMf+Bsw7Od9lFRekQ2u2WQfY96Ode2Jn7aGcegusYqFw0aO
	 Qnx42x/XSkHtLW9iwyZKB4vNp0bnjI8dm2mlDwZOdqLaGJHfSHbhK7qmF6ERx3cmw3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793156802;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=11lcN6RE1tbNLJZFeXECRXq4SIB89GmBk7LD4PWNOyY=;
	b=qeDrgSpfy0nT282gISFJMgCXcCc23HUarWSbUfcY+cfkRue7fg/ua/KbjK9f42gjBwWT
	 QT3OaWpf/9+cHQoJTDKVRJ/l1pxyhCRD7p1quQxBAUiNaO3Af54IGhyl987c957AbPjCJ
	 +kD7YcwjVjYg9dOvuCJkvoYqcFlVSi8za9dIYkQxhoG7Cp7caqh2vBTAQLhVnO4egz7OS
	 Xnr8DCW1IfEs8FLfBLUKRwhvRA7uqyZ8HPddZ22skLTiv5knIx5rF88tU8v89m23efOlC
	 xhN5ULpy7Byp6fNaozsFaP6whxm2PxX0GQVcqP6Yltlawwi9HW7WpYWPr7sTswf/H3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qiLePsCA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD39606A31A
	for <mm-commits@vger.kernel.org>; Wed, 28 Oct 2026 03:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qiLePsCA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E701F01828;
	Wed, 28 Oct 2026 03:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793156801;
	bh=11lcN6RE1tbNLJZFeXECRXq4SIB89GmBk7LD4PWNOyY=;
	h=Date:To:From:Subject;
	b=qiLePsCAdto2DuXpwsIByNTfC5uzAEK8j7tbyTRuu8l9QZirLhMGihOHG+PeATKdg
	 VEM3itbT4F1EDWd29wE6TnCZThsp2OQSbB3eYDX47fz8SvPdoCy8uNo8aUAzq4ZpQB
	 +lQTQg4RWKu3sn2w9+2h+aCgWO126HXObXww7dcQ=
Date: Tue, 27 Oct 2026 20:06:41 -0700
To: mm-commits@vger.kernel.org,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_alloc-pass-zone-pointer-to-trace_reclaim_retry_zone.patch removed from -mm tree
Message-Id: <20261028030641.A5E701F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm, page_alloc: pass zone pointer to trace_reclaim_retry_zone
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-pass-zone-pointer-to-trace_reclaim_retry_zone.patch

This patch was dropped because an updated version will be issued

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

mm-compaction-trust-zone-contiguous-only-in-the-span.patch
mm-page_isolation-do-not-take-slab-pages-for-free.patch
mm-memory_hotplug-resize-zones-under-their-seqlock.patch
mm-page_alloc-check-pageblock-pfns-under-span-seqlock.patch
mm-filemap-dont-lose-a-folio-lock-wakeup-to-a-signal.patch

