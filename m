Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793131539;
	b=hh5z8icAINH20ZEpe+Tgl1d9x+UnMAUb6fVXLipfgrdaMGkXp/6104POOND+2iZ44bPP
	 lKlcf6dB7ZTThPk0CqJ+jhA67G5Jk6RS/Ux3nxrfMXyXGx2E7mBmoi7vrw8zNfWmA8Mfi
	 pFAOAL5TIThSF9nJQuhF0sWkULiiXG0G6EImcZWD+5BfPSf3CjX8XmUz9wGDequt9sqiD
	 Nh5YM8RmavDNitTWY1JO5etiDpJMozY9dHlc+Iomo4YPuxA1nFAW69+Gf7o8sC56b12NR
	 hBV9SSmFth1NZAdVdhTpnfi/o3/6bibZ4RHfGGDmAyK0aWEbXQf6IEcKJ6QmwqkvCNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793131539;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=6cq8HJdbTp8bPAXhCRb8wHCGy3+CcXkC2T30FZUf4pw=;
	b=qzPCGpUURor8Zp93xnc49ReZBBqiEUi2s0/6odZLI+qPaKsDBeNCaZiauF1DBlZouY9Q
	 mYUBWgVJJYKX70quxV4DPypG8DqUMwPiWscZVlukAMteDu6o7lZ3Igx9P28pcxiYMppG8
	 UOhu1dkny3UAnxXyfBLLsALjcXrXYaayzuljELBEGLqW95HFkzQzKaXPd1FzxIrhCG6vx
	 iMGOdRYCNtaW5lAbKRmpSLmxrMFfodYwOLHtUtOvhrZXMLVXBEeYUuJxqi9agQ3Lip2+h
	 AP0OWOb36MNHsdAfJ/DSCY3o+0UOJwhtCgSxN9OhS4w5VpcV91pbenJIoEWXqF0qxVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=p7GNlvHL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FF8606A320;
	Tue, 27 Oct 2026 20:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=p7GNlvHL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A54D1F01828;
	Tue, 27 Oct 2026 20:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793131538;
	bh=6cq8HJdbTp8bPAXhCRb8wHCGy3+CcXkC2T30FZUf4pw=;
	h=Date:To:From:Subject;
	b=p7GNlvHLW51dRtMvJJUyvShEoVLYpRRLNKbzykkDAoYabvSL1khh+Yxr+pSxHZJY5
	 H2NnZimTi+8AS0J3YH1ouPO+lGSdEdaMewPFToohwNZvFpsJtd72zsbzREeYPtSyhM
	 vcT0vu9H9vAcXhwl4cbpylNBU15L7rTd3l3wR6nc=
Date: Tue, 27 Oct 2026 13:05:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,
	shakeel.butt@linux.dev,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,
	hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,
	brendan.jackman@linux.dev,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-trust-zone-contiguous-only-in-the-span.patch added to mm-unstable branch
Message-Id: <20261027200538.8A54D1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/compaction: trust zone->contiguous only in the span
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-trust-zone-contiguous-only-in-the-span.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-trust-zone-contiguous-only-in-the-span.patch

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

mm-page_alloc-dont-undo-a-racing-start_isolate_page_range.patch
mm-page_alloc-clear-private-of-deferred-free-pages.patch
mm-page_frag-refill-the-cache-for-large-fragments.patch
mm-page_alloc-keep-the-pagesets-of-an-empty-zone.patch
mm-page_alloc-pass-zone-pointer-to-trace_reclaim_retry_zone.patch
mm-compaction-trust-zone-contiguous-only-in-the-span.patch
mm-page_isolation-do-not-take-slab-pages-for-free.patch
mm-memory_hotplug-resize-zones-under-their-seqlock.patch
mm-page_alloc-check-pageblock-pfns-under-span-seqlock.patch

