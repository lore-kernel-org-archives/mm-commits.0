From: akpm@linux-foundation.org
Subject: + mm-compaction-reset-compaction-scanner-positions.patch added to -mm tree
Date: Tue, 24 Mar 2015 13:27:31 -0700
Message-ID: <5511c8b3.A6n8qJvo903Jut4c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbbCXU1c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 16:27:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gioh.kim@lge.com, iamjoonsoo.kim@lge.com, mel@csn.ul.ie, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: reset compaction scanner positions
has been added to the -mm tree.  Its filename is
     mm-compaction-reset-compaction-scanner-positions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-reset-compaction-scanner-positions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-reset-compaction-scanner-positions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gioh Kim <gioh.kim@lge.com>
Subject: mm/compaction: reset compaction scanner positions

When the compaction is activated via /proc/sys/vm/compact_memory it would
better scan the whole zone.  And some platforms, for instance ARM, have
the start_pfn of a zone at zero.  Therefore the first try to compact via
/proc doesn't work.  It needs to reset the compaction scanner position
first.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/compaction.c~mm-compaction-reset-compaction-scanner-positions mm/compaction.c
--- a/mm/compaction.c~mm-compaction-reset-compaction-scanner-positions
+++ a/mm/compaction.c
@@ -1605,6 +1605,14 @@ static void __compact_pgdat(pg_data_t *p
 		INIT_LIST_HEAD(&cc->freepages);
 		INIT_LIST_HEAD(&cc->migratepages);
 
+		/*
+		 * When called via /proc/sys/vm/compact_memory
+		 * this makes sure we compact the whole zone regardless of
+		 * cached scanner positions.
+		 */
+		if (cc->order == -1)
+			__reset_isolation_suitable(zone);
+
 		if (cc->order == -1 || !compaction_deferred(zone, cc->order))
 			compact_zone(zone, cc);
 
_

Patches currently in -mm which might be from gioh.kim@lge.com are

mm-page_alloc-call-kernel_map_pages-in-unset_migrateype_isolate.patch
mm-compaction-reset-compaction-scanner-positions.patch

