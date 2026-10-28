Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793156803;
	b=sR6olU5l9G4breLW9oNpMXWRtq1qA9TYGWYXEFTTjPAYHXeK8CdN1Exz+YYG2OAmbw0u
	 3B2p6WFB2DfsXdgvvhld9kIdrO//E3v1dX6m/ricjMcgxQ9yT+vdvM/sRtA7tmDRMMs+3
	 lSmRipNeeuy5y9iKwAjCSs08a9pxsdBADReZOO/qn+keLQSruhLk6jQNaetdFAYj6lb09
	 ZlAN6qm1ZvNinvk0rCLQjAi0ymo++NyCLiGokCmllNXdD1hLCETAX6Ahjx0RghAu52B9j
	 IV5bFq0/zTFiR7IeTKF1hWf7Uzx6e/Bup2hmR9hgu+4Jy7F1aXD+2d4YvfvIdJtMiig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793156803;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ISbEAlZqfbnlqABt1qG/W1vgfZ8UGG8e1O39/wlEhaY=;
	b=v0kxpp7ddwHTCnVdw0+vlINVwXarZcfxHad70X2+E/EBWjrJUlEle14RbEy66uUcdam1
	 tGCCi0Z/PB5jH90zzzP05JH0dmokoPdJlbsOURZE1MUPm/+AG5UFCcX6aednRUO1cv9JO
	 GwEMNE8iyWdpb0v1jFPYyjMdtFufn8fgEy5QYSd1VzznXLD7HRIr7NCnTnphBHW/v3HC2
	 3L/1ARrNuovxfp/oHp10gRl+CxaKOi/sVon6Uoiz52o7mn3wRuECdVDyPwwk8JShDyIu9
	 hupK2UUjq/at9FXsmoHMNEZnWCNllD0LyEI1puVzSm3MxlUIWxOD/adD5QODHKCRoJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=y3LEG6kA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339C5606A31A
	for <mm-commits@vger.kernel.org>; Wed, 28 Oct 2026 03:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=y3LEG6kA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B321F1F01829;
	Wed, 28 Oct 2026 03:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793156802;
	bh=ISbEAlZqfbnlqABt1qG/W1vgfZ8UGG8e1O39/wlEhaY=;
	h=Date:To:From:Subject;
	b=y3LEG6kAWp0En6uQyPB/SuIJtidYAKuSma8kuXQyLZqIFegNDxJAoIxYbD00vOdqT
	 AARTtSo0/IMFU//FqKhbWLhvwqZrDCzdxKebSK592TWnGWRiAZ3ud0hiUWBHQKaSlj
	 TeNdW/P7aEdVdYS+Nebk+JBC14zdPI/+jADkcbdg=
Date: Tue, 27 Oct 2026 20:06:42 -0700
To: mm-commits@vger.kernel.org,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-compaction-trust-zone-contiguous-only-in-the-span.patch removed from -mm tree
Message-Id: <20261028030642.B321F1F01829@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/compaction: trust zone->contiguous only in the span
has been removed from the -mm tree.  Its filename was
     mm-compaction-trust-zone-contiguous-only-in-the-span.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm/compaction: trust zone->contiguous only in the span
Date: Tue, 27 Oct 2026 16:46:32 +0100

compact_zone() keeps the positions of its scanners in cc->migrate_pfn and
cc->free_pfn for the whole run. Memory offlining can shrink the zone in
the meantime. At the end of remove_pfn_range_from_zone(),
set_zone_contiguous() only looks at what is left of the zone. If that has
no hole, or if nothing is left, zone->contiguous is set again, and
pageblock_pfn_to_page() returns the memmap of any pfn unchecked, also of
one that the zone does not span any more.

The memmap of the range that left the zone is poisoned if CONFIG_DEBUG_VM
is set. Once the memory has been removed, the memmap and the pageblock
flags are freed. Ejecting DIMMs that were online in ZONE_MOVABLE while
other tasks write to /proc/sys/vm/compact_memory, no debug options set:

  BUG: unable to handle page fault for address: ffffea0004000008
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 3fee9067 P4D 3fee9067 PUD 3fee8067 PMD 0
  RIP: 0010:isolate_migratepages_block+0x32f/0x1280
  Call Trace:
   compact_zone+0x673/0x1140
   compact_node+0xb6/0x130
   sysctl_compaction_handler+0x77/0xd0

kcompactd and direct compaction walk into such ranges in the same way.

Only trust the flag for a pfn that the zone spans. Everything else goes
to __pageblock_pfn_to_page(), which finds the section offline or gone.
The span is written before the flag is set, so read them in the opposite
order.

Link: https://lore.kernel.org/20261027-pgalloc-ai-hotfixes-v1-6-9c7d1aca801e@kernel.org
Fixes: 7cf91a98e607 ("mm/compaction: speed up pageblock_pfn_to_page() when zone is contiguous")
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

 mm/mm_init.c    |    4 ++--
 mm/page_alloc.h |    7 ++++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/mm/mm_init.c~mm-compaction-trust-zone-contiguous-only-in-the-span
+++ a/mm/mm_init.c
@@ -2270,8 +2270,8 @@ void set_zone_contiguous(struct zone *zo
 		cond_resched();
 	}
 
-	/* We confirm that there is no hole */
-	zone->contiguous = true;
+	/* We confirm that there is no hole, see pageblock_pfn_to_page() */
+	smp_store_release(&zone->contiguous, true);
 }
 
 /*
--- a/mm/page_alloc.h~mm-compaction-trust-zone-contiguous-only-in-the-span
+++ a/mm/page_alloc.h
@@ -216,7 +216,12 @@ extern struct page *__pageblock_pfn_to_p
 static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
 				unsigned long end_pfn, struct zone *zone)
 {
-	if (zone->contiguous)
+	/*
+	 * A scanner may still be at a pfn that has left the zone: the zone is
+	 * shrunk before set_zone_contiguous() says that it has no holes.
+	 */
+	if (smp_load_acquire(&zone->contiguous) &&
+	    zone_spans_pfn(zone, start_pfn))
 		return pfn_to_page(start_pfn);
 
 	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-page_isolation-do-not-take-slab-pages-for-free.patch
mm-memory_hotplug-resize-zones-under-their-seqlock.patch
mm-page_alloc-check-pageblock-pfns-under-span-seqlock.patch
mm-filemap-dont-lose-a-folio-lock-wakeup-to-a-signal.patch

