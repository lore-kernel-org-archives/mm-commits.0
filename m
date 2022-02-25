Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E865C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Feb 2022 04:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbiBYEGA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Feb 2022 23:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiBYEF6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Feb 2022 23:05:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE93235337
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 20:05:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83BDC61844
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 04:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DE6C340E7;
        Fri, 25 Feb 2022 04:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645761913;
        bh=YmCG602l0nyyY8FcOWX3cVsKTIKUi6bDLuD7x7qZw2Y=;
        h=Date:To:From:Subject:From;
        b=PHbSzrLs0T7JULS6PhCdBN5b/R023deS9M2Df7Ea+x7qzorzEh1M0W/Ifi04I/hUH
         lD1i3HM79fPRXwAMR7IEIhzTGs038W222xHhxnMgiluQHgZ5CYV30OO73AJoqOi9jz
         R0QAcpj+ebV5WgPNg3udsA6AFe7zVG5kLTxih0+U=
Date:   Thu, 24 Feb 2022 20:05:13 -0800
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + linux-next-git-rejects.patch added to -mm tree
Message-Id: <20220225040513.D6DE6C340E7@smtp.kernel.org>
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

 arch/x86/kvm/x86.c                                      |    3 
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c       |    4 -
 drivers/gpu/drm/i915/display/intel_bw.c                 |   32 ----------
 drivers/gpu/drm/i915/display/intel_snps_phy.c           |    5 -
 drivers/gpu/drm/tegra/Kconfig                           |    3 
 drivers/gpu/drm/tegra/dpaux.c                           |    5 -
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h |    7 --
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c  |    3 
 include/uapi/linux/kvm.h                                |    3 
 tools/testing/selftests/net/mptcp/mptcp_join.sh         |   13 ----
 10 files changed, 78 deletions(-)

--- a/arch/x86/kvm/x86.c~linux-next-git-rejects
+++ a/arch/x86/kvm/x86.c
@@ -4248,10 +4248,7 @@ int kvm_vm_ioctl_check_extension(struct
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_SYS_ATTRIBUTES:
 	case KVM_CAP_ENABLE_CAP:
-<<<<<<< HEAD
-=======
 	case KVM_CAP_VAPIC:
->>>>>>> linux-next/akpm-base
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1981,10 +1981,6 @@ enum dc_status dc_remove_stream_from_ctx
 				dc->res_pool,
 			del_pipe->stream_res.stream_enc,
 			false);
-<<<<<<< HEAD
-#if defined(CONFIG_DRM_AMD_DC_DCN)
-=======
->>>>>>> linux-next/akpm-base
 	if (is_dp_128b_132b_signal(del_pipe)) {
 		update_hpo_dp_stream_engine_usage(
 			&new_ctx->res_ctx, dc->res_pool,
--- a/drivers/gpu/drm/i915/display/intel_bw.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/display/intel_bw.c
@@ -818,30 +818,9 @@ int intel_bw_calc_min_cdclk(struct intel
 
 static u16 icl_qgv_points_mask(struct drm_i915_private *i915)
 {
-<<<<<<< HEAD
-	struct drm_i915_private *dev_priv = to_i915(state->base.dev);
-	struct intel_crtc_state *new_crtc_state, *old_crtc_state;
-	struct intel_bw_state *new_bw_state = NULL;
-	const struct intel_bw_state *old_bw_state = NULL;
-	unsigned int data_rate;
-	unsigned int num_active_planes;
-	struct intel_crtc *crtc;
-	int i, ret;
-	u32 allowed_points = 0;
-	unsigned int max_bw_point = 0, max_bw = 0;
-	unsigned int num_qgv_points = dev_priv->max_bw[0].num_qgv_points;
-	unsigned int num_psf_gv_points = dev_priv->max_bw[0].num_psf_gv_points;
-	bool changed = false;
-	u32 mask = 0;
-
-	/* FIXME earlier gens need some checks too */
-	if (DISPLAY_VER(dev_priv) < 11)
-		return 0;
-=======
 	unsigned int num_psf_gv_points = i915->max_bw[0].num_psf_gv_points;
 	unsigned int num_qgv_points = i915->max_bw[0].num_qgv_points;
 	u16 mask = 0;
->>>>>>> linux-next/akpm-base
 
 	/*
 	 * We can _not_ use the whole ADLS_QGV_PT_MASK here, as PCode rejects
@@ -891,25 +870,15 @@ static int intel_bw_check_data_rate(stru
 		new_bw_state->data_rate[crtc->pipe] = new_data_rate;
 		new_bw_state->num_active_planes[crtc->pipe] = new_active_planes;
 
-<<<<<<< HEAD
-		changed = true;
-
-		drm_dbg_kms(&dev_priv->drm,
-			    "pipe %c data rate %u num active planes %u\n",
-			    pipe_name(crtc->pipe),
-=======
 		*changed = true;
 
 		drm_dbg_kms(&i915->drm,
 			    "[CRTC:%d:%s] data rate %u num active planes %u\n",
 			    crtc->base.base.id, crtc->base.name,
->>>>>>> linux-next/akpm-base
 			    new_bw_state->data_rate[crtc->pipe],
 			    new_bw_state->num_active_planes[crtc->pipe]);
 	}
 
-<<<<<<< HEAD
-=======
 	return 0;
 }
 
@@ -935,7 +904,6 @@ int intel_bw_atomic_check(struct intel_a
 	if (ret)
 		return ret;
 
->>>>>>> linux-next/akpm-base
 	old_bw_state = intel_atomic_get_old_bw_state(state);
 	new_bw_state = intel_atomic_get_new_bw_state(state);
 
--- a/drivers/gpu/drm/i915/display/intel_snps_phy.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/display/intel_snps_phy.c
@@ -34,13 +34,8 @@ void intel_snps_phy_wait_for_calibration
 
 		if (intel_de_wait_for_clear(i915, DG2_PHY_MISC(phy),
 					    DG2_PHY_DP_TX_ACK_MASK, 25))
-<<<<<<< HEAD
-			DRM_ERROR("SNPS PHY %c failed to calibrate after 25ms.\n",
-				  phy_name(phy));
-=======
 			drm_err(&i915->drm, "SNPS PHY %c failed to calibrate after 25ms.\n",
 				phy_name(phy));
->>>>>>> linux-next/akpm-base
 	}
 }
 
--- a/drivers/gpu/drm/tegra/dpaux.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/tegra/dpaux.c
@@ -18,13 +18,8 @@
 #include <linux/reset.h>
 #include <linux/workqueue.h>
 
-<<<<<<< HEAD
-#include <drm/drm_dp_helper.h>
-#include <drm/drm_dp_aux_bus.h>
-=======
 #include <drm/dp/drm_dp_helper.h>
 #include <drm/dp/drm_dp_aux_bus.h>
->>>>>>> linux-next/akpm-base
 #include <drm/drm_panel.h>
 
 #include "dp.h"
--- a/drivers/gpu/drm/tegra/Kconfig~linux-next-git-rejects
+++ a/drivers/gpu/drm/tegra/Kconfig
@@ -5,10 +5,7 @@ config DRM_TEGRA
 	depends on COMMON_CLK
 	depends on DRM
 	depends on OF
-<<<<<<< HEAD
-=======
 	select DRM_DP_HELPER
->>>>>>> linux-next/akpm-base
 	select DRM_DP_AUX_BUS
 	select DRM_KMS_HELPER
 	select DRM_MIPI_DSI
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h~linux-next-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -17,21 +17,14 @@ struct mlx5e_tc_act_parse_state {
 	struct mlx5e_tc_flow *flow;
 	struct netlink_ext_ack *extack;
 	bool ct_clear;
-<<<<<<< HEAD
-=======
 	u32 actions;
 	bool ct;
->>>>>>> linux-next/akpm-base
 	bool encap;
 	bool decap;
 	bool mpls_push;
 	bool ptype_host;
 	const struct ip_tunnel_info *tun_info;
 	struct mlx5e_mpls_info mpls_info;
-<<<<<<< HEAD
-	struct pedit_headers_action hdrs[__PEDIT_CMD_MAX];
-=======
->>>>>>> linux-next/akpm-base
 	int ifindexes[MLX5_MAX_FLOW_FWD_VPORTS];
 	int if_count;
 	struct mlx5_tc_ct_priv *ct_priv;
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
@@ -46,14 +46,11 @@ tc_act_parse_ct(struct mlx5e_tc_act_pars
 		attr->esw_attr->split_count = attr->esw_attr->out_count;
 
 	parse_state->ct_clear = clear_action;
-<<<<<<< HEAD
-=======
 	if (!clear_action) {
 		attr->flags |= MLX5_ATTR_FLAG_CT;
 		flow_flag_set(parse_state->flow, CT);
 		parse_state->ct = true;
 	}
->>>>>>> linux-next/akpm-base
 
 	return 0;
 }
--- a/include/uapi/linux/kvm.h~linux-next-git-rejects
+++ a/include/uapi/linux/kvm.h
@@ -1141,10 +1141,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
 #define KVM_CAP_PPC_AIL_MODE_3 210
-<<<<<<< HEAD
-=======
 #define KVM_CAP_S390_MEM_OP_EXTENSION 211
->>>>>>> linux-next/akpm-base
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh~linux-next-git-rejects
+++ a/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1302,18 +1302,6 @@ signal_address_tests()
 
 	# signal addresses race test
 	reset
-<<<<<<< HEAD
-	ip netns exec $ns1 ./pm_nl_ctl limits 4 4
-	ip netns exec $ns2 ./pm_nl_ctl limits 4 4
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.4.1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.1.2 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags signal
-=======
 
 	pm_nl_set_limits $ns1 4 4
 	pm_nl_set_limits $ns2 4 4
@@ -1325,7 +1313,6 @@ signal_address_tests()
 	pm_nl_add_endpoint $ns2 10.0.2.2 flags signal
 	pm_nl_add_endpoint $ns2 10.0.3.2 flags signal
 	pm_nl_add_endpoint $ns2 10.0.4.2 flags signal
->>>>>>> linux-next/akpm-base
 
 	# the peer could possibly miss some addr notification, allow retransmission
 	ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=1
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
x86-mm-enable-arch_has_vm_get_page_prot-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpu-drm-dp-drm_dpc-fix-build.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

