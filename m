From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:10:58 -0700
Message-ID: <51db0ec2.Md9rJszcuGYOnAdr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab3GHTK7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:10:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:10:58 -0700


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-shmobile/Kconfig |    8 --------
 arch/arm64/xen/hypercall.S     |    3 ---
 drivers/net/phy/phy.c          |   10 ----------
 include/linux/cgroup.h         |   20 --------------------
 4 files changed, 41 deletions(-)

diff -puN arch/arm/mach-shmobile/Kconfig~linux-next-git-rejects arch/arm/mach-shmobile/Kconfig
--- a/arch/arm/mach-shmobile/Kconfig~linux-next-git-rejects
+++ a/arch/arm/mach-shmobile/Kconfig
@@ -23,10 +23,6 @@ config ARCH_R8A73A4
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARM_GIC
 	select CPU_V7
-<<<<<<< HEAD
-	select HAVE_ARM_ARCH_TIMER
-=======
->>>>>>> linux-next/akpm-base
 	select SH_CLK_CPG
 	select RENESAS_IRQC
 	select ARCH_HAS_CPUFREQ
@@ -64,10 +60,6 @@ config ARCH_R8A7790
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARM_GIC
 	select CPU_V7
-<<<<<<< HEAD
-	select HAVE_ARM_ARCH_TIMER
-=======
->>>>>>> linux-next/akpm-base
 	select SH_CLK_CPG
 	select RENESAS_IRQC
 
diff -puN arch/arm64/xen/hypercall.S~linux-next-git-rejects arch/arm64/xen/hypercall.S
--- a/arch/arm64/xen/hypercall.S~linux-next-git-rejects
+++ a/arch/arm64/xen/hypercall.S
@@ -79,10 +79,7 @@ HYPERCALL2(hvm_op);
 HYPERCALL2(memory_op);
 HYPERCALL2(physdev_op);
 HYPERCALL3(vcpu_op);
-<<<<<<< HEAD
-=======
 HYPERCALL1(tmem_op);
->>>>>>> linux-next/akpm-base
 
 ENTRY(privcmd_call)
 	mov x16, x0
diff -puN drivers/net/phy/phy.c~linux-next-git-rejects drivers/net/phy/phy.c
--- a/drivers/net/phy/phy.c~linux-next-git-rejects
+++ a/drivers/net/phy/phy.c
@@ -918,16 +918,6 @@ void phy_state_machine(struct work_struc
 
 	queue_delayed_work(system_power_efficient_wq, &phydev->state_queue,
 			PHY_STATE_TIME * HZ);
-<<<<<<< HEAD
-=======
-}
-
-void phy_mac_interrupt(struct phy_device *phydev, int new_link)
-{
-	cancel_work_sync(&phydev->phy_queue);
-	phydev->link = new_link;
-	schedule_work(&phydev->phy_queue);
->>>>>>> linux-next/akpm-base
 }
 EXPORT_SYMBOL(phy_mac_interrupt);
 
diff -puN include/linux/cgroup.h~linux-next-git-rejects include/linux/cgroup.h
--- a/include/linux/cgroup.h~linux-next-git-rejects
+++ a/include/linux/cgroup.h
@@ -261,25 +261,6 @@ enum {
 	 *
 	 * - Remount is disallowed.
 	 *
-<<<<<<< HEAD
-	 * - rename(2) is disallowed.
-	 *
-	 * - "tasks" is removed.  Everything should be at process
-	 *   granularity.  Use "cgroup.procs" instead.
-	 *
-	 * - "release_agent" and "notify_on_release" are removed.
-	 *   Replacement notification mechanism will be implemented.
-	 *
-	 * - cpuset: tasks will be kept in empty cpusets when hotplug happens
-	 *   and take masks of ancestors with non-empty cpus/mems, instead of
-	 *   being moved to an ancestor.
-	 *
-	 * - cpuset: a task can be moved into an empty cpuset, and again it
-	 *   takes masks of ancestors.
-	 *
-	 * - memcg: use_hierarchy is on by default and the cgroup file for
-	 *   the flag is not created.
-=======
 	 * - "tasks" is removed.  Everything should be at process
 	 *   granularity.  Use "cgroup.procs" instead.
 	 *
@@ -299,7 +280,6 @@ enum {
 	 *   the flag is not created.
 	 *
 	 * - blkcg: blk-throttle becomes properly hierarchical.
->>>>>>> linux-next/akpm-base
 	 */
 	CGRP_ROOT_SANE_BEHAVIOR	= (1 << 0),
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
mm.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix-fix.patch
include-linux-mmzoneh-cleanups.patch
drop_caches-add-some-documentation-and-info-messsge.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

