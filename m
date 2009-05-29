From: akpm@linux-foundation.org
Subject: [withdrawn] pm-hibernate-rework-shrinking-of-memory.patch removed from -mm tree
Date: Fri, 29 May 2009 13:45:35 -0700
Message-ID: <200905292045.n4TKjZqE000958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752013AbZE2UqL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 16:46:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, fengguang.wu@intel.com, nigel@tuxonice.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     pm/hibernate: rework shrinking of memory
has been removed from the -mm tree.  Its filename was
     pm-hibernate-rework-shrinking-of-memory.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm/hibernate: rework shrinking of memory
From: Rafael J. Wysocki <rjw@sisk.pl>

Rework swsusp_shrink_memory() so that it calls shrink_all_memory() just
once to make some room for the image and then allocates memory to apply
more pressure to the memory management subsystem, if necessary.

Unfortunately, we don't seem to be able to drop shrink_all_memory()
entirely just yet, because that would lead to huge performance regressions
in some test cases.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@tuxonice.net>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/snapshot.c |  211 +++++++++++++++++++++++++++++---------
 1 file changed, 166 insertions(+), 45 deletions(-)

diff -puN kernel/power/snapshot.c~pm-hibernate-rework-shrinking-of-memory kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~pm-hibernate-rework-shrinking-of-memory
+++ a/kernel/power/snapshot.c
@@ -1066,69 +1066,190 @@ void swsusp_free(void)
 	buffer = NULL;
 }
 
+/* Helper functions used for the shrinking of memory. */
+
+#define GFP_IMAGE	(GFP_KERNEL | __GFP_NOWARN)
+
 /**
- *	swsusp_shrink_memory -  Try to free as much memory as needed
+ * preallocate_image_pages - Allocate a number of pages for hibernation image
+ * @nr_pages: Number of page frames to allocate.
+ * @mask: GFP flags to use for the allocation.
  *
- *	... but do not OOM-kill anyone
+ * Return value: Number of page frames actually allocated
+ */
+static unsigned long preallocate_image_pages(unsigned long nr_pages, gfp_t mask)
+{
+	unsigned long nr_alloc = 0;
+
+	while (nr_pages > 0) {
+		if (!alloc_image_page(mask))
+			break;
+		nr_pages--;
+		nr_alloc++;
+	}
+
+	return nr_alloc;
+}
+
+static unsigned long preallocate_image_memory(unsigned long nr_pages)
+{
+	return preallocate_image_pages(nr_pages, GFP_IMAGE);
+}
+
+#ifdef CONFIG_HIGHMEM
+static unsigned long preallocate_image_highmem(unsigned long nr_pages)
+{
+	return preallocate_image_pages(nr_pages, GFP_IMAGE | __GFP_HIGHMEM);
+}
+
+#define FRACTION_SHIFT	8
+
+/**
+ * compute_fraction - Compute approximate fraction x * (a/b)
+ * @x: Number to multiply.
+ * @numerator: Numerator of the fraction (a).
+ * @denominator: Denominator of the fraction (b).
  *
- *	Notice: all userland should be stopped before it is called, or
- *	livelock is possible.
+ * Compute an approximate value of the expression x * (a/b), where a is less
+ * than b, all x, a, b are unsigned longs and x * a may be greater than the
+ * maximum unsigned long.
  */
+static unsigned long compute_fraction(
+	unsigned long x, unsigned long numerator, unsigned long denominator)
+{
+	unsigned long ratio = (numerator << FRACTION_SHIFT) / denominator;
+
+	x *= ratio;
+	return x >> FRACTION_SHIFT;
+}
+
+static unsigned long highmem_size(
+	unsigned long size, unsigned long highmem, unsigned long count)
+{
+	return highmem > count / 2 ?
+			compute_fraction(size, highmem, count) :
+			size - compute_fraction(size, count - highmem, count);
+}
+#else
+static inline unsigned long preallocate_image_highmem(unsigned long nr_pages)
+{
+	return 0;
+}
 
-#define SHRINK_BITE	10000
-static inline unsigned long __shrink_memory(long tmp)
+static inline unsigned long highmem_size(
+	unsigned long size, unsigned long highmem, unsigned long count)
 {
-	if (tmp > SHRINK_BITE)
-		tmp = SHRINK_BITE;
-	return shrink_all_memory(tmp);
+	return 0;
 }
+#endif /* CONFIG_HIGHMEM */
 
+/**
+ * swsusp_shrink_memory -  Make the kernel release as much memory as needed
+ *
+ * To create a hibernation image it is necessary to make a copy of every page
+ * frame in use.  We also need a number of page frames to be free during
+ * hibernation for allocations made while saving the image and for device
+ * drivers, in case they need to allocate memory from their hibernation
+ * callbacks (these two numbers are given by PAGES_FOR_IO and SPARE_PAGES,
+ * respectively, both of which are rough estimates).  To make this happen, we
+ * compute the total number of available page frames and allocate at least
+ *
+ * ([page frames total] + PAGES_FOR_IO + [metadata pages]) / 2 + 2 * SPARE_PAGES
+ *
+ * of them, which corresponds to the maximum size of a hibernation image.
+ *
+ * If image_size is set below the number following from the above formula,
+ * the preallocation of memory is continued until the total number of saveable
+ * pages in the system is below the requested image size or it is impossible to
+ * allocate more memory, whichever happens first.
+ */
 int swsusp_shrink_memory(void)
 {
-	long tmp;
 	struct zone *zone;
-	unsigned long pages = 0;
-	unsigned int i = 0;
-	char *p = "-\\|/";
+	unsigned long saveable, size, max_size, count, highmem, pages = 0;
+	unsigned long alloc, pages_highmem;
 	struct timeval start, stop;
+	int error = 0;
 
-	printk(KERN_INFO "PM: Shrinking memory...  ");
+	printk(KERN_INFO "PM: Shrinking memory... ");
 	do_gettimeofday(&start);
-	do {
-		long size, highmem_size;
 
-		highmem_size = count_highmem_pages();
-		size = count_data_pages() + PAGES_FOR_IO + SPARE_PAGES;
-		tmp = size;
-		size += highmem_size;
-		for_each_populated_zone(zone) {
-			tmp += snapshot_additional_pages(zone);
-			if (is_highmem(zone)) {
-				highmem_size -=
-					zone_page_state(zone, NR_FREE_PAGES);
-			} else {
-				tmp -= zone_page_state(zone, NR_FREE_PAGES);
-				tmp += zone->lowmem_reserve[ZONE_NORMAL];
-			}
-		}
+	/* Count the number of saveable data pages. */
+	highmem = count_highmem_pages();
+	saveable = count_data_pages();
 
-		if (highmem_size < 0)
-			highmem_size = 0;
+	/*
+	 * Compute the total number of page frames we can use (count) and the
+	 * number of pages needed for image metadata (size).
+	 */
+	count = saveable;
+	saveable += highmem;
+	size = 0;
+	for_each_populated_zone(zone) {
+		size += snapshot_additional_pages(zone);
+		if (is_highmem(zone))
+			highmem += zone_page_state(zone, NR_FREE_PAGES);
+		else
+			count += zone_page_state(zone, NR_FREE_PAGES);
+	}
+	count += highmem;
+	count -= totalreserve_pages;
 
-		tmp += highmem_size;
-		if (tmp > 0) {
-			tmp = __shrink_memory(tmp);
-			if (!tmp)
-				return -ENOMEM;
-			pages += tmp;
-		} else if (size > image_size / PAGE_SIZE) {
-			tmp = __shrink_memory(size - (image_size / PAGE_SIZE));
-			pages += tmp;
-		}
-		printk("\b%c", p[i++%4]);
-	} while (tmp > 0);
+	/* Compute the maximum number of saveable pages to leave in memory. */
+	max_size = (count - (size + PAGES_FOR_IO)) / 2 - 2 * SPARE_PAGES;
+	size = DIV_ROUND_UP(image_size, PAGE_SIZE);
+	if (size > max_size)
+		size = max_size;
+	/*
+	 * If the maximum is not less than the current number of saveable pages
+	 * in memory, we don't need to do anything more.
+	 */
+	if (size >= saveable)
+		goto out;
+
+	/*
+	 * Let the memory management subsystem know that we're going to need a
+	 * large number of page frames to allocate and make it free some memory.
+	 * NOTE: If this is not done, performance will be hurt badly in some
+	 * test cases.
+	 */
+	shrink_all_memory(saveable - size);
+
+	/*
+	 * The number of saveable pages in memory was too high, so apply some
+	 * pressure to decrease it.  First, make room for the largest possible
+	 * image and fail if that doesn't work.  Next, try to decrease the size
+	 * of the image as much as indicated by image_size using allocations
+	 * from highmem and non-highmem zones separately.
+	 */
+	pages_highmem = preallocate_image_highmem(highmem / 2);
+	max_size += pages_highmem;
+	alloc = count - max_size;
+	pages = preallocate_image_memory(alloc);
+	if (pages < alloc) {
+		error = -ENOMEM;
+		goto free_out;
+	}
+	size = max_size - size;
+	alloc = size;
+	size = preallocate_image_highmem(highmem_size(size, highmem, count));
+	pages_highmem += size;
+	alloc -= size;
+	pages += preallocate_image_memory(alloc);
+	pages += pages_highmem;
+
+ free_out:
+	/* Release all of the preallocated page frames. */
+	swsusp_free();
+
+	if (error) {
+		printk(KERN_CONT "\n");
+		return error;
+	}
+
+ out:
 	do_gettimeofday(&stop);
-	printk("\bdone (%lu pages freed)\n", pages);
+	printk(KERN_CONT "done (preallocated %lu free pages)\n", pages);
 	swsusp_show_speed(&start, &stop, pages, "Freed");
 
 	return 0;
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
drivers-net-macvlanc-fix-cloning-of-tagged-vlan-interfaces.patch
pci-pm-follow-pci_pm_ctrl_no_soft_reset-during-transitions-from-d3.patch
pci-pm-read-device-power-state-from-register-after-updating-it.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
pm-hibernate-rework-shrinking-of-memory.patch
pm-hibernate-do-not-release-preallocated-memory-unnecessarily-rev-2.patch
pm-hibernate-do-not-try-to-allocate-too-much-memory-too-hard.patch
shrink_slab-handle-bad-shrinkers.patch

