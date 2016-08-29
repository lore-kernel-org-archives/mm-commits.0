From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 29 Aug 2016 12:53:16 -0700
Message-ID: <57c492ac.RaaCB+LFmrqiH1Ro%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35082 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754874AbcH2TxR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2016 15:53:17 -0400
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

 drivers/gpu/drm/i915/intel_drv.h      |    3 ---
 drivers/infiniband/hw/mlx4/cq.c       |   17 -----------------
 sound/soc/generic/Makefile            |    3 ---
 sound/soc/generic/simple-card-utils.c |    6 ------
 sound/soc/omap/omap-abe-twl6040.c     |   18 ------------------
 5 files changed, 47 deletions(-)

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
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-checkpatch-fixes.patch
powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load-checkpatch-fixes.patch
powerpc-add-code-to-work-with-device-trees-in-kexec_file_load-checkpatch-fixes.patch
ima-demonstration-code-for-kexec-buffer-passing-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

