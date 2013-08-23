From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 23 Aug 2013 11:57:48 -0700
Message-ID: <5217b0ac.1X+8gOD65zionho/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab3HWS5t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Aug 2013 14:57:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: + linux-next-git-rejects.patch added to -mm tree
To: akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Fri, 23 Aug 2013 11:57:48 -0700


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/dts/tegra20-seaboard.dts        |    6 ------
 arch/arm/boot/dts/tegra20-trimslice.dts       |    6 ------
 arch/arm64/kernel/perf_event.c                |    4 ----
 drivers/net/wireless/iwlwifi/mvm/time-event.c |    4 ----
 drivers/net/wireless/iwlwifi/pcie/trans.c     |    7 +------
 include/linux/inetdevice.h                    |    3 ---
 6 files changed, 1 insertion(+), 29 deletions(-)

diff -puN arch/arm/boot/dts/tegra20-seaboard.dts~linux-next-git-rejects arch/arm/boot/dts/tegra20-seaboard.dts
--- a/arch/arm/boot/dts/tegra20-seaboard.dts~linux-next-git-rejects
+++ a/arch/arm/boot/dts/tegra20-seaboard.dts
@@ -828,13 +828,7 @@
 			regulator-min-microvolt = <5000000>;
 			regulator-max-microvolt = <5000000>;
 			enable-active-high;
-<<<<<<< HEAD
-			gpio = <&gpio 24 0>; /* PD0 */
-			regulator-always-on;
-			regulator-boot-on;
-=======
 			gpio = <&gpio TEGRA_GPIO(D, 0) 0>;
->>>>>>> linux-next/akpm-base
 		};
 	};
 
diff -puN arch/arm/boot/dts/tegra20-trimslice.dts~linux-next-git-rejects arch/arm/boot/dts/tegra20-trimslice.dts
--- a/arch/arm/boot/dts/tegra20-trimslice.dts~linux-next-git-rejects
+++ a/arch/arm/boot/dts/tegra20-trimslice.dts
@@ -420,11 +420,6 @@
 			regulator-min-microvolt = <5000000>;
 			regulator-max-microvolt = <5000000>;
 			enable-active-high;
-<<<<<<< HEAD
-			gpio = <&gpio 170 0>; /* PV2 */
-			regulator-always-on;
-			regulator-boot-on;
-=======
 			gpio = <&gpio TEGRA_GPIO(V, 2) 0>;
 		};
 
@@ -444,7 +439,6 @@
 			regulator-min-microvolt = <1050000>;
 			regulator-max-microvolt = <1050000>;
 			regulator-always-on;
->>>>>>> linux-next/akpm-base
 		};
 	};
 
diff -puN arch/arm64/kernel/perf_event.c~linux-next-git-rejects arch/arm64/kernel/perf_event.c
--- a/arch/arm64/kernel/perf_event.c~linux-next-git-rejects
+++ a/arch/arm64/kernel/perf_event.c
@@ -325,14 +325,10 @@ validate_event(struct pmu_hw_events *hw_
 	if (is_software_event(event))
 		return 1;
 
-<<<<<<< HEAD
-	if (event->pmu != leader_pmu || event->state <= PERF_EVENT_STATE_OFF)
-=======
 	if (event->pmu != leader_pmu || event->state < PERF_EVENT_STATE_OFF)
 		return 1;
 
 	if (event->state == PERF_EVENT_STATE_OFF && !event->attr.enable_on_exec)
->>>>>>> linux-next/akpm-base
 		return 1;
 
 	return armpmu->get_event_idx(hw_events, &fake_event) >= 0;
diff -puN drivers/net/wireless/iwlwifi/mvm/time-event.c~linux-next-git-rejects drivers/net/wireless/iwlwifi/mvm/time-event.c
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c~linux-next-git-rejects
+++ a/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -199,11 +199,7 @@ static void iwl_mvm_te_handle_notif(stru
 		 * and know the dtim period.
 		 */
 		iwl_mvm_te_check_disconnect(mvm, te_data->vif,
-<<<<<<< HEAD
-			"No assocation and the time event is over already...");
-=======
 			"No association and the time event is over already...");
->>>>>>> linux-next/akpm-base
 		iwl_mvm_te_clear_data(mvm, te_data);
 	} else if (le32_to_cpu(notif->action) & TE_V2_NOTIF_HOST_EVENT_START) {
 		te_data->running = true;
diff -puN drivers/net/wireless/iwlwifi/pcie/trans.c~linux-next-git-rejects drivers/net/wireless/iwlwifi/pcie/trans.c
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c~linux-next-git-rejects
+++ a/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1,4 +1,4 @@
-/******************************************************************************
+q/******************************************************************************
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -1401,13 +1401,8 @@ struct iwl_trans *iwl_trans_pcie_alloc(s
 	spin_lock_init(&trans_pcie->reg_lock);
 	init_waitqueue_head(&trans_pcie->ucode_write_waitq);
 
-<<<<<<< HEAD
-	if (pci_enable_device(pdev)) {
-		err = -ENODEV;
-=======
 	err = pci_enable_device(pdev);
 	if (err)
->>>>>>> linux-next/akpm-base
 		goto out_no_pci;
 
 	if (!cfg->base_params->pcie_l1_allowed) {
diff -puN include/linux/inetdevice.h~linux-next-git-rejects include/linux/inetdevice.h
--- a/include/linux/inetdevice.h~linux-next-git-rejects
+++ a/include/linux/inetdevice.h
@@ -12,8 +12,6 @@
 #include <linux/sysctl.h>
 #include <linux/rtnetlink.h>
 
-<<<<<<< HEAD
-=======
 enum
 {
 	IPV4_DEVCONF_FORWARDING=1,
@@ -49,7 +47,6 @@ enum
 
 #define IPV4_DEVCONF_MAX (__IPV4_DEVCONF_MAX - 1)
 
->>>>>>> linux-next/akpm-base
 struct ipv4_devconf {
 	void	*sysctl;
 	int	data[IPV4_DEVCONF_MAX];
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
block-support-embedded-device-command-line-partition.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix.patch
mm-hotplug-verify-hotplug-memory-range-fix.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch
mm-track-vma-changes-with-vm_softdirty-bit-fix.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
revert-selinux-do-not-handle-seclabel-as-a-special-flag.patch
memcg-trivial-cleanups.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

