From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages-fix.patch added to -mm tree
Date: Mon, 06 Feb 2017 15:01:55 -0800
Message-ID: <58990063.Tqp3MVPUEupFVAjX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34204 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752489AbdBFXB4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2017 18:01:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: use static global work_struct for draining per-cpu pages -fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: use static global work_struct for draining per-cpu pages -fix

Remove obsolete comment. This is a fix for the mmotm patch
mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages.patch

Link: http://lkml.kernel.org/r/20170206212210.s5ylsuidbpr44hkd@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages-fix
+++ a/mm/page_alloc.c
@@ -2378,10 +2378,6 @@ void drain_all_pages(struct zone *zone)
 		mutex_lock(&pcpu_drain_mutex);
 	}
 
-	/*
-	 * As this can be called from reclaim context, do not reenter reclaim.
-	 * An allocation failure can be handled, it's simply slower
-	 */
 	get_online_cpus();
 
 	/*
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-split-buffered_rmqueue.patch
mm-page_alloc-split-buffered_rmqueue-fix.patch
mm-page_alloc-split-alloc_pages_nodemask.patch
mm-page_alloc-drain-per-cpu-pages-from-workqueue-context.patch
mm-page_alloc-only-use-per-cpu-allocator-for-irq-safe-requests.patch
mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages.patch
mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages-fix.patch

