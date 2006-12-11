From: akpm@osdl.org
Subject: + vt-fix-comments-to-not-refer-to-kill_proc.patch added to -mm tree
Date: Mon, 11 Dec 2006 12:42:08 -0800
Message-ID: <200612112042.kBBKg8sG006727@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34903 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937501AbWLKUmL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 15:42:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com


The patch titled
     vt: fix comments to not refer to kill_proc
has been added to the -mm tree.  Its filename is
     vt-fix-comments-to-not-refer-to-kill_proc.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vt: fix comments to not refer to kill_proc
From: Eric W. Biederman <ebiederm@xmission.com>

The code has been fixed to use kill_pid instead of kill_proc fix the
comments as well.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/vt_ioctl.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

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

origin.patch
revert-identifier-to-nsproxy.patch
vt-fix-comments-to-not-refer-to-kill_proc.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
updated-i386-cleanup-apic-code.patch
updated-i386-rework-local-apic-calibration.patch
updated-dynticks-fix-nmi-watchdog.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
pidhash-temporary-debug-checks.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

