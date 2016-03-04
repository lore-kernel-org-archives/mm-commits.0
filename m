From: akpm@linux-foundation.org
Subject: +
 mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd-fix.patch
 added to -mm tree
Date: Fri, 04 Mar 2016 15:05:31 -0800
Message-ID: <56da14bb.kJ8ipfLYl4aI6PGw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760463AbcCDXFc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2016 18:05:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd-fix
has been added to the -mm tree.  Its filename is
     mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd-fix.patch

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
Subject: mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd-fix

Change zone_balanced() check in balance_pgdat() to consider only base
pages as that's the same what kswapd_shrink_zone() later does.  So a zone
that would be selected due to lack of high-order pages would not be
reclaimed anyway, and just cause extra CPU churn.

Also remove unnecessary variable testorder in kswapd_shrink_zone().

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd-fix
+++ a/mm/vmscan.c
@@ -3090,7 +3090,6 @@ static bool kswapd_shrink_zone(struct zo
 			       int classzone_idx,
 			       struct scan_control *sc)
 {
-	int testorder = sc->order;
 	unsigned long balance_gap;
 	bool lowmem_pressure;
 
@@ -3111,7 +3110,7 @@ static bool kswapd_shrink_zone(struct zo
 	 * reclaim is necessary
 	 */
 	lowmem_pressure = (buffer_heads_over_limit && is_highmem(zone));
-	if (!lowmem_pressure && zone_balanced(zone, testorder, false,
+	if (!lowmem_pressure && zone_balanced(zone, sc->order, false,
 						balance_gap, classzone_idx))
 		return true;
 
@@ -3126,7 +3125,7 @@ static bool kswapd_shrink_zone(struct zo
 	 * waits.
 	 */
 	if (zone_reclaimable(zone) &&
-	    zone_balanced(zone, testorder, false, 0, classzone_idx)) {
+	    zone_balanced(zone, sc->order, false, 0, classzone_idx)) {
 		clear_bit(ZONE_CONGESTED, &zone->flags);
 		clear_bit(ZONE_DIRTY, &zone->flags);
 	}
@@ -3207,7 +3206,7 @@ static int balance_pgdat(pg_data_t *pgda
 				break;
 			}
 
-			if (!zone_balanced(zone, order, true, 0, 0)) {
+			if (!zone_balanced(zone, order, false, 0, 0)) {
 				end_zone = i;
 				break;
 			} else {
_

Patches currently in -mm which might be from vbabka@suse.cz are

tracepoints-move-trace_print_flags-definitions-to-tracepoint-defsh.patch
mm-tracing-make-show_gfp_flags-up-to-date.patch
tools-perf-make-gfp_compact_table-up-to-date.patch
mm-tracing-unify-mm-flags-handling-in-tracepoints-and-printk.patch
mm-printk-introduce-new-format-string-for-flags.patch
mm-printk-introduce-new-format-string-for-flags-fix.patch
mm-debug-replace-dump_flags-with-the-new-printk-formats.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch
mm-page_owner-print-migratetype-of-page-and-pageblock-symbolic-flags.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-debug-move-bad-flags-printing-to-bad_page.patch
mm-slb-print-gfp_flags-as-strings-in-slab_out_of_memory.patch
mm-kswapd-remove-bogus-check-of-balance_classzone_idx.patch
mm-compaction-introduce-kcompactd.patch
mm-memory-hotplug-small-cleanup-in-online_pages.patch
mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd.patch
mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd-fix.patch
mm-compaction-adapt-isolation_suitable-flushing-to-kcompactd.patch
mm-tracing-refresh-__def_vmaflag_names-fix.patch
mm-use-radix_tree_iter_retry-fix.patch

