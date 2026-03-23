Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581F438736A
	for <mm-commits@vger.kernel.org>; Mon, 23 Mar 2026 17:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774286646; cv=none; b=c7h0nIA1KSNlIjU1ssWgN5ad5E1vrcUgGq0eCEhBlSLR1U4Hr+bsAEBBNufcxj29pME4RSIfsUlG+qwRxqq+KKRQnZfq3E0hJ71vy4gyOw8rYlv0pfV6rScXF02uZJDEmMf2h8rc/ATS49E7k31fc8a2x7MPnyZpGmK1pC3ICJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774286646; c=relaxed/simple;
	bh=iTRvHr5CosEKYfORZ67WYLhj8wYcpBGfMpCLQ+g+Dz8=;
	h=Date:To:From:Subject:Message-Id; b=YTvxm08jSYNQYGporUyVG1ojRFIZSXfbaAp7jU5KuV/65DoyfKLiSz7bKONAb6fILYwD0046d7gDp6OxpRO8NtAtVWhvlyuCdSS3JcS8+Spq8N+lqEWC6df9S6tzE1F3G4Jn8APTDBBbqmadql3ascKoToWlVEoRw5fIDtRCPQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sj1VOd3/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sj1VOd3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF356C4CEF7;
	Mon, 23 Mar 2026 17:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774286646;
	bh=iTRvHr5CosEKYfORZ67WYLhj8wYcpBGfMpCLQ+g+Dz8=;
	h=Date:To:From:Subject:From;
	b=Sj1VOd3/hsvXFWpZBoU4rxpS5qTth43qeLiig4pr6pz5fA38siJ+H4NZgyrwXrRL8
	 LACUm6HGAe6kYIf7TNgtm4HRue8kepkWBR3mw5HR7lTMctgV4jmalviK0vHO0+LKUK
	 Zifl9Dioxl1PR9gXSDt5Sf9SNJufT4yb2f/dGlnA=
Date: Mon, 23 Mar 2026 10:24:05 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,rostedt@goodmis.org,ritesh.list@gmail.com,peterz@infradead.org,mingo@redhat.com,mgorman@suse.de,juri.lelli@redhat.com,huang.ying.caritas@gmail.com,dietmar.eggemann@arm.com,david@kernel.org,bsegall@google.com,baolin.wang@linux.alibaba.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tiering-do-not-allow-promotion-if-numa_balancing_memory_tiering-is-disabled.patch added to mm-new branch
Message-Id: <20260323172405.EF356C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memory tiering: do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
has been added to the -mm mm-new branch.  Its filename is
     memory-tiering-do-not-allow-promotion-if-numa_balancing_memory_tiering-is-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tiering-do-not-allow-promotion-if-numa_balancing_memory_tiering-is-disabled.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Donet Tom <donettom@linux.ibm.com>
Subject: memory tiering: do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
Date: Mon, 23 Mar 2026 04:48:49 -0500

In the current implementation, if NUMA_BALANCING_MEMORY_TIERING is
disabled and the pages are on the lower tier, the pages may still be
promoted.

This happens because task_numa_work() updates the last_cpupid field to
record the last access time only when NUMA_BALANCING_MEMORY_TIERING is
enabled and the folio is on the lower tier.  If
NUMA_BALANCING_MEMORY_TIERING is disabled, the last_cpupid field can
retains a valid last CPU id.

In should_numa_migrate_memory(), the decision checks whether
NUMA_BALANCING_MEMORY_TIERING is disabled, the folio is on the lower tier,
and last_cpupid is invalid.  However, the last_cpupid can be valid when
NUMA_BALANCING_MEMORY_TIERING is disabled, the condition evaluates to
false and migration is allowed.

This patch prevents promotion when NUMA_BALANCING_MEMORY_TIERING is
disabled and the folio is on the lower tier.

Behavior before this change:
============================
  - If NUMA_BALANCING_NORMAL is enabled, migration occurs between
    nodes within the same memory tier, and promotion from lower
    tier to higher tier may also happen.

  - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from
    lower tier to higher tier nodes is allowed.

Behavior after this change:
===========================
  - If NUMA_BALANCING_NORMAL is enabled, migration will occur only
    between nodes within the same memory tier.

  - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from lower
    tier to higher tier nodes will be allowed.

  - If both NUMA_BALANCING_MEMORY_TIERING and NUMA_BALANCING_NORMAL are
    enabled, both migration (same tier) and promotion (cross tier) are
    allowed.

Link: https://lkml.kernel.org/r/20260323094849.3903-1-donettom@linux.ibm.com
Fixes: 33024536bafd ("memory tiering: hot page selection with hint page fault latency")
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ben Segall <bsegall@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: "Huang, Ying" <huang.ying.caritas@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/sched/fair.c~memory-tiering-do-not-allow-promotion-if-numa_balancing_memory_tiering-is-disabled
+++ a/kernel/sched/fair.c
@@ -2024,8 +2024,12 @@ bool should_numa_migrate_memory(struct t
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
 	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
 
+	/*
+	 * Do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
+	 * and the pages are on the lower tier.
+	 */
 	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
-	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
+	    !node_is_toptier(src_nid))
 		return false;
 
 	/*
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

memory-tiering-do-not-allow-promotion-if-numa_balancing_memory_tiering-is-disabled.patch

