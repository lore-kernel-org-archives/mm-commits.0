From: akpm@linux-foundation.org
Subject: + mm-make-lru_add_drain_all-selective.patch added to -mm tree
Date: Wed, 14 Aug 2013 14:13:03 -0700
Message-ID: <520bf2df.Shg8egd+B63vHo5U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760012Ab3HNVNE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 17:13:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, cmetcalf@tilera.com

Subject: + mm-make-lru_add_drain_all-selective.patch added to -mm tree
To: cmetcalf@tilera.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 14:13:03 -0700


The patch titled
     Subject: mm: make lru_add_drain_all() selective
has been added to the -mm tree.  Its filename is
     mm-make-lru_add_drain_all-selective.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-lru_add_drain_all-selective.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-lru_add_drain_all-selective.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -405,6 +405,11 @@ static void activate_page_drain(int cpu)
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
@@ -422,6 +427,11 @@ static inline void activate_page_drain(i
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
@@ -674,12 +684,36 @@ static void lru_add_drain_per_cpu(struct
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

kernel-smpc-quit-unconditionally-enabling-irqs-in-on_each_cpu_mask.patch
linux-next.patch
mm-make-lru_add_drain_all-selective.patch

