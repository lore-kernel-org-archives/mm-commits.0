From: akpm@linux-foundation.org
Subject: [patch 078/102] mm, page_alloc: remove
 debug_guardpage_minorder() test in warn_alloc()
Date: Wed, 03 May 2017 14:55:34 -0700
Message-ID: <20170503215534.h-xSiB28X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53040 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdECV5j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:57:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, cl@linux-foundation.org, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, penberg@cs.helsinki.fi, penguin-kernel@I-love.SAKURA.ne.jp, rafael.j.wysocki@intel.com, sgruszka@redhat.com, torvalds@linux-foundation.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm, page_alloc: remove debug_guardpage_minorder() test in warn_alloc()

Commit c0a32fc5a2e470d0 ("mm: more intensive memory corruption debugging")
changed to check debug_guardpage_minorder() > 0 when reporting allocation
failures.  The reasoning was

  When we use guard page to debug memory corruption, it shrinks available
  pages to 1/2, 1/4, 1/8 and so on, depending on parameter value.
  In such case memory allocation failures can be common and printing
  errors can flood dmesg. If somebody debug corruption, allocation
  failures are not the things he/she is interested about.

but is misguided.

Allocation requests with __GFP_NOWARN flag by definition do not cause
flooding of allocation failure messages.  Allocation requests with
__GFP_NORETRY flag likely also have __GFP_NOWARN flag.  Costly allocation
requests likely also have __GFP_NOWARN flag.

Allocation requests without __GFP_DIRECT_RECLAIM flag likely also have
__GFP_NOWARN flag or __GFP_HIGH flag.  Non-costly allocation requests with
__GFP_DIRECT_RECLAIM flag basically retry forever due to the "too small to
fail" memory-allocation rule.

Therefore, as a whole, shrinking available pages by
debug_guardpage_minorder= kernel boot parameter might cause flooding of
OOM killer messages but unlikely causes flooding of allocation failure
messages.  Let's remove debug_guardpage_minorder() > 0 check which would
likely be pointless.

Link: http://lkml.kernel.org/r/1491910035-4231-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-remove-debug_guardpage_minorder-test-in-warn_alloc mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-debug_guardpage_minorder-test-in-warn_alloc
+++ a/mm/page_alloc.c
@@ -3092,8 +3092,7 @@ void warn_alloc(gfp_t gfp_mask, nodemask
 	static DEFINE_RATELIMIT_STATE(nopage_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
 
-	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs) ||
-	    debug_guardpage_minorder() > 0)
+	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs))
 		return;
 
 	pr_warn("%s: ", current->comm);
_
