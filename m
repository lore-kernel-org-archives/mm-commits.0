From: akpm@linux-foundation.org
Subject: - introduce-flags-for-reserve_bootmem-powerpc-fix.patch removed from -mm tree
Date: Wed, 06 Feb 2008 19:31:39 -0800
Message-ID: <200802070331.m173VKcr013929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43798 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758099AbYBGDbf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 22:31:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, bwalle@suse.de, ebiederm@xmission.com, paulus@samba.org, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     introduce-flags-for-reserve_bootmem-powerpc-fix
has been removed from the -mm tree.  Its filename was
     introduce-flags-for-reserve_bootmem-powerpc-fix.patch

This patch was dropped because it was folded into introduce-flags-for-reserve_bootmem.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: introduce-flags-for-reserve_bootmem-powerpc-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Bernhard Walle <bwalle@suse.de>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mem.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/mm/mem.c~introduce-flags-for-reserve_bootmem-powerpc-fix arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~introduce-flags-for-reserve_bootmem-powerpc-fix
+++ a/arch/powerpc/mm/mem.c
@@ -253,12 +253,13 @@ void __init do_init_bootmem(void)
 				     lmb_size_bytes(&lmb.reserved, i) - 1;
 		if (addr < total_lowmem)
 			reserve_bootmem(lmb.reserved.region[i].base,
-					lmb_size_bytes(&lmb.reserved, i));
+					lmb_size_bytes(&lmb.reserved, i),
+					BOOTMEM_DEFAULT);
 		else if (lmb.reserved.region[i].base < total_lowmem) {
 			unsigned long adjusted_size = total_lowmem -
 				      lmb.reserved.region[i].base;
 			reserve_bootmem(lmb.reserved.region[i].base,
-					adjusted_size);
+					adjusted_size, BOOTMEM_DEFAULT);
 		}
 	}
 #else
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
