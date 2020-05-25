From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Mon, 25 May 2020 10:57:49 -0700
Message-ID: <20200525175749.oK2DMtE0E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388621AbgEYR5u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 May 2020 13:57:50 -0400
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

 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c    |    3 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c    |    3 
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c    |    8 --
 drivers/gpu/drm/amd/display/dc/dml/dml_inline_defs.h |   15 ----
 drivers/net/phy/mscc/mscc.h                          |    3 
 drivers/net/phy/mscc/mscc_main.c                     |   35 ----------
 net/core/flow_dissector.c                            |    9 --
 net/mptcp/options.c                                  |    8 --
 8 files changed, 84 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
@@ -73,12 +73,9 @@ static const struct hw_sequencer_funcs d
 	.get_clock = dcn10_get_clock,
 	.get_vupdate_offset_from_vsync = dcn10_get_vupdate_offset_from_vsync,
 	.calc_vupdate_position = dcn10_calc_vupdate_position,
-<<<<<<< HEAD
-=======
 	.set_backlight_level = dce110_set_backlight_level,
 	.set_abm_immediate_disable = dce110_set_abm_immediate_disable,
 	.set_pipe = dce110_set_pipe,
->>>>>>> linux-next/akpm-base
 };
 
 static const struct hwseq_private_funcs dcn10_private_funcs = {
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c
@@ -84,12 +84,9 @@ static const struct hw_sequencer_funcs d
 	.set_flip_control_gsl = dcn20_set_flip_control_gsl,
 	.get_vupdate_offset_from_vsync = dcn10_get_vupdate_offset_from_vsync,
 	.calc_vupdate_position = dcn10_calc_vupdate_position,
-<<<<<<< HEAD
-=======
 	.set_backlight_level = dce110_set_backlight_level,
 	.set_abm_immediate_disable = dce110_set_abm_immediate_disable,
 	.set_pipe = dce110_set_pipe,
->>>>>>> linux-next/akpm-base
 };
 
 static const struct hwseq_private_funcs dcn20_private_funcs = {
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c
@@ -87,18 +87,10 @@ static const struct hw_sequencer_funcs d
 	.exit_optimized_pwr_state = dcn21_exit_optimized_pwr_state,
 	.get_vupdate_offset_from_vsync = dcn10_get_vupdate_offset_from_vsync,
 	.calc_vupdate_position = dcn10_calc_vupdate_position,
-<<<<<<< HEAD
-	.set_cursor_position = dcn10_set_cursor_position,
-	.set_cursor_attribute = dcn10_set_cursor_attribute,
-	.set_cursor_sdr_white_level = dcn10_set_cursor_sdr_white_level,
-	.optimize_pwr_state = dcn21_optimize_pwr_state,
-	.exit_optimized_pwr_state = dcn21_exit_optimized_pwr_state,
-=======
 	.power_down = dce110_power_down,
 	.set_backlight_level = dcn21_set_backlight_level,
 	.set_abm_immediate_disable = dcn21_set_abm_immediate_disable,
 	.set_pipe = dcn21_set_pipe,
->>>>>>> linux-next/akpm-base
 };
 
 static const struct hwseq_private_funcs dcn21_private_funcs = {
--- a/drivers/gpu/drm/amd/display/dc/dml/dml_inline_defs.h~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/display/dc/dml/dml_inline_defs.h
@@ -75,21 +75,6 @@ static inline double dml_floor(double a,
 }
 
 static inline double dml_round(double a)
-<<<<<<< HEAD
-{
-	double round_pt = 0.5;
-	double ceil = dml_ceil(a, 1);
-	double floor = dml_floor(a, 1);
-
-	if (a - floor >= round_pt)
-		return ceil;
-	else
-		return floor;
-}
-
-static inline int dml_log2(double x)
-=======
->>>>>>> linux-next/akpm-base
 {
 	double round_pt = 0.5;
 	double ceil = dml_ceil(a, 1);
--- a/drivers/net/phy/mscc/mscc.h~linux-next-git-rejects
+++ a/drivers/net/phy/mscc/mscc.h
@@ -353,12 +353,9 @@ struct vsc8531_private {
 	const struct vsc85xx_hw_stat *hw_stats;
 	u64 *stats;
 	int nstats;
-<<<<<<< HEAD
 	bool pkg_init;
 	/* PHY address within the package. */
 	u8 addr;
-=======
->>>>>>> linux-next/akpm-base
 	/* For multiple port PHYs; the MDIO address of the base PHY in the
 	 * package.
 	 */
--- a/drivers/net/phy/mscc/mscc_main.c~linux-next-git-rejects
+++ a/drivers/net/phy/mscc/mscc_main.c
@@ -1315,24 +1315,6 @@ static int vsc8584_config_init(struct ph
 
 	mutex_lock(&phydev->mdio.bus->mdio_lock);
 
-<<<<<<< HEAD
-	__mdiobus_write(phydev->mdio.bus, phydev->mdio.addr,
-			MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_EXTENDED);
-	addr = __mdiobus_read(phydev->mdio.bus, phydev->mdio.addr,
-			      MSCC_PHY_EXT_PHY_CNTL_4);
-	addr >>= PHY_CNTL_4_ADDR_POS;
-
-	val = __mdiobus_read(phydev->mdio.bus, phydev->mdio.addr,
-			     MSCC_PHY_ACTIPHY_CNTL);
-	if (val & PHY_ADDR_REVERSED)
-		vsc8531->base_addr = phydev->mdio.addr + addr;
-	else
-		vsc8531->base_addr = phydev->mdio.addr - addr;
-
-	vsc8531->addr = addr;
-
-=======
->>>>>>> linux-next/akpm-base
 	/* Some parts of the init sequence are identical for every PHY in the
 	 * package. Some parts are modifying the GPIO register bank which is a
 	 * set of registers that are affecting all PHYs, a few resetting the
@@ -1745,23 +1727,6 @@ static int vsc8514_config_init(struct ph
 
 	mutex_lock(&phydev->mdio.bus->mdio_lock);
 
-<<<<<<< HEAD
-	__phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_EXTENDED);
-
-	addr = __phy_read(phydev, MSCC_PHY_EXT_PHY_CNTL_4);
-	addr >>= PHY_CNTL_4_ADDR_POS;
-
-	val = __phy_read(phydev, MSCC_PHY_ACTIPHY_CNTL);
-
-	if (val & PHY_ADDR_REVERSED)
-		vsc8531->base_addr = phydev->mdio.addr + addr;
-	else
-		vsc8531->base_addr = phydev->mdio.addr - addr;
-
-	vsc8531->addr = addr;
-
-=======
->>>>>>> linux-next/akpm-base
 	/* Some parts of the init sequence are identical for every PHY in the
 	 * package. Some parts are modifying the GPIO register bank which is a
 	 * set of registers that are affecting all PHYs, a few resetting the
--- a/net/core/flow_dissector.c~linux-next-git-rejects
+++ a/net/core/flow_dissector.c
@@ -1854,15 +1854,6 @@ static int __init init_default_flow_diss
 	skb_flow_dissector_init(&flow_keys_basic_dissector,
 				flow_keys_basic_dissector_keys,
 				ARRAY_SIZE(flow_keys_basic_dissector_keys));
-<<<<<<< HEAD
-=======
-
-	err = register_pernet_subsys(&flow_dissector_pernet_ops);
-
-	WARN_ON(err);
-	return err;
-}
->>>>>>> linux-next/akpm-base
 
 	return register_pernet_subsys(&flow_dissector_pernet_ops);
 }
--- a/net/mptcp/options.c~linux-next-git-rejects
+++ a/net/mptcp/options.c
@@ -551,11 +551,7 @@ static u64 add_addr_generate_hmac(u64 ke
 
 	mptcp_crypto_hmac_sha(key1, key2, msg, 7, hmac);
 
-<<<<<<< HEAD
 	return get_unaligned_be64(&hmac[SHA256_DIGEST_SIZE - sizeof(u64)]);
-=======
-	return get_unaligned_be64(&hmac[MPTCP_ADDR_HMAC_LEN - sizeof(u64)]);
->>>>>>> linux-next/akpm-base
 }
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
@@ -572,11 +568,7 @@ static u64 add_addr6_generate_hmac(u64 k
 
 	mptcp_crypto_hmac_sha(key1, key2, msg, 19, hmac);
 
-<<<<<<< HEAD
 	return get_unaligned_be64(&hmac[SHA256_DIGEST_SIZE - sizeof(u64)]);
-=======
-	return get_unaligned_be64(&hmac[MPTCP_ADDR_HMAC_LEN - sizeof(u64)]);
->>>>>>> linux-next/akpm-base
 }
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

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
padata-initialize-earlier-fix.patch
arch-kunmap-remove-duplicate-kunmap-implementations-fix.patch
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-add-debug_wx-support-fix.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-pre.patch
linux-next-rejects.patch
linux-next-post.patch
kernel-add-panic_on_taint-fix.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch
