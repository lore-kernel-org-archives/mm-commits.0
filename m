From: akpm@linux-foundation.org
Subject: + proc-fix-the-threaded-proc-self.patch added to -mm tree
Date: Mon, 26 Nov 2007 15:39:23 -0800
Message-ID: <200711262339.lAQNdNrw029057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55087 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901AbXKZXkb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 18:40:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, guichaz@yahoo.fr, mingo@elte.hu, oleg@tv-sign.ru, rjw@sisk.pl, roland@redhat.com, xemul@openvz.org


The patch titled
     proc: fix the threaded /proc/self
has been added to the -mm tree.  Its filename is
     proc-fix-the-threaded-proc-self.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proc: fix the threaded /proc/self
From: ebiederm@xmission.com (Eric W. Biederman)

Long ago when the CLONE_THREAD support first went it someone thought it
would be wise to point /proc/self at /proc/<tgid> instead of /proc/<pid>.

Given that /proc/<tgid> can return information about a very different task
(if enough things have been unshared) then our current process /proc/<tgid>
seems blatantly wrong.  So far I have yet to think up an example where the
current behavior would be advantageous, and I can see several places where
it is seriously non-intuitive.

We may be stuck with the current broken behavior for backwards
compatibility reasons but lets try fixing our ancient bug for the 2.6.25
time frame and see if anyone screams.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: "Guillaume Chazarain" <guichaz@yahoo.fr>
Cc: "Pavel Emelyanov" <xemul@openvz.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/proc/base.c~proc-fix-the-threaded-proc-self fs/proc/base.c
--- a/fs/proc/base.c~proc-fix-the-threaded-proc-self
+++ a/fs/proc/base.c
@@ -2003,22 +2003,22 @@ static int proc_self_readlink(struct den
 			      int buflen)
 {
 	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
-	pid_t tgid = task_tgid_nr_ns(current, ns);
+	pid_t pid = task_pid_nr_ns(current, ns);
 	char tmp[PROC_NUMBUF];
-	if (!tgid)
+	if (!pid)
 		return -ENOENT;
-	sprintf(tmp, "%d", tgid);
+	sprintf(tmp, "%d", pid);
 	return vfs_readlink(dentry,buffer,buflen,tmp);
 }
 
 static void *proc_self_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
-	pid_t tgid = task_tgid_nr_ns(current, ns);
+	pid_t pid = task_pid_nr_ns(current, ns);
 	char tmp[PROC_NUMBUF];
-	if (!tgid)
+	if (!pid)
 		return ERR_PTR(-ENOENT);
-	sprintf(tmp, "%d", task_tgid_nr_ns(current, ns));
+	sprintf(tmp, "%d", pid);
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
proc-seqfile-convert-proc_pid_statm.patch
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
