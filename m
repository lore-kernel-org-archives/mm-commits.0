From: akpm@linux-foundation.org
Subject: +
 mm-compaction-dont-recheck-watermarks-after-compact_success.patch added to
 -mm tree
Date: Thu, 11 Aug 2016 14:29:47 -0700
Message-ID: <57acee4b.d+OWVtANaJB+65Ir%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbcHKV3s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 17:29:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@kernel.org, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: don't recheck watermarks after COMPACT_SUCCESS
has been added to the -mm tree.  Its filename is
     mm-compaction-dont-recheck-watermarks-after-compact_success.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-dont-recheck-watermarks-after-compact_success.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-dont-recheck-watermarks-after-compact_success.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: don't recheck watermarks after COMPACT_SUCCESS

Joonsoo has reminded me that in a later patch changing watermark checks
throughout compaction I forgot to update checks in try_to_compact_pages()
and compactd_do_work().  Closer inspection however shows that they are
redundant now that compact_zone() reliably reports success with
COMPACT_SUCCESS, as they just repeat (a subset) of checks that have just
passed.  So instead of checking watermarks again, just test the return
value.

Also remove the stray "bool success" variable from kcompactd_do_work().

Link: http://lkml.kernel.org/r/20160810091226.6709-5-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
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
-
 	trace_mm_compaction_kcompactd_wake(pgdat->node_id, cc.order,
 							cc.classzone_idx);
 	count_vm_event(KCOMPACTD_WAKE);
@@ -1903,9 +1900,7 @@ static void kcompactd_do_work(pg_data_t
 			return;
 		status = compact_zone(zone, &cc);
 
-		if (zone_watermark_ok(zone, cc.order, low_wmark_pages(zone),
-						cc.classzone_idx, 0)) {
-			success = true;
+		if (status == COMPACT_SUCCESS) {
 			compaction_defer_reset(zone, cc.order, false);
 		} else if (status == COMPACT_PARTIAL_SKIPPED || status == COMPACT_COMPLETE) {
 			/*
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions.patch
mm-compaction-cleanup-unused-functions.patch
mm-compaction-rename-compact_partial-to-compact_success.patch
mm-compaction-dont-recheck-watermarks-after-compact_success.patch
mm-compaction-add-the-ultimate-direct-compaction-priority.patch
mm-compaction-more-reliably-increase-direct-compaction-priority.patch
mm-compaction-use-correct-watermark-when-checking-compaction-success.patch
mm-compaction-create-compact_gap-wrapper.patch
mm-compaction-use-proper-alloc_flags-in-__compaction_suitable.patch
mm-compaction-require-only-min-watermarks-for-non-costly-orders.patch
mm-vmscan-make-compaction_ready-more-accurate-and-readable.patch

