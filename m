Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50572737E2;
	Tue, 29 Jul 2025 20:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753822038; cv=none; b=CFQ64BOobqDlp3ZbIK5aZ3bdDFmqtszyCHmznMrZlDYu6Ry2NLNKOuEsYwoAzcSGMQsCfWhhosMmnbHjord4ZdF6HjZ56Zwsj93U/DPghdKMLs9GgNZRpEFWC+HLLrI1MMhQbC81tHPdxCJ5SyLDjFDeoWwE/+TX/bOuPQLD23U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753822038; c=relaxed/simple;
	bh=lMhU8hiUwITy1gL9Pst+TfEe9J8Ku41SbGJDulE/98Y=;
	h=Date:To:From:Subject:Message-Id; b=KjIJmn+Lzmw9Mb2vEIf+TDN1j0SqGDelylfjjOHxxYT0uTWO7S6mO/DoNQUzwEbR6a2bhYSA2Q4WolTZFN/bHwlHnZgDgwRjId4QtX/FVSGlQkJbionoTxyqC2VUygjKdTaFqZwfAlJltyTnduRwjlozN4h/zSpDEmAublTJ2SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jRvmT0vP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jRvmT0vP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D65C4CEEF;
	Tue, 29 Jul 2025 20:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753822037;
	bh=lMhU8hiUwITy1gL9Pst+TfEe9J8Ku41SbGJDulE/98Y=;
	h=Date:To:From:Subject:From;
	b=jRvmT0vPZxaKrEB8L+XC22skjjPPe/j479a+tlOHeZa+fCmx5FnwPR2t2CSZhUmDJ
	 ljhAQs3WHr68kB3fCgRhb2a6bJjMKXFZSVAalWldNuMY+JRb0d31MdLMKwtE+hOpRG
	 vg22lr3KKCMk1/V1yLp1iJBUdQnVPCEmMafWm24A=
Date: Tue, 29 Jul 2025 13:47:16 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,y-goto@fujitsu.com,vschneid@redhat.com,vincent.guittot@linaro.org,stable@vger.kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mgorman@suse.de,lizhijian@fujitsu.com,juri.lelli@redhat.com,dietmar.eggemann@arm.com,bsegall@google.com,ruansy.fnst@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-tiering-fix-pgpromote_candidate-counting.patch added to mm-new branch
Message-Id: <20250729204717.57D65C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory-tiering: fix PGPROMOTE_CANDIDATE counting
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-tiering-fix-pgpromote_candidate-counting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-tiering-fix-pgpromote_candidate-counting.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Ruan Shiyang <ruansy.fnst@fujitsu.com>
Subject: mm: memory-tiering: fix PGPROMOTE_CANDIDATE counting
Date: Tue, 29 Jul 2025 11:51:01 +0800

Goto-san reported confusing pgpromote statistics where the
pgpromote_success count significantly exceeded pgpromote_candidate.

On a system with three nodes (nodes 0-1: DRAM 4GB, node 2: NVDIMM 4GB):
 # Enable demotion only
 echo 1 > /sys/kernel/mm/numa/demotion_enabled
 numactl -m 0-1 memhog -r200 3500M >/dev/null &
 pid=$!
 sleep 2
 numactl memhog -r100 2500M >/dev/null &
 sleep 10
 kill -9 $pid # terminate the 1st memhog
 # Enable promotion
 echo 2 > /proc/sys/kernel/numa_balancing

After a few seconds, we observeed `pgpromote_candidate < pgpromote_success`
$ grep -e pgpromote /proc/vmstat
pgpromote_success 2579
pgpromote_candidate 0

In this scenario, after terminating the first memhog, the conditions for
pgdat_free_space_enough() are quickly met, and triggers promotion. 
However, these migrated pages are only counted for in PGPROMOTE_SUCCESS,
not in PGPROMOTE_CANDIDATE.

To solve these confusing statistics, introduce PGPROMOTE_CANDIDATE_NRL to
count the missed promotion pages.  And also, not counting these pages into
PGPROMOTE_CANDIDATE is to avoid changing the existing algorithm or
performance of the promotion rate limit.

Link: https://lkml.kernel.org/r/20250729035101.1601407-1-ruansy.fnst@fujitsu.com
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Signed-off-by: Ruan Shiyang <ruansy.fnst@fujitsu.com>
Reported-by: Yasunori Gotou (Fujitsu) <y-goto@fujitsu.com>
Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   16 +++++++++++++++-
 kernel/sched/fair.c    |    5 +++--
 mm/vmstat.c            |    1 +
 3 files changed, 19 insertions(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mm-memory-tiering-fix-pgpromote_candidate-counting
+++ a/include/linux/mmzone.h
@@ -234,7 +234,21 @@ enum node_stat_item {
 #endif
 #ifdef CONFIG_NUMA_BALANCING
 	PGPROMOTE_SUCCESS,	/* promote successfully */
-	PGPROMOTE_CANDIDATE,	/* candidate pages to promote */
+	/**
+	 * Candidate pages for promotion based on hint fault latency.  This
+	 * counter is used to control the promotion rate and adjust the hot
+	 * threshold.
+	 */
+	PGPROMOTE_CANDIDATE,
+	/**
+	 * Not rate-limited (NRL) candidate pages for those can be promoted
+	 * without considering hot threshold because of enough free pages in
+	 * fast-tier node.  These promotions bypass the regular hotness checks
+	 * and do NOT influence the promotion rate-limiter or
+	 * threshold-adjustment logic.
+	 * This is for statistics/monitoring purposes.
+	 */
+	PGPROMOTE_CANDIDATE_NRL,
 #endif
 	/* PGDEMOTE_*: pages demoted */
 	PGDEMOTE_KSWAPD,
--- a/kernel/sched/fair.c~mm-memory-tiering-fix-pgpromote_candidate-counting
+++ a/kernel/sched/fair.c
@@ -1940,11 +1940,13 @@ bool should_numa_migrate_memory(struct t
 		struct pglist_data *pgdat;
 		unsigned long rate_limit;
 		unsigned int latency, th, def_th;
+		long nr = folio_nr_pages(folio);
 
 		pgdat = NODE_DATA(dst_nid);
 		if (pgdat_free_space_enough(pgdat)) {
 			/* workload changed, reset hot threshold */
 			pgdat->nbp_threshold = 0;
+			mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NRL, nr);
 			return true;
 		}
 
@@ -1958,8 +1960,7 @@ bool should_numa_migrate_memory(struct t
 		if (latency >= th)
 			return false;
 
-		return !numa_promotion_rate_limit(pgdat, rate_limit,
-						  folio_nr_pages(folio));
+		return !numa_promotion_rate_limit(pgdat, rate_limit, nr);
 	}
 
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
--- a/mm/vmstat.c~mm-memory-tiering-fix-pgpromote_candidate-counting
+++ a/mm/vmstat.c
@@ -1280,6 +1280,7 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_NUMA_BALANCING
 	[I(PGPROMOTE_SUCCESS)]			= "pgpromote_success",
 	[I(PGPROMOTE_CANDIDATE)]		= "pgpromote_candidate",
+	[I(PGPROMOTE_CANDIDATE_NRL)]		= "pgpromote_candidate_nrl",
 #endif
 	[I(PGDEMOTE_KSWAPD)]			= "pgdemote_kswapd",
 	[I(PGDEMOTE_DIRECT)]			= "pgdemote_direct",
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are

mm-memory-tiering-fix-pgpromote_candidate-counting.patch

