From: akpm@linux-foundation.org
Subject: - memory-controller-memory-accounting-v7-fix.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:48:41 -0700
Message-ID: <200710212348.l9LNmftC000734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585AbXJUXzN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:55:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Valdis.Kletnieks@vt.edu, balbir@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     memory-controller-memory-accounting-v7-fix
has been removed from the -mm tree.  Its filename was
     memory-controller-memory-accounting-v7-fix.patch

This patch was dropped because it was folded into memory-controller-memory-accounting-v7.patch

------------------------------------------------------
Subject: memory-controller-memory-accounting-v7-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/memory.c~memory-controller-memory-accounting-v7-fix mm/memory.c
--- a/mm/memory.c~memory-controller-memory-accounting-v7-fix
+++ a/mm/memory.c
@@ -1132,7 +1132,7 @@ static int insert_page(struct mm_struct 
 {
 	int retval;
 	pte_t *pte;
-	spinlock_t *ptl;  
+	spinlock_t *ptl;
 
 	retval = mem_cgroup_charge(page, mm);
 	if (retval)
@@ -1157,6 +1157,7 @@ static int insert_page(struct mm_struct 
 	set_pte_at(mm, addr, pte, mk_pte(page, prot));
 
 	retval = 0;
+	pte_unmap_unlock(pte, ptl);
 	return retval;
 out_unlock:
 	pte_unmap_unlock(pte, ptl);
@@ -2184,8 +2185,8 @@ static int do_anonymous_page(struct mm_s
 	if (!page)
 		goto oom;
 
-		if (mem_cgroup_charge(page, mm))
-			goto oom_free_page;
+	if (mem_cgroup_charge(page, mm))
+		goto oom_free_page;
 
 	entry = mk_pte(page, vma->vm_page_prot);
 	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
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
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
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
