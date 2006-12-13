From: akpm@osdl.org
Subject: + pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch added to -mm tree
Date: Wed, 13 Dec 2006 14:09:39 -0800
Message-ID: <200612132209.kBDM9dZ0021935@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48397 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbWLMWJn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:09:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk, oleg@tv-sign.ru


The patch titled
     pid: replace do/while_each_task_pid with do/while_each_pid_task
has been added to the -mm tree.  Its filename is
     pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid: replace do/while_each_task_pid with do/while_each_pid_task
From: Eric W. Biederman <ebiederm@xmission.com>

There isn't any real advantage to this change except that it allows the old
functions to be removed.  Which is easier on maintenance and puts the code in
a more uniform style.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ioprio.c         |   18 ++++++++++++------
 kernel/capability.c |    8 +++++---
 kernel/sys.c        |   40 ++++++++++++++++++++++++----------------
 3 files changed, 41 insertions(+), 25 deletions(-)

diff -puN fs/ioprio.c~pid-replace-do-while_each_task_pid-with-do-while_each_pid_task fs/ioprio.c
--- a/fs/ioprio.c~pid-replace-do-while_each_task_pid-with-do-while_each_pid_task
+++ a/fs/ioprio.c
@@ -60,6 +60,7 @@ asmlinkage long sys_ioprio_set(int which
 	int data = IOPRIO_PRIO_DATA(ioprio);
 	struct task_struct *p, *g;
 	struct user_struct *user;
+	struct pid *pgrp;
 	int ret;
 
 	switch (class) {
@@ -98,12 +99,14 @@ asmlinkage long sys_ioprio_set(int which
 			break;
 		case IOPRIO_WHO_PGRP:
 			if (!who)
-				who = process_group(current);
-			do_each_task_pid(who, PIDTYPE_PGID, p) {
+				pgrp = task_pgrp(current);
+			else
+				pgrp = find_pid(who);
+			do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
 				ret = set_task_ioprio(p, ioprio);
 				if (ret)
 					break;
-			} while_each_task_pid(who, PIDTYPE_PGID, p);
+			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
 			break;
 		case IOPRIO_WHO_USER:
 			if (!who)
@@ -167,6 +170,7 @@ asmlinkage long sys_ioprio_get(int which
 {
 	struct task_struct *g, *p;
 	struct user_struct *user;
+	struct pid *pgrp;
 	int ret = -ESRCH;
 	int tmpio;
 
@@ -182,8 +186,10 @@ asmlinkage long sys_ioprio_get(int which
 			break;
 		case IOPRIO_WHO_PGRP:
 			if (!who)
-				who = process_group(current);
-			do_each_task_pid(who, PIDTYPE_PGID, p) {
+				pgrp = task_pgrp(current);
+			else
+				pgrp = find_pid(who);
+			do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
 				tmpio = get_task_ioprio(p);
 				if (tmpio < 0)
 					continue;
@@ -191,7 +197,7 @@ asmlinkage long sys_ioprio_get(int which
 					ret = tmpio;
 				else
 					ret = ioprio_best(ret, tmpio);
-			} while_each_task_pid(who, PIDTYPE_PGID, p);
+			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
 			break;
 		case IOPRIO_WHO_USER:
 			if (!who)
diff -puN kernel/capability.c~pid-replace-do-while_each_task_pid-with-do-while_each_pid_task kernel/capability.c
--- a/kernel/capability.c~pid-replace-do-while_each_task_pid-with-do-while_each_pid_task
+++ a/kernel/capability.c
@@ -92,15 +92,17 @@ out:
  * cap_set_pg - set capabilities for all processes in a given process
  * group.  We call this holding task_capability_lock and tasklist_lock.
  */
-static inline int cap_set_pg(int pgrp, kernel_cap_t *effective,
+static inline int cap_set_pg(int pgrp_nr, kernel_cap_t *effective,
 			      kernel_cap_t *inheritable,
 			      kernel_cap_t *permitted)
 {
 	struct task_struct *g, *target;
 	int ret = -EPERM;
 	int found = 0;
+	struct pid *pgrp;
 
-	do_each_task_pid(pgrp, PIDTYPE_PGID, g) {
+	pgrp = find_pid(pgrp_nr);
+	do_each_pid_task(pgrp, PIDTYPE_PGID, g) {
 		target = g;
 		while_each_thread(g, target) {
 			if (!security_capset_check(target, effective,
@@ -113,7 +115,7 @@ static inline int cap_set_pg(int pgrp, k
 			}
 			found = 1;
 		}
-	} while_each_task_pid(pgrp, PIDTYPE_PGID, g);
+	} while_each_pid_task(pgrp, PIDTYPE_PGID, g);
 
 	if (!found)
 	     ret = 0;
diff -puN kernel/sys.c~pid-replace-do-while_each_task_pid-with-do-while_each_pid_task kernel/sys.c
--- a/kernel/sys.c~pid-replace-do-while_each_task_pid-with-do-while_each_pid_task
+++ a/kernel/sys.c
@@ -589,6 +589,7 @@ asmlinkage long sys_setpriority(int whic
 	struct task_struct *g, *p;
 	struct user_struct *user;
 	int error = -EINVAL;
+	struct pid *pgrp;
 
 	if (which > 2 || which < 0)
 		goto out;
@@ -603,18 +604,21 @@ asmlinkage long sys_setpriority(int whic
 	read_lock(&tasklist_lock);
 	switch (which) {
 		case PRIO_PROCESS:
-			if (!who)
-				who = current->pid;
-			p = find_task_by_pid(who);
+			if (who)
+				p = find_task_by_pid(who);
+			else
+				p = current;
 			if (p)
 				error = set_one_prio(p, niceval, error);
 			break;
 		case PRIO_PGRP:
-			if (!who)
-				who = process_group(current);
-			do_each_task_pid(who, PIDTYPE_PGID, p) {
+			if (who)
+				pgrp = find_pid(who);
+			else
+				pgrp = task_pgrp(current);
+			do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
 				error = set_one_prio(p, niceval, error);
-			} while_each_task_pid(who, PIDTYPE_PGID, p);
+			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
 			user = current->user;
@@ -649,6 +653,7 @@ asmlinkage long sys_getpriority(int whic
 	struct task_struct *g, *p;
 	struct user_struct *user;
 	long niceval, retval = -ESRCH;
+	struct pid *pgrp;
 
 	if (which > 2 || which < 0)
 		return -EINVAL;
@@ -656,9 +661,10 @@ asmlinkage long sys_getpriority(int whic
 	read_lock(&tasklist_lock);
 	switch (which) {
 		case PRIO_PROCESS:
-			if (!who)
-				who = current->pid;
-			p = find_task_by_pid(who);
+			if (who)
+				p = find_task_by_pid(who);
+			else
+				p = current;
 			if (p) {
 				niceval = 20 - task_nice(p);
 				if (niceval > retval)
@@ -666,13 +672,15 @@ asmlinkage long sys_getpriority(int whic
 			}
 			break;
 		case PRIO_PGRP:
-			if (!who)
-				who = process_group(current);
-			do_each_task_pid(who, PIDTYPE_PGID, p) {
+			if (who)
+				pgrp = find_pid(who);
+			else
+				pgrp = task_pgrp(current);
+			do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
 				niceval = 20 - task_nice(p);
 				if (niceval > retval)
 					retval = niceval;
-			} while_each_task_pid(who, PIDTYPE_PGID, p);
+			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
 			user = current->user;
@@ -1381,7 +1389,7 @@ asmlinkage long sys_setpgid(pid_t pid, p
 
 	if (p->real_parent == group_leader) {
 		err = -EPERM;
-		if (process_session(p) != process_session(group_leader))
+		if (task_session(p) != task_session(group_leader))
 			goto out;
 		err = -EACCES;
 		if (p->did_exec)
@@ -1400,7 +1408,7 @@ asmlinkage long sys_setpgid(pid_t pid, p
 		struct task_struct *g =
 			find_task_by_pid_type(PIDTYPE_PGID, pgid);
 
-		if (!g || process_session(g) != process_session(group_leader))
+		if (!g || task_session(g) != task_session(group_leader))
 			goto out;
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

