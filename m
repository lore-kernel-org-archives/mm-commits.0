From: akpm@linux-foundation.org
Subject: - git-e1000-fixup.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:42:15 -0700
Message-ID: <200703292342.l2TNgGR4015485@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43319 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945960AbXC2XmT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:42:19 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l2TNgGU2004445
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2007 16:42:16 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-e1000-fixup
has been removed from the -mm tree.  Its filename was
     git-e1000-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-e1000-fixup
From: Andrew Morton <akpm@osdl.org>

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/e1000/e1000_main.c |   37 +++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff -puN drivers/net/e1000/e1000_main.c~git-e1000-fixup drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~git-e1000-fixup
+++ a/drivers/net/e1000/e1000_main.c
@@ -979,24 +979,49 @@ e1000_probe(struct pci_dev *pdev,
 			goto err_flashmap;
 	}
 
-	if (e1000_check_phy_reset_block(&adapter->hw))
+	if ((err = e1000_init_mac_params(&adapter->hw)))
+		goto err_hw_init;
+
+	if ((err = e1000_init_nvm_params(&adapter->hw)))
+		goto err_hw_init;
+
+	if ((err = e1000_init_phy_params(&adapter->hw)))
+		goto err_hw_init;
+
+	e1000_get_bus_info(&adapter->hw);
+
+	e1000_init_script_state_82541(&adapter->hw, TRUE);
+	e1000_set_tbi_compatibility_82543(&adapter->hw, TRUE);
+
+	adapter->hw.phy.wait_for_link = FALSE;
+	adapter->hw.mac.adaptive_ifs = TRUE;
+
+	/* Copper options */
+
+	if (adapter->hw.media_type == e1000_media_type_copper) {
+		adapter->hw.phy.mdix = AUTO_ALL_MODES;
+		adapter->hw.phy.disable_polarity_correction = FALSE;
+		adapter->hw.phy.ms_type = e1000_ms_hw_default;
+	}
+
+	if (e1000_check_reset_block(&adapter->hw))
 		DPRINTK(PROBE, INFO, "PHY reset is blocked due to SOL/IDER session.\n");
 
-	if (adapter->hw.mac_type >= e1000_82543) {
+	if (adapter->hw.mac.type >= e1000_82543) {
 		netdev->features = NETIF_F_SG |
 				   NETIF_F_HW_CSUM |
 				   NETIF_F_HW_VLAN_TX |
 				   NETIF_F_HW_VLAN_RX |
 				   NETIF_F_HW_VLAN_FILTER;
-		if (adapter->hw.mac_type == e1000_ich8lan)
+		if (adapter->hw.mac.type == e1000_ich8lan)
 			netdev->features &= ~NETIF_F_HW_VLAN_FILTER;
 	}
 
-	if ((adapter->hw.mac_type >= e1000_82544) &&
-	   (adapter->hw.mac_type != e1000_82547))
+	if ((adapter->hw.mac.type >= e1000_82544) &&
+	   (adapter->hw.mac.type != e1000_82547))
 		netdev->features |= NETIF_F_TSO;
 
-	if (adapter->hw.mac_type > e1000_82547_rev_2)
+	if (adapter->hw.mac.type > e1000_82547_rev_2)
 		netdev->features |= NETIF_F_TSO6;
 	if (pci_using_dac)
 		netdev->features |= NETIF_F_HIGHDMA;
_

Patches currently in -mm which might be from akpm@osdl.org are

git-powerpc.patch
git-ia64.patch
git-ieee1394.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
git-ubi.patch
git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
lumpy-reclaim-v4.patch
deprecate-smbfs-in-favour-of-cifs.patch
block_write_full_page-handle-enospc.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
epoll-optimizations-and-cleanups-tidy.patch
sync_sb_inodes-propagate-errors.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
aio-is-unlikely.patch
mm-implement-swap-prefetching.patch
readahead-kconfig-options.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-context-based-method.patch
readahead-call-scheme.patch
readahead-nfsd-case.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
