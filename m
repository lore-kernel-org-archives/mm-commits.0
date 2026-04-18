Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFB234F48E
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499151; cv=none; b=SSgvFwCdfXo5RSgsUAumT4cyGczEq4OX08Kwj6TjU2RgMTafpamPwTBFlrFsSZpGYPaoQxAxYggYbjkaExxK5+j7DeysutXsbgjJhef8B0dalj3VoVav0QvgXB/WsA3jmFpZEIboMbs6Bj9CQ1lU3bPMPZtkKQ8AfKnktyiz2zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499151; c=relaxed/simple;
	bh=oDsBj52L1V8i76ckT1A6QFsVCK7qh2BrQN6+Z8I0Jzk=;
	h=Date:To:From:Subject:Message-Id; b=hijXes5I2kHLnyl/XBaI9w42Hmva4pFDAZaqDEb+T7b1ZI64AVcvi1Vt0vuPV6BA1NwsR7bKRI6krLv6ZyJR31UJzbRIodf4NMNjkvGycIStVhDLb8LeNaO3EtQRoYU8qnBWpd6McqkbMoqMnO9oWMn0zqQCJOse/TA67zkX1u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mAjZTpOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mAjZTpOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C64DC19424;
	Sat, 18 Apr 2026 07:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499151;
	bh=oDsBj52L1V8i76ckT1A6QFsVCK7qh2BrQN6+Z8I0Jzk=;
	h=Date:To:From:Subject:From;
	b=mAjZTpOR7QtYeX5X1DVB8Ctzt7XYJQIkXRt2s5C+WhyV4N4hUeoi0BWJmGB2eXT5I
	 euxD1eJlDHnxizLcgSPXShRGXLeiTRN8TfbsZRJbkxzmU42QSHDoagCPlC5YQGfFui
	 xHP5XAmm5SynVoWIoQCkjqta8XlXRm+tN1rzp7UE=
Date: Sat, 18 Apr 2026 00:59:06 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,d@ilvokhin.com,david@kernel.org,cl@linux.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmstat-fix-vmstat_shepherd-double-scheduling-vmstat_update.patch removed from -mm tree
Message-Id: <20260418075910.4C64DC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmstat: fix vmstat_shepherd double-scheduling vmstat_update
has been removed from the -mm tree.  Its filename was
     mm-vmstat-fix-vmstat_shepherd-double-scheduling-vmstat_update.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/vmstat: fix vmstat_shepherd double-scheduling vmstat_update
Date: Thu, 09 Apr 2026 05:26:36 -0700

vmstat_shepherd uses delayed_work_pending() to check whether vmstat_update
is already scheduled for a given CPU before queuing it.  However,
delayed_work_pending() only tests WORK_STRUCT_PENDING_BIT, which is
cleared the moment a worker thread picks up the work to execute it.

This means that while vmstat_update is actively running on a CPU,
delayed_work_pending() returns false.  If need_update() also returns true
at that point (per-cpu counters not yet zeroed mid-flush), the shepherd
queues a second invocation with delay=0, causing vmstat_update to run
again immediately after finishing.

On a 72-CPU system this race is readily observable: before the fix, many
CPUs show invocation gaps well below 500 jiffies (the minimum
round_jiffies_relative() can produce), with the most extreme cases
reaching 0 jiffies—vmstat_update called twice within the same jiffy.

Fix this by replacing delayed_work_pending() with work_busy(), which
returns non-zero for both WORK_BUSY_PENDING (timer armed or work queued)
and WORK_BUSY_RUNNING (work currently executing).  The shepherd now
correctly skips a CPU in all busy states.

After the fix, all sub-jiffy and most sub-100-jiffie gaps disappear.  The
remaining early invocations have gaps in the 700–999 jiffie range,
attributable to round_jiffies_relative() aligning to a nearer
jiffie-second boundary rather than to this race.

Each spurious vmstat_update invocation has a measurable side effect:
refresh_cpu_vm_stats() calls decay_pcp_high() for every zone, which drains
idle per-CPU pages back to the buddy allocator via free_pcppages_bulk(),
taking the zone spinlock each time.  Eliminating the double-scheduling
therefore reduces zone lock contention directly.  On a 72-CPU stress-ng
workload measured with perf lock contention:

  free_pcppages_bulk contention count:  ~55% reduction
  free_pcppages_bulk total wait time:   ~57% reduction
  free_pcppages_bulk max wait time:     ~47% reduction

Note: work_busy() is inherently racy—between the check and the
subsequent queue_delayed_work_on() call, vmstat_update can finish
execution, leaving the work neither pending nor running.  In that narrow
window the shepherd can still queue a second invocation.  After the fix,
this residual race is rare and produces only occasional small gaps, a
significant improvement over the systematic double-scheduling seen with
delayed_work_pending().

Link: https://lore.kernel.org/20260409-vmstat-v2-1-e9d9a6db08ad@debian.org
Fixes: 7b8da4c7f07774 ("vmstat: get rid of the ugly cpu_stat_off variable")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmstat.c~mm-vmstat-fix-vmstat_shepherd-double-scheduling-vmstat_update
+++ a/mm/vmstat.c
@@ -2139,7 +2139,7 @@ static void vmstat_shepherd(struct work_
 			if (cpu_is_isolated(cpu))
 				continue;
 
-			if (!delayed_work_pending(dw) && need_update(cpu))
+			if (!work_busy(&dw->work) && need_update(cpu))
 				queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
 		}
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-blk-cgroup-fix-use-after-free-in-cgwb_release_workfn.patch
kho-fix-error-handling-in-kho_add_subtree.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

