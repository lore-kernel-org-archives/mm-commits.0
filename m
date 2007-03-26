From: akpm@linux-foundation.org
Subject: - sched-remove-noninteractive-flag.patch removed from -mm tree
Date: Mon, 26 Mar 2007 15:37:18 -0700
Message-ID: <200703262237.l2QMbIeV032428@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56487 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933648AbXCZWhY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 18:37:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kolivas.org, mingo@elte.hu, nickpiggin@yahoo.com.au, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: remove noninteractive flag
has been removed from the -mm tree.  Its filename was
     sched-remove-noninteractive-flag.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: sched: remove noninteractive flag
From: Con Kolivas <kernel@kolivas.org>

Remove the TASK_NONINTERACTIVE flag as it will no longer be used.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c             |    7 +------
 include/linux/sched.h |    3 +--
 2 files changed, 2 insertions(+), 8 deletions(-)

diff -puN fs/pipe.c~sched-remove-noninteractive-flag fs/pipe.c
--- a/fs/pipe.c~sched-remove-noninteractive-flag
+++ a/fs/pipe.c
@@ -41,12 +41,7 @@ void pipe_wait(struct pipe_inode_info *p
 {
 	DEFINE_WAIT(wait);
 
-	/*
-	 * Pipes are system-local resources, so sleeping on them
-	 * is considered a noninteractive wait:
-	 */
-	prepare_to_wait(&pipe->wait, &wait,
-			TASK_INTERRUPTIBLE | TASK_NONINTERACTIVE);
+	prepare_to_wait(&pipe->wait, &wait, TASK_INTERRUPTIBLE);
 	if (pipe->inode)
 		mutex_unlock(&pipe->inode->i_mutex);
 	schedule();
diff -puN include/linux/sched.h~sched-remove-noninteractive-flag include/linux/sched.h
--- a/include/linux/sched.h~sched-remove-noninteractive-flag
+++ a/include/linux/sched.h
@@ -149,8 +149,7 @@ extern unsigned long weighted_cpuload(co
 #define EXIT_ZOMBIE		16
 #define EXIT_DEAD		32
 /* in tsk->state again */
-#define TASK_NONINTERACTIVE	64
-#define TASK_DEAD		128
+#define TASK_DEAD		64
 
 #define __set_task_state(tsk, state_value)		\
 	do { (tsk)->state = (state_value); } while (0)
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
sched-remove-noninteractive-flag.patch
sched-dont-renice-kernel-threads.patch
sched-implement-rsdl-cpu-scheduler.patch
sched-document-rsdl-cpu-scheduler.patch
sched-rsdl-improvements.patch
sched-rsdl-check-for-niced-tasks-lowering-prio-level.patch
sched-rsdl-yet-more-fixes.patch
