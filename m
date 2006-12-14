From: akpm@osdl.org
Subject: - vt-fix-comments-to-not-refer-to-kill_proc.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:03:04 -0800
Message-ID: <200612140603.kBE634Jx001766@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51625 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbWLNGDP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:03:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     vt: fix comments to not refer to kill_proc
has been removed from the -mm tree.  Its filename was
     vt-fix-comments-to-not-refer-to-kill_proc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vt: fix comments to not refer to kill_proc
From: Eric W. Biederman <ebiederm@xmission.com>

The code has been fixed to use kill_pid instead of kill_proc fix the
comments as well.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/vt_ioctl.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/char/vt_ioctl.c~vt-fix-comments-to-not-refer-to-kill_proc drivers/char/vt_ioctl.c
--- a/drivers/char/vt_ioctl.c~vt-fix-comments-to-not-refer-to-kill_proc
+++ a/drivers/char/vt_ioctl.c
@@ -1087,7 +1087,7 @@ static void complete_change_console(stru
 	switch_screen(vc);
 
 	/*
-	 * This can't appear below a successful kill_proc().  If it did,
+	 * This can't appear below a successful kill_pid().  If it did,
 	 * then the *blank_screen operation could occur while X, having
 	 * received acqsig, is waking up on another processor.  This
 	 * condition can lead to overlapping accesses to the VGA range
@@ -1110,7 +1110,7 @@ static void complete_change_console(stru
 	 */
 	if (vc->vt_mode.mode == VT_PROCESS) {
 		/*
-		 * Send the signal as privileged - kill_proc() will
+		 * Send the signal as privileged - kill_pid() will
 		 * tell us if the process has gone or something else
 		 * is awry
 		 */
@@ -1170,7 +1170,7 @@ void change_console(struct vc_data *new_
 	vc = vc_cons[fg_console].d;
 	if (vc->vt_mode.mode == VT_PROCESS) {
 		/*
-		 * Send the signal as privileged - kill_proc() will
+		 * Send the signal as privileged - kill_pid() will
 		 * tell us if the process has gone or something else
 		 * is awry
 		 */
_

Patches currently in -mm which might be from ebiederm@xmission.com are

kthread-api-conversion-for-dvb_frontend-and-av7110.patch
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
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
pidhash-temporary-debug-checks.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

