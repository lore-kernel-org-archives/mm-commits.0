From: akpm@linux-foundation.org
Subject: + page-allocator-clean-up-pcp-draining-functions.patch added to -mm tree
Date: Mon, 12 Nov 2007 14:07:12 -0800
Message-ID: <200711122207.lACM7C0K011225@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36578 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426AbXKLWHb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 17:07:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, mel@csn.ul.ie, rjw@sisk.pl


The patch titled
     Page allocator: clean up pcp draining functions
has been added to the -mm tree.  Its filename is
     page-allocator-clean-up-pcp-draining-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h     |    1 
 include/linux/suspend.h |    1 
 kernel/power/snapshot.c |    4 -
 mm/memory_hotplug.c     |    6 --
 mm/page_alloc.c         |   79 ++++++++++++++++++++------------------
 5 files changed, 47 insertions(+), 44 deletions(-)

diff -puN include/linux/gfp.h~page-allocator-clean-up-pcp-draining-functions include/linux/gfp.h
--- a/include/linux/gfp.h~page-allocator-clean-up-pcp-draining-functions
+++ a/include/linux/gfp.h
@@ -228,5 +228,6 @@ extern void FASTCALL(free_cold_page(stru
 
 void page_alloc_init(void);
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
+void drain_all_pages(void);
 
 #endif /* __LINUX_GFP_H */
diff -puN include/linux/suspend.h~page-allocator-clean-up-pcp-draining-functions include/linux/suspend.h
--- a/include/linux/suspend.h~page-allocator-clean-up-pcp-draining-functions
+++ a/include/linux/suspend.h
@@ -123,7 +123,6 @@ struct pbe {
 };
 
 /* mm/page_alloc.c */
-extern void drain_local_pages(void);
 extern void mark_free_pages(struct zone *zone);
 
 /**
diff -puN kernel/power/snapshot.c~page-allocator-clean-up-pcp-draining-functions kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~page-allocator-clean-up-pcp-draining-functions
+++ a/kernel/power/snapshot.c
@@ -1204,7 +1204,7 @@ asmlinkage int swsusp_save(void)
 
 	printk("swsusp: critical section: \n");
 
-	drain_local_pages();
+	drain_all_pages();
 	nr_pages = count_data_pages();
 	nr_highmem = count_highmem_pages();
 	printk("swsusp: Need to copy %u pages\n", nr_pages + nr_highmem);
@@ -1222,7 +1222,7 @@ asmlinkage int swsusp_save(void)
 	/* During allocating of suspend pagedir, new cold pages may appear.
 	 * Kill them.
 	 */
-	drain_local_pages();
+	drain_all_pages();
 	copy_data_pages(&copy_bm, &orig_bm);
 
 	/*
diff -puN mm/memory_hotplug.c~page-allocator-clean-up-pcp-draining-functions mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~page-allocator-clean-up-pcp-draining-functions
+++ a/mm/memory_hotplug.c
@@ -537,8 +537,6 @@ check_pages_isolated(unsigned long start
 	return offlined;
 }
 
-extern void drain_all_local_pages(void);
-
 int offline_pages(unsigned long start_pfn,
 		  unsigned long end_pfn, unsigned long timeout)
 {
@@ -596,7 +594,7 @@ repeat:
 		lru_add_drain_all();
 		flush_scheduled_work();
 		cond_resched();
-		drain_all_local_pages();
+		drain_all_pages();
 	}
 
 	pfn = scan_lru_pages(start_pfn, end_pfn);
@@ -619,7 +617,7 @@ repeat:
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
@@ -900,7 +900,14 @@ void drain_zone_pages(struct zone *zone,
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
@@ -925,6 +932,22 @@ static void __drain_pages(unsigned int c
 	}
 }
 
+/*
+ * Spill all of this CPU's per-cpu pages back into the buddy allocator.
+ */
+static void drain_local_pages(void *arg)
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
@@ -962,37 +985,6 @@ void mark_free_pages(struct zone *zone)
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
@@ -1579,7 +1571,7 @@ nofail_alloc:
 	cond_resched();
 
 	if (order != 0)
-		drain_all_local_pages();
+		drain_all_pages();
 
 	if (likely(did_some_progress)) {
 		page = get_page_from_freelist(gfp_mask, order,
@@ -3969,10 +3961,23 @@ static int page_alloc_cpu_notify(struct 
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
@@ -4471,7 +4476,7 @@ int set_migratetype_isolate(struct page 
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
 	if (!ret)
-		drain_all_local_pages();
+		drain_all_pages();
 	return ret;
 }
 
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-fix-typo-in-allocation-failure-handling.patch
migration-find-correct-vma-in-new_vma_page.patch
ia64-slim-down-__clear_bit_unlock.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
git-unionfs.patch
git-x86.patch
x86_64-clean-up-stack-allocation-and-free.patch
x86_64-configure-stack-size.patch
fix-mm-utilckrealloc.patch
vmstat-fix-section-mismatch-warning.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
vunmap-return-page-array-passed-on-vmap.patch
slub-move-count_partial.patch
slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
slub-use-non-atomic-bit-unlock.patch
slub-fix-coding-style-violations.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
slub-__slab_alloc-exit-path-consolidation.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-fix.patch
slub-restructure-slab-alloc.patch
slub-comment-kmem_cache_cpu-structure.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
bufferhead-revert-constructor-removal.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
swapin_readahead-excise-numa-bogosity.patch
vmstat-small-revisions-to-refresh_cpu_vm_stats.patch
page-allocator-clean-up-pcp-draining-functions.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
