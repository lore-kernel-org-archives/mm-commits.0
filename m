Return-Path: <SRS0=SqaX=DN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B271C41604
	for <mm-commits@archiver.kernel.org>; Tue,  6 Oct 2020 21:11:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9395720897
	for <mm-commits@archiver.kernel.org>; Tue,  6 Oct 2020 21:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602018680;
	bh=fjnDNT1KRGPP2N8NFbMfAe0L0hvhQwlI/O9FqBlFtUM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=tQqOHa19JQwmIq/amTIXkulvesZQPzWyN744gF/GbygoYqWXK5ldtGLwUCFCvf3ku
	 Ih4gBHiFSiKLeg/swLRNFC96FziSUz9HAahHh+fhiAH0zN3G/nk+VLTf7kjfc5NaCc
	 n4wJllvq9irMdFqZ1NV/So8R/6+8sttx0DjaDw3A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgJFVLU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Oct 2020 17:11:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727345AbgJFVLU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Oct 2020 17:11:20 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 988D52087E;
        Tue,  6 Oct 2020 21:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602018678;
        bh=fjnDNT1KRGPP2N8NFbMfAe0L0hvhQwlI/O9FqBlFtUM=;
        h=Date:From:To:Subject:From;
        b=Vzr9y0cfh72uM5nQvysD1j1kowg/8IjJnQCy7U6sgD3jgsl1TIzrKOMkxBY2rvH0F
         sOVh/Rz2eaS4UrMUg3y0q8OlFqlo67iXMkJtBlf+TFJ4dgK/Wv1lR/jXD3fbSz+kd4
         nI1mMk31hbpYxAm5OJlZ6xjV+EWTJqVshOfvkwIA=
Date:   Tue, 06 Oct 2020 14:11:17 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20201006211117.ASrC6G8EP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


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

 drivers/gpio/gpio-mockup.c                           |    8 
 drivers/net/ethernet/realtek/r8169_main.c            |    7 
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c |   16 
 drivers/net/phy/Kconfig                              |  244 ----------
 drivers/net/phy/realtek.c                            |    3 
 fs/btrfs/dev-replace.c                               |   20 
 net/mptcp/protocol.c                                 |    6 
 net/mptcp/protocol.h                                 |    3 
 tools/lib/bpf/btf.c                                  |   10 
 9 files changed, 317 deletions(-)

--- a/drivers/gpio/gpio-mockup.c~linux-next-git-rejects
+++ a/drivers/gpio/gpio-mockup.c
@@ -577,11 +577,7 @@ static int __init gpio_mockup_init(void)
 
 	err = platform_driver_register(&gpio_mockup_driver);
 	if (err) {
-<<<<<<< HEAD
-		gpio_mockup_err("error registering platform driver\n");
-=======
 		pr_err("error registering platform driver\n");
->>>>>>> linux-next/akpm-base
 		debugfs_remove_recursive(gpio_mockup_dbg_dir);
 		return err;
 	}
@@ -592,11 +588,7 @@ static int __init gpio_mockup_init(void)
 			platform_driver_unregister(&gpio_mockup_driver);
 			gpio_mockup_unregister_pdevs();
 			debugfs_remove_recursive(gpio_mockup_dbg_dir);
-<<<<<<< HEAD
-			return PTR_ERR(pdev);
-=======
 			return err;
->>>>>>> linux-next/akpm-base
 		}
 	}
 
--- a/fs/btrfs/dev-replace.c~linux-next-git-rejects
+++ a/fs/btrfs/dev-replace.c
@@ -593,8 +593,6 @@ static void btrfs_rm_dev_replace_unblock
 	wake_up(&fs_info->dev_replace.replace_wait);
 }
 
-<<<<<<< HEAD
-=======
 static void btrfs_dev_replace_update_device_in_mapping_tree(
 						struct btrfs_fs_info *fs_info,
 						struct btrfs_device *srcdev,
@@ -621,7 +619,6 @@ static void btrfs_dev_replace_update_dev
 	write_unlock(&em_tree->lock);
 }
 
->>>>>>> linux-next/akpm-base
 /*
  * When finishing the device replace, before swapping the source device with the
  * target device we must update the chunk allocation state in the target device,
@@ -818,23 +815,6 @@ error:
 	mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 
 	btrfs_rm_dev_replace_free_srcdev(src_device);
-<<<<<<< HEAD
-
-	return 0;
-}
-
-static void btrfs_dev_replace_update_device_in_mapping_tree(
-						struct btrfs_fs_info *fs_info,
-						struct btrfs_device *srcdev,
-						struct btrfs_device *tgtdev)
-{
-	struct extent_map_tree *em_tree = &fs_info->mapping_tree;
-	struct extent_map *em;
-	struct map_lookup *map;
-	u64 start = 0;
-	int i;
-=======
->>>>>>> linux-next/akpm-base
 
 	return 0;
 }
--- a/drivers/net/ethernet/realtek/r8169_main.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/realtek/r8169_main.c
@@ -4848,13 +4848,6 @@ static int __maybe_unused rtl8169_resume
 	if (!device_may_wakeup(tp_to_dev(tp)))
 		clk_prepare_enable(tp->clk);
 
-<<<<<<< HEAD
-	/* Reportedly at least Asus X453MA truncates packets otherwise */
-	if (tp->mac_version == RTL_GIGA_MAC_VER_37)
-		rtl_init_rxcfg(tp);
-
-=======
->>>>>>> linux-next/akpm-base
 	return rtl8169_net_resume(tp);
 }
 
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -706,13 +706,6 @@ static int stmmac_ethtool_op_set_eee(str
 	if (!priv->dma_cap.eee)
 		return -EOPNOTSUPP;
 
-<<<<<<< HEAD
-	if (priv->tx_lpi_enabled != edata->tx_lpi_enabled)
-		netdev_warn(priv->dev,
-			    "Setting EEE tx-lpi is not supported\n");
-
-=======
->>>>>>> linux-next/akpm-base
 	if (!edata->eee_enabled)
 		stmmac_disable_eee_mode(priv);
 
@@ -720,16 +713,7 @@ static int stmmac_ethtool_op_set_eee(str
 	if (ret)
 		return ret;
 
-<<<<<<< HEAD
-	if (edata->eee_enabled &&
-	    priv->tx_lpi_timer != edata->tx_lpi_timer) {
-		priv->tx_lpi_timer = edata->tx_lpi_timer;
-		stmmac_eee_init(priv);
-	}
-
-=======
 	priv->tx_lpi_timer = edata->tx_lpi_timer;
->>>>>>> linux-next/akpm-base
 	return 0;
 }
 
--- a/drivers/net/phy/Kconfig~linux-next-git-rejects
+++ a/drivers/net/phy/Kconfig
@@ -3,250 +3,6 @@
 # PHY Layer Configuration
 #
 
-<<<<<<< HEAD
-menuconfig MDIO_DEVICE
-	tristate "MDIO bus device drivers"
-	help
-	  MDIO devices and driver infrastructure code.
-
-if MDIO_DEVICE
-
-config MDIO_BUS
-	tristate
-	default m if PHYLIB=m
-	default MDIO_DEVICE
-	help
-	  This internal symbol is used for link time dependencies and it
-	  reflects whether the mdio_bus/mdio_device code is built as a
-	  loadable module or built-in.
-
-if MDIO_BUS
-
-config MDIO_DEVRES
-	tristate
-
-config MDIO_ASPEED
-	tristate "ASPEED MDIO bus controller"
-	depends on ARCH_ASPEED || COMPILE_TEST
-	depends on OF_MDIO && HAS_IOMEM
-	help
-	  This module provides a driver for the independent MDIO bus
-	  controllers found in the ASPEED AST2600 SoC. This is a driver for the
-	  third revision of the ASPEED MDIO register interface - the first two
-	  revisions are the "old" and "new" interfaces found in the AST2400 and
-	  AST2500, embedded in the MAC. For legacy reasons, FTGMAC100 driver
-	  continues to drive the embedded MDIO controller for the AST2400 and
-	  AST2500 SoCs, so say N if AST2600 support is not required.
-
-config MDIO_BCM_IPROC
-	tristate "Broadcom iProc MDIO bus controller"
-	depends on ARCH_BCM_IPROC || COMPILE_TEST
-	depends on HAS_IOMEM && OF_MDIO
-	default ARCH_BCM_IPROC
-	help
-	  This module provides a driver for the MDIO busses found in the
-	  Broadcom iProc SoC's.
-
-config MDIO_BCM_UNIMAC
-	tristate "Broadcom UniMAC MDIO bus controller"
-	depends on HAS_IOMEM
-	help
-	  This module provides a driver for the Broadcom UniMAC MDIO busses.
-	  This hardware can be found in the Broadcom GENET Ethernet MAC
-	  controllers as well as some Broadcom Ethernet switches such as the
-	  Starfighter 2 switches.
-
-config MDIO_BITBANG
-	tristate "Bitbanged MDIO buses"
-	help
-	  This module implements the MDIO bus protocol in software,
-	  for use by low level drivers that export the ability to
-	  drive the relevant pins.
-
-	  If in doubt, say N.
-
-config MDIO_BUS_MUX
-	tristate
-	depends on OF_MDIO
-	help
-	  This module provides a driver framework for MDIO bus
-	  multiplexers which connect one of several child MDIO busses
-	  to a parent bus.  Switching between child busses is done by
-	  device specific drivers.
-
-config MDIO_BUS_MUX_BCM_IPROC
-	tristate "Broadcom iProc based MDIO bus multiplexers"
-	depends on OF && OF_MDIO && (ARCH_BCM_IPROC || COMPILE_TEST)
-	select MDIO_BUS_MUX
-	default ARCH_BCM_IPROC
-	help
-	  This module provides a driver for MDIO bus multiplexers found in
-	  iProc based Broadcom SoCs. This multiplexer connects one of several
-	  child MDIO bus to a parent bus. Buses could be internal as well as
-	  external and selection logic lies inside the same multiplexer.
-
-config MDIO_BUS_MUX_GPIO
-	tristate "GPIO controlled MDIO bus multiplexers"
-	depends on OF_GPIO && OF_MDIO
-	select MDIO_BUS_MUX
-	help
-	  This module provides a driver for MDIO bus multiplexers that
-	  are controlled via GPIO lines.  The multiplexer connects one of
-	  several child MDIO busses to a parent bus.  Child bus
-	  selection is under the control of GPIO lines.
-
-config MDIO_BUS_MUX_MESON_G12A
-	tristate "Amlogic G12a based MDIO bus multiplexer"
-	depends on ARCH_MESON || COMPILE_TEST
-	depends on OF_MDIO && HAS_IOMEM && COMMON_CLK
-	select MDIO_BUS_MUX
-	default m if ARCH_MESON
-	help
-	  This module provides a driver for the MDIO multiplexer/glue of
-	  the amlogic g12a SoC. The multiplexers connects either the external
-	  or the internal MDIO bus to the parent bus.
-
-config MDIO_BUS_MUX_MMIOREG
-	tristate "MMIO device-controlled MDIO bus multiplexers"
-	depends on OF_MDIO && HAS_IOMEM
-	select MDIO_BUS_MUX
-	help
-	  This module provides a driver for MDIO bus multiplexers that
-	  are controlled via a simple memory-mapped device, like an FPGA.
-	  The multiplexer connects one of several child MDIO busses to a
-	  parent bus.  Child bus selection is under the control of one of
-	  the FPGA's registers.
-
-	  Currently, only 8/16/32 bits registers are supported.
-
-config MDIO_BUS_MUX_MULTIPLEXER
-	tristate "MDIO bus multiplexer using kernel multiplexer subsystem"
-	depends on OF_MDIO
-	select MULTIPLEXER
-	select MDIO_BUS_MUX
-	help
-	  This module provides a driver for MDIO bus multiplexer
-	  that is controlled via the kernel multiplexer subsystem. The
-	  bus multiplexer connects one of several child MDIO busses to
-	  a parent bus.  Child bus selection is under the control of
-	  the kernel multiplexer subsystem.
-
-config MDIO_CAVIUM
-	tristate
-
-config MDIO_GPIO
-	tristate "GPIO lib-based bitbanged MDIO buses"
-	depends on MDIO_BITBANG
-	depends on GPIOLIB || COMPILE_TEST
-	help
-	  Supports GPIO lib-based MDIO busses.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called mdio-gpio.
-
-config MDIO_HISI_FEMAC
-	tristate "Hisilicon FEMAC MDIO bus controller"
-	depends on HAS_IOMEM && OF_MDIO
-	help
-	  This module provides a driver for the MDIO busses found in the
-	  Hisilicon SoC that have an Fast Ethernet MAC.
-
-config MDIO_I2C
-	tristate
-	depends on I2C
-	help
-	  Support I2C based PHYs.  This provides a MDIO bus bridged
-	  to I2C to allow PHYs connected in I2C mode to be accessed
-	  using the existing infrastructure.
-
-	  This is library mode.
-
-config MDIO_IPQ4019
-	tristate "Qualcomm IPQ4019 MDIO interface support"
-	depends on HAS_IOMEM && OF_MDIO
-	help
-	  This driver supports the MDIO interface found in Qualcomm
-	  IPQ40xx series Soc-s.
-
-config MDIO_IPQ8064
-	tristate "Qualcomm IPQ8064 MDIO interface support"
-	depends on HAS_IOMEM && OF_MDIO
-	depends on MFD_SYSCON
-	help
-	  This driver supports the MDIO interface found in the network
-	  interface units of the IPQ8064 SoC
-
-config MDIO_MOXART
-	tristate "MOXA ART MDIO interface support"
-	depends on ARCH_MOXART || COMPILE_TEST
-	help
-	  This driver supports the MDIO interface found in the network
-	  interface units of the MOXA ART SoC
-
-config MDIO_MSCC_MIIM
-	tristate "Microsemi MIIM interface support"
-	depends on HAS_IOMEM
-	select MDIO_DEVRES
-	help
-	  This driver supports the MIIM (MDIO) interface found in the network
-	  switches of the Microsemi SoCs; it is recommended to switch on
-	  CONFIG_HIGH_RES_TIMERS
-
-config MDIO_MVUSB
-	tristate "Marvell USB to MDIO Adapter"
-	depends on USB
-	select MDIO_DEVRES
-	help
-	  A USB to MDIO converter present on development boards for
-	  Marvell's Link Street family of Ethernet switches.
-
-config MDIO_OCTEON
-	tristate "Octeon and some ThunderX SOCs MDIO buses"
-	depends on (64BIT && OF_MDIO) || COMPILE_TEST
-	depends on HAS_IOMEM
-	select MDIO_CAVIUM
-	help
-	  This module provides a driver for the Octeon and ThunderX MDIO
-	  buses. It is required by the Octeon and ThunderX ethernet device
-	  drivers on some systems.
-
-config MDIO_SUN4I
-	tristate "Allwinner sun4i MDIO interface support"
-	depends on ARCH_SUNXI || COMPILE_TEST
-	help
-	  This driver supports the MDIO interface found in the network
-	  interface units of the Allwinner SoC that have an EMAC (A10,
-	  A12, A10s, etc.)
-
-config MDIO_THUNDER
-	tristate "ThunderX SOCs MDIO buses"
-	depends on 64BIT
-	depends on PCI
-	select MDIO_CAVIUM
-	select MDIO_DEVRES
-	help
-	  This driver supports the MDIO interfaces found on Cavium
-	  ThunderX SoCs when the MDIO bus device appears as a PCI
-	  device.
-
-config MDIO_XGENE
-	tristate "APM X-Gene SoC MDIO bus controller"
-	depends on ARCH_XGENE || COMPILE_TEST
-	help
-	  This module provides a driver for the MDIO busses found in the
-	  APM X-Gene SoC's.
-
-config MDIO_XPCS
-	tristate "Synopsys DesignWare XPCS controller"
-	help
-	  This module provides helper functions for Synopsys DesignWare XPCS
-	  controllers.
-
-endif
-endif
-
-=======
->>>>>>> linux-next/akpm-base
 config PHYLINK
 	tristate
 	depends on NETDEVICES
--- a/drivers/net/phy/realtek.c~linux-next-git-rejects
+++ a/drivers/net/phy/realtek.c
@@ -32,13 +32,10 @@
 #define RTL8211F_TX_DELAY			BIT(8)
 #define RTL8211F_RX_DELAY			BIT(3)
 
-<<<<<<< HEAD
-=======
 #define RTL8211F_ALDPS_PLL_OFF			BIT(1)
 #define RTL8211F_ALDPS_ENABLE			BIT(2)
 #define RTL8211F_ALDPS_XTAL_OFF			BIT(12)
 
->>>>>>> linux-next/akpm-base
 #define RTL8211E_CTRL_DELAY			BIT(13)
 #define RTL8211E_TX_DELAY			BIT(12)
 #define RTL8211E_RX_DELAY			BIT(11)
--- a/net/mptcp/protocol.c~linux-next-git-rejects
+++ a/net/mptcp/protocol.c
@@ -182,11 +182,6 @@ static void mptcp_data_queue_ofo(struct
 		goto end;
 	}
 
-<<<<<<< HEAD
-	skb_ext_reset(skb);
-	skb_orphan(skb);
-	WRITE_ONCE(msk->ack_seq, msk->ack_seq + copy_len);
-=======
 	/* with 2 subflows, adding at end of ooo queue is quite likely
 	 * Use of ooo_last_skb avoids the O(Log(N)) rbtree lookup.
 	 */
@@ -195,7 +190,6 @@ static void mptcp_data_queue_ofo(struct
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_OFOQUEUETAIL);
 		return;
 	}
->>>>>>> linux-next/akpm-base
 
 	/* Can avoid an rbtree lookup if we are adding skb after ooo_last_skb */
 	if (!before64(seq, MPTCP_SKB_CB(msk->ooo_last_skb)->end_seq)) {
--- a/net/mptcp/protocol.h~linux-next-git-rejects
+++ a/net/mptcp/protocol.h
@@ -408,10 +408,7 @@ bool mptcp_finish_join(struct sock *sk);
 void mptcp_data_acked(struct sock *sk);
 void mptcp_subflow_eof(struct sock *sk);
 bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq, bool use_64bit);
-<<<<<<< HEAD
-=======
 void mptcp_destroy_common(struct mptcp_sock *msk);
->>>>>>> linux-next/akpm-base
 
 void __init mptcp_token_init(void);
 static inline void mptcp_token_init_request(struct request_sock *req)
--- a/tools/lib/bpf/btf.c~linux-next-git-rejects
+++ a/tools/lib/bpf/btf.c
@@ -933,17 +933,7 @@ struct btf *btf__parse_raw(const char *p
 		err = -EIO;
 		goto err_out;
 	}
-<<<<<<< HEAD
-	if (magic == __bswap_16(BTF_MAGIC)) {
-		/* non-native endian raw BTF */
-		pr_warn("non-native BTF endianness is not supported\n");
-		err = -LIBBPF_ERRNO__ENDIAN;
-		goto err_out;
-	}
-	if (magic != BTF_MAGIC) {
-=======
 	if (magic != BTF_MAGIC && magic != bswap_16(BTF_MAGIC)) {
->>>>>>> linux-next/akpm-base
 		/* definitely not a raw BTF */
 		err = -EPROTO;
 		goto err_out;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
mm-mempool-add-else-to-split-mutually-exclusive-case-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
checkpatch-emit-a-warning-on-embedded-filenames-fix.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
fs-fuse-virtio_fsc-fix-for-mm-memremap_pages-convert-to-struct-range.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

