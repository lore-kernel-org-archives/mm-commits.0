From: akpm@linux-foundation.org
Subject: + containersv10-add-procfs-interface-fix.patch added to -mm tree
Date: Wed, 30 May 2007 00:15:13 -0700
Message-ID: <200705300715.l4U7FCVB021359@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbXE3HP5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 03:15:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, balbir@in.ibm.com, dev@openvz.org, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, menage@google.com, pj@sgi.com, serue@us.ibm.com, vatsa@in.ibm.com


The patch titled
     containersv10-add-procfs-interface-fix
has been added to the -mm tree.  Its filename is
     containersv10-add-procfs-interface-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1556,11 +1556,12 @@ static int proc_container_show(struct se
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
@@ -1598,6 +1599,7 @@ static int proc_containerstats_show(stru
 {
 	int i;
 	struct containerfs_root *root;
+
 	mutex_lock(&container_mutex);
 	seq_puts(m, "Hierarchies:\n");
 	for_each_root(root) {
@@ -1631,12 +1633,13 @@ static int containerstats_open(struct in
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
