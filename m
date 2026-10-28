Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793156806;
	b=HT9iEmKBCW7bptsroCgzfMu0qUm16zVvY4JK3G2VcYzYu8NC+xSgAu91Lqn9CyGHJmnM
	 /O/twZo8SiLmvB4ND4s0SOKXDbn/eGpE+49lozhVV2+OjJG0bkt2uKga8A1v4YCFs4yB2
	 8HAlNnOqEuMCEUumK6uVmDjSHIsxhfMXs1CAL72u62kdAgCW3ZtA1zl2DZcQ6YChH5NVP
	 +0JH5WL+B7PbT5v69No9YLhoYg6BA+oTV0jv36VMdOyVBLnwB2mqn+IIOLD8kbZ8LkJBL
	 DBZGrHllZuiguohvfTuSR0pWAPd/fQMjsR+XptuU4uXkLN+dfV4yDRIouPbN+ILuWaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793156806;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=8ndto25sjxPlRVExPGqXVTaqSyAu108p1PKPHvuW36M=;
	b=ZZW2M1rzd7+0BDme0TPPZ0Kf8vhdr1YXXEd7Ym6afgf8WC6Dq/xDYb0mnt4n5nhFyUaj
	 Dx+xxbd25fqSDcB4Uy6JwkrvdV7NJHffadzSES/yZQp/7geJ4PflPAhYcmveDWwNket4O
	 BYS5zqXOQdi+RSuXpZnC8QsdMMtBJMeiC9wjh7+Zhr7Ln5hKyLG78TfKR3BXYP12S8G7w
	 OmxeAd7FSo60Ml4frPL2XlP/BWHFxlgRFbf6xdNOTBQP+bm7yJxdpr4mCPRSOPILHaxsC
	 3knZW14RzSKnfdw4iUSjLvFq/T7woV9g9+sVOwDpaDYm+wCFLNeiI6t5JJxaJDRqgyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iBbXOUuY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C41C606A31F
	for <mm-commits@vger.kernel.org>; Wed, 28 Oct 2026 03:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iBbXOUuY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A141F01828;
	Wed, 28 Oct 2026 03:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793156805;
	bh=8ndto25sjxPlRVExPGqXVTaqSyAu108p1PKPHvuW36M=;
	h=Date:To:From:Subject;
	b=iBbXOUuYg58PANlb/uQ9il13/wLKCdb/cQAOPCOMvXlAKAmvSgYOF2hQGNcQbJ+gB
	 VgWiSxCXpL3WRZCMxbNcoK5lucLgxJkKZ8Bx/X8S/4FR6ncG4/dv+XqUwrc+Ep6/g5
	 6i1KkHpS/MQihuCBr+GSO1KRIoX67Ojz8ewwWan0=
Date: Tue, 27 Oct 2026 20:06:45 -0700
To: mm-commits@vger.kernel.org,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_alloc-check-pageblock-pfns-under-span-seqlock.patch removed from -mm tree
Message-Id: <20261028030645.D3A141F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/page_alloc: check pageblock pfns under span seqlock
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-check-pageblock-pfns-under-span-seqlock.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm/page_alloc: check pageblock pfns under span seqlock
Date: Tue, 27 Oct 2026 16:46:35 +0100

Whenever the flags of a pageblock are read or written, a kernel with
CONFIG_DEBUG_VM makes sure that the pfn lies within the zone of the page.
Unlike bad_range(), that check reads zone->zone_start_pfn and
zone->spanned_pages without zone->span_seqlock.

Memory hotplug changes the two fields one after the other. If the lower
end of a zone moves, the zone seems to end before its last pages in
between. A page of that part which is freed at that moment, on another
CPU, ends in

  page dumped because: VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn))
  kernel BUG at mm/page_alloc.c:372!
   free_unref_folios+0x55e/0xed0
   folios_put_refs+0x2b5/0x530

Read the span in a read section of the seqlock.

Link: https://lore.kernel.org/20261027-pgalloc-ai-hotfixes-v1-9-9c7d1aca801e@kernel.org
Fixes: 86051ca5eaf5 ("mm: fix usemap initialization")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: <stable@vger.kernel.org>
---

 mm/page_alloc.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-check-pageblock-pfns-under-span-seqlock
+++ a/mm/page_alloc.c
@@ -357,6 +357,21 @@ static __always_inline bool is_standalon
 	return pb_bit >= PB_compact_skip && pb_bit < __NR_PAGEBLOCK_BITS;
 }
 
+/* Memory hotplug can resize the zone while we look at its span */
+static bool __maybe_unused zone_spans_pfn_stable(struct zone *zone,
+						 unsigned long pfn)
+{
+	unsigned int seq;
+	bool ret;
+
+	do {
+		seq = zone_span_seqbegin(zone);
+		ret = zone_spans_pfn(zone, pfn);
+	} while (zone_span_seqretry(zone, seq));
+
+	return ret;
+}
+
 static __always_inline void
 get_pfnblock_bitmap_bitidx(const struct page *page, unsigned long pfn,
 			   unsigned long **bitmap_word, unsigned long *bitidx)
@@ -370,7 +385,7 @@ get_pfnblock_bitmap_bitidx(const struct
 	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
 #endif
 	BUILD_BUG_ON(__MIGRATE_TYPE_END > PAGEBLOCK_MIGRATETYPE_MASK);
-	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
+	VM_BUG_ON_PAGE(!zone_spans_pfn_stable(page_zone(page), pfn), page);
 
 	bitmap = get_pageblock_bitmap(page, pfn);
 	*bitidx = pfn_to_bitidx(page, pfn);
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-filemap-dont-lose-a-folio-lock-wakeup-to-a-signal.patch

