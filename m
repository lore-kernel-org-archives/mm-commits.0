From: akpm@linux-foundation.org
Subject: - put_pid-make-sure-we-dont-free-the-live-pid.patch removed from -mm tree
Date: Tue, 20 May 2008 03:36:06 -0700
Message-ID: <200805201036.m4KAa708018314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753570AbYETKmb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 06:42:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, alan@lxorguk.ukuu.org.uk, ebiederm@xmission.com, kamalesh@linux.vnet.ibm.com, roland@redhat.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     put_pid: make sure we don't free the live pid
has been removed from the -mm tree.  Its filename was
     put_pid-make-sure-we-dont-free-the-live-pid.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: put_pid: make sure we don't free the live pid
From: Oleg Nesterov <oleg@tv-sign.ru>

Add the temporary (for -mm only) debugging code to catch the unbalanced
put_pid()'s.  At least those which can free the "live" pid.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Valdis.Kletnieks@vt.edu
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/pid.c~put_pid-make-sure-we-dont-free-the-live-pid kernel/pid.c
--- a/kernel/pid.c~put_pid-make-sure-we-dont-free-the-live-pid
+++ a/kernel/pid.c
@@ -210,6 +210,10 @@ void put_pid(struct pid *pid)
 	ns = pid->numbers[pid->level].ns;
 	if ((atomic_read(&pid->count) == 1) ||
 	     atomic_dec_and_test(&pid->count)) {
+		int type = PIDTYPE_MAX;
+		while (--type >= 0)
+			if (WARN_ON(!hlist_empty(&pid->tasks[type])))
+				return;
 		kmem_cache_free(ns->pid_cachep, pid);
 		put_pid_ns(ns);
 	}
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

signals-fix-sigqueue_free-vs-__exit_signal-race.patch
uml-activate_mm-remove-the-dead-pf_borrowed_mm-check.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-sigqueue_free-dont-free-sigqueue-if-it-is-queued.patch
signals-introduce-sigqueue_cancelled.patch
posix-timers-use-sigqueue_cancelled-when-the-timer-is-destroyed.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

