From: akpm@linux-foundation.org
Subject: + sysctl-properly-register-the-irda-binary-sysctl-numbers.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:22:20 -0700
Message-ID: <200708242222.l7OMMK5v017697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40705 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760151AbXHXWW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:22:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, samuel@sortiz.org


The patch titled
     sysctl: properly register the irda binary sysctl numbers
has been added to the -mm tree.  Its filename is
     sysctl-properly-register-the-irda-binary-sysctl-numbers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: properly register the irda binary sysctl numbers
From: Eric W. Biederman <ebiederm@xmission.com>

Grumble.  These numbers should have been in sysctl.h from the beginning if we
ever expected anyone to use them.  Oh well put them there now so we can find
them and make maintenance easier.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
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
