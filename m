Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB9A2EFD95;
	Wed,  7 Oct 2026 00:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334210; cv=none; b=nRkPn6oHJMBHAb9/feBHPNKLqFchbuK8mop7WWn8ScWGbsxpRCUYWgYKSEihEipJuYJUSr0NrxA/yug0b2m3bXUYQKT8rAeN4jtAoF5IARY4m1Z4UGLDDuGwwXR18HdNPX+fSeI3OC1kWg0WypzfFKhi+R3jVTobyiExHY11dII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334210; c=relaxed/simple;
	bh=oNN6TP4BltXHQcOndG3cmc8pUI9jBb9PoMzfRz9SjfU=;
	h=Date:To:From:Subject:Message-Id; b=s/bhQ2uDANFGOJDcXTyYEY7/eHftHB2Boji1Mfzp1MMRToSJek8tau4lzX6BaKwzEWrAgt7Wp1EZT/Y3T64nghC2OrXR9OgeFdTFv988PzRtD9sTGO3lbrYzeTsC9eYHNlf6f9BN9OEx2Dlx1QROgUKGD6DRg6ozvSIMiU1l0Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cRud9dUR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cRud9dUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46471F0089B;
	Wed,  7 Oct 2026 00:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334208;
	bh=BrYdgWURON3os/gkhSCHSN8P7mYOxLBs6vbZbT0H9is=;
	h=Date:To:From:Subject;
	b=cRud9dURAwTWcS2+nfpq2J6M5xFXADc7xHAgPVT14aiLUdqAz9F26cj9yh9IsJIN9
	 W/xqChDwTt0y+eW0PDPdyk+FOazrum+UJiYxXMrOSwmoKdHDiNYb+WNjc5NkyYqEmJ
	 1wkUfUqe3a9Rl1lKDVH3VYmtJ0HFTCU4C/95pv2E=
Date: Tue, 06 Oct 2026 17:50:08 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,riel@surriel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-fix-stuck-flushing_cached_charge-bit-on-isolated-cpus.patch removed from -mm tree
Message-Id: <20261007005008.A46471F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit on isolated cpus
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-stuck-flushing_cached_charge-bit-on-isolated-cpus.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
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


