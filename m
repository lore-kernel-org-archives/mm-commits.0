From: akpm@linux-foundation.org
Subject: - sched-dont-renice-kernel-threads.patch removed from -mm tree
Date: Mon, 26 Mar 2007 15:37:20 -0700
Message-ID: <200703262237.l2QMbKFk032434@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56489 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933691AbXCZWhZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 18:37:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kolivas.org, mm-commits@vger.kernel.org


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
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
sched-dont-renice-kernel-threads.patch
sched-implement-rsdl-cpu-scheduler.patch
sched-document-rsdl-cpu-scheduler.patch
sched-rsdl-improvements.patch
sched-rsdl-check-for-niced-tasks-lowering-prio-level.patch
sched-rsdl-yet-more-fixes.patch
