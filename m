Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BADAC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 22:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FCDA61154
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 22:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhJSWcW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Oct 2021 18:32:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229548AbhJSWcU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Oct 2021 18:32:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E5B660F8F;
        Tue, 19 Oct 2021 22:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634682606;
        bh=3im5LY/UOe/Csz2YTXXPUPE0wnsXVHJtwQWYcmGpWI8=;
        h=Date:From:To:Subject:From;
        b=BZY8AHYgkJcW3EwJ3lgs0Gcu6A9EjMJYMeVySLeVfLasyFXtW8nQwBUsh+MtT4JN0
         KH6991A9fV9+jvKZNtEFgghvcftLT/9AkzurZ7HUNnzt7lsnPCwcnWZ1C2/F+rQFV4
         ukzw3HND0UiJw4eUoeU97t5IKKo5gqJqmGNzMNpk=
Date:   Tue, 19 Oct 2021 15:30:05 -0700
From:   akpm@linux-foundation.org
To:     adilger.kernel@dilger.ca, corbet@lwn.net, david@fromorbit.com,
        djwong@kernel.org, hannes@cmpxchg.org, hdanton@sina.com,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de, riel@surriel.com,
        shy828301@gmail.com, tytso@mit.edu, vbabka@suse.cz,
        willy@infradead.org
Subject:  +
 =?US-ASCII?Q?mm-vmscan-throttle-reclaim-and-compaction-when-too-may-page?=
 =?US-ASCII?Q?s-are-isolated.patch?= added to -mm tree
Message-ID: <20211019223005.cRs95Aus-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: throttle reclaim and compaction when too may pages are isolated
has been added to the -mm tree.  Its filename is
     mm-vmscan-throttle-reclaim-and-compaction-when-too-may-pages-are-isolated.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-throttle-reclaim-and-compaction-when-too-may-pages-are-isolated.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-throttle-reclaim-and-compaction-when-too-may-pages-are-isolated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Link: https://lkml.kernel.org/r/20211019090108.25501-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: "Darrick J . Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h        |    6 ++++--
 include/trace/events/vmscan.h |    4 +++-
 mm/compaction.c               |   10 ++++++++--
 mm/internal.h                 |   13 ++++++++++++-
 mm/page_alloc.c               |    6 +++++-
 mm/vmscan.c                   |   28 +++++++++++++++++++---------
 6 files changed, 51 insertions(+), 16 deletions(-)

--- a/include/linux/mmzone.h~mm-vmscan-throttle-reclaim-and-compaction-when-too-may-pages-are-isolated
+++ a/include/linux/mmzone.h
@@ -275,6 +275,8 @@ enum lru_list {
 
 enum vmscan_throttle_state {
 	VMSCAN_THROTTLE_WRITEBACK,
+	VMSCAN_THROTTLE_ISOLATED,
+	NR_VMSCAN_THROTTLE,
 };
 
 #define for_each_lru(lru) for (lru = 0; lru < NR_LRU_LISTS; lru++)
@@ -846,8 +848,8 @@ typedef struct pglist_data {
 	int node_id;
 	wait_queue_head_t kswapd_wait;
 	wait_queue_head_t pfmemalloc_wait;
-	wait_queue_head_t reclaim_wait;	/* wq for throttling reclaim */
-	atomic_t nr_reclaim_throttled;	/* nr of throtted tasks */
+	wait_queue_head_t reclaim_wait[NR_VMSCAN_THROTTLE];
+	atomic_t nr_writeback_throttled;/* nr of writeback-throttled tasks */
 	unsigned long nr_reclaim_start;	/* nr pages written while throttled
 					 * when throttling started. */
 	struct task_struct *kswapd;	/* Protected by
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
@@ -39,12 +39,21 @@ void __acct_reclaim_writeback(pg_data_t
 static inline void acct_reclaim_writeback(struct page *page)
 {
 	pg_data_t *pgdat = page_pgdat(page);
-	int nr_throttled = atomic_read(&pgdat->nr_reclaim_throttled);
+	int nr_throttled = atomic_read(&pgdat->nr_writeback_throttled);
 
 	if (nr_throttled)
 		__acct_reclaim_writeback(pgdat, page, nr_throttled);
 }
 
+static inline void wake_throttle_isolated(pg_data_t *pgdat)
+{
+	wait_queue_head_t *wqh;
+
+	wqh = &pgdat->reclaim_wait[VMSCAN_THROTTLE_ISOLATED];
+	if (waitqueue_active(wqh))
+		wake_up_all(wqh);
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
--- a/mm/page_alloc.c~mm-vmscan-throttle-reclaim-and-compaction-when-too-may-pages-are-isolated
+++ a/mm/page_alloc.c
@@ -7408,6 +7408,8 @@ static void pgdat_init_kcompactd(struct
 
 static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 {
+	int i;
+
 	pgdat_resize_init(pgdat);
 
 	pgdat_init_split_queue(pgdat);
@@ -7415,7 +7417,9 @@ static void __meminit pgdat_init_interna
 
 	init_waitqueue_head(&pgdat->kswapd_wait);
 	init_waitqueue_head(&pgdat->pfmemalloc_wait);
-	init_waitqueue_head(&pgdat->reclaim_wait);
+
+	for (i = 0; i < NR_VMSCAN_THROTTLE; i++)
+		init_waitqueue_head(&pgdat->reclaim_wait[i]);
 
 	pgdat_page_ext_init(pgdat);
 	lruvec_init(&pgdat->__lruvec);
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
-	wait_queue_head_t *wqh = &pgdat->reclaim_wait;
+	wait_queue_head_t *wqh = &pgdat->reclaim_wait[reason];
 	long ret;
+	bool acct_writeback = (reason == VMSCAN_THROTTLE_WRITEBACK);
 	DEFINE_WAIT(wait);
 
 	/*
@@ -1023,7 +1023,8 @@ reclaim_throttle(pg_data_t *pgdat, enum
 	    current->flags & (PF_IO_WORKER|PF_KTHREAD))
 		return;
 
-	if (atomic_inc_return(&pgdat->nr_reclaim_throttled) == 1) {
+	if (acct_writeback &&
+	    atomic_inc_return(&pgdat->nr_writeback_throttled) == 1) {
 		WRITE_ONCE(pgdat->nr_reclaim_start,
 			node_page_state(pgdat, NR_THROTTLED_WRITTEN));
 	}
@@ -1031,7 +1032,9 @@ reclaim_throttle(pg_data_t *pgdat, enum
 	prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
 	ret = schedule_timeout(timeout);
 	finish_wait(wqh, &wait);
-	atomic_dec(&pgdat->nr_reclaim_throttled);
+
+	if (acct_writeback)
+		atomic_dec(&pgdat->nr_writeback_throttled);
 
 	trace_mm_vmscan_throttled(pgdat->node_id, jiffies_to_usecs(timeout),
 				jiffies_to_usecs(timeout - ret),
@@ -1061,7 +1064,7 @@ void __acct_reclaim_writeback(pg_data_t
 		READ_ONCE(pgdat->nr_reclaim_start);
 
 	if (nr_written > SWAP_CLUSTER_MAX * nr_throttled)
-		wake_up_all(&pgdat->reclaim_wait);
+		wake_up_all(&pgdat->reclaim_wait[VMSCAN_THROTTLE_WRITEBACK]);
 }
 
 /* possible outcome of pageout() */
@@ -2182,6 +2185,7 @@ static int too_many_isolated(struct pgli
 		struct scan_control *sc)
 {
 	unsigned long inactive, isolated;
+	bool too_many;
 
 	if (current_is_kswapd())
 		return 0;
@@ -2205,7 +2209,13 @@ static int too_many_isolated(struct pgli
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
@@ -2314,8 +2324,8 @@ shrink_inactive_list(unsigned long nr_to
 			return 0;
 
 		/* wait a bit for the reclaimer. */
-		msleep(100);
 		stalled = true;
+		reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED, HZ/10);
 
 		/* We are about to die and free our memory. Return now. */
 		if (fatal_signal_pending(current))
@@ -4349,7 +4359,7 @@ static int kswapd(void *p)
 
 	WRITE_ONCE(pgdat->kswapd_order, 0);
 	WRITE_ONCE(pgdat->kswapd_highest_zoneidx, MAX_NR_ZONES);
-	atomic_set(&pgdat->nr_reclaim_throttled, 0);
+	atomic_set(&pgdat->nr_writeback_throttled, 0);
 	for ( ; ; ) {
 		bool ret;
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-vmscan-throttle-reclaim-until-some-writeback-completes-if-congested.patch
mm-vmscan-throttle-reclaim-and-compaction-when-too-may-pages-are-isolated.patch
mm-vmscan-throttle-reclaim-when-no-progress-is-being-made.patch
mm-writeback-throttle-based-on-page-writeback-instead-of-congestion.patch
mm-page_alloc-remove-the-throttling-logic-from-the-page-allocator.patch
mm-vmscan-centralise-timeout-values-for-reclaim_throttle.patch
mm-vmscan-increase-the-timeout-if-page-reclaim-is-not-making-progress.patch
mm-vmscan-delay-waking-of-tasks-throttled-on-noprogress.patch

