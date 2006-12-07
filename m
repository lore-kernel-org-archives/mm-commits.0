From: akpm@osdl.org
Subject: - swsusp-measure-memory-shrinking-time.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:37 -0800
Message-ID: <200612072259.kB7Mxbtu029537@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51052 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163673AbWLGW7q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, nigel@suspend2.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: Measure memory shrinking time
has been removed from the -mm tree.  Its filename was
     swsusp-measure-memory-shrinking-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: Measure memory shrinking time
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Make swsusp measure and print the time needed to shrink memory during the
suspend.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@suspend2.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/power.h  |    4 ++++
 kernel/power/swap.c   |   24 ++----------------------
 kernel/power/swsusp.c |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 22 deletions(-)

diff -puN kernel/power/power.h~swsusp-measure-memory-shrinking-time kernel/power/power.h
--- a/kernel/power/power.h~swsusp-measure-memory-shrinking-time
+++ a/kernel/power/power.h
@@ -171,3 +171,7 @@ extern int swsusp_read(void);
 extern int swsusp_write(void);
 extern void swsusp_close(void);
 extern int suspend_enter(suspend_state_t state);
+
+struct timeval;
+extern void swsusp_show_speed(struct timeval *, struct timeval *,
+				unsigned int, char *);
diff -puN kernel/power/swap.c~swsusp-measure-memory-shrinking-time kernel/power/swap.c
--- a/kernel/power/swap.c~swsusp-measure-memory-shrinking-time
+++ a/kernel/power/swap.c
@@ -133,26 +133,6 @@ static int wait_on_bio_chain(struct bio 
 	return ret;
 }
 
-static void show_speed(struct timeval *start, struct timeval *stop,
-			unsigned nr_pages, char *msg)
-{
-	s64 elapsed_centisecs64;
-	int centisecs;
-	int k;
-	int kps;
-
-	elapsed_centisecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
-	do_div(elapsed_centisecs64, NSEC_PER_SEC / 100);
-	centisecs = elapsed_centisecs64;
-	if (centisecs == 0)
-		centisecs = 1;	/* avoid div-by-zero */
-	k = nr_pages * (PAGE_SIZE / 1024);
-	kps = (k * 100) / centisecs;
-	printk("%s %d kbytes in %d.%02d seconds (%d.%02d MB/s)\n", msg, k,
-			centisecs / 100, centisecs % 100,
-			kps / 1000, (kps % 1000) / 10);
-}
-
 /*
  * Saving part
  */
@@ -375,7 +355,7 @@ static int save_image(struct swap_map_ha
 		error = err2;
 	if (!error)
 		printk("\b\b\b\bdone\n");
-	show_speed(&start, &stop, nr_to_write, "Wrote");
+	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
 	return error;
 }
 
@@ -562,7 +542,7 @@ static int load_image(struct swap_map_ha
 		if (!snapshot_image_loaded(snapshot))
 			error = -ENODATA;
 	}
-	show_speed(&start, &stop, nr_to_read, "Read");
+	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
 	return error;
 }
 
diff -puN kernel/power/swsusp.c~swsusp-measure-memory-shrinking-time kernel/power/swsusp.c
--- a/kernel/power/swsusp.c~swsusp-measure-memory-shrinking-time
+++ a/kernel/power/swsusp.c
@@ -49,6 +49,7 @@
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
 #include <linux/highmem.h>
+#include <linux/time.h>
 
 #include "power.h"
 
@@ -164,6 +165,34 @@ void free_all_swap_pages(int swap, struc
 }
 
 /**
+ *	swsusp_show_speed - print the time elapsed between two events represented by
+ *	@start and @stop
+ *
+ *	@nr_pages -	number of pages processed between @start and @stop
+ *	@msg -		introductory message to print
+ */
+
+void swsusp_show_speed(struct timeval *start, struct timeval *stop,
+			unsigned nr_pages, char *msg)
+{
+	s64 elapsed_centisecs64;
+	int centisecs;
+	int k;
+	int kps;
+
+	elapsed_centisecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
+	do_div(elapsed_centisecs64, NSEC_PER_SEC / 100);
+	centisecs = elapsed_centisecs64;
+	if (centisecs == 0)
+		centisecs = 1;	/* avoid div-by-zero */
+	k = nr_pages * (PAGE_SIZE / 1024);
+	kps = (k * 100) / centisecs;
+	printk("%s %d kbytes in %d.%02d seconds (%d.%02d MB/s)\n", msg, k,
+			centisecs / 100, centisecs % 100,
+			kps / 1000, (kps % 1000) / 10);
+}
+
+/**
  *	swsusp_shrink_memory -  Try to free as much memory as needed
  *
  *	... but do not OOM-kill anyone
@@ -187,8 +216,10 @@ int swsusp_shrink_memory(void)
 	unsigned long pages = 0;
 	unsigned int i = 0;
 	char *p = "-\\|/";
+	struct timeval start, stop;
 
 	printk("Shrinking memory...  ");
+	do_gettimeofday(&start);
 	do {
 		long size, highmem_size;
 
@@ -222,7 +253,9 @@ int swsusp_shrink_memory(void)
 		}
 		printk("\b%c", p[i++%4]);
 	} while (tmp > 0);
+	do_gettimeofday(&stop);
 	printk("\bdone (%lu pages freed)\n", pages);
+	swsusp_show_speed(&start, &stop, pages, "Freed");
 
 	return 0;
 }
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
md-change-lifetime-rules-for-md-devices.patch

