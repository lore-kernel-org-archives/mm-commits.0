From: akpm@linux-foundation.org
Subject: - sysctl-parport-remove-binary-paths.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:42:54 -0700
Message-ID: <200710190342.l9J3gsZW012938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57919 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934254AbXJSD4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sysctl: parport remove binary paths
has been removed from the -mm tree.  Its filename was
     sysctl-parport-remove-binary-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: parport remove binary paths
From: Eric W. Biederman <ebiederm@xmission.com>

The sysctl binary paths don't look as if they even code work, .data is not
filled in, and all of the proc_handlers look at extra1 and there is not
strategy routine.

So just kill the binary paths.

In addition this patch removes the setting of extra1 on directories.  It
doesn't look like the parport code ever examines it, and it's bad sysctl form.

[bunk@kernel.org: remove parport_device_num()]
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/parport-lowlevel.txt |   29 ++------------------
 drivers/parport/daisy.c            |   29 --------------------
 drivers/parport/procfs.c           |   38 +++------------------------
 include/linux/parport.h            |    1 
 4 files changed, 8 insertions(+), 89 deletions(-)

diff -puN Documentation/parport-lowlevel.txt~sysctl-parport-remove-binary-paths Documentation/parport-lowlevel.txt
--- a/Documentation/parport-lowlevel.txt~sysctl-parport-remove-binary-paths
+++ a/Documentation/parport-lowlevel.txt
@@ -25,7 +25,6 @@ Global functions:
   parport_open
   parport_close
   parport_device_id
-  parport_device_num
   parport_device_coords
   parport_find_class
   parport_find_device
@@ -735,7 +734,7 @@ NULL is returned.
 
 SEE ALSO
 
-parport_register_device, parport_device_num
+parport_register_device
 
 parport_close - unregister device for particular device number
 -------------
@@ -787,29 +786,7 @@ Many devices have ill-formed IEEE 1284 D
 
 SEE ALSO
 
-parport_find_class, parport_find_device, parport_device_num
-
-parport_device_num - convert device coordinates to device number
-------------------
-
-SYNOPSIS
-
-#include <linux/parport.h>
-
-int parport_device_num (int parport, int mux, int daisy);
-
-DESCRIPTION
-
-Convert between device coordinates (port, multiplexor, daisy chain
-address) and device number (zero-based).
-
-RETURN VALUE
-
-Device number, or -1 if no device at given coordinates.
-
-SEE ALSO
-
-parport_device_coords, parport_open, parport_device_id
+parport_find_class, parport_find_device
 
 parport_device_coords - convert device number to device coordinates
 ------------------
@@ -833,7 +810,7 @@ Zero on success, in which case the coord
 
 SEE ALSO
 
-parport_device_num, parport_open, parport_device_id
+parport_open, parport_device_id
 
 parport_find_class - find a device by its class
 ------------------
diff -puN drivers/parport/daisy.c~sysctl-parport-remove-binary-paths drivers/parport/daisy.c
--- a/drivers/parport/daisy.c~sysctl-parport-remove-binary-paths
+++ a/drivers/parport/daisy.c
@@ -275,35 +275,6 @@ void parport_close(struct pardevice *dev
 	parport_unregister_device(dev);
 }
 
-/**
- *	parport_device_num - convert device coordinates
- *	@parport: parallel port number
- *	@mux: multiplexor port number (-1 for no multiplexor)
- *	@daisy: daisy chain address (-1 for no daisy chain address)
- *
- *	This tries to locate a device on the given parallel port,
- *	multiplexor port and daisy chain address, and returns its
- *	device number or %-ENXIO if no device with those coordinates
- *	exists.
- **/
-
-int parport_device_num(int parport, int mux, int daisy)
-{
-	int res = -ENXIO;
-	struct daisydev *dev;
-
-	spin_lock(&topology_lock);
-	dev = topology;
-	while (dev && dev->port->portnum != parport &&
-	       dev->port->muxport != mux && dev->daisy != daisy)
-		dev = dev->next;
-	if (dev)
-		res = dev->devnum;
-	spin_unlock(&topology_lock);
-
-	return res;
-}
-
 /* Send a daisy-chain-style CPP command packet. */
 static int cpp_daisy(struct parport *port, int cmd)
 {
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
 
diff -puN include/linux/parport.h~sysctl-parport-remove-binary-paths include/linux/parport.h
--- a/include/linux/parport.h~sysctl-parport-remove-binary-paths
+++ a/include/linux/parport.h
@@ -510,7 +510,6 @@ extern struct pardevice *parport_open (i
 				       int flags, void *handle);
 extern void parport_close (struct pardevice *dev);
 extern ssize_t parport_device_id (int devnum, char *buffer, size_t len);
-extern int parport_device_num (int parport, int mux, int daisy);
 extern void parport_daisy_deselect_all (struct parport *port);
 extern int parport_daisy_select (struct parport *port, int daisy, int mode);
 
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
