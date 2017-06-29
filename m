From: akpm@linux-foundation.org
Subject: + mm-memory-hotplug-switch-locking-to-a-percpu-rwsem.patch added
 to -mm tree
Date: Thu, 29 Jun 2017 14:13:56 -0700
Message-ID: <59556d94.QSwwGdvnW+P1kgFM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60106 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbdF2VN6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jun 2017 17:13:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, aryabinin@virtuozzo.com, dkiper@net-space.pl, mhocko@kernel.org, vbabka@suse.cz, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-hotplug: switch locking to a percpu rwsem
has been added to the -mm tree.  Its filename is
     mm-memory-hotplug-switch-locking-to-a-percpu-rwsem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-hotplug-switch-locking-to-a-percpu-rwsem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-hotplug-switch-locking-to-a-percpu-rwsem.patch

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
Subject: mm/memory-hotplug: switch locking to a percpu rwsem

Andrey reported a potential deadlock with the memory hotplug lock and the
cpu hotplug lock.

The reason is that memory hotplug takes the memory hotplug lock and then
calls stop_machine() which calls get_online_cpus().  That's the reverse
lock order to get_online_cpus(); get_online_mems(); in mm/slub_common.c

The problem has been there forever.  The reason why this was never
reported is that the cpu hotplug locking had this homebrewn recursive
reader writer semaphore construct which due to the recursion evaded the
full lock dep coverage.  The memory hotplug code copied that construct
verbatim and therefor has similar issues.

Two steps to fix this:

1) Convert the memory hotplug locking to a per cpu rwsem so the potential
   issues get reported proper by lockdep.

2) Lock the online cpus in mem_hotplug_begin() before taking the memory
   hotplug rwsem and use stop_machine_cpuslocked() in the page_alloc code
   to avoid recursive locking.

Note:

Most of the call sites of get_online_mems() are also calling
get_online_cpus().

So we could switch the whole machinery to use the CPU hotplug locking for
protecting both memory and CPU hotplug.  That actually works and removes
another 40 lines of code.

Link: http://lkml.kernel.org/r/alpine.DEB.2.20.1706291803380.1861@nanos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Daniel Kiper <dkiper@net-space.pl>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   85 ++++++------------------------------------
 mm/page_alloc.c     |    2 
 2 files changed, 14 insertions(+), 73 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory-hotplug-switch-locking-to-a-percpu-rwsem mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory-hotplug-switch-locking-to-a-percpu-rwsem
+++ a/mm/memory_hotplug.c
@@ -52,32 +52,17 @@ static void generic_online_page(struct p
 static online_page_callback_t online_page_callback = generic_online_page;
 static DEFINE_MUTEX(online_page_callback_lock);
 
-/* The same as the cpu_hotplug lock, but for memory hotplug. */
-static struct {
-	struct task_struct *active_writer;
-	struct mutex lock; /* Synchronizes accesses to refcount, */
-	/*
-	 * Also blocks the new readers during
-	 * an ongoing mem hotplug operation.
-	 */
-	int refcount;
+DEFINE_STATIC_PERCPU_RWSEM(mem_hotplug_lock);
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map dep_map;
-#endif
-} mem_hotplug = {
-	.active_writer = NULL,
-	.lock = __MUTEX_INITIALIZER(mem_hotplug.lock),
-	.refcount = 0,
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	.dep_map = {.name = "mem_hotplug.lock" },
-#endif
-};
+void get_online_mems(void)
+{
+	percpu_down_read(&mem_hotplug_lock);
+}
 
-/* Lockdep annotations for get/put_online_mems() and mem_hotplug_begin/end() */
-#define memhp_lock_acquire_read() lock_map_acquire_read(&mem_hotplug.dep_map)
-#define memhp_lock_acquire()      lock_map_acquire(&mem_hotplug.dep_map)
-#define memhp_lock_release()      lock_map_release(&mem_hotplug.dep_map)
+void put_online_mems(void)
+{
+	percpu_up_read(&mem_hotplug_lock);
+}
 
 bool movable_node_enabled = false;
 
@@ -99,60 +84,16 @@ static int __init setup_memhp_default_st
 }
 __setup("memhp_default_state=", setup_memhp_default_state);
 
-void get_online_mems(void)
-{
-	might_sleep();
-	if (mem_hotplug.active_writer == current)
-		return;
-	memhp_lock_acquire_read();
-	mutex_lock(&mem_hotplug.lock);
-	mem_hotplug.refcount++;
-	mutex_unlock(&mem_hotplug.lock);
-
-}
-
-void put_online_mems(void)
-{
-	if (mem_hotplug.active_writer == current)
-		return;
-	mutex_lock(&mem_hotplug.lock);
-
-	if (WARN_ON(!mem_hotplug.refcount))
-		mem_hotplug.refcount++; /* try to fix things up */
-
-	if (!--mem_hotplug.refcount && unlikely(mem_hotplug.active_writer))
-		wake_up_process(mem_hotplug.active_writer);
-	mutex_unlock(&mem_hotplug.lock);
-	memhp_lock_release();
-
-}
-
-/* Serializes write accesses to mem_hotplug.active_writer. */
-static DEFINE_MUTEX(memory_add_remove_lock);
-
 void mem_hotplug_begin(void)
 {
-	mutex_lock(&memory_add_remove_lock);
-
-	mem_hotplug.active_writer = current;
-
-	memhp_lock_acquire();
-	for (;;) {
-		mutex_lock(&mem_hotplug.lock);
-		if (likely(!mem_hotplug.refcount))
-			break;
-		__set_current_state(TASK_UNINTERRUPTIBLE);
-		mutex_unlock(&mem_hotplug.lock);
-		schedule();
-	}
+	cpus_read_lock();
+	percpu_down_write(&mem_hotplug_lock);
 }
 
 void mem_hotplug_done(void)
 {
-	mem_hotplug.active_writer = NULL;
-	mutex_unlock(&mem_hotplug.lock);
-	memhp_lock_release();
-	mutex_unlock(&memory_add_remove_lock);
+	percpu_up_write(&mem_hotplug_lock);
+	cpus_read_unlock();
 }
 
 /* add this memory to iomem resource */
diff -puN mm/page_alloc.c~mm-memory-hotplug-switch-locking-to-a-percpu-rwsem mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memory-hotplug-switch-locking-to-a-percpu-rwsem
+++ a/mm/page_alloc.c
@@ -5289,7 +5289,7 @@ void __ref build_all_zonelists(pg_data_t
 #endif
 		/* we have to stop all cpus to guarantee there is no user
 		   of zonelist */
-		stop_machine(__build_all_zonelists, pgdat, NULL);
+		stop_machine_cpuslocked(__build_all_zonelists, pgdat, NULL);
 		/* cpuset refresh routine should be here */
 	}
 	vm_total_pages = nr_free_pagecache_pages();
_

Patches currently in -mm which might be from tglx@linutronix.de are

mm-memory-hotplug-switch-locking-to-a-percpu-rwsem.patch

