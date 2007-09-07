From: akpm@linux-foundation.org
Subject: + revert-x86_64-mm-intel_cacheinfo-adjustments.patch added to -mm tree
Date: Thu, 06 Sep 2007 17:46:20 -0700
Message-ID: <200709070046.l870kKpc016299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37846 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932685AbXIGAqm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2007 20:46:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de, jbeulich@novell.com


The patch titled
     revert x86_64-mm-intel_cacheinfo-adjustments
has been added to the -mm tree.  Its filename is
     revert-x86_64-mm-intel_cacheinfo-adjustments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert x86_64-mm-intel_cacheinfo-adjustments
From: Andrew Morton <akpm@linux-foundation.org>

Avoid destroying
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch

Cc: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/intel_cacheinfo.c |   43 ++++++++++++-----------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff -puN arch/i386/kernel/cpu/intel_cacheinfo.c~revert-x86_64-mm-intel_cacheinfo-adjustments arch/i386/kernel/cpu/intel_cacheinfo.c
--- a/arch/i386/kernel/cpu/intel_cacheinfo.c~revert-x86_64-mm-intel_cacheinfo-adjustments
+++ a/arch/i386/kernel/cpu/intel_cacheinfo.c
@@ -457,7 +457,8 @@ static struct _cpuid4_info *cpuid4_info[
 static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
 {
 	struct _cpuid4_info	*this_leaf, *sibling_leaf;
-	unsigned int num_threads_sharing, index_msb, i;
+	unsigned long num_threads_sharing;
+	int index_msb, i;
 	struct cpuinfo_x86 *c = cpu_data;
 
 	this_leaf = CPUID4_INFO_IDX(cpu, index);
@@ -483,7 +484,7 @@ static void __cpuinit cache_shared_cpu_m
 static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
 {
 	struct _cpuid4_info	*this_leaf, *sibling_leaf;
-	unsigned int sibling;
+	int sibling;
 
 	this_leaf = CPUID4_INFO_IDX(cpu, index);
 	for_each_cpu_mask(sibling, this_leaf->shared_cpu_map) {
@@ -505,7 +506,7 @@ static void free_cache_attributes(unsign
 static int __cpuinit detect_cache_attributes(unsigned int cpu)
 {
 	struct _cpuid4_info	*this_leaf;
-	unsigned int		j;
+	unsigned long 		j;
 	int 			retval;
 	cpumask_t		oldmask;
 
@@ -523,6 +524,7 @@ static int __cpuinit detect_cache_attrib
 		goto out;
 
 	/* Do cpuid and store the results */
+	retval = 0;
 	for (j = 0; j < num_cache_leaves; j++) {
 		this_leaf = CPUID4_INFO_IDX(cpu, j);
 		retval = cpuid4_cache_lookup(j, this_leaf);
@@ -562,7 +564,7 @@ static struct _index_kobject *index_kobj
 static ssize_t show_##file_name						\
 			(struct _cpuid4_info *this_leaf, char *buf)	\
 {									\
-	return sprintf(buf, "%u\n", this_leaf->object + (val));		\
+	return sprintf (buf, "%lu\n", (unsigned long)this_leaf->object + val); \
 }
 
 show_one_plus(level, eax.split.level, 0);
@@ -573,7 +575,7 @@ show_one_plus(number_of_sets, ecx.split.
 
 static ssize_t show_size(struct _cpuid4_info *this_leaf, char *buf)
 {
-	return sprintf(buf, "%luK\n", this_leaf->size / 1024);
+	return sprintf (buf, "%luK\n", this_leaf->size / 1024);
 }
 
 static ssize_t show_shared_cpu_map(struct _cpuid4_info *this_leaf, char *buf)
@@ -678,11 +680,13 @@ static void cpuid4_cache_sysfs_exit(unsi
 
 static int __cpuinit cpuid4_cache_sysfs_init(unsigned int cpu)
 {
-	int retval;
 
-	retval = detect_cache_attributes(cpu);
-	if (retval < 0)
-		return retval;
+	if (num_cache_leaves == 0)
+		return -ENOENT;
+
+	detect_cache_attributes(cpu);
+	if (cpuid4_info[cpu] == NULL)
+		return -ENOENT;
 
 	/* Allocate all required memory */
 	cache_kobject[cpu] = kzalloc(sizeof(struct kobject), GFP_KERNEL);
@@ -704,9 +708,10 @@ err_out:
 /* Add/Remove cache interface for CPU device */
 static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 {
-	unsigned int i, cpu = sys_dev->id;
+	unsigned int cpu = sys_dev->id;
+	unsigned long i, j;
 	struct _index_kobject *this_object;
-	int retval;
+	int retval = 0;
 
 	retval = cpuid4_cache_sysfs_init(cpu);
 	if (unlikely(retval < 0))
@@ -722,13 +727,14 @@ static int __cpuinit cache_add_dev(struc
 		this_object->cpu = cpu;
 		this_object->index = i;
 		this_object->kobj.parent = cache_kobject[cpu];
-		kobject_set_name(&(this_object->kobj), "index%u", i);
+		kobject_set_name(&(this_object->kobj), "index%1lu", i);
 		this_object->kobj.ktype = &ktype_cache;
 		retval = kobject_register(&(this_object->kobj));
 		if (unlikely(retval)) {
-			while (i--)
+			for (j = 0; j < i; j++) {
 				kobject_unregister(
-					&(INDEX_KOBJECT_PTR(cpu,i)->kobj));
+					&(INDEX_KOBJECT_PTR(cpu,j)->kobj));
+			}
 			kobject_unregister(cache_kobject[cpu]);
 			cpuid4_cache_sysfs_exit(cpu);
 			break;
@@ -739,10 +745,9 @@ static int __cpuinit cache_add_dev(struc
 
 static void __cpuinit cache_remove_dev(struct sys_device * sys_dev)
 {
-	unsigned int i, cpu = sys_dev->id;
+	unsigned int cpu = sys_dev->id;
+	unsigned long i;
 
-	if (unlikely(cpuid4_info[cpu] == NULL))
-		return;
 	for (i = 0; i < num_cache_leaves; i++) {
 		cache_remove_shared_cpu_map(cpu, i);
 		kobject_unregister(&(INDEX_KOBJECT_PTR(cpu,i)->kobj));
@@ -777,9 +782,9 @@ static struct notifier_block __cpuinitda
     .notifier_call = cacheinfo_cpu_callback,
 };
 
-static int __init cache_sysfs_init(void)
+static int __cpuinit cache_sysfs_init(void)
 {
-	unsigned int i;
+	int i;
 
 	if (num_cache_leaves == 0)
 		return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-powerpc-fixup.patch
revert-gregkh-driver-block-device.patch
revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
git-dvb.patch
git-dvb-fixup-2.patch
infiniband-work-around-gcc-slub-problem.patch
git-input.patch
adbhid-produce-all-capslock-key-events.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
git-kbuild.patch
git-kvm.patch
git-libata-all.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61patch.patch
ide-arm-hack.patch
git-mips.patch
git-mmc.patch
git-mmc-fixup2.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-netdev-all.patch
e1000e-build-fix.patch
revert-8139too-clean-up-i-o-remapping.patch
git-net.patch
git-net-fixup.patch
net-atm-lecc-printk-warning-fix.patch
git-backlight.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
git-ocfs2.patch
revert-gregkh-pci-pci_bridge-device.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
fix-ide-legacy-mode-resources-fix.patch
git-s390.patch
git-scsi-misc.patch
advansys-printk-fix.patch
git-block-fixup.patch
git-block-fix-headers_check.patch
git-unionfs.patch
git-unionfs-fix-2.patch
fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
net-add-ath5k-wireless-driver-fix.patch
revert-x86_64-mm-intel_cacheinfo-adjustments.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
intel_cacheinfo-misc-section-annotation-fixes-fix.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
hpet-force-enable-on-vt8235-37-chipsets-fix.patch
x86-convert-cpu_sibling_map-to-be-a-per-cpu-variable-broke-ia64.patch
git-xfs.patch
git-xtensa.patch
i386-apic-fix-4-bit-apicid-assumption-of-mach-default.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
binfmt_flat-warning-fixes.patch
console-events-and-accessibility-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
md-software-raid-autodetect-dev-list-not-array-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
isolate-some-explicit-usage-of-task-tgid-fix-fix.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
