From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 14 Jan 2016 12:09:08 -0800
Message-ID: <56980064.+YyAycSnmojX5Nhi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbcANUJK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 15:09:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


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

 drivers/acpi/acpi_lpss.c                          |   10 -
 drivers/i2c/busses/i2c-designware-platdrv.c       |    3 
 drivers/infiniband/hw/mlx5/main.c                 |    4 
 drivers/net/ethernet/mellanox/mlx5/core/vport.c   |   67 -------
 drivers/net/wireless/intel/iwlegacy/4965-mac.c    |    9 
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c |    9 
 drivers/net/wireless/st/cw1200/sta.c              |    6 
 drivers/s390/char/zcore.c                         |  112 ------------
 include/linux/fs.h                                |   28 ---
 include/linux/mlx5/device.h                       |    4 
 include/linux/mlx5/mlx5_ifc.h                     |   29 ---
 include/linux/mlx5/vport.h                        |    6 
 include/linux/pci_ids.h                           |    3 
 include/net/mac80211.h                            |    6 
 net/mac80211/offchannel.c                         |   62 ------
 net/mac80211/sta_info.c                           |    4 
 16 files changed, 362 deletions(-)

diff -puN drivers/acpi/acpi_lpss.c~linux-next-git-rejects drivers/acpi/acpi_lpss.c
--- a/drivers/acpi/acpi_lpss.c~linux-next-git-rejects
+++ a/drivers/acpi/acpi_lpss.c
@@ -876,21 +876,14 @@ static int acpi_lpss_platform_notify(str
 
 	switch (action) {
 	case BUS_NOTIFY_BIND_DRIVER:
-<<<<<<< HEAD
-		pdev->dev.pm_domain = &acpi_lpss_pm_domain;
-=======
 		dev_pm_domain_set(&pdev->dev, &acpi_lpss_pm_domain);
->>>>>>> linux-next/akpm-base
 		break;
 	case BUS_NOTIFY_DRIVER_NOT_BOUND:
 	case BUS_NOTIFY_UNBOUND_DRIVER:
 		pdev->dev.pm_domain = NULL;
 		break;
 	case BUS_NOTIFY_ADD_DEVICE:
-<<<<<<< HEAD
-=======
 		dev_pm_domain_set(&pdev->dev, &acpi_lpss_pm_domain);
->>>>>>> linux-next/akpm-base
 		if (pdata->dev_desc->flags & LPSS_LTR)
 			return sysfs_create_group(&pdev->dev.kobj,
 						  &lpss_attr_group);
@@ -898,10 +891,7 @@ static int acpi_lpss_platform_notify(str
 	case BUS_NOTIFY_DEL_DEVICE:
 		if (pdata->dev_desc->flags & LPSS_LTR)
 			sysfs_remove_group(&pdev->dev.kobj, &lpss_attr_group);
-<<<<<<< HEAD
-=======
 		dev_pm_domain_set(&pdev->dev, NULL);
->>>>>>> linux-next/akpm-base
 		break;
 	default:
 		break;
diff -puN drivers/i2c/busses/i2c-designware-platdrv.c~linux-next-git-rejects drivers/i2c/busses/i2c-designware-platdrv.c
--- a/drivers/i2c/busses/i2c-designware-platdrv.c~linux-next-git-rejects
+++ a/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -123,10 +123,7 @@ static const struct acpi_device_id dw_i2
 	{ "80860F41", 0 },
 	{ "808622C1", 0 },
 	{ "AMD0010", ACCESS_INTR_MASK },
-<<<<<<< HEAD
-=======
 	{ "AMDI0510", 0 },
->>>>>>> linux-next/akpm-base
 	{ "APMC0D0F", 0 },
 	{ }
 };
diff -puN drivers/infiniband/hw/mlx5/main.c~linux-next-git-rejects drivers/infiniband/hw/mlx5/main.c
--- a/drivers/infiniband/hw/mlx5/main.c~linux-next-git-rejects
+++ a/drivers/infiniband/hw/mlx5/main.c
@@ -2252,11 +2252,7 @@ static void *mlx5_ib_add(struct mlx5_cor
 			(1ull << IB_USER_VERBS_CMD_CLOSE_XRCD);
 	}
 
-<<<<<<< HEAD
-	if (mlx5_ib_port_link_layer(&dev->ib_dev) ==
-=======
 	if (mlx5_ib_port_link_layer(&dev->ib_dev, 1) ==
->>>>>>> linux-next/akpm-base
 	    IB_LINK_LAYER_ETHERNET) {
 		dev->ib_dev.create_flow	= mlx5_ib_create_flow;
 		dev->ib_dev.destroy_flow = mlx5_ib_destroy_flow;
diff -puN drivers/net/ethernet/mellanox/mlx5/core/vport.c~linux-next-git-rejects drivers/net/ethernet/mellanox/mlx5/core/vport.c
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -77,7 +77,6 @@ u8 mlx5_query_vport_admin_state(struct m
 	return MLX5_GET(query_vport_state_out, out, admin_state);
 }
 EXPORT_SYMBOL(mlx5_query_vport_admin_state);
-<<<<<<< HEAD
 
 int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
 				  u16 vport, u8 state)
@@ -136,66 +135,6 @@ static int mlx5_modify_nic_vport_context
 	return mlx5_cmd_exec_check_status(mdev, in, inlen, out, sizeof(out));
 }
 
-=======
-
-int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
-				  u16 vport, u8 state)
-{
-	u32 in[MLX5_ST_SZ_DW(modify_vport_state_in)];
-	u32 out[MLX5_ST_SZ_DW(modify_vport_state_out)];
-	int err;
-
-	memset(in, 0, sizeof(in));
-
-	MLX5_SET(modify_vport_state_in, in, opcode,
-		 MLX5_CMD_OP_MODIFY_VPORT_STATE);
-	MLX5_SET(modify_vport_state_in, in, op_mod, opmod);
-	MLX5_SET(modify_vport_state_in, in, vport_number, vport);
-
-	if (vport)
-		MLX5_SET(modify_vport_state_in, in, other_vport, 1);
-
-	MLX5_SET(modify_vport_state_in, in, admin_state, state);
-
-	err = mlx5_cmd_exec_check_status(mdev, in, sizeof(in), out,
-					 sizeof(out));
-	if (err)
-		mlx5_core_warn(mdev, "MLX5_CMD_OP_MODIFY_VPORT_STATE failed\n");
-
-	return err;
-}
-EXPORT_SYMBOL(mlx5_modify_vport_admin_state);
-
-static int mlx5_query_nic_vport_context(struct mlx5_core_dev *mdev, u16 vport,
-					u32 *out, int outlen)
-{
-	u32 in[MLX5_ST_SZ_DW(query_nic_vport_context_in)];
-
-	memset(in, 0, sizeof(in));
-
-	MLX5_SET(query_nic_vport_context_in, in, opcode,
-		 MLX5_CMD_OP_QUERY_NIC_VPORT_CONTEXT);
-
-	MLX5_SET(query_nic_vport_context_in, in, vport_number, vport);
-	if (vport)
-		MLX5_SET(query_nic_vport_context_in, in, other_vport, 1);
-
-	return mlx5_cmd_exec_check_status(mdev, in, sizeof(in), out, outlen);
-}
-
-static int mlx5_modify_nic_vport_context(struct mlx5_core_dev *mdev, void *in,
-					 int inlen)
-{
-	u32 out[MLX5_ST_SZ_DW(modify_nic_vport_context_out)];
-
-	MLX5_SET(modify_nic_vport_context_in, in, opcode,
-		 MLX5_CMD_OP_MODIFY_NIC_VPORT_CONTEXT);
-
-	memset(out, 0, sizeof(out));
-	return mlx5_cmd_exec_check_status(mdev, in, inlen, out, sizeof(out));
-}
-
->>>>>>> linux-next/akpm-base
 int mlx5_query_nic_vport_mac_address(struct mlx5_core_dev *mdev,
 				     u16 vport, u8 *addr)
 {
@@ -490,8 +429,6 @@ int mlx5_modify_nic_vport_vlans(struct m
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_modify_nic_vport_vlans);
-<<<<<<< HEAD
-=======
 
 int mlx5_query_nic_vport_system_image_guid(struct mlx5_core_dev *mdev,
 					   u64 *system_image_guid)
@@ -554,7 +491,6 @@ int mlx5_query_nic_vport_qkey_viol_cntr(
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mlx5_query_nic_vport_qkey_viol_cntr);
->>>>>>> linux-next/akpm-base
 
 int mlx5_query_hca_vport_gid(struct mlx5_core_dev *dev, u8 other_vport,
 			     u8 port_num, u16  vf_num, u16 gid_index,
@@ -876,8 +812,6 @@ int mlx5_modify_nic_vport_promisc(struct
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_modify_nic_vport_promisc);
-<<<<<<< HEAD
-=======
 
 enum mlx5_vport_roce_state {
 	MLX5_VPORT_ROCE_DISABLED = 0,
@@ -919,4 +853,3 @@ int mlx5_nic_vport_disable_roce(struct m
 	return mlx5_nic_vport_update_roce_state(mdev, MLX5_VPORT_ROCE_DISABLED);
 }
 EXPORT_SYMBOL_GPL(mlx5_nic_vport_disable_roce);
->>>>>>> linux-next/akpm-base
diff -puN drivers/net/wireless/intel/iwlegacy/4965-mac.c~linux-next-git-rejects drivers/net/wireless/intel/iwlegacy/4965-mac.c
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c~linux-next-git-rejects
+++ a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -5982,14 +5982,6 @@ il4965_mac_set_key(struct ieee80211_hw *
 
 int
 il4965_mac_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-<<<<<<< HEAD
-			enum ieee80211_ampdu_mlme_action action,
-			struct ieee80211_sta *sta, u16 tid, u16 * ssn,
-			u8 buf_size, bool amsdu)
-{
-	struct il_priv *il = hw->priv;
-	int ret = -EINVAL;
-=======
 			struct ieee80211_ampdu_params *params)
 {
 	struct il_priv *il = hw->priv;
@@ -5998,7 +5990,6 @@ il4965_mac_ampdu_action(struct ieee80211
 	enum ieee80211_ampdu_mlme_action action = params->action;
 	u16 tid = params->tid;
 	u16 *ssn = &params->ssn;
->>>>>>> linux-next/akpm-base
 
 	D_HT("A-MPDU action on addr %pM tid %d\n", sta->addr, tid);
 
diff -puN drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c~linux-next-git-rejects drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c~linux-next-git-rejects
+++ a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -732,14 +732,6 @@ static inline bool iwl_enable_tx_ampdu(c
 
 static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
-<<<<<<< HEAD
-				   enum ieee80211_ampdu_mlme_action action,
-				   struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-				   u8 buf_size, bool amsdu)
-{
-	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
-	int ret = -EINVAL;
-=======
 				   struct ieee80211_ampdu_params *params)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
@@ -749,7 +741,6 @@ static int iwlagn_mac_ampdu_action(struc
 	u16 tid = params->tid;
 	u16 *ssn = &params->ssn;
 	u8 buf_size = params->buf_size;
->>>>>>> linux-next/akpm-base
 	struct iwl_station_priv *sta_priv = (void *) sta->drv_priv;
 
 	IWL_DEBUG_HT(priv, "A-MPDU action on addr %pM tid %d\n",
diff -puN drivers/net/wireless/st/cw1200/sta.c~linux-next-git-rejects drivers/net/wireless/st/cw1200/sta.c
--- a/drivers/net/wireless/st/cw1200/sta.c~linux-next-git-rejects
+++ a/drivers/net/wireless/st/cw1200/sta.c
@@ -2129,13 +2129,7 @@ void cw1200_mcast_timeout(unsigned long
 
 int cw1200_ampdu_action(struct ieee80211_hw *hw,
 			struct ieee80211_vif *vif,
-<<<<<<< HEAD
-			enum ieee80211_ampdu_mlme_action action,
-			struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			u8 buf_size, bool amsdu)
-=======
 			struct ieee80211_ampdu_params *params)
->>>>>>> linux-next/akpm-base
 {
 	/* Aggregation is implemented fully in firmware,
 	 * including block ack negotiation. Do not allow
diff -puN drivers/s390/char/zcore.c~linux-next-git-rejects drivers/s390/char/zcore.c
--- a/drivers/s390/char/zcore.c~linux-next-git-rejects
+++ a/drivers/s390/char/zcore.c
@@ -140,118 +140,6 @@ static void release_hsa(void)
 	hsa_available = 0;
 }
 
-<<<<<<< HEAD
-/*
- * Read routine for zcore character device
- * First 4K are dump header
- * Next 32MB are HSA Memory
- * Rest is read from absolute Memory
- */
-static ssize_t zcore_read(struct file *file, char __user *buf, size_t count,
-			  loff_t *ppos)
-{
-	unsigned long mem_start; /* Start address in memory */
-	size_t mem_offs;	 /* Offset in dump memory */
-	size_t hdr_count;	 /* Size of header part of output buffer */
-	size_t size;
-	int rc;
-
-	mutex_lock(&zcore_mutex);
-
-	if (*ppos > (sys_info.mem_size + HEADER_SIZE)) {
-		rc = -EINVAL;
-		goto fail;
-	}
-
-	count = min(count, (size_t) (sys_info.mem_size + HEADER_SIZE - *ppos));
-
-	/* Copy dump header */
-	if (*ppos < HEADER_SIZE) {
-		size = min(count, (size_t) (HEADER_SIZE - *ppos));
-		if (copy_to_user(buf, &zcore_header + *ppos, size)) {
-			rc = -EFAULT;
-			goto fail;
-		}
-		hdr_count = size;
-		mem_start = 0;
-	} else {
-		hdr_count = 0;
-		mem_start = *ppos - HEADER_SIZE;
-	}
-
-	mem_offs = 0;
-
-	/* Copy from HSA data */
-	if (*ppos < sclp.hsa_size + HEADER_SIZE) {
-		size = min((count - hdr_count),
-			   (size_t) (sclp.hsa_size - mem_start));
-		rc = memcpy_hsa_user(buf + hdr_count, mem_start, size);
-		if (rc)
-			goto fail;
-
-		mem_offs += size;
-	}
-
-	/* Copy from real mem */
-	size = count - mem_offs - hdr_count;
-	rc = copy_to_user_real(buf + hdr_count + mem_offs,
-			       (void *) mem_start + mem_offs, size);
-	if (rc)
-		goto fail;
-
-	/*
-	 * Since s390 dump analysis tools like lcrash or crash
-	 * expect register sets in the prefix pages of the cpus,
-	 * we copy them into the read buffer, if necessary.
-	 * buf + hdr_count: Start of memory part of output buffer
-	 * mem_start: Start memory address to copy from
-	 * count - hdr_count: Size of memory area to copy
-	 */
-	if (zcore_add_lc(buf + hdr_count, mem_start, count - hdr_count)) {
-		rc = -EFAULT;
-		goto fail;
-	}
-	*ppos += count;
-fail:
-	mutex_unlock(&zcore_mutex);
-	return (rc < 0) ? rc : count;
-}
-
-static int zcore_open(struct inode *inode, struct file *filp)
-{
-	if (!hsa_available)
-		return -ENODATA;
-	else
-		return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
-}
-
-static int zcore_release(struct inode *inode, struct file *filep)
-{
-	if (hsa_available)
-		release_hsa();
-	return 0;
-}
-
-static loff_t zcore_lseek(struct file *file, loff_t offset, int orig)
-{
-	loff_t rc;
-
-	mutex_lock(&zcore_mutex);
-	rc = no_seek_end_llseek(file, offset, orig);
-	mutex_unlock(&zcore_mutex);
-	return rc;
-}
-
-static const struct file_operations zcore_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= zcore_lseek,
-	.read		= zcore_read,
-	.open		= zcore_open,
-	.release	= zcore_release,
-};
-
-=======
->>>>>>> linux-next/akpm-base
 static ssize_t zcore_memmap_read(struct file *filp, char __user *buf,
 				 size_t count, loff_t *ppos)
 {
diff -puN include/linux/fs.h~linux-next-git-rejects include/linux/fs.h
--- a/include/linux/fs.h~linux-next-git-rejects
+++ a/include/linux/fs.h
@@ -2099,38 +2099,11 @@ static inline int locks_mandatory_locked
 }
 
 static inline int locks_mandatory_area(struct inode *inode, struct file *filp,
-<<<<<<< HEAD
-                                       loff_t start, loff_t end, unsigned char type)
-{
-	return 0;
-}
-
-static inline int __mandatory_lock(struct inode *inode)
-{
-	return 0;
-}
-
-static inline int mandatory_lock(struct inode *inode)
-{
-	return 0;
-}
-
-static inline int locks_verify_locked(struct file *file)
-{
-	return 0;
-}
-
-static inline int locks_verify_truncate(struct inode *inode, struct file *filp,
-					size_t size)
-=======
 		loff_t start, loff_t end, unsigned char type)
->>>>>>> linux-next/akpm-base
 {
 	return 0;
 }
 
-<<<<<<< HEAD
-=======
 static inline int __mandatory_lock(struct inode *inode)
 {
 	return 0;
@@ -2152,7 +2125,6 @@ static inline int locks_verify_truncate(
 	return 0;
 }
 
->>>>>>> linux-next/akpm-base
 #endif /* CONFIG_MANDATORY_FILE_LOCKING */
 
 
diff -puN include/linux/mlx5/device.h~linux-next-git-rejects include/linux/mlx5/device.h
--- a/include/linux/mlx5/device.h~linux-next-git-rejects
+++ a/include/linux/mlx5/device.h
@@ -466,11 +466,7 @@ struct mlx5_init_seg {
 	__be32			rsvd2[880];
 	__be32			internal_timer_h;
 	__be32			internal_timer_l;
-<<<<<<< HEAD
-	__be32			rsrv3[2];
-=======
 	__be32			rsvd3[2];
->>>>>>> linux-next/akpm-base
 	__be32			health_counter;
 	__be32			rsvd4[1019];
 	__be64			ieee1588_clk;
diff -puN include/linux/mlx5/mlx5_ifc.h~linux-next-git-rejects include/linux/mlx5/mlx5_ifc.h
--- a/include/linux/mlx5/mlx5_ifc.h~linux-next-git-rejects
+++ a/include/linux/mlx5/mlx5_ifc.h
@@ -858,28 +858,18 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_66[0x8];
 	u8         log_uar_page_sz[0x10];
 
-<<<<<<< HEAD
-	u8         reserved_67[0x40];
-	u8         device_frequency_khz[0x20];
-	u8         reserved_68[0x5f];
-=======
 	u8	   reserved_67[0x20];
 	u8	   device_frequency_mhz[0x20];
 	u8	   device_frequency_khz[0x20];
 	u8         reserved_68[0xa0];
 
 	u8         reserved_69[0x1f];
->>>>>>> linux-next/akpm-base
 	u8         cqe_zip[0x1];
 
 	u8         cqe_zip_timeout[0x10];
 	u8         cqe_zip_max_num[0x10];
 
-<<<<<<< HEAD
-	u8         reserved_69[0x220];
-=======
 	u8         reserved_70[0x220];
->>>>>>> linux-next/akpm-base
 };
 
 enum mlx5_flow_destination_type {
@@ -2231,14 +2221,6 @@ struct mlx5_ifc_nic_vport_context_bits {
 	u8         event_on_vlan_change[0x1];
 	u8         event_on_mc_address_change[0x1];
 	u8         event_on_uc_address_change[0x1];
-<<<<<<< HEAD
-
-	u8         reserved_2[0xf0];
-
-	u8         mtu[0x10];
-
-	u8         reserved_3[0x640];
-=======
 
 	u8         reserved_2[0xf0];
 
@@ -2251,29 +2233,18 @@ struct mlx5_ifc_nic_vport_context_bits {
 	u8         reserved_3[0x140];
 	u8         qkey_violation_counter[0x10];
 	u8         reserved_4[0x430];
->>>>>>> linux-next/akpm-base
 
 	u8         promisc_uc[0x1];
 	u8         promisc_mc[0x1];
 	u8         promisc_all[0x1];
-<<<<<<< HEAD
-	u8         reserved_4[0x2];
-	u8         allowed_list_type[0x3];
-	u8         reserved_5[0xc];
-=======
 	u8         reserved_5[0x2];
 	u8         allowed_list_type[0x3];
 	u8         reserved_6[0xc];
->>>>>>> linux-next/akpm-base
 	u8         allowed_list_size[0xc];
 
 	struct mlx5_ifc_mac_address_layout_bits permanent_address;
 
-<<<<<<< HEAD
-	u8         reserved_6[0x20];
-=======
 	u8         reserved_7[0x20];
->>>>>>> linux-next/akpm-base
 
 	u8         current_uc_mac_address[0][0x40];
 };
diff -puN include/linux/mlx5/vport.h~linux-next-git-rejects include/linux/mlx5/vport.h
--- a/include/linux/mlx5/vport.h~linux-next-git-rejects
+++ a/include/linux/mlx5/vport.h
@@ -45,14 +45,11 @@ int mlx5_query_nic_vport_mac_address(str
 				     u16 vport, u8 *addr);
 int mlx5_modify_nic_vport_mac_address(struct mlx5_core_dev *dev,
 				      u16 vport, u8 *addr);
-<<<<<<< HEAD
-=======
 int mlx5_query_nic_vport_system_image_guid(struct mlx5_core_dev *mdev,
 					   u64 *system_image_guid);
 int mlx5_query_nic_vport_node_guid(struct mlx5_core_dev *mdev, u64 *node_guid);
 int mlx5_query_nic_vport_qkey_viol_cntr(struct mlx5_core_dev *mdev,
 					u16 *qkey_viol_cntr);
->>>>>>> linux-next/akpm-base
 int mlx5_query_hca_vport_gid(struct mlx5_core_dev *dev, u8 other_vport,
 			     u8 port_num, u16  vf_num, u16 gid_index,
 			     union ib_gid *gid);
@@ -92,11 +89,8 @@ int mlx5_query_nic_vport_vlans(struct ml
 int mlx5_modify_nic_vport_vlans(struct mlx5_core_dev *dev,
 				u16 vlans[],
 				int list_size);
-<<<<<<< HEAD
-=======
 
 int mlx5_nic_vport_enable_roce(struct mlx5_core_dev *mdev);
 int mlx5_nic_vport_disable_roce(struct mlx5_core_dev *mdev);
->>>>>>> linux-next/akpm-base
 
 #endif /* __MLX5_VPORT_H__ */
diff -puN include/linux/pci_ids.h~linux-next-git-rejects include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~linux-next-git-rejects
+++ a/include/linux/pci_ids.h
@@ -2496,13 +2496,10 @@
 #define PCI_DEVICE_ID_KORENIX_JETCARDF3	0x17ff
 
 #define PCI_VENDOR_ID_NETRONOME		0x19ee
-<<<<<<< HEAD
-=======
 #define PCI_DEVICE_ID_NETRONOME_NFP3200	0x3200
 #define PCI_DEVICE_ID_NETRONOME_NFP3240	0x3240
 #define PCI_DEVICE_ID_NETRONOME_NFP6000	0x6000
 #define PCI_DEVICE_ID_NETRONOME_NFP6000_VF	0x6003
->>>>>>> linux-next/akpm-base
 
 #define PCI_VENDOR_ID_QMI		0x1a32
 
diff -puN include/net/mac80211.h~linux-next-git-rejects include/net/mac80211.h
--- a/include/net/mac80211.h~linux-next-git-rejects
+++ a/include/net/mac80211.h
@@ -1954,14 +1954,11 @@ struct ieee80211_txq {
  *	by just its MAC address; this prevents, for example, the same station
  *	from connecting to two virtual AP interfaces at the same time.
  *
-<<<<<<< HEAD
-=======
  * @IEEE80211_HW_SUPPORTS_REORDERING_BUFFER: Hardware (or driver) manages the
  *	reordering buffer internally, guaranteeing mac80211 receives frames in
  *	order and does not need to manage its own reorder buffer or BA session
  *	timeout.
  *
->>>>>>> linux-next/akpm-base
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -1998,10 +1995,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_AMSDU_IN_AMPDU,
 	IEEE80211_HW_BEACON_TX_STATUS,
 	IEEE80211_HW_NEEDS_UNIQUE_STA_ADDR,
-<<<<<<< HEAD
-=======
 	IEEE80211_HW_SUPPORTS_REORDERING_BUFFER,
->>>>>>> linux-next/akpm-base
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff -puN net/mac80211/offchannel.c~linux-next-git-rejects net/mac80211/offchannel.c
--- a/net/mac80211/offchannel.c~linux-next-git-rejects
+++ a/net/mac80211/offchannel.c
@@ -252,20 +252,11 @@ static bool ieee80211_recalc_sw_work(str
 static void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc,
 					 unsigned long start_time)
 {
-<<<<<<< HEAD
-	struct ieee80211_local *local = roc->sdata->local;
-
-=======
->>>>>>> linux-next/akpm-base
 	if (WARN_ON(roc->notified))
 		return;
 
 	roc->start_time = start_time;
 	roc->started = true;
-<<<<<<< HEAD
-	roc->hw_begun = true;
-=======
->>>>>>> linux-next/akpm-base
 
 	if (roc->mgmt_tx_cookie) {
 		if (!WARN_ON(!roc->frame)) {
@@ -297,10 +288,7 @@ static void ieee80211_hw_roc_start(struc
 		if (!roc->started)
 			break;
 
-<<<<<<< HEAD
-=======
 		roc->hw_begun = true;
->>>>>>> linux-next/akpm-base
 		ieee80211_handle_roc_started(roc, local->hw_roc_start_time);
 	}
 
@@ -400,7 +388,6 @@ static void _ieee80211_start_next_roc(st
 
 		ieee80211_queue_delayed_work(&local->hw, &local->roc_work,
 					     msecs_to_jiffies(min_dur));
-<<<<<<< HEAD
 
 		/* tell userspace or send frame(s) */
 		list_for_each_entry(tmp, &local->roc_list, list) {
@@ -413,20 +400,6 @@ static void _ieee80211_start_next_roc(st
 	}
 }
 
-=======
-
-		/* tell userspace or send frame(s) */
-		list_for_each_entry(tmp, &local->roc_list, list) {
-			if (tmp->sdata != roc->sdata || tmp->chan != roc->chan)
-				break;
-
-			tmp->on_channel = roc->on_channel;
-			ieee80211_handle_roc_started(tmp, jiffies);
-		}
-	}
-}
-
->>>>>>> linux-next/akpm-base
 void ieee80211_start_next_roc(struct ieee80211_local *local)
 {
 	struct ieee80211_roc_work *roc;
@@ -438,13 +411,10 @@ void ieee80211_start_next_roc(struct iee
 		return;
 	}
 
-<<<<<<< HEAD
-=======
 	/* defer roc if driver is not started (i.e. during reconfig) */
 	if (local->in_reconfig)
 		return;
 
->>>>>>> linux-next/akpm-base
 	roc = list_first_entry(&local->roc_list, struct ieee80211_roc_work,
 			       list);
 
@@ -566,15 +536,10 @@ ieee80211_coalesce_hw_started_roc(struct
 	 * begin, otherwise they'll both be marked properly by the work
 	 * struct that runs once the driver notifies us of the beginning
 	 */
-<<<<<<< HEAD
-	if (cur_roc->hw_begun)
-		ieee80211_handle_roc_started(new_roc, now);
-=======
 	if (cur_roc->hw_begun) {
 		new_roc->hw_begun = true;
 		ieee80211_handle_roc_started(new_roc, now);
 	}
->>>>>>> linux-next/akpm-base
 
 	return true;
 }
@@ -697,10 +662,7 @@ static int ieee80211_start_roc_work(stru
 			queued = true;
 			roc->on_channel = tmp->on_channel;
 			ieee80211_handle_roc_started(roc, now);
-<<<<<<< HEAD
-=======
 			ieee80211_recalc_sw_work(local, now);
->>>>>>> linux-next/akpm-base
 			break;
 		}
 
@@ -750,11 +712,8 @@ static int ieee80211_cancel_roc(struct i
 	mutex_lock(&local->mtx);
 	list_for_each_entry_safe(roc, tmp, &local->roc_list, list) {
 		if (!mgmt_tx && roc->cookie != cookie)
-<<<<<<< HEAD
-=======
 			continue;
 		else if (mgmt_tx && roc->mgmt_tx_cookie != cookie)
->>>>>>> linux-next/akpm-base
 			continue;
 		else if (mgmt_tx && roc->mgmt_tx_cookie != cookie)
 			continue;
@@ -773,8 +732,6 @@ static int ieee80211_cancel_roc(struct i
 		goto out_unlock;
 	}
 
-<<<<<<< HEAD
-=======
 		found = roc;
 		break;
 	}
@@ -789,29 +746,11 @@ static int ieee80211_cancel_roc(struct i
 		goto out_unlock;
 	}
 
->>>>>>> linux-next/akpm-base
 	if (local->ops->remain_on_channel) {
 		ret = drv_cancel_remain_on_channel(local);
 		if (WARN_ON_ONCE(ret)) {
 			mutex_unlock(&local->mtx);
 			return ret;
-<<<<<<< HEAD
-		}
-
-		/* TODO:
-		 * if multiple items were combined here then we really shouldn't
-		 * cancel them all - we should wait for as much time as needed
-		 * for the longest remaining one, and only then cancel ...
-		 */
-		list_for_each_entry_safe(roc, tmp, &local->roc_list, list) {
-			if (!roc->started)
-				break;
-			if (roc == found)
-				found = NULL;
-			ieee80211_roc_notify_destroy(roc);
-		}
-
-=======
 		}
 
 		/* TODO:
@@ -827,7 +766,6 @@ static int ieee80211_cancel_roc(struct i
 			ieee80211_roc_notify_destroy(roc);
 		}
 
->>>>>>> linux-next/akpm-base
 		/* that really must not happen - it was started */
 		WARN_ON(found);
 
diff -puN net/mac80211/sta_info.c~linux-next-git-rejects net/mac80211/sta_info.c
--- a/net/mac80211/sta_info.c~linux-next-git-rejects
+++ a/net/mac80211/sta_info.c
@@ -1451,11 +1451,7 @@ ieee80211_sta_ps_deliver_response(struct
 
 	more_data = ieee80211_sta_ps_more_data(sta, ignored_acs, reason, driver_release_tids);
 
-<<<<<<< HEAD
-	if (reason == IEEE80211_FRAME_RELEASE_PSPOLL)
-=======
 	if (driver_release_tids && reason == IEEE80211_FRAME_RELEASE_PSPOLL)
->>>>>>> linux-next/akpm-base
 		driver_release_tids =
 			BIT(find_highest_prio_tid(driver_release_tids));
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount-checkpatch-fixes.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
mm-vmalloc-remove-vm_vpages-fix.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch
mm-support-madvisemadv_free-fix-2-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-3.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
mm-mlockc-change-can_do_mlock-return-value-type-to-boolean-fix.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix.patch
mm-soft-offline-exit-with-failure-for-non-anonymous-thp-fix.patch
kernel-stop_machinec-remove-config_smp-dependencies.patch
kernel-stop_machinec-remove-config_smp-dependencies-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch
printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix-fix.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
fs-coredump-prevent-core-path-components-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch
linux-next-rejects.patch
fs-overlayfs-superc-needs-pagemaph.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-adfs-adfsh-tidy-up-comments.patch
net-drop-tcp_memcontrolc-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

