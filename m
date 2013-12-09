From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch added to -mm tree
Date: Mon, 09 Dec 2013 15:23:29 -0800
Message-ID: <52a650f1.kR2YB8mE+AerzOn0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab3LIXX3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Dec 2013 18:23:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, mgorman@suse.de, rientjes@google.com

Subject: + mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch added to -mm tree
To: rientjes@google.com,mgorman@suse.de,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 09 Dec 2013 15:23:29 -0800


The patch titled
     Subject: mm, page_alloc: allow __GFP_NOFAIL to allocate below watermarks after reclaim
has been added to the -mm tree.  Its filename is
     mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, page_alloc: allow __GFP_NOFAIL to allocate below watermarks after reclaim

If direct reclaim has failed to free memory, __GFP_NOFAIL allocations can
potentially loop forever in the page allocator.  In this case, it's better
to give them the ability to access below watermarks so that they may
allocate similar to the same privilege given to GFP_ATOMIC allocations.

We're careful to ensure this is only done after direct reclaim has had the
chance to free memory, however.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/page_alloc.c~mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim
+++ a/mm/page_alloc.c
@@ -2622,6 +2622,11 @@ rebalance:
 						pages_reclaimed)) {
 		/* Wait for some write requests to complete then retry */
 		wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/50);
+
+		/* Allocations that cannot fail must allocate from somewhere */
+		if (gfp_mask & __GFP_NOFAIL)
+			alloc_flags |= ALLOC_HARDER;
+
 		goto rebalance;
 	} else {
 		/*
_

Patches currently in -mm which might be from rientjes@google.com are

include-linux-hugetlbh-make-isolate_huge_page-an-inline.patch
mm-memcg-do-not-declare-oom-from-__gfp_nofail-allocations.patch
mm-memcg-fix-race-condition-between-memcg-teardown-and-swapin.patch
mm-memcg-do-not-allow-task-about-to-oom-kill-to-bypass-the-limit.patch
arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch
arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit-fix.patch
mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch
mm-mempolicy-remove-unneeded-functions-for-uma-configs.patch
mm-show_mem-remove-show_mem_filter_page_count.patch
introduce-for_each_thread-to-replace-the-buggy-while_each_thread.patch
oom_kill-change-oom_killc-to-use-for_each_thread.patch
oom_kill-has_intersects_mems_allowed-needs-rcu_read_lock.patch
oom_kill-add-rcu_read_lock-into-find_lock_task_mm.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch

