Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B582AC433B4
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 22:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81C4F61027
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 22:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235611AbhDKWsn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Apr 2021 18:48:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235474AbhDKWsm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 11 Apr 2021 18:48:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3A5A61003;
        Sun, 11 Apr 2021 22:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618181303;
        bh=+nSH21rRvGsZrXOJOJSZTJEH3BAZbnwVJM4xbwY5xRw=;
        h=Date:From:To:Subject:From;
        b=1QlhybkdUIY7vfwD8xqBltP3IlIW5NR4d5XD6S/df7HJsLfEmnRDZLPcaSwMPZWVT
         KHS8N0NJtzCegQXDRIdDyYX6No0AT8VFAt9YOf8UDmTpHBrUR0dOyoX1mAly5Akknn
         +GrqrKKEmufqimQz7AkJPFdbt4M3oXPMea/9xJhg=
Date:   Sun, 11 Apr 2021 15:48:23 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210411224823.h82D8%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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

 drivers/base/dd.c                                 |    3 
 drivers/gpu/drm/vc4/vc4_plane.c                   |   24 
 drivers/net/dsa/lantiq_gswip.c                    |    8 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  315 ------------
 drivers/scsi/ufs/ufshcd.c                         |    4 
 drivers/target/iscsi/iscsi_target.c               |    4 
 include/linux/bpf.h                               |    3 
 include/linux/ethtool.h                           |    3 
 include/linux/skmsg.h                             |   16 
 net/core/skmsg.c                                  |   18 
 net/ipv6/addrconf.c                               |   12 
 11 files changed, 410 deletions(-)

--- a/drivers/base/dd.c~linux-next-git-rejects
+++ a/drivers/base/dd.c
@@ -300,11 +300,8 @@ int driver_deferred_probe_check_state(st
 static void deferred_probe_timeout_work_func(struct work_struct *work)
 {
 	struct device_private *p;
-<<<<<<< HEAD
-=======
 
 	fw_devlink_drivers_done();
->>>>>>> linux-next/akpm-base
 
 	driver_deferred_probe_timeout = 0;
 	driver_deferred_probe_trigger();
--- a/drivers/gpu/drm/vc4/vc4_plane.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/vc4/vc4_plane.c
@@ -1141,29 +1141,6 @@ static void vc4_plane_atomic_async_updat
 										 plane);
 	struct vc4_plane_state *vc4_state, *new_vc4_state;
 
-<<<<<<< HEAD
-	swap(plane->state->fb, state->fb);
-	plane->state->crtc_x = state->crtc_x;
-	plane->state->crtc_y = state->crtc_y;
-	plane->state->crtc_w = state->crtc_w;
-	plane->state->crtc_h = state->crtc_h;
-	plane->state->src_x = state->src_x;
-	plane->state->src_y = state->src_y;
-	plane->state->src_w = state->src_w;
-	plane->state->src_h = state->src_h;
-	plane->state->alpha = state->alpha;
-	plane->state->pixel_blend_mode = state->pixel_blend_mode;
-	plane->state->rotation = state->rotation;
-	plane->state->zpos = state->zpos;
-	plane->state->normalized_zpos = state->normalized_zpos;
-	plane->state->color_encoding = state->color_encoding;
-	plane->state->color_range = state->color_range;
-	plane->state->src = state->src;
-	plane->state->dst = state->dst;
-	plane->state->visible = state->visible;
-
-	new_vc4_state = to_vc4_plane_state(state);
-=======
 	swap(plane->state->fb, new_plane_state->fb);
 	plane->state->crtc_x = new_plane_state->crtc_x;
 	plane->state->crtc_y = new_plane_state->crtc_y;
@@ -1185,7 +1162,6 @@ static void vc4_plane_atomic_async_updat
 	plane->state->visible = new_plane_state->visible;
 
 	new_vc4_state = to_vc4_plane_state(new_plane_state);
->>>>>>> linux-next/akpm-base
 	vc4_state = to_vc4_plane_state(plane->state);
 
 	vc4_state->crtc_x = new_vc4_state->crtc_x;
--- a/drivers/net/dsa/lantiq_gswip.c~linux-next-git-rejects
+++ a/drivers/net/dsa/lantiq_gswip.c
@@ -827,17 +827,9 @@ static int gswip_setup(struct dsa_switch
 	/* Configure the MDIO Clock 2.5 MHz */
 	gswip_mdio_mask(priv, 0xff, 0x09, GSWIP_MDIO_MDC_CFG1);
 
-<<<<<<< HEAD
-	/* Disable the xMII interface and clear it's isolation bit */
-	for (i = 0; i < priv->hw_info->max_ports; i++)
-		gswip_mii_mask_cfg(priv,
-				   GSWIP_MII_CFG_EN | GSWIP_MII_CFG_ISOLATE,
-				   0, i);
-=======
 	for (i = 0; i < priv->hw_info->max_ports; i++) {
 		/* Disable the xMII link */
 		gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, i);
->>>>>>> linux-next/akpm-base
 
 		/* Automatically select the xMII interface clock */
 		gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_RATE_MASK,
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1040,11 +1040,7 @@ static int mlx5e_alloc_icosq(struct mlx5
 	int err;
 
 	sq->channel   = c;
-<<<<<<< HEAD
-	sq->uar_map   = mdev->mlx5e_res.bfreg.map;
-=======
 	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
->>>>>>> linux-next/akpm-base
 	sq->reserved_room = param->stop_room;
 
 	param->wq.db_numa_node = cpu_to_node(c->cpu);
@@ -2066,317 +2062,6 @@ static void mlx5e_close_channel(struct m
 	kvfree(c);
 }
 
-<<<<<<< HEAD
-#define DEFAULT_FRAG_SIZE (2048)
-
-static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
-				      struct mlx5e_params *params,
-				      struct mlx5e_xsk_param *xsk,
-				      struct mlx5e_rq_frags_info *info)
-{
-	u32 byte_count = MLX5E_SW2HW_MTU(params, params->sw_mtu);
-	int frag_size_max = DEFAULT_FRAG_SIZE;
-	u32 buf_size = 0;
-	int i;
-
-	if (mlx5_fpga_is_ipsec_device(mdev))
-		byte_count += MLX5E_METADATA_ETHER_LEN;
-
-	if (mlx5e_rx_is_linear_skb(params, xsk)) {
-		int frag_stride;
-
-		frag_stride = mlx5e_rx_get_linear_frag_sz(params, xsk);
-		frag_stride = roundup_pow_of_two(frag_stride);
-
-		info->arr[0].frag_size = byte_count;
-		info->arr[0].frag_stride = frag_stride;
-		info->num_frags = 1;
-		info->wqe_bulk = PAGE_SIZE / frag_stride;
-		goto out;
-	}
-
-	if (byte_count > PAGE_SIZE +
-	    (MLX5E_MAX_RX_FRAGS - 1) * frag_size_max)
-		frag_size_max = PAGE_SIZE;
-
-	i = 0;
-	while (buf_size < byte_count) {
-		int frag_size = byte_count - buf_size;
-
-		if (i < MLX5E_MAX_RX_FRAGS - 1)
-			frag_size = min(frag_size, frag_size_max);
-
-		info->arr[i].frag_size = frag_size;
-		info->arr[i].frag_stride = roundup_pow_of_two(frag_size);
-
-		buf_size += frag_size;
-		i++;
-	}
-	info->num_frags = i;
-	/* number of different wqes sharing a page */
-	info->wqe_bulk = 1 + (info->num_frags % 2);
-
-out:
-	info->wqe_bulk = max_t(u8, info->wqe_bulk, 8);
-	info->log_num_frags = order_base_2(info->num_frags);
-}
-
-static inline u8 mlx5e_get_rqwq_log_stride(u8 wq_type, int ndsegs)
-{
-	int sz = sizeof(struct mlx5_wqe_data_seg) * ndsegs;
-
-	switch (wq_type) {
-	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
-		sz += sizeof(struct mlx5e_rx_wqe_ll);
-		break;
-	default: /* MLX5_WQ_TYPE_CYCLIC */
-		sz += sizeof(struct mlx5e_rx_wqe_cyc);
-	}
-
-	return order_base_2(sz);
-}
-
-static u8 mlx5e_get_rq_log_wq_sz(void *rqc)
-{
-	void *wq = MLX5_ADDR_OF(rqc, rqc, wq);
-
-	return MLX5_GET(wq, wq, log_wq_sz);
-}
-
-void mlx5e_build_rq_param(struct mlx5e_priv *priv,
-			  struct mlx5e_params *params,
-			  struct mlx5e_xsk_param *xsk,
-			  struct mlx5e_rq_param *param)
-{
-	struct mlx5_core_dev *mdev = priv->mdev;
-	void *rqc = param->rqc;
-	void *wq = MLX5_ADDR_OF(rqc, rqc, wq);
-	int ndsegs = 1;
-
-	switch (params->rq_wq_type) {
-	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
-		MLX5_SET(wq, wq, log_wqe_num_of_strides,
-			 mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk) -
-			 MLX5_MPWQE_LOG_NUM_STRIDES_BASE);
-		MLX5_SET(wq, wq, log_wqe_stride_size,
-			 mlx5e_mpwqe_get_log_stride_size(mdev, params, xsk) -
-			 MLX5_MPWQE_LOG_STRIDE_SZ_BASE);
-		MLX5_SET(wq, wq, log_wq_sz, mlx5e_mpwqe_get_log_rq_size(params, xsk));
-		break;
-	default: /* MLX5_WQ_TYPE_CYCLIC */
-		MLX5_SET(wq, wq, log_wq_sz, params->log_rq_mtu_frames);
-		mlx5e_build_rq_frags_info(mdev, params, xsk, &param->frags_info);
-		ndsegs = param->frags_info.num_frags;
-	}
-
-	MLX5_SET(wq, wq, wq_type,          params->rq_wq_type);
-	MLX5_SET(wq, wq, end_padding_mode, MLX5_WQ_END_PAD_MODE_ALIGN);
-	MLX5_SET(wq, wq, log_wq_stride,
-		 mlx5e_get_rqwq_log_stride(params->rq_wq_type, ndsegs));
-	MLX5_SET(wq, wq, pd,               mdev->mlx5e_res.pdn);
-	MLX5_SET(rqc, rqc, counter_set_id, priv->q_counter);
-	MLX5_SET(rqc, rqc, vsd,            params->vlan_strip_disable);
-	MLX5_SET(rqc, rqc, scatter_fcs,    params->scatter_fcs_en);
-
-	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(mdev));
-	mlx5e_build_rx_cq_param(priv, params, xsk, &param->cqp);
-}
-
-static void mlx5e_build_drop_rq_param(struct mlx5e_priv *priv,
-				      struct mlx5e_rq_param *param)
-{
-	struct mlx5_core_dev *mdev = priv->mdev;
-	void *rqc = param->rqc;
-	void *wq = MLX5_ADDR_OF(rqc, rqc, wq);
-
-	MLX5_SET(wq, wq, wq_type, MLX5_WQ_TYPE_CYCLIC);
-	MLX5_SET(wq, wq, log_wq_stride,
-		 mlx5e_get_rqwq_log_stride(MLX5_WQ_TYPE_CYCLIC, 1));
-	MLX5_SET(rqc, rqc, counter_set_id, priv->drop_rq_q_counter);
-
-	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(mdev));
-}
-
-void mlx5e_build_sq_param_common(struct mlx5e_priv *priv,
-				 struct mlx5e_sq_param *param)
-{
-	void *sqc = param->sqc;
-	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
-
-	MLX5_SET(wq, wq, log_wq_stride, ilog2(MLX5_SEND_WQE_BB));
-	MLX5_SET(wq, wq, pd,            priv->mdev->mlx5e_res.pdn);
-
-	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(priv->mdev));
-}
-
-void mlx5e_build_sq_param(struct mlx5e_priv *priv, struct mlx5e_params *params,
-			  struct mlx5e_sq_param *param)
-{
-	void *sqc = param->sqc;
-	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
-	bool allow_swp;
-
-	allow_swp = mlx5_geneve_tx_allowed(priv->mdev) ||
-		    !!MLX5_IPSEC_DEV(priv->mdev);
-	mlx5e_build_sq_param_common(priv, param);
-	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
-	MLX5_SET(sqc, sqc, allow_swp, allow_swp);
-	param->is_mpw = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_SKB_TX_MPWQE);
-	param->stop_room = mlx5e_calc_sq_stop_room(priv->mdev, params);
-	mlx5e_build_tx_cq_param(priv, params, &param->cqp);
-}
-
-static void mlx5e_build_common_cq_param(struct mlx5e_priv *priv,
-					struct mlx5e_cq_param *param)
-{
-	void *cqc = param->cqc;
-
-	MLX5_SET(cqc, cqc, uar_page, priv->mdev->priv.uar->index);
-	if (MLX5_CAP_GEN(priv->mdev, cqe_128_always) && cache_line_size() >= 128)
-		MLX5_SET(cqc, cqc, cqe_sz, CQE_STRIDE_128_PAD);
-}
-
-void mlx5e_build_rx_cq_param(struct mlx5e_priv *priv,
-			     struct mlx5e_params *params,
-			     struct mlx5e_xsk_param *xsk,
-			     struct mlx5e_cq_param *param)
-{
-	struct mlx5_core_dev *mdev = priv->mdev;
-	bool hw_stridx = false;
-	void *cqc = param->cqc;
-	u8 log_cq_size;
-
-	switch (params->rq_wq_type) {
-	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
-		log_cq_size = mlx5e_mpwqe_get_log_rq_size(params, xsk) +
-			mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk);
-		hw_stridx = MLX5_CAP_GEN(mdev, mini_cqe_resp_stride_index);
-		break;
-	default: /* MLX5_WQ_TYPE_CYCLIC */
-		log_cq_size = params->log_rq_mtu_frames;
-	}
-
-	MLX5_SET(cqc, cqc, log_cq_size, log_cq_size);
-	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS)) {
-		MLX5_SET(cqc, cqc, mini_cqe_res_format, hw_stridx ?
-			 MLX5_CQE_FORMAT_CSUM_STRIDX : MLX5_CQE_FORMAT_CSUM);
-		MLX5_SET(cqc, cqc, cqe_comp_en, 1);
-	}
-
-	mlx5e_build_common_cq_param(priv, param);
-	param->cq_period_mode = params->rx_cq_moderation.cq_period_mode;
-}
-
-void mlx5e_build_tx_cq_param(struct mlx5e_priv *priv,
-			     struct mlx5e_params *params,
-			     struct mlx5e_cq_param *param)
-{
-	void *cqc = param->cqc;
-
-	MLX5_SET(cqc, cqc, log_cq_size, params->log_sq_size);
-
-	mlx5e_build_common_cq_param(priv, param);
-	param->cq_period_mode = params->tx_cq_moderation.cq_period_mode;
-}
-
-void mlx5e_build_ico_cq_param(struct mlx5e_priv *priv,
-			      u8 log_wq_size,
-			      struct mlx5e_cq_param *param)
-{
-	void *cqc = param->cqc;
-
-	MLX5_SET(cqc, cqc, log_cq_size, log_wq_size);
-
-	mlx5e_build_common_cq_param(priv, param);
-
-	param->cq_period_mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
-}
-
-void mlx5e_build_icosq_param(struct mlx5e_priv *priv,
-			     u8 log_wq_size,
-			     struct mlx5e_sq_param *param)
-{
-	void *sqc = param->sqc;
-	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
-
-	mlx5e_build_sq_param_common(priv, param);
-
-	MLX5_SET(wq, wq, log_wq_sz, log_wq_size);
-	MLX5_SET(sqc, sqc, reg_umr, MLX5_CAP_ETH(priv->mdev, reg_umr_sq));
-	mlx5e_build_ico_cq_param(priv, log_wq_size, &param->cqp);
-}
-
-static void mlx5e_build_async_icosq_param(struct mlx5e_priv *priv,
-					  struct mlx5e_params *params,
-					  u8 log_wq_size,
-					  struct mlx5e_sq_param *param)
-{
-	void *sqc = param->sqc;
-	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
-
-	mlx5e_build_sq_param_common(priv, param);
-
-	/* async_icosq is used by XSK only if xdp_prog is active */
-	if (params->xdp_prog)
-		param->stop_room = mlx5e_stop_room_for_wqe(1); /* for XSK NOP */
-	MLX5_SET(sqc, sqc, reg_umr, MLX5_CAP_ETH(priv->mdev, reg_umr_sq));
-	MLX5_SET(wq, wq, log_wq_sz, log_wq_size);
-	mlx5e_build_ico_cq_param(priv, log_wq_size, &param->cqp);
-}
-
-void mlx5e_build_xdpsq_param(struct mlx5e_priv *priv,
-			     struct mlx5e_params *params,
-			     struct mlx5e_sq_param *param)
-{
-	void *sqc = param->sqc;
-	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
-
-	mlx5e_build_sq_param_common(priv, param);
-	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
-	param->is_mpw = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_XDP_TX_MPWQE);
-	mlx5e_build_tx_cq_param(priv, params, &param->cqp);
-}
-
-static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5e_params *params,
-				      struct mlx5e_rq_param *rqp)
-{
-	switch (params->rq_wq_type) {
-	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
-		return max_t(u8, MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE,
-			     order_base_2(MLX5E_UMR_WQEBBS) +
-			     mlx5e_get_rq_log_wq_sz(rqp->rqc));
-	default: /* MLX5_WQ_TYPE_CYCLIC */
-		return MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
-	}
-}
-
-static u8 mlx5e_build_async_icosq_log_wq_sz(struct net_device *netdev)
-{
-	if (netdev->hw_features & NETIF_F_HW_TLS_RX)
-		return MLX5E_PARAMS_DEFAULT_LOG_SQ_SIZE;
-
-	return MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
-}
-
-static void mlx5e_build_channel_param(struct mlx5e_priv *priv,
-				      struct mlx5e_params *params,
-				      struct mlx5e_channel_param *cparam)
-{
-	u8 icosq_log_wq_sz, async_icosq_log_wq_sz;
-
-	mlx5e_build_rq_param(priv, params, NULL, &cparam->rq);
-
-	icosq_log_wq_sz = mlx5e_build_icosq_log_wq_sz(params, &cparam->rq);
-	async_icosq_log_wq_sz = mlx5e_build_async_icosq_log_wq_sz(priv->netdev);
-
-	mlx5e_build_sq_param(priv, params, &cparam->txq_sq);
-	mlx5e_build_xdpsq_param(priv, params, &cparam->xdp_sq);
-	mlx5e_build_icosq_param(priv, icosq_log_wq_sz, &cparam->icosq);
-	mlx5e_build_async_icosq_param(priv, params, async_icosq_log_wq_sz, &cparam->async_icosq);
-}
-
-=======
->>>>>>> linux-next/akpm-base
 int mlx5e_open_channels(struct mlx5e_priv *priv,
 			struct mlx5e_channels *chs)
 {
--- a/drivers/scsi/ufs/ufshcd.c~linux-next-git-rejects
+++ a/drivers/scsi/ufs/ufshcd.c
@@ -6399,11 +6399,7 @@ static int __ufshcd_issue_tm_cmd(struct
 	blk_mq_start_request(req);
 
 	task_tag = req->tag;
-<<<<<<< HEAD
-	treq->req_header.dword_0 |= cpu_to_be32(task_tag);
-=======
 	treq->upiu_req.req_header.dword_0 |= cpu_to_be32(task_tag);
->>>>>>> linux-next/akpm-base
 
 	memcpy(hba->utmrdl_base_addr + task_tag, treq, sizeof(*treq));
 	ufshcd_vops_setup_task_mgmt(hba, task_tag, tm_function);
--- a/drivers/target/iscsi/iscsi_target.c~linux-next-git-rejects
+++ a/drivers/target/iscsi/iscsi_target.c
@@ -1167,12 +1167,8 @@ int iscsit_setup_scsi_cmd(struct iscsi_c
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
 	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
-<<<<<<< HEAD
-	cmd->sense_reason = target_cmd_init_cdb(&cmd->se_cmd, hdr->cdb);
-=======
 	cmd->sense_reason = target_cmd_init_cdb(&cmd->se_cmd, hdr->cdb,
 						GFP_KERNEL);
->>>>>>> linux-next/akpm-base
 	if (cmd->sense_reason) {
 		if (cmd->sense_reason == TCM_OUT_OF_RESOURCES) {
 			return iscsit_add_reject_cmd(cmd,
--- a/include/linux/bpf.h~linux-next-git-rejects
+++ a/include/linux/bpf.h
@@ -41,10 +41,7 @@ struct bpf_local_storage_map;
 struct kobject;
 struct mem_cgroup;
 struct module;
-<<<<<<< HEAD
-=======
 struct bpf_func_state;
->>>>>>> linux-next/akpm-base
 
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
--- a/include/linux/ethtool.h~linux-next-git-rejects
+++ a/include/linux/ethtool.h
@@ -583,8 +583,6 @@ void ethtool_set_ethtool_phy_ops(const s
 void
 ethtool_params_from_link_mode(struct ethtool_link_ksettings *link_ksettings,
 			      enum ethtool_link_mode_bit_indices link_mode);
-<<<<<<< HEAD
-=======
 
 /**
  * ethtool_sprintf - Write formatted string to ethtool string data
@@ -595,5 +593,4 @@ ethtool_params_from_link_mode(struct eth
  * next string.
  */
 extern __printf(2, 3) void ethtool_sprintf(u8 **data, const char *fmt, ...);
->>>>>>> linux-next/akpm-base
 #endif /* _LINUX_ETHTOOL_H */
--- a/include/linux/skmsg.h~linux-next-git-rejects
+++ a/include/linux/skmsg.h
@@ -403,25 +403,9 @@ static inline void sk_psock_cork_free(st
 static inline void sk_psock_restore_proto(struct sock *sk,
 					  struct sk_psock *psock)
 {
-<<<<<<< HEAD
-	if (inet_csk_has_ulp(sk)) {
-		/* TLS does not have an unhash proto in SW cases, but we need
-		 * to ensure we stop using the sock_map unhash routine because
-		 * the associated psock is being removed. So use the original
-		 * unhash handler.
-		 */
-		WRITE_ONCE(sk->sk_prot->unhash, psock->saved_unhash);
-		tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
-	} else {
-		sk->sk_write_space = psock->saved_write_space;
-		/* Pairs with lockless read in sk_clone_lock() */
-		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
-	}
-=======
 	sk->sk_prot->unhash = psock->saved_unhash;
 	if (psock->psock_update_sk_prot)
 		psock->psock_update_sk_prot(sk, true);
->>>>>>> linux-next/akpm-base
 }
 
 static inline void sk_psock_set_state(struct sk_psock *psock,
--- a/net/core/skmsg.c~linux-next-git-rejects
+++ a/net/core/skmsg.c
@@ -991,14 +991,6 @@ static void sk_psock_strp_read(struct st
 		kfree_skb(skb);
 		goto out;
 	}
-<<<<<<< HEAD
-	prog = READ_ONCE(psock->progs.skb_verdict);
-	if (likely(prog)) {
-		skb->sk = sk;
-		tcp_skb_bpf_redirect_clear(skb);
-		ret = sk_psock_bpf_run(psock, prog, skb);
-		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
-=======
 	prog = READ_ONCE(psock->progs.stream_verdict);
 	if (likely(prog)) {
 		skb->sk = sk;
@@ -1006,7 +998,6 @@ static void sk_psock_strp_read(struct st
 		skb_bpf_redirect_clear(skb);
 		ret = bpf_prog_run_pin_on_cpu(prog, skb);
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
->>>>>>> linux-next/akpm-base
 		skb->sk = NULL;
 	}
 	sk_psock_verdict_apply(psock, skb, ret);
@@ -1121,14 +1112,6 @@ static int sk_psock_verdict_recv(read_de
 		kfree_skb(skb);
 		goto out;
 	}
-<<<<<<< HEAD
-	prog = READ_ONCE(psock->progs.skb_verdict);
-	if (likely(prog)) {
-		skb->sk = sk;
-		tcp_skb_bpf_redirect_clear(skb);
-		ret = sk_psock_bpf_run(psock, prog, skb);
-		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
-=======
 	prog = READ_ONCE(psock->progs.stream_verdict);
 	if (!prog)
 		prog = READ_ONCE(psock->progs.skb_verdict);
@@ -1138,7 +1121,6 @@ static int sk_psock_verdict_recv(read_de
 		skb_bpf_redirect_clear(skb);
 		ret = bpf_prog_run_pin_on_cpu(prog, skb);
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
->>>>>>> linux-next/akpm-base
 		skb->sk = NULL;
 	}
 	sk_psock_verdict_apply(psock, skb, ret);
--- a/net/ipv6/addrconf.c~linux-next-git-rejects
+++ a/net/ipv6/addrconf.c
@@ -5687,7 +5687,6 @@ static int inet6_set_iftoken(struct inet
 
 	if (dev->flags & IFF_LOOPBACK) {
 		NL_SET_ERR_MSG_MOD(extack, "Device is loopback");
-<<<<<<< HEAD
 		return -EINVAL;
 	}
 
@@ -5697,17 +5696,6 @@ static int inet6_set_iftoken(struct inet
 		return -EINVAL;
 	}
 
-=======
-		return -EINVAL;
-	}
-
-	if (dev->flags & IFF_NOARP) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Device does not do neighbour discovery");
-		return -EINVAL;
-	}
-
->>>>>>> linux-next/akpm-base
 	if (!ipv6_accept_ra(idev)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Router advertisement is disabled on device");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

