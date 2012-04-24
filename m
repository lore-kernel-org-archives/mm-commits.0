From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 24 Apr 2012 12:01:55 -0700
Message-ID: <20120424190158.C54BFA0162@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:47491 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab2DXTCA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Apr 2012 15:02:00 -0400
Received: by qabg24 with SMTP id g24so60911qab.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Apr 2012 12:01:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/caif/caif_hsi.c              |   10 ---------
 drivers/net/ethernet/atheros/atlx/atl1.c |   22 ---------------------
 drivers/net/ethernet/atheros/atlx/atl1.h |    3 --
 3 files changed, 35 deletions(-)

diff -puN drivers/net/caif/caif_hsi.c~linux-next-git-rejects drivers/net/caif/caif_hsi.c
--- a/drivers/net/caif/caif_hsi.c~linux-next-git-rejects
+++ a/drivers/net/caif/caif_hsi.c
@@ -1330,15 +1330,8 @@ static int cfhsi_open(struct net_device 
 
 static int cfhsi_close(struct net_device *ndev)
 {
-<<<<<<< HEAD
-	u8 *tx_buf, *rx_buf, *flip_buf;
-
-	/* Stop TXing */
-	netif_tx_stop_all_queues(cfhsi->ndev);
-=======
 	struct cfhsi *cfhsi = netdev_priv(ndev);
 	u8 *tx_buf, *rx_buf, *flip_buf;
->>>>>>> linux-next/akpm-end
 
 	/* going to shutdown driver */
 	set_bit(CFHSI_SHUTDOWN, &cfhsi->bits);
@@ -1371,10 +1364,7 @@ static int cfhsi_close(struct net_device
 	kfree(tx_buf);
 	kfree(rx_buf);
 	kfree(flip_buf);
-<<<<<<< HEAD
-=======
 	return 0;
->>>>>>> linux-next/akpm-end
 }
 
 static const struct net_device_ops cfhsi_ops = {
diff -puN drivers/net/ethernet/atheros/atlx/atl1.c~linux-next-git-rejects drivers/net/ethernet/atheros/atlx/atl1.c
--- a/drivers/net/ethernet/atheros/atlx/atl1.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -2517,27 +2517,6 @@ static irqreturn_t atl1_intr(int irq, vo
 	/* clear ISR status, and Enable CMB DMA/Disable Interrupt */
 	iowrite32(status | ISR_DIS_INT, adapter->hw.hw_addr + REG_ISR);
 
-<<<<<<< HEAD
-		/* check if PCIE PHY Link down */
-		if (status & ISR_PHY_LINKDOWN) {
-			if (netif_msg_intr(adapter))
-				dev_printk(KERN_DEBUG, &adapter->pdev->dev,
-					"pcie phy link down %x\n", status);
-			if (netif_running(adapter->netdev)) {	/* reset MAC */
-				iowrite32(0, adapter->hw.hw_addr + REG_IMR);
-				schedule_work(&adapter->reset_dev_task);
-				return IRQ_HANDLED;
-			}
-		}
-
-		/* check if DMA read/write error ? */
-		if (status & (ISR_DMAR_TO_RST | ISR_DMAW_TO_RST)) {
-			if (netif_msg_intr(adapter))
-				dev_printk(KERN_DEBUG, &adapter->pdev->dev,
-					"pcie DMA r/w error (status = 0x%x)\n",
-					status);
-			iowrite32(0, adapter->hw.hw_addr + REG_IMR);
-=======
 	/* check if SMB intr */
 	if (status & ISR_SMB)
 		atl1_inc_smb(adapter);
@@ -2549,7 +2528,6 @@ static irqreturn_t atl1_intr(int irq, vo
 				"pcie phy link down %x\n", status);
 		if (netif_running(adapter->netdev)) {	/* reset MAC */
 			atlx_irq_disable(adapter);
->>>>>>> linux-next/akpm-end
 			schedule_work(&adapter->reset_dev_task);
 			return IRQ_HANDLED;
 		}
diff -puN drivers/net/ethernet/atheros/atlx/atl1.h~linux-next-git-rejects drivers/net/ethernet/atheros/atlx/atl1.h
--- a/drivers/net/ethernet/atheros/atlx/atl1.h~linux-next-git-rejects
+++ a/drivers/net/ethernet/atheros/atlx/atl1.h
@@ -762,10 +762,7 @@ struct atl1_adapter {
 	u16 link_speed;
 	u16 link_duplex;
 	spinlock_t lock;
-<<<<<<< HEAD
-=======
 	struct napi_struct napi;
->>>>>>> linux-next/akpm-end
 	struct work_struct reset_dev_task;
 	struct work_struct link_chg_task;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
sound-usb-endpointc-suppress-warning.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

