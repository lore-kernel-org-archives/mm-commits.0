From: akpm@linux-foundation.org
Subject: - sysctl-kill-binary-sysctl-kern_ppc_l2cr.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:50:18 -0800
Message-ID: <200801290150.m0T1oI7s027562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39257 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755691AbYA2B7R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:59:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, akpm@linux-foundation.org, benh@kernel.crashing.org, jwboyer@gmail.com, paulus@samba.org, sr@denx.de, wd@denx.de, mm-commits@vger.kernel.org


The patch titled
     sysctl: kill binary sysctl KERN_PPC_L2CR
has been removed from the -mm tree.  Its filename was
     sysctl-kill-binary-sysctl-kern_ppc_l2cr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: kill binary sysctl KERN_PPC_L2CR
From: Eric W. Biederman <ebiederm@xmission.com>

: Stefan Roese <sr@denx.de> said:
> ppc: 4xx: sysctl table check failed: /kernel/l2cr .1.31 Missing strategy
>
> I'm seeing this error message when booting an recent arch/ppc kernel on
> 4xx platforms (tested on Ocotea and other 4xx platforms). Booting NFS
> rootfs still works fine, but this message kind of makes me "nervous".
> This is not seen on 4xx arch/powerpc platforms. Here the bootlog:

Because the data field was never filled and a binary sysctl handler was
never written this sysctl has never been usable through the sys_sysctl
interface.  So just remove the binary sysctl number.  Making the kernel
sanity checks happy.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Reported-by: Stefan Roese <sr@denx.de>
Cc: Josh Boyer <jwboyer@gmail.com>
Cc: Wolfgang Denk <wd@denx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ppc/kernel/ppc_htab.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/ppc/kernel/ppc_htab.c~sysctl-kill-binary-sysctl-kern_ppc_l2cr arch/ppc/kernel/ppc_htab.c
--- a/arch/ppc/kernel/ppc_htab.c~sysctl-kill-binary-sysctl-kern_ppc_l2cr
+++ a/arch/ppc/kernel/ppc_htab.c
@@ -436,7 +436,6 @@ int proc_dol2crvec(ctl_table *table, int
  */
 static ctl_table htab_ctl_table[]={
 	{
-		.ctl_name	= KERN_PPC_L2CR,
 		.procname	= "l2cr",
 		.mode		= 0644,
 		.proc_handler	= &proc_dol2crvec,
_

Patches currently in -mm which might be from ebiederm@xmission.com are

git-net.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform-checkpatch-fixes.patch
git-x86.patch
fix-proc-dcache-deadlock-in-do_exit.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
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
proc-fix-openless-usage-due-to-proc_fops-flip.patch
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
pid-namespaces-vs-locks-interaction.patch
sys_setpgid-simplify-pid-ns-interaction.patch
fix-setsid-for-sub-namespace-sbin-init.patch
teach-set_special_pids-to-use-struct-pid.patch
move-daemonized-kernel-threads-into-the-swappers-session.patch
start-the-global-sbin-init-with-00-special-pids.patch
sys_setsid-remove-now-unneeded-session-=-1-check.patch
pid-sys_wait-fixes-v2.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
pid-extend-fix-pid_vnr.patch
sys_getsid-dont-use-nsproxy-directly.patch
pid-fix-mips-irix-emulation-pid-usage.patch
pid-fix-mips-irix-emulation-pid-usage-fix.patch
pid-fix-solaris_procids.patch
uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch
uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch
itimer_real-convert-to-use-struct-pid.patch
constify-tables-in-kernel-sysctl_checkc.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
fix-procfs-task-exe-symlink.patch
