From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-remove-cold-parameter-from-free_hot_cold_page-fix.patch removed from -mm tree
Date: Wed, 15 Nov 2017 17:08:25 -0800
Message-ID: <5a0ce509.Hwea3DxhZf6iXoOY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36278 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932972AbdKPBI1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:08:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-remove-cold-parameter-from-free_hot_cold_page-fix
has been removed from the -mm tree.  Its filename was
     mm-remove-cold-parameter-from-free_hot_cold_page-fix.patch

This patch was dropped because it was folded into mm-remove-cold-parameter-from-free_hot_cold_page.patch

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
@@ -2644,7 +2644,7 @@ static void free_unref_page_commit(struc
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
mm-truncate-do-not-check-mapping-for-every-page-being-truncated.patch
mm-truncate-remove-all-exceptional-entries-from-pagevec-under-one-lock.patch
mm-only-drain-per-cpu-pagevecs-once-per-pagevec-usage.patch
mm-pagevec-remove-cold-parameter-for-pagevecs.patch
mm-remove-cold-parameter-for-release_pages.patch
mm-remove-cold-parameter-from-free_hot_cold_page.patch
mm-remove-__gfp_cold.patch
mm-pagevec-rename-pagevec-drained-field.patch

