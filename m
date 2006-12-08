From: akpm@osdl.org
Subject: - do_task_stat-dont-take-tty_mutex.patch removed from -mm tree
Date: Fri, 08 Dec 2006 11:59:59 -0800
Message-ID: <200612081959.kB8JxxL5001665@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56554 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426194AbWLHUAV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:00:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, a.p.zijlstra@chello.nl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     do_task_stat(): don't take tty_mutex
has been removed from the -mm tree.  Its filename was
     do_task_stat-dont-take-tty_mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: do_task_stat(): don't take tty_mutex
From: Oleg Nesterov <oleg@tv-sign.ru>

->signal->tty is protected by ->siglock, no need to take the global tty_mutex.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/array.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff -puN fs/proc/array.c~do_task_stat-dont-take-tty_mutex fs/proc/array.c
--- a/fs/proc/array.c~do_task_stat-dont-take-tty_mutex
+++ a/fs/proc/array.c
@@ -346,20 +346,13 @@ static int do_task_stat(struct task_stru
 	sigemptyset(&sigcatch);
 	cutime = cstime = utime = stime = cputime_zero;
 
-	mutex_lock(&tty_mutex);
 	rcu_read_lock();
 	if (lock_task_sighand(task, &flags)) {
 		struct signal_struct *sig = task->signal;
-		struct tty_struct *tty = sig->tty;
 
-		if (tty) {
-			/*
-			 * sig->tty is not stable, but tty_mutex
-			 * protects us from release_dev(tty)
-			 */
-			barrier();
-			tty_pgrp = tty->pgrp;
-			tty_nr = new_encode_dev(tty_devnum(tty));
+		if (sig->tty) {
+			tty_pgrp = sig->tty->pgrp;
+			tty_nr = new_encode_dev(tty_devnum(sig->tty));
 		}
 
 		num_threads = atomic_read(&sig->count);
@@ -395,7 +388,6 @@ static int do_task_stat(struct task_stru
 		unlock_task_sighand(task, &flags);
 	}
 	rcu_read_unlock();
-	mutex_unlock(&tty_mutex);
 
 	if (!whole || num_threads<2)
 		wchan = get_wchan(task);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
do_task_stat-dont-take-tty_mutex.patch
do_acct_process-dont-take-tty_mutex.patch
trivial-make-set_special_pids-static.patch
sys_unshare-remove-a-broken-clone_sighand-code.patch
sys_setpgid-eliminate-unnecessary-do_each_task_pidpidtype_pgid.patch
session_of_pgrp-kill-unnecessary-do_each_task_pidpidtype_pgid.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
pidhash-temporary-debug-checks.patch

