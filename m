From: akpm@linux-foundation.org
Subject: + mm-remove-cold-parameter-from-free_hot_cold_page-fix.patch
 added to -mm tree
Date: Thu, 19 Oct 2017 12:23:21 -0700
Message-ID: <59e8fba9.uqPYWV1iB9ipAE/A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42268 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751585AbdJSTXW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Oct 2017 15:23:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-remove-cold-parameter-from-free_hot_cold_page-fix
has been added to the -mm tree.  Its filename is
     mm-remove-cold-parameter-from-free_hot_cold_page-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-cold-parameter-from-free_hot_cold_page-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-cold-parameter-from-free_hot_cold_page-fix.patch

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
Subject: mm-remove-cold-parameter-from-free_hot_cold_page-fix

As pointed out by Vlastimil Babka, the pages being freed should be added
to the head, no the tail, of the pcpu list.

Link: http://lkml.kernel.org/r/20171019154321.qtpzaeftoyyw4iey@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-remove-cold-parameter-from-free_hot_cold_page-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-cold-parameter-from-free_hot_cold_page-fix
+++ a/mm/page_alloc.c
@@ -2624,7 +2624,7 @@ static void free_unref_page_commit(struc
 	}
 
 	pcp = &this_cpu_ptr(zone->pageset)->pcp;
-	list_add_tail(&page->lru, &pcp->lists[migratetype]);
+	list_add(&page->lru, &pcp->lists[migratetype]);
 	pcp->count++;
 	if (pcp->count >= pcp->high) {
 		unsigned long batch = READ_ONCE(pcp->batch);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-enable-disable-irqs-once-when-freeing-a-list-of-pages.patch
mm-page_alloc-enable-disable-irqs-once-when-freeing-a-list-of-pages-fix.patch
mm-truncate-do-not-check-mapping-for-every-page-being-truncated.patch
mm-truncate-remove-all-exceptional-entries-from-pagevec-under-one-lock.patch
mm-only-drain-per-cpu-pagevecs-once-per-pagevec-usage.patch
mm-pagevec-remove-cold-parameter-for-pagevecs.patch
mm-remove-cold-parameter-for-release_pages.patch
mm-remove-cold-parameter-from-free_hot_cold_page.patch
mm-remove-cold-parameter-from-free_hot_cold_page-fix.patch
mm-remove-__gfp_cold.patch
mm-pagevec-rename-pagevec-drained-field.patch

