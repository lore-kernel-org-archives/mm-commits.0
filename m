From: akpm@osdl.org
Subject: + signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch added to -mm tree
Date: Wed, 13 Dec 2006 14:09:28 -0800
Message-ID: <200612132209.kBDM9S2N021913@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48361 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbWLMWJb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:09:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk, oleg@tv-sign.ru


The patch titled
     signal: rewrite kill_something_info so it uses newer helpers
has been added to the -mm tree.  Its filename is
     signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: signal: rewrite kill_something_info so it uses newer helpers
From: Eric W. Biederman <ebiederm@xmission.com>

The goal is to remove users of the old signal helper functions so they can be
removed.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/signal.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff -puN kernel/signal.c~signal-rewrite-kill_something_info-so-it-uses-newer-helpers kernel/signal.c
--- a/kernel/signal.c~signal-rewrite-kill_something_info-so-it-uses-newer-helpers
+++ a/kernel/signal.c
@@ -1192,8 +1192,10 @@ EXPORT_SYMBOL_GPL(kill_pid_info_as_uid);
 
 static int kill_something_info(int sig, struct siginfo *info, int pid)
 {
+	int ret;
+	rcu_read_lock();
 	if (!pid) {
-		return kill_pg_info(sig, info, process_group(current));
+		ret = kill_pgrp_info(sig, info, task_pgrp(current));
 	} else if (pid == -1) {
 		int retval = 0, count = 0;
 		struct task_struct * p;
@@ -1208,12 +1210,14 @@ static int kill_something_info(int sig, 
 			}
 		}
 		read_unlock(&tasklist_lock);
-		return count ? retval : -ESRCH;
+		ret = count ? retval : -ESRCH;
 	} else if (pid < 0) {
-		return kill_pg_info(sig, info, -pid);
+		ret = kill_pgrp_info(sig, info, find_pid(-pid));
 	} else {
-		return kill_proc_info(sig, info, pid);
+		ret = kill_pid_info(sig, info, find_pid(pid));
 	}
+	rcu_read_unlock();
+	return ret;
 }
 
 /*
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

