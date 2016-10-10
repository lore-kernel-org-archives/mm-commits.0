From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-dont-recheck-watermarks-after-compact_success.patch removed
 from -mm tree
Date: Mon, 10 Oct 2016 15:43:01 -0700
Message-ID: <57fc1975.Jx7PfW8Wdmn6iDzy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36636 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752422AbcJJWnl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:43:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, lstoakes@gmail.com, mgorman@techsingularity.net, mhocko@kernel.org, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: don't recheck watermarks after COMPACT_SUCCESS
has been removed from the -mm tree.  Its filename was
     mm-compaction-dont-recheck-watermarks-after-compact_success.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: don't recheck watermarks after COMPACT_SUCCESS

Joonsoo has reminded me that in a later patch changing watermark checks
throughout compaction I forgot to update checks in
try_to_compact_pages() and compactd_do_work().  Closer inspection
however shows that they are redundant now in the success case, because
compact_zone() now reliably reports this with COMPACT_SUCCESS.  So
effectively the checks just repeat (a subset) of checks that have just
passed.  So instead of checking watermarks again, just test the return
value.

Note it's also possible that compaction would declare failure e.g. 
because its find_suitable_fallback() is more strict than simple
watermark check, and then the watermark check we are removing would
then still succeed.  After this patch this is not possible and it's
arguably better, because for long-term fragmentation avoidance we
should rather try a different zone than allocate with the unsuitable
fallback.  If compaction of all zones fail and the allocation is
important enough, it will retry and succeed anyway.

Also remove the stray "bool success" variable from kcompactd_do_work().

Link: http://lkml.kernel.org/r/20160810091226.6709-5-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Tested-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN mm/compaction.c~mm-compaction-dont-recheck-watermarks-after-compact_success mm/compaction.c
--- a/mm/compaction.c~mm-compaction-dont-recheck-watermarks-after-compact_success
+++ a/mm/compaction.c
@@ -1698,9 +1698,8 @@ enum compact_result try_to_compact_pages
 					alloc_flags, ac_classzone_idx(ac));
 		rc = max(status, rc);
 
-		/* If a normal allocation would succeed, stop compacting */
-		if (zone_watermark_ok(zone, order, low_wmark_pages(zone),
-					ac_classzone_idx(ac), alloc_flags)) {
+		/* The allocation should succeed, stop compacting */
+		if (status == COMPACT_SUCCESS) {
 			/*
 			 * We think the allocation will succeed in this zone,
 			 * but it is not certain, hence the false. The caller
@@ -1873,8 +1872,6 @@ static void kcompactd_do_work(pg_data_t
 		.ignore_skip_hint = true,
 
 	};
-	bool success = false;
