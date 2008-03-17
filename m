From: akpm@linux-foundation.org
Subject: + kernel-schedc-remove-double-unlikely.patch added to -mm tree
Date: Mon, 17 Mar 2008 14:56:02 -0700
Message-ID: <200803172156.m2HLu2PX000419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753183AbYCQV4a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:56:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, a.p.zijlstra@chello.nl, mingo@elte.hu


The patch titled
     kernel/sched.c: remove double unlikely
has been added to the -mm tree.  Its filename is
     kernel-schedc-remove-double-unlikely.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-dvb.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
kernel-schedc-remove-double-unlikely.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch
drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch
drivers-video-imsttfbc-add-missing-curly-brackets.patch

