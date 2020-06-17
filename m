From: akpm@linux-foundation.org
Subject: + mm-page_alloc-use-unlikely-in-task_capc.patch added to
 -mm tree
Date: Wed, 17 Jun 2020 14:42:53 -0700
Message-ID: <20200617214253.X_Ukw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbgFQVmy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 17:42:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@techsingularity.net, liwang@redhat.com, hughd@googlecom, hughd@google.com, alex.shi@linux.alibaba.com, vbabka@suse.cz


The patch titled
     Subject: mm, page_alloc: use unlikely() in task_capc()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-use-unlikely-in-task_capc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-use-unlikely-in-task_capc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-use-unlikely-in-task_capc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: use unlikely() in task_capc()

Hugh noted that task_capc() could use unlikely(), as most of the time
there is no capture in progress and we are in page freeing hot path. 
Indeed adding unlikely() produces assembly that better matches the
assumption and moves all the tests away from the hot path.

I have also noticed that we don't need to test for cc->direct_compaction
as the only place we set current->task_capture is compact_zone_order()
which also always sets cc->direct_compaction true.

Link: http://lkml.kernel.org/r/4a24f7af-3aa5-6e80-4ae6-8f253b562039@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Suggested-by: Hugh Dickins <hughd@google.com>
Acked-by: Hugh Dickins <hughd@googlecom>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Li Wang <liwang@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-unlikely-in-task_capc
+++ a/mm/page_alloc.c
@@ -813,11 +813,10 @@ static inline struct capture_control *ta
 {
 	struct capture_control *capc = current->capture_control;
 
-	return capc &&
+	return unlikely(capc) &&
 		!(current->flags & PF_KTHREAD) &&
 		!capc->page &&
-		capc->cc->zone == zone &&
-		capc->cc->direct_compaction ? capc : NULL;
+		capc->cc->zone == zone ? capc : NULL;
 }
 
 static inline bool
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-make-capture-control-handling-safe-wrt-interrupts.patch
mm-page_alloc-use-unlikely-in-task_capc.patch
mm-slub-extend-slub_debug-syntax-for-multiple-blocks.patch
mm-slub-make-some-slub_debug-related-attributes-read-only.patch
mm-slub-remove-runtime-allocation-order-changes.patch
mm-slub-make-remaining-slub_debug-related-attributes-read-only.patch
mm-slub-make-reclaim_account-attribute-read-only.patch
mm-slub-introduce-static-key-for-slub_debug.patch
mm-slub-introduce-kmem_cache_debug_flags.patch
mm-slub-extend-checks-guarded-by-slub_debug-static-key.patch
mm-slab-slub-move-and-improve-cache_from_obj.patch
