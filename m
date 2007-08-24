From: akpm@linux-foundation.org
Subject: + sysctl-for-irda-update-sysctl_checks-list-of-binary-paths.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:22:22 -0700
Message-ID: <200708242222.l7OMMMDF017700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37281 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760764AbXHXWW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:22:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, samuel@sortiz.org


The patch titled
     sysctl: for irda update sysctl_checks list of binary paths
has been added to the -mm tree.  Its filename is
     sysctl-for-irda-update-sysctl_checks-list-of-binary-paths.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: for irda update sysctl_checks list of binary paths
From: Eric W. Biederman <ebiederm@xmission.com>

It turns out that the net/irda code didn't register any of it's binary paths
in the global sysctl.h header file so I missed them completely when making an
authoritative list of binary sysctl paths in the kernel.  So add them to the
list of valid binary sysctl paths.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_check.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+)

diff -puN kernel/sysctl_check.c~sysctl-for-irda-update-sysctl_checks-list-of-binary-paths kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~sysctl-for-irda-update-sysctl_checks-list-of-binary-paths
+++ a/kernel/sysctl_check.c
@@ -703,6 +703,24 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
+static struct trans_ctl_table trans_net_irda_table[] = {
+	{ NET_IRDA_DISCOVERY,		"discovery" },
+	{ NET_IRDA_DEVNAME,		"devname" },
+	{ NET_IRDA_DEBUG,		"debug" },
+	{ NET_IRDA_FAST_POLL,		"fast_poll_increase" },
+	{ NET_IRDA_DISCOVERY_SLOTS,	"discovery_slots" },
+	{ NET_IRDA_DISCOVERY_TIMEOUT,	"discovery_timeout" },
+	{ NET_IRDA_SLOT_TIMEOUT,	"slot_timeout" },
+	{ NET_IRDA_MAX_BAUD_RATE,	"max_baud_rate" },
+	{ NET_IRDA_MIN_TX_TURN_TIME,	"min_tx_turn_time" },
+	{ NET_IRDA_MAX_TX_DATA_SIZE,	"max_tx_data_size" },
+	{ NET_IRDA_MAX_TX_WINDOW,	"max_tx_window" },
+	{ NET_IRDA_MAX_NOREPLY_TIME,	"max_noreply_time" },
+	{ NET_IRDA_WARN_NOREPLY_TIME,	"warn_noreply_time" },
+	{ NET_IRDA_LAP_KEEPALIVE_TIME,	"lap_keepalive_time" },
+	{}
+};
+
 static struct trans_ctl_table trans_net_table[] = {
 	{ NET_CORE,		"core",		trans_net_core_table },
 	/* NET_ETHER not used */
@@ -724,6 +742,7 @@ static struct trans_ctl_table trans_net_
 	{ NET_LLC,		"llc",		trans_net_llc_table },
 	{ NET_NETFILTER,	"netfilter",	trans_net_netfilter_table },
 	{ NET_DCCP,		"dccp",		trans_net_dccp_table },
+	{ NET_IRDA,		"irda",		trans_net_irda_table },
 	{ 2089,			"nf_conntrack_max" },
 	{}
 };
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
dvb_en_50221-convert-to-kthread-api.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
handle-the-multi-threaded-inits-exit-properly.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
sysctl-update-sysctl_check_table.patch
sysct-mqueue-remove-the-binary-sysctl-numbers.patch
sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
sysctl-remove-broken-cdrom-binary-sysctls-update.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
sysctl-parport-remove-binary-paths.patch
sysctl-simplify-the-pty-sysctl-logic.patch
sysctl-remove-broken-netfilter-binary-sysctls.patch
sysctl-update-sysctl_checks-list-of-binary-paths.patch
sysctl-remove-the-cad_pid-binary-sysctl-path.patch
sysctl-properly-register-the-irda-binary-sysctl-numbers.patch
sysctl-for-irda-update-sysctl_checks-list-of-binary-paths.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
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
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
isolate-some-explicit-usage-of-task-tgid.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
