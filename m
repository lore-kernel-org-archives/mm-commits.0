From: akpm@linux-foundation.org
Subject: - swsusp-do-not-use-page-flags.patch removed from -mm tree
Date: Mon, 07 May 2007 17:05:16 -0700
Message-ID: <200705080005.l4805Gf1009081@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755265AbXEHAGJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: do not use page flags
has been removed from the -mm tree.  Its filename was
     swsusp-do-not-use-page-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: do not use page flags
From: Rafael J. Wysocki <rjw@sisk.pl>

Make swsusp use memory bitmaps instead of page flags for marking 'nosave' and
free pages.  This allows us to 'recycle' two page flags that can be used for
other purposes.  Also, the memory needed to store the bitmaps is allocated
when necessary (ie.  before the suspend) and freed after the resume which is
more reasonable.

The patch is designed to minimize the amount of changes and there are some
nice simplifications and optimizations possible on top of it.  I am going to
implement them separately in the future.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/e820.c |   26 ---
 include/linux/suspend.h   |   58 ++------
 kernel/power/disk.c       |   23 ++-
 kernel/power/main.c       |    2 
 kernel/power/power.h      |    2 
 kernel/power/snapshot.c   |  250 +++++++++++++++++++++++++++++++++---
 kernel/power/user.c       |    4 
 7 files changed, 283 insertions(+), 82 deletions(-)

diff -puN arch/x86_64/kernel/e820.c~swsusp-do-not-use-page-flags arch/x86_64/kernel/e820.c
--- a/arch/x86_64/kernel/e820.c~swsusp-do-not-use-page-flags
+++ a/arch/x86_64/kernel/e820.c
@@ -17,6 +17,8 @@
 #include <linux/kexec.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/suspend.h>
+#include <linux/pfn.h>
 
 #include <asm/pgtable.h>
 #include <asm/page.h>
@@ -256,22 +258,6 @@ void __init e820_reserve_resources(void)
 	}
 }
 
-/* Mark pages corresponding to given address range as nosave */
-static void __init
-e820_mark_nosave_range(unsigned long start, unsigned long end)
-{
-	unsigned long pfn, max_pfn;
-
-	if (start >= end)
-		return;
-
-	printk("Nosave address range: %016lx - %016lx\n", start, end);
-	max_pfn = end >> PAGE_SHIFT;
-	for (pfn = start >> PAGE_SHIFT; pfn < max_pfn; pfn++)
-		if (pfn_valid(pfn))
-			SetPageNosave(pfn_to_page(pfn));
-}
-
 /*
  * Find the ranges of physical addresses that do not correspond to
  * e820 RAM areas and mark the corresponding pages as nosave for software
@@ -290,13 +276,13 @@ void __init e820_mark_nosave_regions(voi
 		struct e820entry *ei = &e820.map[i];
 
 		if (paddr < ei->addr)
-			e820_mark_nosave_range(paddr,
-					round_up(ei->addr, PAGE_SIZE));
+			register_nosave_region(PFN_DOWN(paddr),
+						PFN_UP(ei->addr));
 
 		paddr = round_down(ei->addr + ei->size, PAGE_SIZE);
 		if (ei->type != E820_RAM)
-			e820_mark_nosave_range(round_up(ei->addr, PAGE_SIZE),
-					paddr);
+			register_nosave_region(PFN_UP(ei->addr),
+						PFN_DOWN(paddr));
 
 		if (paddr >= (end_pfn << PAGE_SHIFT))
 			break;
diff -puN include/linux/suspend.h~swsusp-do-not-use-page-flags include/linux/suspend.h
--- a/include/linux/suspend.h~swsusp-do-not-use-page-flags
+++ a/include/linux/suspend.h
@@ -24,63 +24,41 @@ struct pbe {
 extern void drain_local_pages(void);
 extern void mark_free_pages(struct zone *zone);
 
-#ifdef CONFIG_PM
-/* kernel/power/swsusp.c */
-extern int software_suspend(void);
-
-#if defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
+#if defined(CONFIG_PM) && defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
 extern int pm_prepare_console(void);
 extern void pm_restore_console(void);
 #else
 static inline int pm_prepare_console(void) { return 0; }
 static inline void pm_restore_console(void) {}
-#endif /* defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE) */
+#endif
+
+#if defined(CONFIG_PM) && defined(CONFIG_SOFTWARE_SUSPEND)
+/* kernel/power/swsusp.c */
+extern int software_suspend(void);
+/* kernel/power/snapshot.c */
+extern void __init register_nosave_region(unsigned long, unsigned long);
+extern int swsusp_page_is_forbidden(struct page *);
+extern void swsusp_set_page_free(struct page *);
+extern void swsusp_unset_page_free(struct page *);
+extern unsigned long get_safe_page(gfp_t gfp_mask);
 #else
 static inline int software_suspend(void)
 {
 	printk("Warning: fake suspend called\n");
 	return -ENOSYS;
 }
-#endif /* CONFIG_PM */
+
+static inline void register_nosave_region(unsigned long b, unsigned long e) {}
+static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
+static inline void swsusp_set_page_free(struct page *p) {}
+static inline void swsusp_unset_page_free(struct page *p) {}
+#endif /* defined(CONFIG_PM) && defined(CONFIG_SOFTWARE_SUSPEND) */
 
 void save_processor_state(void);
 void restore_processor_state(void);
 struct saved_context;
 void __save_processor_state(struct saved_context *ctxt);
 void __restore_processor_state(struct saved_context *ctxt);
-unsigned long get_safe_page(gfp_t gfp_mask);
-
-/* Page management functions for the software suspend (swsusp) */
-
-static inline void swsusp_set_page_forbidden(struct page *page)
-{
-	SetPageNosave(page);
-}
-
-static inline int swsusp_page_is_forbidden(struct page *page)
-{
-	return PageNosave(page);
-}
-
-static inline void swsusp_unset_page_forbidden(struct page *page)
-{
-	ClearPageNosave(page);
-}
-
-static inline void swsusp_set_page_free(struct page *page)
-{
-	SetPageNosaveFree(page);
-}
-
-static inline int swsusp_page_is_free(struct page *page)
-{
-	return PageNosaveFree(page);
-}
-
-static inline void swsusp_unset_page_free(struct page *page)
-{
-	ClearPageNosaveFree(page);
-}
 
 /*
  * XXX: We try to keep some more pages free so that I/O operations succeed
diff -puN kernel/power/disk.c~swsusp-do-not-use-page-flags kernel/power/disk.c
--- a/kernel/power/disk.c~swsusp-do-not-use-page-flags
+++ a/kernel/power/disk.c
@@ -139,14 +139,19 @@ int pm_suspend_disk(void)
 		mdelay(5000);
 		goto Thaw;
 	}
+	/* Allocate memory management structures */
+	error = create_basic_memory_bitmaps();
+	if (error)
+		goto Thaw;
+
 	/* Free memory before shutting down devices. */
 	error = swsusp_shrink_memory();
 	if (error)
-		goto Thaw;
+		goto Finish;
 
 	error = platform_prepare();
 	if (error)
-		goto Thaw;
+		goto Finish;
 
 	suspend_console();
 	error = device_suspend(PMSG_FREEZE);
@@ -181,7 +186,7 @@ int pm_suspend_disk(void)
 			power_down();
 		else {
 			swsusp_free();
-			goto Thaw;
+			goto Finish;
 		}
 	} else {
 		pr_debug("PM: Image restored successfully.\n");
@@ -194,6 +199,8 @@ int pm_suspend_disk(void)
 	platform_finish();
 	device_resume();
 	resume_console();
+ Finish:
+	free_basic_memory_bitmaps();
  Thaw:
 	unprepare_processes();
 	return error;
@@ -239,13 +246,15 @@ static int software_resume(void)
 	}
 
 	pr_debug("PM: Checking swsusp image.\n");
-
 	error = swsusp_check();
 	if (error)
-		goto Done;
+		goto Unlock;
 
-	pr_debug("PM: Preparing processes for restore.\n");
+	error = create_basic_memory_bitmaps();
+	if (error)
+		goto Unlock;
 
+	pr_debug("PM: Preparing processes for restore.\n");
 	error = prepare_processes();
 	if (error) {
 		swsusp_close();
@@ -280,7 +289,9 @@ static int software_resume(void)
 	printk(KERN_ERR "PM: Restore failed, recovering.\n");
 	unprepare_processes();
  Done:
+	free_basic_memory_bitmaps();
 	/* For success case, the suspend path will release the lock */
+ Unlock:
 	mutex_unlock(&pm_mutex);
 	pr_debug("PM: Resume from disk failed.\n");
 	return 0;
diff -puN kernel/power/main.c~swsusp-do-not-use-page-flags kernel/power/main.c
--- a/kernel/power/main.c~swsusp-do-not-use-page-flags
+++ a/kernel/power/main.c
@@ -244,6 +244,7 @@ static int enter_state(suspend_state_t s
 	return error;
 }
 
+#ifdef CONFIG_SOFTWARE_SUSPEND
 /*
  * This is main interface to the outside world. It needs to be
  * called from process context.
@@ -252,6 +253,7 @@ int software_suspend(void)
 {
 	return enter_state(PM_SUSPEND_DISK);
 }
+#endif
 
 
 /**
diff -puN kernel/power/power.h~swsusp-do-not-use-page-flags kernel/power/power.h
--- a/kernel/power/power.h~swsusp-do-not-use-page-flags
+++ a/kernel/power/power.h
@@ -48,6 +48,8 @@ extern sector_t swsusp_resume_block;
 extern asmlinkage int swsusp_arch_suspend(void);
 extern asmlinkage int swsusp_arch_resume(void);
 
+extern int create_basic_memory_bitmaps(void);
+extern void free_basic_memory_bitmaps(void);
 extern unsigned int count_data_pages(void);
 
 /**
diff -puN kernel/power/snapshot.c~swsusp-do-not-use-page-flags kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~swsusp-do-not-use-page-flags
+++ a/kernel/power/snapshot.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/pm.h>
 #include <linux/device.h>
+#include <linux/init.h>
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
 #include <linux/console.h>
@@ -34,6 +35,10 @@
 
 #include "power.h"
 
+static int swsusp_page_is_free(struct page *);
+static void swsusp_set_page_forbidden(struct page *);
+static void swsusp_unset_page_forbidden(struct page *);
+
 /* List of PBEs needed for restoring the pages that were allocated before
  * the suspend and included in the suspend image, but have also been
  * allocated by the "resume" kernel, so their contents cannot be written
@@ -224,11 +229,6 @@ static void chain_free(struct chain_allo
  *	of type unsigned long each).  It also contains the pfns that
  *	correspond to the start and end of the represented memory area and
  *	the number of bit chunks in the block.
- *
- *	NOTE: Memory bitmaps are used for two types of operations only:
- *	"set a bit" and "find the next bit set".  Moreover, the searching
- *	is always carried out after all of the "set a bit" operations
- *	on given bitmap.
  */
 
 #define BM_END_OF_MAP	(~0UL)
@@ -443,15 +443,13 @@ static void memory_bm_free(struct memory
 }
 
 /**
- *	memory_bm_set_bit - set the bit in the bitmap @bm that corresponds
+ *	memory_bm_find_bit - find the bit in the bitmap @bm that corresponds
  *	to given pfn.  The cur_zone_bm member of @bm and the cur_block member
  *	of @bm->cur_zone_bm are updated.
- *
- *	If the bit cannot be set, the function returns -EINVAL .
  */
 
-static int
-memory_bm_set_bit(struct memory_bitmap *bm, unsigned long pfn)
+static void memory_bm_find_bit(struct memory_bitmap *bm, unsigned long pfn,
+				void **addr, unsigned int *bit_nr)
 {
 	struct zone_bitmap *zone_bm;
 	struct bm_block *bb;
@@ -463,8 +461,8 @@ memory_bm_set_bit(struct memory_bitmap *
 		/* We don't assume that the zones are sorted by pfns */
 		while (pfn < zone_bm->start_pfn || pfn >= zone_bm->end_pfn) {
 			zone_bm = zone_bm->next;
-			if (unlikely(!zone_bm))
-				return -EINVAL;
+
+			BUG_ON(!zone_bm);
 		}
 		bm->cur.zone_bm = zone_bm;
 	}
@@ -475,13 +473,40 @@ memory_bm_set_bit(struct memory_bitmap *
 
 	while (pfn >= bb->end_pfn) {
 		bb = bb->next;
-		if (unlikely(!bb))
-			return -EINVAL;
+
+		BUG_ON(!bb);
 	}
 	zone_bm->cur_block = bb;
 	pfn -= bb->start_pfn;
-	set_bit(pfn % BM_BITS_PER_CHUNK, bb->data + pfn / BM_BITS_PER_CHUNK);
-	return 0;
+	*bit_nr = pfn % BM_BITS_PER_CHUNK;
+	*addr = bb->data + pfn / BM_BITS_PER_CHUNK;
+}
+
+static void memory_bm_set_bit(struct memory_bitmap *bm, unsigned long pfn)
+{
+	void *addr;
+	unsigned int bit;
+
+	memory_bm_find_bit(bm, pfn, &addr, &bit);
+	set_bit(bit, addr);
+}
+
+static void memory_bm_clear_bit(struct memory_bitmap *bm, unsigned long pfn)
+{
+	void *addr;
+	unsigned int bit;
+
+	memory_bm_find_bit(bm, pfn, &addr, &bit);
+	clear_bit(bit, addr);
+}
+
+static int memory_bm_test_bit(struct memory_bitmap *bm, unsigned long pfn)
+{
+	void *addr;
+	unsigned int bit;
+
+	memory_bm_find_bit(bm, pfn, &addr, &bit);
+	return test_bit(bit, addr);
 }
 
 /* Two auxiliary functions for memory_bm_next_pfn */
@@ -564,6 +589,199 @@ static unsigned long memory_bm_next_pfn(
 }
 
 /**
+ *	This structure represents a range of page frames the contents of which
+ *	should not be saved during the suspend.
+ */
+
+struct nosave_region {
+	struct list_head list;
+	unsigned long start_pfn;
+	unsigned long end_pfn;
+};
+
+static LIST_HEAD(nosave_regions);
+
+/**
+ *	register_nosave_region - register a range of page frames the contents
+ *	of which should not be saved during the suspend (to be used in the early
+ *	initializatoion code)
+ */
+
+void __init
+register_nosave_region(unsigned long start_pfn, unsigned long end_pfn)
+{
+	struct nosave_region *region;
+
+	if (start_pfn >= end_pfn)
+		return;
+
+	if (!list_empty(&nosave_regions)) {
+		/* Try to extend the previous region (they should be sorted) */
+		region = list_entry(nosave_regions.prev,
+					struct nosave_region, list);
+		if (region->end_pfn == start_pfn) {
+			region->end_pfn = end_pfn;
+			goto Report;
+		}
+	}
+	/* This allocation cannot fail */
+	region = alloc_bootmem_low(sizeof(struct nosave_region));
+	region->start_pfn = start_pfn;
+	region->end_pfn = end_pfn;
+	list_add_tail(&region->list, &nosave_regions);
+ Report:
+	printk("swsusp: Registered nosave memory region: %016lx - %016lx\n",
+		start_pfn << PAGE_SHIFT, end_pfn << PAGE_SHIFT);
+}
+
+/*
+ * Set bits in this map correspond to the page frames the contents of which
+ * should not be saved during the suspend.
+ */
+static struct memory_bitmap *forbidden_pages_map;
+
+/* Set bits in this map correspond to free page frames. */
+static struct memory_bitmap *free_pages_map;
+
+/*
+ * Each page frame allocated for creating the image is marked by setting the
+ * corresponding bits in forbidden_pages_map and free_pages_map simultaneously
+ */
+
+void swsusp_set_page_free(struct page *page)
+{
+	if (free_pages_map)
+		memory_bm_set_bit(free_pages_map, page_to_pfn(page));
+}
+
+static int swsusp_page_is_free(struct page *page)
+{
+	return free_pages_map ?
+		memory_bm_test_bit(free_pages_map, page_to_pfn(page)) : 0;
+}
+
+void swsusp_unset_page_free(struct page *page)
+{
+	if (free_pages_map)
+		memory_bm_clear_bit(free_pages_map, page_to_pfn(page));
+}
+
+static void swsusp_set_page_forbidden(struct page *page)
+{
+	if (forbidden_pages_map)
+		memory_bm_set_bit(forbidden_pages_map, page_to_pfn(page));
+}
+
+int swsusp_page_is_forbidden(struct page *page)
+{
+	return forbidden_pages_map ?
+		memory_bm_test_bit(forbidden_pages_map, page_to_pfn(page)) : 0;
+}
+
+static void swsusp_unset_page_forbidden(struct page *page)
+{
+	if (forbidden_pages_map)
+		memory_bm_clear_bit(forbidden_pages_map, page_to_pfn(page));
+}
+
+/**
+ *	mark_nosave_pages - set bits corresponding to the page frames the
+ *	contents of which should not be saved in a given bitmap.
+ */
+
+static void mark_nosave_pages(struct memory_bitmap *bm)
+{
+	struct nosave_region *region;
+
+	if (list_empty(&nosave_regions))
+		return;
+
+	list_for_each_entry(region, &nosave_regions, list) {
+		unsigned long pfn;
+
+		printk("swsusp: Marking nosave pages: %016lx - %016lx\n",
+				region->start_pfn << PAGE_SHIFT,
+				region->end_pfn << PAGE_SHIFT);
+
+		for (pfn = region->start_pfn; pfn < region->end_pfn; pfn++)
+			memory_bm_set_bit(bm, pfn);
+	}
+}
+
+/**
+ *	create_basic_memory_bitmaps - create bitmaps needed for marking page
+ *	frames that should not be saved and free page frames.  The pointers
+ *	forbidden_pages_map and free_pages_map are only modified if everything
+ *	goes well, because we don't want the bits to be used before both bitmaps
+ *	are set up.
+ */
+
+int create_basic_memory_bitmaps(void)
+{
+	struct memory_bitmap *bm1, *bm2;
+	int error = 0;
+
+	BUG_ON(forbidden_pages_map || free_pages_map);
+
+	bm1 = kzalloc(sizeof(struct memory_bitmap), GFP_ATOMIC);
+	if (!bm1)
+		return -ENOMEM;
+
+	error = memory_bm_create(bm1, GFP_ATOMIC | __GFP_COLD, PG_ANY);
+	if (error)
+		goto Free_first_object;
+
+	bm2 = kzalloc(sizeof(struct memory_bitmap), GFP_ATOMIC);
+	if (!bm2)
+		goto Free_first_bitmap;
+
+	error = memory_bm_create(bm2, GFP_ATOMIC | __GFP_COLD, PG_ANY);
+	if (error)
+		goto Free_second_object;
+
+	forbidden_pages_map = bm1;
+	free_pages_map = bm2;
+	mark_nosave_pages(forbidden_pages_map);
+
+	printk("swsusp: Basic memory bitmaps created\n");
+
+	return 0;
+
+ Free_second_object:
+	kfree(bm2);
+ Free_first_bitmap:
+ 	memory_bm_free(bm1, PG_UNSAFE_CLEAR);
+ Free_first_object:
+	kfree(bm1);
+	return -ENOMEM;
+}
+
+/**
+ *	free_basic_memory_bitmaps - free memory bitmaps allocated by
+ *	create_basic_memory_bitmaps().  The auxiliary pointers are necessary
+ *	so that the bitmaps themselves are not referred to while they are being
+ *	freed.
+ */
+
+void free_basic_memory_bitmaps(void)
+{
+	struct memory_bitmap *bm1, *bm2;
+
+	BUG_ON(!(forbidden_pages_map && free_pages_map));
+
+	bm1 = forbidden_pages_map;
+	bm2 = free_pages_map;
+	forbidden_pages_map = NULL;
+	free_pages_map = NULL;
+	memory_bm_free(bm1, PG_UNSAFE_CLEAR);
+	kfree(bm1);
+	memory_bm_free(bm2, PG_UNSAFE_CLEAR);
+	kfree(bm2);
+
+	printk("swsusp: Basic memory bitmaps freed\n");
+}
+
+/**
  *	snapshot_additional_pages - estimate the number of additional pages
  *	be needed for setting up the suspend image data structures for given
  *	zone (usually the returned value is greater than the exact number)
diff -puN kernel/power/user.c~swsusp-do-not-use-page-flags kernel/power/user.c
--- a/kernel/power/user.c~swsusp-do-not-use-page-flags
+++ a/kernel/power/user.c
@@ -52,6 +52,9 @@ static int snapshot_open(struct inode *i
 	if ((filp->f_flags & O_ACCMODE) == O_RDWR)
 		return -ENOSYS;
 
+	if(create_basic_memory_bitmaps())
+		return -ENOMEM;
+
 	nonseekable_open(inode, filp);
 	data = &snapshot_state;
 	filp->private_data = data;
@@ -77,6 +80,7 @@ static int snapshot_release(struct inode
 	struct snapshot_data *data;
 
 	swsusp_free();
+	free_basic_memory_bitmaps();
 	data = filp->private_data;
 	free_all_swap_pages(data->swap, data->bitmap);
 	free_bitmap(data->bitmap);
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
swsusp-clean-up-print.patch
pm-separate-hibernation-code-from-suspend-code.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
workqueues-shift-kthread_bind-from-cpu_up_prepare-to-cpu_online.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
remvoe-kthread_bind-call-from-_cpu_down.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
add-suspend-related-notifications-for-cpu-hotplug.patch
add-suspend-related-notifications-for-cpu-hotplug-cleanup.patch
microcode-use-suspend-related-cpu-hotplug-notifications.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
