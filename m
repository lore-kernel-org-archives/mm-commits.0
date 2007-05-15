From: akpm@linux-foundation.org
Subject: - nlmclnt_recovery-dont-use-clone_sighand.patch removed from -mm tree
Date: Tue, 15 May 2007 11:07:34 -0700
Message-ID: <200705151807.l4FI7XkF014174@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47205 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755735AbXEOSIj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 14:08:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, bfields@fieldses.org, neilb@suse.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     nlmclnt_recovery: don't use CLONE_SIGHAND
has been removed from the -mm tree.  Its filename was
     nlmclnt_recovery-dont-use-clone_sighand.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nlmclnt_recovery: don't use CLONE_SIGHAND
From: Oleg Nesterov <oleg@tv-sign.ru>

reclaimer() calls allow_signal() which plays with parent process's ->sighand.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/clntlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/lockd/clntlock.c~nlmclnt_recovery-dont-use-clone_sighand fs/lockd/clntlock.c
--- a/fs/lockd/clntlock.c~nlmclnt_recovery-dont-use-clone_sighand
+++ a/fs/lockd/clntlock.c
@@ -153,7 +153,7 @@ nlmclnt_recovery(struct nlm_host *host)
 	if (!host->h_reclaiming++) {
 		nlm_get_host(host);
 		__module_get(THIS_MODULE);
-		if (kernel_thread(reclaimer, host, CLONE_KERNEL) < 0)
+		if (kernel_thread(reclaimer, host, CLONE_FS | CLONE_FILES) < 0)
 			module_put(THIS_MODULE);
 	}
 }
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

libata-core-convert-to-use-cancel_rearming_delayed_work.patch
git-nfs.patch
make-freezeable-workqueues-singlethread.patch
freezer-close-potential-race-between-refrigerator-and-thaw_tasks.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
freezer-fix-pf_nofreeze-vs-freezeable-race.patch
freezer-move-frozen_process-to-kernel-power-processc.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
tidy-up-usermode-helper-waiting-a-bit.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
