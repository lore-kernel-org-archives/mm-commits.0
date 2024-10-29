Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E841FF618
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 04:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730176017; cv=none; b=ohnFZ5ag+qYRppWKVkil9MkQA2w8Z4dqjrfI10o+NWrOhcE5SRgMgBgEn649UyX5742Rspbm3gw1yDhAR+q0s6dOmh4n4qTTiEt5W4MQsabkct6BGk3gEpkJQUdfXWEvWjVqhTL6AWRGqZUy9G4/FXlzpJ059tnryG4H1OFBo98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730176017; c=relaxed/simple;
	bh=uD8Vi4mO80Cgq5YlfUc5YfDahkaaD/DfuptTtMvhoVM=;
	h=Date:To:From:Subject:Message-Id; b=t2vGfMzUh7jQg49QdKnLpo9tHEQlnB1CPFwA67o/dvLxeEZ4q4JGxPd8UVk5DupZv5wxZSIIcPqrJ5kuNEBoTsYLDI7Q2wxSygNJs58xs8LwPhp3tcsJgkqA47s2lZ6SUyScBPhYzbCBkdTEbsBd+DDnLZMzImpqbVimi6gD/T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hf4lr9V2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hf4lr9V2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E321C4CECD;
	Tue, 29 Oct 2024 04:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730176017;
	bh=uD8Vi4mO80Cgq5YlfUc5YfDahkaaD/DfuptTtMvhoVM=;
	h=Date:To:From:Subject:From;
	b=Hf4lr9V23TKPSefj2fkgvkRR/FjmjiNuYPsbKxKWWaB7BOKMGpte3tzuEDlKnm02z
	 hAtBBtPOjlBHWAS+WrRd7WBhpMtq58QpoV6Cm9qMbuVgclIWap7HkdUAupSUmdbGzi
	 T92TxvqMjPb6Hbs1Lv7CHJNNpvx4MXBlu6QrThWw=
Date: Mon, 28 Oct 2024 21:26:56 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,rostedt@goodmis.org,hannes@cmpxchg.org,inwardvessel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-rename-do_flush_stats-and-add-force-flag.patch added to mm-unstable branch
Message-Id: <20241029042657.2E321C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: rename do_flush_stats and add force flag
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-rename-do_flush_stats-and-add-force-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-rename-do_flush_stats-and-add-force-flag.patch

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
From: JP Kobryn <inwardvessel@gmail.com>
Subject: memcg: rename do_flush_stats and add force flag
Date: Mon, 28 Oct 2024 19:11:05 -0700

Patch series "memcg: tracepoint for flushing stats", v3.

This series adds new capability for understanding frequency and circumstances
behind flushing memcg stats.


This patch (of 2):

Change the name to something more consistent with others in the file and
use double unders to signify it is associated with the
mem_cgroup_flush_stats() API call.  Additionally include a new flag that
call sites use to indicate a forced flush; skipping checks and flushing
unconditionally.  There are no changes in functionality.

Link: https://lkml.kernel.org/r/20241029021106.25587-1-inwardvessel@gmail.com
Link: https://lkml.kernel.org/r/20241029021106.25587-2-inwardvessel@gmail.com
Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/mm/memcontrol.c~memcg-rename-do_flush_stats-and-add-force-flag
+++ a/mm/memcontrol.c
@@ -594,8 +594,11 @@ static inline void memcg_rstat_updated(s
 	}
 }
 
-static void do_flush_stats(struct mem_cgroup *memcg)
+static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
 {
+	if (!force && !memcg_vmstats_needs_flush(memcg->vmstats))
+		return;
+
 	if (mem_cgroup_is_root(memcg))
 		WRITE_ONCE(flush_last_time, jiffies_64);
 
@@ -619,8 +622,7 @@ void mem_cgroup_flush_stats(struct mem_c
 	if (!memcg)
 		memcg = root_mem_cgroup;
 
-	if (memcg_vmstats_needs_flush(memcg->vmstats))
-		do_flush_stats(memcg);
+	__mem_cgroup_flush_stats(memcg, false);
 }
 
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
@@ -636,7 +638,7 @@ static void flush_memcg_stats_dwork(stru
 	 * Deliberately ignore memcg_vmstats_needs_flush() here so that flushing
 	 * in latency-sensitive paths is as cheap as possible.
 	 */
-	do_flush_stats(root_mem_cgroup);
+	__mem_cgroup_flush_stats(root_mem_cgroup, true);
 	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
@@ -5291,11 +5293,8 @@ bool obj_cgroup_may_zswap(struct obj_cgr
 			break;
 		}
 
-		/*
-		 * mem_cgroup_flush_stats() ignores small changes. Use
-		 * do_flush_stats() directly to get accurate stats for charging.
-		 */
-		do_flush_stats(memcg);
+		/* Force flush to get accurate stats for charging */
+		__mem_cgroup_flush_stats(memcg, true);
 		pages = memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZE;
 		if (pages < max)
 			continue;
_

Patches currently in -mm which might be from inwardvessel@gmail.com are

memcg-rename-do_flush_stats-and-add-force-flag.patch
memcg-add-flush-tracepoint.patch

