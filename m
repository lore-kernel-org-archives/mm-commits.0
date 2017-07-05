From: akpm@linux-foundation.org
Subject: + mm-swap-provide-lru_add_drain_all_cpuslocked.patch added to -mm tree
Date: Wed, 05 Jul 2017 15:01:02 -0700
Message-ID: <595d619e.Bvizd38hiBay82uU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57808 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752459AbdGEWBD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 18:01:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, aryabinin@virtuozzo.com, dave@stgolabs.net, mhocko@suse.com, peterz@infradead.org, vbabka@suse.cz, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: swap: provide lru_add_drain_all_cpuslocked()
has been added to the -mm tree.  Its filename is
     mm-swap-provide-lru_add_drain_all_cpuslocked.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-provide-lru_add_drain_all_cpuslocked.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-provide-lru_add_drain_all_cpuslocked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thomas Gleixner <tglx@linutronix.de>
Subject: mm: swap: provide lru_add_drain_all_cpuslocked()

The rework of the cpu hotplug locking unearthed potential deadlocks with
the memory hotplug locking code.

The solution for these is to rework the memory hotplug locking code as
well and take the cpu hotplug lock before the memory hotplug lock in
mem_hotplug_begin(), but this will cause a recursive locking of the cpu
hotplug lock when the memory hotplug code calls lru_add_drain_all().

Split out the inner workings of lru_add_drain_all() into
lru_add_drain_all_cpuslocked() so this function can be invoked from the
memory hotplug code with the cpu hotplug lock held.

Link: http://lkml.kernel.org/r/20170704093421.419329357@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 +
 mm/swap.c            |   11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff -puN include/linux/swap.h~mm-swap-provide-lru_add_drain_all_cpuslocked include/linux/swap.h
--- a/include/linux/swap.h~mm-swap-provide-lru_add_drain_all_cpuslocked
+++ a/include/linux/swap.h
@@ -277,6 +277,7 @@ extern void mark_page_accessed(struct pa
 extern void lru_add_drain(void);
 extern void lru_add_drain_cpu(int cpu);
 extern void lru_add_drain_all(void);
+extern void lru_add_drain_all_cpuslocked(void);
 extern void rotate_reclaimable_page(struct page *page);
 extern void deactivate_file_page(struct page *page);
 extern void mark_page_lazyfree(struct page *page);
diff -puN mm/swap.c~mm-swap-provide-lru_add_drain_all_cpuslocked mm/swap.c
--- a/mm/swap.c~mm-swap-provide-lru_add_drain_all_cpuslocked
+++ a/mm/swap.c
@@ -688,7 +688,7 @@ static void lru_add_drain_per_cpu(struct
 
 static DEFINE_PER_CPU(struct work_struct, lru_add_drain_work);
 
-void lru_add_drain_all(void)
+void lru_add_drain_all_cpuslocked(void)
 {
 	static DEFINE_MUTEX(lock);
 	static struct cpumask has_work;
@@ -702,7 +702,6 @@ void lru_add_drain_all(void)
 		return;
 
 	mutex_lock(&lock);
-	get_online_cpus();
 	cpumask_clear(&has_work);
 
 	for_each_online_cpu(cpu) {
@@ -722,10 +721,16 @@ void lru_add_drain_all(void)
 	for_each_cpu(cpu, &has_work)
 		flush_work(&per_cpu(lru_add_drain_work, cpu));
 
-	put_online_cpus();
 	mutex_unlock(&lock);
 }
 
+void lru_add_drain_all(void)
+{
+	get_online_cpus();
+	lru_add_drain_all_cpuslocked();
+	put_online_cpus();
+}
+
 /**
  * release_pages - batched put_page()
  * @pages: array of pages to release
_

Patches currently in -mm which might be from tglx@linutronix.de are

mm-swap-provide-lru_add_drain_all_cpuslocked.patch
mm-memory-hotplug-switch-locking-to-a-percpu-rwsem.patch

