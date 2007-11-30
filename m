From: akpm@linux-foundation.org
Subject: + sysctl-remember-the-ctl_table-we-passed-to-register_sysctl_paths.patch added to -mm tree
Date: Thu, 29 Nov 2007 16:26:18 -0800
Message-ID: <200711300026.lAU0QIS6014916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762338AbXK3A1Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 19:27:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, clg@fr.ibm.com, davem@davemloft.net, dlezcano@fr.ibm.com, herbert@gondor.apana.org.au, serue@us.ibm.com, xemul@openvz.org


The patch titled
     sysctl: remember the ctl_table we passed to register_sysctl_paths
has been added to the -mm tree.  Its filename is
     sysctl-remember-the-ctl_table-we-passed-to-register_sysctl_paths.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: remember the ctl_table we passed to register_sysctl_paths
From: Eric W. Biederman <ebiederm@xmission.com>

By doing this we allow users of register_sysctl_paths that build and
dynamically allocate their ctl_table to be simpler.  This allows them to just
remember the ctl_table_header returned from register_sysctl_paths from which
they can now find the ctl_table array they need to free.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Daniel Lezcano <dlezcano@fr.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    1 +
 kernel/sysctl.c        |    1 +
 2 files changed, 2 insertions(+)

diff -puN include/linux/sysctl.h~sysctl-remember-the-ctl_table-we-passed-to-register_sysctl_paths include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-remember-the-ctl_table-we-passed-to-register_sysctl_paths
+++ a/include/linux/sysctl.h
@@ -1057,6 +1057,7 @@ struct ctl_table_header
 	struct list_head ctl_entry;
 	int used;
 	struct completion *unregistering;
+	struct ctl_table *ctl_table_arg;
 };
 
 /* struct ctl_path describes where in the hierarchy a table is added */
diff -puN kernel/sysctl.c~sysctl-remember-the-ctl_table-we-passed-to-register_sysctl_paths kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-remember-the-ctl_table-we-passed-to-register_sysctl_paths
+++ a/kernel/sysctl.c
@@ -1598,6 +1598,7 @@ struct ctl_table_header *register_sysctl
 		new += 2;
 	}
 	*prevp = table;
+	header->ctl_table_arg = table;
 
 	INIT_LIST_HEAD(&header->ctl_entry);
 	header->used = 0;
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
proc-fix-null-i_fop-oops.patch
proc-remove-races-from-proc_id_readdir.patch
the-namespaces-compatibility-list.patch
git-net.patch
sysctl-add-register_sysctl_paths-function.patch
sysctl-add-register_sysctl_paths-function-checkpatch-fixes.patch
sysctl-remember-the-ctl_table-we-passed-to-register_sysctl_paths.patch
sysctl-infrastructure-for-per-namespace-sysctls.patch
net-implement-the-per-network-namespace-sysctl-infrastructure.patch
quirk-enable-msi-mapping-on-ht1000.patch
quirk-enable-msi-mapping-on-ht1000-v2.patch
fix-proc-net-breakage.patch
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
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
sys_setpgid-simplify-pid-ns-interaction.patch
fix-setsid-for-sub-namespace-sbin-init.patch
teach-set_special_pids-to-use-struct-pid.patch
move-daemonized-kernel-threads-into-the-swappers-session.patch
start-the-global-sbin-init-with-00-special-pids.patch
