Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793131543;
	b=MsfvHX4voQwoz8vjJ6ZpNdiAQX7MC/E1tDtlLb+OO7A+i33F7Rv1hbhrpRaYJF6ce1J9
	 elRC6s0H7+qEhD0Cm4CR5po/uEfUa0Gys0PHc9HYIrqZ7/K2llP79A1KOSWIlnommbOdM
	 B7bJuRLALFzfhZeH1jGJevbLOuWCt27gJ+AVIDXr9KfFLleNIizM3MeFUwBw0ZW1OlJT4
	 EUrbXSg8ieu1wKOfkIGXqi2O8PHzFNGSWEVCo2TcY/RVsn1QN03RXuLTYTGaiDMOUFH8j
	 QexyKyI9ut3nUvinAsbYgPkcSdPjDYtHG6SoMGfnBfzfhrdD8C9W7af2mhHCOc7GeqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793131543;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=3yZbLKl+lK8pTnLJ8/ysaxlpLv1CxJpbhJHDq/znmvE=;
	b=Nx7Zlcq/mhFOe1KOZRGR+KMVc5BbwiPGzde5+4JXTxZ04q3h25jH9K1BHFC6e6hfUJo9
	 o+mTOVNPsARI+RS+ayAva8OLEQ6hr3SqnAKOGXZaEg7zWy8XSVdAy9XN1YpDozMxkYWbt
	 qIAOtzzfxqG2oyTzeSMbRs4pSPfHmNxfzQDUEd4BRPC/c7ulAXfSp41JOgX4A2KfFG8eo
	 k0zov8NjbSsDJt5F7bmE2kmTKbMoa+H9wqBKItJF6uhOhmDHpGLXwOdkguoXAcw4A47/6
	 iCuolKyMRRixKy9I9otLghTHcgSdwNFqq0mAWVAZUO4iHq0ZwLEGhI7nQYluhEfWKTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=s80zaUZK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772D0606A31A;
	Tue, 27 Oct 2026 20:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=s80zaUZK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B471F01825;
	Tue, 27 Oct 2026 20:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793131543;
	bh=3yZbLKl+lK8pTnLJ8/ysaxlpLv1CxJpbhJHDq/znmvE=;
	h=Date:To:From:Subject;
	b=s80zaUZKCBlhmk6YS1+wx8jGo0tnFhvpBQppzcoD4SlIahiHErZ7LpwI6X2miI8iX
	 L6kgnjAw21KbmFC6OvxBFTi7Fw+NtftLAT9fNgUrDP8XhUGSjal2E+bhsglzHPll9n
	 +kBVl0ByrZCMBX9xOixpsy/nisZvY11wcwOAEGg8=
Date: Tue, 27 Oct 2026 13:05:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,
	shakeel.butt@linux.dev,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,
	hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,
	brendan.jackman@linux.dev,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-resize-zones-under-their-seqlock.patch added to mm-unstable branch
Message-Id: <20261027200543.41B471F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/memory_hotplug: resize zones under their seqlock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-resize-zones-under-their-seqlock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-resize-zones-under-their-seqlock.patch

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
Subject: mm/memory_hotplug: resize zones under their seqlock
Date: Tue, 27 Oct 2026 16:46:34 +0100

With CONFIG_DEBUG_VM the page allocator checks that a page which is
freed, split or allocated lies within its zone. The check reads
zone->zone_start_pfn and zone->spanned_pages under zone->span_seqlock, as
memory hotplug can change the two at any time.

Commit 27cacaad16c5 ("mm,memory_hotplug: drop unneeded locking") removed
the write side, since all resizing is serialized by the hotplug lock. That
leaves the reader without protection. When memory below the start of a
zone goes online, the start is lowered first and the size is raised
afterwards. When the lowest memory of a zone goes offline, the size is
reduced first. In between, the zone seems to end before its last pages. If
one of them goes through the allocator at that moment, it is reported as
being outside of the zone and VM_BUG_ON_PAGE() kills the kernel.

Write the two fields in a write section of the seqlock. Interrupts are
disabled as pages are freed from interrupts, too, and the reader would
wait for the writer which it has interrupted.

Link: https://lore.kernel.org/20261027-pgalloc-ai-hotfixes-v1-8-9c7d1aca801e@kernel.org
Fixes: 27cacaad16c5 ("mm,memory_hotplug: drop unneeded locking")
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

 mm/memory_hotplug.c |   44 ++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-resize-zones-under-their-seqlock
+++ a/mm/memory_hotplug.c
@@ -467,6 +467,22 @@ static unsigned long find_biggest_sectio
 	return 0;
 }
 
+/*
+ * The page allocator checks pages against the span of their zone while the
+ * zone is resized, see page_outside_zone_boundaries(). It must not see the
+ * new value of one field together with the old value of the other one.
+ */
+static void zone_set_span(struct zone *zone, unsigned long start_pfn,
+			  unsigned long spanned_pages)
+{
+	unsigned long flags;
+
+	write_seqlock_irqsave(&zone->span_seqlock, flags);
+	zone->zone_start_pfn = start_pfn;
+	zone->spanned_pages = spanned_pages;
+	write_sequnlock_irqrestore(&zone->span_seqlock, flags);
+}
+
 static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 			     unsigned long end_pfn)
 {
@@ -482,13 +498,10 @@ static void shrink_zone_span(struct zone
 		 */
 		pfn = find_smallest_section_pfn(nid, zone, end_pfn,
 						zone_end_pfn(zone));
-		if (pfn) {
-			zone->spanned_pages = zone_end_pfn(zone) - pfn;
-			zone->zone_start_pfn = pfn;
-		} else {
-			zone->zone_start_pfn = 0;
-			zone->spanned_pages = 0;
-		}
+		if (pfn)
+			zone_set_span(zone, pfn, zone_end_pfn(zone) - pfn);
+		else
+			zone_set_span(zone, 0, 0);
 	} else if (zone_end_pfn(zone) == end_pfn) {
 		/*
 		 * If the section is biggest section in the zone, it need
@@ -499,11 +512,10 @@ static void shrink_zone_span(struct zone
 		pfn = find_biggest_section_pfn(nid, zone, zone->zone_start_pfn,
 					       start_pfn);
 		if (pfn)
-			zone->spanned_pages = pfn - zone->zone_start_pfn + 1;
-		else {
-			zone->zone_start_pfn = 0;
-			zone->spanned_pages = 0;
-		}
+			zone_set_span(zone, zone->zone_start_pfn,
+				      pfn - zone->zone_start_pfn + 1);
+		else
+			zone_set_span(zone, 0, 0);
 	}
 }
 
@@ -696,12 +708,12 @@ static void online_pages_range(unsigned
 static void __meminit resize_zone_range(struct zone *zone, unsigned long start_pfn,
 		unsigned long nr_pages)
 {
-	unsigned long old_end_pfn = zone_end_pfn(zone);
+	unsigned long end_pfn = max(start_pfn + nr_pages, zone_end_pfn(zone));
 
-	if (zone_is_empty(zone) || start_pfn < zone->zone_start_pfn)
-		zone->zone_start_pfn = start_pfn;
+	if (!zone_is_empty(zone) && start_pfn > zone->zone_start_pfn)
+		start_pfn = zone->zone_start_pfn;
 
-	zone->spanned_pages = max(start_pfn + nr_pages, old_end_pfn) - zone->zone_start_pfn;
+	zone_set_span(zone, start_pfn, end_pfn - start_pfn);
 }
 
 static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned long start_pfn,
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

