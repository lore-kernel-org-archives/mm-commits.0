From: akpm@linux-foundation.org
Subject: [merged]
 mm-oom-prevent-pre-mature-oom-killer-invocation-for-high-order-request.patch removed from -mm tree
Date: Fri, 02 Sep 2016 12:00:45 -0700
Message-ID: <57c9cc5d.c2D9i9a28a5788QL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32964 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753953AbcIBTAr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2016 15:00:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, Ralf-Peter.Rohbeck@quantum.com, a.miskiewicz@gmail.com, js1304@gmail.com, jslaby@suse.com, markus@trippelsdorf.de, olaf@aepfle.de, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: prevent premature OOM killer invocation for high order request
has been removed from the -mm tree.  Its filename was
     mm-oom-prevent-pre-mature-oom-killer-invocation-for-high-order-request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom: prevent premature OOM killer invocation for high order request

There have been several reports about pre-mature OOM killer invocation in
4.7 kernel when order-2 allocation request (for the kernel stack) invoked
OOM killer even during basic workloads (light IO or even kernel compile on
some filesystems).  In all reported cases the memory is fragmented and
there are no order-2+ pages available.  There is usually a large amount of
slab memory (usually dentries/inodes) and further debugging has shown that
there are way too many unmovable blocks which are skipped during the
compaction.  Multiple reporters have confirmed that the current linux-next
which includes [1] and [2] helped and OOMs are not reproducible anymore.

A simpler fix for the late rc and stable is to simply ignore the
compaction feedback and retry as long as there is a reclaim progress and
we are not getting OOM for order-0 pages.  We already do that for
CONFING_COMPACTION=n so let's reuse the same code when compaction is
enabled as well.

[1] http://lkml.kernel.org/r/20160810091226.6709-1-vbabka@suse.cz
[2] http://lkml.kernel.org/r/f7a9ea9d-bb88-bfd6-e340-3a933559305a@suse.cz

Fixes: 0a0337e0d1d1 ("mm, oom: rework oom detection")
Link: http://lkml.kernel.org/r/20160823074339.GB23577@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Tested-by: Olaf Hering <olaf@aepfle.de>
Tested-by: Ralf-Peter Rohbeck <Ralf-Peter.Rohbeck@quantum.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: Ralf-Peter Rohbeck <Ralf-Peter.Rohbeck@quantum.com>
Cc: Jiri Slaby <jslaby@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[4.7.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   51 +---------------------------------------------
 1 file changed, 2 insertions(+), 49 deletions(-)

diff -puN mm/page_alloc.c~mm-oom-prevent-pre-mature-oom-killer-invocation-for-high-order-request mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-prevent-pre-mature-oom-killer-invocation-for-high-order-request
+++ a/mm/page_alloc.c
@@ -3137,54 +3137,6 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	return NULL;
 }
 
-static inline bool
-should_compact_retry(struct alloc_context *ac, int order, int alloc_flags,
-		     enum compact_result compact_result,
-		     enum compact_priority *compact_priority,
-		     int compaction_retries)
-{
-	int max_retries = MAX_COMPACT_RETRIES;
-
-	if (!order)
-		return false;
-
-	/*
-	 * compaction considers all the zone as desperately out of memory
-	 * so it doesn't really make much sense to retry except when the
-	 * failure could be caused by insufficient priority
-	 */
-	if (compaction_failed(compact_result)) {
-		if (*compact_priority > MIN_COMPACT_PRIORITY) {
-			(*compact_priority)--;
-			return true;
-		}
-		return false;
-	}
-
-	/*
-	 * make sure the compaction wasn't deferred or didn't bail out early
-	 * due to locks contention before we declare that we should give up.
-	 * But do not retry if the given zonelist is not suitable for
-	 * compaction.
-	 */
-	if (compaction_withdrawn(compact_result))
-		return compaction_zonelist_suitable(ac, order, alloc_flags);
-
-	/*
-	 * !costly requests are much more important than __GFP_REPEAT
-	 * costly ones because they are de facto nofail and invoke OOM
-	 * killer to move on while costly can fail and users are ready
-	 * to cope with that. 1/4 retries is rather arbitrary but we
-	 * would need much more detailed feedback from compaction to
-	 * make a better decision.
-	 */
-	if (order > PAGE_ALLOC_COSTLY_ORDER)
-		max_retries /= 4;
-	if (compaction_retries <= max_retries)
-		return true;
-
-	return false;
-}
 #else
 static inline struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
@@ -3195,6 +3147,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	return NULL;
 }
 
+#endif /* CONFIG_COMPACTION */
+
 static inline bool
 should_compact_retry(struct alloc_context *ac, unsigned int order, int alloc_flags,
 		     enum compact_result compact_result,
@@ -3221,7 +3175,6 @@ should_compact_retry(struct alloc_contex
 	}
 	return false;
 }
-#endif /* CONFIG_COMPACTION */
 
 /* Perform direct synchronous page reclaim */
 static int
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmscan-get-rid-of-throttle_vm_writeout.patch
oom-keep-mm-of-the-killed-task-available.patch
kernel-oom-fix-potential-pgd_lock-deadlock-from-__mmdrop.patch
mm-oom-get-rid-of-signal_struct-oom_victims.patch
oom-suspend-fix-oom_killer_disable-vs-pm-suspend-properly.patch
mm-make-sure-that-kthreads-will-not-refault-oom-reaped-memory.patch
oom-oom_reaper-allow-to-reap-mm-shared-by-the-kthreads.patch
oom-warn-if-we-go-oom-for-higher-order-and-compaction-is-disabled.patch

