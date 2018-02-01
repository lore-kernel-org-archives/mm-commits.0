From: akpm@linux-foundation.org
Subject: [patch 037/119] mm: drop hotplug lock from
 lru_add_drain_all()
Date: Wed, 31 Jan 2018 16:16:19 -0800
Message-ID: <20180201001619.o8GjRoQcu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34238 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752657AbeBAAQU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:16:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de, tj@kernel.org, torvalds@linux-foundation.org

From: Michal Hocko <mhocko@suse.com>
Subject: mm: drop hotplug lock from lru_add_drain_all()

Pulling cpu hotplug locks inside the mm core function like
lru_add_drain_all just asks for problems and the recent lockdep splat [1]
just proves this.  While the usage in that particular case might be wrong
we should avoid the locking as lru_add_drain_all() is used in many places.
It seems that this is not all that hard to achieve actually.

We have done the same thing for drain_all_pages which is analogous by
a459eeb7b852 ("mm, page_alloc: do not depend on cpu hotplug locks inside
the allocator").  All we have to care about is to handle

      - the work item might be executed on a different cpu in worker from
        unbound pool so it doesn't run on pinned on the cpu

      - we have to make sure that we do not race with page_alloc_cpu_dead
        calling lru_add_drain_cpu

the first part is already handled because the worker calls lru_add_drain
which disables preemption when calling lru_add_drain_cpu on the local cpu
it is draining.  The later is true because page_alloc_cpu_dead is called
on the controlling CPU after the hotplugged CPU vanished completely.

[1] http://lkml.kernel.org/r/089e0825eec8955c1f055c83d476@google.com

[add a cpu hotplug locking interaction as per tglx]
Link: http://lkml.kernel.org/r/20171116120535.23765-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 -
 mm/memory_hotplug.c  |    2 +-
 mm/swap.c            |   16 ++++++++--------
 3 files changed, 9 insertions(+), 10 deletions(-)

diff -puN include/linux/swap.h~mm-drop-hotplug-lock-from-lru_add_drain_all include/linux/swap.h
--- a/include/linux/swap.h~mm-drop-hotplug-lock-from-lru_add_drain_all
+++ a/include/linux/swap.h
@@ -332,7 +332,6 @@ extern void mark_page_accessed(struct pa
 extern void lru_add_drain(void);
 extern void lru_add_drain_cpu(int cpu);
 extern void lru_add_drain_all(void);
-extern void lru_add_drain_all_cpuslocked(void);
 extern void rotate_reclaimable_page(struct page *page);
 extern void deactivate_file_page(struct page *page);
 extern void mark_page_lazyfree(struct page *page);
diff -puN mm/memory_hotplug.c~mm-drop-hotplug-lock-from-lru_add_drain_all mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-drop-hotplug-lock-from-lru_add_drain_all
+++ a/mm/memory_hotplug.c
@@ -1637,7 +1637,7 @@ repeat:
 		goto failed_removal;
 
 	cond_resched();
-	lru_add_drain_all_cpuslocked();
+	lru_add_drain_all();
 	drain_all_pages(zone);
 
 	pfn = scan_movable_pages(start_pfn, end_pfn);
diff -puN mm/swap.c~mm-drop-hotplug-lock-from-lru_add_drain_all mm/swap.c
--- a/mm/swap.c~mm-drop-hotplug-lock-from-lru_add_drain_all
+++ a/mm/swap.c
@@ -688,7 +688,14 @@ static void lru_add_drain_per_cpu(struct
 
 static DEFINE_PER_CPU(struct work_struct, lru_add_drain_work);
 
-void lru_add_drain_all_cpuslocked(void)
+/*
+ * Doesn't need any cpu hotplug locking because we do rely on per-cpu
+ * kworkers being shut down before our page_alloc_cpu_dead callback is
+ * executed on the offlined cpu.
+ * Calling this function with cpu hotplug locks held can actually lead
+ * to obscure indirect dependencies via WQ context.
+ */
+void lru_add_drain_all(void)
 {
 	static DEFINE_MUTEX(lock);
 	static struct cpumask has_work;
@@ -724,13 +731,6 @@ void lru_add_drain_all_cpuslocked(void)
 	mutex_unlock(&lock);
 }
 
-void lru_add_drain_all(void)
-{
-	get_online_cpus();
-	lru_add_drain_all_cpuslocked();
-	put_online_cpus();
-}
