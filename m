From: akpm@linux-foundation.org
Subject: [merged] vmscan-use-atomic-long-for-shrinker-batching.patch removed from -mm tree
Date: Fri, 09 Dec 2011 12:07:44 -0800
Message-ID: <201112092007.pB9K7iaD014111@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:38322 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab1LIUHr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 15:07:47 -0500
Received: by mail-ee0-f74.google.com with SMTP id c14so73205eek.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 12:07:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, david@fromorbit.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: use atomic-long for shrinker batching
has been removed from the -mm tree.  Its filename was
     vmscan-use-atomic-long-for-shrinker-batching.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: vmscan: use atomic-long for shrinker batching

Use atomic-long operations instead of looping around cmpxchg().

[akpm@linux-foundation.org: massage atomic.h inclusions]
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h       |    2 +-
 include/linux/mm.h       |    1 +
 include/linux/shrinker.h |    2 +-
 mm/vmscan.c              |   17 +++++++----------
 4 files changed, 10 insertions(+), 12 deletions(-)

diff -puN include/linux/fs.h~vmscan-use-atomic-long-for-shrinker-batching include/linux/fs.h
--- a/include/linux/fs.h~vmscan-use-atomic-long-for-shrinker-batching
+++ a/include/linux/fs.h
@@ -393,8 +393,8 @@ struct inodes_stat_t {
 #include <linux/semaphore.h>
 #include <linux/fiemap.h>
 #include <linux/rculist_bl.h>
-#include <linux/shrinker.h>
 #include <linux/atomic.h>
+#include <linux/shrinker.h>
 
 #include <asm/byteorder.h>
 
diff -puN include/linux/mm.h~vmscan-use-atomic-long-for-shrinker-batching include/linux/mm.h
--- a/include/linux/mm.h~vmscan-use-atomic-long-for-shrinker-batching
+++ a/include/linux/mm.h
@@ -10,6 +10,7 @@
 #include <linux/mmzone.h>
 #include <linux/rbtree.h>
 #include <linux/prio_tree.h>
+#include <linux/atomic.h>
 #include <linux/debug_locks.h>
 #include <linux/mm_types.h>
 #include <linux/range.h>
diff -puN include/linux/shrinker.h~vmscan-use-atomic-long-for-shrinker-batching include/linux/shrinker.h
--- a/include/linux/shrinker.h~vmscan-use-atomic-long-for-shrinker-batching
+++ a/include/linux/shrinker.h
@@ -35,7 +35,7 @@ struct shrinker {
 
 	/* These are for internal use */
 	struct list_head list;
-	long nr;	/* objs pending delete */
+	atomic_long_t nr_in_batch; /* objs pending delete */
 };
 #define DEFAULT_SEEKS 2 /* A good number if you don't know better. */
 extern void register_shrinker(struct shrinker *);
diff -puN mm/vmscan.c~vmscan-use-atomic-long-for-shrinker-batching mm/vmscan.c
--- a/mm/vmscan.c~vmscan-use-atomic-long-for-shrinker-batching
+++ a/mm/vmscan.c
@@ -183,7 +183,7 @@ static unsigned long zone_nr_lru_pages(s
  */
 void register_shrinker(struct shrinker *shrinker)
 {
-	shrinker->nr = 0;
+	atomic_long_set(&shrinker->nr_in_batch, 0);
 	down_write(&shrinker_rwsem);
 	list_add_tail(&shrinker->list, &shrinker_list);
 	up_write(&shrinker_rwsem);
@@ -264,9 +264,7 @@ unsigned long shrink_slab(struct shrink_
 		 * and zero it so that other concurrent shrinker invocations
 		 * don't also do this scanning work.
 		 */
-		do {
-			nr = shrinker->nr;
-		} while (cmpxchg(&shrinker->nr, nr, 0) != nr);
+		nr = atomic_long_xchg(&shrinker->nr_in_batch, 0);
 
 		total_scan = nr;
 		delta = (4 * nr_pages_scanned) / shrinker->seeks;
@@ -328,12 +326,11 @@ unsigned long shrink_slab(struct shrink_
 		 * manner that handles concurrent updates. If we exhausted the
 		 * scan, there is no need to do an update.
 		 */
-		do {
-			nr = shrinker->nr;
-			new_nr = total_scan + nr;
-			if (total_scan <= 0)
-				break;
-		} while (cmpxchg(&shrinker->nr, nr, new_nr) != nr);
+		if (total_scan > 0)
+			new_nr = atomic_long_add_return(total_scan,
+					&shrinker->nr_in_batch);
+		else
+			new_nr = atomic_long_read(&shrinker->nr_in_batch);
 
 		trace_mm_shrink_slab_end(shrinker, shrink_ret, nr, new_nr);
 	}
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-add-free_hot_cold_page_list-helper.patch
mm-add-free_hot_cold_page_list-helper-v2.patch
mm-add-free_hot_cold_page_list-helper-v3.patch
mm-remove-unused-pagevec_free.patch
mm-tracepoint-rename-page-free-events.patch
mm-tracepoint-fixup-documentation-and-examples.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
mm-account-reaped-page-cache-on-inode-cache-pruning.patch

