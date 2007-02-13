From: akpm@linux-foundation.org
Subject: + ipvs-flush-defense_work-before-module-unload.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:44:57 -0800
Message-ID: <200702130544.l1D5ivZc022870@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55428 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161089AbXBMFpN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:45:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, davem@davemloft.net


The patch titled
     ipvs: flush defense_work before module unload
has been added to the -mm tree.  Its filename is
     ipvs-flush-defense_work-before-module-unload.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

akpm: depends on lots of -mm-only goop.

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
git-block.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
posix-timers-rcu-optimization-for-clock_gettime.patch
posix-timers-rcu-optimization-for-clock_gettime-fix.patch
reimplement-flush_workqueue.patch
implement-flush_work.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
flush_cpu_workqueue-dont-flush-an-empty-worklist.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-dont-save-interrupts-in-run_workqueue-update-2.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
make-queue_delayed_work-friendly-to-flush_fork.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
ipvs-flush-defense_work-before-module-unload.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
rework-compat_sys_io_submit.patch
fix-aioh-includes.patch
fix-access_ok-checks.patch
make-good_sigevent-non-static.patch
make-good_sigevent-non-static-fix.patch
make-__sigqueue_free-and.patch
aio-completion-signal-notification.patch
aio-completion-signal-notification-fix.patch
aio-completion-signal-notification-fixes-and-cleanups.patch
aio-completion-signal-notification-small-cleanup.patch
add-listio-syscall-support.patch
