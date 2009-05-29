From: akpm@linux-foundation.org
Subject: [to-be-updated] pm-hibernate-do-not-release-preallocated-memory-unnecessarily-rev-2.patch removed from -mm tree
Date: Fri, 29 May 2009 13:45:42 -0700
Message-ID: <200905292045.n4TKjgap001056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752284AbZE2UqT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 16:46:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, fengguang.wu@intel.com, nigel@tuxonice.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     pm/hibernate: do not release preallocated memory unnecessarily
has been removed from the -mm tree.  Its filename was
     pm-hibernate-do-not-release-preallocated-memory-unnecessarily-rev-2.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm/hibernate: do not release preallocated memory unnecessarily
From: Rafael J. Wysocki <rjw@sisk.pl>

Since the hibernation code is now going to use allocations of memory to
make enough room for the image, it can also use the page frames allocated
at this stage as image page frames.  The low-level hibernation code needs
to be rearranged for this purpose, but it allows us to avoid freeing a
great number of pages and allocating these same pages once again later, so
it generally is worth doing.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@tuxonice.net>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c     |   15 ++
 kernel/power/power.h    |    2 
 kernel/power/snapshot.c |  204 +++++++++++++++++++++++++-------------
 3 files changed, 148 insertions(+), 73 deletions(-)

diff -puN kernel/power/disk.c~pm-hibernate-do-not-release-preallocated-memory-unnecessarily-rev-2 kernel/power/disk.c
--- a/kernel/power/disk.c~pm-hibernate-do-not-release-preallocated-memory-unnecessarily-rev-2
+++ a/kernel/power/disk.c
@@ -298,8 +298,8 @@ int hibernation_snapshot(int platform_mo
 	if (error)
 		return error;
 
-	/* Free memory before shutting down devices. */
-	error = swsusp_shrink_memory();
+	/* Preallocate image memory before shutting down devices. */
+	error = hibernate_preallocate_memory();
 	if (error)
 		goto Close;
 
@@ -315,6 +315,10 @@ int hibernation_snapshot(int platform_mo
 	/* Control returns here after successful restore */
 
  Resume_devices:
+	/* We may need to release the preallocated image pages here. */
+	if (error || !in_suspend)
+		swsusp_free();
+
 	dpm_resume_end(in_suspend ?
 		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
 	resume_console();
@@ -578,7 +582,10 @@ int hibernate(void)
 		goto Thaw;
 
 	error = hibernation_snapshot(hibernation_mode == HIBERNATION_PLATFORM);
-	if (in_suspend && !error) {
+	if (error)
+		goto Thaw;
+
+	if (in_suspend) {
 		unsigned int flags = 0;
 
 		if (hibernation_mode == HIBERNATION_PLATFORM)
@@ -590,8 +597,8 @@ int hibernate(void)
 			power_down();
 	} else {
 		pr_debug("PM: Image restored successfully.\n");
-		swsusp_free();
 	}
+
  Thaw:
 	thaw_processes();
  Finish:
diff -puN kernel/power/power.h~pm-hibernate-do-not-release-preallocated-memory-unnecessarily-rev-2 kernel/power/power.h
--- a/kernel/power/power.h~pm-hibernate-do-not-release-preallocated-memory-unnecessarily-rev-2
+++ a/kernel/power/power.h
@@ -74,7 +74,7 @@ extern asmlinkage int swsusp_arch_resume
 
 extern int create_basic_memory_bitmaps(void);
 extern void free_basic_memory_bitmaps(void);
-extern int swsusp_shrink_memory(void);
+extern int hibernate_preallocate_memory(void);
 
 /**
  *	Auxiliary structure used for reading the snapshot image data and
diff -puN kernel/power/snapshot.c~pm-hibernate-do-not-release-preallocated-memory-unnecessarily-rev-2 kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~pm-hibernate-do-not-release-preallocated-memory-unnecessarily-rev-2
+++ a/kernel/power/snapshot.c
@@ -1033,6 +1033,25 @@ copy_data_pages(struct memory_bitmap *co
 static unsigned int nr_copy_pages;
 /* Number of pages needed for saving the original pfns of the image pages */
 static unsigned int nr_meta_pages;
+/*
+ * Numbers of normal and highmem page frames allocated for hibernation image
+ * before suspending devices.
+ */
+unsigned int alloc_normal, alloc_highmem;
+/*
+ * Memory bitmap used for marking saveable pages (during hibernation) or
+ * hibernation image pages (during restore)
+ */
+static struct memory_bitmap orig_bm;
+/*
+ * Memory bitmap used during hibernation for marking allocated page frames that
+ * will contain copies of saveable pages.  During restore it is initially used
+ * for marking hibernation image pages, but then the set bits from it are
+ * duplicated in @orig_bm and it is released.  On highmem systems it is next
+ * used for marking "safe" highmem pages, but it has to be reinitialized for
+ * this purpose.
+ */
+static struct memory_bitmap copy_bm;
 
 /**
  *	swsusp_free - free pages allocated for the suspend.
@@ -1064,6 +1083,8 @@ void swsusp_free(void)
 	nr_meta_pages = 0;
 	restore_pblist = NULL;
 	buffer = NULL;
+	alloc_normal = 0;
+	alloc_highmem = 0;
 }
 
 /* Helper functions used for the shrinking of memory. */
@@ -1082,8 +1103,16 @@ static unsigned long preallocate_image_p
 	unsigned long nr_alloc = 0;
 
 	while (nr_pages > 0) {
-		if (!alloc_image_page(mask))
-			break;
+ 		struct page *page;
+
+		page = alloc_image_page(mask);
+ 		if (!page)
+ 			break;
+		memory_bm_set_bit(&copy_bm, page_to_pfn(page));
+		if (PageHighMem(page))
+			alloc_highmem++;
+		else
+			alloc_normal++;
 		nr_pages--;
 		nr_alloc++;
 	}
@@ -1144,7 +1173,47 @@ static inline unsigned long highmem_size
 #endif /* CONFIG_HIGHMEM */
 
 /**
- * swsusp_shrink_memory -  Make the kernel release as much memory as needed
+ * free_unnecessary_pages - Release preallocated pages not needed for the image
+ */
+static void free_unnecessary_pages(void)
+{
+	unsigned long save_highmem, to_free_normal, to_free_highmem;
+
+	to_free_normal = alloc_normal - count_data_pages();
+	save_highmem = count_highmem_pages();
+	if (alloc_highmem > save_highmem) {
+		to_free_highmem = alloc_highmem - save_highmem;
+	} else {
+		to_free_highmem = 0;
+		to_free_normal -= save_highmem - alloc_highmem;
+	}
+
+	memory_bm_position_reset(&copy_bm);
+
+	while (to_free_normal > 0 && to_free_highmem > 0) {
+		unsigned long pfn = memory_bm_next_pfn(&copy_bm);
+		struct page *page = pfn_to_page(pfn);
+
+		if (PageHighMem(page)) {
+			if (!to_free_highmem)
+				continue;
+			to_free_highmem--;
+			alloc_highmem--;
+		} else {
+			if (!to_free_normal)
+				continue;
+			to_free_normal--;
+			alloc_normal--;
+		}
+		memory_bm_clear_bit(&copy_bm, pfn);
+		swsusp_unset_page_forbidden(page);
+		swsusp_unset_page_free(page);
+		__free_page(page);
+	}
+}
+
+/**
+ * hibernate_preallocate_memory - Preallocate memory for hibernation image
  *
  * To create a hibernation image it is necessary to make a copy of every page
  * frame in use.  We also need a number of page frames to be free during
@@ -1163,19 +1232,30 @@ static inline unsigned long highmem_size
  * pages in the system is below the requested image size or it is impossible to
  * allocate more memory, whichever happens first.
  */
-int swsusp_shrink_memory(void)
+int hibernate_preallocate_memory(void)
 {
 	struct zone *zone;
 	unsigned long saveable, size, max_size, count, highmem, pages = 0;
-	unsigned long alloc, pages_highmem;
+	unsigned long alloc, save_highmem, pages_highmem;
 	struct timeval start, stop;
-	int error = 0;
+	int error;
 
-	printk(KERN_INFO "PM: Shrinking memory... ");
+	printk(KERN_INFO "PM: Preallocating image memory... ");
 	do_gettimeofday(&start);
 
+	error = memory_bm_create(&orig_bm, GFP_IMAGE, PG_ANY);
+	if (error)
+		goto err_out;
+
+	error = memory_bm_create(&copy_bm, GFP_IMAGE, PG_ANY);
+	if (error)
+		goto err_out;
+
+	alloc_normal = 0;
+	alloc_highmem = 0;
+
 	/* Count the number of saveable data pages. */
-	highmem = count_highmem_pages();
+	save_highmem = count_highmem_pages();
 	saveable = count_data_pages();
 
 	/*
@@ -1183,7 +1263,8 @@ int swsusp_shrink_memory(void)
 	 * number of pages needed for image metadata (size).
 	 */
 	count = saveable;
-	saveable += highmem;
+	saveable += save_highmem;
+	highmem = save_highmem;
 	size = 0;
 	for_each_populated_zone(zone) {
 		size += snapshot_additional_pages(zone);
@@ -1202,10 +1283,13 @@ int swsusp_shrink_memory(void)
 		size = max_size;
 	/*
 	 * If the maximum is not less than the current number of saveable pages
-	 * in memory, we don't need to do anything more.
+	 * in memory, allocate page frames for the image and we're done.
 	 */
-	if (size >= saveable)
+	if (size >= saveable) {
+		pages = preallocate_image_highmem(save_highmem);
+		pages += preallocate_image_memory(saveable - pages);
 		goto out;
+	}
 
 	/*
 	 * Let the memory management subsystem know that we're going to need a
@@ -1226,10 +1310,8 @@ int swsusp_shrink_memory(void)
 	max_size += pages_highmem;
 	alloc = count - max_size;
 	pages = preallocate_image_memory(alloc);
-	if (pages < alloc) {
-		error = -ENOMEM;
-		goto free_out;
-	}
+	if (pages < alloc)
+		goto err_out;
 	size = max_size - size;
 	alloc = size;
 	size = preallocate_image_highmem(highmem_size(size, highmem, count));
@@ -1238,21 +1320,24 @@ int swsusp_shrink_memory(void)
 	pages += preallocate_image_memory(alloc);
 	pages += pages_highmem;
 
- free_out:
-	/* Release all of the preallocated page frames. */
-	swsusp_free();
-
-	if (error) {
-		printk(KERN_CONT "\n");
-		return error;
-	}
+	/*
+	 * We only need as many page frames for the image as there are saveable
+	 * pages in memory, but we have allocated more.  Release the excessive
+	 * ones now.
+	 */
+	free_unnecessary_pages();
 
  out:
 	do_gettimeofday(&stop);
-	printk(KERN_CONT "done (preallocated %lu free pages)\n", pages);
-	swsusp_show_speed(&start, &stop, pages, "Freed");
+	printk(KERN_CONT "done (allocated %lu pages)\n", pages);
+	swsusp_show_speed(&start, &stop, pages, "Allocated");
 
 	return 0;
+
+ err_out:
+	printk(KERN_CONT "\n");
+	swsusp_free();
+	return -ENOMEM;
 }
 
 #ifdef CONFIG_HIGHMEM
@@ -1263,7 +1348,7 @@ int swsusp_shrink_memory(void)
 
 static unsigned int count_pages_for_highmem(unsigned int nr_highmem)
 {
-	unsigned int free_highmem = count_free_highmem_pages();
+	unsigned int free_highmem = count_free_highmem_pages() + alloc_highmem;
 
 	if (free_highmem >= nr_highmem)
 		nr_highmem = 0;
@@ -1285,19 +1370,17 @@ count_pages_for_highmem(unsigned int nr_
 static int enough_free_mem(unsigned int nr_pages, unsigned int nr_highmem)
 {
 	struct zone *zone;
-	unsigned int free = 0, meta = 0;
+	unsigned int free = alloc_normal;
 
-	for_each_zone(zone) {
-		meta += snapshot_additional_pages(zone);
+	for_each_zone(zone)
 		if (!is_highmem(zone))
 			free += zone_page_state(zone, NR_FREE_PAGES);
-	}
 
 	nr_pages += count_pages_for_highmem(nr_highmem);
-	pr_debug("PM: Normal pages needed: %u + %u + %u, available pages: %u\n",
-		nr_pages, PAGES_FOR_IO, meta, free);
+	pr_debug("PM: Normal pages needed: %u + %u, available pages: %u\n",
+		nr_pages, PAGES_FOR_IO, free);
 
-	return free > nr_pages + PAGES_FOR_IO + meta;
+	return free > nr_pages + PAGES_FOR_IO;
 }
 
 #ifdef CONFIG_HIGHMEM
@@ -1319,7 +1402,7 @@ static inline int get_highmem_buffer(int
  */
 
 static inline unsigned int
-alloc_highmem_image_pages(struct memory_bitmap *bm, unsigned int nr_highmem)
+alloc_highmem_pages(struct memory_bitmap *bm, unsigned int nr_highmem)
 {
 	unsigned int to_alloc = count_free_highmem_pages();
 
@@ -1339,7 +1422,7 @@ alloc_highmem_image_pages(struct memory_
 static inline int get_highmem_buffer(int safe_needed) { return 0; }
 
 static inline unsigned int
-alloc_highmem_image_pages(struct memory_bitmap *bm, unsigned int n) { return 0; }
+alloc_highmem_pages(struct memory_bitmap *bm, unsigned int n) { return 0; }
 #endif /* CONFIG_HIGHMEM */
 
 /**
@@ -1358,51 +1441,36 @@ static int
 swsusp_alloc(struct memory_bitmap *orig_bm, struct memory_bitmap *copy_bm,
 		unsigned int nr_pages, unsigned int nr_highmem)
 {
-	int error;
-
-	error = memory_bm_create(orig_bm, GFP_ATOMIC | __GFP_COLD, PG_ANY);
-	if (error)
-		goto Free;
-
-	error = memory_bm_create(copy_bm, GFP_ATOMIC | __GFP_COLD, PG_ANY);
-	if (error)
-		goto Free;
+	int error = 0;
 
 	if (nr_highmem > 0) {
 		error = get_highmem_buffer(PG_ANY);
 		if (error)
-			goto Free;
-
-		nr_pages += alloc_highmem_image_pages(copy_bm, nr_highmem);
+			goto err_out;
+		if (nr_highmem > alloc_highmem) {
+			nr_highmem -= alloc_highmem;
+			nr_pages += alloc_highmem_pages(copy_bm, nr_highmem);
+		}
 	}
-	while (nr_pages-- > 0) {
-		struct page *page = alloc_image_page(GFP_ATOMIC | __GFP_COLD);
-
-		if (!page)
-			goto Free;
+	if (nr_pages > alloc_normal) {
+		nr_pages -= alloc_normal;
+		while (nr_pages-- > 0) {
+			struct page *page;
 
-		memory_bm_set_bit(copy_bm, page_to_pfn(page));
+			page = alloc_image_page(GFP_ATOMIC | __GFP_COLD);
+			if (!page)
+				goto err_out;
+			memory_bm_set_bit(copy_bm, page_to_pfn(page));
+		}
 	}
+
 	return 0;
 
- Free:
+ err_out:
 	swsusp_free();
-	return -ENOMEM;
+	return error;
 }
 
-/* Memory bitmap used for marking saveable pages (during suspend) or the
- * suspend image pages (during resume)
- */
-static struct memory_bitmap orig_bm;
-/* Memory bitmap used on suspend for marking allocated pages that will contain
- * the copies of saveable pages.  During resume it is initially used for
- * marking the suspend image pages, but then its set bits are duplicated in
- * @orig_bm and it is released.  Next, on systems with high memory, it may be
- * used for marking "safe" highmem pages, but it has to be reinitialized for
- * this purpose.
- */
-static struct memory_bitmap copy_bm;
