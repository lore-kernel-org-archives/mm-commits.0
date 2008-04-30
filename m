From: akpm@linux-foundation.org
Subject: - ia64-use-non-racy-method-for-proc-entries-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:17 -0700
Message-ID: <200804300547.m3U5lHQB029691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758583AbYD3Frv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:47:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: use non-racy method for proc entries creation
has been removed from the -mm tree.  Its filename was
     ia64-use-non-racy-method-for-proc-entries-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: use non-racy method for proc entries creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create()/proc_create_data() to make sure that ->proc_fops and ->data
be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/hp/common/sba_iommu.c      |    6 +----
 arch/ia64/kernel/perfmon.c           |    6 -----
 arch/ia64/kernel/salinfo.c           |   10 +++-----
 arch/ia64/sn/kernel/sn2/sn2_smp.c    |    5 ++--
 arch/ia64/sn/kernel/sn2/sn_proc_fs.c |   29 ++++++++-----------------
 5 files changed, 20 insertions(+), 36 deletions(-)

diff -puN arch/ia64/hp/common/sba_iommu.c~ia64-use-non-racy-method-for-proc-entries-creation arch/ia64/hp/common/sba_iommu.c
--- a/arch/ia64/hp/common/sba_iommu.c~ia64-use-non-racy-method-for-proc-entries-creation
+++ a/arch/ia64/hp/common/sba_iommu.c
@@ -1932,15 +1932,13 @@ static const struct file_operations ioc_
 static void __init
 ioc_proc_init(void)
 {
-	struct proc_dir_entry *dir, *entry;
+	struct proc_dir_entry *dir;
 
 	dir = proc_mkdir("bus/mckinley", NULL);
 	if (!dir)
 		return;
 
-	entry = create_proc_entry(ioc_list->name, 0, dir);
-	if (entry)
-		entry->proc_fops = &ioc_fops;
+	proc_create(ioc_list->name, 0, dir, &ioc_fops);
 }
 #endif
 
diff -puN arch/ia64/kernel/perfmon.c~ia64-use-non-racy-method-for-proc-entries-creation arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~ia64-use-non-racy-method-for-proc-entries-creation
+++ a/arch/ia64/kernel/perfmon.c
@@ -6695,16 +6695,12 @@ pfm_init(void)
 	/*
 	 * create /proc/perfmon (mostly for debugging purposes)
 	 */
- 	perfmon_dir = create_proc_entry("perfmon", S_IRUGO, NULL);
+	perfmon_dir = proc_create("perfmon", S_IRUGO, NULL, &pfm_proc_fops);
 	if (perfmon_dir == NULL) {
 		printk(KERN_ERR "perfmon: cannot create /proc entry, perfmon disabled\n");
 		pmu_conf = NULL;
 		return -1;
 	}
-  	/*
- 	 * install customized file operations for /proc/perfmon entry
- 	 */
- 	perfmon_dir->proc_fops = &pfm_proc_fops;
 
 	/*
 	 * create /proc/sys/kernel/perfmon (for debugging purposes)
diff -puN arch/ia64/kernel/salinfo.c~ia64-use-non-racy-method-for-proc-entries-creation arch/ia64/kernel/salinfo.c
--- a/arch/ia64/kernel/salinfo.c~ia64-use-non-racy-method-for-proc-entries-creation
+++ a/arch/ia64/kernel/salinfo.c
@@ -648,18 +648,16 @@ salinfo_init(void)
 		if (!dir)
 			continue;
 
-		entry = create_proc_entry("event", S_IRUSR, dir);
+		entry = proc_create_data("event", S_IRUSR, dir,
+					 &salinfo_event_fops, data);
 		if (!entry)
 			continue;
-		entry->data = data;
-		entry->proc_fops = &salinfo_event_fops;
 		*sdir++ = entry;
 
-		entry = create_proc_entry("data", S_IRUSR | S_IWUSR, dir);
+		entry = proc_create_data("data", S_IRUSR | S_IWUSR, dir,
+					 &salinfo_data_fops, data);
 		if (!entry)
 			continue;
-		entry->data = data;
-		entry->proc_fops = &salinfo_data_fops;
 		*sdir++ = entry;
 
 		/* we missed any events before now */
diff -puN arch/ia64/sn/kernel/sn2/sn2_smp.c~ia64-use-non-racy-method-for-proc-entries-creation arch/ia64/sn/kernel/sn2/sn2_smp.c
--- a/arch/ia64/sn/kernel/sn2/sn2_smp.c~ia64-use-non-racy-method-for-proc-entries-creation
+++ a/arch/ia64/sn/kernel/sn2/sn2_smp.c
@@ -550,11 +550,12 @@ static int __init sn2_ptc_init(void)
 	if (!ia64_platform_is("sn2"))
 		return 0;
 
-	if (!(proc_sn2_ptc = create_proc_entry(PTC_BASENAME, 0444, NULL))) {
+	proc_sn2_ptc = proc_create(PTC_BASENAME, 0444,
+				   NULL, &proc_sn2_ptc_operations);
+	if (!&proc_sn2_ptc_operations) {
 		printk(KERN_ERR "unable to create %s proc entry", PTC_BASENAME);
 		return -EINVAL;
 	}
-	proc_sn2_ptc->proc_fops = &proc_sn2_ptc_operations;
 	spin_lock_init(&sn2_global_ptc_lock);
 	return 0;
 }
diff -puN arch/ia64/sn/kernel/sn2/sn_proc_fs.c~ia64-use-non-racy-method-for-proc-entries-creation arch/ia64/sn/kernel/sn2/sn_proc_fs.c
--- a/arch/ia64/sn/kernel/sn2/sn_proc_fs.c~ia64-use-non-racy-method-for-proc-entries-creation
+++ a/arch/ia64/sn/kernel/sn2/sn_proc_fs.c
@@ -139,30 +139,21 @@ static const struct file_operations proc
 void register_sn_procfs(void)
 {
 	static struct proc_dir_entry *sgi_proc_dir = NULL;
-	struct proc_dir_entry *pde;
 
 	BUG_ON(sgi_proc_dir != NULL);
 	if (!(sgi_proc_dir = proc_mkdir("sgi_sn", NULL)))
 		return;
 
-	pde = create_proc_entry("partition_id", 0444, sgi_proc_dir);
-	if (pde)
-		pde->proc_fops = &proc_partition_id_fops;
-	pde = create_proc_entry("system_serial_number", 0444, sgi_proc_dir);
-	if (pde)
-		pde->proc_fops = &proc_system_sn_fops;
-	pde = create_proc_entry("licenseID", 0444, sgi_proc_dir);
-	if (pde)
-		pde->proc_fops = &proc_license_id_fops;
-	pde = create_proc_entry("sn_force_interrupt", 0644, sgi_proc_dir);
-	if (pde)
-		pde->proc_fops = &proc_sn_force_intr_fops;
-	pde = create_proc_entry("coherence_id", 0444, sgi_proc_dir);
-	if (pde)
-		pde->proc_fops = &proc_coherence_id_fops;
-	pde = create_proc_entry("sn_topology", 0444, sgi_proc_dir);
-	if (pde)
-		pde->proc_fops = &proc_sn_topo_fops;
+	proc_create("partition_id", 0444, sgi_proc_dir,
+		    &proc_partition_id_fops);
+	proc_create("system_serial_number", 0444, sgi_proc_dir,
+		    &proc_system_sn_fops);
+	proc_create("licenseID", 0444, sgi_proc_dir, &proc_license_id_fops);
+	proc_create("sn_force_interrupt", 0644, sgi_proc_dir,
+		    &proc_sn_force_intr_fops);
+	proc_create("coherence_id", 0444, sgi_proc_dir,
+		    &proc_coherence_id_fops);
+	proc_create("sn_topology", 0444, sgi_proc_dir, &proc_sn_topo_fops);
 }
 
 #endif /* CONFIG_PROC_FS */
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

