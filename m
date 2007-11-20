From: akpm@linux-foundation.org
Subject: + proc-proper-pidns-handling-for-proc-self.patch added to -mm tree
Date: Mon, 19 Nov 2007 17:00:48 -0800
Message-ID: <200711200100.lAK10mtP005587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56013 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752367AbXKTBAx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 20:00:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, adobriyan@gmail.com, oleg@tv-sign.ru, xemul@openvz.org


The patch titled
     proc: proper pidns handling for /proc/self
has been added to the -mm tree.  Its filename is
     proc-proper-pidns-handling-for-proc-self.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proc: proper pidns handling for /proc/self
From: Eric W. Biederman <ebiederm@xmission.com>

Currently if you access a /proc that is not mounted with your processes
current pid namespace /proc/self will point at a completely

This patch fixes /proc/self to point to the current process if it is
available in the particular mount of /proc or to return -ENOENT if the
current process is not visible.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~proc-proper-pidns-handling-for-proc-self fs/proc/base.c
--- a/fs/proc/base.c~proc-proper-pidns-handling-for-proc-self
+++ a/fs/proc/base.c
@@ -2002,15 +2002,23 @@ static const struct file_operations proc
 static int proc_self_readlink(struct dentry *dentry, char __user *buffer,
 			      int buflen)
 {
+	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
+	pid_t tgid = task_tgid_nr_ns(current, ns);
 	char tmp[PROC_NUMBUF];
-	sprintf(tmp, "%d", task_tgid_vnr(current));
+	if (!tgid)
+		return -ENOENT;
+	sprintf(tmp, "%d", tgid);
 	return vfs_readlink(dentry,buffer,buflen,tmp);
 }
 
 static void *proc_self_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
+	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
+	pid_t tgid = task_tgid_nr_ns(current, ns);
 	char tmp[PROC_NUMBUF];
-	sprintf(tmp, "%d", task_tgid_vnr(current));
+	if (!tgid)
+		return ERR_PTR(-ENOENT);
+	sprintf(tmp, "%d", task_tgid_nr_ns(current, ns));
 	return ERR_PTR(vfs_follow_link(nd,tmp));
 }
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

proc-fix-null-i_fop-oops.patch
proc-remove-races-from-proc_id_readdir.patch
git-s390.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
introduce-flags-for-reserve_bootmem.patch
use-bootmem_exclusive-for-kdump.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
mark-net_ns-with-depends-on-namespaces.patch
proc-implement-proc_single_file_operations.patch
proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_statm.patch
proc-proper-pidns-handling-for-proc-self.patch
