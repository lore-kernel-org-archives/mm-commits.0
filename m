Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5ACB674
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 03:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744343211; cv=none; b=AFMF0TIx3PdFZT40ZlOIEYXL17TbHyc0Rhmqzo7Qdg3tr0+m4/7GwgpzkK+2EsY/Wt1hUYCV4dzhMper4+6vkFHdB/IQ7el28Puy2me/F70qaXi0+/GqcwIlxftavHXpw0dIky4zuU1NcZ0PBZEskc0MZ6PoKYsjKzEzpRoJGks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744343211; c=relaxed/simple;
	bh=uvZd3EkIsJUIVvWHTSiunZ8QnRDFwnbhgqYM/WRGl5k=;
	h=Date:To:From:Subject:Message-Id; b=k/C1T7zXBy44HMCVVgnquM34AZsrkR3Kmx7V22VjaFEeR/eFTyYrW3deCoeo/4q7BaFAQdOHzNGCPtfsOcz+6VJjrp99r4pnbLIZufaPx1gGUdFutoZdjmCBNHTKHsXmdQpXZG2C2fWZPMDS3ojq29O2DRSoYyvbkAWK6SCGUis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vjucT3xy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vjucT3xy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC063C4CEE2;
	Fri, 11 Apr 2025 03:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744343210;
	bh=uvZd3EkIsJUIVvWHTSiunZ8QnRDFwnbhgqYM/WRGl5k=;
	h=Date:To:From:Subject:From;
	b=vjucT3xy1WL3FnaIjcyRsh5fgj4Ncf+L8fP+oZF4qwUMOLXDWOEL0m2a//oPR1gql
	 xFe2UQQI4914VdqaixzqRBRIu24lF4d6EEuTzKTiyEpLH0GLSh7aNyuluMEgL7ydf1
	 JvKKK+PpFI7BnItvt08PljVXJkp1tcIR2VM48gI8=
Date: Thu, 10 Apr 2025 20:46:50 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-optimize-memcg_rstat_updated.patch added to mm-new branch
Message-Id: <20250411034650.DC063C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: optimize memcg_rstat_updated
has been added to the -mm mm-new branch.  Its filename is
     memcg-optimize-memcg_rstat_updated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-optimize-memcg_rstat_updated.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: optimize memcg_rstat_updated
Date: Wed, 9 Apr 2025 19:57:52 -0700

Currently the kernel maintains the stats updates per-memcg which is needed
to implement stats flushing threshold.  On the update side, the update is
added to the per-cpu per-memcg update of the given memcg and all of its
ancestors.  However when the given memcg has passed the flushing
threshold, all of its ancestors should have passed the threshold as well. 
There is no need to traverse up the memcg tree to maintain the stats
updates.

Perf profile collected from our fleet shows that memcg_rstat_updated is
one of the most expensive memcg function i.e.  a lot of cumulative CPU is
being spent on it.  So, even small micro optimizations matter a lot.  This
patch is microbenchmarked with multiple instances of netperf on a single
machine with locally running netserver and we see couple of percentage of
improvement.

Link: https://lkml.kernel.org/r/20250410025752.92159-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~memcg-optimize-memcg_rstat_updated
+++ a/mm/memcontrol.c
@@ -594,18 +594,20 @@ static inline void memcg_rstat_updated(s
 	cgroup_rstat_updated(memcg->css.cgroup, cpu);
 	statc = this_cpu_ptr(memcg->vmstats_percpu);
 	for (; statc; statc = statc->parent) {
+		/*
+		 * If @memcg is already flushable then all its ancestors are
+		 * flushable as well and also there is no need to increase
+		 * stats_updates.
+		 */
+		if (memcg_vmstats_needs_flush(statc->vmstats))
+			break;
+
 		stats_updates = READ_ONCE(statc->stats_updates) + abs(val);
 		WRITE_ONCE(statc->stats_updates, stats_updates);
 		if (stats_updates < MEMCG_CHARGE_BATCH)
 			continue;
 
-		/*
-		 * If @memcg is already flush-able, increasing stats_updates is
-		 * redundant. Avoid the overhead of the atomic update.
-		 */
-		if (!memcg_vmstats_needs_flush(statc->vmstats))
-			atomic64_add(stats_updates,
-				     &statc->vmstats->stats_updates);
+		atomic64_add(stats_updates, &statc->vmstats->stats_updates);
 		WRITE_ONCE(statc->stats_updates, 0);
 	}
 }
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-vmalloc-simplify-memcg_vmalloc-updates.patch
memcg-vmalloc-simplify-memcg_vmalloc-updates-fix.patch
memcg-remove-root-memcg-check-from-refill_stock.patch
memcg-decouple-drain_obj_stock-from-local-stock.patch
memcg-introduce-memcg_uncharge.patch
memcg-manually-inline-__refill_stock.patch
memcg-no-refilling-stock-from-obj_cgroup_release.patch
memcg-do-obj_cgroup_put-inside-drain_obj_stock.patch
memcg-use-__mod_memcg_state-in-drain_obj_stock.patch
memcg-manually-inline-replace_stock_objcg.patch
memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock.patch
memcg-optimize-memcg_rstat_updated.patch

