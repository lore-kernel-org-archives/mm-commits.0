Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0993515D4;
	Fri, 28 Aug 2026 19:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787944882; cv=none; b=kiHgW842uzlmp9XES4xcewqvbGTnRQDZVkdIKpGcyw9Dr9AVtcrSbR2XUQUKrF4DgRDpGKtvkr/o6bZ1LWWr8AlXZtCzh1kJzI6MANmg1QPCwjYizPgrksaPiP/EDF8VpaSMTcH3XiIiwarCo6Eo35mBkSo4dBCg1iEJ1LiU2MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787944882; c=relaxed/simple;
	bh=nTNkf0XnH0unR2bJpeFCa08cOylFM15AT6EKrqyG+54=;
	h=Date:To:From:Subject:Message-Id; b=U1CzQRH1WBaZhvoz/x2oKpiNgIk6W/lvsbYiGuhRN3HPenrXNDzUQnsyj2feku6irJ4IlZAAF+vf8zXzIbkiRAEWIiV+ZxsX/rT5qS32p9qOrG18cszGF63btdsaJo0LDgKyITzOwSUDIdl6c0LuXEEmUpDEPFYUpPATmsmS/yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LIEz/86S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LIEz/86S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991481F00A3E;
	Fri, 28 Aug 2026 19:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787944880;
	bh=6lJcR8HLMfcfSyUb7aEi9Pbge4iCWRlvJpoCX9I+0iw=;
	h=Date:To:From:Subject;
	b=LIEz/86S8pv7dvFbGf5JLIl+6XCl/dvynMoR5vxTu8snGA9ygNleVZWCZFNQPRgJ8
	 xYS8E9zhM7v7ER3VPgd0+Rx8LVDHTeQsaM9OlmJDl9Tx95OcuyKCR7iykv7HFTfFyE
	 1WaEhOCOqgQ4btkwfzvuaVkwXoBwv7ZNEvXFtBo4=
Date: Fri, 28 Aug 2026 12:21:20 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,riel@surriel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-fix-stuck-flushing_cached_charge-bit-on-isolated-cpus.patch added to mm-new branch
Message-Id: <20260828192120.991481F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit on isolated cpus
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-fix-stuck-flushing_cached_charge-bit-on-isolated-cpus.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-fix-stuck-flushing_cached_charge-bit-on-isolated-cpus.patch

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
From: Rik van Riel <riel@surriel.com>
Subject: mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit on isolated cpus
Date: Fri, 28 Aug 2026 13:50:36 -0400

When drain_all_stock() sets FLUSHING_CACHED_CHARGE before checking
isolation, schedule_drain_work() can drop the work in a separate RCU
critical section, and housekeeping_update()'s synchronize_rcu() can race
that second check, leaving the flag set.

drain_local_stock() only clears the bit for work that ran, so the flag
remains set and the stock is never drained again.

Have schedule_drain_work() return whether the work was queued, and clear
FLUSHING_CACHED_CHARGE in drain_all_stock() when the remote CPU is
isolated, so future drains can retry.

Link: https://lore.kernel.org/20260828135036.7d44361f@fangorn
Fixes: 6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated cpus")
Suggested-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Rik van Riel <riel@surriel.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-stuck-flushing_cached_charge-bit-on-isolated-cpus
+++ a/mm/memcontrol.c
@@ -2306,7 +2306,7 @@ static bool is_memcg_drain_needed(struct
 	return flush;
 }
 
-static void schedule_drain_work(int cpu, struct work_struct *work)
+static bool schedule_drain_work(int cpu, struct work_struct *work)
 {
 	/*
 	 * Protect housekeeping cpumask read and work enqueue together
@@ -2315,8 +2315,11 @@ static void schedule_drain_work(int cpu,
 	 * pending work on newly isolated CPUs.
 	 */
 	guard(rcu)();
-	if (!cpu_is_isolated(cpu))
-		queue_work_on(cpu, memcg_wq, work);
+	if (cpu_is_isolated(cpu))
+		return false;
+
+	queue_work_on(cpu, memcg_wq, work);
+	return true;
 }
 
 /*
@@ -2348,8 +2351,9 @@ void drain_all_stock(struct mem_cgroup *
 				      &memcg_st->flags)) {
 			if (cpu == curcpu)
 				drain_local_memcg_stock(&memcg_st->work);
-			else
-				schedule_drain_work(cpu, &memcg_st->work);
+			else if (!schedule_drain_work(cpu, &memcg_st->work))
+				clear_bit(FLUSHING_CACHED_CHARGE,
+					  &memcg_st->flags);
 		}
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
@@ -2358,8 +2362,9 @@ void drain_all_stock(struct mem_cgroup *
 				      &obj_st->flags)) {
 			if (cpu == curcpu)
 				drain_local_obj_stock(&obj_st->work);
-			else
-				schedule_drain_work(cpu, &obj_st->work);
+			else if (!schedule_drain_work(cpu, &obj_st->work))
+				clear_bit(FLUSHING_CACHED_CHARGE,
+					  &obj_st->flags);
 		}
 	}
 	migrate_enable();
_

Patches currently in -mm which might be from riel@surriel.com are

mm-memcontrol-fix-stuck-flushing_cached_charge-bit-on-isolated-cpus.patch

