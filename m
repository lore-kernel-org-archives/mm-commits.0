Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61670A48
	for <mm-commits@vger.kernel.org>; Mon, 20 May 2024 00:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716164353; cv=none; b=mAXRX3AhuxefVDdcG4WhQLO78Kvy1Jsph2HIbqnfXn3iRLNGflyQWJ3Gg5ASAwXB7gLPYTk1KxfCVAKn0hrD5IeQ7vSGkGAbKFFs+51fNWgLyKJTfheYvIofcodTgv4o6qP1yT4iFuTUxHdOMGMXtb9U23tgWsYwzCSvleXZru8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716164353; c=relaxed/simple;
	bh=ukzNoL3CWRo09xpS2Q8cPohFx2aY9tq8pUtPVusy47Q=;
	h=Date:To:From:Subject:Message-Id; b=lMUETwYTvOH08qNQkOMVhxx7D64p9SZ1syF64IyTkJ7sJdF7/1AzGjarDOgo7vjHAQ4hQjJK46BzWPRBrbS0zJjssYk8CwItUL2g7R6u8iaTFups69d0k+UXcBPYwBHpaQ9C/gjA8l/4MBJKfnSLe1ghnQ7bq0LBija+E5wKIgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y7ydKZ2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y7ydKZ2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3217C32781;
	Mon, 20 May 2024 00:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716164352;
	bh=ukzNoL3CWRo09xpS2Q8cPohFx2aY9tq8pUtPVusy47Q=;
	h=Date:To:From:Subject:From;
	b=Y7ydKZ2oUswqwAMXgPSbE9Mn4e3R1d+33cu29bfDDX5CnQ5OP+sDRnkflkM9Ccs7O
	 idab0BGqofZWcyuxW7aRtYr/f7f2CF5NCQ9zXTijLIKXe5YSr2Xya+fSOqJWZzKpRJ
	 BzTQCvMPXydELBOK1MzCNsPd449WP7dOn5kl8RuI=
Date: Sun, 19 May 2024 17:19:12 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,riel@surriel.com,mhocko@kernel.org,kernel-team@fb.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-restore-incremental-cgroup-iteration.patch added to mm-unstable branch
Message-Id: <20240520001912.D3217C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: restore incremental cgroup iteration
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-restore-incremental-cgroup-iteration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-restore-incremental-cgroup-iteration.patch

This patch will later appear in the mm-unstable branch at
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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: restore incremental cgroup iteration
Date: Tue, 14 May 2024 16:26:41 -0400

Currently, reclaim always walks the entire cgroup tree in order to ensure
fairness between groups.  While overreclaim is limited in shrink_lruvec(),
many of our systems have a sizable number of active groups, and an even
bigger number of idle cgroups with cache left behind by previous jobs; the
mere act of walking all these cgroups can impose significant latency on
direct reclaimers.

In the past, we've used a save-and-restore iterator that enabled
incremental tree walks over multiple reclaim invocations.  This ensured
fairness, while keeping the work of individual reclaimers small.

However, in edge cases with a lot of reclaim concurrency, individual
reclaimers would sometimes not see enough of the cgroup tree to make
forward progress and (prematurely) declare OOM.  Consequently we switched
to comprehensive walks in 1ba6fc9af35b ("mm: vmscan: do not share cgroup
iteration between reclaimers").

To address the latency problem without bringing back the premature OOM
issue, reinstate the shared iteration, but with a restart condition to do
the full walk in the OOM case - similar to what we do for memory.low
enforcement and active page protection.

In the worst case, we do one more full tree walk before declaring
OOM. But the vast majority of direct reclaim scans can then finish
much quicker, while fairness across the tree is maintained:

- Before this patch, we observed that direct reclaim always takes more
  than 100us and most direct reclaim time is spent in reclaim cycles
  lasting between 1ms and 1 second. Almost 40% of direct reclaim time
  was spent on reclaim cycles exceeding 100ms.

- With this patch, almost all page reclaim cycles last less than 10ms,
  and a good amount of direct page reclaim finishes in under 100us. No
  page reclaim cycles lasting over 100ms were observed anymore.

The shared iterator state is maintaned inside the target cgroup, so
fair and incremental walks are performed during both global reclaim
and cgroup limit reclaim of complex subtrees.

Link: https://lkml.kernel.org/r/20240514202641.2821494-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Rik van Riel <riel@surriel.com>
Reported-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Facebook Kernel Team <kernel-team@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-restore-incremental-cgroup-iteration
+++ a/mm/vmscan.c
@@ -128,6 +128,9 @@ struct scan_control {
 	unsigned int memcg_low_reclaim:1;
 	unsigned int memcg_low_skipped:1;
 
+	/* Shared cgroup tree walk failed, rescan the whole tree */
+	unsigned int memcg_full_walk:1;
+
 	unsigned int hibernation_mode:1;
 
 	/* One of the zones is ready for compaction */
@@ -5845,9 +5848,25 @@ static inline bool should_continue_recla
 static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 {
 	struct mem_cgroup *target_memcg = sc->target_mem_cgroup;
+	struct mem_cgroup_reclaim_cookie reclaim = {
+		.pgdat = pgdat,
+	};
+	struct mem_cgroup_reclaim_cookie *partial = &reclaim;
 	struct mem_cgroup *memcg;
 
-	memcg = mem_cgroup_iter(target_memcg, NULL, NULL);
+	/*
+	 * In most cases, direct reclaimers can do partial walks
+	 * through the cgroup tree, using an iterator state that
+	 * persists across invocations. This strikes a balance between
+	 * fairness and allocation latency.
+	 *
+	 * For kswapd, reliable forward progress is more important
+	 * than a quick return to idle. Always do full walks.
+	 */
+	if (current_is_kswapd() || sc->memcg_full_walk)
+		partial = NULL;
+
+	memcg = mem_cgroup_iter(target_memcg, NULL, partial);
 	do {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 		unsigned long reclaimed;
@@ -5897,7 +5916,12 @@ static void shrink_node_memcgs(pg_data_t
 				   sc->nr_scanned - scanned,
 				   sc->nr_reclaimed - reclaimed);
 
-	} while ((memcg = mem_cgroup_iter(target_memcg, memcg, NULL)));
+		/* If partial walks are allowed, bail once goal is reached */
+		if (partial && sc->nr_reclaimed >= sc->nr_to_reclaim) {
+			mem_cgroup_iter_break(target_memcg, memcg);
+			break;
+		}
+	} while ((memcg = mem_cgroup_iter(target_memcg, memcg, partial)));
 }
 
 static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
@@ -6271,6 +6295,20 @@ retry:
 		return 1;
 
 	/*
+	 * In most cases, direct reclaimers can do partial walks
+	 * through the cgroup tree to meet the reclaim goal while
+	 * keeping latency low. Since the iterator state is shared
+	 * among all direct reclaim invocations (to retain fairness
+	 * among cgroups), though, high concurrency can result in
+	 * individual threads not seeing enough cgroups to make
+	 * meaningful forward progress. Avoid false OOMs in this case.
+	 */
+	if (!sc->memcg_full_walk) {
+		sc->memcg_full_walk = 1;
+		goto retry;
+	}
+
+	/*
 	 * We make inactive:active ratio decisions based on the node's
 	 * composition of memory, but a restrictive reclaim_idx or a
 	 * memory.low cgroup setting can exempt large amounts of
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-restore-incremental-cgroup-iteration.patch

