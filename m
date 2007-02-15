From: akpm@linux-foundation.org
Subject: - sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:50:03 -0800
Message-ID: <200702150850.l1F8o3N0025184@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40168 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965489AbXBOIuF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:50:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: C99 convert ctl_tables in drivers/parport/procfs.c
has been removed from the -mm tree.  Its filename was
     sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: C99 convert ctl_tables in drivers/parport/procfs.c
From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/procfs.c |  270 ++++++++++++++++++++++++++-----------
 1 file changed, 192 insertions(+), 78 deletions(-)

diff -puN drivers/parport/procfs.c~sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc drivers/parport/procfs.c
--- a/drivers/parport/procfs.c~sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc
+++ a/drivers/parport/procfs.c
@@ -233,12 +233,12 @@ static int do_hardware_modes (ctl_table 
 	return copy_to_user(result, buffer, len) ? -EFAULT : 0;
 }
 
-#define PARPORT_PORT_DIR(child) { 0, NULL, NULL, 0, 0555, child }
-#define PARPORT_PARPORT_DIR(child) { DEV_PARPORT, "parport", \
-                                     NULL, 0, 0555, child }
-#define PARPORT_DEV_DIR(child) { CTL_DEV, "dev", NULL, 0, 0555, child }
-#define PARPORT_DEVICES_ROOT_DIR  { DEV_PARPORT_DEVICES, "devices", \
-                                    NULL, 0, 0555, NULL }
+#define PARPORT_PORT_DIR(CHILD) { .ctl_name = 0, .procname = NULL, .mode = 0555, .child = CHILD }
+#define PARPORT_PARPORT_DIR(CHILD) { .ctl_name = DEV_PARPORT, .procname = "parport", \
+                                     .mode = 0555, .child = CHILD }
+#define PARPORT_DEV_DIR(CHILD) { .ctl_name = CTL_DEV, .procname = "dev", .mode = 0555, .child = CHILD }
+#define PARPORT_DEVICES_ROOT_DIR  { .ctl_name = DEV_PARPORT_DEVICES, .procname = "devices", \
+                                    .mode = 0555, .child = NULL }
 
 static const unsigned long parport_min_timeslice_value =
 PARPORT_MIN_TIMESLICE_VALUE;
@@ -263,50 +263,118 @@ struct parport_sysctl_table {
 };
 
 static const struct parport_sysctl_table parport_sysctl_template = {
-	NULL,
+	.sysctl_header = NULL,
         {
-		{ DEV_PARPORT_SPINTIME, "spintime",
-		  NULL, sizeof(int), 0644, NULL,
-		  &proc_dointvec_minmax, NULL, NULL,
-		  (void*) &parport_min_spintime_value,
-		  (void*) &parport_max_spintime_value },
-		{ DEV_PARPORT_BASE_ADDR, "base-addr",
-		  NULL, 0, 0444, NULL,
-		  &do_hardware_base_addr },
-		{ DEV_PARPORT_IRQ, "irq",
-		  NULL, 0, 0444, NULL,
-		  &do_hardware_irq },
-		{ DEV_PARPORT_DMA, "dma",
-		  NULL, 0, 0444, NULL,
-		  &do_hardware_dma },
-		{ DEV_PARPORT_MODES, "modes",
-		  NULL, 0, 0444, NULL,
-		  &do_hardware_modes },
+		{
+			.ctl_name	= DEV_PARPORT_SPINTIME,
+			.procname	= "spintime",
+			.data		= NULL,
+			.maxlen		= sizeof(int),
+			.mode		= 0644,
+			.proc_handler	= &proc_dointvec_minmax,
+			.extra1		= (void*) &parport_min_spintime_value,
+			.extra2		= (void*) &parport_max_spintime_value
+		},
+		{
+			.ctl_name	= DEV_PARPORT_BASE_ADDR,
+			.procname	= "base-addr",
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0444,
+			.proc_handler	= &do_hardware_base_addr
+		},
+		{
+			.ctl_name	= DEV_PARPORT_IRQ,
+			.procname	= "irq",
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0444,
+			.proc_handler	= &do_hardware_irq
+		},
+		{
+			.ctl_name	= DEV_PARPORT_DMA,
+			.procname	= "dma",
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0444,
+			.proc_handler	= &do_hardware_dma
+		},
+		{
+			.ctl_name	= DEV_PARPORT_MODES,
+			.procname	= "modes",
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0444,
+			.proc_handler	= &do_hardware_modes
+		},
 		PARPORT_DEVICES_ROOT_DIR,
 #ifdef CONFIG_PARPORT_1284
-		{ DEV_PARPORT_AUTOPROBE, "autoprobe",
-		  NULL, 0, 0444, NULL,
-		  &do_autoprobe },
-		{ DEV_PARPORT_AUTOPROBE + 1, "autoprobe0",
-		 NULL, 0, 0444, NULL,
-		 &do_autoprobe },
-		{ DEV_PARPORT_AUTOPROBE + 2, "autoprobe1",
-		  NULL, 0, 0444, NULL,
-		  &do_autoprobe },
-		{ DEV_PARPORT_AUTOPROBE + 3, "autoprobe2",
-		  NULL, 0, 0444, NULL,
-		  &do_autoprobe },
-		{ DEV_PARPORT_AUTOPROBE + 4, "autoprobe3",
-		  NULL, 0, 0444, NULL,
-		  &do_autoprobe },
+		{
+			.ctl_name	= DEV_PARPORT_AUTOPROBE,
+			.procname	= "autoprobe",
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0444,
+			.proc_handler	= &do_autoprobe
+		},
+		{
+			.ctl_name	= DEV_PARPORT_AUTOPROBE + 1,
+			.procname	= "autoprobe0",
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0444,
+			.proc_handler	=  &do_autoprobe
+		},
+		{
+			.ctl_name	= DEV_PARPORT_AUTOPROBE + 2,
+			.procname	= "autoprobe1",
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0444,
+			.proc_handler	= &do_autoprobe
+		},
+		{
+			.ctl_name	= DEV_PARPORT_AUTOPROBE + 3,
+			.procname	= "autoprobe2",
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0444,
+			.proc_handler	= &do_autoprobe
+		},
+		{
+			.ctl_name	= DEV_PARPORT_AUTOPROBE + 4,
+			.procname	= "autoprobe3",
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0444,
+			.proc_handler	= &do_autoprobe
+		},
 #endif /* IEEE 1284 support */
-		{0}
+		{}
 	},
-	{ {DEV_PARPORT_DEVICES_ACTIVE, "active", NULL, 0, 0444, NULL,
-	  &do_active_device }, {0}},
-	{ PARPORT_PORT_DIR(NULL), {0}},
-	{ PARPORT_PARPORT_DIR(NULL), {0}},
-	{ PARPORT_DEV_DIR(NULL), {0}}
+	{
+		{
+			.ctl_name	= DEV_PARPORT_DEVICES_ACTIVE,
+			.procname	= "active",
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0444,
+			.proc_handler	= &do_active_device
+		},
+		{}
+	},
+	{
+		PARPORT_PORT_DIR(NULL),
+		{}
+	},
+	{
+		PARPORT_PARPORT_DIR(NULL),
+		{}
+	},
+	{
+		PARPORT_DEV_DIR(NULL),
+		{}
+	}
 };
 
 struct parport_device_sysctl_table
@@ -322,19 +390,46 @@ struct parport_device_sysctl_table
 
 static const struct parport_device_sysctl_table
 parport_device_sysctl_template = {
-	NULL,
+	.sysctl_header = NULL,
+	{
+		{
+			.ctl_name 	= DEV_PARPORT_DEVICE_TIMESLICE,
+			.procname 	= "timeslice",
+			.data		= NULL,
+			.maxlen		= sizeof(int),
+			.mode		= 0644,
+			.proc_handler	= &proc_doulongvec_ms_jiffies_minmax,
+			.extra1		= (void*) &parport_min_timeslice_value,
+			.extra2		= (void*) &parport_max_timeslice_value
+		},
+	},
 	{
-		{ DEV_PARPORT_DEVICE_TIMESLICE, "timeslice",
-		  NULL, sizeof(int), 0644, NULL,
-		  &proc_doulongvec_ms_jiffies_minmax, NULL, NULL,
-		  (void*) &parport_min_timeslice_value,
-		  (void*) &parport_max_timeslice_value },
-	},
-	{ {0, NULL, NULL, 0, 0555, NULL}, {0}},
-	{ PARPORT_DEVICES_ROOT_DIR, {0}},
-	{ PARPORT_PORT_DIR(NULL), {0}},
-	{ PARPORT_PARPORT_DIR(NULL), {0}},
-	{ PARPORT_DEV_DIR(NULL), {0}}
+		{
+			.ctl_name	= 0,
+			.procname	= NULL,
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0555,
+			.child		= NULL
+		},
+		{}
+	},
+	{
+		PARPORT_DEVICES_ROOT_DIR,
+		{}
+	},
+	{
+		PARPORT_PORT_DIR(NULL),
+		{}
+	},
+	{
+		PARPORT_PARPORT_DIR(NULL),
+		{}
+	},
+	{
+		PARPORT_DEV_DIR(NULL),
+		{}
+	}
 };
 
 struct parport_default_sysctl_table
@@ -351,28 +446,47 @@ extern int parport_default_spintime;
 
 static struct parport_default_sysctl_table
 parport_default_sysctl_table = {
-	NULL,
+	.sysctl_header	= NULL,
 	{
-		{ DEV_PARPORT_DEFAULT_TIMESLICE, "timeslice",
-		  &parport_default_timeslice,
-		  sizeof(parport_default_timeslice), 0644, NULL,
-		  &proc_doulongvec_ms_jiffies_minmax, NULL, NULL,
-		  (void*) &parport_min_timeslice_value,
-		  (void*) &parport_max_timeslice_value },
-		{ DEV_PARPORT_DEFAULT_SPINTIME, "spintime",
-		  &parport_default_spintime,
-		  sizeof(parport_default_spintime), 0644, NULL,
-		  &proc_dointvec_minmax, NULL, NULL,
-		  (void*) &parport_min_spintime_value,
-		  (void*) &parport_max_spintime_value },
-		{0}
-	},
-	{ { DEV_PARPORT_DEFAULT, "default", NULL, 0, 0555,
-	    parport_default_sysctl_table.vars },{0}},
-	{
-	PARPORT_PARPORT_DIR(parport_default_sysctl_table.default_dir), 
-	{0}},
-	{ PARPORT_DEV_DIR(parport_default_sysctl_table.parport_dir), {0}}
+		{
+			.ctl_name	= DEV_PARPORT_DEFAULT_TIMESLICE,
+			.procname	= "timeslice",
+			.data		= &parport_default_timeslice,
+			.maxlen		= sizeof(parport_default_timeslice),
+			.mode		= 0644,
+			.proc_handler	= &proc_doulongvec_ms_jiffies_minmax,
+			.extra1		= (void*) &parport_min_timeslice_value,
+			.extra2		= (void*) &parport_max_timeslice_value
+		},
+		{
+			.ctl_name	= DEV_PARPORT_DEFAULT_SPINTIME,
+			.procname	= "spintime",
+			.data		= &parport_default_spintime,
+			.maxlen		= sizeof(parport_default_spintime),
+			.mode		= 0644,
+			.proc_handler	= &proc_dointvec_minmax,
+			.extra1		= (void*) &parport_min_spintime_value,
+			.extra2		= (void*) &parport_max_spintime_value
+		},
+		{}
+	},
+	{
+		{
+			.ctl_name	= DEV_PARPORT_DEFAULT,
+			.procname	= "default",
+			.mode		= 0555,
+			.child		= parport_default_sysctl_table.vars
+		},
+		{}
+	},
+	{
+		PARPORT_PARPORT_DIR(parport_default_sysctl_table.default_dir),
+		{}
+	},
+	{
+		PARPORT_DEV_DIR(parport_default_sysctl_table.parport_dir),
+		{}
+	}
 };
 
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
git-v9fs.patch
x86_64-irq-simplfy-__assign_irq_vector.patch
x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
i386-apic-clean-up-the-apic-code.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
