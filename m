Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05745C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE60161151
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347824AbhIBVyG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:54:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347811AbhIBVx5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:53:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 839FD61153;
        Thu,  2 Sep 2021 21:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619578;
        bh=lkpswNeLkLnSSSbgArbJoiZyePdAbLjxJW0KwiXMQ7E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=A8WG/Wx7yC8aL2jYwPqELCf9kEuZnEFKwWW6+koUWesYpugFUXf7Z/DtzniQ8Ogj7
         vXF2WhkXeT1FqPIYNAUchJIctT+7w5fzBSU67Be81dszsZ5iHrKQ5NeOO0aF/O4Uz7
         P1mU1tiIJcMu/lGnST5Rr9ogJ49qpmv+sQHE5RfA=
Date:   Thu, 02 Sep 2021 14:52:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, boqun.feng@gmail.com,
        linux-mm@kvack.org, mingo@kernel.org, mm-commits@vger.kernel.org,
        osandov@fb.com, peterz@infradead.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 056/212] mm: report a more useful address for
 reclaim acquisition
Message-ID: <20210902215258.DSYCrFsZ3%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: report a more useful address for reclaim acquisition

A recent lockdep report included these lines:

[   96.177910] 3 locks held by containerd/770:
[   96.177934]  #0: ffff88810815ea28 (&mm->mmap_lock#2){++++}-{3:3},
at: do_user_addr_fault+0x115/0x770
[   96.177999]  #1: ffffffff82915020 (rcu_read_lock){....}-{1:2}, at:
get_swap_device+0x33/0x140
[   96.178057]  #2: ffffffff82955ba0 (fs_reclaim){+.+.}-{0:0}, at:
__fs_reclaim_acquire+0x5/0x30

While it was not useful to that bug report to know where the reclaim lock
had been acquired, it might be useful under other circumstances.  Allow
the caller of __fs_reclaim_acquire to specify the instruction pointer to
use.

Link: https://lkml.kernel.org/r/20210719185709.1755149-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Omar Sandoval <osandov@fb.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |    8 ++++----
 mm/page_alloc.c          |   12 ++++++------
 mm/vmscan.c              |    8 ++++----
 3 files changed, 14 insertions(+), 14 deletions(-)

--- a/include/linux/sched/mm.h~mm-report-a-more-useful-address-for-reclaim-acquisition
+++ a/include/linux/sched/mm.h
@@ -174,13 +174,13 @@ static inline gfp_t current_gfp_context(
 }
 
 #ifdef CONFIG_LOCKDEP
-extern void __fs_reclaim_acquire(void);
-extern void __fs_reclaim_release(void);
+extern void __fs_reclaim_acquire(unsigned long ip);
+extern void __fs_reclaim_release(unsigned long ip);
 extern void fs_reclaim_acquire(gfp_t gfp_mask);
 extern void fs_reclaim_release(gfp_t gfp_mask);
 #else
-static inline void __fs_reclaim_acquire(void) { }
-static inline void __fs_reclaim_release(void) { }
+static inline void __fs_reclaim_acquire(unsigned long ip) { }
+static inline void __fs_reclaim_release(unsigned long ip) { }
 static inline void fs_reclaim_acquire(gfp_t gfp_mask) { }
 static inline void fs_reclaim_release(gfp_t gfp_mask) { }
 #endif
--- a/mm/page_alloc.c~mm-report-a-more-useful-address-for-reclaim-acquisition
+++ a/mm/page_alloc.c
@@ -4549,14 +4549,14 @@ static bool __need_reclaim(gfp_t gfp_mas
 	return true;
 }
 
-void __fs_reclaim_acquire(void)
+void __fs_reclaim_acquire(unsigned long ip)
 {
-	lock_map_acquire(&__fs_reclaim_map);
+	lock_acquire_exclusive(&__fs_reclaim_map, 0, 0, NULL, ip);
 }
 
-void __fs_reclaim_release(void)
+void __fs_reclaim_release(unsigned long ip)
 {
-	lock_map_release(&__fs_reclaim_map);
+	lock_release(&__fs_reclaim_map, ip);
 }
 
 void fs_reclaim_acquire(gfp_t gfp_mask)
@@ -4565,7 +4565,7 @@ void fs_reclaim_acquire(gfp_t gfp_mask)
 
 	if (__need_reclaim(gfp_mask)) {
 		if (gfp_mask & __GFP_FS)
-			__fs_reclaim_acquire();
+			__fs_reclaim_acquire(_RET_IP_);
 
 #ifdef CONFIG_MMU_NOTIFIER
 		lock_map_acquire(&__mmu_notifier_invalidate_range_start_map);
@@ -4582,7 +4582,7 @@ void fs_reclaim_release(gfp_t gfp_mask)
 
 	if (__need_reclaim(gfp_mask)) {
 		if (gfp_mask & __GFP_FS)
-			__fs_reclaim_release();
+			__fs_reclaim_release(_RET_IP_);
 	}
 }
 EXPORT_SYMBOL_GPL(fs_reclaim_release);
--- a/mm/vmscan.c~mm-report-a-more-useful-address-for-reclaim-acquisition
+++ a/mm/vmscan.c
@@ -3812,7 +3812,7 @@ static int balance_pgdat(pg_data_t *pgda
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
 	psi_memstall_enter(&pflags);
-	__fs_reclaim_acquire();
+	__fs_reclaim_acquire(_THIS_IP_);
 
 	count_vm_event(PAGEOUTRUN);
 
@@ -3938,9 +3938,9 @@ restart:
 			wake_up_all(&pgdat->pfmemalloc_wait);
 
 		/* Check if kswapd should be suspending */
-		__fs_reclaim_release();
+		__fs_reclaim_release(_THIS_IP_);
 		ret = try_to_freeze();
-		__fs_reclaim_acquire();
+		__fs_reclaim_acquire(_THIS_IP_);
 		if (ret || kthread_should_stop())
 			break;
 
@@ -3992,7 +3992,7 @@ out:
 	}
 
 	snapshot_refaults(NULL, pgdat);
-	__fs_reclaim_release();
+	__fs_reclaim_release(_THIS_IP_);
 	psi_memstall_leave(&pflags);
 	set_task_reclaim_state(current, NULL);
 
_
