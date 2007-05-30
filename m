From: akpm@linux-foundation.org
Subject: + containersv10-add-tasks-file-interface-fix.patch added to -mm tree
Date: Wed, 30 May 2007 00:15:00 -0700
Message-ID: <200705300714.l4U7Exu0021315@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751522AbXE3HQH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 03:16:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, balbir@in.ibm.com, dev@openvz.org, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, menage@google.com, pj@sgi.com, serue@us.ibm.com, vatsa@in.ibm.com


The patch titled
     containersv10-add-tasks-file-interface-fix
has been added to the -mm tree.  Its filename is
     containersv10-add-tasks-file-interface-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -679,7 +679,6 @@ static void get_first_subsys(const struc
  * Call holding container_mutex.  May take task_lock of
  * the task 'pid' during call.
  */
-
 static int attach_task(struct container *cont, struct task_struct *tsk)
 {
 	int retval = 0;
@@ -688,8 +687,8 @@ static int attach_task(struct container 
 	struct css_group *cg = &tsk->containers;
 	struct containerfs_root *root = cont->root;
 	int i;
-
 	int subsys_id;
+
 	get_first_subsys(cont, NULL, &subsys_id);
 
 	/* Nothing to do if the task is already in that container */
@@ -739,9 +738,7 @@ static int attach_task(struct container 
 /*
  * Attach task with pid 'pid' to container 'cont'. Call with
  * container_mutex, may take task_lock of task
- *
  */
-
 static int attach_task_by_pid(struct container *cont, char *pidbuf)
 {
 	pid_t pid;
@@ -798,7 +795,8 @@ static ssize_t container_common_file_wri
 		return -E2BIG;
 
 	/* +1 for nul-terminator */
-	if ((buffer = kmalloc(nbytes + 1, GFP_KERNEL)) == 0)
+	buffer = kmalloc(nbytes + 1, GFP_KERNEL);
+	if (buffer == NULL)
 		return -ENOMEM;
 
 	if (copy_from_user(buffer, userbuf, nbytes)) {
@@ -1029,16 +1027,16 @@ int container_add_files(struct container
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
@@ -1060,9 +1058,6 @@ int __container_task_count(const struct 
  * be freed by release() when the file is closed.  The array is used
  * to sprintf the PIDs and then used by read().
  */
-
-/* containers_tasks_read array */
-
 struct ctr_struct {
 	char *buf;
 	int bufsz;
@@ -1081,9 +1076,9 @@ static int pid_array_load(pid_t *pidarra
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
@@ -1178,10 +1173,11 @@ static ssize_t container_tasks_read(stru
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
 
@@ -1196,7 +1192,6 @@ static int container_tasks_release(struc
 /*
  * for the common functions, 'private' gives the type of file
  */
-
 static struct cftype cft_tasks = {
 	.name = "tasks",
 	.open = container_tasks_open,
@@ -1214,7 +1209,8 @@ static int container_populate_dir(struct
 	/* First clear out any existing files */
 	container_clear_directory(cont->dentry);
 
-	if ((err = container_add_file(cont, &cft_tasks)) < 0)
+	err = container_add_file(cont, &cft_tasks);
+	if (err < 0)
 		return err;
 
 	for_each_subsys(cont->root, ss) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slub-more-documentation-fix.patch
ntfs_init_locked_inode-fix-array-indexing.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm-master.patch
git-cpufreq-fix.patch
8xx-mpc885ads-pcmcia-support.patch
fix-gregkh-driver-dmi-based-module-autoloading.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
driver-core-check-return-code-of-sysfs_create_link.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-input.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
git-leds-fixup.patch
git-mips-fixup.patch
git-mtd.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
git-ubi.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-pciseg.patch
sh-support-older-gccs.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-unionfs.patch
fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
git-watchdog.patch
git-wireless.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
git-xfs.patch
git-cryptodev.patch
fix-possible-leakage-of-blocks-in-udf-tidy.patch
potential-parse-error-in-ifdef.patch
e1000-restore-netif_poll_enable-call-but-make-sure-irqs-are-off.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
change-zonelist-order-v6-zonelist-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
freezer-run-show_state-when-freezing-times-out.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty-fix.patch
mpu401-warning-fixes.patch
procfs-directory-entry-cleanup-fix.patch
vdso-print-fatal-signals.patch
reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
reiser4.patch
reiser4-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
