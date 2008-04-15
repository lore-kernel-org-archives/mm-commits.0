From: akpm@linux-foundation.org
Subject: + ia64-use-non-racy-method-for-proc-entries-creation.patch added to -mm tree
Date: Tue, 15 Apr 2008 16:56:31 -0700
Message-ID: <200804152356.m3FNuVkF022548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753286AbYDOX4g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 19:56:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, tony.luck@intel.com


The patch titled
     ia64: use non-racy method for proc entries creation
has been added to the -mm tree.  Its filename is
     ia64-use-non-racy-method-for-proc-entries-creation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-net.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
nfsd-use-proc_create-to-setup-de-proc_fops.patch
nfs-use-proc_create-to-setup-de-proc_fops.patch
afs-use-non-racy-method-for-proc-entries-creation.patch
ext4-use-non-racy-method-for-proc-entries-creation.patch
reiserfs-use-non-racy-method-for-proc-entries-creation.patch
jbd2-use-non-racy-method-for-proc-entries-creation.patch
sysvipc-use-non-racy-method-for-proc-entries-creation.patch
mm-use-non-racy-method-for-proc-swaps-creation.patch
sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation.patch
zorro-use-non-racy-method-for-proc-entries-creation.patch
samples-use-non-racy-method-for-proc-marker-example-creation.patch
scsi-use-non-racy-method-for-proc-entries-creation.patch
usb-use-non-racy-method-for-proc-entries-creation.patch
s390-use-non-racy-method-for-proc-entries-creation.patch
arm-use-non-racy-method-for-proc-davinci_clocks-creation.patch
avr32-proc-use-non-racy-method-for-proc-tlb-creation.patch
cris-use-non-racy-method-for-proc-system_profile-creation.patch
ia64-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-pcxl_dma-creation.patch
powerpc-use-non-racy-method-for-proc-entries-creation.patch
acpi-use-non-racy-method-for-proc-entries-creation.patch
netdev-use-non-racy-method-for-proc-entries-creation.patch
isdn-use-non-racy-method-for-proc-entries-creation.patch
kernel-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation-2.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

