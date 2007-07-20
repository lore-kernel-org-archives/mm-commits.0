From: akpm@linux-foundation.org
Subject: - containersv10-add-procfs-interface-fix.patch removed from -mm tree
Date: Fri, 20 Jul 2007 13:29:32 -0700
Message-ID: <200707202029.l6KKTWku014885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33762 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764238AbXGTUaj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 16:30:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@in.ibm.com, dev@openvz.org, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, menage@google.com, pj@sgi.com, serue@us.ibm.com, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     containersv10-add-procfs-interface-fix
has been removed from the -mm tree.  Its filename was
     containersv10-add-procfs-interface-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: containersv10-add-procfs-interface-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/container.h |    2 ++
 kernel/container.c        |   13 ++++++++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff -puN include/linux/container.h~containersv10-add-procfs-interface-fix include/linux/container.h
--- a/include/linux/container.h~containersv10-add-procfs-interface-fix
+++ a/include/linux/container.h
@@ -28,6 +28,8 @@ extern void container_fork(struct task_s
 extern void container_fork_callbacks(struct task_struct *p);
 extern void container_exit(struct task_struct *p, int run_callbacks);
 
+extern struct file_operations proc_container_operations;
+
 /* Per-subsystem/per-container state maintained by the system. */
 struct container_subsys_state {
 	/* The container that this subsystem is attached to. Useful
diff -puN kernel/container.c~containersv10-add-procfs-interface-fix kernel/container.c
--- a/kernel/container.c~containersv10-add-procfs-interface-fix
+++ a/kernel/container.c
@@ -246,7 +246,7 @@ static int container_mkdir(struct inode 
 static int container_rmdir(struct inode *unused_dir, struct dentry *dentry);
 static int container_populate_dir(struct container *cont);
 static struct inode_operations container_dir_inode_operations;
-struct file_operations proc_containerstats_operations;
+static struct file_operations proc_containerstats_operations;
 
 static struct inode *container_new_inode(mode_t mode, struct super_block *sb)
 {
@@ -1562,11 +1562,12 @@ static int proc_container_show(struct se
 		struct container *cont;
 		int subsys_id;
 		int count = 0;
+
 		/* Skip this hierarchy if it has no active subsystems */
-		if (!root->subsys_bits) continue;
-		for_each_subsys(root, ss) {
+		if (!root->subsys_bits)
+			continue;
+		for_each_subsys(root, ss)
 			seq_printf(m, "%s%s", count++ ? "," : "", ss->name);
-		}
 		seq_putc(m, ':');
 		get_first_subsys(&root->top_container, NULL, &subsys_id);
 		cont = task_container(tsk, subsys_id);
@@ -1604,6 +1605,7 @@ static int proc_containerstats_show(stru
 {
 	int i;
 	struct containerfs_root *root;
+
 	mutex_lock(&container_mutex);
 	seq_puts(m, "Hierarchies:\n");
 	for_each_root(root) {
@@ -1637,12 +1639,13 @@ static int containerstats_open(struct in
 	return single_open(file, proc_containerstats_show, 0);
 }
 
-struct file_operations proc_containerstats_operations = {
+static struct file_operations proc_containerstats_operations = {
 	.open = containerstats_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
 };
+
 /**
  * container_fork - attach newly forked task to its parents container.
  * @tsk: pointer to task_struct of forking parent process.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
git-acpi-fix-git-rejects.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
git-dvb.patch
adbhid-produce-all-capslock-key-events-fix.patch
git-kvm.patch
git-leds.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
git-mtd.patch
mtd-potential-leak-in-rfd_ftl_add_mtd-fix.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
git-scsi-misc.patch
aacraid-rename-check_reset.patch
git-unionfs.patch
git-block-vs-git-unionfs.patch
x86_64-clean-up-apicid_to_node-declaration.patch
clockevents-fix-resume-logic-xen-fix.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-xfs.patch
git-xfs-fixup.patch
git-kgdb-fixup-2.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
fs-9p-convc-error-path-fix.patch
loop-use-unlocked_ioctl.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
