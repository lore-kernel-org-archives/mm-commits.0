From: akpm@linux-foundation.org
Subject: - containersv10-add-tasks-file-interface-fix.patch removed from -mm tree
Date: Fri, 20 Jul 2007 13:29:11 -0700
Message-ID: <200707202029.l6KKTBRB014862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54662 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760759AbXGTUaK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 16:30:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@in.ibm.com, dev@openvz.org, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, menage@google.com, pj@sgi.com, serue@us.ibm.com, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     containersv10-add-tasks-file-interface-fix
has been removed from the -mm tree.  Its filename was
     containersv10-add-tasks-file-interface-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: containersv10-add-tasks-file-interface-fix
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

 kernel/container.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff -puN kernel/container.c~containersv10-add-tasks-file-interface-fix kernel/container.c
--- a/kernel/container.c~containersv10-add-tasks-file-interface-fix
+++ a/kernel/container.c
@@ -680,7 +680,6 @@ static void get_first_subsys(const struc
  * Call holding container_mutex.  May take task_lock of
  * the task 'pid' during call.
  */
-
 static int attach_task(struct container *cont, struct task_struct *tsk)
 {
 	int retval = 0;
@@ -689,8 +688,8 @@ static int attach_task(struct container 
 	struct css_group *cg = &tsk->containers;
 	struct containerfs_root *root = cont->root;
 	int i;
-
 	int subsys_id;
+
 	get_first_subsys(cont, NULL, &subsys_id);
 
 	/* Nothing to do if the task is already in that container */
@@ -740,9 +739,7 @@ static int attach_task(struct container 
 /*
  * Attach task with pid 'pid' to container 'cont'. Call with
  * container_mutex, may take task_lock of task
- *
  */
-
 static int attach_task_by_pid(struct container *cont, char *pidbuf)
 {
 	pid_t pid;
@@ -799,7 +796,8 @@ static ssize_t container_common_file_wri
 		return -E2BIG;
 
 	/* +1 for nul-terminator */
-	if ((buffer = kmalloc(nbytes + 1, GFP_KERNEL)) == 0)
+	buffer = kmalloc(nbytes + 1, GFP_KERNEL);
+	if (buffer == NULL)
 		return -ENOMEM;
 
 	if (copy_from_user(buffer, userbuf, nbytes)) {
@@ -1030,16 +1028,16 @@ int container_add_files(struct container
  * time-efficient but less space-efficient with more linked lists
  * running through each container and the css_group structures that
  * referenced it. Must be called with tasklist_lock held for read or
- * write or in an rcu critical section. */
-
+ * write or in an rcu critical section.
+ */
 int __container_task_count(const struct container *cont)
 {
 	int count = 0;
 	struct task_struct *g, *p;
 	struct container_subsys_state *css;
 	int subsys_id;
-	get_first_subsys(cont, &css, &subsys_id);
 
+	get_first_subsys(cont, &css, &subsys_id);
 	do_each_thread(g, p) {
 		if (task_subsys_state(p, subsys_id) == css)
 			count ++;
@@ -1061,9 +1059,6 @@ int __container_task_count(const struct 
  * be freed by release() when the file is closed.  The array is used
  * to sprintf the PIDs and then used by read().
  */
-
-/* containers_tasks_read array */
-
 struct ctr_struct {
 	char *buf;
 	int bufsz;
@@ -1082,9 +1077,9 @@ static int pid_array_load(pid_t *pidarra
 	struct task_struct *g, *p;
 	struct container_subsys_state *css;
 	int subsys_id;
+
 	get_first_subsys(cont, &css, &subsys_id);
 	rcu_read_lock();
-
 	do_each_thread(g, p) {
 		if (task_subsys_state(p, subsys_id) == css) {
 			pidarray[n++] = pid_nr(task_pid(p));
@@ -1179,10 +1174,11 @@ static ssize_t container_tasks_read(stru
 {
 	struct ctr_struct *ctr = file->private_data;
 
-        return simple_read_from_buffer(buf, nbytes, ppos, ctr->buf, ctr->bufsz);
+	return simple_read_from_buffer(buf, nbytes, ppos, ctr->buf, ctr->bufsz);
 }
 
-static int container_tasks_release(struct inode *unused_inode, struct file *file)
+static int container_tasks_release(struct inode *unused_inode,
+					struct file *file)
 {
 	struct ctr_struct *ctr;
 
@@ -1197,7 +1193,6 @@ static int container_tasks_release(struc
 /*
  * for the common functions, 'private' gives the type of file
  */
-
 static struct cftype cft_tasks = {
 	.name = "tasks",
 	.open = container_tasks_open,
@@ -1215,7 +1210,8 @@ static int container_populate_dir(struct
 	/* First clear out any existing files */
 	container_clear_directory(cont->dentry);
 
-	if ((err = container_add_file(cont, &cft_tasks)) < 0)
+	err = container_add_file(cont, &cft_tasks);
+	if (err < 0)
 		return err;
 
 	for_each_subsys(cont->root, ss) {
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
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
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
