From: akpm@linux-foundation.org
Subject: - kernel-schedc-remove-double-unlikely.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:31:06 -0700
Message-ID: <200803212031.m2LKV6is009046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758737AbYCUUbb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:31:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kernel/sched.c: remove double unlikely
has been removed from the -mm tree.  Its filename was
     kernel-schedc-remove-double-unlikely.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/sched.c: remove double unlikely
From: Roel Kluin <12o3l@tiscali.nl>

Combine two unlikely's

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~kernel-schedc-remove-double-unlikely kernel/sched.c
--- a/kernel/sched.c~kernel-schedc-remove-double-unlikely
+++ a/kernel/sched.c
@@ -3959,7 +3959,7 @@ need_resched_nonpreemptible:
 
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
 		if (unlikely((prev->state & TASK_INTERRUPTIBLE) &&
-				unlikely(signal_pending(prev)))) {
+				signal_pending(prev))) {
 			prev->state = TASK_RUNNING;
 		} else {
 			deactivate_task(rq, prev, 1);
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
git-dvb.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch
drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch
drivers-video-imsttfbc-add-missing-curly-brackets.patch

