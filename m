Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B609679F8
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 05:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707369475; cv=none; b=SAJvpzSZ3Vz2bfHl0o4R9WyOZ7bw/REwz7OHzQprhFaPR/gfDtv9MZNOJEv+y7LxpLwACtaM0QUv28pm80CWQN8TuVlZupe00r+n80xIrfcGccCesk1kfAcSswg4+15e2adi4K7V/gJvc4mfz0/CI/wia/uwGkUH2q+DZm3hJiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707369475; c=relaxed/simple;
	bh=SD9/xT8kfvNAU1OGxHChOpWc5rToPuGHOBOj4O098Lc=;
	h=Date:To:From:Subject:Message-Id; b=hfJzt8P0DSyCzJSgvA0p8Qqim1ByzC2PSupYlkzSPDupBi5iEM3jMvVp/gwdqf/cAULdN3xSjAG9+yhGeDxUCJ5JH2YSe6lUdPUX+fn8ryNk8CmplxTb/oQHm1sIKTAvhEVuOup0MtIqeonMlTyaY7IrFZZfBZJ4y20vk2OFYBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pWm2CG9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pWm2CG9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75402C433F1;
	Thu,  8 Feb 2024 05:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707369474;
	bh=SD9/xT8kfvNAU1OGxHChOpWc5rToPuGHOBOj4O098Lc=;
	h=Date:To:From:Subject:From;
	b=pWm2CG9WFdrMRVAN4Ez9qmW8V2E4ewnoB08GO+/8zHlx8ia6Ni5yt3iARXDhnHh+N
	 5I739MfqYY6Pur2FxZlyQmu3jGJA8dkX2fnB+Wvx4evQeGFrdXGjiiM7jteYhRtjRy
	 4ioAhkFCPoyOylGYLezPSRYxyU58tUZund4Z8DUU=
Date: Wed, 07 Feb 2024 21:17:53 -0800
To: mm-commits@vger.kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,gthelen@google.com,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated-fix.patch removed from -mm tree
Message-Id: <20240208051754.75402C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: fix struct memcg_vmstats_percpu size and alignment
has been removed from the -mm tree.  Its filename was
     mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated-fix.patch

This patch was dropped because it was folded into mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated.patch

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: memcg: fix struct memcg_vmstats_percpu size and alignment
Date: Sat, 3 Feb 2024 04:46:12 +0000

Commit da10d7e140196 ("mm: memcg: optimize parent iteration in
memcg_rstat_updated()") added two additional pointers to the end of struct
memcg_vmstats_percpu with CACHELINE_PADDING to put them in a separate
cacheline.  This caused the struct size to increase from 1200 to 1280 on
my config (80 extra bytes instead of 16).

Upon revisiting, the relevant struct members do not need to be on a
separate cacheline, they just need to fit in a single one.  This is a
percpu struct, so there shouldn't be any contention on that cacheline
anyway.  Move the members to the beginning of the struct and make sure the
struct itself is cacheline aligned.  Add a comment about the members that
need to fit together in a cacheline.

The struct size is now 1216 on my config with this change.

Link: https://lkml.kernel.org/r/20240203044612.1234216-1-yosryahmed@google.com
Fixes: da10d7e14019 ("mm: memcg: optimize parent iteration in memcg_rstat_updated()")
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reported-by: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated-fix
+++ a/mm/memcontrol.c
@@ -621,6 +621,15 @@ static inline int memcg_events_index(enu
 }
 
 struct memcg_vmstats_percpu {
+	/* Stats updates since the last flush */
+	unsigned int			stats_updates;
+
+	/* Cached pointers for fast iteration in memcg_rstat_updated() */
+	struct memcg_vmstats_percpu	*parent;
+	struct memcg_vmstats		*vmstats;
+
+	/* The above should fit a single cacheline for memcg_rstat_updated() */
+
 	/* Local (CPU and cgroup) page state & events */
 	long			state[MEMCG_NR_STAT];
 	unsigned long		events[NR_MEMCG_EVENTS];
@@ -632,17 +641,7 @@ struct memcg_vmstats_percpu {
 	/* Cgroup1: threshold notifications & softlimit tree updates */
 	unsigned long		nr_page_events;
 	unsigned long		targets[MEM_CGROUP_NTARGETS];
-
-	/* Fit members below in a single cacheline for memcg_rstat_updated() */
-	CACHELINE_PADDING(_pad1_);
-
-	/* Stats updates since the last flush */
-	unsigned int		stats_updates;
-
-	/* Cached pointers for fast iteration in memcg_rstat_updated() */
-	struct memcg_vmstats_percpu	*parent;
-	struct memcg_vmstats		*vmstats;
-};
+} ____cacheline_aligned;
 
 struct memcg_vmstats {
 	/* Aggregated (CPU and subtree) page state & events */
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated.patch
mm-zswap-fix-missing-folio-cleanup-in-writeback-race-path.patch
mm-swap-enforce-updating-inuse_pages-at-the-end-of-swap_range_free.patch
mm-zswap-remove-unnecessary-trees-cleanups-in-zswap_swapoff.patch
mm-zswap-remove-unused-tree-argument-in-zswap_entry_put.patch
x86-mm-delete-unused-cpu-argument-to-leave_mm.patch
x86-mm-clarify-prev-usage-in-switch_mm_irqs_off.patch

