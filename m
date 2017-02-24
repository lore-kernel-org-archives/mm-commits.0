From: akpm@linux-foundation.org
Subject: [patch 020/124] mm, page_alloc: drain per-cpu pages from
 workqueue context
Date: Fri, 24 Feb 2017 14:56:32 -0800
Message-ID: <58b0ba20.S5030UgFVExsUO8f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37382 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdBXW4e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:56:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, brouer@redhat.com, hillf.zj@alibaba-inc.com, tj@kernel.org, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: drain per-cpu pages from workqueue context

The per-cpu page allocator can be drained immediately via
drain_all_pages() which sends IPIs to every CPU.  In the next patch, the
per-cpu allocator will only be used for interrupt-safe allocations which
prevents draining it from IPI context.  This patch uses workqueues to
drain the per-cpu lists instead.

This is slower but no slowdown during intensive reclaim was measured and
the paths that use drain_all_pages() are not that sensitive to
performance.  This is particularly true as the path would only be
triggered when reclaim is failing.  It also makes a some sense to avoid
storming a machine with IPIs when it's under memory pressure.  Arguably,
it should be further adjusted so that only one caller at a time is
draining pages but it's beyond the scope of the current patch.

Link: http://lkml.kernel.org/r/20170123153906.3122-4-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   44 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 7 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-drain-per-cpu-pages-from-workqueue-context mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-drain-per-cpu-pages-from-workqueue-context
+++ a/mm/page_alloc.c
@@ -2339,19 +2339,21 @@ void drain_local_pages(struct zone *zone
 		drain_pages(cpu);
 }
 
+static void drain_local_pages_wq(struct work_struct *work)
+{
+	drain_local_pages(NULL);
+}
+
 /*
  * Spill all the per-cpu pages from all CPUs back into the buddy allocator.
  *
  * When zone parameter is non-NULL, spill just the single zone's pages.
  *
- * Note that this code is protected against sending an IPI to an offline
- * CPU but does not guarantee sending an IPI to newly hotplugged CPUs:
- * on_each_cpu_mask() blocks hotplug and won't talk to offlined CPUs but
- * nothing keeps CPUs from showing up after we populated the cpumask and
- * before the call to on_each_cpu_mask().
+ * Note that this can be extremely slow as the draining happens in a workqueue.
  */
 void drain_all_pages(struct zone *zone)
 {
+	struct work_struct __percpu *works;
 	int cpu;
 
 	/*
@@ -2360,6 +2362,17 @@ void drain_all_pages(struct zone *zone)
 	 */
 	static cpumask_t cpus_with_pcps;
 
+	/* Workqueues cannot recurse */
+	if (current->flags & PF_WQ_WORKER)
+		return;
+
+	/*
+	 * As this can be called from reclaim context, do not reenter reclaim.
+	 * An allocation failure can be handled, it's simply slower
+	 */
+	get_online_cpus();
+	works = alloc_percpu_gfp(struct work_struct, GFP_ATOMIC);
+
 	/*
 	 * We don't care about racing with CPU hotplug event
 	 * as offline notification will cause the notified
@@ -2390,8 +2403,25 @@ void drain_all_pages(struct zone *zone)
 		else
 			cpumask_clear_cpu(cpu, &cpus_with_pcps);
 	}
-	on_each_cpu_mask(&cpus_with_pcps, (smp_call_func_t) drain_local_pages,
-								zone, 1);
+
+	if (works) {
+		for_each_cpu(cpu, &cpus_with_pcps) {
+			struct work_struct *work = per_cpu_ptr(works, cpu);
+			INIT_WORK(work, drain_local_pages_wq);
+			schedule_work_on(cpu, work);
+		}
+		for_each_cpu(cpu, &cpus_with_pcps)
+			flush_work(per_cpu_ptr(works, cpu));
+	} else {
+		for_each_cpu(cpu, &cpus_with_pcps) {
+			struct work_struct work;
+
+			INIT_WORK(&work, drain_local_pages_wq);
+			schedule_work_on(cpu, &work);
+			flush_work(&work);
+		}
+	}
+	put_online_cpus();
 }
 
 #ifdef CONFIG_HIBERNATION
_
