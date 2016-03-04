From: akpm@linux-foundation.org
Subject: + mm-compaction-introduce-kcompactd-fix-3.patch added to -mm tree
Date: Fri, 04 Mar 2016 15:06:11 -0800
Message-ID: <56da14e3.rojzcQ2KvXpKQBHP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760441AbcCDXGM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2016 18:06:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-introduce-kcompactd-fix-3
has been added to the -mm tree.  Its filename is
     mm-compaction-introduce-kcompactd-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-introduce-kcompactd-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-introduce-kcompactd-fix-3.patch

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
Subject: mm-compaction-introduce-kcompactd-fix-3

Remove extraneous check for sync compaction before deferring.
Correctly adjust kcompactd's classzone_idx instead of kswapd's.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN mm/compaction.c~mm-compaction-introduce-kcompactd-fix-3 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-introduce-kcompactd-fix-3
+++ a/mm/compaction.c
@@ -1811,8 +1811,11 @@ static void kcompactd_do_work(pg_data_t
 						cc.classzone_idx, 0)) {
 			success = true;
 			compaction_defer_reset(zone, cc.order, false);
-		} else if (cc.mode != MIGRATE_ASYNC &&
-						status == COMPACT_COMPLETE) {
+		} else if (status == COMPACT_COMPLETE) {
+			/*
+			 * We use sync migration mode here, so we defer like
+			 * sync direct compaction does.
+			 */
 			defer_compaction(zone, cc.order);
 		}
 
@@ -1827,8 +1830,8 @@ static void kcompactd_do_work(pg_data_t
 	 */
 	if (pgdat->kcompactd_max_order <= cc.order)
 		pgdat->kcompactd_max_order = 0;
-	if (pgdat->classzone_idx >= cc.classzone_idx)
-		pgdat->classzone_idx = pgdat->nr_zones - 1;
+	if (pgdat->kcompactd_classzone_idx >= cc.classzone_idx)
+		pgdat->kcompactd_classzone_idx = pgdat->nr_zones - 1;
 }
 
 void wakeup_kcompactd(pg_data_t *pgdat, int order, int classzone_idx)
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
mm-compaction-introduce-kcompactd-fix-3.patch
mm-memory-hotplug-small-cleanup-in-online_pages.patch
mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd.patch
mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd-fix.patch
mm-compaction-adapt-isolation_suitable-flushing-to-kcompactd.patch
mm-tracing-refresh-__def_vmaflag_names-fix.patch
mm-use-radix_tree_iter_retry-fix.patch

