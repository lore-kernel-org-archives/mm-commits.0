Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE42399019
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 19:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780600506; cv=none; b=aSLFcGZqxL9QTqRdUPLJiL3DPqiWdzG9GoBfhbfiDudUhvP8UZDbQNxi8js2M/HUF+CiqV7BtQ7IU9GuO6uH3p4zH6AsHEADCZJM9X9Pu1YtFoQurmgv3WC7dtXZnCNvLJ/6iOm5RNebEsoJKEnfs5NY5KaCFieYQe/jQT5iJMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780600506; c=relaxed/simple;
	bh=MaBa0OH9z8fJteOzeoGJQ+7uhx/+nlsi0Ya9Z6FJVME=;
	h=Date:To:From:Subject:Message-Id; b=Ica4awYDup+CRtzuq7jstxjsUJAo58ECP6SI26BsgBAe/aKYXInkBga+7kleIRrzvS3Z+DEbLtCYuo1xEAyq8AEUi6rYMCy7RimLXJApDJv6SgN+D0hkZvv4eB0NWgzhdiMV0nY41uBXgruMTLAd4ovSc8abY8L3/JcNm3x7yIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TzjeA3go; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TzjeA3go"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6451F00893;
	Thu,  4 Jun 2026 19:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780600505;
	bh=2lInUcWEp5NhjU81nVhXjF8/jJumaNYUmnZtqMCI6Hw=;
	h=Date:To:From:Subject;
	b=TzjeA3gowhAkb0hUrQgNxJvWMuvyZ5zeRJXuloM3KXtvkYSY3WuEtYv6lFj53T1cw
	 ADnBQawwb8nSUaWfJbRRLJKy+Cax2fk0GB7iirVn8bol17PdsAh3lGBeH9wkYvWFAe
	 wegJ9Ix4ZVKvaW7YvX0D6iTta5kKhhQMz9p6dZQk=
Date: Thu, 04 Jun 2026 12:15:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,jp.kobryn@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-cap-compact_gap-at-compact_cluster_max.patch added to mm-unstable branch
Message-Id: <20260604191504.DE6451F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: cap compact_gap() at COMPACT_CLUSTER_MAX
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-cap-compact_gap-at-compact_cluster_max.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-cap-compact_gap-at-compact_cluster_max.patch

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
From: "JP Kobryn" <jp.kobryn@linux.dev>
Subject: mm/compaction: cap compact_gap() at COMPACT_CLUSTER_MAX
Date: Wed, 3 Jun 2026 23:17:25 -0700

compact_gap() returns 2 << order, which is used as watermark headroom in
__compaction_suitable() and as a threshold in kswapd reclaim decisions. 
The computed value scales exponentially by order.  For order-9 THP
allocations this evaluates to 1024 pages, but the compaction free
scanner's working set is bounded by COMPACT_CLUSTER_MAX (32 pages).  The
scanner stops isolating free pages once it matches the migration batch. 
The current gap over-reserves by 32x.

On fragmented production hosts, kswapd will try to reclaim up to the gap,
but it only reaches that threshold in 18% of attempts.  As a result,
reclaim continues in the majority of cases despite many lower-order free
pages being available.  The over-sized gap also causes 46% of order-9
compaction suitability checks to fail unnecessarily: the zone has
sufficient free pages for the scanner to operate, but not enough to clear
the inflated threshold.

Cap compact_gap() at COMPACT_CLUSTER_MAX so the watermark headroom
reflects the scanner's actual capacity.  This function is used by two key
heuristics.  The first is when kswapd can stop high-order reclaim and
downgrade to order-0 balancing, allowing kcompactd to be woken for the
original higher allocation order.  The second is zone suitability
checking, where the smaller gap allows compaction to start sooner.

Note that orders 0-4 are unaffected since their gap is already less than
or equal to COMPACT_CLUSTER_MAX.

A/B test on v6.13-based instagram production hosts (64GB, 60s
measurement):

Unpatched (43 hosts)
pgscan_kswapd (mean/host): ~1.6M
reclaim efficiency (steal/scan): 83.8%
per-compaction success (success/stall): 2.1%
THP success (alloc/alloc+fallback): 4.9%
forced lru_add_drain (mean/host): ~107K

Patched (59 hosts)
pgscan_kswapd (mean/host): ~449K
reclaim efficiency (steal/scan): 91.0%
per-compaction success (success/stall): 28.3%
THP success (alloc/alloc+fallback): 17.2%
forced lru_add_drain (mean/host): ~64K

Additional tests were also performed using a workload of similar shape and
based on mm-new at the time of testing.  Across three 60s runs, the patch
showed improvements consistent with the previous test: reduced kswapd
reclaim and fewer THP fault fallbacks.

Unpatched
kswapd_shrink_node downgrade to order-0 (mean): 0
thp_fault_fallback (mean): 1217
pgscan_kswapd (mean): 6328
pgsteal_kswapd (mean): 5657

Patched
kswapd_shrink_node downgrade to order-0 (mean): 28
thp_fault_fallback (mean): 738
pgscan_kswapd (mean): 3773
pgsteal_kswapd (mean): 3243

Link: https://lore.kernel.org/20260604061725.13800-1-jp.kobryn@linux.dev
Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    8 ++++----
 mm/vmscan.c                |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/compaction.h~mm-compaction-cap-compact_gap-at-compact_cluster_max
+++ a/include/linux/compaction.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_COMPACTION_H
 #define _LINUX_COMPACTION_H
 
+#include <linux/swap.h>
+
 /*
  * Determines how hard direct compaction should try to succeed.
  * Lower value means higher priority, analogically to reclaim priority.
@@ -73,11 +75,9 @@ static inline unsigned long compact_gap(
 	 * effectively limited by COMPACT_CLUSTER_MAX, as that's the maximum
 	 * that the migrate scanner can have isolated on migrate list, and free
 	 * scanner is only invoked when the number of isolated free pages is
-	 * lower than that. But it's not worth to complicate the formula here
-	 * as a bigger gap for higher orders than strictly necessary can also
-	 * improve chances of compaction success.
+	 * lower than that.
 	 */
-	return 2UL << order;
+	return min(2UL << order, COMPACT_CLUSTER_MAX);
 }
 
 static inline int current_is_kcompactd(void)
--- a/mm/vmscan.c~mm-compaction-cap-compact_gap-at-compact_cluster_max
+++ a/mm/vmscan.c
@@ -7014,7 +7014,7 @@ static bool kswapd_shrink_node(pg_data_t
 
 	/*
 	 * Fragmentation may mean that the system cannot be rebalanced for
-	 * high-order allocations. If twice the allocation size has been
+	 * high-order allocations. If at least the compaction gap has been
 	 * reclaimed then recheck watermarks only at order-0 to prevent
 	 * excessive reclaim. Assume that a process requested a high-order
 	 * can direct reclaim/compact.
_

Patches currently in -mm which might be from jp.kobryn@linux.dev are

mm-compaction-cap-compact_gap-at-compact_cluster_max.patch

