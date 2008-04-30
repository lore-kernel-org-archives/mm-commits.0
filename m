From: akpm@linux-foundation.org
Subject: - proc-remove-proc_root-from-drivers.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:46:01 -0700
Message-ID: <200804300546.m3U5k1aq029564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757487AbYD3GGG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:06:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: remove proc_root from drivers
has been removed from the -mm tree.  Its filename was
     proc-remove-proc_root-from-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: remove proc_root from drivers
From: Alexey Dobriyan <adobriyan@gmail.com>

Remove proc_root export.  Creation and removal works well if parent PDE is
supplied as NULL -- it worked always that way.

So, one useless export removed and consistency added, some drivers created
PDEs with &proc_root as parent but removed them as NULL and so on.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/atags.c                 |    2 +-
 arch/m68k/mac/iop.c                     |    2 +-
 arch/mips/basler/excite/excite_procfs.c |    2 +-
 arch/um/kernel/exitcode.c               |    2 +-
 arch/um/kernel/process.c                |    2 +-
 arch/x86/kernel/cpu/mtrr/if.c           |    2 +-
 drivers/char/ip2/ip2main.c              |    4 ++--
 drivers/mca/mca-proc.c                  |    2 +-
 drivers/misc/hdpuftrs/hdpu_cpustate.c   |    2 +-
 drivers/misc/hdpuftrs/hdpu_nexus.c      |   12 ++++++------
 drivers/s390/block/dasd_proc.c          |    6 +++---
 drivers/s390/char/tape_proc.c           |    4 ++--
 drivers/s390/cio/blacklist.c            |    2 +-
 drivers/s390/cio/qdio.c                 |    4 ++--
 drivers/scsi/megaraid.c                 |    6 +++---
 drivers/video/clps711xfb.c              |    2 +-
 fs/proc/internal.h                      |    1 +
 fs/proc/proc_misc.c                     |    2 +-
 fs/proc/root.c                          |    1 -
 include/linux/proc_fs.h                 |    3 ---
 kernel/configs.c                        |    5 ++---
 sound/core/info.c                       |    4 ++--
 22 files changed, 34 insertions(+), 38 deletions(-)

diff -puN arch/arm/kernel/atags.c~proc-remove-proc_root-from-drivers arch/arm/kernel/atags.c
--- a/arch/arm/kernel/atags.c~proc-remove-proc_root-from-drivers
+++ a/arch/arm/kernel/atags.c
@@ -35,7 +35,7 @@ create_proc_entries(void)
 {
 	struct proc_dir_entry* tags_entry;
 
-	tags_entry = create_proc_read_entry("atags", 0400, &proc_root, read_buffer, &tags_buffer);
+	tags_entry = create_proc_read_entry("atags", 0400, NULL, read_buffer, &tags_buffer);
 	if (!tags_entry)
 		return -ENOMEM;
 
diff -puN arch/m68k/mac/iop.c~proc-remove-proc_root-from-drivers arch/m68k/mac/iop.c
--- a/arch/m68k/mac/iop.c~proc-remove-proc_root-from-drivers
+++ a/arch/m68k/mac/iop.c
@@ -302,7 +302,7 @@ void __init iop_init(void)
 
 #if 0	/* Crashing in 2.4 now, not yet sure why.   --jmt */
 #ifdef CONFIG_PROC_FS
-	create_proc_info_entry("mac_iop", 0, &proc_root, iop_get_proc_info);
+	create_proc_info_entry("mac_iop", 0, NULL, iop_get_proc_info);
 #endif
 #endif
 }
diff -puN arch/mips/basler/excite/excite_procfs.c~proc-remove-proc_root-from-drivers arch/mips/basler/excite/excite_procfs.c
--- a/arch/mips/basler/excite/excite_procfs.c~proc-remove-proc_root-from-drivers
+++ a/arch/mips/basler/excite/excite_procfs.c
@@ -65,7 +65,7 @@ excite_bootrom_read(char *page, char **s
 void excite_procfs_init(void)
 {
 	/* Create & populate /proc/excite */
-	struct proc_dir_entry * const pdir = proc_mkdir("excite", &proc_root);
+	struct proc_dir_entry * const pdir = proc_mkdir("excite", NULL);
 	if (pdir) {
 		struct proc_dir_entry * e;
 
diff -puN arch/um/kernel/exitcode.c~proc-remove-proc_root-from-drivers arch/um/kernel/exitcode.c
--- a/arch/um/kernel/exitcode.c~proc-remove-proc_root-from-drivers
+++ a/arch/um/kernel/exitcode.c
@@ -59,7 +59,7 @@ static int make_proc_exitcode(void)
 {
 	struct proc_dir_entry *ent;
 
-	ent = create_proc_entry("exitcode", 0600, &proc_root);
+	ent = create_proc_entry("exitcode", 0600, NULL);
 	if (ent == NULL) {
 		printk(KERN_WARNING "make_proc_exitcode : Failed to register "
 		       "/proc/exitcode\n");
diff -puN arch/um/kernel/process.c~proc-remove-proc_root-from-drivers arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~proc-remove-proc_root-from-drivers
+++ a/arch/um/kernel/process.c
@@ -364,7 +364,7 @@ int __init make_proc_sysemu(void)
 	if (!sysemu_supported)
 		return 0;
 
-	ent = create_proc_entry("sysemu", 0600, &proc_root);
+	ent = create_proc_entry("sysemu", 0600, NULL);
 
 	if (ent == NULL)
 	{
diff -puN arch/x86/kernel/cpu/mtrr/if.c~proc-remove-proc_root-from-drivers arch/x86/kernel/cpu/mtrr/if.c
--- a/arch/x86/kernel/cpu/mtrr/if.c~proc-remove-proc_root-from-drivers
+++ a/arch/x86/kernel/cpu/mtrr/if.c
@@ -424,7 +424,7 @@ static int __init mtrr_if_init(void)
 		return -ENODEV;
 
 	proc_root_mtrr =
-		proc_create("mtrr", S_IWUSR | S_IRUGO, &proc_root, &mtrr_fops);
+		proc_create("mtrr", S_IWUSR | S_IRUGO, NULL, &mtrr_fops);
 
 	if (proc_root_mtrr)
 		proc_root_mtrr->owner = THIS_MODULE;
diff -puN drivers/char/ip2/ip2main.c~proc-remove-proc_root-from-drivers drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~proc-remove-proc_root-from-drivers
+++ a/drivers/char/ip2/ip2main.c
@@ -423,7 +423,7 @@ cleanup_module(void)
 	}
 	put_tty_driver(ip2_tty_driver);
 	unregister_chrdev(IP2_IPL_MAJOR, pcIpl);
-	remove_proc_entry("ip2mem", &proc_root);
+	remove_proc_entry("ip2mem", NULL);
 
 	// free memory
 	for (i = 0; i < IP2_MAX_BOARDS; i++) {
@@ -695,7 +695,7 @@ ip2_loadmain(int *iop, int *irqp, unsign
 		}
 	}
 	/* Register the read_procmem thing */
-	if (!create_proc_info_entry("ip2mem",0,&proc_root,ip2_read_procmem)) {
+	if (!create_proc_info_entry("ip2mem",0,NULL,ip2_read_procmem)) {
 		printk(KERN_ERR "IP2: failed to register read_procmem\n");
 	} else {
 
diff -puN drivers/mca/mca-proc.c~proc-remove-proc_root-from-drivers drivers/mca/mca-proc.c
--- a/drivers/mca/mca-proc.c~proc-remove-proc_root-from-drivers
+++ a/drivers/mca/mca-proc.c
@@ -183,7 +183,7 @@ void __init mca_do_proc_init(void)
 	struct proc_dir_entry* node = NULL;
 	struct mca_device *mca_dev;
 
-	proc_mca = proc_mkdir("mca", &proc_root);
+	proc_mca = proc_mkdir("mca", NULL);
 	create_proc_read_entry("pos",0,proc_mca,get_mca_info,NULL);
 	create_proc_read_entry("machine",0,proc_mca,get_mca_machine_info,NULL);
 
diff -puN drivers/misc/hdpuftrs/hdpu_cpustate.c~proc-remove-proc_root-from-drivers drivers/misc/hdpuftrs/hdpu_cpustate.c
--- a/drivers/misc/hdpuftrs/hdpu_cpustate.c~proc-remove-proc_root-from-drivers
+++ a/drivers/misc/hdpuftrs/hdpu_cpustate.c
@@ -210,7 +210,7 @@ static int hdpu_cpustate_probe(struct pl
 		return ret;
 	}
 
-	proc_de = create_proc_entry("sky_cpustate", 0666, &proc_root);
+	proc_de = create_proc_entry("sky_cpustate", 0666, NULL);
 	if (!proc_de) {
 		printk(KERN_WARNING "sky_cpustate: "
 		       "Unable to create proc entry\n");
diff -puN drivers/misc/hdpuftrs/hdpu_nexus.c~proc-remove-proc_root-from-drivers drivers/misc/hdpuftrs/hdpu_nexus.c
--- a/drivers/misc/hdpuftrs/hdpu_nexus.c~proc-remove-proc_root-from-drivers
+++ a/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -102,8 +102,8 @@ static int hdpu_nexus_probe(struct platf
 		printk(KERN_ERR "sky_nexus: Could not map slot id\n");
 	}
 
-	hdpu_slot_id = create_proc_entry("sky_slot_id", 0666, &proc_root);
-	if (!hdpu_slot_id) {
+	hdpu_slot_id = create_proc_entry("sky_slot_id", 0666, NULL);
+	if (!hdpu_slot_id)
 		printk(KERN_WARNING "sky_nexus: "
 		       "Unable to create proc dir entry: sky_slot_id\n");
 	} else {
@@ -111,8 +111,8 @@ static int hdpu_nexus_probe(struct platf
 		hdpu_slot_id->owner = THIS_MODULE;
 	}
 
-	hdpu_chassis_id = create_proc_entry("sky_chassis_id", 0666, &proc_root);
-	if (!hdpu_chassis_id) {
+	hdpu_chassis_id = create_proc_entry("sky_chassis_id", 0666, NULL);
+	if (!hdpu_chassis_id)
 		printk(KERN_WARNING "sky_nexus: "
 		       "Unable to create proc dir entry: sky_chassis_id\n");
 	} else {
@@ -128,8 +128,8 @@ static int hdpu_nexus_remove(struct plat
 	slot_id = -1;
 	chassis_id = -1;
 
-	remove_proc_entry("sky_slot_id", &proc_root);
-	remove_proc_entry("sky_chassis_id", &proc_root);
+	remove_proc_entry("sky_slot_id", NULL);
+	remove_proc_entry("sky_chassis_id", NULL);
 
 	hdpu_slot_id = 0;
 	hdpu_chassis_id = 0;
diff -puN drivers/s390/block/dasd_proc.c~proc-remove-proc_root-from-drivers drivers/s390/block/dasd_proc.c
--- a/drivers/s390/block/dasd_proc.c~proc-remove-proc_root-from-drivers
+++ a/drivers/s390/block/dasd_proc.c
@@ -311,7 +311,7 @@ out_error:
 int
 dasd_proc_init(void)
 {
-	dasd_proc_root_entry = proc_mkdir("dasd", &proc_root);
+	dasd_proc_root_entry = proc_mkdir("dasd", NULL);
 	if (!dasd_proc_root_entry)
 		goto out_nodasd;
 	dasd_proc_root_entry->owner = THIS_MODULE;
@@ -335,7 +335,7 @@ dasd_proc_init(void)
  out_nostatistics:
 	remove_proc_entry("devices", dasd_proc_root_entry);
  out_nodevices:
-	remove_proc_entry("dasd", &proc_root);
+	remove_proc_entry("dasd", NULL);
  out_nodasd:
 	return -ENOENT;
 }
@@ -345,5 +345,5 @@ dasd_proc_exit(void)
 {
 	remove_proc_entry("devices", dasd_proc_root_entry);
 	remove_proc_entry("statistics", dasd_proc_root_entry);
-	remove_proc_entry("dasd", &proc_root);
+	remove_proc_entry("dasd", NULL);
 }
diff -puN drivers/s390/char/tape_proc.c~proc-remove-proc_root-from-drivers drivers/s390/char/tape_proc.c
--- a/drivers/s390/char/tape_proc.c~proc-remove-proc_root-from-drivers
+++ a/drivers/s390/char/tape_proc.c
@@ -125,7 +125,7 @@ tape_proc_init(void)
 {
 	tape_proc_devices =
 		create_proc_entry ("tapedevices", S_IFREG | S_IRUGO | S_IWUSR,
-				   &proc_root);
+				   NULL);
 	if (tape_proc_devices == NULL) {
 		PRINT_WARN("tape: Cannot register procfs entry tapedevices\n");
 		return;
@@ -141,5 +141,5 @@ void
 tape_proc_cleanup(void)
 {
 	if (tape_proc_devices != NULL)
-		remove_proc_entry ("tapedevices", &proc_root);
+		remove_proc_entry ("tapedevices", NULL);
 }
diff -puN drivers/s390/cio/blacklist.c~proc-remove-proc_root-from-drivers drivers/s390/cio/blacklist.c
--- a/drivers/s390/cio/blacklist.c~proc-remove-proc_root-from-drivers
+++ a/drivers/s390/cio/blacklist.c
@@ -375,7 +375,7 @@ cio_ignore_proc_init (void)
 	struct proc_dir_entry *entry;
 
 	entry = create_proc_entry ("cio_ignore", S_IFREG | S_IRUGO | S_IWUSR,
-				   &proc_root);
+				   NULL);
 	if (!entry)
 		return -ENOENT;
 
diff -puN drivers/s390/cio/qdio.c~proc-remove-proc_root-from-drivers drivers/s390/cio/qdio.c
--- a/drivers/s390/cio/qdio.c~proc-remove-proc_root-from-drivers
+++ a/drivers/s390/cio/qdio.c
@@ -3632,7 +3632,7 @@ qdio_add_procfs_entry(void)
 {
         proc_perf_file_registration=0;
 	qdio_perf_proc_file=create_proc_entry(QDIO_PERF,
-					      S_IFREG|0444,&proc_root);
+					      S_IFREG|0444,NULL);
 	if (qdio_perf_proc_file) {
 		qdio_perf_proc_file->read_proc=&qdio_perf_procfile_read;
 	} else proc_perf_file_registration=-1;
@@ -3647,7 +3647,7 @@ static void
 qdio_remove_procfs_entry(void)
 {
         if (!proc_perf_file_registration) /* means if it went ok earlier */
-		remove_proc_entry(QDIO_PERF,&proc_root);
+		remove_proc_entry(QDIO_PERF,NULL);
 }
 
 /**
diff -puN drivers/scsi/megaraid.c~proc-remove-proc_root-from-drivers drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~proc-remove-proc_root-from-drivers
+++ a/drivers/scsi/megaraid.c
@@ -4996,7 +4996,7 @@ static int __init megaraid_init(void)
 		max_mbox_busy_wait = MBOX_BUSY_WAIT;
 
 #ifdef CONFIG_PROC_FS
-	mega_proc_dir_entry = proc_mkdir("megaraid", &proc_root);
+	mega_proc_dir_entry = proc_mkdir("megaraid", NULL);
 	if (!mega_proc_dir_entry) {
 		printk(KERN_WARNING
 				"megaraid: failed to create megaraid root\n");
@@ -5005,7 +5005,7 @@ static int __init megaraid_init(void)
 	error = pci_register_driver(&megaraid_pci_driver);
 	if (error) {
 #ifdef CONFIG_PROC_FS
-		remove_proc_entry("megaraid", &proc_root);
+		remove_proc_entry("megaraid", NULL);
 #endif
 		return error;
 	}
@@ -5035,7 +5035,7 @@ static void __exit megaraid_exit(void)
 	pci_unregister_driver(&megaraid_pci_driver);
 
 #ifdef CONFIG_PROC_FS
-	remove_proc_entry("megaraid", &proc_root);
+	remove_proc_entry("megaraid", NULL);
 #endif
 }
 
diff -puN drivers/video/clps711xfb.c~proc-remove-proc_root-from-drivers drivers/video/clps711xfb.c
--- a/drivers/video/clps711xfb.c~proc-remove-proc_root-from-drivers
+++ a/drivers/video/clps711xfb.c
@@ -381,7 +381,7 @@ int __init clps711xfb_init(void)
 
 	/* Register the /proc entries. */
 	clps7111fb_backlight_proc_entry = create_proc_entry("backlight", 0444,
-		&proc_root);
+		NULL);
 	if (clps7111fb_backlight_proc_entry == NULL) {
 		printk("Couldn't create the /proc entry for the backlight.\n");
 		return -EINVAL;
diff -puN fs/proc/internal.h~proc-remove-proc_root-from-drivers fs/proc/internal.h
--- a/fs/proc/internal.h~proc-remove-proc_root-from-drivers
+++ a/fs/proc/internal.h
@@ -11,6 +11,7 @@
 
 #include <linux/proc_fs.h>
 
+extern struct proc_dir_entry proc_root;
 #ifdef CONFIG_PROC_SYSCTL
 extern int proc_sys_init(void);
 #else
diff -puN fs/proc/proc_misc.c~proc-remove-proc_root-from-drivers fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~proc-remove-proc_root-from-drivers
+++ a/fs/proc/proc_misc.c
@@ -854,7 +854,7 @@ void __init proc_misc_init(void)
 
 	/* And now for trickier ones */
 #ifdef CONFIG_PRINTK
-	proc_create("kmsg", S_IRUSR, &proc_root, &proc_kmsg_operations);
+	proc_create("kmsg", S_IRUSR, NULL, &proc_kmsg_operations);
 #endif
 	proc_create("locks", 0, NULL, &proc_locks_operations);
 	proc_create("devices", 0, NULL, &proc_devinfo_operations);
diff -puN fs/proc/root.c~proc-remove-proc_root-from-drivers fs/proc/root.c
--- a/fs/proc/root.c~proc-remove-proc_root-from-drivers
+++ a/fs/proc/root.c
@@ -232,4 +232,3 @@ EXPORT_SYMBOL(proc_mkdir);
 EXPORT_SYMBOL(create_proc_entry);
 EXPORT_SYMBOL(proc_create);
 EXPORT_SYMBOL(remove_proc_entry);
-EXPORT_SYMBOL(proc_root);
diff -puN include/linux/proc_fs.h~proc-remove-proc_root-from-drivers include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~proc-remove-proc_root-from-drivers
+++ a/include/linux/proc_fs.h
@@ -96,7 +96,6 @@ struct vmcore {
 
 #ifdef CONFIG_PROC_FS
 
-extern struct proc_dir_entry proc_root;
 extern struct proc_dir_entry *proc_root_kcore;
 
 extern spinlock_t proc_subdir_lock;
@@ -243,8 +242,6 @@ struct tty_driver;
 static inline void proc_tty_register_driver(struct tty_driver *driver) {};
 static inline void proc_tty_unregister_driver(struct tty_driver *driver) {};
 
-extern struct proc_dir_entry proc_root;
-
 static inline int pid_ns_prepare_proc(struct pid_namespace *ns)
 {
 	return 0;
diff -puN kernel/configs.c~proc-remove-proc_root-from-drivers kernel/configs.c
--- a/kernel/configs.c~proc-remove-proc_root-from-drivers
+++ a/kernel/configs.c
@@ -79,8 +79,7 @@ static int __init ikconfig_init(void)
 	struct proc_dir_entry *entry;
 
 	/* create the current config file */
-	entry = create_proc_entry("config.gz", S_IFREG | S_IRUGO,
-				  &proc_root);
+	entry = create_proc_entry("config.gz", S_IFREG | S_IRUGO, NULL);
 	if (!entry)
 		return -ENOMEM;
 
@@ -95,7 +94,7 @@ static int __init ikconfig_init(void)
 
 static void __exit ikconfig_cleanup(void)
 {
-	remove_proc_entry("config.gz", &proc_root);
+	remove_proc_entry("config.gz", NULL);
 }
 
 module_init(ikconfig_init);
diff -puN sound/core/info.c~proc-remove-proc_root-from-drivers sound/core/info.c
--- a/sound/core/info.c~proc-remove-proc_root-from-drivers
+++ a/sound/core/info.c
@@ -544,7 +544,7 @@ int __init snd_info_init(void)
 {
 	struct proc_dir_entry *p;
 
-	p = snd_create_proc_entry("asound", S_IFDIR | S_IRUGO | S_IXUGO, &proc_root);
+	p = snd_create_proc_entry("asound", S_IFDIR | S_IRUGO | S_IXUGO, NULL);
 	if (p == NULL)
 		return -ENOMEM;
 	snd_proc_root = p;
@@ -594,7 +594,7 @@ int __exit snd_info_done(void)
 #ifdef CONFIG_SND_OSSEMUL
 		snd_info_free_entry(snd_oss_root);
 #endif
-		snd_remove_proc_entry(&proc_root, snd_proc_root);
+		snd_remove_proc_entry(NULL, snd_proc_root);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
drivers-use-non-racy-method-for-proc-entries-creation-2-rio.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
git-xfs.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

