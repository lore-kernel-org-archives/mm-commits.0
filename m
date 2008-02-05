From: akpm@linux-foundation.org
Subject: - page-allocator-clean-up-pcp-draining-functions.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:31:36 -0800
Message-ID: <200802052231.m15MVHBQ012157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41058 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932334AbYBEWnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, dwalker@mvista.com, mel@csn.ul.ie, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Page allocator: clean up pcp draining functions
has been removed from the -mm tree.  Its filename was
     page-allocator-clean-up-pcp-draining-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Page allocator: clean up pcp draining functions
From: Christoph Lameter <clameter@sgi.com>

- Add comments explaing how drain_pages() works.

- Eliminate useless functions

- Rename drain_all_local_pages to drain_all_pages(). It does drain
  all pages not only those of the local processor.

- Eliminate useless interrupt off / on sequences. drain_pages()
  disables interrupts on its own. The execution thread is
  pinned to processor by the caller. So there is no need to
  disable interrupts.

- Put drain_all_pages() declaration in gfp.h and remove the
  declarations from suspend.h and from mm/memory_hotplug.c

- Make software suspend call drain_all_pages(). The draining
  of processor local pages is may not the right approach if
  software suspend wants to support SMP. If they call drain_all_pages
  then we can make drain_pages() static.

[akpm@linux-foundation.org: fix build]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h     |    2 
 include/linux/suspend.h |    1 
 kernel/power/snapshot.c |    4 -
 mm/memory_hotplug.c     |    6 --
 mm/page_alloc.c         |   79 ++++++++++++++++++++------------------
 5 files changed, 48 insertions(+), 44 deletions(-)

diff -puN include/linux/gfp.h~page-allocator-clean-up-pcp-draining-functions include/linux/gfp.h
--- a/include/linux/gfp.h~page-allocator-clean-up-pcp-draining-functions
+++ a/include/linux/gfp.h
@@ -228,5 +228,7 @@ extern void FASTCALL(free_cold_page(stru
 
 void page_alloc_init(void);
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
+void drain_all_pages(void);
+void drain_local_pages(void *dummy);
 
 #endif /* __LINUX_GFP_H */
diff -puN include/linux/suspend.h~page-allocator-clean-up-pcp-draining-functions include/linux/suspend.h
--- a/include/linux/suspend.h~page-allocator-clean-up-pcp-draining-functions
+++ a/include/linux/suspend.h
@@ -130,7 +130,6 @@ struct pbe {
 };
 
 /* mm/page_alloc.c */
-extern void drain_local_pages(void);
 extern void mark_free_pages(struct zone *zone);
 
 /**
diff -puN kernel/power/snapshot.c~page-allocator-clean-up-pcp-draining-functions kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~page-allocator-clean-up-pcp-draining-functions
+++ a/kernel/power/snapshot.c
@@ -1203,7 +1203,7 @@ asmlinkage int swsusp_save(void)
 
 	printk(KERN_INFO "PM: Creating hibernation image: \n");
 
-	drain_local_pages();
+	drain_local_pages(NULL);
 	nr_pages = count_data_pages();
 	nr_highmem = count_highmem_pages();
 	printk(KERN_INFO "PM: Need to copy %u pages\n", nr_pages + nr_highmem);
@@ -1221,7 +1221,7 @@ asmlinkage int swsusp_save(void)
 	/* During allocating of suspend pagedir, new cold pages may appear.
 	 * Kill them.
 	 */
-	drain_local_pages();
+	drain_local_pages(NULL);
 	copy_data_pages(&copy_bm, &orig_bm);
 
 	/*
diff -puN mm/memory_hotplug.c~page-allocator-clean-up-pcp-draining-functions mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~page-allocator-clean-up-pcp-draining-functions
+++ a/mm/memory_hotplug.c
@@ -481,8 +481,6 @@ check_pages_isolated(unsigned long start
 	return offlined;
 }
 
-extern void drain_all_local_pages(void);
-
 int offline_pages(unsigned long start_pfn,
 		  unsigned long end_pfn, unsigned long timeout)
 {
@@ -540,7 +538,7 @@ repeat:
 		lru_add_drain_all();
 		flush_scheduled_work();
 		cond_resched();
-		drain_all_local_pages();
+		drain_all_pages();
 	}
 
 	pfn = scan_lru_pages(start_pfn, end_pfn);
@@ -563,7 +561,7 @@ repeat:
 	flush_scheduled_work();
 	yield();
 	/* drain pcp pages , this is synchrouns. */
-	drain_all_local_pages();
+	drain_all_pages();
 	/* check again */
 	offlined_pages = check_pages_isolated(start_pfn, end_pfn);
 	if (offlined_pages < 0) {
diff -puN mm/page_alloc.c~page-allocator-clean-up-pcp-draining-functions mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-clean-up-pcp-draining-functions
+++ a/mm/page_alloc.c
@@ -890,7 +890,14 @@ void drain_zone_pages(struct zone *zone,
 }
 #endif
 
-static void __drain_pages(unsigned int cpu)
+/*
+ * Drain pages of the indicated processor.
+ *
+ * The processor must either be the current processor and the
+ * thread pinned to the current processor or a processor that
+ * is not online.
+ */
+static void drain_pages(unsigned int cpu)
 {
 	unsigned long flags;
 	struct zone *zone;
@@ -915,6 +922,22 @@ static void __drain_pages(unsigned int c
 	}
 }
 
+/*
+ * Spill all of this CPU's per-cpu pages back into the buddy allocator.
+ */
+void drain_local_pages(void *arg)
+{
+	drain_pages(smp_processor_id());
+}
+
+/*
+ * Spill all the per-cpu pages from all CPUs back into the buddy allocator
+ */
+void drain_all_pages(void)
+{
+	on_each_cpu(drain_local_pages, NULL, 0, 1);
+}
+
 #ifdef CONFIG_HIBERNATION
 
 void mark_free_pages(struct zone *zone)
@@ -952,37 +975,6 @@ void mark_free_pages(struct zone *zone)
 #endif /* CONFIG_PM */
 
 /*
- * Spill all of this CPU's per-cpu pages back into the buddy allocator.
- */
-void drain_local_pages(void)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);	
-	__drain_pages(smp_processor_id());
-	local_irq_restore(flags);	
-}
-
-void smp_drain_local_pages(void *arg)
-{
-	drain_local_pages();
-}
-
-/*
- * Spill all the per-cpu pages from all CPUs back into the buddy allocator
- */
-void drain_all_local_pages(void)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__drain_pages(smp_processor_id());
-	local_irq_restore(flags);
-
-	smp_call_function(smp_drain_local_pages, NULL, 0, 1);
-}
-
-/*
  * Free a 0-order page
  */
 static void fastcall free_hot_cold_page(struct page *page, int cold)
@@ -1569,7 +1561,7 @@ nofail_alloc:
 	cond_resched();
 
 	if (order != 0)
-		drain_all_local_pages();
+		drain_all_pages();
 
 	if (likely(did_some_progress)) {
 		page = get_page_from_freelist(gfp_mask, order,
@@ -3978,10 +3970,23 @@ static int page_alloc_cpu_notify(struct 
 	int cpu = (unsigned long)hcpu;
 
 	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
-		local_irq_disable();
-		__drain_pages(cpu);
+		drain_pages(cpu);
+
+		/*
+		 * Spill the event counters of the dead processor
+		 * into the current processors event counters.
+		 * This artificially elevates the count of the current
+		 * processor.
+		 */
 		vm_events_fold_cpu(cpu);
-		local_irq_enable();
+
+		/*
+		 * Zero the differential counters of the dead processor
+		 * so that the vm statistics are consistent.
+		 *
+		 * This is only okay since the processor is dead and cannot
+		 * race with what we are doing.
+		 */
 		refresh_cpu_vm_stats(cpu);
 	}
 	return NOTIFY_OK;
@@ -4480,7 +4485,7 @@ int set_migratetype_isolate(struct page 
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
 	if (!ret)
-		drain_all_local_pages();
+		drain_all_pages();
 	return ret;
 }
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
git-unionfs.patch
git-slub.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-include-sectionsh-to-avoid-defining-linker-variables.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
