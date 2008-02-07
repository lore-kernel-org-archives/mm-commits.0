From: akpm@linux-foundation.org
Subject: - introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 06 Feb 2008 19:31:36 -0800
Message-ID: <200802070331.m173VHX5013926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58796 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978AbYBGDbZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 22:31:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bwalle@suse.de, mm-commits@vger.kernel.org


The patch titled
     introduce-flags-for-reserve_bootmem-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch

This patch was dropped because it was folded into introduce-flags-for-reserve_bootmem.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: introduce-flags-for-reserve_bootmem-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#872: FILE: arch/x86/kernel/setup_32.c:486:
+			reserve_bootmem(crash_base, crash_size, BOOTMEM_DEFAULT);

WARNING: line over 80 characters
#916: FILE: arch/x86/kernel/setup_32.c:562:
+			reserve_bootmem(ramdisk_image, ramdisk_size, BOOTMEM_DEFAULT);

WARNING: line over 80 characters
#1058: FILE: mm/bootmem.c:114:
+static int __init reserve_bootmem_core(bootmem_data_t *bdata, unsigned long addr,

total: 0 errors, 3 warnings, 833 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup_32.c |    3 ++-
 mm/bootmem.c               |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/setup_32.c~introduce-flags-for-reserve_bootmem-checkpatch-fixes arch/x86/kernel/setup_32.c
--- a/arch/x86/kernel/setup_32.c~introduce-flags-for-reserve_bootmem-checkpatch-fixes
+++ a/arch/x86/kernel/setup_32.c
@@ -489,7 +489,8 @@ static void __init reserve_crashkernel(v
 					(unsigned long)(total_mem >> 20));
 			crashk_res.start = crash_base;
 			crashk_res.end   = crash_base + crash_size - 1;
-			reserve_bootmem(crash_base, crash_size, BOOTMEM_DEFAULT);
+			reserve_bootmem(crash_base, crash_size,
+					BOOTMEM_DEFAULT);
 		} else
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"you have to specify a base address\n");
diff -puN mm/bootmem.c~introduce-flags-for-reserve_bootmem-checkpatch-fixes mm/bootmem.c
--- a/mm/bootmem.c~introduce-flags-for-reserve_bootmem-checkpatch-fixes
+++ a/mm/bootmem.c
@@ -111,8 +111,8 @@ static unsigned long __init init_bootmem
  * might be used for boot-time allocations - or it might get added
  * to the free page pool later on.
  */
-static int __init reserve_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
-					unsigned long size, int flags)
+static int __init reserve_bootmem_core(bootmem_data_t *bdata,
+			unsigned long addr, unsigned long size, int flags)
 {
 	unsigned long sidx, eidx;
 	unsigned long i;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names.patch
cgroup-simplify-space-stripping.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-mm_cgroup-to-header-file.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent.patch
cpusets-update_cpumask-revision.patch
drivers-edac-add-marvell-mv64x60-driver.patch
introduce-flags-for-reserve_bootmem.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
introduce-flags-for-reserve_bootmem-powerpc-fix.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
