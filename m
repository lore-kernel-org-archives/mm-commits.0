From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 06 Sep 2016 10:58:16 -0700
Message-ID: <57cf03b8.7qKzsaGej+En11vq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55719 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938515AbcIFR6R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2016 13:58:17 -0400
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

 drivers/gpu/drm/i915/intel_drv.h                  |    3 -
 drivers/infiniband/hw/mlx4/cq.c                   |   17 ----------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c   |    5 ---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |   19 +-----------
 sound/soc/generic/Makefile                        |    3 -
 sound/soc/generic/simple-card-utils.c             |    6 ---
 sound/soc/omap/omap-abe-twl6040.c                 |   18 -----------
 7 files changed, 2 insertions(+), 69 deletions(-)

diff -puN drivers/gpu/drm/i915/intel_drv.h~linux-next-git-rejects drivers/gpu/drm/i915/intel_drv.h
--- a/drivers/gpu/drm/i915/intel_drv.h~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_drv.h
@@ -1745,14 +1745,11 @@ void skl_ddb_get_hw_state(struct drm_i91
 bool skl_can_enable_sagv(struct drm_atomic_state *state);
 int skl_enable_sagv(struct drm_i915_private *dev_priv);
 int skl_disable_sagv(struct drm_i915_private *dev_priv);
-<<<<<<< HEAD
-=======
 void skl_write_cursor_wm(struct intel_crtc *intel_crtc,
 			 const struct skl_wm_values *wm);
 void skl_write_plane_wm(struct intel_crtc *intel_crtc,
 			const struct skl_wm_values *wm,
 			int plane);
->>>>>>> linux-next/akpm-base
 uint32_t ilk_pipe_pixel_rate(const struct intel_crtc_state *pipe_config);
 bool ilk_disable_lp_wm(struct drm_device *dev);
 int sanitize_rc6_option(struct drm_i915_private *dev_priv, int enable_rc6);
diff -puN drivers/infiniband/hw/mlx4/cq.c~linux-next-git-rejects drivers/infiniband/hw/mlx4/cq.c
--- a/drivers/infiniband/hw/mlx4/cq.c~linux-next-git-rejects
+++ a/drivers/infiniband/hw/mlx4/cq.c
@@ -576,14 +576,9 @@ static int mlx4_ib_ipoib_csum_ok(__be16
 		checksum == cpu_to_be16(0xffff);
 }
 
-<<<<<<< HEAD
-static void use_tunnel_data(struct mlx4_ib_qp *qp, struct mlx4_ib_cq *cq, struct ib_wc *wc,
-			    unsigned tail, struct mlx4_cqe *cqe, int is_eth)
-=======
 static void use_tunnel_data(struct mlx4_ib_qp *qp, struct mlx4_ib_cq *cq,
 			    struct ib_wc *wc, unsigned tail,
 			    struct mlx4_cqe *cqe, int is_eth)
->>>>>>> linux-next/akpm-base
 {
 	struct mlx4_ib_proxy_sqp_hdr *hdr;
 
@@ -696,11 +691,7 @@ repoll:
 	if (unlikely((cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) == MLX4_OPCODE_NOP &&
 		     is_send)) {
 		pr_warn("Completion for NOP opcode detected!\n");
-<<<<<<< HEAD
-		return -EAGAIN;
-=======
 		goto out;
->>>>>>> linux-next/akpm-base
 	}
 
 	/* Resize CQ in progress */
@@ -731,11 +722,7 @@ repoll:
 		if (unlikely(!mqp)) {
 			pr_warn("CQ %06x with entry for unknown QPN %06x\n",
 			       cq->mcq.cqn, be32_to_cpu(cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK);
-<<<<<<< HEAD
-			return -EAGAIN;
-=======
 			goto out;
->>>>>>> linux-next/akpm-base
 		}
 
 		*cur_qp = to_mibqp(mqp);
@@ -753,11 +740,7 @@ repoll:
 		if (unlikely(!msrq)) {
 			pr_warn("CQ %06x with entry for unknown SRQN %06x\n",
 				cq->mcq.cqn, srq_num);
-<<<<<<< HEAD
-			return -EAGAIN;
-=======
 			goto out;
->>>>>>> linux-next/akpm-base
 		}
 	}
 
diff -puN drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c~linux-next-git-rejects drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -4476,17 +4476,12 @@ static void cfg_queues(struct adapter *a
 
 	/* Reduce memory usage in kdump environment, disable all offload.
 	 */
-<<<<<<< HEAD
-	if (is_kdump_kernel())
-		adap->params.offload = 0;
-=======
 	if (is_kdump_kernel()) {
 		adap->params.offload = 0;
 		adap->params.crypto = 0;
 	} else if (adap->num_uld && uld_mem_alloc(adap)) {
 		adap->params.crypto = 0;
 	}
->>>>>>> linux-next/akpm-base
 
 	for_each_port(adap, i)
 		n10g += is_x_10g_port(&adap2pinfo(adap, i)->link_cfg);
diff -puN drivers/net/ethernet/mellanox/mlx5/core/en_main.c~linux-next-git-rejects drivers/net/ethernet/mellanox/mlx5/core/en_main.c
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3209,19 +3209,13 @@ static void mlx5e_destroy_q_counter(stru
 
 static int mlx5e_create_umr_mkey(struct mlx5e_priv *priv)
 {
+#if 0
 	struct mlx5_core_dev *mdev = priv->mdev;
-<<<<<<< HEAD
 	struct mlx5_create_mkey_mbox_in *in;
 	struct mlx5_mkey_seg *mkc;
 	int inlen = sizeof(*in);
 	u64 npages = MLX5E_REQUIRED_MTTS(priv->profile->max_nch(mdev),
 					 BIT(MLX5E_PARAMS_MAXIMUM_LOG_RQ_SIZE_MPW));
-=======
-	u64 npages = priv->profile->max_nch(mdev) * MLX5_CHANNEL_MAX_NUM_MTTS;
-	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
-	void *mkc;
-	u32 *in;
->>>>>>> linux-next/akpm-base
 	int err;
 
 	in = mlx5_vzalloc(inlen);
@@ -3230,21 +3224,11 @@ static int mlx5e_create_umr_mkey(struct
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
 
-<<<<<<< HEAD
-	npages = min_t(u32, ALIGN(U16_MAX, 4) * 2, npages);
-
-	mkc->qpn_mkey7_0 = cpu_to_be32(0xffffff << 8);
-	mkc->flags_pd = cpu_to_be32(mdev->mlx5e_res.pdn);
-	mkc->len = cpu_to_be64(npages << PAGE_SHIFT);
-	mkc->xlt_oct_size = cpu_to_be32(MLX5_MTT_OCTW(npages));
-	mkc->log2_page_size = PAGE_SHIFT;
-=======
 	MLX5_SET(mkc, mkc, free, 1);
 	MLX5_SET(mkc, mkc, umr_en, 1);
 	MLX5_SET(mkc, mkc, lw, 1);
 	MLX5_SET(mkc, mkc, lr, 1);
 	MLX5_SET(mkc, mkc, access_mode, MLX5_MKC_ACCESS_MODE_MTT);
->>>>>>> linux-next/akpm-base
 
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 	MLX5_SET(mkc, mkc, pd, mdev->mlx5e_res.pdn);
@@ -3257,6 +3241,7 @@ static int mlx5e_create_umr_mkey(struct
 
 	kvfree(in);
 	return err;
+#endif
 }
 
 static void mlx5e_nic_init(struct mlx5_core_dev *mdev,
diff -puN sound/soc/generic/Makefile~linux-next-git-rejects sound/soc/generic/Makefile
--- a/sound/soc/generic/Makefile~linux-next-git-rejects
+++ a/sound/soc/generic/Makefile
@@ -4,7 +4,4 @@ snd-soc-simple-scu-card-objs	:= simple-s
 
 obj-$(CONFIG_SND_SIMPLE_CARD_UTILS)	+= snd-soc-simple-card-utils.o
 obj-$(CONFIG_SND_SIMPLE_CARD)		+= snd-soc-simple-card.o
-<<<<<<< HEAD
-=======
 obj-$(CONFIG_SND_SIMPLE_SCU_CARD)	+= snd-soc-simple-scu-card.o
->>>>>>> linux-next/akpm-base
diff -puN sound/soc/generic/simple-card-utils.c~linux-next-git-rejects sound/soc/generic/simple-card-utils.c
--- a/sound/soc/generic/simple-card-utils.c~linux-next-git-rejects
+++ a/sound/soc/generic/simple-card-utils.c
@@ -7,10 +7,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-<<<<<<< HEAD
-=======
 #include <linux/clk.h>
->>>>>>> linux-next/akpm-base
 #include <linux/module.h>
 #include <linux/of.h>
 #include <sound/simple_card_utils.h>
@@ -101,8 +98,6 @@ int asoc_simple_card_parse_card_name(str
 }
 EXPORT_SYMBOL_GPL(asoc_simple_card_parse_card_name);
 
-<<<<<<< HEAD
-=======
 int asoc_simple_card_parse_clk(struct device_node *node,
 			       struct device_node *dai_of_node,
 			       struct asoc_simple_dai *simple_dai)
@@ -243,7 +238,6 @@ int asoc_simple_card_clean_reference(str
 }
 EXPORT_SYMBOL_GPL(asoc_simple_card_clean_reference);
 
->>>>>>> linux-next/akpm-base
 /* Module information */
 MODULE_AUTHOR("Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>");
 MODULE_DESCRIPTION("ALSA SoC Simple Card Utils");
diff -puN sound/soc/omap/omap-abe-twl6040.c~linux-next-git-rejects sound/soc/omap/omap-abe-twl6040.c
--- a/sound/soc/omap/omap-abe-twl6040.c~linux-next-git-rejects
+++ a/sound/soc/omap/omap-abe-twl6040.c
@@ -305,32 +305,14 @@ static int omap_abe_probe(struct platfor
 
 	snd_soc_card_set_drvdata(card, priv);
 
-<<<<<<< HEAD
-	ret = snd_soc_register_card(card);
-	if (ret)
-		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
-=======
 	ret = devm_snd_soc_register_card(&pdev->dev, card);
 	if (ret)
 		dev_err(&pdev->dev, "devm_snd_soc_register_card() failed: %d\n",
->>>>>>> linux-next/akpm-base
 			ret);
 
 	return ret;
 }
 
-<<<<<<< HEAD
-static int omap_abe_remove(struct platform_device *pdev)
-{
-	struct snd_soc_card *card = platform_get_drvdata(pdev);
-
-	snd_soc_unregister_card(card);
-
-	return 0;
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static const struct of_device_id omap_abe_of_match[] = {
 	{.compatible = "ti,abe-twl6040", },
 	{ },
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
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
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

