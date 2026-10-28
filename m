Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793156805;
	b=JeY3+s02jkdZ4xaKxLDMBfdoYMKJHb8CTyGcfOXIH1AV0AGhKWd/wTARidE1Oozy3aWo
	 4yjBDRMFKNJchR8x3N9rjgMpqsr4aPUGPmLH+c2YfHipipvezUQw5okS7vkKuhvAm8yI6
	 pH4hEbh8rE8k4vjruUfW0iANusrMnanjuAC8GdDBKL8j0Ycwru2wvwpDMkz7AjoXQkt6s
	 HNlUC2FeMYWNJaLtxsZpABKOFeB9vd7677jv6eCeDIlFLUUgtkNX3ZuF7/qhEysO+OPMb
	 HwyBkNOh+whfNOmg78NaDURxpn3S+MHoen58CMb0qNLPnwdtQWVv2Y+aS+k96IyXmJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793156805;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=pl1O+rPVYEol7nlIN/jasMe4DxDmG+LR2fNz5a0/hJ4=;
	b=tPZAcuHCKc7Z1koIrZt0oWdiQSMRNhdUtojYlfSVGKXNtEAwLXaGNkrFeaLY1Eh8hWKd
	 M9FF3l9QqGN4jTzj6dg5a4pttevayXWKYrkgcDHEx5eUGFNgiCFcONM/3YaVV9/wB+cEo
	 w8AQ6el4yNI8illkKrznKi4RlpaYXLqc/GnxV2tydpZYX881ktnMA6Fh6CRUJYpb8Dz4V
	 TyK9jwpCgNJgM7t15JQ76rJowEmUfnnScAIsGllRlZgilbP/iGlWX8ukO/pCYjfbpGGZt
	 FxIq5Ps0GVx/nZGdqNSlbZg3VW6cE85Fw48bN9J/KoiId4KcI68RxpYfHHVV7YvxeyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=V+CC1ir8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDF7606A31A
	for <mm-commits@vger.kernel.org>; Wed, 28 Oct 2026 03:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=V+CC1ir8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5A81F01828;
	Wed, 28 Oct 2026 03:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793156804;
	bh=pl1O+rPVYEol7nlIN/jasMe4DxDmG+LR2fNz5a0/hJ4=;
	h=Date:To:From:Subject;
	b=V+CC1ir8Xi645QtwPuGyAZ2xgOVqt7zw2j8MW2/66OhrensoJmCWxC5QLUjLPZNsP
	 b0FK1NvlvS2wZ6UYWas4vxR+mA21IH3FKA5bcw+e8k76aCUjGPGM23ROzMg3RTYAyE
	 ltYJa4LAkDuG7o2O6UzZUhyT1gTtFcsXJJb1G8oQ=
Date: Tue, 27 Oct 2026 20:06:44 -0700
To: mm-commits@vger.kernel.org,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory_hotplug-resize-zones-under-their-seqlock.patch removed from -mm tree
Message-Id: <20261028030644.CC5A81F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/memory_hotplug: resize zones under their seqlock
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-resize-zones-under-their-seqlock.patch

This patch was dropped because an updated version will be issued

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

mm-page_alloc-check-pageblock-pfns-under-span-seqlock.patch
mm-filemap-dont-lose-a-folio-lock-wakeup-to-a-signal.patch

