From: akpm@linux-foundation.org
Subject: + vmscan-use-atomic-long-for-shrinker-batching.patch added to -mm tree
Date: Mon, 22 Aug 2011 14:40:25 -0700
Message-ID: <201108222140.p7MLePsq008012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668Ab1HVVk4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Aug 2011 17:40:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, david@fromorbit.com


The patch titled
     vmscan: use atomic-long for shrinker batching
has been added to the -mm tree.  Its filename is
     vmscan-use-atomic-long-for-shrinker-batching.patch

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
Subject: vmscan: use atomic-long for shrinker batching
From: Konstantin Khlebnikov <khlebnikov@openvz.org>

Use atomic-long operations instead of looping around cmpxchg().

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shrinker.h |    2 +-
 mm/vmscan.c              |   17 +++++++----------
 2 files changed, 8 insertions(+), 11 deletions(-)

diff -puN include/linux/shrinker.h~vmscan-use-atomic-long-for-shrinker-batching include/linux/shrinker.h
--- a/include/linux/shrinker.h~vmscan-use-atomic-long-for-shrinker-batching
+++ a/include/linux/shrinker.h
@@ -34,7 +34,7 @@ struct shrinker {
 
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
@@ -184,7 +184,7 @@ static unsigned long zone_nr_lru_pages(s
  */
 void register_shrinker(struct shrinker *shrinker)
 {
-	shrinker->nr = 0;
+	atomic_long_set(&shrinker->nr_in_batch, 0);
 	down_write(&shrinker_rwsem);
 	list_add_tail(&shrinker->list, &shrinker_list);
 	up_write(&shrinker_rwsem);
@@ -265,9 +265,7 @@ unsigned long shrink_slab(struct shrink_
 		 * and zero it so that other concurrent shrinker invocations
 		 * don't also do this scanning work.
 		 */
-		do {
-			nr = shrinker->nr;
-		} while (cmpxchg(&shrinker->nr, nr, 0) != nr);
+		nr = atomic_long_xchg(&shrinker->nr_in_batch, 0);
 
 		total_scan = nr;
 		delta = (4 * nr_pages_scanned) / shrinker->seeks;
@@ -329,12 +327,11 @@ unsigned long shrink_slab(struct shrink_
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

vmscan-fix-initial-shrinker-size-handling.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch

