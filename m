From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 12 Sep 2016 13:25:31 -0700
Message-ID: <57d70f3b.l26RgcHkGO0enxpp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48513 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750832AbcILUZc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2016 16:25:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


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

 drivers/net/ethernet/cavium/thunder/nic_main.c           |    3 -
 drivers/net/ethernet/mediatek/mtk_eth_soc.c              |   19 ----------
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c |    3 -
 drivers/net/ethernet/qlogic/qed/qed_dcbx.c               |   10 -----
 drivers/net/phy/Kconfig                                  |    9 ----
 5 files changed, 44 deletions(-)

diff -puN drivers/net/ethernet/cavium/thunder/nic_main.c~linux-next-git-rejects drivers/net/ethernet/cavium/thunder/nic_main.c
--- a/drivers/net/ethernet/cavium/thunder/nic_main.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/cavium/thunder/nic_main.c
@@ -290,8 +290,6 @@ static void nic_set_tx_pkt_pad(struct ni
 	 */
 	if (size > 52)
 		size = 52;
-<<<<<<< HEAD
-=======
 
 	pci_read_config_word(nic->pdev, PCI_SUBSYSTEM_ID, &sdevid);
 	/* 81xx's RGX has only one LMAC */
@@ -299,7 +297,6 @@ static void nic_set_tx_pkt_pad(struct ni
 		max_lmac = ((nic->hw->bgx_cnt - 1) * MAX_LMAC_PER_BGX) + 1;
 	else
 		max_lmac = nic->hw->bgx_cnt * MAX_LMAC_PER_BGX;
->>>>>>> linux-next/akpm-base
 
 	for (lmac = 0; lmac < max_lmac; lmac++) {
 		lmac_cfg = nic_reg_read(nic, NIC_PF_LMAC_0_7_CFG | (lmac << 3));
diff -puN drivers/net/ethernet/mediatek/mtk_eth_soc.c~linux-next-git-rejects drivers/net/ethernet/mediatek/mtk_eth_soc.c
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1512,12 +1512,8 @@ static void mtk_uninit(struct net_device
 	struct mtk_eth *eth = mac->hw;
 
 	phy_disconnect(mac->phy_dev);
-<<<<<<< HEAD
-	mtk_irq_disable(eth, ~0);
-=======
 	mtk_irq_disable(eth, MTK_QDMA_INT_MASK, ~0);
 	mtk_irq_disable(eth, MTK_PDMA_INT_MASK, ~0);
->>>>>>> linux-next/akpm-base
 }
 
 static int mtk_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
@@ -1913,7 +1909,6 @@ static int mtk_remove(struct platform_de
 {
 	struct mtk_eth *eth = platform_get_drvdata(pdev);
 	int i;
-<<<<<<< HEAD
 
 	/* stop all devices to make sure that dma is properly shut down */
 	for (i = 0; i < MTK_MAC_COUNT; i++) {
@@ -1922,16 +1917,6 @@ static int mtk_remove(struct platform_de
 		mtk_stop(eth->netdev[i]);
 	}
 
-=======
-
-	/* stop all devices to make sure that dma is properly shut down */
-	for (i = 0; i < MTK_MAC_COUNT; i++) {
-		if (!eth->netdev[i])
-			continue;
-		mtk_stop(eth->netdev[i]);
-	}
-
->>>>>>> linux-next/akpm-base
 	clk_disable_unprepare(eth->clks[MTK_CLK_ETHIF]);
 	clk_disable_unprepare(eth->clks[MTK_CLK_ESW]);
 	clk_disable_unprepare(eth->clks[MTK_CLK_GP1]);
@@ -1941,10 +1926,6 @@ static int mtk_remove(struct platform_de
 	netif_napi_del(&eth->rx_napi);
 	mtk_cleanup(eth);
 	mtk_mdio_cleanup(eth);
-<<<<<<< HEAD
-	platform_set_drvdata(pdev, NULL);
-=======
->>>>>>> linux-next/akpm-base
 
 	return 0;
 }
diff -puN drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c~linux-next-git-rejects drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -252,8 +252,6 @@ int mlxsw_sp_vport_flood_set(struct mlxs
 	 */
 	vfid = mlxsw_sp_fid_to_vfid(fid);
 	return __mlxsw_sp_port_flood_set(mlxsw_sp_vport, vfid, vfid, set, set);
-<<<<<<< HEAD
-=======
 }
 
 static int mlxsw_sp_port_learning_set(struct mlxsw_sp_port *mlxsw_sp_port,
@@ -282,7 +280,6 @@ err_port_vid_learning_set:
 	for_each_set_bit(vid, mlxsw_sp_port->active_vlans, VLAN_N_VID)
 		__mlxsw_sp_port_vid_learning_set(mlxsw_sp_port, vid, vid, !set);
 	return err;
->>>>>>> linux-next/akpm-base
 }
 
 static int mlxsw_sp_port_attr_br_flags_set(struct mlxsw_sp_port *mlxsw_sp_port,
diff -puN drivers/net/ethernet/qlogic/qed/qed_dcbx.c~linux-next-git-rejects drivers/net/ethernet/qlogic/qed/qed_dcbx.c
--- a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
@@ -1187,12 +1187,7 @@ int qed_dcbx_get_config_params(struct qe
 	}
 
 	dcbx_info = kzalloc(sizeof(*dcbx_info), GFP_KERNEL);
-<<<<<<< HEAD
-	if (!dcbx_info) {
-		DP_ERR(p_hwfn, "Failed to allocate struct qed_dcbx_info\n");
-=======
 	if (!dcbx_info)
->>>>>>> linux-next/akpm-base
 		return -ENOMEM;
 
 	rc = qed_dcbx_query_params(p_hwfn, dcbx_info, QED_DCBX_OPERATIONAL_MIB);
@@ -1227,12 +1222,7 @@ static struct qed_dcbx_get *qed_dcbnl_ge
 	struct qed_dcbx_get *dcbx_info;
 
 	dcbx_info = kzalloc(sizeof(*dcbx_info), GFP_KERNEL);
-<<<<<<< HEAD
-	if (!dcbx_info) {
-		DP_ERR(hwfn->cdev, "Failed to allocate memory for dcbx_info\n");
-=======
 	if (!dcbx_info)
->>>>>>> linux-next/akpm-base
 		return NULL;
 
 	if (qed_dcbx_query_params(hwfn, dcbx_info, type)) {
diff -puN drivers/net/phy/Kconfig~linux-next-git-rejects drivers/net/phy/Kconfig
--- a/drivers/net/phy/Kconfig~linux-next-git-rejects
+++ a/drivers/net/phy/Kconfig
@@ -309,14 +309,6 @@ config TERANETICS_PHY
         ---help---
           Currently supports the Teranetics TN2020
 
-<<<<<<< HEAD
-config MDIO_XGENE
-	tristate "APM X-Gene SoC MDIO bus controller"
-	depends on ARCH_XGENE || COMPILE_TEST
-	help
-	  This module provides a driver for the MDIO busses found in the
-	  APM X-Gene SoC's.
-=======
 config VITESSE_PHY
         tristate "Vitesse PHYs"
         ---help---
@@ -328,7 +320,6 @@ config XILINX_GMII2RGMII
          This driver support xilinx GMII to RGMII IP core it provides
          the Reduced Gigabit Media Independent Interface(RGMII) between
          Ethernet physical media devices and the Gigabit Ethernet controller.
->>>>>>> linux-next/akpm-base
 
 endif # PHYLIB
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-rapidio-rio_cmc-avoid-gfp_kernel-in-atomic-context.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
mm-check-that-we-havent-used-more-than-32-bits-in-address_spaceflags.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

