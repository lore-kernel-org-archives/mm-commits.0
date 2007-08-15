From: akpm@linux-foundation.org
Subject: + sysctl-parport-remove-binary-paths.patch added to -mm tree
Date: Wed, 15 Aug 2007 12:59:47 -0700
Message-ID: <200708151959.l7FJxlX9012466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40977 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936157AbXHOUAX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 16:00:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com


The patch titled
     sysctl: parport remove binary paths
has been added to the -mm tree.  Its filename is
     sysctl-parport-remove-binary-paths.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: parport remove binary paths
From: Eric W. Biederman <ebiederm@xmission.com>

The sysctl binary paths don't look as if they even code work, .data is not
filled in, and all of the proc_handlers look at extra1 and there is not
strategy routine.

So just kill the binary paths.

In addition this patch removes the setting of extra1 on directories.  It
doesn't look like the parport code ever examines it, and it's bad sysctl form.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/procfs.c |   38 ++++---------------------------------
 1 files changed, 5 insertions(+), 33 deletions(-)

diff -puN drivers/parport/procfs.c~sysctl-parport-remove-binary-paths drivers/parport/procfs.c
--- a/drivers/parport/procfs.c~sysctl-parport-remove-binary-paths
+++ a/drivers/parport/procfs.c
@@ -237,7 +237,7 @@ static int do_hardware_modes (ctl_table 
 #define PARPORT_PARPORT_DIR(CHILD) { .ctl_name = DEV_PARPORT, .procname = "parport", \
                                      .mode = 0555, .child = CHILD }
 #define PARPORT_DEV_DIR(CHILD) { .ctl_name = CTL_DEV, .procname = "dev", .mode = 0555, .child = CHILD }
-#define PARPORT_DEVICES_ROOT_DIR  { .ctl_name = DEV_PARPORT_DEVICES, .procname = "devices", \
+#define PARPORT_DEVICES_ROOT_DIR  {  .procname = "devices", \
                                     .mode = 0555, .child = NULL }
 
 static const unsigned long parport_min_timeslice_value =
@@ -266,7 +266,6 @@ static const struct parport_sysctl_table
 	.sysctl_header = NULL,
         {
 		{
-			.ctl_name	= DEV_PARPORT_SPINTIME,
 			.procname	= "spintime",
 			.data		= NULL,
 			.maxlen		= sizeof(int),
@@ -276,7 +275,6 @@ static const struct parport_sysctl_table
 			.extra2		= (void*) &parport_max_spintime_value
 		},
 		{
-			.ctl_name	= DEV_PARPORT_BASE_ADDR,
 			.procname	= "base-addr",
 			.data		= NULL,
 			.maxlen		= 0,
@@ -284,7 +282,6 @@ static const struct parport_sysctl_table
 			.proc_handler	= &do_hardware_base_addr
 		},
 		{
-			.ctl_name	= DEV_PARPORT_IRQ,
 			.procname	= "irq",
 			.data		= NULL,
 			.maxlen		= 0,
@@ -292,7 +289,6 @@ static const struct parport_sysctl_table
 			.proc_handler	= &do_hardware_irq
 		},
 		{
-			.ctl_name	= DEV_PARPORT_DMA,
 			.procname	= "dma",
 			.data		= NULL,
 			.maxlen		= 0,
@@ -300,7 +296,6 @@ static const struct parport_sysctl_table
 			.proc_handler	= &do_hardware_dma
 		},
 		{
-			.ctl_name	= DEV_PARPORT_MODES,
 			.procname	= "modes",
 			.data		= NULL,
 			.maxlen		= 0,
@@ -310,7 +305,6 @@ static const struct parport_sysctl_table
 		PARPORT_DEVICES_ROOT_DIR,
 #ifdef CONFIG_PARPORT_1284
 		{
-			.ctl_name	= DEV_PARPORT_AUTOPROBE,
 			.procname	= "autoprobe",
 			.data		= NULL,
 			.maxlen		= 0,
@@ -318,7 +312,6 @@ static const struct parport_sysctl_table
 			.proc_handler	= &do_autoprobe
 		},
 		{
-			.ctl_name	= DEV_PARPORT_AUTOPROBE + 1,
 			.procname	= "autoprobe0",
 			.data		= NULL,
 			.maxlen		= 0,
@@ -326,7 +319,6 @@ static const struct parport_sysctl_table
 			.proc_handler	=  &do_autoprobe
 		},
 		{
-			.ctl_name	= DEV_PARPORT_AUTOPROBE + 2,
 			.procname	= "autoprobe1",
 			.data		= NULL,
 			.maxlen		= 0,
@@ -334,7 +326,6 @@ static const struct parport_sysctl_table
 			.proc_handler	= &do_autoprobe
 		},
 		{
-			.ctl_name	= DEV_PARPORT_AUTOPROBE + 3,
 			.procname	= "autoprobe2",
 			.data		= NULL,
 			.maxlen		= 0,
@@ -342,7 +333,6 @@ static const struct parport_sysctl_table
 			.proc_handler	= &do_autoprobe
 		},
 		{
-			.ctl_name	= DEV_PARPORT_AUTOPROBE + 4,
 			.procname	= "autoprobe3",
 			.data		= NULL,
 			.maxlen		= 0,
@@ -354,7 +344,6 @@ static const struct parport_sysctl_table
 	},
 	{
 		{
-			.ctl_name	= DEV_PARPORT_DEVICES_ACTIVE,
 			.procname	= "active",
 			.data		= NULL,
 			.maxlen		= 0,
@@ -393,7 +382,6 @@ parport_device_sysctl_template = {
 	.sysctl_header = NULL,
 	{
 		{
-			.ctl_name 	= DEV_PARPORT_DEVICE_TIMESLICE,
 			.procname 	= "timeslice",
 			.data		= NULL,
 			.maxlen		= sizeof(int),
@@ -449,7 +437,6 @@ parport_default_sysctl_table = {
 	.sysctl_header	= NULL,
 	{
 		{
-			.ctl_name	= DEV_PARPORT_DEFAULT_TIMESLICE,
 			.procname	= "timeslice",
 			.data		= &parport_default_timeslice,
 			.maxlen		= sizeof(parport_default_timeslice),
@@ -459,7 +446,6 @@ parport_default_sysctl_table = {
 			.extra2		= (void*) &parport_max_timeslice_value
 		},
 		{
-			.ctl_name	= DEV_PARPORT_DEFAULT_SPINTIME,
 			.procname	= "spintime",
 			.data		= &parport_default_spintime,
 			.maxlen		= sizeof(parport_default_spintime),
@@ -502,7 +488,7 @@ int parport_proc_register(struct parport
 
 	t->device_dir[0].extra1 = port;
 
-	for (i = 0; i < 8; i++)
+	for (i = 0; i < 5; i++)
 		t->vars[i].extra1 = port;
 
 	t->vars[0].data = &port->spintime;
@@ -512,7 +498,7 @@ int parport_proc_register(struct parport
 		t->vars[6 + i].extra2 = &port->probe_info[i];
 
 	t->port_dir[0].procname = port->name;
-	t->port_dir[0].ctl_name = port->number + 1; /* nb 0 isn't legal here */
+	t->port_dir[0].ctl_name = 0;
 
 	t->port_dir[0].child = t->vars;
 	t->parport_dir[0].child = t->port_dir;
@@ -551,26 +537,12 @@ int parport_device_proc_register(struct 
 	t->dev_dir[0].child = t->parport_dir;
 	t->parport_dir[0].child = t->port_dir;
 	t->port_dir[0].procname = port->name;
-	t->port_dir[0].ctl_name = port->number + 1; /* nb 0 isn't legal here */
+	t->port_dir[0].ctl_name = 0;
 	t->port_dir[0].child = t->devices_root_dir;
 	t->devices_root_dir[0].child = t->device_dir;
 
-#ifdef CONFIG_PARPORT_1284
-
-	t->device_dir[0].ctl_name =
-		parport_device_num(port->number, port->muxport,
-				   device->daisy)
-		+ 1;  /* nb 0 isn't legal here */ 
-
-#else /* No IEEE 1284 support */
-
-	/* parport_device_num isn't available. */
-	t->device_dir[0].ctl_name = 1;
-	
-#endif /* IEEE 1284 support or not */
-
+	t->device_dir[0].ctl_name = 0;
 	t->device_dir[0].procname = device->name;
-	t->device_dir[0].extra1 = device;
 	t->device_dir[0].child = t->vars;
 	t->vars[0].data = &device->timeslice;
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

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
sysctl-clean-up-the-sched-debug-sysctl-usage.patch
sysctl-update-sysctl_checks-list-of-binary-paths.patch
sysctl-remove-the-cad_pid-binary-sysctl-path.patch
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
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
