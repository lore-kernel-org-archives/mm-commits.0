From: akpm@linux-foundation.org
Subject: - fix-theoretical-ccids_readwrite_lock-race.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:12:43 -0700
Message-ID: <200708141912.l7EJChMt016428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932375AbXHNTVW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:21:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, acme@redhat.com, davem@davemloft.net, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     fix theoretical ccids_{read,write}_lock() race
has been removed from the -mm tree.  Its filename was
     fix-theoretical-ccids_readwrite_lock-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix theoretical ccids_{read,write}_lock() race
From: Oleg Nesterov <oleg@tv-sign.ru>

Make sure that spin_unlock_wait() is properly ordered wrt atomic_inc().

(akpm: can't we convert this code to use rwlocks?)

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/dccp/ccid.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN net/dccp/ccid.c~fix-theoretical-ccids_readwrite_lock-race net/dccp/ccid.c
--- a/net/dccp/ccid.c~fix-theoretical-ccids_readwrite_lock-race
+++ a/net/dccp/ccid.c
@@ -40,6 +40,7 @@ static inline void ccids_write_unlock(vo
 static inline void ccids_read_lock(void)
 {
 	atomic_inc(&ccids_lockct);
+	smp_mb__after_atomic_inc();
 	spin_unlock_wait(&ccids_lock);
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
git-dvb.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
do_poll-return-eintr-when-signalled.patch
pi-futex-set-pf_exiting-without-taking-pi_lock.patch
do_sigaction-remove-now-unneeded-recalc_sigpending.patch
handle-the-multi-threaded-inits-exit-properly.patch
wait_task_zombie-remove-unneeded-child-signal-check.patch
wait_task_zombie-fix-2-3-races-vs-forget_original_parent.patch
exit_notify-dont-take-tasklist-for-tif_sigpending-re-targeting.patch
zap_other_threads-dont-optimize-thread_group_empty-case.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
make-access-to-tasks-nsproxy-lighter.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
