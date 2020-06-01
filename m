From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 01 Jun 2020 15:04:19 -0700
Message-ID: <20200601220419.4Alpc8REB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728590AbgFAWEW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Jun 2020 18:04:22 -0400
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

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/dts/mmp3.dtsi                     |    8 -
 arch/x86/kernel/fpu/xstate.c                    |    4 
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig |    4 
 drivers/platform/chrome/chromeos_pstore.c       |    3 
 drivers/power/supply/bd70528-charger.c          |   64 --------------
 drivers/regulator/max8998.c                     |    5 -
 drivers/spi/spi-dw-core.c                       |   13 --
 drivers/spi/spi-dw-mmio.c                       |   10 --
 drivers/spi/spi-dw-pci.c                        |   12 --
 drivers/spi/spi-dw.h                            |   25 -----
 fs/ext4/super.c                                 |    4 
 fs/f2fs/f2fs.h                                  |    3 
 fs/pstore/blk.c                                 |   28 ------
 fs/pstore/inode.c                               |    4 
 include/linux/virtio_net.h                      |    7 -
 net/ipv4/nexthop.c                              |   25 -----
 net/xdp/xdp_umem.c                              |    4 
 sound/usb/quirks-table.h                        |   18 ---
 18 files changed, 241 deletions(-)

--- a/arch/arm/boot/dts/mmp3.dtsi~linux-next-git-rejects
+++ a/arch/arm/boot/dts/mmp3.dtsi
@@ -201,11 +201,7 @@
 				status = "disabled";
 			};
 
-<<<<<<< HEAD
-			hsic_phy0: hsic-phy@f0001800 {
-=======
 			hsic_phy0: usb-phy@f0001800 {
->>>>>>> linux-next/akpm-base
 				compatible = "marvell,mmp3-hsic-phy";
 				reg = <0xf0001800 0x40>;
 				#phy-cells = <0>;
@@ -226,11 +222,7 @@
 				status = "disabled";
 			};
 
-<<<<<<< HEAD
-			hsic_phy1: hsic-phy@f0002800 {
-=======
 			hsic_phy1: usb-phy@f0002800 {
->>>>>>> linux-next/akpm-base
 				compatible = "marvell,mmp3-hsic-phy";
 				reg = <0xf0002800 0x40>;
 				#phy-cells = <0>;
--- a/arch/x86/kernel/fpu/xstate.c~linux-next-git-rejects
+++ a/arch/x86/kernel/fpu/xstate.c
@@ -1062,11 +1062,7 @@ int copy_xstate_to_kernel(void *kbuf, st
 	 */
 	memset(&header, 0, sizeof(header));
 	header.xfeatures = xsave->header.xfeatures;
-<<<<<<< HEAD
-	header.xfeatures &= ~XFEATURE_MASK_SUPERVISOR;
-=======
 	header.xfeatures &= xfeatures_mask_user();
->>>>>>> linux-next/akpm-base
 
 	if (header.xfeatures & XFEATURE_MASK_FP)
 		copy_part(0, off_mxcsr,
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig~linux-next-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -95,11 +95,7 @@ config MLX5_CLS_ACT
 
 config MLX5_TC_CT
 	bool "MLX5 TC connection tracking offload support"
-<<<<<<< HEAD
-	depends on MLX5_ESWITCH && NF_FLOW_TABLE && NET_ACT_CT && NET_TC_SKB_EXT
-=======
 	depends on MLX5_CLS_ACT && NF_FLOW_TABLE && NET_ACT_CT && NET_TC_SKB_EXT
->>>>>>> linux-next/akpm-base
 	default y
 	help
 	  Say Y here if you want to support offloading connection tracking rules
--- a/drivers/platform/chrome/chromeos_pstore.c~linux-next-git-rejects
+++ a/drivers/platform/chrome/chromeos_pstore.c
@@ -57,10 +57,7 @@ static struct ramoops_platform_data chro
 	.record_size	= 0x40000,
 	.console_size	= 0x20000,
 	.ftrace_size	= 0x20000,
-<<<<<<< HEAD
-=======
 	.pmsg_size	= 0x20000,
->>>>>>> linux-next/akpm-base
 	.max_reason	= KMSG_DUMP_OOPS,
 };
 
--- a/drivers/power/supply/bd70528-charger.c~linux-next-git-rejects
+++ a/drivers/power/supply/bd70528-charger.c
@@ -336,18 +336,7 @@ static int bd70528_get_present(struct bd
 	return 0;
 }
 
-<<<<<<< HEAD
-struct bd70528_linear_range {
-	int min;
-	int step;
-	int vals;
-	int low_sel;
-};
-
-static const struct bd70528_linear_range current_limit_ranges[] = {
-=======
 static const struct linear_range current_limit_ranges[] = {
->>>>>>> linux-next/akpm-base
 	{
 		.min = 5,
 		.step = 1,
@@ -409,59 +398,6 @@ static const struct bd70528_linear_range
 #define MAX_WARM_CHG_CURR_SEL 0x1f
 #define MIN_CHG_CURR_SEL 0x0
 
-<<<<<<< HEAD
-static int find_value_for_selector_low(const struct bd70528_linear_range *r,
-				       int selectors, unsigned int sel,
-				       unsigned int *val)
-{
-	int i;
-
-	for (i = 0; i < selectors; i++) {
-		if (r[i].low_sel <= sel && r[i].low_sel + r[i].vals >= sel) {
-			*val = r[i].min + (sel - r[i].low_sel) * r[i].step;
-			return 0;
-		}
-	}
-	return -EINVAL;
-}
-
-/*
- * For BD70528 voltage/current limits we happily accept any value which
- * belongs the range. We could check if value matching the selector is
- * desired by computing the range min + (sel - sel_low) * range step - but
- * I guess it is enough if we use voltage/current which is closest (below)
- * the requested?
- */
-static int find_selector_for_value_low(const struct bd70528_linear_range *r,
-				       int selectors, unsigned int val,
-				       unsigned int *sel, bool *found)
-{
-	int i;
-	int ret = -EINVAL;
-
-	*found = false;
-	for (i = 0; i < selectors; i++) {
-		if (r[i].min <= val) {
-			if (r[i].min + r[i].step * r[i].vals >= val) {
-				*found = true;
-				*sel = r[i].low_sel + (val - r[i].min) /
-				       r[i].step;
-				ret = 0;
-				break;
-			}
-			/*
-			 * If the range max is smaller than requested
-			 * we can set the max supported value from range
-			 */
-			*sel = r[i].low_sel + r[i].vals;
-			ret = 0;
-		}
-	}
-	return ret;
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static int get_charge_current(struct bd70528_psy *bdpsy, int *ma)
 {
 	unsigned int sel;
--- a/drivers/regulator/max8998.c~linux-next-git-rejects
+++ a/drivers/regulator/max8998.c
@@ -371,13 +371,8 @@ static int max8998_set_voltage_buck_time
 	return 0;
 }
 
-<<<<<<< HEAD
-static int max8998_set_current_limit(struct regulator_dev *rdev,
-				     int min_uA, int max_uA)
-=======
 int max8998_set_current_limit(struct regulator_dev *rdev,
 			      int min_uA, int max_uA)
->>>>>>> linux-next/akpm-base
 {
 	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
 	struct i2c_client *i2c = max8998->iodev->i2c;
--- a/drivers/spi/spi-dw-core.c~linux-next-git-rejects
+++ a/drivers/spi/spi-dw-core.c
@@ -29,13 +29,6 @@ struct chip_data {
 };
 
 #ifdef CONFIG_DEBUG_FS
-<<<<<<< HEAD:drivers/spi/spi-dw-core.c
-
-#define DW_SPI_DBGFS_REG(_name, _off)	\
-{					\
-	.name = _name,			\
-	.offset = _off,			\
-=======
 #define SPI_REGS_BUFSIZE	1024
 static ssize_t dw_spi_show_regs(struct file *file, char __user *user_buf,
 		size_t count, loff_t *ppos)
@@ -89,7 +82,6 @@ static ssize_t dw_spi_show_regs(struct f
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, len);
 	kfree(buf);
 	return ret;
->>>>>>> linux-next/akpm-base:drivers/spi/spi-dw.c
 }
 
 static const struct debugfs_reg32 dw_spi_dbgfs_regs[] = {
@@ -411,16 +403,11 @@ static int dw_spi_transfer_one(struct sp
 
 	spi_enable_chip(dws, 1);
 
-<<<<<<< HEAD:drivers/spi/spi-dw-core.c
-	if (dws->dma_mapped)
-		return dws->dma_ops->dma_transfer(dws, transfer);
-=======
 	if (dws->dma_mapped) {
 		ret = dws->dma_ops->dma_transfer(dws, transfer);
 		if (ret < 0)
 			return ret;
 	}
->>>>>>> linux-next/akpm-base:drivers/spi/spi-dw.c
 
 	return 1;
 }
--- a/drivers/spi/spi-dw.h~linux-next-git-rejects
+++ a/drivers/spi/spi-dw.h
@@ -2,11 +2,6 @@
 #ifndef DW_SPI_HEADER_H
 #define DW_SPI_HEADER_H
 
-<<<<<<< HEAD
-#include <linux/completion.h>
-#include <linux/debugfs.h>
-=======
->>>>>>> linux-next/akpm-base
 #include <linux/irqreturn.h>
 #include <linux/io.h>
 #include <linux/scatterlist.h>
@@ -152,10 +147,6 @@ struct dw_spi {
 	unsigned long		dma_chan_busy;
 	dma_addr_t		dma_addr; /* phy address of the Data register */
 	const struct dw_spi_dma_ops *dma_ops;
-<<<<<<< HEAD
-	struct completion	dma_completion;
-=======
->>>>>>> linux-next/akpm-base
 
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debugfs;
@@ -264,25 +255,9 @@ extern u32 dw_spi_update_cr0(struct spi_
 extern u32 dw_spi_update_cr0_v1_01a(struct spi_controller *master,
 				    struct spi_device *spi,
 				    struct spi_transfer *transfer);
-<<<<<<< HEAD
-
-#ifdef CONFIG_SPI_DW_DMA
-
-extern void dw_spi_dma_setup_mfld(struct dw_spi *dws);
-extern void dw_spi_dma_setup_generic(struct dw_spi *dws);
-
-#else
-
-static inline void dw_spi_dma_setup_mfld(struct dw_spi *dws) {}
-static inline void dw_spi_dma_setup_generic(struct dw_spi *dws) {}
-
-#endif /* !CONFIG_SPI_DW_DMA */
-
-=======
 
 /* platform related setup */
 extern int dw_spi_mid_init_mfld(struct dw_spi *dws);
 extern int dw_spi_mid_init_generic(struct dw_spi *dws);
 
->>>>>>> linux-next/akpm-base
 #endif /* DW_SPI_HEADER_H */
--- a/drivers/spi/spi-dw-mmio.c~linux-next-git-rejects
+++ a/drivers/spi/spi-dw-mmio.c
@@ -151,11 +151,6 @@ static int dw_spi_dw_apb_init(struct pla
 	/* Register hook to configure CTRLR0 */
 	dwsmmio->dws.update_cr0 = dw_spi_update_cr0;
 
-<<<<<<< HEAD
-	dw_spi_dma_setup_generic(&dwsmmio->dws);
-
-=======
->>>>>>> linux-next/akpm-base
 	return 0;
 }
 
@@ -165,11 +160,6 @@ static int dw_spi_dwc_ssi_init(struct pl
 	/* Register hook to configure CTRLR0 */
 	dwsmmio->dws.update_cr0 = dw_spi_update_cr0_v1_01a;
 
-<<<<<<< HEAD
-	dw_spi_dma_setup_generic(&dwsmmio->dws);
-
-=======
->>>>>>> linux-next/akpm-base
 	return 0;
 }
 
--- a/drivers/spi/spi-dw-pci.c~linux-next-git-rejects
+++ a/drivers/spi/spi-dw-pci.c
@@ -67,31 +67,19 @@ static int spi_generic_init(struct dw_sp
 }
 
 static struct spi_pci_desc spi_pci_mid_desc_1 = {
-<<<<<<< HEAD
-	.setup = spi_mid_init,
-=======
 	.setup = dw_spi_mid_init_mfld,
->>>>>>> linux-next/akpm-base
 	.num_cs = 5,
 	.bus_num = 0,
 };
 
 static struct spi_pci_desc spi_pci_mid_desc_2 = {
-<<<<<<< HEAD
-	.setup = spi_mid_init,
-=======
 	.setup = dw_spi_mid_init_mfld,
->>>>>>> linux-next/akpm-base
 	.num_cs = 2,
 	.bus_num = 1,
 };
 
 static struct spi_pci_desc spi_pci_ehl_desc = {
-<<<<<<< HEAD
-	.setup = spi_generic_init,
-=======
 	.setup = dw_spi_mid_init_generic,
->>>>>>> linux-next/akpm-base
 	.num_cs = 2,
 	.bus_num = -1,
 	.max_freq = 100000000,
--- a/fs/ext4/super.c~linux-next-git-rejects
+++ a/fs/ext4/super.c
@@ -1824,11 +1824,7 @@ static const struct mount_opts {
 	{Opt_jqfmt_vfsv1, QFMT_VFS_V1, MOPT_QFMT},
 	{Opt_max_dir_size_kb, 0, MOPT_GTE0},
 	{Opt_test_dummy_encryption, 0, MOPT_STRING},
-<<<<<<< HEAD
-	{Opt_nombcache, EXT4_MOUNT_NO_MBCACHE, MOPT_SET},
-=======
 	{Opt_nombcache, EXT4_MOUNT_NO_MBCACHE, MOPT_SET | MOPT_NO_REMOUNT},
->>>>>>> linux-next/akpm-base
 	{Opt_err, 0, 0}
 };
 
--- a/fs/f2fs/f2fs.h~linux-next-git-rejects
+++ a/fs/f2fs/f2fs.h
@@ -139,10 +139,7 @@ struct f2fs_mount_info {
 	int fs_mode;			/* fs mode: LFS or ADAPTIVE */
 	int bggc_mode;			/* bggc mode: off, on or sync */
 	struct fscrypt_dummy_context dummy_enc_ctx; /* test dummy encryption */
-<<<<<<< HEAD
-=======
 	block_t unusable_cap_perc;	/* percentage for cap */
->>>>>>> linux-next/akpm-base
 	block_t unusable_cap;		/* Amount of space allowed to be
 					 * unusable when disabling checkpoint
 					 */
--- a/fs/pstore/blk.c~linux-next-git-rejects
+++ a/fs/pstore/blk.c
@@ -113,12 +113,8 @@ static int __register_pstore_device(stru
 {
 	int ret;
 
-<<<<<<< HEAD
-	lockdep_assert_held(&pstore_blk_lock);
-=======
 	if (WARN_ON(!mutex_is_locked(&pstore_blk_lock)))
 		return -EINVAL;
->>>>>>> linux-next/akpm-base
 
 	if (!dev || !dev->total_size || !dev->read || !dev->write)
 		return -EINVAL;
@@ -190,11 +186,7 @@ EXPORT_SYMBOL_GPL(register_pstore_device
 
 static void __unregister_pstore_device(struct pstore_device_info *dev)
 {
-<<<<<<< HEAD
-	lockdep_assert_held(&pstore_blk_lock);
-=======
 	WARN_ON(!mutex_is_locked(&pstore_blk_lock));
->>>>>>> linux-next/akpm-base
 	if (pstore_zone_info && pstore_zone_info->read == dev->read) {
 		unregister_pstore_zone(pstore_zone_info);
 		kfree(pstore_zone_info);
@@ -232,12 +224,8 @@ static struct block_device *psblk_get_bd
 	fmode_t mode = FMODE_READ | FMODE_WRITE;
 	sector_t nr_sects;
 
-<<<<<<< HEAD
-	lockdep_assert_held(&pstore_blk_lock);
-=======
 	if (WARN_ON(!mutex_is_locked(&pstore_blk_lock)))
 		return ERR_PTR(-EINVAL);
->>>>>>> linux-next/akpm-base
 
 	if (pstore_zone_info)
 		return ERR_PTR(-EBUSY);
@@ -279,20 +267,12 @@ static void psblk_put_bdev(struct block_
 {
 	fmode_t mode = FMODE_READ | FMODE_WRITE;
 
-<<<<<<< HEAD
-	lockdep_assert_held(&pstore_blk_lock);
-
-	if (!bdev)
-		return;
-
-=======
 	if (!bdev)
 		return;
 
 	if (WARN_ON(!mutex_is_locked(&pstore_blk_lock)))
 		return;
 
->>>>>>> linux-next/akpm-base
 	if (holder)
 		mode |= FMODE_EXCL;
 	blkdev_put(bdev, mode);
@@ -390,12 +370,8 @@ static int __register_pstore_blk(struct
 	void *holder = blkdev;
 	int ret = -ENODEV;
 
-<<<<<<< HEAD
-	lockdep_assert_held(&pstore_blk_lock);
-=======
 	if (WARN_ON(!mutex_is_locked(&pstore_blk_lock)))
 		return -EINVAL;
->>>>>>> linux-next/akpm-base
 
 	/* hold bdev exclusively */
 	memset(&binfo, 0, sizeof(binfo));
@@ -473,11 +449,7 @@ static void __unregister_pstore_blk(unsi
 	struct pstore_device_info dev = { .read = psblk_generic_blk_read };
 	void *holder = blkdev;
 
-<<<<<<< HEAD
-	lockdep_assert_held(&pstore_blk_lock);
-=======
 	WARN_ON(!mutex_is_locked(&pstore_blk_lock));
->>>>>>> linux-next/akpm-base
 	if (psblk_bdev && MAJOR(psblk_bdev->bd_dev) == major) {
 		__unregister_pstore_device(&dev);
 		psblk_put_bdev(psblk_bdev, holder);
--- a/fs/pstore/inode.c~linux-next-git-rejects
+++ a/fs/pstore/inode.c
@@ -287,11 +287,7 @@ static const struct super_operations pst
 	.show_options	= pstore_show_options,
 };
 
-<<<<<<< HEAD
-static struct dentry *psinfo_lock_root(void)
-=======
 struct dentry *psinfo_lock_root(void)
->>>>>>> linux-next/akpm-base
 {
 	struct dentry *root;
 
--- a/include/linux/virtio_net.h~linux-next-git-rejects
+++ a/include/linux/virtio_net.h
@@ -111,18 +111,11 @@ retry:
 		u16 gso_size = __virtio16_to_cpu(little_endian, hdr->gso_size);
 		struct skb_shared_info *shinfo = skb_shinfo(skb);
 
-<<<<<<< HEAD
-		/* Too small packets are not really GSO ones. */
-		if (skb->len - p_off > gso_size) {
-			shinfo->gso_size = gso_size;
-			shinfo->gso_type = gso_type;
-=======
 		if (skb->len - p_off <= gso_size)
 			return -EINVAL;
 
 		skb_shinfo(skb)->gso_size = gso_size;
 		skb_shinfo(skb)->gso_type = gso_type;
->>>>>>> linux-next/akpm-base
 
 			/* Header must be checked, and gso_segs computed. */
 			shinfo->gso_type |= SKB_GSO_DODGY;
--- a/net/ipv4/nexthop.c~linux-next-git-rejects
+++ a/net/ipv4/nexthop.c
@@ -788,7 +788,6 @@ static void remove_nh_grp_entry(struct n
 	newg->has_v4 = nhg->has_v4;
 	newg->mpath = nhg->mpath;
 	newg->num_nh = nhg->num_nh;
-<<<<<<< HEAD
 
 	/* copy old entries to new except the one getting removed */
 	nhges = nhg->nh_entries;
@@ -811,30 +810,6 @@ static void remove_nh_grp_entry(struct n
 	nh_group_rebalance(newg);
 	rcu_assign_pointer(nhp->nh_grp, newg);
 
-=======
-
-	/* copy old entries to new except the one getting removed */
-	nhges = nhg->nh_entries;
-	new_nhges = newg->nh_entries;
-	for (i = 0, j = 0; i < nhg->num_nh; ++i) {
-		/* current nexthop getting removed */
-		if (nhg->nh_entries[i].nh == nh) {
-			newg->num_nh--;
-			continue;
-		}
-
-		list_del(&nhges[i].nh_list);
-		new_nhges[j].nh_parent = nhges[i].nh_parent;
-		new_nhges[j].nh = nhges[i].nh;
-		new_nhges[j].weight = nhges[i].weight;
-		list_add(&new_nhges[j].nh_list, &new_nhges[j].nh->grp_list);
-		j++;
-	}
-
-	nh_group_rebalance(newg);
-	rcu_assign_pointer(nhp->nh_grp, newg);
-
->>>>>>> linux-next/akpm-base
 	list_del(&nhge->nh_list);
 	nexthop_put(nhge->nh);
 
--- a/net/xdp/xdp_umem.c~linux-next-git-rejects
+++ a/net/xdp/xdp_umem.c
@@ -355,11 +355,7 @@ static int xdp_umem_reg(struct xdp_umem
 
 	umem->size = size;
 	umem->headroom = headroom;
-<<<<<<< HEAD
-	umem->chunk_size_nohr = chunk_size - headroom;
-=======
 	umem->chunk_size = chunk_size;
->>>>>>> linux-next/akpm-base
 	umem->npgs = (u32)npgs;
 	umem->pgs = NULL;
 	umem->user = NULL;
--- a/sound/usb/quirks-table.h~linux-next-git-rejects
+++ a/sound/usb/quirks-table.h
@@ -3549,23 +3549,6 @@ ALC1220_VB_DESKTOP(0x26ce, 0x0a01), /* A
  */
 {
 	USB_DEVICE(0x0414, 0xa000),
-<<<<<<< HEAD
-	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
-		.vendor_name = "Gigabyte",
-		.product_name = "Aorus Master Front Headphone",
-		.profile_name = "Gigabyte-Aorus-Master-Front-Headphone",
-		.ifnum = QUIRK_NO_INTERFACE
-	}
-},
-{
-	USB_DEVICE(0x0414, 0xa001),
-	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
-		.vendor_name = "Gigabyte",
-		.product_name = "Aorus Master Main Audio",
-		.profile_name = "Gigabyte-Aorus-Master-Main-Audio",
-		.ifnum = QUIRK_NO_INTERFACE
-	}
-=======
 	QUIRK_DEVICE_PROFILE("Gigabyte", "Aorus Master Front Headphone",
 			     "Gigabyte-Aorus-Master-Front-Headphone")
 },
@@ -3573,7 +3556,6 @@ ALC1220_VB_DESKTOP(0x26ce, 0x0a01), /* A
 	USB_DEVICE(0x0414, 0xa001),
 	QUIRK_DEVICE_PROFILE("Gigabyte", "Aorus Master Main Audio",
 			     "Gigabyte-Aorus-Master-Main-Audio")
->>>>>>> linux-next/akpm-base
 },
 
 #undef USB_DEVICE_VENDOR_SPEC
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-ptdump-expand-type-of-val-in-note_page-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
arch-parisc-include-asm-pgtableh-remove-unused-old_pte.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
mm-migratec-call-detach_page_private-to-cleanup-code-fix.patch
mm-migratec-call-detach_page_private-to-cleanup-code-fix-fix.patch
mm-gupc-updating-the-documentation-fix.patch
mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-vmalloc-track-which-page-table-levels-were-modified-fix.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2-fix.patch
mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix.patch
arch-kunmap-remove-duplicate-kunmap-implementations-fix.patch
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-add-debug_wx-support-fix.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
lib-make-a-test-module-with-get_count_order-long-fix.patch
seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-pre.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
linux-next-post.patch
kernel-add-panic_on_taint-fix.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better-fix.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
