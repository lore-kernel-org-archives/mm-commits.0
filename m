Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4028C07
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600519; cv=none; b=Dg4aYEED95tzNL73o8YKapwzUks1rTo5l2R4m2QDkOQRqfQGX5lYZotiOjgfhz/KmUa53oP/m09/gLHn4sGGfFQ9gyDTDzlauowPOCHJrO+QjoCjC3arK+p5nB9CcT04jpE5JYz4+54b7/33m2m0ZpFGCzh9hYBVyOwuAfxweCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600519; c=relaxed/simple;
	bh=2YwtvBiESy/eHN+2nFTB/nfy4+yTxNWfzoYfiRxkn7s=;
	h=Date:To:From:Subject:Message-Id; b=dZBcIJb5R/MnFwnC9djCoSnLoE8XRyzYZaWYV+RR99Rcvo7NFFVFNI2R24evSg/IFKEzU2mNoS6HWi1/QImtyaMr90RRWECK0fLf76gF20Wuf10HdRKejcn3Ux3FSIg0a/rZ0T5RP4JPu5WonOZm7VMh1MRMMPW0iGIrVy3Bse8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ir1ftLqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ir1ftLqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60473C433C7;
	Tue,  5 Mar 2024 01:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600519;
	bh=2YwtvBiESy/eHN+2nFTB/nfy4+yTxNWfzoYfiRxkn7s=;
	h=Date:To:From:Subject:From;
	b=Ir1ftLqJGUAZboo9eHzEZ+CH29ho1RYg2w+NqWt1OkR4Q+py6H0dQVcgkatUNuxZ8
	 2wUBkoyClHVy9xJ4D9YQwyYnir9bX8wFVhaZ0XBOtjcWAlmCzzGGM/coNFI+WWQ6zu
	 3tZ+b6KqEPYvnlF773rnPjEddRDWgMYYFZJHRzT0=
Date: Mon, 04 Mar 2024 17:01:58 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,vschneid@redhat.com,vincent.guittot@linaro.org,rostedt@goodmis.org,peterz@infradead.org,pauld@redhat.com,osalvador@suse.de,mingo@redhat.com,mgorman@suse.de,juri.lelli@redhat.com,dietmar.eggemann@arm.com,david@redhat.com,dave@stgolabs.net,bsegall@google.com,bristot@redhat.com,byungchul@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sched-numa-mm-do-not-try-to-migrate-memory-to-memoryless-nodes.patch removed from -mm tree
Message-Id: <20240305010159.60473C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sched/numa, mm: do not try to migrate memory to memoryless nodes
has been removed from the -mm tree.  Its filename was
     sched-numa-mm-do-not-try-to-migrate-memory-to-memoryless-nodes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Byungchul Park <byungchul@sk.com>
Subject: sched/numa, mm: do not try to migrate memory to memoryless nodes
Date: Mon, 19 Feb 2024 13:10:47 +0900

Memoryless nodes do not have any memory to migrate to, so, as an
optimization, stop trying it.

Link: https://lkml.kernel.org/r/20240219041920.1183-1-byungchul@sk.com
Link: https://lkml.kernel.org/r/20240216111502.79759-1-byungchul@sk.com
Fixes: c574bbe91703 ("NUMA balancing: optimize page placement for memory tiering system")
Signed-off-by: Byungchul Park <byungchul@sk.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Phil Auld <pauld@redhat.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Benjamin Segall <bsegall@google.com>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/sched/fair.c~sched-numa-mm-do-not-try-to-migrate-memory-to-memoryless-nodes
+++ a/kernel/sched/fair.c
@@ -1831,6 +1831,12 @@ bool should_numa_migrate_memory(struct t
 	int last_cpupid, this_cpupid;
 
 	/*
+	 * Cannot migrate to memoryless nodes.
+	 */
+	if (!node_state(dst_nid, N_MEMORY))
+		return false;
+
+	/*
 	 * The pages in slow memory node should be migrated according
 	 * to hot/cold instead of private/shared.
 	 */
_

Patches currently in -mm which might be from byungchul@sk.com are

mm-vmscan-retry-kswapds-priority-loop-with-cache_trim_mode-off-on-failure.patch

