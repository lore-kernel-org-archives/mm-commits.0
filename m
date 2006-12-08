From: akpm@osdl.org
Subject: - do_acct_process-dont-take-tty_mutex.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:00:04 -0800
Message-ID: <200612082000.kB8K04wo001703@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56634 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426207AbWLHUAr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:00:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     do_acct_process(): don't take tty_mutex
has been removed from the -mm tree.  Its filename was
     do_acct_process-dont-take-tty_mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: do_acct_process(): don't take tty_mutex
From: Oleg Nesterov <oleg@tv-sign.ru>

No need to take the global tty_mutex, signal->tty->driver can't go away while
we are holding ->siglock.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/acct.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN kernel/acct.c~do_acct_process-dont-take-tty_mutex kernel/acct.c
--- a/kernel/acct.c~do_acct_process-dont-take-tty_mutex
+++ a/kernel/acct.c
@@ -485,12 +485,9 @@ static void do_acct_process(struct file 
 	ac.ac_ppid = current->parent->tgid;
 #endif
 
-	mutex_lock(&tty_mutex);
-	tty = get_current_tty();
-	ac.ac_tty = tty ? old_encode_dev(tty_devnum(tty)) : 0;
-	mutex_unlock(&tty_mutex);
-
 	spin_lock_irq(&current->sighand->siglock);
+	tty = current->signal->tty;
+	ac.ac_tty = tty ? old_encode_dev(tty_devnum(tty)) : 0;
 	ac.ac_utime = encode_comp_t(jiffies_to_AHZ(cputime_to_jiffies(pacct->ac_utime)));
 	ac.ac_stime = encode_comp_t(jiffies_to_AHZ(cputime_to_jiffies(pacct->ac_stime)));
 	ac.ac_flag = pacct->ac_flag;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
do_acct_process-dont-take-tty_mutex.patch
trivial-make-set_special_pids-static.patch
sys_unshare-remove-a-broken-clone_sighand-code.patch
sys_setpgid-eliminate-unnecessary-do_each_task_pidpidtype_pgid.patch
session_of_pgrp-kill-unnecessary-do_each_task_pidpidtype_pgid.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
pidhash-temporary-debug-checks.patch

