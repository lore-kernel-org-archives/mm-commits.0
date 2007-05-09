From: akpm@linux-foundation.org
Subject: - ipvs-flush-defense_work-before-module-unload.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:05 -0700
Message-ID: <200705092152.l49Lq5ia002964@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758761AbXEIVwZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     ipvs: flush defense_work before module unload
has been removed from the -mm tree.  Its filename was
     ipvs-flush-defense_work-before-module-unload.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ipvs: flush defense_work before module unload
From: Oleg Nesterov <oleg@tv-sign.ru>

net/ipv4/ipvs/ip_vs_core.c

	module_exit
	    ip_vs_cleanup
		ip_vs_control_cleanup
		    cancel_rearming_delayed_work
	// done

This is unsafe.  The module may be unloaded and the memory may be freed
while defense_work's handler is still running/preempted.

Do flush_work(&defense_work.work) after cancel_rearming_delayed_work().

Alternatively, we could add flush_work() to cancel_rearming_delayed_work(),
but note that we can't change cancel_delayed_work() in the same manner
because it may be called from atomic context.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/ipvs/ip_vs_ctl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN net/ipv4/ipvs/ip_vs_ctl.c~ipvs-flush-defense_work-before-module-unload net/ipv4/ipvs/ip_vs_ctl.c
--- a/net/ipv4/ipvs/ip_vs_ctl.c~ipvs-flush-defense_work-before-module-unload
+++ a/net/ipv4/ipvs/ip_vs_ctl.c
@@ -2387,6 +2387,7 @@ void ip_vs_control_cleanup(void)
 	EnterFunction(2);
 	ip_vs_trash_cleanup();
 	cancel_rearming_delayed_work(&defense_work);
+	flush_work_keventd(&defense_work.work);
 	ip_vs_kill_estimator(&ip_vs_stats);
 	unregister_sysctl_table(sysctl_header);
 	proc_net_remove("ip_vs_stats");
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
