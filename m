From: akpm@linux-foundation.org
Subject: + zap_other_threads-dont-optimize-thread_group_empty-case.patch added to -mm tree
Date: Tue, 07 Aug 2007 15:57:40 -0700
Message-ID: <200708072257.l77MveQV009174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48579 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753878AbXHGW6q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 18:58:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     zap_other_threads: don't optimize thread_group_empty() case
has been added to the -mm tree.  Its filename is
     zap_other_threads-dont-optimize-thread_group_empty-case.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: zap_other_threads: don't optimize thread_group_empty() case
From: Oleg Nesterov <oleg@tv-sign.ru>

Nowadays thread_group_empty() and next_thread() are simple list operations,
this optimization doesn't make sense: we are doing exactly same check one
line below.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    3 ---
 1 files changed, 3 deletions(-)

diff -puN kernel/signal.c~zap_other_threads-dont-optimize-thread_group_empty-case kernel/signal.c
--- a/kernel/signal.c~zap_other_threads-dont-optimize-thread_group_empty-case
+++ a/kernel/signal.c
@@ -976,9 +976,6 @@ void zap_other_threads(struct task_struc
 	p->signal->flags = SIGNAL_GROUP_EXIT;
 	p->signal->group_stop_count = 0;
 
-	if (thread_group_empty(p))
-		return;
-
 	for (t = next_thread(p); t != p; t = next_thread(t)) {
 		/*
 		 * Don't bother with already dead threads
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

fix-theoretical-ccids_readwrite_lock-race.patch
i386-remove-unnecessary-code.patch
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
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
