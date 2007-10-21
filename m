From: akpm@linux-foundation.org
Subject: - pm-qos-infrastructure-and-interface-fix.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:50:21 -0700
Message-ID: <200710212350.l9LNoLMi000861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50146 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175AbXJUXvO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:51:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjan@infradead.org, lenb@kernel.org, mgross@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     pm-qos-infrastructure-and-interface-fix
has been removed from the -mm tree.  Its filename was
     pm-qos-infrastructure-and-interface-fix.patch

This patch was dropped because it was folded into pm-qos-infrastructure-and-interface.patch

------------------------------------------------------
Subject: pm-qos-infrastructure-and-interface-fix
From: Andrew Morton <akpm@linux-foundation.org>

kernel/pm_qos_params.c: In function 'pm_qos_power_open':
kernel/pm_qos_params.c:355: warning: cast to pointer from integer of different size
kernel/pm_qos_params.c: In function 'pm_qos_power_release':
kernel/pm_qos_params.c:370: warning: cast from pointer to integer of different size
kernel/pm_qos_params.c: In function 'pm_qos_power_write':
kernel/pm_qos_params.c:383: warning: cast from pointer to integer of different size

Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Mark Gross <mgross@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pm_qos_params.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/pm_qos_params.c~pm-qos-infrastructure-and-interface-fix kernel/pm_qos_params.c
--- a/kernel/pm_qos_params.c~pm-qos-infrastructure-and-interface-fix
+++ a/kernel/pm_qos_params.c
@@ -348,11 +348,11 @@ static char name[PID_NAME_LEN];
 static int pm_qos_power_open(struct inode *inode, struct file *filp)
 {
 	int ret;
-	int pm_qos_class;
+	long pm_qos_class;
 
 	pm_qos_class = find_pm_qos_object_by_minor(iminor(inode));
 	if (pm_qos_class >= 0) {
-		filp->private_data = (void *) pm_qos_class;
+		filp->private_data = (void *)pm_qos_class;
 		sprintf(name, "process_%d", current->pid);
 		ret = pm_qos_add_requirement(pm_qos_class, name,
 					PM_QOS_DEFAULT_VALUE);
@@ -367,7 +367,7 @@ static int pm_qos_power_release(struct i
 {
 	int pm_qos_class;
 
-	pm_qos_class = (int) filp->private_data;
+	pm_qos_class = (long)filp->private_data;
 	sprintf(name, "process_%d", current->pid);
 	pm_qos_remove_requirement(pm_qos_class, name);
 
@@ -380,7 +380,7 @@ static ssize_t pm_qos_power_write(struct
 	s32 value;
 	int pm_qos_class;
 
-	pm_qos_class = (int) filp->private_data;
+	pm_qos_class = (long)filp->private_data;
 	if (count != sizeof(s32))
 		return -EINVAL;
 	if (copy_from_user(&value, buf, sizeof(s32)))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic.patch
capabilities-clean-up-file-capability-reading.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
kexec-add-bss-to-resource-tree.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
nf_ct_alloc_hashtable-use-__gfp_nowarn.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
git-scsi-misc.patch
git-unionfs.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
git-x86.patch
fix-x86_64-mm-sched-clock-share.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-fix.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
sync_sb_inodes-propagate-errors.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
