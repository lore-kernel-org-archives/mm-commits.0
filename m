From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mmpage=5Falloc-apply-gfp=5Fallowed=5Fmask-before-the-first-?=
 =?US-ASCII?Q?allocation-attempt.patch?= removed from -mm tree
Date: Mon, 11 Sep 2017 12:40:25 -0700
Message-ID: <20170911194025.zgZRDgFaw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49394 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbdIKTk0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:40:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, vbabka@suse.cz


The patch titled
     Subject: mm/page_alloc.c: apply gfp_allowed_mask before the first allocation attempt
has been removed from the -mm tree.  Its filename was
     mmpage_alloc-apply-gfp_allowed_mask-before-the-first-allocation-attempt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm/page_alloc.c: apply gfp_allowed_mask before the first allocation attempt

We are by error initializing alloc_flags before gfp_allowed_mask is
applied.  This could cause problems after pm_restrict_gfp_mask() is called
during suspend operation.  Apply gfp_allowed_mask before initializing
alloc_flags so that the first allocation attempt uses correct flags.

Link: http://lkml.kernel.org/r/201709020016.ADJ21342.OFLJHOOSMFVtFQ@I-love.SAKURA.ne.jp
Fixes: 83d4ca8148fd9092 ("mm, page_alloc: move __GFP_HARDWALL modifications out of the fastpath")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mmpage_alloc-apply-gfp_allowed_mask-before-the-first-allocation-attempt mm/page_alloc.c
--- a/mm/page_alloc.c~mmpage_alloc-apply-gfp_allowed_mask-before-the-first-allocation-attempt
+++ a/mm/page_alloc.c
@@ -4183,10 +4183,11 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 {
 	struct page *page;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
-	gfp_t alloc_mask = gfp_mask; /* The gfp_t that was actually used for allocation */
+	gfp_t alloc_mask; /* The gfp_t that was actually used for allocation */
 	struct alloc_context ac = { };
 
 	gfp_mask &= gfp_allowed_mask;
+	alloc_mask = gfp_mask;
 	if (!prepare_alloc_pages(gfp_mask, order, preferred_nid, nodemask, &ac, &alloc_mask, &alloc_flags))
 		return NULL;
 
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are


