From: akpm@linux-foundation.org
Subject: - sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:43 -0700
Message-ID: <200804300547.m3U5lhCL029730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760795AbYD3GMv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, adobriyan@sw.ru, davem@davemloft.net, den@openvz.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: merge equal proc_sys_read and proc_sys_write
has been removed from the -mm tree.  Its filename was
     sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: merge equal proc_sys_read and proc_sys_write
From: Pavel Emelyanov <xemul@openvz.org>

Many (most of) sysctls do not have a per-container sense.  E.g. 
kernel.print_fatal_signals, vm.panic_on_oom, net.core.netdev_budget and so on
and so forth.  Besides, tuning then from inside a container is not even
secure.  On the other hand, hiding them completely from the container's tasks
sometimes causes user-space to stop working.

When developing net sysctl, the common practice was to duplicate a table and
drop the write bits in table->mode, but this approach was not very elegant,
lead to excessive memory consumption and was not suitable in general.

Here's the alternative solution.  To facilitate the per-container sysctls
ctl_table_root-s were introduced.  Each root contains a list of
ctl_table_header-s that are visible to different namespaces.  The idea of this
set is to add the permissions() callback on the ctl_table_root to allow ctl
root limit permissions to the same ctl_table-s.

The main user of this functionality is the net-namespaces code, but later this
will (should) be used by more and more namespaces, containers and control
groups.

Actually, this idea's core is in a single hunk in the third patch.  First two
patches are cleanups for sysctl code, while the third one mostly extends the
arguments set of some sysctl functions.


This patch:


These ->read and ->write callbacks act in a very similar way, so merge these
paths to reduce the number of places to patch later and shrink the .text size
(a bit).

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Denis V. Lunev <den@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |   50 ++++++++--------------------------------
 1 file changed, 11 insertions(+), 39 deletions(-)

diff -puN fs/proc/proc_sysctl.c~sysctl-merge-equal-proc_sys_read-and-proc_sys_write fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~sysctl-merge-equal-proc_sys_read-and-proc_sys_write
+++ a/fs/proc/proc_sysctl.c
@@ -165,8 +165,8 @@ out:
 	return err;
 }
 
-static ssize_t proc_sys_read(struct file *filp, char __user *buf,
-				size_t count, loff_t *ppos)
+static ssize_t proc_sys_call_handler(struct file *filp, void __user *buf,
+		size_t count, loff_t *ppos, int write)
 {
 	struct dentry *dentry = filp->f_dentry;
 	struct ctl_table_header *head;
@@ -190,12 +190,12 @@ static ssize_t proc_sys_read(struct file
 	 * and won't be until we finish.
 	 */
 	error = -EPERM;
-	if (sysctl_perm(table, MAY_READ))
+	if (sysctl_perm(table, write ? MAY_WRITE : MAY_READ))
 		goto out;
 
 	/* careful: calling conventions are nasty here */
 	res = count;
-	error = table->proc_handler(table, 0, filp, buf, &res, ppos);
+	error = table->proc_handler(table, write, filp, buf, &res, ppos);
 	if (!error)
 		error = res;
 out:
@@ -204,44 +204,16 @@ out:
 	return error;
 }
 
-static ssize_t proc_sys_write(struct file *filp, const char __user *buf,
+static ssize_t proc_sys_read(struct file *filp, char __user *buf,
 				size_t count, loff_t *ppos)
 {
-	struct dentry *dentry = filp->f_dentry;
-	struct ctl_table_header *head;
-	struct ctl_table *table;
-	ssize_t error;
-	size_t res;
-
-	table = do_proc_sys_lookup(dentry->d_parent, &dentry->d_name, &head);
-	/* Has the sysctl entry disappeared on us? */
-	error = -ENOENT;
-	if (!table)
-		goto out;
-
-	/* Has the sysctl entry been replaced by a directory? */
-	error = -EISDIR;
-	if (!table->proc_handler)
-		goto out;
-
-	/*
-	 * At this point we know that the sysctl was not unregistered
-	 * and won't be until we finish.
-	 */
-	error = -EPERM;
-	if (sysctl_perm(table, MAY_WRITE))
-		goto out;
-
-	/* careful: calling conventions are nasty here */
-	res = count;
-	error = table->proc_handler(table, 1, filp, (char __user *)buf,
-				    &res, ppos);
-	if (!error)
-		error = res;
-out:
-	sysctl_head_finish(head);
+	return proc_sys_call_handler(filp, (void __user *)buf, count, ppos, 0);
+}
 
-	return error;
+static ssize_t proc_sys_write(struct file *filp, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	return proc_sys_call_handler(filp, (void __user *)buf, count, ppos, 1);
 }
 
 
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
disable-the-memory-controller-by-default-v3.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
ptrace-allow-to-ptrace-sbin-init.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
deprecate-find_task_by_pid-warning-fix.patch
pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch
pids-introduce-change_pid-helper.patch
pids-sys_setpgid-use-change_pid-helper.patch
pids-__set_special_pids-use-change_pid-helper.patch
pidns-make-pid-level-and-pid_ns-level-unsigned.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

