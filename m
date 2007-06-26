From: akpm@linux-foundation.org
Subject: + nbdcsock_xmit-cleanup-signal-related-code.patch added to -mm tree
Date: Tue, 26 Jun 2007 13:48:30 -0700
Message-ID: <200706262048.l5QKmUqg001812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40020 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758123AbXFZUtW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 16:49:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, paul.clements@steeleye.com


The patch titled
     nbd.c: sock_xmit: cleanup signal related code
has been added to the -mm tree.  Its filename is
     nbdcsock_xmit-cleanup-signal-related-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nbd.c: sock_xmit: cleanup signal related code
From: Oleg Nesterov <oleg@tv-sign.ru>

sock_xmit() re-implements sigprocmask() and dequeue_signal_lock().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |   22 ++++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

diff -puN drivers/block/nbd.c~nbdcsock_xmit-cleanup-signal-related-code drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbdcsock_xmit-cleanup-signal-related-code
+++ a/drivers/block/nbd.c
@@ -122,17 +122,12 @@ static int sock_xmit(struct socket *sock
 	int result;
 	struct msghdr msg;
 	struct kvec iov;
-	unsigned long flags;
-	sigset_t oldset;
+	sigset_t blocked, oldset;
 
 	/* Allow interception of SIGKILL only
 	 * Don't allow other signals to interrupt the transmission */
-	spin_lock_irqsave(&current->sighand->siglock, flags);
-	oldset = current->blocked;
-	sigfillset(&current->blocked);
-	sigdelsetmask(&current->blocked, sigmask(SIGKILL));
-	recalc_sigpending();
-	spin_unlock_irqrestore(&current->sighand->siglock, flags);
+	siginitsetinv(&blocked, sigmask(SIGKILL));
+	sigprocmask(SIG_SETMASK, &blocked, &oldset);
 
 	do {
 		sock->sk->sk_allocation = GFP_NOIO;
@@ -151,11 +146,9 @@ static int sock_xmit(struct socket *sock
 
 		if (signal_pending(current)) {
 			siginfo_t info;
-			spin_lock_irqsave(&current->sighand->siglock, flags);
 			printk(KERN_WARNING "nbd (pid %d: %s) got signal %d\n",
-				current->pid, current->comm, 
-				dequeue_signal(current, &current->blocked, &info));
-			spin_unlock_irqrestore(&current->sighand->siglock, flags);
+				current->pid, current->comm,
+				dequeue_signal_lock(current, &current->blocked, &info));
 			result = -EINTR;
 			break;
 		}
@@ -169,10 +162,7 @@ static int sock_xmit(struct socket *sock
 		buf += result;
 	} while (size > 0);
 
-	spin_lock_irqsave(&current->sighand->siglock, flags);
-	current->blocked = oldset;
-	recalc_sigpending();
-	spin_unlock_irqrestore(&current->sighand->siglock, flags);
+	sigprocmask(SIG_SETMASK, &oldset, NULL);
 
 	return result;
 }
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

avoid-spurious-pollin-returns-in-signalfd.patch
w1_therm_read_bin-suspicious-usage-of-flush_signals.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-2.patch
freezer-run-show_state-when-freezing-times-out.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
mm-fix-create_new_namespaces-return-value.patch
adb_probe_task-remove-unneeded-flush_signals-call.patch
kcdrwd-remove-unneeded-flush_signals-call.patch
nbdcsock_xmit-cleanup-signal-related-code.patch
