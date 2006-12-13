From: akpm@osdl.org
Subject: + pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch added to -mm tree
Date: Wed, 13 Dec 2006 14:09:34 -0800
Message-ID: <200612132209.kBDM9YiJ021922@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48409 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbWLMWJt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:09:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk, oleg@tv-sign.ru


The patch titled
     pid: replace is_orphaned_pgrp with is_current_pgrp_orphaned
has been added to the -mm tree.  Its filename is
     pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid: replace is_orphaned_pgrp with is_current_pgrp_orphaned
From: Eric W. Biederman <ebiederm@xmission.com>

Every call to is_orphaned_pgrp passed in process_group(current) which is racy
with respect to another thread changing our process group.  It didn't bite us
because we were dealing with integers and the worse we would get would be a
stale answer.

In switching the checks to use struct pid to be a little more efficient and
prepare the way for pid namespaces this race became apparent.

So I simplified the calls to the more specialized is_current_pgrp_orphaned so
I didn't have to worry about making logic changes to avoid the race.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/n_tty.c  |    2 +-
 drivers/char/tty_io.c |    2 +-
 include/linux/tty.h   |    2 +-
 kernel/exit.c         |    4 ++--
 kernel/signal.c       |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/char/n_tty.c~pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned
+++ a/drivers/char/n_tty.c
@@ -1188,7 +1188,7 @@ static int job_control(struct tty_struct
 			printk("read_chan: tty->pgrp <= 0!\n");
 		else if (process_group(current) != tty->pgrp) {
 			if (is_ignored(SIGTTIN) ||
-			    is_orphaned_pgrp(process_group(current)))
+			    is_current_pgrp_orphaned())
 				return -EIO;
 			kill_pg(process_group(current), SIGTTIN, 1);
 			return -ERESTARTSYS;
diff -puN drivers/char/tty_io.c~pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned
+++ a/drivers/char/tty_io.c
@@ -1118,7 +1118,7 @@ int tty_check_change(struct tty_struct *
 		return 0;
 	if (is_ignored(SIGTTOU))
 		return 0;
-	if (is_orphaned_pgrp(process_group(current)))
+	if (is_current_pgrp_orphaned())
 		return -EIO;
 	(void) kill_pg(process_group(current), SIGTTOU, 1);
 	return -ERESTARTSYS;
diff -puN include/linux/tty.h~pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned include/linux/tty.h
--- a/include/linux/tty.h~pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned
+++ a/include/linux/tty.h
@@ -283,7 +283,7 @@ extern int tty_read_raw_data(struct tty_
 			     int buflen);
 extern void tty_write_message(struct tty_struct *tty, char *msg);
 
-extern int is_orphaned_pgrp(int pgrp);
+extern int is_current_pgrp_orphaned(void);
 extern int is_ignored(int sig);
 extern int tty_signal(int sig, struct tty_struct *tty);
 extern void tty_hangup(struct tty_struct * tty);
diff -puN kernel/exit.c~pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned kernel/exit.c
--- a/kernel/exit.c~pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned
+++ a/kernel/exit.c
@@ -229,12 +229,12 @@ static int will_become_orphaned_pgrp(str
 	return ret;	/* (sighing) "Often!" */
 }
 
-int is_orphaned_pgrp(int pgrp)
+int is_current_pgrp_orphaned(void)
 {
 	int retval;
 
 	read_lock(&tasklist_lock);
-	retval = will_become_orphaned_pgrp(find_pid(pgrp), NULL);
+	retval = will_become_orphaned_pgrp(task_pgrp(current), NULL);
 	read_unlock(&tasklist_lock);
 
 	return retval;
diff -puN kernel/signal.c~pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned kernel/signal.c
--- a/kernel/signal.c~pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned
+++ a/kernel/signal.c
@@ -1910,7 +1910,7 @@ relock:
 
 				/* signals can be posted during this window */
 
-				if (is_orphaned_pgrp(process_group(current)))
+				if (is_current_pgrp_orphaned())
 					goto relock;
 
 				spin_lock_irq(&current->sighand->siglock);
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

