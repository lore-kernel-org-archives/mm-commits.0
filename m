Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80160C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B5436128B
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbhKEUpQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:45:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233521AbhKEUpJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:45:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A6A26120D;
        Fri,  5 Nov 2021 20:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144949;
        bh=waDO+7uAcViGltZ2gJRZmyPHaTt2qcSaomoLk2KCndY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ceu+ab1ONEQabof7tX/2qwx+VdnvgBxeGoXwUVP1INjaMBCJ0nI2v2nboSgUmINn9
         U4xGum2t1Z2KSqO9qXE1SEaVLKN2OiSKjjfrvyQB25UqNNOQHk8fOVOvXbwZwMjEfQ
         QJRiEaNkFvlGARPSDXecUQBLWfdu93TGljrj2fGE=
Date:   Fri, 05 Nov 2021 13:42:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        corbet@lwn.net, david@fromorbit.com, djwong@kernel.org,
        hannes@cmpxchg.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de, riel@surriel.com,
        torvalds@linux-foundation.org, tytso@mit.edu, vbabka@suse.cz,
        willy@infradead.org
Subject:  [patch 150/262] mm/vmscan: throttle reclaim and
 compaction when too may pages are isolated
Message-ID: <20211105204229.eXBgYXP95%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/vmscan: throttle reclaim and compaction when too may pages are isolated

Page reclaim throttles on congestion if too many parallel reclaim
instances have isolated too many pages.  This makes no sense, excessive
parallelisation has nothing to do with writeback or congestion.

This patch creates an additional workqueue to sleep on when too many pages
are isolated.  The throttled tasks are woken when the number of isolated
pages is reduced or a timeout occurs.  There may be some false positive
wakeups for GFP_NOIO/GFP_NOFS callers but the tasks will throttle again if
necessary.

[shy828301@gmail.com: Wake up from compaction context]
[vbabka@suse.cz: Account number of throttled tasks only for writeback]
Link: https://lkml.kernel.org/r/20211022144651.19914-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: "Darrick J . Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h        |    1 +
 include/trace/events/vmscan.h |    4 +++-
 mm/compaction.c               |   10 ++++++++--
 mm/internal.h                 |   11 +++++++++++
 mm/vmscan.c                   |   22 ++++++++++++++++------
 5 files changed, 39 insertions(+), 9 deletions(-)

--- a/include/linux/mmzone.h~mm-vmscan-throttle-reclaim-and-compaction-when-too-may-pages-are-isolated
+++ a/include/linux/mmzone.h
@@ -275,6 +275,7 @@ enum lru_list {
 
 enum vmscan_throttle_state {
 	VMSCAN_THROTTLE_WRITEBACK,
+	VMSCAN_THROTTLE_ISOLATED,
 	NR_VMSCAN_THROTTLE,
 };
 
--- a/include/trace/events/vmscan.h~mm-vmscan-throttle-reclaim-and-compaction-when-too-may-pages-are-isolated
+++ a/include/trace/events/vmscan.h
@@ -28,10 +28,12 @@
 		) : "RECLAIM_WB_NONE"
 
 #define _VMSCAN_THROTTLE_WRITEBACK	(1 << VMSCAN_THROTTLE_WRITEBACK)
+#define _VMSCAN_THROTTLE_ISOLATED	(1 << VMSCAN_THROTTLE_ISOLATED)
 
 #define show_throttle_flags(flags)						\
 	(flags) ? __print_flags(flags, "|",					\
-		{_VMSCAN_THROTTLE_WRITEBACK,	"VMSCAN_THROTTLE_WRITEBACK"}	\
+		{_VMSCAN_THROTTLE_WRITEBACK,	"VMSCAN_THROTTLE_WRITEBACK"},	\
+		{_VMSCAN_THROTTLE_ISOLATED,	"VMSCAN_THROTTLE_ISOLATED"}	\
 		) : "VMSCAN_THROTTLE_NONE"
 
 
--- a/mm/compaction.c~mm-vmscan-throttle-reclaim-and-compaction-when-too-may-pages-are-isolated
+++ a/mm/compaction.c
@@ -761,6 +761,8 @@ isolate_freepages_range(struct compact_c
 /* Similar to reclaim, but different enough that they don't share logic */
 static bool too_many_isolated(pg_data_t *pgdat)
 {
+	bool too_many;
+
 	unsigned long active, inactive, isolated;
 
 	inactive = node_page_state(pgdat, NR_INACTIVE_FILE) +
@@ -770,7 +772,11 @@ static bool too_many_isolated(pg_data_t
 	isolated = node_page_state(pgdat, NR_ISOLATED_FILE) +
 			node_page_state(pgdat, NR_ISOLATED_ANON);
 
-	return isolated > (inactive + active) / 2;
+	too_many = isolated > (inactive + active) / 2;
+	if (!too_many)
+		wake_throttle_isolated(pgdat);
+
+	return too_many;
 }
 
 /**
@@ -822,7 +828,7 @@ isolate_migratepages_block(struct compac
 		if (cc->mode == MIGRATE_ASYNC)
 			return -EAGAIN;
 
-		congestion_wait(BLK_RW_ASYNC, HZ/10);
+		reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED, HZ/10);
 
 		if (fatal_signal_pending(current))
 			return -EINTR;
--- a/mm/internal.h~mm-vmscan-throttle-reclaim-and-compaction-when-too-may-pages-are-isolated
+++ a/mm/internal.h
@@ -45,6 +45,15 @@ static inline void acct_reclaim_writebac
 		__acct_reclaim_writeback(pgdat, page, nr_throttled);
 }
 
+static inline void wake_throttle_isolated(pg_data_t *pgdat)
+{
+	wait_queue_head_t *wqh;
+
+	wqh = &pgdat->reclaim_wait[VMSCAN_THROTTLE_ISOLATED];
+	if (waitqueue_active(wqh))
+		wake_up(wqh);
+}
+
 vm_fault_t do_swap_page(struct vm_fault *vmf);
 
 void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
@@ -121,6 +130,8 @@ extern unsigned long highest_memmap_pfn;
  */
 extern int isolate_lru_page(struct page *page);
 extern void putback_lru_page(struct page *page);
+extern void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason,
+								long timeout);
 
 /*
  * in mm/rmap.c:
--- a/mm/vmscan.c~mm-vmscan-throttle-reclaim-and-compaction-when-too-may-pages-are-isolated
+++ a/mm/vmscan.c
@@ -1006,12 +1006,12 @@ static void handle_write_error(struct ad
 	unlock_page(page);
 }
 
-static void
-reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason,
+void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason,
 							long timeout)
 {
 	wait_queue_head_t *wqh = &pgdat->reclaim_wait[reason];
 	long ret;
+	bool acct_writeback = (reason == VMSCAN_THROTTLE_WRITEBACK);
 	DEFINE_WAIT(wait);
 
 	/*
@@ -1023,7 +1023,8 @@ reclaim_throttle(pg_data_t *pgdat, enum
 	    current->flags & (PF_IO_WORKER|PF_KTHREAD))
 		return;
 
-	if (atomic_inc_return(&pgdat->nr_writeback_throttled) == 1) {
+	if (acct_writeback &&
+	    atomic_inc_return(&pgdat->nr_writeback_throttled) == 1) {
 		WRITE_ONCE(pgdat->nr_reclaim_start,
 			node_page_state(pgdat, NR_THROTTLED_WRITTEN));
 	}
@@ -1031,7 +1032,9 @@ reclaim_throttle(pg_data_t *pgdat, enum
 	prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
 	ret = schedule_timeout(timeout);
 	finish_wait(wqh, &wait);
-	atomic_dec(&pgdat->nr_writeback_throttled);
+
+	if (acct_writeback)
+		atomic_dec(&pgdat->nr_writeback_throttled);
 
 	trace_mm_vmscan_throttled(pgdat->node_id, jiffies_to_usecs(timeout),
 				jiffies_to_usecs(timeout - ret),
@@ -2175,6 +2178,7 @@ static int too_many_isolated(struct pgli
 		struct scan_control *sc)
 {
 	unsigned long inactive, isolated;
+	bool too_many;
 
 	if (current_is_kswapd())
 		return 0;
@@ -2198,7 +2202,13 @@ static int too_many_isolated(struct pgli
 	if ((sc->gfp_mask & (__GFP_IO | __GFP_FS)) == (__GFP_IO | __GFP_FS))
 		inactive >>= 3;
 
-	return isolated > inactive;
+	too_many = isolated > inactive;
+
+	/* Wake up tasks throttled due to too_many_isolated. */
+	if (!too_many)
+		wake_throttle_isolated(pgdat);
+
+	return too_many;
 }
 
 /*
@@ -2307,8 +2317,8 @@ shrink_inactive_list(unsigned long nr_to
 			return 0;
 
 		/* wait a bit for the reclaimer. */
-		msleep(100);
 		stalled = true;
+		reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED, HZ/10);
 
 		/* We are about to die and free our memory. Return now. */
 		if (fatal_signal_pending(current))
_
