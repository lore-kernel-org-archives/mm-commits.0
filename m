From: akpm@linux-foundation.org
Subject: + sysctl-fix-ax25-checks.patch added to -mm tree
Date: Mon, 17 Dec 2007 14:58:21 -0800
Message-ID: <200712172258.lBHMwLSm006154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41932 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757484AbXLQW64 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 17:58:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, davem@davemloft.net, pidoux@ccr.jussieu.fr, rjw@sisk.pl


The patch titled
     sysctl: fix ax25 checks
has been added to the -mm tree.  Its filename is
     sysctl-fix-ax25-checks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: fix ax25 checks
From: Eric W. Biederman <ebiederm@xmission.com>

Fix:

sysctl table check failed: /net/ax25/ax0/ax25_default_mode .3.9.1.2 Unknown
sysctl binary path
Pid: 2936, comm: kissattach Not tainted 2.6.24-rc5 #1
 [<c012ca6a>] set_fail+0x3b/0x43
 [<c012ce7a>] sysctl_check_table+0x408/0x456
 [<c012ce8e>] sysctl_check_table+0x41c/0x456
 [<c012ce8e>] sysctl_check_table+0x41c/0x456
 ...

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Bernard Pidoux <pidoux@ccr.jussieu.fr>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_check.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN kernel/sysctl_check.c~sysctl-fix-ax25-checks kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~sysctl-fix-ax25-checks
+++ a/kernel/sysctl_check.c
@@ -423,7 +423,7 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_net_ax25_table[] = {
+static struct trans_ctl_table trans_net_ax25_param_table[] = {
 	{ NET_AX25_IP_DEFAULT_MODE,	"ip_default_mode" },
 	{ NET_AX25_DEFAULT_MODE,	"ax25_default_mode" },
 	{ NET_AX25_BACKOFF_TYPE,	"backoff_type" },
@@ -441,6 +441,11 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
+static struct trans_ctl_table trans_net_ax25_table[] = {
+	{ 0, NULL, trans_net_ax25_param_table },
+	{}
+};
+
 static struct trans_ctl_table trans_net_bridge_table[] = {
 	{ NET_BRIDGE_NF_CALL_ARPTABLES,		"bridge-nf-call-arptables" },
 	{ NET_BRIDGE_NF_CALL_IPTABLES,		"bridge-nf-call-iptables" },
_

Patches currently in -mm which might be from ebiederm@xmission.com are

sysctl-fix-ax25-checks.patch
git-net.patch
quirk-enable-msi-mapping-on-ht1000.patch
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
