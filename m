From: akpm@linux-foundation.org
Subject: +
 mmpage_alloc-apply-gfp_allowed_mask-before-the-first-allocation-attempt.patch added to -mm tree
Date: Tue, 05 Sep 2017 16:47:00 -0700
Message-ID: <59af3774.X4cYOHn36eKK5Z+Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43368 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753652AbdIEXrB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2017 19:47:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, brouer@redhat.com, mgorman@techsingularity.net, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: apply gfp_allowed_mask before the first allocation attempt
has been added to the -mm tree.  Its filename is
     mmpage_alloc-apply-gfp_allowed_mask-before-the-first-allocation-attempt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmpage_alloc-apply-gfp_allowed_mask-before-the-first-allocation-attempt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmpage_alloc-apply-gfp_allowed_mask-before-the-first-allocation-attempt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -4179,10 +4179,11 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
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

mmpage_alloc-apply-gfp_allowed_mask-before-the-first-allocation-attempt.patch

