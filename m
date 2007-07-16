From: akpm@linux-foundation.org
Subject: - adb_probe_task-remove-unneeded-flush_signals-call.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:58:04 -0700
Message-ID: <200707162058.l6GKw4rP002321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37690 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758803AbXGPVQz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:16:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     adb_probe_task: remove unneeded flush_signals() call
has been removed from the -mm tree.  Its filename was
     adb_probe_task-remove-unneeded-flush_signals-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: adb_probe_task: remove unneeded flush_signals() call
From: Oleg Nesterov <oleg@tv-sign.ru>

adb_probe_task() is forked by "events" thread, all signals are ignored, no
need to play with signal blocking/flushing.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/adb.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/macintosh/adb.c~adb_probe_task-remove-unneeded-flush_signals-call drivers/macintosh/adb.c
--- a/drivers/macintosh/adb.c~adb_probe_task-remove-unneeded-flush_signals-call
+++ a/drivers/macintosh/adb.c
@@ -248,21 +248,15 @@ static int adb_scan_bus(void)
 static int
 adb_probe_task(void *x)
 {
-	sigset_t blocked;
-
 	strcpy(current->comm, "kadbprobe");
 
-	sigfillset(&blocked);
-	sigprocmask(SIG_BLOCK, &blocked, NULL);
-	flush_signals(current);
-
 	printk(KERN_INFO "adb: starting probe task...\n");
 	do_adb_reset_bus();
 	printk(KERN_INFO "adb: finished probe task...\n");
-	
+
 	adb_probe_task_pid = 0;
 	up(&adb_probe_mutex);
-	
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
freezer-run-show_state-when-freezing-times-out.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
destroy_workqueue-can-livelock.patch
