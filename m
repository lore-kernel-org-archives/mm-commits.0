Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B522D057
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247849; cv=none; b=m+3V2bck6r1Y7LptGd08jwTbjc921W73jrR78tCadpIyjHy/Iddm2JiAPQ6qxpKv/yORrIUbbtig6DRpYoAUjWIVy3Vz6pc8kMiop+qb7R9GpasVWpOpS15P+0i1BEOs/zaV/PuSnHxhbkyxyD4p3qcJw7hPKIS/AcXDIMmkhb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247849; c=relaxed/simple;
	bh=pqedANgrsnXOS4qn4xe0S60GUHOaeULaZlE6gfc4WAU=;
	h=Date:To:From:Subject:Message-Id; b=f8NKPIbBs3i0sXWhdXZpIy7CZgVT5tmlNt510pM+s6S0u0o6s6DD0tlBDlI2gmGpv9CZszfiDOn7qI1aCJt+3jK87mdpf3KyTjUH4luAhr1ijwryUKWxStdYdhgvKX8HR4b7fBRyr2vOEOrdQTXKoe3nP3Yzdoc2mbnneIn61mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UJo3rRsI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UJo3rRsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D32AC4CEC2;
	Mon,  2 Sep 2024 03:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247849;
	bh=pqedANgrsnXOS4qn4xe0S60GUHOaeULaZlE6gfc4WAU=;
	h=Date:To:From:Subject:From;
	b=UJo3rRsI+js+bBTm0Sh4lTWi82UHlMd09edOKqRb0mCictxNTeGgMzkPs3Q/yKjGA
	 ueG83lYqspNcRn8ormNhEiz1FMYyJ3r7C3wKRZZAl6Cta9mBvAMZU1Q4gQvVCAq/fP
	 iLM4P5qAxTwvbulOWDyLjqas/1gV9yZybN2GVkFg=
Date: Sun, 01 Sep 2024 20:30:48 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-move-mem_cgroup_event_ratelimit-to-v1-code.patch removed from -mm tree
Message-Id: <20240902033049.3D32AC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: move mem_cgroup_event_ratelimit to v1 code
has been removed from the -mm tree.  Its filename was
     memcg-move-mem_cgroup_event_ratelimit-to-v1-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: move mem_cgroup_event_ratelimit to v1 code
Date: Wed, 14 Aug 2024 22:04:48 -0700

There are no callers of mem_cgroup_event_ratelimit() in the v2 code.  Move
it to v1 only code and rename it to memcg1_event_ratelimit().

Link: https://lkml.kernel.org/r/20240815050453.1298138-3-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |   32 ++++++++++++++++++++++++++++++--
 mm/memcontrol-v1.h |    2 --
 mm/memcontrol.c    |   28 ----------------------------
 3 files changed, 30 insertions(+), 32 deletions(-)

--- a/mm/memcontrol.c~memcg-move-mem_cgroup_event_ratelimit-to-v1-code
+++ a/mm/memcontrol.c
@@ -95,9 +95,6 @@ static bool cgroup_memory_nobpf __ro_aft
 static DECLARE_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq);
 #endif
 
-#define THRESHOLDS_EVENTS_TARGET 128
-#define SOFTLIMIT_EVENTS_TARGET 1024
-
 static inline bool task_is_dying(void)
 {
 	return tsk_is_oom_victim(current) || fatal_signal_pending(current) ||
@@ -856,31 +853,6 @@ void mem_cgroup_charge_statistics(struct
 	__this_cpu_add(memcg->events_percpu->nr_page_events, nr_pages);
 }
 
-bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
-				enum mem_cgroup_events_target target)
-{
-	unsigned long val, next;
-
-	val = __this_cpu_read(memcg->events_percpu->nr_page_events);
-	next = __this_cpu_read(memcg->events_percpu->targets[target]);
-	/* from time_after() in jiffies.h */
-	if ((long)(next - val) < 0) {
-		switch (target) {
-		case MEM_CGROUP_TARGET_THRESH:
-			next = val + THRESHOLDS_EVENTS_TARGET;
-			break;
-		case MEM_CGROUP_TARGET_SOFTLIMIT:
-			next = val + SOFTLIMIT_EVENTS_TARGET;
-			break;
-		default:
-			break;
-		}
-		__this_cpu_write(memcg->events_percpu->targets[target], next);
-		return true;
-	}
-	return false;
-}
-
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
 {
 	/*
--- a/mm/memcontrol-v1.c~memcg-move-mem_cgroup_event_ratelimit-to-v1-code
+++ a/mm/memcontrol-v1.c
@@ -1439,6 +1439,34 @@ static void mem_cgroup_threshold(struct
 	}
 }
 
+#define THRESHOLDS_EVENTS_TARGET 128
+#define SOFTLIMIT_EVENTS_TARGET 1024
+
+static bool memcg1_event_ratelimit(struct mem_cgroup *memcg,
+				enum mem_cgroup_events_target target)
+{
+	unsigned long val, next;
+
+	val = __this_cpu_read(memcg->events_percpu->nr_page_events);
+	next = __this_cpu_read(memcg->events_percpu->targets[target]);
+	/* from time_after() in jiffies.h */
+	if ((long)(next - val) < 0) {
+		switch (target) {
+		case MEM_CGROUP_TARGET_THRESH:
+			next = val + THRESHOLDS_EVENTS_TARGET;
+			break;
+		case MEM_CGROUP_TARGET_SOFTLIMIT:
+			next = val + SOFTLIMIT_EVENTS_TARGET;
+			break;
+		default:
+			break;
+		}
+		__this_cpu_write(memcg->events_percpu->targets[target], next);
+		return true;
+	}
+	return false;
+}
+
 /*
  * Check events in order.
  *
@@ -1449,11 +1477,11 @@ void memcg1_check_events(struct mem_cgro
 		return;
 
 	/* threshold event is triggered in finer grain than soft limit */
-	if (unlikely(mem_cgroup_event_ratelimit(memcg,
+	if (unlikely(memcg1_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_THRESH))) {
 		bool do_softlimit;
 
-		do_softlimit = mem_cgroup_event_ratelimit(memcg,
+		do_softlimit = memcg1_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_SOFTLIMIT);
 		mem_cgroup_threshold(memcg);
 		if (unlikely(do_softlimit))
--- a/mm/memcontrol-v1.h~memcg-move-mem_cgroup_event_ratelimit-to-v1-code
+++ a/mm/memcontrol-v1.h
@@ -62,8 +62,6 @@ struct memcg1_events_percpu {
 	unsigned long targets[MEM_CGROUP_NTARGETS];
 };
 
-bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
-				enum mem_cgroup_events_target target);
 unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
 
 void drain_all_stock(struct mem_cgroup *root_memcg);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


