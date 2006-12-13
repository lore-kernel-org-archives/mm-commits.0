From: akpm@osdl.org
Subject: + pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch added to -mm tree
Date: Wed, 13 Dec 2006 14:09:43 -0800
Message-ID: <200612132209.kBDM9hed021944@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48406 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbWLMWJr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:09:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk, oleg@tv-sign.ru


The patch titled
     pid: remove the now unused kill_pg kill_pg_info and __kill_pg_info
has been added to the -mm tree.  Its filename is
     pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid: remove the now unused kill_pg kill_pg_info and __kill_pg_info
From: Eric W. Biederman <ebiederm@xmission.com>

Now that I have changed all of the in-tree users remove the old version of
these functions.  This should make it clear to any out of tree users that they
should be using kill_pgrp kill_pgrp_info or __kill_pgrp_info instead.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/sched.h |    3 ---
 kernel/signal.c       |   27 ---------------------------
 2 files changed, 30 deletions(-)

diff -puN include/linux/sched.h~pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info include/linux/sched.h
--- a/include/linux/sched.h~pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info
+++ a/include/linux/sched.h
@@ -1324,14 +1324,11 @@ extern int kill_pid_info(int sig, struct
 extern int kill_pid_info_as_uid(int, struct siginfo *, struct pid *, uid_t, uid_t, u32);
 extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
-extern int __kill_pg_info(int sig, struct siginfo *info, pid_t pgrp);
-extern int kill_pg_info(int, struct siginfo *, pid_t);
 extern void do_notify_parent(struct task_struct *, int);
 extern void force_sig(int, struct task_struct *);
 extern void force_sig_specific(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
 extern void zap_other_threads(struct task_struct *p);
-extern int kill_pg(pid_t, int, int);
 extern int kill_proc(pid_t, int, int);
 extern struct sigqueue *sigqueue_alloc(void);
 extern void sigqueue_free(struct sigqueue *);
diff -puN kernel/signal.c~pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info kernel/signal.c
--- a/kernel/signal.c~pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info
+++ a/kernel/signal.c
@@ -1096,26 +1096,6 @@ int kill_pgrp_info(int sig, struct sigin
 	return retval;
 }
 
-int __kill_pg_info(int sig, struct siginfo *info, pid_t pgrp)
-{
-	if (pgrp <= 0)
-		return -EINVAL;
-
-	return __kill_pgrp_info(sig, info, find_pid(pgrp));
-}
-
-int
-kill_pg_info(int sig, struct siginfo *info, pid_t pgrp)
-{
-	int retval;
-
-	read_lock(&tasklist_lock);
-	retval = __kill_pg_info(sig, info, pgrp);
-	read_unlock(&tasklist_lock);
-
-	return retval;
-}
-
 int kill_pid_info(int sig, struct siginfo *info, struct pid *pid)
 {
 	int error;
@@ -1316,12 +1296,6 @@ int kill_pid(struct pid *pid, int sig, i
 EXPORT_SYMBOL(kill_pid);
 
 int
-kill_pg(pid_t pgrp, int sig, int priv)
-{
-	return kill_pg_info(sig, __si_special(priv), pgrp);
-}
-
-int
 kill_proc(pid_t pid, int sig, int priv)
 {
 	return kill_proc_info(sig, __si_special(priv), pid);
@@ -1960,7 +1934,6 @@ EXPORT_SYMBOL(recalc_sigpending);
 EXPORT_SYMBOL_GPL(dequeue_signal);
 EXPORT_SYMBOL(flush_signals);
 EXPORT_SYMBOL(force_sig);
-EXPORT_SYMBOL(kill_pg);
 EXPORT_SYMBOL(kill_proc);
 EXPORT_SYMBOL(ptrace_notify);
 EXPORT_SYMBOL(send_sig);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
revert-identifier-to-nsproxy.patch
vt-fix-comments-to-not-refer-to-kill_proc.patch
n_r3964-use-struct-pid-to-track-user-space-clients.patch
smbfs-make-conn_pid-a-struct-pid.patch
ncpfs-use-struct-pid-to-track-the-userspace-watchdog-process.patch
ncpfs-ensure-we-free-wdog_pid-on-parse_option-or-fill_inode-failure.patch
usbatm-update-to-use-the-kthread-api.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
vt-refactor-console-sak-processing.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
updated-i386-cleanup-apic-code.patch
updated-i386-rework-local-apic-calibration.patch
updated-dynticks-fix-nmi-watchdog.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
pidhash-temporary-debug-checks.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

