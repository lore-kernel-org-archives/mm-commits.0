From: akpm@linux-foundation.org
Subject: - workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:47 -0700
Message-ID: <200705092151.l49LplB8002921@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758761AbXEIVwH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     workqueue: make cancel_rearming_delayed_workqueue() work on idle dwork
has been removed from the -mm tree.  Its filename was
     workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: workqueue: make cancel_rearming_delayed_workqueue() work on idle dwork
From: Oleg Nesterov <oleg@tv-sign.ru>

cancel_rearming_delayed_workqueue(dwork) will hang forever if dwork was not
scheduled, because in that case cancel_delayed_work()->del_timer_sync() never
returns true.

I don't know if there are any callers which may have problems, but this is not
so convenient, and the fix is very simple.

Q: looks like we don't need "struct workqueue_struct *wq" parameter.  If the
timer was aborted successfully, get_wq_data() == wq.  Is it worth to add the
new function?

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/workqueue.c~workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork
+++ a/kernel/workqueue.c
@@ -569,6 +569,10 @@ EXPORT_SYMBOL(flush_work_keventd);
 void cancel_rearming_delayed_workqueue(struct workqueue_struct *wq,
 				       struct delayed_work *dwork)
 {
+	/* Was it ever queued ? */
+	if (!get_wq_data(&dwork->work))
+		return;
+
 	while (!cancel_delayed_work(dwork))
 		flush_workqueue(wq);
 }
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
dont-init-pgrp-and-__session-in-init_signals.patch
