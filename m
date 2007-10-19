From: akpm@linux-foundation.org
Subject: - sysctl-properly-register-the-irda-binary-sysctl-numbers.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:43:03 -0700
Message-ID: <200710190343.l9J3h3Pm012959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58759 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966505AbXJSD4B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, samuel@sortiz.org, mm-commits@vger.kernel.org


The patch titled
     sysctl: properly register the irda binary sysctl numbers
has been removed from the -mm tree.  Its filename was
     sysctl-properly-register-the-irda-binary-sysctl-numbers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: properly register the irda binary sysctl numbers
From: Eric W. Biederman <ebiederm@xmission.com>

Grumble.  These numbers should have been in sysctl.h from the beginning if we
ever expected anyone to use them.  Oh well put them there now so we can find
them and make maintenance easier.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |   20 ++++++++++++++++++++
 net/irda/irsysctl.c    |   34 ++++++++++++++--------------------
 2 files changed, 34 insertions(+), 20 deletions(-)

diff -puN include/linux/sysctl.h~sysctl-properly-register-the-irda-binary-sysctl-numbers include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-properly-register-the-irda-binary-sysctl-numbers
+++ a/include/linux/sysctl.h
@@ -238,6 +238,7 @@ enum
 	NET_LLC=18,
 	NET_NETFILTER=19,
 	NET_DCCP=20,
+	NET_IRDA=412,
 };
 
 /* /proc/sys/kernel/random */
@@ -795,6 +796,25 @@ enum {
 	NET_BRIDGE_NF_FILTER_PPPOE_TAGGED = 5,
 };
 
+/* proc/sys/net/irda */
+enum {
+	NET_IRDA_DISCOVERY=1,
+	NET_IRDA_DEVNAME=2,
+	NET_IRDA_DEBUG=3,
+	NET_IRDA_FAST_POLL=4,
+	NET_IRDA_DISCOVERY_SLOTS=5,
+	NET_IRDA_DISCOVERY_TIMEOUT=6,
+	NET_IRDA_SLOT_TIMEOUT=7,
+	NET_IRDA_MAX_BAUD_RATE=8,
+	NET_IRDA_MIN_TX_TURN_TIME=9,
+	NET_IRDA_MAX_TX_DATA_SIZE=10,
+	NET_IRDA_MAX_TX_WINDOW=11,
+	NET_IRDA_MAX_NOREPLY_TIME=12,
+	NET_IRDA_WARN_NOREPLY_TIME=13,
+	NET_IRDA_LAP_KEEPALIVE_TIME=14,
+};
+
+
 /* CTL_FS names: */
 enum
 {
diff -puN net/irda/irsysctl.c~sysctl-properly-register-the-irda-binary-sysctl-numbers net/irda/irsysctl.c
--- a/net/irda/irsysctl.c~sysctl-properly-register-the-irda-binary-sysctl-numbers
+++ a/net/irda/irsysctl.c
@@ -31,12 +31,6 @@
 #include <net/irda/irda.h>		/* irda_debug */
 #include <net/irda/irias_object.h>
 
-#define NET_IRDA 412 /* Random number */
-enum { DISCOVERY=1, DEVNAME, DEBUG, FAST_POLL, DISCOVERY_SLOTS,
-       DISCOVERY_TIMEOUT, SLOT_TIMEOUT, MAX_BAUD_RATE, MIN_TX_TURN_TIME,
-       MAX_TX_DATA_SIZE, MAX_TX_WINDOW, MAX_NOREPLY_TIME, WARN_NOREPLY_TIME,
-       LAP_KEEPALIVE_TIME };
-
 extern int  sysctl_discovery;
 extern int  sysctl_discovery_slots;
 extern int  sysctl_discovery_timeout;
@@ -94,7 +88,7 @@ static int do_devname(ctl_table *table, 
 /* One file */
 static ctl_table irda_table[] = {
 	{
-		.ctl_name	= DISCOVERY,
+		.ctl_name	= NET_IRDA_DISCOVERY,
 		.procname	= "discovery",
 		.data		= &sysctl_discovery,
 		.maxlen		= sizeof(int),
@@ -102,7 +96,7 @@ static ctl_table irda_table[] = {
 		.proc_handler	= &proc_dointvec
 	},
 	{
-		.ctl_name	= DEVNAME,
+		.ctl_name	= NET_IRDA_DEVNAME,
 		.procname	= "devname",
 		.data		= sysctl_devname,
 		.maxlen		= 65,
@@ -112,7 +106,7 @@ static ctl_table irda_table[] = {
 	},
 #ifdef CONFIG_IRDA_DEBUG
 	{
-		.ctl_name	= DEBUG,
+		.ctl_name	= NET_IRDA_DEBUG,
 		.procname	= "debug",
 		.data		= &irda_debug,
 		.maxlen		= sizeof(int),
@@ -122,7 +116,7 @@ static ctl_table irda_table[] = {
 #endif
 #ifdef CONFIG_IRDA_FAST_RR
 	{
-		.ctl_name	= FAST_POLL,
+		.ctl_name	= NET_IRDA_FAST_POLL,
 		.procname	= "fast_poll_increase",
 		.data		= &sysctl_fast_poll_increase,
 		.maxlen		= sizeof(int),
@@ -131,7 +125,7 @@ static ctl_table irda_table[] = {
 	},
 #endif
 	{
-		.ctl_name	= DISCOVERY_SLOTS,
+		.ctl_name	= NET_IRDA_DISCOVERY_SLOTS,
 		.procname	= "discovery_slots",
 		.data		= &sysctl_discovery_slots,
 		.maxlen		= sizeof(int),
@@ -142,7 +136,7 @@ static ctl_table irda_table[] = {
 		.extra2		= &max_discovery_slots
 	},
 	{
-		.ctl_name	= DISCOVERY_TIMEOUT,
+		.ctl_name	= NET_IRDA_DISCOVERY_TIMEOUT,
 		.procname	= "discovery_timeout",
 		.data		= &sysctl_discovery_timeout,
 		.maxlen		= sizeof(int),
@@ -150,7 +144,7 @@ static ctl_table irda_table[] = {
 		.proc_handler	= &proc_dointvec
 	},
 	{
-		.ctl_name	= SLOT_TIMEOUT,
+		.ctl_name	= NET_IRDA_SLOT_TIMEOUT,
 		.procname	= "slot_timeout",
 		.data		= &sysctl_slot_timeout,
 		.maxlen		= sizeof(int),
@@ -161,7 +155,7 @@ static ctl_table irda_table[] = {
 		.extra2		= &max_slot_timeout
 	},
 	{
-		.ctl_name	= MAX_BAUD_RATE,
+		.ctl_name	= NET_IRDA_MAX_BAUD_RATE,
 		.procname	= "max_baud_rate",
 		.data		= &sysctl_max_baud_rate,
 		.maxlen		= sizeof(int),
@@ -172,7 +166,7 @@ static ctl_table irda_table[] = {
 		.extra2		= &max_max_baud_rate
 	},
 	{
-		.ctl_name	= MIN_TX_TURN_TIME,
+		.ctl_name	= NET_IRDA_MIN_TX_TURN_TIME,
 		.procname	= "min_tx_turn_time",
 		.data		= &sysctl_min_tx_turn_time,
 		.maxlen		= sizeof(int),
@@ -183,7 +177,7 @@ static ctl_table irda_table[] = {
 		.extra2		= &max_min_tx_turn_time
 	},
 	{
-		.ctl_name	= MAX_TX_DATA_SIZE,
+		.ctl_name	= NET_IRDA_MAX_TX_DATA_SIZE,
 		.procname	= "max_tx_data_size",
 		.data		= &sysctl_max_tx_data_size,
 		.maxlen		= sizeof(int),
@@ -194,7 +188,7 @@ static ctl_table irda_table[] = {
 		.extra2		= &max_max_tx_data_size
 	},
 	{
-		.ctl_name	= MAX_TX_WINDOW,
+		.ctl_name	= NET_IRDA_MAX_TX_WINDOW,
 		.procname	= "max_tx_window",
 		.data		= &sysctl_max_tx_window,
 		.maxlen		= sizeof(int),
@@ -205,7 +199,7 @@ static ctl_table irda_table[] = {
 		.extra2		= &max_max_tx_window
 	},
 	{
-		.ctl_name	= MAX_NOREPLY_TIME,
+		.ctl_name	= NET_IRDA_MAX_NOREPLY_TIME,
 		.procname	= "max_noreply_time",
 		.data		= &sysctl_max_noreply_time,
 		.maxlen		= sizeof(int),
@@ -216,7 +210,7 @@ static ctl_table irda_table[] = {
 		.extra2		= &max_max_noreply_time
 	},
 	{
-		.ctl_name	= WARN_NOREPLY_TIME,
+		.ctl_name	= NET_IRDA_WARN_NOREPLY_TIME,
 		.procname	= "warn_noreply_time",
 		.data		= &sysctl_warn_noreply_time,
 		.maxlen		= sizeof(int),
@@ -227,7 +221,7 @@ static ctl_table irda_table[] = {
 		.extra2		= &max_warn_noreply_time
 	},
 	{
-		.ctl_name	= LAP_KEEPALIVE_TIME,
+		.ctl_name	= NET_IRDA_LAP_KEEPALIVE_TIME,
 		.procname	= "lap_keepalive_time",
 		.data		= &sysctl_lap_keepalive_time,
 		.maxlen		= sizeof(int),
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
update-boot-spec-to-207.patch
i386-paravirt-boot-sequence.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups-fix.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix-capabilityc-to-work-with-threaded-init.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch
make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-create-a-slab-cache-for-struct-pid_namespace.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
uninline-find_task_by_xxx-set-of-functions.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
isolate-some-explicit-usage-of-task-tgid.patch
uninline-find_pid-etc-set-of-functions.patch
uninline-the-task_xid_nr_ns-calls.patch
fix-cpusets-update_cpumask.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
virtualization-of-sysv-msg-queues-is-incomplete.patch
extended-crashkernel-command-line.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ia64-fix.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-sh.patch
add-documentation-for-extended-crashkernel-syntax.patch
kexec-add-bss-to-resource-tree.patch
kexec-introduce-bootmem_exclusive.patch
kexec-use-bootmem_exclusive-on-x86.patch
