From: akpm@osdl.org
Subject: + signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch added to -mm tree
Date: Wed, 13 Dec 2006 14:09:26 -0800
Message-ID: <200612132209.kBDM9Qin021910@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48355 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbWLMWJa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:09:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk, oleg@tv-sign.ru


The patch titled
     signal: use kill_pgrp not kill_pg in the sunos compatibility code
has been added to the -mm tree.  Its filename is
     signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: signal: use kill_pgrp not kill_pg in the sunos compatibility code
From: Eric W. Biederman <ebiederm@xmission.com>

I am slowly moving to a model where all process killing is struct pid based
instead of pid_t based.  The sunos compatibility code is one of the last users
of the old pid_t based kill_pg in the kernel.  By being complete I allow for
the future removal of kill_pg from the kernel, which will ensure I don't miss
something.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/sparc/kernel/sys_sunos.c     |   10 ++++++----
 arch/sparc64/kernel/sys_sunos32.c |   11 +++++++++--
 2 files changed, 15 insertions(+), 6 deletions(-)

diff -puN arch/sparc/kernel/sys_sunos.c~signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code arch/sparc/kernel/sys_sunos.c
--- a/arch/sparc/kernel/sys_sunos.c~signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code
+++ a/arch/sparc/kernel/sys_sunos.c
@@ -859,14 +859,16 @@ asmlinkage int sunos_wait4(pid_t pid, un
 	return ret;
 }
 
-extern int kill_pg(int, int, int);
 asmlinkage int sunos_killpg(int pgrp, int sig)
 {
 	int ret;
 
-	lock_kernel();
-	ret = kill_pg(pgrp, sig, 0);
-	unlock_kernel();
+	rcu_read_lock();
+	ret = -EINVAL;
+	if (pgrp > 0)
+		ret = kill_pgrp(find_pid(pgrp), sig, 0);
+	rcu_read_unlock();
+
 	return ret;
 }
 
diff -puN arch/sparc64/kernel/sys_sunos32.c~signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code arch/sparc64/kernel/sys_sunos32.c
--- a/arch/sparc64/kernel/sys_sunos32.c~signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code
+++ a/arch/sparc64/kernel/sys_sunos32.c
@@ -824,10 +824,17 @@ asmlinkage int sunos_wait4(compat_pid_t 
 	return ret;
 }
 
-extern int kill_pg(int, int, int);
 asmlinkage int sunos_killpg(int pgrp, int sig)
 {
-	return kill_pg(pgrp, sig, 0);
+	int ret;
+
+	rcu_read_lock();
+	ret = -EINVAL;
+	if (pgrp > 0)
+		ret = kill_pgrp(find_pid(pgrp), sig, 0);
+	rcu_read_unlock();
+
+	return ret;
 }
 
 asmlinkage int sunos_audit(void)
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

