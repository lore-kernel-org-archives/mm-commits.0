From: akpm@osdl.org
Subject: - taskstats_exit_alloc-optimize-simplify.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:03:12 -0800
Message-ID: <200612072303.kB7N3CZx029944@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52015 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163837AbWLGXER (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:04:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, balbir@in.ibm.com, nagar@watson.ibm.com, mm-commits@vger.kernel.org


The patch titled
     taskstats_exit_alloc: optimize/simplify
has been removed from the -mm tree.  Its filename was
     taskstats_exit_alloc-optimize-simplify.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: taskstats_exit_alloc: optimize/simplify
From: Oleg Nesterov <oleg@tv-sign.ru>

If there are no listeners, every task does unneeded kmem_cache alloc/free on
exit. We don't need listeners->sem for 'if (!list_empty())' check. Yes, we may
have a false positive, but this doesn't differ from the case when the listener
is unregistered after we drop the semaphore. So we don't need to do allocation
beforehand.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Balbir Singh <balbir@in.ibm.com>
Acked-by: Shailabh Nagar <nagar@watson.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/taskstats.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff -puN kernel/taskstats.c~taskstats_exit_alloc-optimize-simplify kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats_exit_alloc-optimize-simplify
+++ a/kernel/taskstats.c
@@ -416,7 +416,6 @@ err:
 void taskstats_exit_alloc(struct taskstats **ptidstats, unsigned int *mycpu)
 {
 	struct listener_list *listeners;
-	struct taskstats *tmp;
 	/*
 	 * This is the cpu on which the task is exiting currently and will
 	 * be the one for which the exit event is sent, even if the cpu
@@ -424,19 +423,11 @@ void taskstats_exit_alloc(struct tasksta
 	 */
 	*mycpu = raw_smp_processor_id();
 
-	*ptidstats = NULL;
-	tmp = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
-	if (!tmp)
-		return;
-
 	listeners = &per_cpu(listener_array, *mycpu);
-	down_read(&listeners->sem);
-	if (!list_empty(&listeners->list)) {
-		*ptidstats = tmp;
-		tmp = NULL;
-	}
-	up_read(&listeners->sem);
-	kfree(tmp);
+
+	*ptidstats = NULL;
+	if (!list_empty(&listeners->list))
+		*ptidstats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
 }
 
 /* Send pid data out on exit */
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
tty-signal-tty-locking.patch
tty-signal-tty-locking-post-viro-trainwreck.patch
tty-signal-tty-locking-post-viro-trainwreck-fix.patch
tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch
do_task_stat-dont-take-tty_mutex.patch
do_acct_process-dont-take-tty_mutex.patch
trivial-make-set_special_pids-static.patch
sys_unshare-remove-a-broken-clone_sighand-code.patch
sys_setpgid-eliminate-unnecessary-do_each_task_pidpidtype_pgid.patch
session_of_pgrp-kill-unnecessary-do_each_task_pidpidtype_pgid.patch
pidhash-temporary-debug-checks.patch

