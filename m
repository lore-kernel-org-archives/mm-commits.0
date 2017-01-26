From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages.patch added to -mm tree
Date: Wed, 25 Jan 2017 16:04:50 -0800
Message-ID: <58893d22.ao3zeBMfUvTYsobZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51520 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750986AbdAZAEv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2017 19:04:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, hillf.zj@alibaba-inc.com, tj@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: use static global work_struct for draining per-cpu pages
has been added to the -mm tree.  Its filename is
     mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: use static global work_struct for draining per-cpu pages

As suggested by Vlastimil Babka and Tejun Heo, this patch uses a static
work_struct to co-ordinate the draining of per-cpu pages on the workqueue.
Only one task can drain at a time but this is better than the previous
scheme that allowed multiple tasks to send IPIs at a time.

One consideration is whether parallel requests should synchronise against
each other.  This patch does not synchronise for a global drain as the
common case for such callers is expected to be multiple parallel direct
reclaimers competing for pages when the watermark is close to min. 
Draining the per-cpu list is unlikely to make much progress and
serialising the drain is of dubious merit.  Drains are synchonrised for
callers such as memory hotplug and CMA that care about the drain being
complete when the function returns.

Link: http://lkml.kernel.org/r/20170125083038.rzb5f43nptmk7aed@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Suggested-by: Tejun Heo <tj@kernel.org>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages
+++ a/mm/page_alloc.c
@@ -92,6 +92,10 @@ EXPORT_PER_CPU_SYMBOL(_numa_mem_);
 int _node_numa_mem_[MAX_NUMNODES];
 #endif
 
+/* work_structs for global per-cpu drains */
+DEFINE_MUTEX(pcpu_drain_mutex);
+DEFINE_PER_CPU(struct work_struct, pcpu_drain);
+
 #ifdef CONFIG_GCC_PLUGIN_LATENT_ENTROPY
 volatile unsigned long latent_entropy __latent_entropy;
 EXPORT_SYMBOL(latent_entropy);
@@ -2351,7 +2355,6 @@ static void drain_local_pages_wq(struct
  */
 void drain_all_pages(struct zone *zone)
 {
-	struct work_struct __percpu *works;
 	int cpu;
 
 	/*
@@ -2365,11 +2368,21 @@ void drain_all_pages(struct zone *zone)
 		return;
 
 	/*
+	 * Do not drain if one is already in progress unless it's specific to
+	 * a zone. Such callers are primarily CMA and memory hotplug and need
+	 * the drain to be complete when the call returns.
+	 */
+	if (unlikely(!mutex_trylock(&pcpu_drain_mutex))) {
+		if (!zone)
+			return;
+		mutex_lock(&pcpu_drain_mutex);
+	}
+
+	/*
 	 * As this can be called from reclaim context, do not reenter reclaim.
 	 * An allocation failure can be handled, it's simply slower
 	 */
 	get_online_cpus();
-	works = alloc_percpu_gfp(struct work_struct, GFP_ATOMIC);
 
 	/*
 	 * We don't care about racing with CPU hotplug event
@@ -2402,24 +2415,16 @@ void drain_all_pages(struct zone *zone)
 			cpumask_clear_cpu(cpu, &cpus_with_pcps);
 	}
 
-	if (works) {
-		for_each_cpu(cpu, &cpus_with_pcps) {
-			struct work_struct *work = per_cpu_ptr(works, cpu);
-			INIT_WORK(work, drain_local_pages_wq);
-			schedule_work_on(cpu, work);
-		}
-		for_each_cpu(cpu, &cpus_with_pcps)
-			flush_work(per_cpu_ptr(works, cpu));
-	} else {
-		for_each_cpu(cpu, &cpus_with_pcps) {
-			struct work_struct work;
-
-			INIT_WORK(&work, drain_local_pages_wq);
-			schedule_work_on(cpu, &work);
-			flush_work(&work);
-		}
+	for_each_cpu(cpu, &cpus_with_pcps) {
+		struct work_struct *work = per_cpu_ptr(&pcpu_drain, cpu);
+		INIT_WORK(work, drain_local_pages_wq);
+		schedule_work_on(cpu, work);
 	}
+	for_each_cpu(cpu, &cpus_with_pcps)
+		flush_work(per_cpu_ptr(&pcpu_drain, cpu));
+
 	put_online_cpus();
+	mutex_unlock(&pcpu_drain_mutex);
 }
 
 #ifdef CONFIG_HIBERNATION
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-split-buffered_rmqueue.patch
mm-page_alloc-split-buffered_rmqueue-fix.patch
mm-page_alloc-split-alloc_pages_nodemask.patch
mm-page_alloc-drain-per-cpu-pages-from-workqueue-context.patch
mm-page_alloc-only-use-per-cpu-allocator-for-irq-safe-requests.patch
mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages.patch

