From: akpm@linux-foundation.org
Subject: - workqueue-make-init_workqueues-__init.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:53 -0700
Message-ID: <200705092151.l49Lpr6w002932@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758995AbXEIWJU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 18:09:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     workqueue: make init_workqueues() __init
has been removed from the -mm tree.  Its filename was
     workqueue-make-init_workqueues-__init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: workqueue: make init_workqueues() __init
From: Oleg Nesterov <oleg@tv-sign.ru>

The only caller of init_workqueues() is do_basic_setup().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/workqueue.c~workqueue-make-init_workqueues-__init kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-make-init_workqueues-__init
+++ a/kernel/workqueue.c
@@ -823,7 +823,7 @@ static int __devinit workqueue_cpu_callb
 	return NOTIFY_OK;
 }
 
-void init_workqueues(void)
+void __init init_workqueues(void)
 {
 	cpu_populated_map = cpu_online_map;
 	singlethread_cpu = first_cpu(cpu_possible_map);
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
