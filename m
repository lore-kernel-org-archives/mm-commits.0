Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D868415E88
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 22:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723762054; cv=none; b=KYaNJhkDqvFyQ6H/bE9FoaxZMoJe10z6buWk1kKgLCXaA75A3REnRQguKB05YEhpcEBCSGlnmSKfz07frr3tqrnAMdYjcxQYK14yc0RMtxDhbGLu85NZKSa/maOrNrlvuTmKZlSuC6WKw09jzn3Y61cqDDC4ej6Sw4Lj0QyNIMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723762054; c=relaxed/simple;
	bh=TqLkXUtZa6asryZIClwo8eBxnOqnJAb2G1WlS6RRw+E=;
	h=Date:To:From:Subject:Message-Id; b=pnbBMseD/p916ub9GNWhyGWS6YkkAxz/BBanbj47bMAobdUgwjLRImSYHTsVCdGxok56BG/vriBsWWWVJp42BkKjhd+mtodHktN4z2mHvQqDckQvJD/VQ/k4g6X9TkKuQR6eOP2WkLA3Mc8TTtC9+sg3CIdHkAYlDetMp2SZjD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ATgXjNn1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ATgXjNn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5958CC32786;
	Thu, 15 Aug 2024 22:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723762054;
	bh=TqLkXUtZa6asryZIClwo8eBxnOqnJAb2G1WlS6RRw+E=;
	h=Date:To:From:Subject:From;
	b=ATgXjNn1oBJelsBRtPEC2AvEBppL1dFzZl8tszn1JlC+cRr97PS8ve6O6z/clLKbO
	 5f9iyD7/mUbqnMSuwoDS7B7R5bnoz1oHuUTYIipl+QWf3Z3ebzaMpRPxRua29eh9fF
	 Qunc+2P7ZH/4pbqK3WBgFPQLv6kNd7OokJaxIwJg=
Date: Thu, 15 Aug 2024 15:47:33 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-move-mem_cgroup_event_ratelimit-to-v1-code.patch added to mm-unstable branch
Message-Id: <20240815224734.5958CC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: move mem_cgroup_event_ratelimit to v1 code
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-move-mem_cgroup_event_ratelimit-to-v1-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-move-mem_cgroup_event_ratelimit-to-v1-code.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -867,31 +864,6 @@ void mem_cgroup_charge_statistics(struct
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

memcg-increase-the-valid-index-range-for-memcg-stats.patch
memcg-replace-memcg-id-idr-with-xarray.patch
memcg-replace-memcg-id-idr-with-xarray-v2.patch
memcg-use-ratelimited-stats-flush-in-the-reclaim.patch
memcg-move-v1-only-percpu-stats-in-separate-struct.patch
memcg-move-mem_cgroup_event_ratelimit-to-v1-code.patch
memcg-move-mem_cgroup_charge_statistics-to-v1-code.patch
memcg-move-v1-events-and-statistics-code-to-v1-file.patch
memcg-make-v1-only-functions-static.patch
memcg-allocate-v1-event-percpu-only-on-v1-deployment.patch
memcg-make-pgpgin-and-pgpgout-v1-only.patch

