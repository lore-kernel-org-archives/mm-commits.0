Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30E62C6B7
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957107; cv=none; b=SjQKVOPS8Mw+FE2I9Pcav3HVy7nF0Ehp2wY8zATGMdj7fhjNtI+DsbfF9HATw2YPhVuiwY20/8obumhnilRD1XlhOon/WH+IZSD0I4xyrrRtacy7cJz63Gi5hJHkLTAypq10QVGRBh53rNoP5uZafWLaIarjHcJjqyaiJYcXdCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957107; c=relaxed/simple;
	bh=Iyz+Zjuffk1jMulLiY+ohGFSW/vgQ4CNmmkQMmilrNc=;
	h=Date:To:From:Subject:Message-Id; b=Rxwdg9sUfXLCaSu5wbFog8hBV56Nh5Nzqt7mpmzEF9X8f9Lm41TC2K9GyHwR5LCcFX3rWJs0Hc/+rK1pdTGAkZU/aDe0KZYTTuaUz5cIEP2RZMrI84eqgrq2pHcZCJ2Al4kxQkZ0RFkNDUJLo3KxmORQ/MfndZ1OpjcBY2NnYNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mBgM17fL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mBgM17fL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A79C113CC;
	Mon,  6 May 2024 00:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957107;
	bh=Iyz+Zjuffk1jMulLiY+ohGFSW/vgQ4CNmmkQMmilrNc=;
	h=Date:To:From:Subject:From;
	b=mBgM17fLF0J8EfzSEAX+/BAq1c8wcjol11kmMDD9UurSOwgAiJY2HvvbpdklS4Wpr
	 H/WFeLFIpFG4n9nWSO/sdgxpCr7xIt6od+P+r258gvqQXVd+kaPyTAi9p4l3ndIcHk
	 w3VoV+m46JrzGaoRAGhc2jJlpzZVL5SS6fZLrL3c=
Date: Sun, 05 May 2024 17:58:27 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-fix-data-race-kcsan-bug-in-rstats.patch removed from -mm tree
Message-Id: <20240506005827.87A79C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: fix data-race KCSAN bug in rstats
has been removed from the -mm tree.  Its filename was
     memcg-fix-data-race-kcsan-bug-in-rstats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: memcg: fix data-race KCSAN bug in rstats
Date: Wed, 24 Apr 2024 05:59:39 -0700

A data-race issue in memcg rstat occurs when two distinct code paths
access the same 4-byte region concurrently.  KCSAN detection triggers the
following BUG as a result.

	BUG: KCSAN: data-race in __count_memcg_events / mem_cgroup_css_rstat_flush

	write to 0xffffe8ffff98e300 of 4 bytes by task 5274 on cpu 17:
	mem_cgroup_css_rstat_flush (mm/memcontrol.c:5850)
	cgroup_rstat_flush_locked (kernel/cgroup/rstat.c:243 (discriminator 7))
	cgroup_rstat_flush (./include/linux/spinlock.h:401 kernel/cgroup/rstat.c:278)
	mem_cgroup_flush_stats.part.0 (mm/memcontrol.c:767)
	memory_numa_stat_show (mm/memcontrol.c:6911)
<snip>

	read to 0xffffe8ffff98e300 of 4 bytes by task 410848 on cpu 27:
	__count_memcg_events (mm/memcontrol.c:725 mm/memcontrol.c:962)
	count_memcg_event_mm.part.0 (./include/linux/memcontrol.h:1097 ./include/linux/memcontrol.h:1120)
	handle_mm_fault (mm/memory.c:5483 mm/memory.c:5622)
<snip>

	value changed: 0x00000029 -> 0x00000000

The race occurs because two code paths access the same "stats_updates"
location.  Although "stats_updates" is a per-CPU variable, it is remotely
accessed by another CPU at
cgroup_rstat_flush_locked()->mem_cgroup_css_rstat_flush(), leading to the
data race mentioned.

Considering that memcg_rstat_updated() is in the hot code path, adding a
lock to protect it may not be desirable, especially since this variable
pertains solely to statistics.

Therefore, annotating accesses to stats_updates with READ/WRITE_ONCE() can
prevent KCSAN splats and potential partial reads/writes.

Link: https://lkml.kernel.org/r/20240424125940.2410718-1-leitao@debian.org
Fixes: 9cee7e8ef3e3 ("mm: memcg: optimize parent iteration in memcg_rstat_updated()")
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~memcg-fix-data-race-kcsan-bug-in-rstats
+++ a/mm/memcontrol.c
@@ -715,6 +715,7 @@ static inline void memcg_rstat_updated(s
 {
 	struct memcg_vmstats_percpu *statc;
 	int cpu = smp_processor_id();
+	unsigned int stats_updates;
 
 	if (!val)
 		return;
@@ -722,8 +723,9 @@ static inline void memcg_rstat_updated(s
 	cgroup_rstat_updated(memcg->css.cgroup, cpu);
 	statc = this_cpu_ptr(memcg->vmstats_percpu);
 	for (; statc; statc = statc->parent) {
-		statc->stats_updates += abs(val);
-		if (statc->stats_updates < MEMCG_CHARGE_BATCH)
+		stats_updates = READ_ONCE(statc->stats_updates) + abs(val);
+		WRITE_ONCE(statc->stats_updates, stats_updates);
+		if (stats_updates < MEMCG_CHARGE_BATCH)
 			continue;
 
 		/*
@@ -731,9 +733,9 @@ static inline void memcg_rstat_updated(s
 		 * redundant. Avoid the overhead of the atomic update.
 		 */
 		if (!memcg_vmstats_needs_flush(statc->vmstats))
-			atomic64_add(statc->stats_updates,
+			atomic64_add(stats_updates,
 				     &statc->vmstats->stats_updates);
-		statc->stats_updates = 0;
+		WRITE_ONCE(statc->stats_updates, 0);
 	}
 }
 
@@ -5887,7 +5889,7 @@ static void mem_cgroup_css_rstat_flush(s
 			}
 		}
 	}
-	statc->stats_updates = 0;
+	WRITE_ONCE(statc->stats_updates, 0);
 	/* We are in a per-cpu loop here, only do the atomic write once */
 	if (atomic64_read(&memcg->vmstats->stats_updates))
 		atomic64_set(&memcg->vmstats->stats_updates, 0);
_

Patches currently in -mm which might be from leitao@debian.org are


