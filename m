From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-data-races-at-kswapd_classzone_idx.patch
 added to -mm tree
Date: Wed, 26 Feb 2020 17:37:20 -0800
Message-ID: <20200227013720.M0vahmnzX%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728091AbgB0BhV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 Feb 2020 20:37:21 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, elver@google.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: mm/vmscan.c: fix data races using kswapd_classzone_idx
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-data-races-at-kswapd_classzone_idx.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-fix-data-races-at-kswapd_classzone_idx.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-fix-data-races-at-kswapd_classzone_idx.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/vmscan.c: fix data races using kswapd_classzone_idx

pgdat->kswapd_classzone_idx could be accessed concurrently in
wakeup_kswapd().  Plain writes and reads without any lock protection
result in data races.  Fix them by adding a pair of READ|WRITE_ONCE() as
well as saving a branch (compilers might well optimize the original code
in an unintentional way anyway).  While at it, also take care of
pgdat->kswapd_order and non-kswapd threads in allow_direct_reclaim().  The
data races were reported by KCSAN,

 BUG: KCSAN: data-race in wakeup_kswapd / wakeup_kswapd

 write to 0xffff9f427ffff2dc of 4 bytes by task 7454 on cpu 13:
  wakeup_kswapd+0xf1/0x400
  wakeup_kswapd at mm/vmscan.c:3967
  wake_all_kswapds+0x59/0xc0
  wake_all_kswapds at mm/page_alloc.c:4241
  __alloc_pages_slowpath+0xdcc/0x1290
  __alloc_pages_slowpath at mm/page_alloc.c:4512
  __alloc_pages_nodemask+0x3bb/0x450
  alloc_pages_vma+0x8a/0x2c0
  do_anonymous_page+0x16e/0x6f0
  __handle_mm_fault+0xcd5/0xd40
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 1 lock held by mtest01/7454:
  #0: ffff9f425afe8808 (&mm->mmap_sem#2){++++}, at:
 do_page_fault+0x143/0x6f9
 do_user_addr_fault at arch/x86/mm/fault.c:1405
 (inlined by) do_page_fault at arch/x86/mm/fault.c:1539
 irq event stamp: 6944085
 count_memcg_event_mm+0x1a6/0x270
 count_memcg_event_mm+0x119/0x270
 __do_softirq+0x34c/0x57c
 irq_exit+0xa2/0xc0

 read to 0xffff9f427ffff2dc of 4 bytes by task 7472 on cpu 38:
  wakeup_kswapd+0xc8/0x400
  wake_all_kswapds+0x59/0xc0
  __alloc_pages_slowpath+0xdcc/0x1290
  __alloc_pages_nodemask+0x3bb/0x450
  alloc_pages_vma+0x8a/0x2c0
  do_anonymous_page+0x16e/0x6f0
  __handle_mm_fault+0xcd5/0xd40
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 1 lock held by mtest01/7472:
  #0: ffff9f425a9ac148 (&mm->mmap_sem#2){++++}, at:
 do_page_fault+0x143/0x6f9
 irq event stamp: 6793561
 count_memcg_event_mm+0x1a6/0x270
 count_memcg_event_mm+0x119/0x270
 __do_softirq+0x34c/0x57c
 irq_exit+0xa2/0xc0

 BUG: KCSAN: data-race in kswapd / wakeup_kswapd

 write to 0xffff90973ffff2dc of 4 bytes by task 820 on cpu 6:
  kswapd+0x27c/0x8d0
  kthread+0x1e0/0x200
  ret_from_fork+0x27/0x50

 read to 0xffff90973ffff2dc of 4 bytes by task 6299 on cpu 0:
  wakeup_kswapd+0xf3/0x450
  wake_all_kswapds+0x59/0xc0
  __alloc_pages_slowpath+0xdcc/0x1290
  __alloc_pages_nodemask+0x3bb/0x450
  alloc_pages_vma+0x8a/0x2c0
  do_anonymous_page+0x170/0x700
  __handle_mm_fault+0xc9f/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

Link: http://lkml.kernel.org/r/1582749472-5171-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Marco Elver <elver@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-fix-data-races-at-kswapd_classzone_idx
+++ a/mm/vmscan.c
@@ -3136,8 +3136,9 @@ static bool allow_direct_reclaim(pg_data
 
 	/* kswapd must be awake if processes are being throttled */
 	if (!wmark_ok && waitqueue_active(&pgdat->kswapd_wait)) {
-		pgdat->kswapd_classzone_idx = min(pgdat->kswapd_classzone_idx,
-						(enum zone_type)ZONE_NORMAL);
+		if (READ_ONCE(pgdat->kswapd_classzone_idx) > ZONE_NORMAL)
+			WRITE_ONCE(pgdat->kswapd_classzone_idx, ZONE_NORMAL);
+
 		wake_up_interruptible(&pgdat->kswapd_wait);
 	}
 
@@ -3769,9 +3770,9 @@ out:
 static enum zone_type kswapd_classzone_idx(pg_data_t *pgdat,
 					   enum zone_type prev_classzone_idx)
 {
-	if (pgdat->kswapd_classzone_idx == MAX_NR_ZONES)
-		return prev_classzone_idx;
-	return pgdat->kswapd_classzone_idx;
+	enum zone_type curr_idx = READ_ONCE(pgdat->kswapd_classzone_idx);
+
+	return curr_idx == MAX_NR_ZONES ? prev_classzone_idx : curr_idx;
 }
 
 static void kswapd_try_to_sleep(pg_data_t *pgdat, int alloc_order, int reclaim_order,
@@ -3815,8 +3816,11 @@ static void kswapd_try_to_sleep(pg_data_
 		 * the previous request that slept prematurely.
 		 */
 		if (remaining) {
-			pgdat->kswapd_classzone_idx = kswapd_classzone_idx(pgdat, classzone_idx);
-			pgdat->kswapd_order = max(pgdat->kswapd_order, reclaim_order);
+			WRITE_ONCE(pgdat->kswapd_classzone_idx,
+				   kswapd_classzone_idx(pgdat, classzone_idx));
+
+			if (READ_ONCE(pgdat->kswapd_order) < reclaim_order)
+				WRITE_ONCE(pgdat->kswapd_order, reclaim_order);
 		}
 
 		finish_wait(&pgdat->kswapd_wait, &wait);
@@ -3893,12 +3897,12 @@ static int kswapd(void *p)
 	tsk->flags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
 	set_freezable();
 
-	pgdat->kswapd_order = 0;
-	pgdat->kswapd_classzone_idx = MAX_NR_ZONES;
+	WRITE_ONCE(pgdat->kswapd_order, 0);
+	WRITE_ONCE(pgdat->kswapd_classzone_idx, MAX_NR_ZONES);
 	for ( ; ; ) {
 		bool ret;
 
-		alloc_order = reclaim_order = pgdat->kswapd_order;
+		alloc_order = reclaim_order = READ_ONCE(pgdat->kswapd_order);
 		classzone_idx = kswapd_classzone_idx(pgdat, classzone_idx);
 
 kswapd_try_sleep:
@@ -3906,10 +3910,10 @@ kswapd_try_sleep:
 					classzone_idx);
 
 		/* Read the new order and classzone_idx */
-		alloc_order = reclaim_order = pgdat->kswapd_order;
+		alloc_order = reclaim_order = READ_ONCE(pgdat->kswapd_order);
 		classzone_idx = kswapd_classzone_idx(pgdat, classzone_idx);
-		pgdat->kswapd_order = 0;
-		pgdat->kswapd_classzone_idx = MAX_NR_ZONES;
+		WRITE_ONCE(pgdat->kswapd_order, 0);
+		WRITE_ONCE(pgdat->kswapd_classzone_idx, MAX_NR_ZONES);
 
 		ret = try_to_freeze();
 		if (kthread_should_stop())
@@ -3953,20 +3957,23 @@ void wakeup_kswapd(struct zone *zone, gf
 		   enum zone_type classzone_idx)
 {
 	pg_data_t *pgdat;
+	enum zone_type curr_idx;
 
 	if (!managed_zone(zone))
 		return;
 
 	if (!cpuset_zone_allowed(zone, gfp_flags))
 		return;
+
 	pgdat = zone->zone_pgdat;
+	curr_idx = READ_ONCE(pgdat->kswapd_classzone_idx);
+
+	if (curr_idx == MAX_NR_ZONES || curr_idx < classzone_idx)
+		WRITE_ONCE(pgdat->kswapd_classzone_idx, classzone_idx);
+
+	if (READ_ONCE(pgdat->kswapd_order) < order)
+		WRITE_ONCE(pgdat->kswapd_order, order);
 
-	if (pgdat->kswapd_classzone_idx == MAX_NR_ZONES)
-		pgdat->kswapd_classzone_idx = classzone_idx;
-	else
-		pgdat->kswapd_classzone_idx = max(pgdat->kswapd_classzone_idx,
-						  classzone_idx);
-	pgdat->kswapd_order = max(pgdat->kswapd_order, order);
 	if (!waitqueue_active(&pgdat->kswapd_wait))
 		return;
 
_

Patches currently in -mm which might be from cai@lca.pw are

mm-swapfile-fix-data-races-in-try_to_unuse.patch
mm-vmscan-fix-data-races-at-kswapd_classzone_idx.patch
percpu_counter-fix-a-data-race-at-vm_committed_as.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races-v2.patch
mm-swap_state-mark-various-intentional-data-races.patch
mm-kmemleak-annotate-various-data-races-obj-ptr.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races-v2.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-util-annotate-an-data-race-at-vm_committed_as.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-annotate-a-data-race-in-page_zonenum.patch
