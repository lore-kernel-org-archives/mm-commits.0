From: akpm@linux-foundation.org
Subject: - powerpc-use-non-racy-method-for-proc-entries-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:21 -0700
Message-ID: <200804300547.m3U5lLwY029697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758579AbYD3Fr5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:47:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, benh@kernel.crashing.org, ebiederm@xmission.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: use non-racy method for proc entries creation
has been removed from the -mm tree.  Its filename was
     powerpc-use-non-racy-method-for-proc-entries-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: use non-racy method for proc entries creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create()/proc_create_data() to make sure that ->proc_fops and ->data
be setup before gluing PDE to main tree.

Add correct ->owner to proc_fops to fix reading/module unloading race.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/lparcfg.c                |    6 --
 arch/powerpc/kernel/proc_ppc64.c             |    5 -
 arch/powerpc/kernel/rtas-proc.c              |   45 +++++------------
 arch/powerpc/kernel/rtas_flash.c             |   13 +---
 arch/powerpc/platforms/cell/spufs/sched.c    |    3 -
 arch/powerpc/platforms/cell/spufs/sputrace.c |    3 -
 arch/powerpc/platforms/iseries/lpevents.c    |    8 ---
 arch/powerpc/platforms/iseries/mf.c          |    6 +-
 arch/powerpc/platforms/iseries/proc.c        |    8 ---
 arch/powerpc/platforms/iseries/viopath.c     |    7 --
 arch/powerpc/platforms/pseries/eeh.c         |   10 ---
 arch/powerpc/platforms/pseries/reconfig.c    |    7 --
 arch/powerpc/platforms/pseries/rtasd.c       |    7 +-
 13 files changed, 39 insertions(+), 89 deletions(-)

diff -puN arch/powerpc/kernel/lparcfg.c~powerpc-use-non-racy-method-for-proc-entries-creation arch/powerpc/kernel/lparcfg.c
--- a/arch/powerpc/kernel/lparcfg.c~powerpc-use-non-racy-method-for-proc-entries-creation
+++ a/arch/powerpc/kernel/lparcfg.c
@@ -591,10 +591,8 @@ int __init lparcfg_init(void)
 			!firmware_has_feature(FW_FEATURE_ISERIES))
 		mode |= S_IWUSR;
 
-	ent = create_proc_entry("ppc64/lparcfg", mode, NULL);
-	if (ent) {
-		ent->proc_fops = &lparcfg_fops;
-	} else {
+	ent = proc_create("ppc64/lparcfg", mode, NULL, &lparcfg_fops);
+	if (!ent) {
 		printk(KERN_ERR "Failed to create ppc64/lparcfg\n");
 		return -EIO;
 	}
diff -puN arch/powerpc/kernel/proc_ppc64.c~powerpc-use-non-racy-method-for-proc-entries-creation arch/powerpc/kernel/proc_ppc64.c
--- a/arch/powerpc/kernel/proc_ppc64.c~powerpc-use-non-racy-method-for-proc-entries-creation
+++ a/arch/powerpc/kernel/proc_ppc64.c
@@ -68,12 +68,11 @@ static int __init proc_ppc64_init(void)
 {
 	struct proc_dir_entry *pde;
 
-	pde = create_proc_entry("ppc64/systemcfg", S_IFREG|S_IRUGO, NULL);
+	pde = proc_create_data("ppc64/systemcfg", S_IFREG|S_IRUGO, NULL,
+			       &page_map_fops, vdso_data);
 	if (!pde)
 		return 1;
-	pde->data = vdso_data;
 	pde->size = PAGE_SIZE;
-	pde->proc_fops = &page_map_fops;
 
 	return 0;
 }
diff -puN arch/powerpc/kernel/rtas-proc.c~powerpc-use-non-racy-method-for-proc-entries-creation arch/powerpc/kernel/rtas-proc.c
--- a/arch/powerpc/kernel/rtas-proc.c~powerpc-use-non-racy-method-for-proc-entries-creation
+++ a/arch/powerpc/kernel/rtas-proc.c
@@ -255,8 +255,6 @@ static void check_location(struct seq_fi
 
 static int __init proc_rtas_init(void)
 {
-	struct proc_dir_entry *entry;
-
 	if (!machine_is(pseries))
 		return -ENODEV;
 
@@ -264,35 +262,20 @@ static int __init proc_rtas_init(void)
 	if (rtas_node == NULL)
 		return -ENODEV;
 
-	entry = create_proc_entry("ppc64/rtas/progress", S_IRUGO|S_IWUSR, NULL);
-	if (entry)
-		entry->proc_fops = &ppc_rtas_progress_operations;
-
-	entry = create_proc_entry("ppc64/rtas/clock", S_IRUGO|S_IWUSR, NULL);
-	if (entry)
-		entry->proc_fops = &ppc_rtas_clock_operations;
-
-	entry = create_proc_entry("ppc64/rtas/poweron", S_IWUSR|S_IRUGO, NULL);
-	if (entry)
-		entry->proc_fops = &ppc_rtas_poweron_operations;
-
-	entry = create_proc_entry("ppc64/rtas/sensors", S_IRUGO, NULL);
-	if (entry)
-		entry->proc_fops = &ppc_rtas_sensors_operations;
-
-	entry = create_proc_entry("ppc64/rtas/frequency", S_IWUSR|S_IRUGO,
-				  NULL);
-	if (entry)
-		entry->proc_fops = &ppc_rtas_tone_freq_operations;
-
-	entry = create_proc_entry("ppc64/rtas/volume", S_IWUSR|S_IRUGO, NULL);
-	if (entry)
-		entry->proc_fops = &ppc_rtas_tone_volume_operations;
-
-	entry = create_proc_entry("ppc64/rtas/rmo_buffer", S_IRUSR, NULL);
-	if (entry)
-		entry->proc_fops = &ppc_rtas_rmo_buf_ops;
-
+	proc_create("ppc64/rtas/progress", S_IRUGO|S_IWUSR, NULL,
+		    &ppc_rtas_progress_operations);
+	proc_create("ppc64/rtas/clock", S_IRUGO|S_IWUSR, NULL,
+		    &ppc_rtas_clock_operations);
+	proc_create("ppc64/rtas/poweron", S_IWUSR|S_IRUGO, NULL,
+		    &ppc_rtas_poweron_operations);
+	proc_create("ppc64/rtas/sensors", S_IRUGO, NULL,
+		    &ppc_rtas_sensors_operations);
+	proc_create("ppc64/rtas/frequency", S_IWUSR|S_IRUGO, NULL,
+		    &ppc_rtas_tone_freq_operations);
+	proc_create("ppc64/rtas/volume", S_IWUSR|S_IRUGO, NULL,
+		    &ppc_rtas_tone_volume_operations);
+	proc_create("ppc64/rtas/rmo_buffer", S_IRUSR, NULL,
+		    &ppc_rtas_rmo_buf_ops);
 	return 0;
 }
 
diff -puN arch/powerpc/kernel/rtas_flash.c~powerpc-use-non-racy-method-for-proc-entries-creation arch/powerpc/kernel/rtas_flash.c
--- a/arch/powerpc/kernel/rtas_flash.c~powerpc-use-non-racy-method-for-proc-entries-creation
+++ a/arch/powerpc/kernel/rtas_flash.c
@@ -704,18 +704,11 @@ static int initialize_flash_pde_data(con
 static struct proc_dir_entry *create_flash_pde(const char *filename,
 					       const struct file_operations *fops)
 {
-	struct proc_dir_entry *ent = NULL;
-
-	ent = create_proc_entry(filename, S_IRUSR | S_IWUSR, NULL);
-	if (ent != NULL) {
-		ent->proc_fops = fops;
-		ent->owner = THIS_MODULE;
-	}
-
-	return ent;
+	return proc_create(filename, S_IRUSR | S_IWUSR, NULL, fops);
 }
 
 static const struct file_operations rtas_flash_operations = {
+	.owner		= THIS_MODULE,
 	.read		= rtas_flash_read,
 	.write		= rtas_flash_write,
 	.open		= rtas_excl_open,
@@ -723,6 +716,7 @@ static const struct file_operations rtas
 };
 
 static const struct file_operations manage_flash_operations = {
+	.owner		= THIS_MODULE,
 	.read		= manage_flash_read,
 	.write		= manage_flash_write,
 	.open		= rtas_excl_open,
@@ -730,6 +724,7 @@ static const struct file_operations mana
 };
 
 static const struct file_operations validate_flash_operations = {
+	.owner		= THIS_MODULE,
 	.read		= validate_flash_read,
 	.write		= validate_flash_write,
 	.open		= rtas_excl_open,
diff -puN arch/powerpc/platforms/cell/spufs/sched.c~powerpc-use-non-racy-method-for-proc-entries-creation arch/powerpc/platforms/cell/spufs/sched.c
--- a/arch/powerpc/platforms/cell/spufs/sched.c~powerpc-use-non-racy-method-for-proc-entries-creation
+++ a/arch/powerpc/platforms/cell/spufs/sched.c
@@ -1063,10 +1063,9 @@ int __init spu_sched_init(void)
 
 	mod_timer(&spuloadavg_timer, 0);
 
-	entry = create_proc_entry("spu_loadavg", 0, NULL);
+	entry = proc_create("spu_loadavg", 0, NULL, &spu_loadavg_fops);
 	if (!entry)
 		goto out_stop_kthread;
-	entry->proc_fops = &spu_loadavg_fops;
 
 	pr_debug("spusched: tick: %d, min ticks: %d, default ticks: %d\n",
 			SPUSCHED_TICK, MIN_SPU_TIMESLICE, DEF_SPU_TIMESLICE);
diff -puN arch/powerpc/platforms/cell/spufs/sputrace.c~powerpc-use-non-racy-method-for-proc-entries-creation arch/powerpc/platforms/cell/spufs/sputrace.c
--- a/arch/powerpc/platforms/cell/spufs/sputrace.c~powerpc-use-non-racy-method-for-proc-entries-creation
+++ a/arch/powerpc/platforms/cell/spufs/sputrace.c
@@ -201,10 +201,9 @@ static int __init sputrace_init(void)
 	if (!sputrace_log)
 		goto out;
 
-	entry = create_proc_entry("sputrace", S_IRUSR, NULL);
+	entry = proc_create("sputrace", S_IRUSR, NULL, &sputrace_fops);
 	if (!entry)
 		goto out_free_log;
-	entry->proc_fops = &sputrace_fops;
 
 	for (i = 0; i < ARRAY_SIZE(spu_probes); i++) {
 		struct spu_probe *p = &spu_probes[i];
diff -puN arch/powerpc/platforms/iseries/lpevents.c~powerpc-use-non-racy-method-for-proc-entries-creation arch/powerpc/platforms/iseries/lpevents.c
--- a/arch/powerpc/platforms/iseries/lpevents.c~powerpc-use-non-racy-method-for-proc-entries-creation
+++ a/arch/powerpc/platforms/iseries/lpevents.c
@@ -330,15 +330,11 @@ static const struct file_operations proc
 
 static int __init proc_lpevents_init(void)
 {
-	struct proc_dir_entry *e;
-
 	if (!firmware_has_feature(FW_FEATURE_ISERIES))
 		return 0;
 
-	e = create_proc_entry("iSeries/lpevents", S_IFREG|S_IRUGO, NULL);
-	if (e)
-		e->proc_fops = &proc_lpevents_operations;
-
+	proc_create("iSeries/lpevents", S_IFREG|S_IRUGO, NULL,
+		    &proc_lpevents_operations);
 	return 0;
 }
 __initcall(proc_lpevents_init);
diff -puN arch/powerpc/platforms/iseries/mf.c~powerpc-use-non-racy-method-for-proc-entries-creation arch/powerpc/platforms/iseries/mf.c
--- a/arch/powerpc/platforms/iseries/mf.c~powerpc-use-non-racy-method-for-proc-entries-creation
+++ a/arch/powerpc/platforms/iseries/mf.c
@@ -1255,11 +1255,11 @@ static int __init mf_proc_init(void)
 		if (i == 3)	/* no vmlinux entry for 'D' */
 			continue;
 
-		ent = create_proc_entry("vmlinux", S_IFREG|S_IWUSR, mf);
+		ent = proc_create_data("vmlinux", S_IFREG|S_IWUSR, mf,
+				       &proc_vmlinux_operations,
+				       (void *)(long)i);
 		if (!ent)
 			return 1;
-		ent->data = (void *)(long)i;
-		ent->proc_fops = &proc_vmlinux_operations;
 	}
 
 	ent = create_proc_entry("side", S_IFREG|S_IRUSR|S_IWUSR, mf_proc_root);
diff -puN arch/powerpc/platforms/iseries/proc.c~powerpc-use-non-racy-method-for-proc-entries-creation arch/powerpc/platforms/iseries/proc.c
--- a/arch/powerpc/platforms/iseries/proc.c~powerpc-use-non-racy-method-for-proc-entries-creation
+++ a/arch/powerpc/platforms/iseries/proc.c
@@ -110,15 +110,11 @@ static const struct file_operations proc
 
 static int __init iseries_proc_init(void)
 {
-	struct proc_dir_entry *e;
-
 	if (!firmware_has_feature(FW_FEATURE_ISERIES))
 		return 0;
 
-	e = create_proc_entry("iSeries/titanTod", S_IFREG|S_IRUGO, NULL);
-	if (e)
-		e->proc_fops = &proc_titantod_operations;
-
+	proc_create("iSeries/titanTod", S_IFREG|S_IRUGO, NULL,
+		    &proc_titantod_operations);
 	return 0;
 }
 __initcall(iseries_proc_init);
diff -puN arch/powerpc/platforms/iseries/viopath.c~powerpc-use-non-racy-method-for-proc-entries-creation arch/powerpc/platforms/iseries/viopath.c
--- a/arch/powerpc/platforms/iseries/viopath.c~powerpc-use-non-racy-method-for-proc-entries-creation
+++ a/arch/powerpc/platforms/iseries/viopath.c
@@ -180,15 +180,10 @@ static const struct file_operations proc
 
 static int __init vio_proc_init(void)
 {
-	struct proc_dir_entry *e;
-
 	if (!firmware_has_feature(FW_FEATURE_ISERIES))
 		return 0;
 
-	e = create_proc_entry("iSeries/config", 0, NULL);
-	if (e)
-		e->proc_fops = &proc_viopath_operations;
-
+	proc_create("iSeries/config", 0, NULL, &proc_viopath_operations);
         return 0;
 }
 __initcall(vio_proc_init);
diff -puN arch/powerpc/platforms/pseries/eeh.c~powerpc-use-non-racy-method-for-proc-entries-creation arch/powerpc/platforms/pseries/eeh.c
--- a/arch/powerpc/platforms/pseries/eeh.c~powerpc-use-non-racy-method-for-proc-entries-creation
+++ a/arch/powerpc/platforms/pseries/eeh.c
@@ -1259,14 +1259,8 @@ static const struct file_operations proc
 
 static int __init eeh_init_proc(void)
 {
-	struct proc_dir_entry *e;
-
-	if (machine_is(pseries)) {
-		e = create_proc_entry("ppc64/eeh", 0, NULL);
-		if (e)
-			e->proc_fops = &proc_eeh_operations;
-	}
-
+	if (machine_is(pseries))
+		proc_create("ppc64/eeh", 0, NULL, &proc_eeh_operations);
 	return 0;
 }
 __initcall(eeh_init_proc);
diff -puN arch/powerpc/platforms/pseries/reconfig.c~powerpc-use-non-racy-method-for-proc-entries-creation arch/powerpc/platforms/pseries/reconfig.c
--- a/arch/powerpc/platforms/pseries/reconfig.c~powerpc-use-non-racy-method-for-proc-entries-creation
+++ a/arch/powerpc/platforms/pseries/reconfig.c
@@ -512,12 +512,9 @@ static int proc_ppc64_create_ofdt(void)
 	if (!machine_is(pseries))
 		return 0;
 
-	ent = create_proc_entry("ppc64/ofdt", S_IWUSR, NULL);
-	if (ent) {
-		ent->data = NULL;
+	ent = proc_create("ppc64/ofdt", S_IWUSR, NULL, &ofdt_fops);
+	if (ent)
 		ent->size = 0;
-		ent->proc_fops = &ofdt_fops;
-	}
 
 	return 0;
 }
diff -puN arch/powerpc/platforms/pseries/rtasd.c~powerpc-use-non-racy-method-for-proc-entries-creation arch/powerpc/platforms/pseries/rtasd.c
--- a/arch/powerpc/platforms/pseries/rtasd.c~powerpc-use-non-racy-method-for-proc-entries-creation
+++ a/arch/powerpc/platforms/pseries/rtasd.c
@@ -468,10 +468,9 @@ static int __init rtas_init(void)
 		return -ENOMEM;
 	}
 
-	entry = create_proc_entry("ppc64/rtas/error_log", S_IRUSR, NULL);
-	if (entry)
-		entry->proc_fops = &proc_rtas_log_operations;
-	else
+	entry = proc_create("ppc64/rtas/error_log", S_IRUSR, NULL,
+			    &proc_rtas_log_operations);
+	if (!entry)
 		printk(KERN_ERR "Failed to create error_log proc entry\n");
 
 	if (kernel_thread(rtasd, NULL, CLONE_FS) < 0)
_

Patches currently in -mm which might be from den@openvz.org are

origin.patch
drivers-use-non-racy-method-for-proc-entries-creation-2-rio.patch
sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-data-before-gluing-pde-into-proc-tree.patch
net-assign-pde-data-before-gluing-pde-into-proc-tree.patch
ipv6-assign-pde-data-before-gluing-pde-into-proc-tree.patch
atm-assign-pde-data-before-gluing-pde-into-proc-tree.patch
vlan-assign-pde-data-before-gluing-pde-into-proc-tree.patch
cciss-assign-pde-data-before-gluing-pde-into-proc-tree.patch
powerpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
ipv4-assign-pde-data-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-fops-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-data-before-gluing-pde-into-proc-tree-2.patch
netns-assign-pde-data-before-gluing-entry-into-proc-tree.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

