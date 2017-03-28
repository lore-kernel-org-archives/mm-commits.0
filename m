From: akpm@linux-foundation.org
Subject: + mm-page_alloc-split-smallest-stolen-page-in-fallback-fix.patch
 added to -mm tree
Date: Tue, 28 Mar 2017 13:39:15 -0700
Message-ID: <58dac9f3.yhjQA9HWmPzUPUw1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55676 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751882AbdC1Uj1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2017 16:39:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, rientjes@google.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-split-smallest-stolen-page-in-fallback-fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-split-smallest-stolen-page-in-fallback-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-split-smallest-stolen-page-in-fallback-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-split-smallest-stolen-page-in-fallback-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------

Author: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-page_alloc-split-smallest-stolen-page-in-fallback-fix

The lkp-robot reported a test case stuck on boot due to the patch [1]
which was due to endless loop in the modified __rmqueue().  It blindly
expected that move_freepages_block() will succeed, but that can fail due
to last pageblock pfn not belonging to the same zone as the fallback
candidate page.

This fix checks the result of move_freepages_block() and steals the single
candidate page if it fails, which was also effectively done before [1].

[1] mmotm: mm-page_alloc-split-smallest-stolen-page-in-fallback.patch

Link: http://lkml.kernel.org/r/59d71b35-d556-4fc9-ee2e-1574259282fd@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/page_alloc.c~mm-page_alloc-split-smallest-stolen-page-in-fallback-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-split-smallest-stolen-page-in-fallback-fix
+++ a/mm/page_alloc.c
@@ -1977,6 +1977,9 @@ static void steal_suitable_fallback(stru
 		goto single_page;
 
 	pages = move_freepages_block(zone, page, start_type);
+	/* moving whole block can fail due to zone boundary conditions */
+	if (!pages)
+		goto single_page;
 
 	/* Claim the whole block if over half of it is free */
 	if (pages >= (1 << (pageblock_order-1)) ||
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-reorder-fields-in-struct-compact_control.patch
mm-compaction-remove-redundant-watermark-check-in-compact_finished.patch
mm-page_alloc-split-smallest-stolen-page-in-fallback.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock.patch
mm-compaction-change-migrate_async_suitable-to-suitable_migration_source.patch
mm-compaction-add-migratetype-to-compact_control.patch
mm-compaction-restrict-async-compaction-to-pageblocks-of-same-migratetype.patch
mm-compaction-finish-whole-pageblock-to-reduce-fragmentation.patch

