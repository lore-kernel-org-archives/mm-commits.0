From: akpm@linux-foundation.org
Subject: + pm-hibernate-do-not-try-to-allocate-too-much-memory-too-hard.patch added to -mm tree
Date: Wed, 13 May 2009 12:35:33 -0700
Message-ID: <200905131935.n4DJZXXx029085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753083AbZEMTjL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 15:39:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, fengguang.wu@intel.com, nigel@tuxonice.net, pavel@ucw.cz


The patch titled
     pm/hibernate: do not try to allocate too much memory too hard
has been added to the -mm tree.  Its filename is
     pm-hibernate-do-not-try-to-allocate-too-much-memory-too-hard.patch

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
Subject: pm/hibernate: do not try to allocate too much memory too hard
From: Rafael J. Wysocki <rjw@sisk.pl>

We want to avoid attempting to free too much memory too hard during
hibernation, so estimate the minimum size of the image to use as the lower
limit for preallocating memory.

The approach here is based on the (experimental) observation that we can't
free more page frames than the sum of:

* global_page_state(NR_SLAB_RECLAIMABLE)
* global_page_state(NR_ACTIVE_ANON)
* global_page_state(NR_INACTIVE_ANON)
* global_page_state(NR_ACTIVE_FILE)
* global_page_state(NR_INACTIVE_FILE)

and even that is usually impossible to free in practice, because some of
the pages reported as global_page_state(NR_SLAB_RECLAIMABLE) can't in fact
be freed.  It turns out, however, that if the sum of the above numbers is
subtracted from the number of saveable pages in the system and the result
is multiplied by 1.25, we get a suitable estimate of the minimum size of
the image.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@tuxonice.net>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/snapshot.c |   56 +++++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 4 deletions(-)

diff -puN kernel/power/snapshot.c~pm-hibernate-do-not-try-to-allocate-too-much-memory-too-hard kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~pm-hibernate-do-not-try-to-allocate-too-much-memory-too-hard
+++ a/kernel/power/snapshot.c
@@ -1213,6 +1213,49 @@ static void free_unnecessary_pages(void)
 }
 
 /**
+ * minimum_image_size - Estimate the minimum acceptable size of an image
+ * @saveable: The total number of saveable pages in the system.
+ *
+ * We want to avoid attempting to free too much memory too hard, so estimate the
+ * minimum acceptable size of a hibernation image to use as the lower limit for
+ * preallocating memory.
+ *
+ * The minimum size of the image is computed as
+ *
+ * ([number of saveable pages] - [number of pages we can free]) * 1.25
+ *
+ * where the second term is the sum of reclaimable slab, anonymouns pages and
+ * active/inactive file pages.
+ *
+ * NOTE: It usually turns out that we can't really free all pages reported as
+ * reclaimable slab, so the number resulting from the subtraction alone is too
+ * low.  Still, it seems reasonable to assume that this number is proportional
+ * to the total number of pages that cannot be freed, which leads to the
+ * formula above.  The coefficient of proportinality in this formula, 1.25, has
+ * been determined experimentally.
+ */
+static unsigned long minimum_image_size(unsigned long saveable)
+{
+	unsigned long size;
+
+	/* Compute the number of saveable pages we can free. */
+	size = global_page_state(NR_SLAB_RECLAIMABLE)
+		+ global_page_state(NR_ACTIVE_ANON)
+		+ global_page_state(NR_INACTIVE_ANON)
+		+ global_page_state(NR_ACTIVE_FILE)
+		+ global_page_state(NR_INACTIVE_FILE);
+
+	if (saveable <= size)
+		return saveable;
+
+	size = saveable - size;
+	size += (size >> 2);
+
+	return size;
+}
+
+
+/**
  * hibernate_preallocate_memory - Preallocate memory for hibernation image
  *
  * To create a hibernation image it is necessary to make a copy of every page
@@ -1229,8 +1272,8 @@ static void free_unnecessary_pages(void)
  *
  * If image_size is set below the number following from the above formula,
  * the preallocation of memory is continued until the total number of saveable
- * pages in the system is below the requested image size or it is impossible to
- * allocate more memory, whichever happens first.
+ * pages in the system is below the requested image size or the minimum
+ * acceptable image size returned by minimum_image_size(), whichever is greater.
  */
 int hibernate_preallocate_memory(void)
 {
@@ -1291,6 +1334,11 @@ int hibernate_preallocate_memory(void)
 		goto out;
 	}
 
+	/* Estimate the minimum size of the image. */
+	pages = minimum_image_size(saveable);
+	if (size < pages)
+		size = min_t(unsigned long, pages, max_size);
+
 	/*
 	 * Let the memory management subsystem know that we're going to need a
 	 * large number of page frames to allocate and make it free some memory.
@@ -1303,8 +1351,8 @@ int hibernate_preallocate_memory(void)
 	 * The number of saveable pages in memory was too high, so apply some
 	 * pressure to decrease it.  First, make room for the largest possible
 	 * image and fail if that doesn't work.  Next, try to decrease the size
-	 * of the image as much as indicated by image_size using allocations
-	 * from highmem and non-highmem zones separately.
+	 * of the image as much as indicated by 'size' using allocations from
+	 * highmem and non-highmem zones separately.
 	 */
 	pages_highmem = preallocate_image_highmem(highmem / 2);
 	max_size += pages_highmem;
_

Patches currently in -mm which might be from rjw@sisk.pl are

linux-next.patch
devpts-correctly-set-default-options.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
pm-suspend-do-not-shrink-memory-before-suspend.patch
pm-hibernate-move-memory-shrinking-to-snapshotc-rev-2.patch
pm-hibernate-rework-shrinking-of-memory.patch
pm-hibernate-do-not-release-preallocated-memory-unnecessarily-rev-2.patch
pm-hibernate-do-not-try-to-allocate-too-much-memory-too-hard.patch
shrink_slab-handle-bad-shrinkers.patch

