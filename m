From: akpm@linux-foundation.org
Subject: + pm-hibernate-move-memory-shrinking-to-snapshotc-rev-2.patch added to -mm tree
Date: Wed, 13 May 2009 12:35:24 -0700
Message-ID: <200905131935.n4DJZP0B028973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753350AbZEMTi1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 15:38:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, fengguang.wu@intel.com, pavel@ucw.cz


The patch titled
     pm/hibernate: move memory shrinking to snapshotc
has been added to the -mm tree.  Its filename is
     pm-hibernate-move-memory-shrinking-to-snapshotc-rev-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm/hibernate: move memory shrinking to snapshotc
From: Rafael J. Wysocki <rjw@sisk.pl>

The next patch is going to modify the memory shrinking code so that it
will make memory allocations to free memory instead of using an artificial
memory shrinking mechanism for that.  For this purpose it is convenient to
move swsusp_shrink_memory() from kernel/power/swsusp.c to
kernel/power/snapshot.c, because the new memory-shrinking code is going to
use things that are local to kernel/power/snapshot.c .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/power.h    |    4 -
 kernel/power/snapshot.c |   80 +++++++++++++++++++++++++++++++++++++-
 kernel/power/swsusp.c   |   76 ------------------------------------
 3 files changed, 79 insertions(+), 81 deletions(-)

diff -puN kernel/power/power.h~pm-hibernate-move-memory-shrinking-to-snapshotc-rev-2 kernel/power/power.h
--- a/kernel/power/power.h~pm-hibernate-move-memory-shrinking-to-snapshotc-rev-2
+++ a/kernel/power/power.h
@@ -74,7 +74,7 @@ extern asmlinkage int swsusp_arch_resume
 
 extern int create_basic_memory_bitmaps(void);
 extern void free_basic_memory_bitmaps(void);
-extern unsigned int count_data_pages(void);
+extern int swsusp_shrink_memory(void);
 
 /**
  *	Auxiliary structure used for reading the snapshot image data and
@@ -149,7 +149,6 @@ extern int swsusp_swap_in_use(void);
 
 /* kernel/power/disk.c */
 extern int swsusp_check(void);
-extern int swsusp_shrink_memory(void);
 extern void swsusp_free(void);
 extern int swsusp_read(unsigned int *flags_p);
 extern int swsusp_write(unsigned int flags);
@@ -176,7 +175,6 @@ extern int pm_notifier_call_chain(unsign
 #endif
 
 #ifdef CONFIG_HIGHMEM
-unsigned int count_highmem_pages(void);
 int restore_highmem(void);
 #else
 static inline unsigned int count_highmem_pages(void) { return 0; }
diff -puN kernel/power/snapshot.c~pm-hibernate-move-memory-shrinking-to-snapshotc-rev-2 kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~pm-hibernate-move-memory-shrinking-to-snapshotc-rev-2
+++ a/kernel/power/snapshot.c
@@ -39,6 +39,14 @@ static int swsusp_page_is_free(struct pa
 static void swsusp_set_page_forbidden(struct page *);
 static void swsusp_unset_page_forbidden(struct page *);
 
+/*
+ * Preferred image size in bytes (tunable via /sys/power/image_size).
+ * When it is set to N, swsusp will do its best to ensure the image
+ * size will not exceed N bytes, but if that is impossible, it will
+ * try to create the smallest image possible.
+ */
+unsigned long image_size = 500 * 1024 * 1024;
+
 /* List of PBEs needed for restoring the pages that were allocated before
  * the suspend and included in the suspend image, but have also been
  * allocated by the "resume" kernel, so their contents cannot be written
@@ -840,7 +848,7 @@ static struct page *saveable_highmem_pag
  *	pages.
  */
 
-unsigned int count_highmem_pages(void)
+static unsigned int count_highmem_pages(void)
 {
 	struct zone *zone;
 	unsigned int n = 0;
@@ -902,7 +910,7 @@ static struct page *saveable_page(struct
  *	pages.
  */
 
-unsigned int count_data_pages(void)
+static unsigned int count_data_pages(void)
 {
 	struct zone *zone;
 	unsigned long pfn, max_zone_pfn;
@@ -1058,6 +1066,74 @@ void swsusp_free(void)
 	buffer = NULL;
 }
 
+/**
+ *	swsusp_shrink_memory -  Try to free as much memory as needed
+ *
+ *	... but do not OOM-kill anyone
+ *
+ *	Notice: all userland should be stopped before it is called, or
+ *	livelock is possible.
+ */
+
+#define SHRINK_BITE	10000
+static inline unsigned long __shrink_memory(long tmp)
+{
+	if (tmp > SHRINK_BITE)
+		tmp = SHRINK_BITE;
+	return shrink_all_memory(tmp);
+}
+
+int swsusp_shrink_memory(void)
+{
+	long tmp;
+	struct zone *zone;
+	unsigned long pages = 0;
+	unsigned int i = 0;
+	char *p = "-\\|/";
+	struct timeval start, stop;
+
+	printk(KERN_INFO "PM: Shrinking memory...  ");
+	do_gettimeofday(&start);
+	do {
+		long size, highmem_size;
+
+		highmem_size = count_highmem_pages();
+		size = count_data_pages() + PAGES_FOR_IO + SPARE_PAGES;
+		tmp = size;
+		size += highmem_size;
+		for_each_populated_zone(zone) {
+			tmp += snapshot_additional_pages(zone);
+			if (is_highmem(zone)) {
+				highmem_size -=
+					zone_page_state(zone, NR_FREE_PAGES);
+			} else {
+				tmp -= zone_page_state(zone, NR_FREE_PAGES);
+				tmp += zone->lowmem_reserve[ZONE_NORMAL];
+			}
+		}
+
+		if (highmem_size < 0)
+			highmem_size = 0;
+
+		tmp += highmem_size;
+		if (tmp > 0) {
+			tmp = __shrink_memory(tmp);
+			if (!tmp)
+				return -ENOMEM;
+			pages += tmp;
+		} else if (size > image_size / PAGE_SIZE) {
+			tmp = __shrink_memory(size - (image_size / PAGE_SIZE));
+			pages += tmp;
+		}
+		printk("\b%c", p[i++%4]);
+	} while (tmp > 0);
+	do_gettimeofday(&stop);
+	printk("\bdone (%lu pages freed)\n", pages);
+	swsusp_show_speed(&start, &stop, pages, "Freed");
+
+	return 0;
+}
+
 #ifdef CONFIG_HIGHMEM
 /**
   *	count_pages_for_highmem - compute the number of non-highmem pages
diff -puN kernel/power/swsusp.c~pm-hibernate-move-memory-shrinking-to-snapshotc-rev-2 kernel/power/swsusp.c
--- a/kernel/power/swsusp.c~pm-hibernate-move-memory-shrinking-to-snapshotc-rev-2
+++ a/kernel/power/swsusp.c
@@ -55,14 +55,6 @@
 
 #include "power.h"
 
-/*
- * Preferred image size in bytes (tunable via /sys/power/image_size).
- * When it is set to N, swsusp will do its best to ensure the image
- * size will not exceed N bytes, but if that is impossible, it will
- * try to create the smallest image possible.
- */
-unsigned long image_size = 500 * 1024 * 1024;
-
 int in_suspend __nosavedata = 0;
 
 /**
@@ -195,74 +187,6 @@ void swsusp_show_speed(struct timeval *s
 			kps / 1000, (kps % 1000) / 10);
 }
 
-/**
- *	swsusp_shrink_memory -  Try to free as much memory as needed
- *
- *	... but do not OOM-kill anyone
- *
- *	Notice: all userland should be stopped before it is called, or
- *	livelock is possible.
- */
-
-#define SHRINK_BITE	10000
-static inline unsigned long __shrink_memory(long tmp)
-{
-	if (tmp > SHRINK_BITE)
-		tmp = SHRINK_BITE;
-	return shrink_all_memory(tmp);
-}
-
-int swsusp_shrink_memory(void)
-{
-	long tmp;
-	struct zone *zone;
-	unsigned long pages = 0;
-	unsigned int i = 0;
-	char *p = "-\\|/";
-	struct timeval start, stop;
-
-	printk(KERN_INFO "PM: Shrinking memory...  ");
-	do_gettimeofday(&start);
-	do {
-		long size, highmem_size;
-
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
-
-		if (highmem_size < 0)
-			highmem_size = 0;
-
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
-	do_gettimeofday(&stop);
-	printk("\bdone (%lu pages freed)\n", pages);
-	swsusp_show_speed(&start, &stop, pages, "Freed");
-
-	return 0;
-}
