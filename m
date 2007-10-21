From: akpm@linux-foundation.org
Subject: - memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:49:24 -0700
Message-ID: <200710212349.l9LNnOdZ000775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46959 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062AbXJUXuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:50:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, clameter@sgi.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     memcontrol-move-oom-task-exclusion-to-tasklist-fix
has been removed from the -mm tree.  Its filename was
     memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch

This patch was dropped because it was folded into memcontrol-move-oom-task-exclusion-to-tasklist.patch

------------------------------------------------------
Subject: memcontrol-move-oom-task-exclusion-to-tasklist-fix
From: Andrew Morton <akpm@linux-foundation.org>

In file included from include/linux/rmap.h:11,
                 from mm/filemap_xip.c:15:
include/linux/memcontrol.h: In function 'task_in_mem_cgroup':
include/linux/memcontrol.h:63: error: implicit declaration of function 'task_lock'
include/linux/memcontrol.h:64: error: dereferencing pointer to incomplete type
include/linux/memcontrol.h:64: error: dereferencing pointer to incomplete type
include/linux/memcontrol.h:65: error: implicit declaration of function 'task_unlock'
In file included from mm/filemap_xip.c:16:
include/linux/sched.h: At top level:
include/linux/sched.h:1709: warning: conflicting types for 'task_lock'
include/linux/sched.h:1709: error: static declaration of 'task_lock' follows non-static declaration
include/linux/memcontrol.h:63: error: previous implicit declaration of 'task_lock' was here
include/linux/sched.h:1714: warning: conflicting types for 'task_unlock'
include/linux/sched.h:1714: error: static declaration of 'task_unlock' follows non-static declaration
include/linux/memcontrol.h:65: error: previous implicit declaration of 'task_unlock' was here

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   11 +----------
 mm/memcontrol.c            |   10 ++++++++++
 2 files changed, 11 insertions(+), 10 deletions(-)

diff -puN include/linux/memcontrol.h~memcontrol-move-oom-task-exclusion-to-tasklist-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcontrol-move-oom-task-exclusion-to-tasklist-fix
+++ a/include/linux/memcontrol.h
@@ -45,6 +45,7 @@ extern unsigned long mem_cgroup_isolate_
 extern void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask);
 extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 					gfp_t gfp_mask);
+int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);
 
 static inline struct mem_cgroup *mm_cgroup(const struct mm_struct *mm)
 {
@@ -56,16 +57,6 @@ static inline void mem_cgroup_uncharge_p
 	mem_cgroup_uncharge(page_get_page_cgroup(page));
 }
 
-static inline int task_in_mem_cgroup(struct task_struct *task,
-				     const struct mem_cgroup *mem)
-{
-	int ret;
-	task_lock(task);
-	ret = task->mm && mm_cgroup(task->mm) == mem;
-	task_unlock(task);
-	return ret;
-}
-
 #else /* CONFIG_CGROUP_MEM_CONT */
 static inline void mm_init_cgroup(struct mm_struct *mm,
 					struct task_struct *p)
diff -puN mm/memcontrol.c~memcontrol-move-oom-task-exclusion-to-tasklist-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcontrol-move-oom-task-exclusion-to-tasklist-fix
+++ a/mm/memcontrol.c
@@ -170,6 +170,16 @@ static void __mem_cgroup_move_lists(stru
 		list_move(&pc->lru, &pc->mem_cgroup->inactive_list);
 }
 
+int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
+{
+	int ret;
+
+	task_lock(task);
+	ret = task->mm && mm_cgroup(task->mm) == mem;
+	task_unlock(task);
+	return ret;
+}
+
 /*
  * This routine assumes that the appropriate zone's lru lock is already held
  */
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
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
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
