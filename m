Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB961428E1
	for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2024 20:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710274068; cv=none; b=Byz5qs1zV5p8nLQYRXSEZ0kZPrzfwgMHARcVJ3VxR2GGarePAs5ltKSV/C7Y30s5iiC6OXeMk6nSYh836u8A4de29MxZlh9Igzk22J44xnjwJKfo4Eq0589/q3dPUAgZL557gmS0U1YbSrW2n5wawiKfkQ1IXg4UVhpw+Ty1EsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710274068; c=relaxed/simple;
	bh=vTuyfKMStZ3CkeyeaoE7tLyOytk6GcKm7WhjcIi6Enw=;
	h=Date:To:From:Subject:Message-Id; b=utMnMMvecIm1GOc5J3OM0yuAV3n45DbGrMg0xY31AuT5PBoCrxgc5d4N6b5gSaWTMQ5vmrIlhLBHOc5akRk94Xwg7u9FJIKZ8/lWA6YIB2ZN959xavRBD7qq/FCehgD9ZLPT/kYCsweKdx8tkgu2knIxRGrOA+ozxjm6U0mEl50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LCQK78/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LCQK78/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB9EC43390;
	Tue, 12 Mar 2024 20:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710274068;
	bh=vTuyfKMStZ3CkeyeaoE7tLyOytk6GcKm7WhjcIi6Enw=;
	h=Date:To:From:Subject:From;
	b=LCQK78/vl92SN19XgjlJh40cVs5pl5xlUHJgpLw7r1pVfHW4462Tha7wi37zc7NyU
	 KjFg7/p3CrEM7vg18l2hAaGA9P38REp8PXMeiY6Daovs+fLT4BUQ0t+oj9RV4GtPir
	 CUZFL13H0mNQFk3epvDD2j5Rv8rGjTXP5242/Kmk=
Date: Tue, 12 Mar 2024 13:07:47 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,hannes@cmpxchg.org,byungchul@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-retry-kswapds-priority-loop-with-cache_trim_mode-off-on-failure.patch removed from -mm tree
Message-Id: <20240312200748.0CB9EC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, vmscan: retry kswapd's priority loop with cache_trim_mode off on failure
has been removed from the -mm tree.  Its filename was
     mm-vmscan-retry-kswapds-priority-loop-with-cache_trim_mode-off-on-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Byungchul Park <byungchul@sk.com>
Subject: mm, vmscan: retry kswapd's priority loop with cache_trim_mode off on failure
Date: Mon, 4 Mar 2024 15:27:37 +0900

With cache_trim_mode on, reclaim logic doesn't bother reclaiming anon
pages.  However, it should be more careful to use the mode because it's
going to prevent anon pages from being reclaimed even if there are a huge
number of anon pages that are cold and should be reclaimed.  Even worse,
that leads kswapd_failures to reach MAX_RECLAIM_RETRIES and stopping
kswapd from functioning until direct reclaim eventually works to resume
kswapd.

So kswapd needs to retry its scan priority loop with cache_trim_mode off
again if the mode doesn't work for reclaim.

The problematic behavior can be reproduced by:

   CONFIG_NUMA_BALANCING enabled
   sysctl_numa_balancing_mode set to NUMA_BALANCING_MEMORY_TIERING
   numa node0 (8GB local memory, 16 CPUs)
   numa node1 (8GB slow tier memory, no CPUs)

   Sequence:

   1) echo 3 > /proc/sys/vm/drop_caches
   2) To emulate the system with full of cold memory in local DRAM, run
      the following dummy program and never touch the region:

         mmap(0, 8 * 1024 * 1024 * 1024, PROT_READ | PROT_WRITE,
              MAP_ANONYMOUS | MAP_PRIVATE | MAP_POPULATE, -1, 0);

   3) Run any memory intensive work e.g. XSBench.
   4) Check if numa balancing is working e.i. promotion/demotion.
   5) Iterate 1) ~ 4) until numa balancing stops.

With this, you could see that promotion/demotion are not working because
kswapd has stopped due to ->kswapd_failures >= MAX_RECLAIM_RETRIES.

Interesting vmstat delta's differences between before and after are like:

   +-----------------------+-------------------------------+
   | interesting vmstat    | before        | after         |
   +-----------------------+-------------------------------+
   | nr_inactive_anon      | 321935        | 1664772       |
   | nr_active_anon        | 1780700       | 437834        |
   | nr_inactive_file      | 30425         | 40882         |
   | nr_active_file        | 14961         | 3012          |
   | pgpromote_success     | 356           | 1293122       |
   | pgpromote_candidate   | 21953245      | 1824148       |
   | pgactivate            | 1844523       | 3311907       |
   | pgdeactivate          | 50634         | 1554069       |
   | pgfault               | 31100294      | 6518806       |
   | pgdemote_kswapd       | 30856         | 2230821       |
   | pgscan_kswapd         | 1861981       | 7667629       |
   | pgscan_anon           | 1822930       | 7610583       |
   | pgscan_file           | 39051         | 57046         |
   | pgsteal_anon          | 386           | 2192033       |
   | pgsteal_file          | 30470         | 38788         |
   | pageoutrun            | 30            | 412           |
   | numa_hint_faults      | 27418279      | 2875955       |
   | numa_pages_migrated   | 356           | 1293122       |
   +-----------------------+-------------------------------+

Link: https://lkml.kernel.org/r/20240304082118.20499-1-byungchul@sk.com
Signed-off-by: Byungchul Park <byungchul@sk.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-retry-kswapds-priority-loop-with-cache_trim_mode-off-on-failure
+++ a/mm/vmscan.c
@@ -108,6 +108,12 @@ struct scan_control {
 	/* Can folios be swapped as part of reclaim? */
 	unsigned int may_swap:1;
 
+	/* Not allow cache_trim_mode to be turned on as part of reclaim? */
+	unsigned int no_cache_trim_mode:1;
+
+	/* Has cache_trim_mode failed at least once? */
+	unsigned int cache_trim_mode_failed:1;
+
 	/* Proactive reclaim invoked by userspace through memory.reclaim */
 	unsigned int proactive:1;
 
@@ -2271,7 +2277,8 @@ static void prepare_scan_control(pg_data
 	 * anonymous pages.
 	 */
 	file = lruvec_page_state(target_lruvec, NR_INACTIVE_FILE);
-	if (file >> sc->priority && !(sc->may_deactivate & DEACTIVATE_FILE))
+	if (file >> sc->priority && !(sc->may_deactivate & DEACTIVATE_FILE) &&
+	    !sc->no_cache_trim_mode)
 		sc->cache_trim_mode = 1;
 	else
 		sc->cache_trim_mode = 0;
@@ -5986,6 +5993,8 @@ again:
 	 */
 	if (reclaimable)
 		pgdat->kswapd_failures = 0;
+	else if (sc->cache_trim_mode)
+		sc->cache_trim_mode_failed = 1;
 }
 
 /*
@@ -6918,6 +6927,16 @@ restart:
 			sc.priority--;
 	} while (sc.priority >= 1);
 
+	/*
+	 * Restart only if it went through the priority loop all the way,
+	 * but cache_trim_mode didn't work.
+	 */
+	if (!sc.nr_reclaimed && sc.priority < 1 &&
+	    !sc.no_cache_trim_mode && sc.cache_trim_mode_failed) {
+		sc.no_cache_trim_mode = 1;
+		goto restart;
+	}
+
 	if (!sc.nr_reclaimed)
 		pgdat->kswapd_failures++;
 
_

Patches currently in -mm which might be from byungchul@sk.com are


