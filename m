Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C84CE7A95
	for <mm-commits@archiver.kernel.org>; Mon, 25 Sep 2023 15:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbjIYPYD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Sep 2023 11:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbjIYPYC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2023 11:24:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D4CA3
        for <mm-commits@vger.kernel.org>; Mon, 25 Sep 2023 08:23:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BF1C433C8;
        Mon, 25 Sep 2023 15:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695655434;
        bh=j5FEy48MbmDhINYtFYPsFBKXjz+FIZ+1AQE0ifOCo3w=;
        h=Date:To:From:Subject:From;
        b=BtPVyTqsVC4HHUhXe8hDCOcfTceqYBXtxulvENQv10L+D7m3OZ3cpdKt7bvv3xghN
         Aa+6mzuoYYYrJ0AxAL4RdEuDcD3Rx942m/t46gEbeTrRb8Vw+TjWmDCpgg5tzPDUfp
         9l4t9cd2zKaSqjWBhzgheF9HGQQJFqQMcwP5MaX0=
Date:   Mon, 25 Sep 2023 08:23:54 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, vbabka@suse.cz,
        tjmercier@google.com, rostedt@goodmis.org, kaleshsingh@google.com,
        hannes@cmpxchg.org, jaewon31.kim@samsung.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmscan-add-trace-events-for-lru_gen.patch added to mm-unstable branch
Message-Id: <20230925152354.D7BF1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: add trace events for lru_gen
has been added to the -mm mm-unstable branch.  Its filename is
     vmscan-add-trace-events-for-lru_gen.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmscan-add-trace-events-for-lru_gen.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: vmscan: add trace events for lru_gen
Date: Sun, 24 Sep 2023 23:23:43 +0900

As the legacy lru provides, the lru_gen needs some trace events for
debugging.

This commit introduces 2 trace events.
  trace_mm_vmscan_lru_gen_scan
  trace_mm_vmscan_lru_gen_evict

Each event is similar to the following legacy events.
  trace_mm_vmscan_lru_isolate,
  trace_mm_vmscan_lru_shrink_[in]active

Here's an example
  mm_vmscan_lru_gen_scan: isolate_mode=0 classzone=1 order=9 nr_requested=4096 nr_scanned=431 nr_skipped=0 nr_taken=55 lru=anon
  mm_vmscan_lru_gen_evict: nid=0 nr_reclaimed=42 nr_dirty=0 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=13 nr_activate_file=0 nr_ref_keep=0 nr_unmap_fail=0 priority=2 flags=RECLAIM_WB_ANON|RECLAIM_WB_ASYNC
  mm_vmscan_lru_gen_scan: isolate_mode=0 classzone=1 order=9 nr_requested=4096 nr_scanned=66 nr_skipped=0 nr_taken=64 lru=file
  mm_vmscan_lru_gen_evict: nid=0 nr_reclaimed=62 nr_dirty=0 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=2 nr_ref_keep=0 nr_unmap_fail=0 priority=2 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC

Link: https://lkml.kernel.org/r/20230924142343.23924-1-jaewon31.kim@samsung.com
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/mmflags.h |    5 +
 include/trace/events/vmscan.h  |   98 +++++++++++++++++++++++++++++++
 mm/vmscan.c                    |   17 +++--
 3 files changed, 115 insertions(+), 5 deletions(-)

--- a/include/trace/events/mmflags.h~vmscan-add-trace-events-for-lru_gen
+++ a/include/trace/events/mmflags.h
@@ -274,6 +274,10 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"soft
 		EM (LRU_ACTIVE_FILE, "active_file") \
 		EMe(LRU_UNEVICTABLE, "unevictable")
 
+#define LRU_GEN_NAMES		\
+		EM (LRU_GEN_ANON, "anon") \
+		EMe(LRU_GEN_FILE, "file")
+
 /*
  * First define the enums in the above macros to be exported to userspace
  * via TRACE_DEFINE_ENUM().
@@ -288,6 +292,7 @@ COMPACTION_PRIORITY
 /* COMPACTION_FEEDBACK are defines not enums. Not needed here. */
 ZONE_TYPE
 LRU_NAMES
+LRU_GEN_NAMES
 
 /*
  * Now redefine the EM() and EMe() macros to map the enums to the strings
--- a/include/trace/events/vmscan.h~vmscan-add-trace-events-for-lru_gen
+++ a/include/trace/events/vmscan.h
@@ -323,6 +323,57 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__print_symbolic(__entry->lru, LRU_NAMES))
 );
 
+TRACE_EVENT_CONDITION(mm_vmscan_lru_gen_scan,
+	TP_PROTO(int highest_zoneidx,
+		int order,
+		unsigned long nr_requested,
+		unsigned long nr_scanned,
+		unsigned long nr_skipped,
+		unsigned long nr_taken,
+		isolate_mode_t isolate_mode,
+		int lru),
+
+	TP_ARGS(highest_zoneidx, order, nr_requested, nr_scanned, nr_skipped, nr_taken, isolate_mode, lru),
+
+	TP_CONDITION(nr_scanned),
+
+	TP_STRUCT__entry(
+		__field(int, highest_zoneidx)
+		__field(int, order)
+		__field(unsigned long, nr_requested)
+		__field(unsigned long, nr_scanned)
+		__field(unsigned long, nr_skipped)
+		__field(unsigned long, nr_taken)
+		__field(unsigned int, isolate_mode)
+		__field(int, lru)
+	),
+
+	TP_fast_assign(
+		__entry->highest_zoneidx = highest_zoneidx;
+		__entry->order = order;
+		__entry->nr_requested = nr_requested;
+		__entry->nr_scanned = nr_scanned;
+		__entry->nr_skipped = nr_skipped;
+		__entry->nr_taken = nr_taken;
+		__entry->isolate_mode = (__force unsigned int)isolate_mode;
+		__entry->lru = lru;
+	),
+
+	/*
+	 * classzone is previous name of the highest_zoneidx.
+	 * Reason not to change it is the ABI requirement of the tracepoint.
+	 */
+	TP_printk("isolate_mode=%u classzone=%d order=%d nr_requested=%lu nr_scanned=%lu nr_skipped=%lu nr_taken=%lu lru=%s",
+		__entry->isolate_mode,
+		__entry->highest_zoneidx,
+		__entry->order,
+		__entry->nr_requested,
+		__entry->nr_scanned,
+		__entry->nr_skipped,
+		__entry->nr_taken,
+		__print_symbolic(__entry->lru, LRU_GEN_NAMES))
+);
+
 TRACE_EVENT(mm_vmscan_write_folio,
 
 	TP_PROTO(struct folio *folio),
@@ -432,6 +483,53 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
 		__entry->priority,
 		show_reclaim_flags(__entry->reclaim_flags))
 );
+
+TRACE_EVENT(mm_vmscan_lru_gen_evict,
+
+	TP_PROTO(int nid, unsigned long nr_reclaimed,
+		struct reclaim_stat *stat, int priority, int file),
+
+	TP_ARGS(nid, nr_reclaimed, stat, priority, file),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, nr_reclaimed)
+		__field(unsigned long, nr_dirty)
+		__field(unsigned long, nr_writeback)
+		__field(unsigned long, nr_congested)
+		__field(unsigned long, nr_immediate)
+		__field(unsigned int, nr_activate0)
+		__field(unsigned int, nr_activate1)
+		__field(unsigned long, nr_ref_keep)
+		__field(unsigned long, nr_unmap_fail)
+		__field(int, nid)
+		__field(int, priority)
+		__field(int, reclaim_flags)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->nr_reclaimed = nr_reclaimed;
+		__entry->nr_dirty = stat->nr_dirty;
+		__entry->nr_writeback = stat->nr_writeback;
+		__entry->nr_congested = stat->nr_congested;
+		__entry->nr_immediate = stat->nr_immediate;
+		__entry->nr_activate0 = stat->nr_activate[0];
+		__entry->nr_activate1 = stat->nr_activate[1];
+		__entry->nr_ref_keep = stat->nr_ref_keep;
+		__entry->nr_unmap_fail = stat->nr_unmap_fail;
+		__entry->priority = priority;
+		__entry->reclaim_flags = trace_reclaim_flags(file);
+	),
+
+	TP_printk("nid=%d nr_reclaimed=%lu nr_dirty=%lu nr_writeback=%lu nr_congested=%lu nr_immediate=%lu nr_activate_anon=%u nr_activate_file=%u nr_ref_keep=%lu nr_unmap_fail=%lu priority=%d flags=%s",
+		__entry->nid, __entry->nr_reclaimed,
+		__entry->nr_dirty, __entry->nr_writeback,
+		__entry->nr_congested, __entry->nr_immediate,
+		__entry->nr_activate0, __entry->nr_activate1,
+		__entry->nr_ref_keep, __entry->nr_unmap_fail,
+		__entry->priority,
+		show_reclaim_flags(__entry->reclaim_flags))
+);
 
 TRACE_EVENT(mm_vmscan_node_reclaim_begin,
 
--- a/mm/vmscan.c~vmscan-add-trace-events-for-lru_gen
+++ a/mm/vmscan.c
@@ -4328,6 +4328,7 @@ static int scan_folios(struct lruvec *lr
 	int sorted = 0;
 	int scanned = 0;
 	int isolated = 0;
+	int skipped = 0;
 	int remaining = MAX_LRU_BATCH;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -4341,7 +4342,7 @@ static int scan_folios(struct lruvec *lr
 
 	for (i = MAX_NR_ZONES; i > 0; i--) {
 		LIST_HEAD(moved);
-		int skipped = 0;
+		int skipped_zone = 0;
 		int zone = (sc->reclaim_idx + i) % MAX_NR_ZONES;
 		struct list_head *head = &lrugen->folios[gen][type][zone];
 
@@ -4363,16 +4364,17 @@ static int scan_folios(struct lruvec *lr
 				isolated += delta;
 			} else {
 				list_move(&folio->lru, &moved);
-				skipped += delta;
+				skipped_zone += delta;
 			}
 
-			if (!--remaining || max(isolated, skipped) >= MIN_LRU_BATCH)
+			if (!--remaining || max(isolated, skipped_zone) >= MIN_LRU_BATCH)
 				break;
 		}
 
-		if (skipped) {
+		if (skipped_zone) {
 			list_splice(&moved, head);
-			__count_zid_vm_events(PGSCAN_SKIP, zone, skipped);
+			__count_zid_vm_events(PGSCAN_SKIP, zone, skipped_zone);
+			skipped += skipped_zone;
 		}
 
 		if (!remaining || isolated >= MIN_LRU_BATCH)
@@ -4388,6 +4390,9 @@ static int scan_folios(struct lruvec *lr
 	__count_memcg_events(memcg, PGREFILL, sorted);
 	__count_vm_events(PGSCAN_ANON + type, isolated);
 
+	trace_mm_vmscan_lru_gen_scan(sc->reclaim_idx, sc->order, MAX_LRU_BATCH,
+			scanned, skipped, isolated,
+			sc->may_unmap ? 0 : ISOLATE_UNMAPPED, type);
 	/*
 	 * There might not be eligible folios due to reclaim_idx. Check the
 	 * remaining to prevent livelock if it's not making progress.
@@ -4517,6 +4522,8 @@ static int evict_folios(struct lruvec *l
 retry:
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false);
 	sc->nr_reclaimed += reclaimed;
+	trace_mm_vmscan_lru_gen_evict(pgdat->node_id, reclaimed, &stat,
+				      sc->priority, type);
 
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
 		if (!folio_evictable(folio)) {
_

Patches currently in -mm which might be from jaewon31.kim@samsung.com are

vmscan-add-trace-events-for-lru_gen.patch

