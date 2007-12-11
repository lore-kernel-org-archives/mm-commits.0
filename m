From: akpm@linux-foundation.org
Subject: - proc-remove-fix-proc-generic-d_revalidate.patch removed from -mm tree
Date: Tue, 11 Dec 2007 14:42:10 -0800
Message-ID: <200712112242.lBBMgAqc012591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40604 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754736AbXLKWnk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 17:43:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, adobriyan@gmail.com, davem@davemloft.net, den@openvz.org, herbert@gondor.apana.org.au, rjw@sisk.pl, trond.myklebust@fys.uio.no, xemul@openvz.org, mm-commits@vge


The patch titled
     proc: remove/Fix proc generic d_revalidate
has been removed from the -mm tree.  Its filename was
     proc-remove-fix-proc-generic-d_revalidate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: proc: remove/Fix proc generic d_revalidate
From: Eric W. Biederman <ebiederm@xmission.com>

Ultimately to implement /proc perfectly we need an implementation of
d_revalidate because files and directories can be removed behind the back
of the VFS, and d_revalidate is the only way we can let the VFS know that
this has happened.

Unfortunately the linux VFS can not cope with anything in the path to a
mount point going away.  So a proper d_revalidate method that calls d_drop
also needs to call have_submounts which is moderately expensive, so you
really don't want a d_revalidate method that unconditionally calls it, but
instead only calls it when the backing object has really gone away.

proc generic entries only disappear on module_unload (when not counting the
fledgling network namespace) so it is quite rare that we actually encounter
that case and has not actually caused us real world trouble yet.

So until we get a proper test for keeping dentries in the dcache fix the
current d_revalidate method by completely removing it.  This returns us to
the current status quo.

So with CONFIG_NETNS=n things should look as they have always looked.

For CONFIG_NETNS=y things work most of the time but there are a few rare
corner cases that don't behave properly.  As the network namespace is
barely present in 2.6.24 this should not be a problem.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "Denis V. Lunev" <den@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN fs/proc/generic.c~proc-remove-fix-proc-generic-d_revalidate fs/proc/generic.c
--- a/fs/proc/generic.c~proc-remove-fix-proc-generic-d_revalidate
+++ a/fs/proc/generic.c
@@ -374,16 +374,9 @@ static int proc_delete_dentry(struct den
 	return 1;
 }
 
-static int proc_revalidate_dentry(struct dentry *dentry, struct nameidata *nd)
-{
-	d_drop(dentry);
-	return 0;
-}
-
 static struct dentry_operations proc_dentry_operations =
 {
 	.d_delete	= proc_delete_dentry,
-	.d_revalidate	= proc_revalidate_dentry,
 };
 
 /*
_

Patches currently in -mm which might be from ebiederm@xmission.com are

git-net.patch
quirk-enable-msi-mapping-on-ht1000.patch
quirk-enable-msi-mapping-on-ht1000-v2.patch
git-x86.patch
fix-proc-dcache-deadlock-in-do_exit.patch
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
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix-2.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
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
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
sys_setpgid-simplify-pid-ns-interaction.patch
fix-setsid-for-sub-namespace-sbin-init.patch
teach-set_special_pids-to-use-struct-pid.patch
move-daemonized-kernel-threads-into-the-swappers-session.patch
start-the-global-sbin-init-with-00-special-pids.patch
sys_setsid-remove-now-unneeded-session-=-1-check.patch
