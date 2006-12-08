From: akpm@osdl.org
Subject: - add-process_session-helper-routine-deprecate-old-field-fix-warnings.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:52:20 -0800
Message-ID: <200612080852.kB88qKXs013991@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37287 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425210AbWLHIwc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:52:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, clg@fr.ibm.com, mm-commits@vger.kernel.org


The patch titled
     add-process_session-helper-routine-deprecate-old-field-fix-warnings
has been removed from the -mm tree.  Its filename was
     add-process_session-helper-routine-deprecate-old-field-fix-warnings.patch

This patch was dropped because it was folded into add-process_session-helper-routine-deprecate-old-field.patch

------------------------------------------------------
Subject: add-process_session-helper-routine-deprecate-old-field-fix-warnings
From: Andrew Morton <akpm@osdl.org>

Cc: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/array.c       |    2 +-
 include/linux/sched.h |   12 +++++++++++-
 kernel/exit.c         |    2 +-
 kernel/fork.c         |    2 +-
 4 files changed, 14 insertions(+), 4 deletions(-)

diff -puN fs/proc/array.c~add-process_session-helper-routine-deprecate-old-field-fix-warnings fs/proc/array.c
--- a/fs/proc/array.c~add-process_session-helper-routine-deprecate-old-field-fix-warnings
+++ a/fs/proc/array.c
@@ -381,7 +381,7 @@ static int do_task_stat(struct task_stru
 			stime = cputime_add(stime, sig->stime);
 		}
 
-		sid = sig->session;
+		signal_session(sig);
 		pgid = process_group(task);
 		ppid = rcu_dereference(task->real_parent)->tgid;
 
diff -puN include/linux/sched.h~add-process_session-helper-routine-deprecate-old-field-fix-warnings include/linux/sched.h
--- a/include/linux/sched.h~add-process_session-helper-routine-deprecate-old-field-fix-warnings
+++ a/include/linux/sched.h
@@ -1051,9 +1051,19 @@ static inline pid_t process_group(struct
 	return tsk->signal->pgrp;
 }
 
+static inline pid_t signal_session(struct signal_struct *sig)
+{
+	return sig->__session;
+}
+
 static inline pid_t process_session(struct task_struct *tsk)
 {
-	return tsk->signal->__session;
+	return signal_session(tsk->signal);
+}
+
+static inline void set_signal_session(struct signal_struct *sig, pid_t session)
+{
+	sig->__session = session;
 }
 
 static inline struct pid *task_pid(struct task_struct *task)
diff -puN kernel/exit.c~add-process_session-helper-routine-deprecate-old-field-fix-warnings kernel/exit.c
--- a/kernel/exit.c~add-process_session-helper-routine-deprecate-old-field-fix-warnings
+++ a/kernel/exit.c
@@ -304,7 +304,7 @@ void __set_special_pids(pid_t session, p
 
 	if (process_session(curr) != session) {
 		detach_pid(curr, PIDTYPE_SID);
-		curr->signal->session = session;
+		set_signal_session(curr->signal, session);
 		attach_pid(curr, PIDTYPE_SID, session);
 	}
 	if (process_group(curr) != pgrp) {
diff -puN kernel/fork.c~add-process_session-helper-routine-deprecate-old-field-fix-warnings kernel/fork.c
--- a/kernel/fork.c~add-process_session-helper-routine-deprecate-old-field-fix-warnings
+++ a/kernel/fork.c
@@ -1261,7 +1261,7 @@ static struct task_struct *copy_process(
 		if (thread_group_leader(p)) {
 			p->signal->tty = current->signal->tty;
 			p->signal->pgrp = process_group(current);
-			p->signal->session = process_session(current);
+			set_signal_session(p->signal, process_session(current));
 			attach_pid(p, PIDTYPE_PGID, process_group(p));
 			attach_pid(p, PIDTYPE_SID, process_session(p));
 
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
tty-signal-tty-locking.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
add-process_session-helper-routine-deprecate-old-field.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings-2.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework-warning-fix.patch
tty-switch-to-ktermios-and-new-framework-irda-fix.patch
tty-switch-to-ktermios-bluetooth-fix.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
fault-injection-capabilities-infrastructure-tidy.patch
fault-injection-capabilities-infrastructure-tweaks.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs-fix.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch

