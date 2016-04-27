From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 27 Apr 2016 15:09:19 -0700
Message-ID: <5721388f.9Coumpt8lguQOVfY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbcD0WJU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 18:09:20 -0400
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

 arch/arm/boot/dts/dm814x-clocks.dtsi              |   12 ----
 arch/arm/boot/dts/r8a7791-porter.dts              |    5 -
 arch/arm/boot/dts/r8a7791.dtsi                    |    8 --
 arch/arm/mach-shmobile/timer.c                    |   23 -------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |   35 ------------
 drivers/net/macsec.c                              |   11 ---
 6 files changed, 94 deletions(-)

diff -puN arch/arm/boot/dts/dm814x-clocks.dtsi~linux-next-git-rejects arch/arm/boot/dts/dm814x-clocks.dtsi
--- a/arch/arm/boot/dts/dm814x-clocks.dtsi~linux-next-git-rejects
+++ a/arch/arm/boot/dts/dm814x-clocks.dtsi
@@ -175,11 +175,7 @@
 	};
 
 	/* CPTS_RFT_CLK in RMII_REFCLK_SRC, usually sourced from auiod */
-<<<<<<< HEAD
-	cpsw_cpts_rft_clk: cpsw_cpts_rft_clk {
-=======
 	cpsw_cpts_rft_clk: cpsw_cpts_rft_clk@2e8 {
->>>>>>> linux-next/akpm-base
 		#clock-cells = <0>;
 		compatible = "ti,mux-clock";
 		clocks = <&adpll_video0_ck 1
@@ -196,11 +192,7 @@
 		clock-frequency = <125000000>;
 	};
 
-<<<<<<< HEAD
-	sysclk18_ck: sysclk18_ck {
-=======
 	sysclk18_ck: sysclk18_ck@2f0 {
->>>>>>> linux-next/akpm-base
 		#clock-cells = <0>;
 		compatible = "ti,mux-clock";
 		clocks = <&rtcosc_ck>, <&rtcdivider_ck>;
@@ -319,11 +311,7 @@
 		ti,clock-div = <1>;
 	};
 
-<<<<<<< HEAD
-	sysclk10_ck: sysclk10_ck {
-=======
 	sysclk10_ck: sysclk10_ck@324 {
->>>>>>> linux-next/akpm-base
 		compatible = "ti,divider-clock";
 		reg = <0x324>;
 		ti,max-div = <7>;
diff -puN arch/arm/boot/dts/r8a7791-porter.dts~linux-next-git-rejects arch/arm/boot/dts/r8a7791-porter.dts
--- a/arch/arm/boot/dts/r8a7791-porter.dts~linux-next-git-rejects
+++ a/arch/arm/boot/dts/r8a7791-porter.dts
@@ -143,13 +143,8 @@
 
 &pfc {
 	scif0_pins: serial0 {
-<<<<<<< HEAD
-		renesas,groups = "scif0_data_d";
-		renesas,function = "scif0";
-=======
 		groups = "scif0_data_d";
 		function = "scif0";
->>>>>>> linux-next/akpm-base
 	};
 
 	ether_pins: ether {
diff -puN arch/arm/boot/dts/r8a7791.dtsi~linux-next-git-rejects arch/arm/boot/dts/r8a7791.dtsi
--- a/arch/arm/boot/dts/r8a7791.dtsi~linux-next-git-rejects
+++ a/arch/arm/boot/dts/r8a7791.dtsi
@@ -1084,10 +1084,6 @@
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
 			clock-frequency = <0>;
-<<<<<<< HEAD
-			clock-output-names = "pcie_bus";
-=======
->>>>>>> linux-next/akpm-base
 		};
 
 		/* External SCIF clock */
@@ -1111,10 +1107,6 @@
 			#clock-cells = <0>;
 			/* This value must be overridden by the board. */
 			clock-frequency = <0>;
-<<<<<<< HEAD
-			clock-output-names = "can_clk";
-=======
->>>>>>> linux-next/akpm-base
 		};
 
 		/* Special CPG clocks */
diff -puN arch/arm/mach-shmobile/timer.c~linux-next-git-rejects arch/arm/mach-shmobile/timer.c
--- a/arch/arm/mach-shmobile/timer.c~linux-next-git-rejects
+++ a/arch/arm/mach-shmobile/timer.c
@@ -23,11 +23,6 @@
 void __init shmobile_init_delay(void)
 {
 	struct device_node *np, *cpus;
-<<<<<<< HEAD
-	unsigned int div = 0;
-	bool has_arch_timer = false;
-=======
->>>>>>> linux-next/akpm-base
 	u32 max_freq = 0;
 
 	cpus = of_find_node_by_path("/cpus");
@@ -47,19 +42,6 @@ void __init shmobile_init_delay(void)
 
 		if (!of_property_read_u32(np, "clock-frequency", &freq))
 			max_freq = max(max_freq, freq);
-<<<<<<< HEAD
-
-		if (of_device_is_compatible(np, "arm,cortex-a8")) {
-			div = 2;
-		} else if (of_device_is_compatible(np, "arm,cortex-a9")) {
-			div = 1;
-		} else if (of_device_is_compatible(np, "arm,cortex-a7") ||
-			 of_device_is_compatible(np, "arm,cortex-a15")) {
-			div = 1;
-			has_arch_timer = true;
-		}
-=======
->>>>>>> linux-next/akpm-base
 	}
 
 	of_node_put(cpus);
@@ -67,10 +49,6 @@ void __init shmobile_init_delay(void)
 	if (!max_freq || !div)
 		return;
 
-<<<<<<< HEAD
-	if (!has_arch_timer || !IS_ENABLED(CONFIG_ARM_ARCH_TIMER))
-		shmobile_setup_delay_hz(max_freq, 1, div);
-=======
 	/*
 	 * Calculate a worst-case loops-per-jiffy value
 	 * based on maximum cpu core hz setting and the
@@ -82,5 +60,4 @@ void __init shmobile_init_delay(void)
 
 	if (!preset_lpj)
 		preset_lpj = max_freq / HZ;
->>>>>>> linux-next/akpm-base
 }
diff -puN drivers/net/ethernet/mellanox/mlx5/core/en_main.c~linux-next-git-rejects drivers/net/ethernet/mellanox/mlx5/core/en_main.c
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1556,7 +1556,6 @@ static int mlx5e_set_mtu(struct mlx5e_pr
 	mlx5_modify_nic_vport_mtu(mdev, hw_mtu);
 	return 0;
 }
-<<<<<<< HEAD
 
 static void mlx5e_query_mtu(struct mlx5e_priv *priv, u16 *mtu)
 {
@@ -1586,37 +1585,6 @@ static int mlx5e_set_dev_port_mtu(struct
 		netdev_warn(netdev, "%s: VPort MTU %d is different than netdev mtu %d\n",
 			    __func__, mtu, netdev->mtu);
 
-=======
-
-static void mlx5e_query_mtu(struct mlx5e_priv *priv, u16 *mtu)
-{
-	struct mlx5_core_dev *mdev = priv->mdev;
-	u16 hw_mtu = 0;
-	int err;
-
-	err = mlx5_query_nic_vport_mtu(mdev, &hw_mtu);
-	if (err || !hw_mtu) /* fallback to port oper mtu */
-		mlx5_query_port_oper_mtu(mdev, &hw_mtu, 1);
-
-	*mtu = MLX5E_HW2SW_MTU(hw_mtu);
-}
-
-static int mlx5e_set_dev_port_mtu(struct net_device *netdev)
-{
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-	u16 mtu;
-	int err;
-
-	err = mlx5e_set_mtu(priv, netdev->mtu);
-	if (err)
-		return err;
-
-	mlx5e_query_mtu(priv, &mtu);
-	if (mtu != netdev->mtu)
-		netdev_warn(netdev, "%s: VPort MTU %d is different than netdev mtu %d\n",
-			    __func__, mtu, netdev->mtu);
-
->>>>>>> linux-next/akpm-base
 	netdev->mtu = mtu;
 	return 0;
 }
@@ -2272,8 +2240,6 @@ static int set_feature_rx_vlan(struct ne
 	return err;
 }
 
-<<<<<<< HEAD
-=======
 static int mlx5e_handle_feature(struct net_device *netdev,
 				netdev_features_t wanted_features,
 				netdev_features_t feature,
@@ -2317,7 +2283,6 @@ static int mlx5e_set_features(struct net
 	return err ? -EINVAL : 0;
 }
 
->>>>>>> linux-next/akpm-base
 #define MXL5_HW_MIN_MTU 64
 #define MXL5E_MIN_MTU (MXL5_HW_MIN_MTU + ETH_FCS_LEN)
 
diff -puN drivers/net/macsec.c~linux-next-git-rejects drivers/net/macsec.c
--- a/drivers/net/macsec.c~linux-next-git-rejects
+++ a/drivers/net/macsec.c
@@ -2276,17 +2276,11 @@ static int nla_put_secy(struct macsec_se
 	if (!secy_nest)
 		return 1;
 
-<<<<<<< HEAD
-	if (nla_put_sci(skb, MACSEC_SECY_ATTR_SCI, secy->sci) ||
-	    nla_put_u64(skb, MACSEC_SECY_ATTR_CIPHER_SUITE,
-			MACSEC_DEFAULT_CIPHER_ID) ||
-=======
 	if (nla_put_sci(skb, MACSEC_SECY_ATTR_SCI, secy->sci,
 			MACSEC_SECY_ATTR_PAD) ||
 	    nla_put_u64_64bit(skb, MACSEC_SECY_ATTR_CIPHER_SUITE,
 			      MACSEC_DEFAULT_CIPHER_ID,
 			      MACSEC_SECY_ATTR_PAD) ||
->>>>>>> linux-next/akpm-base
 	    nla_put_u8(skb, MACSEC_SECY_ATTR_ICV_LEN, secy->icv_len) ||
 	    nla_put_u8(skb, MACSEC_SECY_ATTR_OPER, secy->operational) ||
 	    nla_put_u8(skb, MACSEC_SECY_ATTR_PROTECT, secy->protect_frames) ||
@@ -3245,13 +3239,8 @@ static int macsec_fill_info(struct sk_bu
 	if (nla_put_sci(skb, IFLA_MACSEC_SCI, secy->sci,
 			IFLA_MACSEC_PAD) ||
 	    nla_put_u8(skb, IFLA_MACSEC_ICV_LEN, secy->icv_len) ||
-<<<<<<< HEAD
-	    nla_put_u64(skb, IFLA_MACSEC_CIPHER_SUITE,
-			MACSEC_DEFAULT_CIPHER_ID) ||
-=======
 	    nla_put_u64_64bit(skb, IFLA_MACSEC_CIPHER_SUITE,
 			      MACSEC_DEFAULT_CIPHER_ID, IFLA_MACSEC_PAD) ||
->>>>>>> linux-next/akpm-base
 	    nla_put_u8(skb, IFLA_MACSEC_ENCODING_SA, tx_sc->encoding_sa) ||
 	    nla_put_u8(skb, IFLA_MACSEC_ENCRYPT, tx_sc->encrypt) ||
 	    nla_put_u8(skb, IFLA_MACSEC_PROTECT, secy->protect_frames) ||
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
fsnotify-avoid-spurious-emfile-errors-from-inotify_init-checkpatch-fixes.patch
kernel-padata-hide-unused-functions-checkpatch-fixes.patch
mm.patch
mm-slab-freelist-randomization-v5-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix.patch
mm-page_alloc-only-check-pagecompound-for-high-order-pages-fix.patch
mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask-fix.patch
mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check-fix.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch
mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
fs-execc-fix-minor-memory-leak.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

