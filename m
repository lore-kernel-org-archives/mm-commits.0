From: akpm@osdl.org
Subject: + pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch added to -mm tree
Date: Wed, 13 Dec 2006 14:09:30 -0800
Message-ID: <200612132209.kBDM9Uvr021916@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48373 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbWLMWJe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:09:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk, oleg@tv-sign.ru


The patch titled
     pid: make session_of_pgrp use struct pid instead of pid_t
has been added to the -mm tree.  Its filename is
     pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid: make session_of_pgrp use struct pid instead of pid_t
From: Eric W. Biederman <ebiederm@xmission.com>

To properly implement a pid namespace I need to deal exclusively in terms of
struct pid, because pid_t values become ambiguous.

To this end session_of_pgrp is transformed to take and return a struct pid
pointer.  To avoid the need to worry about reference counting I now require my
caller to hold the appropriate locks.  Leaving callers repsonsible for
increasing the reference count if they need access to the result outside of
the locks.

Since session_of_pgrp currently only has one caller and that caller simply
uses only test the result for equality with another process group, the locking
change means I don't actually have to acquire the tasklist_lock at all.

tiocspgrp is also modified to take and release the lock.  The logic there is a
little more complicated but nothing I won't need when I convert pgrp of a tty
to a struct pid pointer.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/tty_io.c  |   24 +++++++++++++++++-------
 include/linux/kernel.h |    3 ++-
 kernel/exit.c          |   16 +++++++---------
 3 files changed, 26 insertions(+), 17 deletions(-)

diff -puN drivers/char/tty_io.c~pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t
+++ a/drivers/char/tty_io.c
@@ -2990,7 +2990,8 @@ static int tiocgpgrp(struct tty_struct *
 
 static int tiocspgrp(struct tty_struct *tty, struct tty_struct *real_tty, pid_t __user *p)
 {
-	pid_t pgrp;
+	struct pid *pgrp;
+	pid_t pgrp_nr;
 	int retval = tty_check_change(real_tty);
 
 	if (retval == -EIO)
@@ -3001,14 +3002,23 @@ static int tiocspgrp(struct tty_struct *
 	    (current->signal->tty != real_tty) ||
 	    (real_tty->session != process_session(current)))
 		return -ENOTTY;
-	if (get_user(pgrp, p))
+	if (get_user(pgrp_nr, p))
 		return -EFAULT;
-	if (pgrp < 0)
+	if (pgrp_nr < 0)
 		return -EINVAL;
-	if (session_of_pgrp(pgrp) != process_session(current))
-		return -EPERM;
-	real_tty->pgrp = pgrp;
-	return 0;
+	rcu_read_lock();
+	pgrp = find_pid(pgrp_nr);
+	retval = -ESRCH;
+	if (!pgrp)
+		goto out_unlock;
+	retval = -EPERM;
+	if (session_of_pgrp(pgrp) != task_session(current))
+		goto out_unlock;
+	retval = 0;
+	real_tty->pgrp = pgrp_nr;
+out_unlock:
+	rcu_read_unlock();
+	return retval;
 }
 
 /**
diff -puN include/linux/kernel.h~pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t include/linux/kernel.h
--- a/include/linux/kernel.h~pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t
+++ a/include/linux/kernel.h
@@ -136,7 +136,8 @@ extern unsigned long long memparse(char 
 extern int core_kernel_text(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
-extern int session_of_pgrp(int pgrp);
+struct pid;
+extern struct pid *session_of_pgrp(struct pid *pgrp);
 
 extern void dump_thread(struct pt_regs *regs, struct user *dump);
 
diff -puN kernel/exit.c~pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t kernel/exit.c
--- a/kernel/exit.c~pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t
+++ a/kernel/exit.c
@@ -185,21 +185,19 @@ repeat:
  * This checks not only the pgrp, but falls back on the pid if no
  * satisfactory pgrp is found. I dunno - gdb doesn't work correctly
  * without this...
+ *
+ * The caller must hold rcu lock or the tasklist lock.
  */
-int session_of_pgrp(int pgrp)
+struct pid *session_of_pgrp(struct pid *pgrp)
 {
 	struct task_struct *p;
-	int sid = 0;
-
-	read_lock(&tasklist_lock);
+	struct pid *sid = NULL;
 
-	p = find_task_by_pid_type(PIDTYPE_PGID, pgrp);
+	p = pid_task(pgrp, PIDTYPE_PGID);
 	if (p == NULL)
-		p = find_task_by_pid(pgrp);
+		p = pid_task(pgrp, PIDTYPE_PID);
 	if (p != NULL)
-		sid = process_session(p);
-
-	read_unlock(&tasklist_lock);
+		sid = task_session(p);
 
 	return sid;
 }
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

