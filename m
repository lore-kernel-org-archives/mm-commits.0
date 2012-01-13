From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-shorten-preempt-disabled-section-around-event-checks.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:33:19 -0800
Message-ID: <20120113203320.338F95C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:49326 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759096Ab2AMUdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:33:22 -0500
Received: by mail-ee0-f74.google.com with SMTP id e50so23664eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:33:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, henrix@camandro.org, kamezawa.hiroyu@jp.fujitsu.com, peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de, yong.zhang0@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: shorten preempt-disabled section around event checks
has been removed from the -mm tree.  Its filename was
     mm-memcg-shorten-preempt-disabled-section-around-event-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: memcg: shorten preempt-disabled section around event checks

Only the ratelimit checks themselves have to run with preemption disabled,
the resulting actions - checking for usage thresholds, updating the soft
limit tree - can and should run with preemption enabled.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Reported-by: Yong Zhang <yong.zhang0@gmail.com>
Tested-by: Yong Zhang <yong.zhang0@gmail.com>
Reported-by: Luis Henriques <henrix@camandro.org>
Tested-by: Luis Henriques <henrix@camandro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   73 ++++++++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 38 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-shorten-preempt-disabled-section-around-event-checks mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-shorten-preempt-disabled-section-around-event-checks
+++ a/mm/memcontrol.c
@@ -748,37 +748,32 @@ static unsigned long mem_cgroup_nr_lru_p
 	return total;
 }
 
-static bool __memcg_event_check(struct mem_cgroup *memcg, int target)
+static bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
+				       enum mem_cgroup_events_target target)
 {
 	unsigned long val, next;
 
 	val = __this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
 	next = __this_cpu_read(memcg->stat->targets[target]);
 	/* from time_after() in jiffies.h */
-	return ((long)next - (long)val < 0);
-}
-
-static void __mem_cgroup_target_update(struct mem_cgroup *memcg, int target)
-{
-	unsigned long val, next;
-
-	val = __this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
-
-	switch (target) {
-	case MEM_CGROUP_TARGET_THRESH:
-		next = val + THRESHOLDS_EVENTS_TARGET;
-		break;
-	case MEM_CGROUP_TARGET_SOFTLIMIT:
-		next = val + SOFTLIMIT_EVENTS_TARGET;
-		break;
-	case MEM_CGROUP_TARGET_NUMAINFO:
-		next = val + NUMAINFO_EVENTS_TARGET;
-		break;
-	default:
-		return;
+	if ((long)next - (long)val < 0) {
+		switch (target) {
+		case MEM_CGROUP_TARGET_THRESH:
+			next = val + THRESHOLDS_EVENTS_TARGET;
+			break;
+		case MEM_CGROUP_TARGET_SOFTLIMIT:
+			next = val + SOFTLIMIT_EVENTS_TARGET;
+			break;
+		case MEM_CGROUP_TARGET_NUMAINFO:
+			next = val + NUMAINFO_EVENTS_TARGET;
+			break;
+		default:
+			break;
+		}
+		__this_cpu_write(memcg->stat->targets[target], next);
+		return true;
 	}
-
-	__this_cpu_write(memcg->stat->targets[target], next);
+	return false;
 }
 
 /*
@@ -789,25 +784,27 @@ static void memcg_check_events(struct me
 {
 	preempt_disable();
 	/* threshold event is triggered in finer grain than soft limit */
-	if (unlikely(__memcg_event_check(memcg, MEM_CGROUP_TARGET_THRESH))) {
+	if (unlikely(mem_cgroup_event_ratelimit(memcg,
+						MEM_CGROUP_TARGET_THRESH))) {
+		bool do_softlimit, do_numainfo;
+
+		do_softlimit = mem_cgroup_event_ratelimit(memcg,
+						MEM_CGROUP_TARGET_SOFTLIMIT);
+#if MAX_NUMNODES > 1
+		do_numainfo = mem_cgroup_event_ratelimit(memcg,
+						MEM_CGROUP_TARGET_NUMAINFO);
+#endif
+		preempt_enable();
+
 		mem_cgroup_threshold(memcg);
-		__mem_cgroup_target_update(memcg, MEM_CGROUP_TARGET_THRESH);
-		if (unlikely(__memcg_event_check(memcg,
-			     MEM_CGROUP_TARGET_SOFTLIMIT))) {
+		if (unlikely(do_softlimit))
 			mem_cgroup_update_tree(memcg, page);
-			__mem_cgroup_target_update(memcg,
-						   MEM_CGROUP_TARGET_SOFTLIMIT);
-		}
 #if MAX_NUMNODES > 1
-		if (unlikely(__memcg_event_check(memcg,
-			MEM_CGROUP_TARGET_NUMAINFO))) {
+		if (unlikely(do_numainfo))
 			atomic_inc(&memcg->numainfo_events);
-			__mem_cgroup_target_update(memcg,
-				MEM_CGROUP_TARGET_NUMAINFO);
-		}
 #endif
-	}
-	preempt_enable();
+	} else
+		preempt_enable();
 }
 
 struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
_

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
mm-add-extra-free-kbytes-tunable.patch

