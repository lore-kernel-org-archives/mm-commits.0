From: akpm@linux-foundation.org
Subject: [merged] mm-make-lru_add_drain_all-selective.patch removed from
 -mm tree
Date: Fri, 13 Sep 2013 13:02:50 -0700
Message-ID: <52336f6a.cnj3u530kSI90fM6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab3IMUCu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, cmetcalf@tilera.com

Subject: [merged] mm-make-lru_add_drain_all-selective.patch removed from -mm tree
To: cmetcalf@tilera.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:02:50 -0700


The patch titled
     Subject: mm: make lru_add_drain_all() selective
has been removed from the -mm tree.  Its filename was
     mm-make-lru_add_drain_all-selective.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chris Metcalf <cmetcalf@tilera.com>
Subject: mm: make lru_add_drain_all() selective

make lru_add_drain_all() only selectively interrupt the cpus that have
per-cpu free pages that can be drained.

This is important in nohz mode where calling mlockall(), for example,
otherwise will interrupt every core unnecessarily.

This is important on workloads where nohz cores are handling 10 Gb traffic
in userspace.  Those CPUs do not enter the kernel and place pages into LRU
pagevecs and they really, really don't want to be interrupted, or they
drop packets on the floor.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 -
 mm/swap.c            |   44 ++++++++++++++++++++++++++++++++++++-----
 2 files changed, 40 insertions(+), 6 deletions(-)

diff -puN include/linux/swap.h~mm-make-lru_add_drain_all-selective include/linux/swap.h
--- a/include/linux/swap.h~mm-make-lru_add_drain_all-selective
+++ a/include/linux/swap.h
@@ -280,7 +280,7 @@ extern void activate_page(struct page *)
 extern void mark_page_accessed(struct page *);
 extern void lru_add_drain(void);
 extern void lru_add_drain_cpu(int cpu);
-extern int lru_add_drain_all(void);
+extern void lru_add_drain_all(void);
 extern void rotate_reclaimable_page(struct page *page);
 extern void deactivate_page(struct page *page);
 extern void swap_setup(void);
diff -puN mm/swap.c~mm-make-lru_add_drain_all-selective mm/swap.c
--- a/mm/swap.c~mm-make-lru_add_drain_all-selective
+++ a/mm/swap.c
@@ -432,6 +432,11 @@ static void activate_page_drain(int cpu)
 		pagevec_lru_move_fn(pvec, __activate_page, NULL);
 }
 
+static bool need_activate_page_drain(int cpu)
+{
+	return pagevec_count(&per_cpu(activate_page_pvecs, cpu)) != 0;
+}
+
 void activate_page(struct page *page)
 {
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
@@ -449,6 +454,11 @@ static inline void activate_page_drain(i
 {
 }
 
+static bool need_activate_page_drain(int cpu)
+{
+	return false;
+}
+
 void activate_page(struct page *page)
 {
 	struct zone *zone = page_zone(page);
@@ -701,12 +711,36 @@ static void lru_add_drain_per_cpu(struct
 	lru_add_drain();
 }
 
-/*
- * Returns 0 for success
- */
-int lru_add_drain_all(void)
+static DEFINE_PER_CPU(struct work_struct, lru_add_drain_work);
+
+void lru_add_drain_all(void)
 {
-	return schedule_on_each_cpu(lru_add_drain_per_cpu);
+	static DEFINE_MUTEX(lock);
+	static struct cpumask has_work;
+	int cpu;
+
+	mutex_lock(&lock);
+	get_online_cpus();
+	cpumask_clear(&has_work);
+
+	for_each_online_cpu(cpu) {
+		struct work_struct *work = &per_cpu(lru_add_drain_work, cpu);
+
+		if (pagevec_count(&per_cpu(lru_add_pvec, cpu)) ||
+		    pagevec_count(&per_cpu(lru_rotate_pvecs, cpu)) ||
+		    pagevec_count(&per_cpu(lru_deactivate_pvecs, cpu)) ||
+		    need_activate_page_drain(cpu)) {
+			INIT_WORK(work, lru_add_drain_per_cpu);
+			schedule_work_on(cpu, work);
+			cpumask_set_cpu(cpu, &has_work);
+		}
+	}
+
+	for_each_cpu(cpu, &has_work)
+		flush_work(&per_cpu(lru_add_drain_work, cpu));
+
+	put_online_cpus();
+	mutex_unlock(&lock);
 }
 
 /*
_

Patches currently in -mm which might be from cmetcalf@tilera.com are

origin.patch

