From: akpm@linux-foundation.org
Subject: - sched-dont-renice-kernel-threads.patch removed from -mm tree
Date: Sat, 17 Mar 2007 23:52:52 -0800
Message-ID: <200703180752.l2I7qqCt018437@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58773 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbXCRHw7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 03:52:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kolivas.org, mingo@elte.hu, nickpiggin@yahoo.com.au, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: don't renice kernel threads
has been removed from the -mm tree.  Its filename was
     sched-dont-renice-kernel-threads.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: sched: don't renice kernel threads
From: Con Kolivas <kernel@kolivas.org>

The practice of renicing kernel threads to negative nice values is of
questionable benefit at best, and at worst leads to larger latencies when
kernel threads are busy on behalf of other tasks.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/workqueue.c~sched-dont-renice-kernel-threads kernel/workqueue.c
--- a/kernel/workqueue.c~sched-dont-renice-kernel-threads
+++ a/kernel/workqueue.c
@@ -294,7 +294,6 @@ static int worker_thread(void *__cwq)
 	if (!cwq->wq->freezeable)
 		current->flags |= PF_NOFREEZE;
 
-	set_user_nice(current, -5);
 	/*
 	 * We inherited MPOL_INTERLEAVE from the booting kernel.
 	 * Set MPOL_DEFAULT to insure node local allocations.
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-dont-renice-kernel-threads.patch
sched-implement-rsdl-cpu-scheduler.patch
sched-implement-rsdl-cpu-scheduler-accounting-fixes.patch
sched-document-rsdl-cpu-scheduler.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
