From: akpm@linux-foundation.org
Subject: + sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch added to -mm tree
Date: Thu, 28 Feb 2008 12:36:03 -0800
Message-ID: <200802282036.m1SKa3Gl019198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932566AbYB1Ug7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 15:36:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, adobriyan@sw.ru, davem@davemloft.net, den@openvz.org, ebiederm@xmission.com


The patch titled
     sysctl: merge equal proc_sys_read and proc_sys_write
has been added to the -mm tree.  Its filename is
     sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

control-groups-add-paul-menage-a-maintainer.patch
add-balbir-as-the-maintainer-for-memory-resource-controller.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
udf-fix-anchor-point-detection.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
pidns-make-pid-level-and-pid_ns-level-unsigned.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

