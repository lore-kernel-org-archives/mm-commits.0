Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAA81DF748
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 03:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775101583; cv=none; b=tew0d4jY4q0pMg78VPmkVu3VufOPLuLPGFbUHpkuif+XqErPVVxXlyWU1DDB9IBbpzMj0PaAp4lEi6RYn8XZK3mdh6tHqWAZ0GCdQi8th+Xgl8Zzw1VzZIx8KNV0rU+xcH04JxIU2kpLiakcJk9PAyQ5lo+N6F3rhKFx6cS/D44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775101583; c=relaxed/simple;
	bh=fTNsXo4PsLFdIOgWTN8PhE3XeAcv6F5qY5ZyLY/zgzA=;
	h=Date:To:From:Subject:Message-Id; b=klHnCMJ0s/q/0dqaFQwiRLzrnqf/5Hf+j50EeSRiW35PksmA86atSSpNlbwDwPqkV2nYHCzre5VTJpLAAgpN11WFK7AmALwGuMFwpmPdnmURBKGHHUvBTDVsxp87InLeSINN9xV41Xrb0kWnfJkVe3h0uiloLwdJEpZRNKJfyQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DJHFoM69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DJHFoM69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DBAC19423;
	Thu,  2 Apr 2026 03:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775101583;
	bh=fTNsXo4PsLFdIOgWTN8PhE3XeAcv6F5qY5ZyLY/zgzA=;
	h=Date:To:From:Subject:From;
	b=DJHFoM69wU3MJFKlGnEdpiNr+XI0kuRZocaSUKaIGHzTZsPXEEWMgsbqI/kEeBbNK
	 TAU/YoFRuMgfv22VWti/i5B8wnHUFcx6/OuPZjI9LP+yfAYArinHY+EI2PqeYvi2Bf
	 sH4fekcRpiJcHJ097tIwQYsyg6lvEECZPCWEWbEo=
Date: Wed, 01 Apr 2026 20:46:22 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,rostedt@goodmis.org,ritesh.list@gmail.com,peterz@infradead.org,mingo@redhat.com,mgorman@suse.de,juri.lelli@redhat.com,huang.ying.caritas@gmail.com,dietmar.eggemann@arm.com,david@kernel.org,bsegall@google.com,baolin.wang@linux.alibaba.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] memory-tiering-do-not-allow-promotion-if-numa_balancing_memory_tiering-is-disabled.patch removed from -mm tree
Message-Id: <20260402034623.46DBAC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memory tiering: do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
has been removed from the -mm tree.  Its filename was
     memory-tiering-do-not-allow-promotion-if-numa_balancing_memory_tiering-is-disabled.patch

This patch was dropped because it was nacked

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


