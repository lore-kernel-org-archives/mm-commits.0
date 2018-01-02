From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Tue, 02 Jan 2018 11:51:50 -0800
Message-ID: <20180102195150.oiMaClCdn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58476 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751127AbeABTvw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jan 2018 14:51:52 -0500
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

 drivers/clk/clk.c                                           |    3 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |   36 
 drivers/gpu/drm/drm_syncobj.c                               |    3 
 drivers/gpu/drm/i915/intel_ddi.c                            |    4 
 drivers/gpu/drm/i915/intel_display.c                        |   28 
 drivers/net/ethernet/netronome/nfp/bpf/main.c               |   56 -
 drivers/net/phy/marvell.c                                   |    4 
 kernel/bpf/verifier.c                                       |    3 
 net/ipv6/route.c                                            |    6 
 tools/testing/selftests/bpf/test_verifier.c                 |  553 ----------
 10 files changed, 696 deletions(-)

diff -puN drivers/clk/clk.c~linux-next-git-rejects drivers/clk/clk.c
--- a/drivers/clk/clk.c~linux-next-git-rejects
+++ a/drivers/clk/clk.c
@@ -1821,8 +1821,6 @@ static void clk_change_rate(struct clk_c
 		clk_change_rate(core->new_child);
 
 	clk_pm_runtime_put(core);
-<<<<<<< HEAD
-=======
 }
 
 static unsigned long clk_core_req_round_rate_nolock(struct clk_core *core,
@@ -1850,7 +1848,6 @@ static unsigned long clk_core_req_round_
 	clk_core_rate_restore_protect(core, cnt);
 
 	return ret ? 0 : req.rate;
->>>>>>> linux-next/akpm-base
 }
 
 static int clk_core_set_rate_nolock(struct clk_core *core,
diff -puN drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c~linux-next-git-rejects drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -216,42 +216,6 @@ void dm_dp_mst_dc_sink_create(struct drm
 					&aconnector->base, aconnector->edid);
 }
 
-void dm_dp_mst_dc_sink_create(struct drm_connector *connector)
-{
-	struct amdgpu_dm_connector *aconnector = to_amdgpu_dm_connector(connector);
-	struct edid *edid;
-	struct dc_sink *dc_sink;
-	struct dc_sink_init_data init_params = {
-			.link = aconnector->dc_link,
-			.sink_signal = SIGNAL_TYPE_DISPLAY_PORT_MST };
-
-	edid = drm_dp_mst_get_edid(connector, &aconnector->mst_port->mst_mgr, aconnector->port);
-
-	if (!edid) {
-		drm_mode_connector_update_edid_property(
-			&aconnector->base,
-			NULL);
-		return;
-	}
-
-	aconnector->edid = edid;
-
-	dc_sink = dc_link_add_remote_sink(
-		aconnector->dc_link,
-		(uint8_t *)aconnector->edid,
-		(aconnector->edid->extensions + 1) * EDID_LENGTH,
-		&init_params);
-
-	dc_sink->priv = aconnector;
-	aconnector->dc_sink = dc_sink;
-
-	amdgpu_dm_add_sink_to_freesync_module(
-			connector, aconnector->edid);
-
-	drm_mode_connector_update_edid_property(
-					&aconnector->base, aconnector->edid);
-}
-
 static int dm_dp_mst_get_modes(struct drm_connector *connector)
 {
 	struct amdgpu_dm_connector *aconnector = to_amdgpu_dm_connector(connector);
diff -puN drivers/gpu/drm/drm_syncobj.c~linux-next-git-rejects drivers/gpu/drm/drm_syncobj.c
--- a/drivers/gpu/drm/drm_syncobj.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/drm_syncobj.c
@@ -399,8 +399,6 @@ static const struct file_operations drm_
 	.release = drm_syncobj_file_release,
 };
 
-<<<<<<< HEAD
-=======
 static int drm_syncobj_alloc_file(struct drm_syncobj *syncobj)
 {
 	struct file *file = anon_inode_getfile("syncobj_file",
@@ -427,7 +425,6 @@ static int drm_syncobj_alloc_file(struct
  *
  * Returns 0 on success or a negative error value on failure.
  */
->>>>>>> linux-next/akpm-base
 int drm_syncobj_get_fd(struct drm_syncobj *syncobj, int *p_fd)
 {
 	struct file *file;
diff -puN drivers/gpu/drm/i915/intel_ddi.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_ddi.c
--- a/drivers/gpu/drm/i915/intel_ddi.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_ddi.c
@@ -2095,11 +2095,7 @@ static void intel_ddi_clk_select(struct
 	if (WARN_ON(!pll))
 		return;
 
-<<<<<<< HEAD
-	 mutex_lock(&dev_priv->dpll_lock);
-=======
 	mutex_lock(&dev_priv->dpll_lock);
->>>>>>> linux-next/akpm-base
 
 	if (IS_CANNONLAKE(dev_priv)) {
 		/* Configure DPCLKA_CFGCR0 to map the DPLL to the DDI. */
diff -puN drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_display.c
--- a/drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_display.c
@@ -9855,39 +9855,11 @@ found:
 	if (!mode)
 		mode = &load_detect_mode;
 
-<<<<<<< HEAD
-	/* We need a framebuffer large enough to accommodate all accesses
-	 * that the plane may generate whilst we perform load detection.
-	 * We can not rely on the fbcon either being present (we get called
-	 * during its initialisation to detect all boot displays, or it may
-	 * not even exist) or that it is large enough to satisfy the
-	 * requested mode.
-	 */
-	fb = mode_fits_in_fbdev(dev, mode);
-	if (fb == NULL) {
-		DRM_DEBUG_KMS("creating tmp fb for load-detection\n");
-		fb = intel_framebuffer_create_for_mode(dev, mode, 24, 32);
-	} else
-		DRM_DEBUG_KMS("reusing fbdev for load-detection framebuffer\n");
-	if (IS_ERR(fb)) {
-		DRM_DEBUG_KMS("failed to allocate framebuffer for load-detection\n");
-		ret = PTR_ERR(fb);
-		goto fail;
-	}
-
-	ret = intel_modeset_setup_plane_state(state, crtc, mode, fb, 0, 0);
-	drm_framebuffer_put(fb);
-	if (ret)
-		goto fail;
-
-	ret = drm_atomic_set_mode_for_crtc(&crtc_state->base, mode);
-=======
 	ret = drm_atomic_set_mode_for_crtc(&crtc_state->base, mode);
 	if (ret)
 		goto fail;
 
 	ret = intel_modeset_disable_planes(state, crtc);
->>>>>>> linux-next/akpm-base
 	if (ret)
 		goto fail;
 
diff -puN drivers/net/ethernet/netronome/nfp/bpf/main.c~linux-next-git-rejects drivers/net/ethernet/netronome/nfp/bpf/main.c
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/netronome/nfp/bpf/main.c
@@ -84,38 +84,6 @@ static const char *nfp_bpf_extra_cap(str
 	return nfp_net_ebpf_capable(nn) ? "BPF" : "";
 }
 
-<<<<<<< HEAD
-static int
-nfp_bpf_vnic_alloc(struct nfp_app *app, struct nfp_net *nn, unsigned int id)
-{
-	int err;
-
-	nn->app_priv = kzalloc(sizeof(struct nfp_bpf_vnic), GFP_KERNEL);
-	if (!nn->app_priv)
-		return -ENOMEM;
-
-	err = nfp_app_nic_vnic_alloc(app, nn, id);
-	if (err)
-		goto err_free_priv;
-
-	return 0;
-err_free_priv:
-	kfree(nn->app_priv);
-	return err;
-}
-
-static void nfp_bpf_vnic_free(struct nfp_app *app, struct nfp_net *nn)
-{
-	struct nfp_bpf_vnic *bv = nn->app_priv;
-
-	if (nn->dp.bpf_offload_xdp)
-		nfp_bpf_xdp_offload(app, nn, NULL);
-	WARN_ON(bv->tc_prog);
-	kfree(bv);
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static int nfp_bpf_setup_tc_block_cb(enum tc_setup_type type,
 				     void *type_data, void *cb_priv)
 {
@@ -142,26 +110,7 @@ static int nfp_bpf_setup_tc_block_cb(enu
 	if (cls_bpf->command != TC_CLSBPF_OFFLOAD)
 		return -EOPNOTSUPP;
 
-<<<<<<< HEAD
-	bv = nn->app_priv;
-	oldprog = cls_bpf->oldprog;
-
-	/* Don't remove if oldprog doesn't match driver's state */
-	if (bv->tc_prog != oldprog) {
-		oldprog = NULL;
-		if (!cls_bpf->prog)
-			return 0;
-	}
-
-	err = nfp_net_bpf_offload(nn, cls_bpf->prog, oldprog);
-	if (err)
-		return err;
-
-	bv->tc_prog = cls_bpf->prog;
-	return 0;
-=======
 	return nfp_net_bpf_offload(nn, cls_bpf->prog, cls_bpf->oldprog);
->>>>>>> linux-next/akpm-base
 }
 
 static int nfp_bpf_setup_tc_block(struct net_device *netdev,
@@ -322,12 +271,7 @@ const struct nfp_app_type app_bpf = {
 
 	.extra_cap	= nfp_bpf_extra_cap,
 
-<<<<<<< HEAD
-	.vnic_alloc	= nfp_bpf_vnic_alloc,
-	.vnic_free	= nfp_bpf_vnic_free,
-=======
 	.vnic_alloc	= nfp_app_nic_vnic_alloc,
->>>>>>> linux-next/akpm-base
 
 	.setup_tc	= nfp_bpf_setup_tc,
 	.tc_busy	= nfp_bpf_tc_busy,
diff -puN drivers/net/phy/marvell.c~linux-next-git-rejects drivers/net/phy/marvell.c
--- a/drivers/net/phy/marvell.c~linux-next-git-rejects
+++ a/drivers/net/phy/marvell.c
@@ -2083,10 +2083,6 @@ static struct phy_driver marvell_drivers
 		.probe = marvell_probe,
 		.config_init = &m88e1145_config_init,
 		.config_aneg = &m88e1101_config_aneg,
-<<<<<<< HEAD
-		.read_status = &genphy_read_status,
-=======
->>>>>>> linux-next/akpm-base
 		.ack_interrupt = &marvell_ack_interrupt,
 		.config_intr = &marvell_config_intr,
 		.resume = &genphy_resume,
diff -puN kernel/bpf/verifier.c~linux-next-git-rejects kernel/bpf/verifier.c
--- a/kernel/bpf/verifier.c~linux-next-git-rejects
+++ a/kernel/bpf/verifier.c
@@ -1454,8 +1454,6 @@ static void coerce_reg_to_size(struct bp
 	reg->smax_value = reg->umax_value;
 }
 
-<<<<<<< HEAD
-=======
 static int update_stack_depth(struct bpf_verifier_env *env,
 			      const struct bpf_func_state *func,
 			      int off)
@@ -1504,7 +1502,6 @@ static int get_callee_stack_depth(struct
 	return env->subprog_stack_depth[subprog];
 }
 
->>>>>>> linux-next/akpm-base
 /* check whether memory at (regno + off) is accessible for t = (read | write)
  * if t==write, value_regno is a register which value is stored into memory
  * if t==read, value_regno is a register which will receive the value from memory
diff -puN net/ipv6/route.c~linux-next-git-rejects net/ipv6/route.c
--- a/net/ipv6/route.c~linux-next-git-rejects
+++ a/net/ipv6/route.c
@@ -4321,14 +4321,8 @@ static int inet6_rtm_getroute(struct sk_
 		goto errout;
 	}
 
-<<<<<<< HEAD
-	if (fibmatch && rt->dst.from) {
-		struct rt6_info *ort = container_of(rt->dst.from,
-						    struct rt6_info, dst);
-=======
 	if (fibmatch && rt->from) {
 		struct rt6_info *ort = rt->from;
->>>>>>> linux-next/akpm-base
 
 		dst_hold(&ort->dst);
 		ip6_rt_put(rt);
diff -puN tools/testing/selftests/bpf/test_verifier.c~linux-next-git-rejects tools/testing/selftests/bpf/test_verifier.c
--- a/tools/testing/selftests/bpf/test_verifier.c~linux-next-git-rejects
+++ a/tools/testing/selftests/bpf/test_verifier.c
@@ -6753,7 +6753,6 @@ static struct bpf_test tests[] = {
 	},
 	{
 		"bounds check based on zero-extended MOV",
-<<<<<<< HEAD
 		.insns = {
 			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
 			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
@@ -7210,533 +7209,6 @@ static struct bpf_test tests[] = {
 	},
 	{
 		"variable-offset ctx access",
-=======
->>>>>>> linux-next/akpm-base
-		.insns = {
-			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-			BPF_LD_MAP_FD(BPF_REG_1, 0),
-			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
-				     BPF_FUNC_map_lookup_elem),
-			BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 4),
-			/* r2 = 0x0000'0000'ffff'ffff */
-			BPF_MOV32_IMM(BPF_REG_2, 0xffffffff),
-			/* r2 = 0 */
-			BPF_ALU64_IMM(BPF_RSH, BPF_REG_2, 32),
-			/* no-op */
-			BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_2),
-			/* access at offset 0 */
-			BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, 0),
-			/* exit */
-			BPF_MOV64_IMM(BPF_REG_0, 0),
-			BPF_EXIT_INSN(),
-		},
-		.fixup_map1 = { 3 },
-		.result = ACCEPT
-	},
-	{
-		"bounds check based on sign-extended MOV. test1",
-		.insns = {
-			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-			BPF_LD_MAP_FD(BPF_REG_1, 0),
-			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
-				     BPF_FUNC_map_lookup_elem),
-			BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 4),
-			/* r2 = 0xffff'ffff'ffff'ffff */
-			BPF_MOV64_IMM(BPF_REG_2, 0xffffffff),
-			/* r2 = 0xffff'ffff */
-			BPF_ALU64_IMM(BPF_RSH, BPF_REG_2, 32),
-			/* r0 = <oob pointer> */
-			BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_2),
-			/* access to OOB pointer */
-			BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, 0),
-			/* exit */
-			BPF_MOV64_IMM(BPF_REG_0, 0),
-			BPF_EXIT_INSN(),
-		},
-		.fixup_map1 = { 3 },
-		.errstr = "map_value pointer and 4294967295",
-		.result = REJECT
-	},
-	{
-<<<<<<< HEAD
-		"indirect variable-offset stack access",
-		.insns = {
-			/* Fill the top 8 bytes of the stack */
-			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-			/* Get an unknown value */
-			BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 0),
-			/* Make it small and 4-byte aligned */
-			BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 4),
-			BPF_ALU64_IMM(BPF_SUB, BPF_REG_2, 8),
-			/* add it to fp.  We now have either fp-4 or fp-8, but
-			 * we don't know which
-			 */
-			BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_10),
-			/* dereference it indirectly */
-			BPF_LD_MAP_FD(BPF_REG_1, 0),
-			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
-				     BPF_FUNC_map_lookup_elem),
-			BPF_MOV64_IMM(BPF_REG_0, 0),
-			BPF_EXIT_INSN(),
-		},
-		.fixup_map1 = { 5 },
-		.errstr = "variable stack read R2",
-		.result = REJECT,
-		.prog_type = BPF_PROG_TYPE_LWT_IN,
-	},
-	{
-		"direct stack access with 32-bit wraparound. test1",
-		.insns = {
-			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 0x7fffffff),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 0x7fffffff),
-			BPF_MOV32_IMM(BPF_REG_0, 0),
-			BPF_STX_MEM(BPF_B, BPF_REG_1, BPF_REG_0, 0),
-			BPF_EXIT_INSN()
-		},
-		.errstr = "fp pointer and 2147483647",
-		.result = REJECT
-	},
-	{
-		"direct stack access with 32-bit wraparound. test2",
-		.insns = {
-			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 0x3fffffff),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 0x3fffffff),
-			BPF_MOV32_IMM(BPF_REG_0, 0),
-			BPF_STX_MEM(BPF_B, BPF_REG_1, BPF_REG_0, 0),
-			BPF_EXIT_INSN()
-		},
-		.errstr = "fp pointer and 1073741823",
-		.result = REJECT
-	},
-	{
-		"direct stack access with 32-bit wraparound. test3",
-		.insns = {
-			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 0x1fffffff),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 0x1fffffff),
-			BPF_MOV32_IMM(BPF_REG_0, 0),
-			BPF_STX_MEM(BPF_B, BPF_REG_1, BPF_REG_0, 0),
-			BPF_EXIT_INSN()
-		},
-		.errstr = "fp pointer offset 1073741822",
-		.result = REJECT
-	},
-	{
-		"liveness pruning and write screening",
-=======
-		"bounds check based on sign-extended MOV. test2",
->>>>>>> linux-next/akpm-base
-		.insns = {
-			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-			BPF_LD_MAP_FD(BPF_REG_1, 0),
-			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
-				     BPF_FUNC_map_lookup_elem),
-			BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 4),
-			/* r2 = 0xffff'ffff'ffff'ffff */
-			BPF_MOV64_IMM(BPF_REG_2, 0xffffffff),
-			/* r2 = 0xfff'ffff */
-			BPF_ALU64_IMM(BPF_RSH, BPF_REG_2, 36),
-			/* r0 = <oob pointer> */
-			BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_2),
-			/* access to OOB pointer */
-			BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, 0),
-			/* exit */
-			BPF_MOV64_IMM(BPF_REG_0, 0),
-			BPF_EXIT_INSN(),
-		},
-		.fixup_map1 = { 3 },
-		.errstr = "R0 min value is outside of the array range",
-		.result = REJECT
-	},
-	{
-		"bounds check based on reg_off + var_off + insn_off. test1",
-		.insns = {
-			BPF_LDX_MEM(BPF_W, BPF_REG_6, BPF_REG_1,
-				    offsetof(struct __sk_buff, mark)),
-			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-			BPF_LD_MAP_FD(BPF_REG_1, 0),
-			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
-				     BPF_FUNC_map_lookup_elem),
-			BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 4),
-			BPF_ALU64_IMM(BPF_AND, BPF_REG_6, 1),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_6, (1 << 29) - 1),
-			BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_6),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, (1 << 29) - 1),
-			BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, 3),
-			BPF_MOV64_IMM(BPF_REG_0, 0),
-			BPF_EXIT_INSN(),
-		},
-		.fixup_map1 = { 4 },
-		.errstr = "value_size=8 off=1073741825",
-		.result = REJECT,
-		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
-	},
-	{
-		"bounds check based on reg_off + var_off + insn_off. test2",
-		.insns = {
-			BPF_LDX_MEM(BPF_W, BPF_REG_6, BPF_REG_1,
-				    offsetof(struct __sk_buff, mark)),
-			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-			BPF_LD_MAP_FD(BPF_REG_1, 0),
-			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
-				     BPF_FUNC_map_lookup_elem),
-			BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 4),
-			BPF_ALU64_IMM(BPF_AND, BPF_REG_6, 1),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_6, (1 << 30) - 1),
-			BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_6),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, (1 << 29) - 1),
-			BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, 3),
-			BPF_MOV64_IMM(BPF_REG_0, 0),
-			BPF_EXIT_INSN(),
-		},
-		.fixup_map1 = { 4 },
-		.errstr = "value 1073741823",
-		.result = REJECT,
-		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
-	},
-	{
-		"bounds check after truncation of non-boundary-crossing range",
-		.insns = {
-			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-			BPF_LD_MAP_FD(BPF_REG_1, 0),
-			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
-				     BPF_FUNC_map_lookup_elem),
-			BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 9),
-			/* r1 = [0x00, 0xff] */
-			BPF_LDX_MEM(BPF_B, BPF_REG_1, BPF_REG_0, 0),
-			BPF_MOV64_IMM(BPF_REG_2, 1),
-			/* r2 = 0x10'0000'0000 */
-			BPF_ALU64_IMM(BPF_LSH, BPF_REG_2, 36),
-			/* r1 = [0x10'0000'0000, 0x10'0000'00ff] */
-			BPF_ALU64_REG(BPF_ADD, BPF_REG_1, BPF_REG_2),
-			/* r1 = [0x10'7fff'ffff, 0x10'8000'00fe] */
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 0x7fffffff),
-			/* r1 = [0x00, 0xff] */
-			BPF_ALU32_IMM(BPF_SUB, BPF_REG_1, 0x7fffffff),
-			/* r1 = 0 */
-			BPF_ALU64_IMM(BPF_RSH, BPF_REG_1, 8),
-			/* no-op */
-			BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_1),
-			/* access at offset 0 */
-			BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, 0),
-			/* exit */
-			BPF_MOV64_IMM(BPF_REG_0, 0),
-			BPF_EXIT_INSN(),
-		},
-		.fixup_map1 = { 3 },
-		.result = ACCEPT
-	},
-	{
-		"bounds check after truncation of boundary-crossing range (1)",
-		.insns = {
-			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-			BPF_LD_MAP_FD(BPF_REG_1, 0),
-			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
-				     BPF_FUNC_map_lookup_elem),
-			BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 9),
-			/* r1 = [0x00, 0xff] */
-			BPF_LDX_MEM(BPF_B, BPF_REG_1, BPF_REG_0, 0),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 0xffffff80 >> 1),
-			/* r1 = [0xffff'ff80, 0x1'0000'007f] */
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 0xffffff80 >> 1),
-			/* r1 = [0xffff'ff80, 0xffff'ffff] or
-			 *      [0x0000'0000, 0x0000'007f]
-			 */
-			BPF_ALU32_IMM(BPF_ADD, BPF_REG_1, 0),
-			BPF_ALU64_IMM(BPF_SUB, BPF_REG_1, 0xffffff80 >> 1),
-			/* r1 = [0x00, 0xff] or
-			 *      [0xffff'ffff'0000'0080, 0xffff'ffff'ffff'ffff]
-			 */
-			BPF_ALU64_IMM(BPF_SUB, BPF_REG_1, 0xffffff80 >> 1),
-			/* r1 = 0 or
-			 *      [0x00ff'ffff'ff00'0000, 0x00ff'ffff'ffff'ffff]
-			 */
-			BPF_ALU64_IMM(BPF_RSH, BPF_REG_1, 8),
-			/* no-op or OOB pointer computation */
-			BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_1),
-			/* potentially OOB access */
-			BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, 0),
-			/* exit */
-			BPF_MOV64_IMM(BPF_REG_0, 0),
-			BPF_EXIT_INSN(),
-		},
-		.fixup_map1 = { 3 },
-		/* not actually fully unbounded, but the bound is very high */
-		.errstr = "R0 unbounded memory access",
-		.result = REJECT
-	},
-	{
-		"bounds check after truncation of boundary-crossing range (2)",
-		.insns = {
-			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-			BPF_LD_MAP_FD(BPF_REG_1, 0),
-			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
-				     BPF_FUNC_map_lookup_elem),
-			BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 9),
-			/* r1 = [0x00, 0xff] */
-			BPF_LDX_MEM(BPF_B, BPF_REG_1, BPF_REG_0, 0),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 0xffffff80 >> 1),
-			/* r1 = [0xffff'ff80, 0x1'0000'007f] */
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 0xffffff80 >> 1),
-			/* r1 = [0xffff'ff80, 0xffff'ffff] or
-			 *      [0x0000'0000, 0x0000'007f]
-			 * difference to previous test: truncation via MOV32
-			 * instead of ALU32.
-			 */
-			BPF_MOV32_REG(BPF_REG_1, BPF_REG_1),
-			BPF_ALU64_IMM(BPF_SUB, BPF_REG_1, 0xffffff80 >> 1),
-			/* r1 = [0x00, 0xff] or
-			 *      [0xffff'ffff'0000'0080, 0xffff'ffff'ffff'ffff]
-			 */
-			BPF_ALU64_IMM(BPF_SUB, BPF_REG_1, 0xffffff80 >> 1),
-			/* r1 = 0 or
-			 *      [0x00ff'ffff'ff00'0000, 0x00ff'ffff'ffff'ffff]
-			 */
-			BPF_ALU64_IMM(BPF_RSH, BPF_REG_1, 8),
-			/* no-op or OOB pointer computation */
-			BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_1),
-			/* potentially OOB access */
-			BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, 0),
-			/* exit */
-			BPF_MOV64_IMM(BPF_REG_0, 0),
-			BPF_EXIT_INSN(),
-		},
-		.fixup_map1 = { 3 },
-		/* not actually fully unbounded, but the bound is very high */
-		.errstr = "R0 unbounded memory access",
-		.result = REJECT
-	},
-	{
-		"bounds check after wrapping 32-bit addition",
-		.insns = {
-			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-			BPF_LD_MAP_FD(BPF_REG_1, 0),
-			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
-				     BPF_FUNC_map_lookup_elem),
-			BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 5),
-			/* r1 = 0x7fff'ffff */
-			BPF_MOV64_IMM(BPF_REG_1, 0x7fffffff),
-			/* r1 = 0xffff'fffe */
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 0x7fffffff),
-			/* r1 = 0 */
-			BPF_ALU32_IMM(BPF_ADD, BPF_REG_1, 2),
-			/* no-op */
-			BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_1),
-			/* access at offset 0 */
-			BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, 0),
-			/* exit */
-			BPF_MOV64_IMM(BPF_REG_0, 0),
-			BPF_EXIT_INSN(),
-		},
-		.fixup_map1 = { 3 },
-		.result = ACCEPT
-	},
-	{
-		"bounds check after shift with oversized count operand",
-		.insns = {
-			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-			BPF_LD_MAP_FD(BPF_REG_1, 0),
-			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
-				     BPF_FUNC_map_lookup_elem),
-			BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 6),
-			BPF_MOV64_IMM(BPF_REG_2, 32),
-			BPF_MOV64_IMM(BPF_REG_1, 1),
-			/* r1 = (u32)1 << (u32)32 = ? */
-			BPF_ALU32_REG(BPF_LSH, BPF_REG_1, BPF_REG_2),
-			/* r1 = [0x0000, 0xffff] */
-			BPF_ALU64_IMM(BPF_AND, BPF_REG_1, 0xffff),
-			/* computes unknown pointer, potentially OOB */
-			BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_1),
-			/* potentially OOB access */
-			BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, 0),
-			/* exit */
-			BPF_MOV64_IMM(BPF_REG_0, 0),
-			BPF_EXIT_INSN(),
-		},
-		.fixup_map1 = { 3 },
-		.errstr = "R0 max value is outside of the array range",
-		.result = REJECT
-	},
-	{
-		"bounds check after right shift of maybe-negative number",
-		.insns = {
-			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-			BPF_LD_MAP_FD(BPF_REG_1, 0),
-			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
-				     BPF_FUNC_map_lookup_elem),
-			BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 6),
-			/* r1 = [0x00, 0xff] */
-			BPF_LDX_MEM(BPF_B, BPF_REG_1, BPF_REG_0, 0),
-			/* r1 = [-0x01, 0xfe] */
-			BPF_ALU64_IMM(BPF_SUB, BPF_REG_1, 1),
-			/* r1 = 0 or 0xff'ffff'ffff'ffff */
-			BPF_ALU64_IMM(BPF_RSH, BPF_REG_1, 8),
-			/* r1 = 0 or 0xffff'ffff'ffff */
-			BPF_ALU64_IMM(BPF_RSH, BPF_REG_1, 8),
-			/* computes unknown pointer, potentially OOB */
-			BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_1),
-			/* potentially OOB access */
-			BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, 0),
-			/* exit */
-			BPF_MOV64_IMM(BPF_REG_0, 0),
-			BPF_EXIT_INSN(),
-		},
-		.fixup_map1 = { 3 },
-		.errstr = "R0 unbounded memory access",
-		.result = REJECT
-	},
-	{
-		"bounds check map access with off+size signed 32bit overflow. test1",
-		.insns = {
-			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-			BPF_LD_MAP_FD(BPF_REG_1, 0),
-			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
-				     BPF_FUNC_map_lookup_elem),
-			BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
-			BPF_EXIT_INSN(),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 0x7ffffffe),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
-			BPF_JMP_A(0),
-			BPF_EXIT_INSN(),
-		},
-		.fixup_map1 = { 3 },
-		.errstr = "map_value pointer and 2147483646",
-		.result = REJECT
-	},
-	{
-		"bounds check map access with off+size signed 32bit overflow. test2",
-		.insns = {
-			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-			BPF_LD_MAP_FD(BPF_REG_1, 0),
-			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
-				     BPF_FUNC_map_lookup_elem),
-			BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
-			BPF_EXIT_INSN(),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 0x1fffffff),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 0x1fffffff),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 0x1fffffff),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
-			BPF_JMP_A(0),
-			BPF_EXIT_INSN(),
-		},
-		.fixup_map1 = { 3 },
-		.errstr = "pointer offset 1073741822",
-		.result = REJECT
-	},
-	{
-		"bounds check map access with off+size signed 32bit overflow. test3",
-		.insns = {
-			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-			BPF_LD_MAP_FD(BPF_REG_1, 0),
-			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
-				     BPF_FUNC_map_lookup_elem),
-			BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
-			BPF_EXIT_INSN(),
-			BPF_ALU64_IMM(BPF_SUB, BPF_REG_0, 0x1fffffff),
-			BPF_ALU64_IMM(BPF_SUB, BPF_REG_0, 0x1fffffff),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 2),
-			BPF_JMP_A(0),
-			BPF_EXIT_INSN(),
-		},
-		.fixup_map1 = { 3 },
-		.errstr = "pointer offset -1073741822",
-		.result = REJECT
-	},
-	{
-		"bounds check map access with off+size signed 32bit overflow. test4",
-		.insns = {
-			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-			BPF_LD_MAP_FD(BPF_REG_1, 0),
-			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
-				     BPF_FUNC_map_lookup_elem),
-			BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
-			BPF_EXIT_INSN(),
-			BPF_MOV64_IMM(BPF_REG_1, 1000000),
-			BPF_ALU64_IMM(BPF_MUL, BPF_REG_1, 1000000),
-			BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 2),
-			BPF_JMP_A(0),
-			BPF_EXIT_INSN(),
-		},
-		.fixup_map1 = { 3 },
-		.errstr = "map_value pointer and 1000000000000",
-		.result = REJECT
-	},
-	{
-		"pointer/scalar confusion in state equality check (way 1)",
-		.insns = {
-			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-			BPF_LD_MAP_FD(BPF_REG_1, 0),
-			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
-				     BPF_FUNC_map_lookup_elem),
-			BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 2),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
-			BPF_JMP_A(1),
-			BPF_MOV64_REG(BPF_REG_0, BPF_REG_10),
-			BPF_JMP_A(0),
-			BPF_EXIT_INSN(),
-		},
-		.fixup_map1 = { 3 },
-		.result = ACCEPT,
-		.result_unpriv = REJECT,
-		.errstr_unpriv = "R0 leaks addr as return value"
-	},
-	{
-		"pointer/scalar confusion in state equality check (way 2)",
-		.insns = {
-			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-			BPF_LD_MAP_FD(BPF_REG_1, 0),
-			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
-				     BPF_FUNC_map_lookup_elem),
-			BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
-			BPF_MOV64_REG(BPF_REG_0, BPF_REG_10),
-			BPF_JMP_A(1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
-			BPF_EXIT_INSN(),
-		},
-		.fixup_map1 = { 3 },
-		.result = ACCEPT,
-		.result_unpriv = REJECT,
-		.errstr_unpriv = "R0 leaks addr as return value"
-	},
-	{
-		"variable-offset ctx access",
 		.insns = {
 			/* Get an unknown value */
 			BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 0),
@@ -7755,24 +7227,7 @@ static struct bpf_test tests[] = {
 		.prog_type = BPF_PROG_TYPE_LWT_IN,
 	},
 	{
-<<<<<<< HEAD
-		"pkt_end - pkt_start is allowed",
-		.insns = {
-			BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
-				    offsetof(struct __sk_buff, data_end)),
-			BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
-				    offsetof(struct __sk_buff, data)),
-			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_2),
-			BPF_EXIT_INSN(),
-		},
-		.result = ACCEPT,
-		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
-	},
-	{
-		"XDP pkt read, pkt_end mangling, bad access 1",
-=======
 		"variable-offset stack access",
->>>>>>> linux-next/akpm-base
 		.insns = {
 			/* Fill the top 8 bytes of the stack */
 			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
@@ -7789,11 +7244,7 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_2, 0),
 			BPF_EXIT_INSN(),
 		},
-<<<<<<< HEAD
-		.errstr = "R3 pointer arithmetic on PTR_TO_PACKET_END",
-=======
 		.errstr = "variable stack access var_off=(0xfffffffffffffff8; 0x4)",
->>>>>>> linux-next/akpm-base
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_LWT_IN,
 	},
@@ -7818,12 +7269,8 @@ static struct bpf_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
-<<<<<<< HEAD
-		.errstr = "R3 pointer arithmetic on PTR_TO_PACKET_END",
-=======
 		.fixup_map1 = { 5 },
 		.errstr = "variable stack read R2",
->>>>>>> linux-next/akpm-base
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_LWT_IN,
 	},
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
kernel-exitc-export-abort-to-modules.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

