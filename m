From: akpm@osdl.org
Subject: + tty-make-__proc_set_tty-static.patch added to -mm tree
Date: Wed, 13 Dec 2006 14:09:19 -0800
Message-ID: <200612132209.kBDM9JO1021899@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48386 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbWLMWJj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:09:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk, oleg@tv-sign.ru


The patch titled
     tty: make __proc_set_tty static
has been added to the -mm tree.  Its filename is
     tty-make-__proc_set_tty-static.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty: make __proc_set_tty static
From: Eric W. Biederman <ebiederm@xmission.com>

The aim of this patch set is to start wrapping up the struct pid conversions. 
As such this patchset culminates with the removal of kill_pg, kill_pg_info,
__kill_pg_info, do_each_task_pid, and while_each_task_pid.

kill_proc, daemonize, and kernel_thread are still in my sights but there is
still work to get to them.


The first three are basic cleanups around disassociate_ctty, while working on
converting it I found several issues.  tty_old_pgrp can be a tricky concept to
wrap your head around.

 1 tty: Make __proc_set_tty static.
 2 tty: Clarify disassociate_ctty
 3 tty: Fix the locking for signal->session in disassociate_ctty

These just stop using the old helper functions.

 4 signal: Use kill_pgrp not kill_pg in the sunos compatibility code.
 5 signal: Rewrite kill_something_info so it uses newer helpers.

Then the grind to convert the tty layer and all of it's helper functions to
struct pid.

 6 pid: Make session_of_pgrp use struct pid instead of pid_t.
 7 pid: Use struct pid for talking about process groups in exit.c
 8 pid: Replace is_orphaned_pgrp with is_current_pgrp_orphaned
 9 tty: Update the tty layer to work with struct pid.

A final helper function update.

10 pid: Replace do/while_each_task_pid with do/while_each_pid_task

And the removal of the functions that are now unused.
11 pid: Remove now unused do_each_task_pid and while_each_task_pid
12 pid: Remove the now unused kill_pg kill_pg_info and __kill_pg_info

All of these should be fairly simple and to the point.



This patch:

Currently all users of __proc_set_tty are in tty_io.c so make the function
static.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/tty_io.c |    3 ++-
 include/linux/tty.h   |    1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/tty_io.c~tty-make-__proc_set_tty-static drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-make-__proc_set_tty-static
+++ a/drivers/char/tty_io.c
@@ -155,6 +155,7 @@ int tty_ioctl(struct inode * inode, stru
 	      unsigned int cmd, unsigned long arg);
 static int tty_fasync(int fd, struct file * filp, int on);
 static void release_mem(struct tty_struct *tty, int idx);
+static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 
 /**
  *	alloc_tty_struct	-	allocate a tty object
@@ -3791,7 +3792,7 @@ void proc_clear_tty(struct task_struct *
 }
 EXPORT_SYMBOL(proc_clear_tty);
 
-void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
+static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 {
 	if (tty) {
 		tty->session = process_session(tsk);
diff -puN include/linux/tty.h~tty-make-__proc_set_tty-static include/linux/tty.h
--- a/include/linux/tty.h~tty-make-__proc_set_tty-static
+++ a/include/linux/tty.h
@@ -313,7 +313,6 @@ extern int tty_ioctl(struct inode *inode
 
 extern dev_t tty_devnum(struct tty_struct *tty);
 extern void proc_clear_tty(struct task_struct *p);
-extern void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 extern void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 extern struct tty_struct *get_current_tty(void);
 
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

