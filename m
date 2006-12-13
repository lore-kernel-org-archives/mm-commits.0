From: akpm@osdl.org
Subject: + 9p-use-kthread_stop-instead-of-sending-a-sigkill.patch added to -mm tree
Date: Tue, 12 Dec 2006 17:20:31 -0800
Message-ID: <200612130120.kBD1KV2j023739@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37290 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420AbWLMBVJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 20:21:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, ericvh@gmail.com, lucho@ionkov.net, rminnich@lanl.gov


The patch titled
     9p: Use kthread_stop instead of sending a SIGKILL
has been added to the -mm tree.  Its filename is
     9p-use-kthread_stop-instead-of-sending-a-sigkill.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 9p: Use kthread_stop instead of sending a SIGKILL
From: Eric W. Biederman <ebiederm@xmission.com>

Since the kthread api does not bump the reference count on processes that
tracked it is not safe allow user space to kill the threads, as I still
retain a pointer to the task_struct.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@lanl.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/9p/mux.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/9p/mux.c~9p-use-kthread_stop-instead-of-sending-a-sigkill fs/9p/mux.c
--- a/fs/9p/mux.c~9p-use-kthread_stop-instead-of-sending-a-sigkill
+++ a/fs/9p/mux.c
@@ -254,7 +254,7 @@ static void v9fs_mux_poll_stop(struct v9
 	vpt->muxnum--;
 	if (!vpt->muxnum) {
 		dprintk(DEBUG_MUX, "destroy proc %p\n", vpt);
-		send_sig(SIGKILL, vpt->task, 1);
+		kthread_stop(vpt->task);
 		vpt->task = NULL;
 		v9fs_mux_poll_task_num--;
 	}
@@ -436,11 +436,8 @@ static int v9fs_poll_proc(void *a)
 
 	vpt = a;
 	dprintk(DEBUG_MUX, "start %p %p\n", current, vpt);
-	allow_signal(SIGKILL);
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		if (signal_pending(current))
-			break;
 
 		list_for_each_entry_safe(m, mtmp, &vpt->mux_list, mux_list) {
 			v9fs_poll_mux(m);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
revert-identifier-to-nsproxy.patch
vt-fix-comments-to-not-refer-to-kill_proc.patch
usbatm-update-to-use-the-kthread-api.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
n_r3964-use-struct-pid-to-track-user-space-clients.patch
smbfs-make-conn_pid-a-struct-pid.patch
ncpfs-use-struct-pid-to-track-the-userspace-watchdog-process.patch
ncpfs-ensure-we-free-wdog_pid-on-parse_option-or-fill_inode-failure.patch
vt-refactor-console-sak-processing.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
updated-i386-cleanup-apic-code.patch
updated-i386-rework-local-apic-calibration.patch
updated-dynticks-fix-nmi-watchdog.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
pidhash-temporary-debug-checks.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

