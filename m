From: akpm@linux-foundation.org
Subject: + mm-memcg-shorten-preempt-disabled-section-around-event-checks.patch added to -mm tree
Date: Mon, 21 Nov 2011 14:21:34 -0800
Message-ID: <201111212221.pALMLYHv002542@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:54180 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab1KUWVj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2011 17:21:39 -0500
Received: by wwe5 with SMTP id 5so178975wwe.1
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2011 14:21:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jweiner@redhat.com, henrix@camandro.org, peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de, yong.zhang0@gmail.com


The patch titled
     Subject: mm: memcg: shorten preempt-disabled section around event checks
has been added to the -mm tree.  Its filename is
     mm-memcg-shorten-preempt-disabled-section-around-event-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: memcg: shorten preempt-disabled section around event checks

Only the ratelimit checks themselves have to run with preemption disabled,
the resulting actions - checking for usage thresholds, updating the soft
limit tree - can and should run with preemption enabled.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Reported-by: Yong Zhang <yong.zhang0@gmail.com>
Reported-by: Luis Henriques <henrix@camandro.org>
Tested-by: Luis Henriques <henrix@camandro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   73 ++++++++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 38 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-shorten-preempt-disabled-section-around-event-checks mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-shorten-preempt-disabled-section-around-event-checks
+++ a/mm/memcontrol.c
@@ -682,37 +682,32 @@ static unsigned long mem_cgroup_nr_lru_p
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
@@ -723,25 +718,27 @@ static void memcg_check_events(struct me
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
 
 static struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
_
Subject: Subject: mm: memcg: shorten preempt-disabled section around event checks

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
mm-add-extra-free-kbytes-tunable.patch
mm-migrate-one-less-atomic-operation.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch
mm-memcg-shorten-preempt-disabled-section-around-event-checks.patch

