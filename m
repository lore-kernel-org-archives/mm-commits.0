Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793131535;
	b=eoGi8rEkq/oV27Wv0Z8OPyN0VZ8ss0tHNHp4rWPqS9bG31N9eLtlUGH1OWdFnaWGXkAD
	 9d7neFbp4z3mTqjtBF/sW6wb7F9tGssdsKuOFFZxEfCAm68J3hR8ZCKy6YHzBem/gZgVd
	 s32jIJ6Si2myCjI+PUfKRtPvfUCXgr0jlco66XRV5mQBzhrnztwYFTpAKcvjDbKp0C79W
	 Ob7n5l7KOxictdPij8Zi44UOfdhDzw5CPTHaommzntKtx5iiqbSQgM71FXKxMvsj6PMSP
	 n82SrA68s6gxkElmbuXe/jOO9HmTfY059flC5Yqk1+ZNmJiQlt8ueN+Ci63waI0oAIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793131535;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=daK+q9Y3lp/MFmrzgpdbsua8cczxq6JgM8PLux+OYc8=;
	b=Cbe60kYo0Br5mhl0+Iwsl9vGxQh30hmtGuMYmX8HgYheH/ElKyB4A9efWzWwXLEDU8Hb
	 xm+0GzvupaAcI/ZmmJMNE4yYP4SebcoSPFRAkJjyQnnqA+KQ74X+JgvWV4xnqjspfTd+j
	 C2ozm9d3VyXGagyDdTlXbACiScSQP8j9NxkfqARg63If0VneEoO+t3i6y4jI1k7drKPCS
	 CSqUxTrCNxks+AnYOSg4skUwxkw7xWNwBDe0o470dyMCTYl5XlDQHyrRrcYTWRV6KY5RH
	 S44hR797UmlIPZXXBIFRtucgu9YMrOF0R0mlKLzR/ALuHzYY1ZA7ex1zng2LMqqyEwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2SQsJbtM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A648F606A320;
	Tue, 27 Oct 2026 20:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2SQsJbtM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318821F01828;
	Tue, 27 Oct 2026 20:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793131534;
	bh=daK+q9Y3lp/MFmrzgpdbsua8cczxq6JgM8PLux+OYc8=;
	h=Date:To:From:Subject;
	b=2SQsJbtMDbWlUazyZwPn/+4moEbSNMsglJkwkywM2Y7O7ne27ZGi94t5FUkOqgxMS
	 cyTo/yzqrHSG5vV3UVaWFbJO8S+Vy9+gB/3wr9yI9iam/5RLPbWfgD3yaLtCBuRU/2
	 eRBrs2v6Puq8jre0LfFCXhtaWK9Y65wnkmVdjXxg=
Date: Tue, 27 Oct 2026 13:05:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,
	shakeel.butt@linux.dev,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,
	hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,
	brendan.jackman@linux.dev,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-keep-the-pagesets-of-an-empty-zone.patch added to mm-unstable branch
Message-Id: <20261027200534.318821F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/page_alloc: keep the pagesets of an empty zone
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-keep-the-pagesets-of-an-empty-zone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-keep-the-pagesets-of-an-empty-zone.patch

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
Subject: mm/page_alloc: keep the pagesets of an empty zone
Date: Tue, 27 Oct 2026 16:46:30 +0100

When the last memory of a zone goes offline, zone_pcp_reset() frees
zone->per_cpu_pageset and zone->per_cpu_zonestats. Nothing waits for those
who found the zone populated and still use the two pointers. They take
neither the memory hotplug lock nor any other lock which offline_pages()
holds, and some of them can sleep:

  CPU0 vmstat_update()                CPU1 offline_pages()
  refresh_cpu_vm_stats()
    for_each_populated_zone(zone)
      pcp = zone->per_cpu_pageset
      cond_resched()
                                      adjust_present_page_count()
                                      zone_pcp_reset(zone)
                                        free_percpu(zone->per_cpu_pageset)
      decay_pcp_high(zone, pcp)
      __this_cpu_write(pcp->expire, 0)

The same goes for drain_all_pages(NULL), which takes pcp->lock, for
zone_pcp_update(), show_free_areas() and the readers and writers of the
zonestats. If the per-cpu memory has got a new owner in the meantime, it
is corrupted.

The pagesets are only freed because setup_zone_pageset() would otherwise
leak them when the zone gets memory again. Keep them instead and let
setup_zone_pageset() and zone_pcp_init() use them again, like it is done
with pgdat->per_cpu_nodestats. Their lists are empty, and their limits
have been calculated for a zone without memory by the
init_per_zone_wmark_min() of offline_pages(), which is what
setup_zone_pageset() would come up with as well.

Link: https://lore.kernel.org/20261027-pgalloc-ai-hotfixes-v1-4-9c7d1aca801e@kernel.org
Fixes: 340175b7d14d ("mm/hotplug: free zone->pageset when a zone becomes empty")
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

 mm/page_alloc.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-keep-the-pagesets-of-an-empty-zone
+++ a/mm/page_alloc.c
@@ -6312,6 +6312,10 @@ void __meminit setup_zone_pageset(struct
 {
 	int cpu;
 
+	/* The zone has been populated before, see zone_pcp_reset(). */
+	if (zone->per_cpu_pageset != &boot_pageset)
+		return;
+
 	/* Size may be 0 on !SMP && !NUMA */
 	if (sizeof(struct per_cpu_zonestat) > 0)
 		zone->per_cpu_zonestats = alloc_percpu(struct per_cpu_zonestat);
@@ -6404,6 +6408,10 @@ void __init setup_per_cpu_pageset(void)
 
 __meminit void zone_pcp_init(struct zone *zone)
 {
+	/* A node which is added again, see zone_pcp_reset(). */
+	if (zone->per_cpu_pageset && zone->per_cpu_pageset != &boot_pageset)
+		return;
+
 	/*
 	 * per cpu subsystem is not up at this point. The following code
 	 * relies on the ability of the linker to provide the
@@ -7684,6 +7692,12 @@ void zone_pcp_enable(struct zone *zone)
 	mutex_unlock(&pcp_batch_high_lock);
 }
 
+/*
+ * The zone has become empty. Its pagesets and zonestats are not freed: nothing
+ * keeps somebody who found the zone populated, such as refresh_cpu_vm_stats()
+ * or drain_all_pages(), from still using them. They are used again when the
+ * zone gets memory again.
+ */
 void zone_pcp_reset(struct zone *zone)
 {
 	int cpu;
@@ -7694,12 +7708,6 @@ void zone_pcp_reset(struct zone *zone)
 			pzstats = per_cpu_ptr(zone->per_cpu_zonestats, cpu);
 			drain_zonestat(zone, pzstats);
 		}
-		free_percpu(zone->per_cpu_pageset);
-		zone->per_cpu_pageset = &boot_pageset;
-		if (zone->per_cpu_zonestats != &boot_zonestats) {
-			free_percpu(zone->per_cpu_zonestats);
-			zone->per_cpu_zonestats = &boot_zonestats;
-		}
 	}
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

