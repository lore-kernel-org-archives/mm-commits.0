From: akpm@linux-foundation.org
Subject: + gru-dynamic-allocation-of-kernel-contexts-update.patch added to -mm tree
Date: Fri, 10 Apr 2009 17:22:52 -0700
Message-ID: <200904110022.n3B0MqM4007195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753840AbZDKAYA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 20:24:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru-dynamic-allocation-of-kernel-contexts-update
has been added to the -mm tree.  Its filename is
     gru-dynamic-allocation-of-kernel-contexts-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru-dynamic-allocation-of-kernel-contexts-update
From: Jack Steiner <steiner@sgi.com>

Added fixes from Andrew.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grumain.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/misc/sgi-gru/grumain.c~gru-dynamic-allocation-of-kernel-contexts-update drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-dynamic-allocation-of-kernel-contexts-update
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -804,8 +804,9 @@ again:
 
 	if (!gts->ts_gru) {
 		if (!gru_assign_gru_context(gts, blade_id)) {
-			mutex_unlock(&gts->ts_ctxlock);
 			preempt_enable();
+			mutex_unlock(&gts->ts_ctxlock);
+			set_current_state(TASK_INTERRUPTIBLE);
 			schedule_timeout(GRU_ASSIGN_DELAY);  /* true hack ZZZ */
 			blade_id = uv_numa_blade_id();
 			if (gts->ts_steal_jiffies + GRU_STEAL_DELAY < jiffies)
@@ -819,8 +820,8 @@ again:
 				vma->vm_page_prot);
 	}
 
-	mutex_unlock(&gts->ts_ctxlock);
 	preempt_enable();
+	mutex_unlock(&gts->ts_ctxlock);
 
 	return VM_FAULT_NOPAGE;
 }
_

Patches currently in -mm which might be from steiner@sgi.com are

gru-bug-fixes-for-gru-exception-handling.patch
gru-dump-chiplet-state.patch
gru-dump-chiplet-state-update.patch
gru-dynamic-allocation-of-kernel-contexts.patch
gru-dynamic-allocation-of-kernel-contexts-update.patch
gru-change-context-load-and-unload.patch
gru-support-cch_allocate-for-kernel-threads.patch
gru-change-resource-assignment-for-kernel-threads.patch
gru-support-contexts-with-zero-dsrs-or-cbrs.patch
gru-fix-handling-of-mesq-failures.patch
gru-check-context-state-on-reload.patch
gru-support-instruction-completion-interrupts.patch
gru-support-for-asynchronous-gru-instructions.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
gru-update-gru-kernel-self-tests.patch
gru-update-to-rev-09-of-gru-spec.patch

