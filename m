From: akpm@linux-foundation.org
Subject: - remove-final-fastcall-users.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:15:38 -0500
Message-ID: <200802150218.m1F2Iv6q014965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42891 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757148AbYBOCTB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:19:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     remove final fastcall users
has been removed from the -mm tree.  Its filename was
     remove-final-fastcall-users.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove final fastcall users
From: Harvey Harrison <harvey.harrison@gmail.com>

fastcall always expands to empty, remove it.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/RCU/NMI-RCU.txt |    2 +-
 Documentation/kprobes.txt     |   11 +++++------
 kernel/signal.c               |    2 +-
 mm/filemap.c                  |    2 +-
 net/bluetooth/rfcomm/core.c   |    4 ++--
 net/core/dev.c                |    2 +-
 net/core/sock.c               |    4 ++--
 7 files changed, 13 insertions(+), 14 deletions(-)

diff -puN Documentation/RCU/NMI-RCU.txt~remove-final-fastcall-users Documentation/RCU/NMI-RCU.txt
--- a/Documentation/RCU/NMI-RCU.txt~remove-final-fastcall-users
+++ a/Documentation/RCU/NMI-RCU.txt
@@ -25,7 +25,7 @@ the NMI handler to take the default mach
 This nmi_callback variable is a global function pointer to the current
 NMI handler.
 
-	fastcall void do_nmi(struct pt_regs * regs, long error_code)
+	void do_nmi(struct pt_regs * regs, long error_code)
 	{
 		int cpu;
 
diff -puN Documentation/kprobes.txt~remove-final-fastcall-users Documentation/kprobes.txt
--- a/Documentation/kprobes.txt~remove-final-fastcall-users
+++ a/Documentation/kprobes.txt
@@ -92,9 +92,8 @@ handler has run.  Up to MAX_STACK_SIZE b
 64 bytes on i386.
 
 Note that the probed function's args may be passed on the stack
-or in registers (e.g., for x86_64 or for an i386 fastcall function).
-The jprobe will work in either case, so long as the handler's
-prototype matches that of the probed function.
+or in registers.  The jprobe will work in either case, so long as the
+handler's prototype matches that of the probed function.
 
 1.3 Return Probes
 
@@ -270,9 +269,9 @@ Kprobes runs the handler whose address i
 The handler should have the same arg list and return type as the probed
 function; and just before it returns, it must call jprobe_return().
 (The handler never actually returns, since jprobe_return() returns
-control to Kprobes.)  If the probed function is declared asmlinkage,
-fastcall, or anything else that affects how args are passed, the
-handler's declaration must match.
+control to Kprobes.)  If the probed function is declared asmlinkage
+or anything else that affects how args are passed, the handler's
+declaration must match.
 
 register_jprobe() returns 0 on success, or a negative errno otherwise.
 
diff -puN kernel/signal.c~remove-final-fastcall-users kernel/signal.c
--- a/kernel/signal.c~remove-final-fastcall-users
+++ a/kernel/signal.c
@@ -972,7 +972,7 @@ void zap_other_threads(struct task_struc
 	}
 }
 
-int fastcall __fatal_signal_pending(struct task_struct *tsk)
+int __fatal_signal_pending(struct task_struct *tsk)
 {
 	return sigismember(&tsk->pending.signal, SIGKILL);
 }
diff -puN mm/filemap.c~remove-final-fastcall-users mm/filemap.c
--- a/mm/filemap.c~remove-final-fastcall-users
+++ a/mm/filemap.c
@@ -604,7 +604,7 @@ void __lock_page(struct page *page)
 }
 EXPORT_SYMBOL(__lock_page);
 
-int fastcall __lock_page_killable(struct page *page)
+int __lock_page_killable(struct page *page)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
 
diff -puN net/bluetooth/rfcomm/core.c~remove-final-fastcall-users net/bluetooth/rfcomm/core.c
--- a/net/bluetooth/rfcomm/core.c~remove-final-fastcall-users
+++ a/net/bluetooth/rfcomm/core.c
@@ -465,7 +465,7 @@ int rfcomm_dlc_send(struct rfcomm_dlc *d
 	return len;
 }
 
-void fastcall __rfcomm_dlc_throttle(struct rfcomm_dlc *d)
+void __rfcomm_dlc_throttle(struct rfcomm_dlc *d)
 {
 	BT_DBG("dlc %p state %ld", d, d->state);
 
@@ -476,7 +476,7 @@ void fastcall __rfcomm_dlc_throttle(stru
 	rfcomm_schedule(RFCOMM_SCHED_TX);
 }
 
-void fastcall __rfcomm_dlc_unthrottle(struct rfcomm_dlc *d)
+void __rfcomm_dlc_unthrottle(struct rfcomm_dlc *d)
 {
 	BT_DBG("dlc %p state %ld", d, d->state);
 
diff -puN net/core/dev.c~remove-final-fastcall-users net/core/dev.c
--- a/net/core/dev.c~remove-final-fastcall-users
+++ a/net/core/dev.c
@@ -2143,7 +2143,7 @@ static int process_backlog(struct napi_s
  *
  * The entry's receive function will be scheduled to run
  */
-void fastcall __napi_schedule(struct napi_struct *n)
+void __napi_schedule(struct napi_struct *n)
 {
 	unsigned long flags;
 
diff -puN net/core/sock.c~remove-final-fastcall-users net/core/sock.c
--- a/net/core/sock.c~remove-final-fastcall-users
+++ a/net/core/sock.c
@@ -1731,7 +1731,7 @@ void sock_init_data(struct socket *sock,
 	atomic_set(&sk->sk_drops, 0);
 }
 
-void fastcall lock_sock_nested(struct sock *sk, int subclass)
+void lock_sock_nested(struct sock *sk, int subclass)
 {
 	might_sleep();
 	spin_lock_bh(&sk->sk_lock.slock);
@@ -1748,7 +1748,7 @@ void fastcall lock_sock_nested(struct so
 
 EXPORT_SYMBOL(lock_sock_nested);
 
-void fastcall release_sock(struct sock *sk)
+void release_sock(struct sock *sk)
 {
 	/*
 	 * The sk_lock has mutex_unlock() semantics:
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
inotify-make-variables-static-in-inotify_userc.patch
kernel-doc-remove-fastcall.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ubi-fix-sparse-errors-in-ubih.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
jbd-sparse-warnings-in-revokec-journalc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
