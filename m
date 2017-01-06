From: akpm@linux-foundation.org
Subject: + mm-compaction-add-vmstats-for-kcompactd-work.patch added to -mm tree
Date: Fri, 06 Jan 2017 14:17:12 -0800
Message-ID: <58701768.W7o3/jZb9Zj2YSEV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57648 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031846AbdAFWPx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2017 17:15:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: add vmstats for kcompactd work
has been added to the -mm tree.  Its filename is
     mm-compaction-add-vmstats-for-kcompactd-work.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-add-vmstats-for-kcompactd-work.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-add-vmstats-for-kcompactd-work.patch

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
Subject: mm, compaction: add vmstats for kcompactd work

A "compact_daemon_wake" vmstat exists that represents the number of times
kcompactd has woken up.  This doesn't represent how much work it actually
did, though.

It's useful to understand how much compaction work is being done by
kcompactd versus other methods such as direct compaction and explicitly
triggered per-node (or system) compaction.

This adds two new vmstats: "compact_daemon_migrate_scanned" and
"compact_daemon_free_scanned" to represent the number of pages kcompactd
has scanned as part of its migration scanner and freeing scanner,
respectively.

These values are still accounted for in the general
"compact_migrate_scanned" and "compact_free_scanned" for compatibility.

It could be argued that explicitly triggered compaction could also be
tracked separately, and that could be added if others find it useful.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1612071749390.69852@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    1 +
 mm/compaction.c               |   22 +++++++++++++++++++---
 mm/internal.h                 |    2 ++
 mm/vmstat.c                   |    2 ++
 4 files changed, 24 insertions(+), 3 deletions(-)

diff -puN include/linux/vm_event_item.h~mm-compaction-add-vmstats-for-kcompactd-work include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-compaction-add-vmstats-for-kcompactd-work
+++ a/include/linux/vm_event_item.h
@@ -56,6 +56,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		COMPACTISOLATED,
 		COMPACTSTALL, COMPACTFAIL, COMPACTSUCCESS,
 		KCOMPACTD_WAKE,
+		KCOMPACTD_MIGRATE_SCANNED, KCOMPACTD_FREE_SCANNED,
 #endif
 #ifdef CONFIG_HUGETLB_PAGE
 		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
diff -puN mm/compaction.c~mm-compaction-add-vmstats-for-kcompactd-work mm/compaction.c
--- a/mm/compaction.c~mm-compaction-add-vmstats-for-kcompactd-work
+++ a/mm/compaction.c
@@ -548,7 +548,7 @@ isolate_fail:
 	if (blockpfn == end_pfn)
 		update_pageblock_skip(cc, valid_page, total_isolated, false);
 
-	count_compact_events(COMPACTFREE_SCANNED, nr_scanned);
+	cc->total_free_scanned += nr_scanned;
 	if (total_isolated)
 		count_compact_events(COMPACTISOLATED, total_isolated);
 	return total_isolated;
@@ -931,7 +931,7 @@ isolate_fail:
 	trace_mm_compaction_isolate_migratepages(start_pfn, low_pfn,
 						nr_scanned, nr_isolated);
 
-	count_compact_events(COMPACTMIGRATE_SCANNED, nr_scanned);
+	cc->total_migrate_scanned += nr_scanned;
 	if (nr_isolated)
 		count_compact_events(COMPACTISOLATED, nr_isolated);
 
@@ -1631,6 +1631,9 @@ out:
 			zone->compact_cached_free_pfn = free_pfn;
 	}
 
+	count_compact_events(COMPACTMIGRATE_SCANNED, cc->total_migrate_scanned);
+	count_compact_events(COMPACTFREE_SCANNED, cc->total_free_scanned);
+
 	trace_mm_compaction_end(start_pfn, cc->migrate_pfn,
 				cc->free_pfn, end_pfn, sync, ret);
 
@@ -1645,6 +1648,8 @@ static enum compact_result compact_zone_
 	struct compact_control cc = {
 		.nr_freepages = 0,
 		.nr_migratepages = 0,
+		.total_migrate_scanned = 0,
+		.total_free_scanned = 0,
 		.order = order,
 		.gfp_mask = gfp_mask,
 		.zone = zone,
@@ -1757,6 +1762,8 @@ static void compact_node(int nid)
 	struct zone *zone;
 	struct compact_control cc = {
 		.order = -1,
+		.total_migrate_scanned = 0,
+		.total_free_scanned = 0,
 		.mode = MIGRATE_SYNC,
 		.ignore_skip_hint = true,
 		.whole_zone = true,
@@ -1883,6 +1890,8 @@ static void kcompactd_do_work(pg_data_t
 	struct zone *zone;
 	struct compact_control cc = {
 		.order = pgdat->kcompactd_max_order,
+		.total_migrate_scanned = 0,
+		.total_free_scanned = 0,
 		.classzone_idx = pgdat->kcompactd_classzone_idx,
 		.mode = MIGRATE_SYNC_LIGHT,
 		.ignore_skip_hint = true,
@@ -1891,7 +1900,7 @@ static void kcompactd_do_work(pg_data_t
 	};
 	trace_mm_compaction_kcompactd_wake(pgdat->node_id, cc.order,
 							cc.classzone_idx);
-	count_vm_event(KCOMPACTD_WAKE);
+	count_compact_event(KCOMPACTD_WAKE);
 
 	for (zoneid = 0; zoneid <= cc.classzone_idx; zoneid++) {
 		int status;
@@ -1909,6 +1918,8 @@ static void kcompactd_do_work(pg_data_t
 
 		cc.nr_freepages = 0;
 		cc.nr_migratepages = 0;
+		cc.total_migrate_scanned = 0;
+		cc.total_free_scanned = 0;
 		cc.zone = zone;
 		INIT_LIST_HEAD(&cc.freepages);
 		INIT_LIST_HEAD(&cc.migratepages);
@@ -1927,6 +1938,11 @@ static void kcompactd_do_work(pg_data_t
 			defer_compaction(zone, cc.order);
 		}
 
+		count_compact_events(KCOMPACTD_MIGRATE_SCANNED,
+				     cc.total_migrate_scanned);
+		count_compact_events(KCOMPACTD_FREE_SCANNED,
+				     cc.total_free_scanned);
+
 		VM_BUG_ON(!list_empty(&cc.freepages));
 		VM_BUG_ON(!list_empty(&cc.migratepages));
 	}
diff -puN mm/internal.h~mm-compaction-add-vmstats-for-kcompactd-work mm/internal.h
--- a/mm/internal.h~mm-compaction-add-vmstats-for-kcompactd-work
+++ a/mm/internal.h
@@ -175,6 +175,8 @@ struct compact_control {
 	struct list_head migratepages;	/* List of pages being migrated */
 	unsigned long nr_freepages;	/* Number of isolated free pages */
 	unsigned long nr_migratepages;	/* Number of pages to migrate */
+	unsigned long total_migrate_scanned;
+	unsigned long total_free_scanned;
 	unsigned long free_pfn;		/* isolate_freepages search base */
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
 	unsigned long last_migrated_pfn;/* Not yet flushed page being freed */
diff -puN mm/vmstat.c~mm-compaction-add-vmstats-for-kcompactd-work mm/vmstat.c
--- a/mm/vmstat.c~mm-compaction-add-vmstats-for-kcompactd-work
+++ a/mm/vmstat.c
@@ -1038,6 +1038,8 @@ const char * const vmstat_text[] = {
 	"compact_fail",
 	"compact_success",
 	"compact_daemon_wake",
+	"compact_daemon_migrate_scanned",
+	"compact_daemon_free_scanned",
 #endif
 
 #ifdef CONFIG_HUGETLB_PAGE
_

Patches currently in -mm which might be from rientjes@google.com are

mm-compaction-add-vmstats-for-kcompactd-work.patch

