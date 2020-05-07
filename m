From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 07 May 2020 09:54:15 -0700
Message-ID: <20200507165415.y8-qZqtgq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725949AbgEGQyR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 12:54:17 -0400
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

 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c |    4 
 drivers/net/ipa/ipa_endpoint.c                             |   64 ----------
 drivers/net/wireguard/send.c                               |    5 
 include/net/mptcp.h                                        |    3 
 net/sched/cls_api.c                                        |   11 -
 5 files changed, 87 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -765,10 +765,6 @@ static struct mlx5dr_cq *dr_create_cq(st
 	pas = (__be64 *)MLX5_ADDR_OF(create_cq_in, in, pas);
 	mlx5_fill_page_frag_array(&cq->wq_ctrl.buf, pas);
 
-<<<<<<< HEAD
-	cq->mcq.event = dr_cq_event;
-=======
->>>>>>> linux-next/akpm-base
 	cq->mcq.comp  = dr_cq_complete;
 
 	err = mlx5_core_create_cq(mdev, &cq->mcq, in, inlen, out, sizeof(out));
--- a/drivers/net/ipa/ipa_endpoint.c~linux-next-git-rejects
+++ a/drivers/net/ipa/ipa_endpoint.c
@@ -1269,70 +1269,6 @@ static void ipa_endpoint_reset(struct ip
 			ret, endpoint->channel_id, endpoint->endpoint_id);
 }
 
-<<<<<<< HEAD
-static int ipa_endpoint_stop_rx_dma(struct ipa *ipa)
-{
-	u16 size = IPA_ENDPOINT_STOP_RX_SIZE;
-	struct gsi_trans *trans;
-	dma_addr_t addr;
-	int ret;
-
-	trans = ipa_cmd_trans_alloc(ipa, 1);
-	if (!trans) {
-		dev_err(&ipa->pdev->dev,
-			"no transaction for RX endpoint STOP workaround\n");
-		return -EBUSY;
-	}
-
-	/* Read into the highest part of the zero memory area */
-	addr = ipa->zero_addr + ipa->zero_size - size;
-
-	ipa_cmd_dma_task_32b_addr_add(trans, size, addr, false);
-
-	ret = gsi_trans_commit_wait_timeout(trans, ENDPOINT_STOP_DMA_TIMEOUT);
-	if (ret)
-		gsi_trans_free(trans);
-
-	return ret;
-}
-
-/**
- * ipa_endpoint_stop() - Stops a GSI channel in IPA
- * @client:	Client whose endpoint should be stopped
- *
- * This function implements the sequence to stop a GSI channel
- * in IPA. This function returns when the channel is is STOP state.
- *
- * Return value: 0 on success, negative otherwise
- */
-int ipa_endpoint_stop(struct ipa_endpoint *endpoint)
-{
-	u32 retries = IPA_ENDPOINT_STOP_RX_RETRIES;
-	int ret;
-
-	do {
-		struct ipa *ipa = endpoint->ipa;
-		struct gsi *gsi = &ipa->gsi;
-
-		ret = gsi_channel_stop(gsi, endpoint->channel_id);
-		if (ret != -EAGAIN || endpoint->toward_ipa)
-			break;
-
-		/* For IPA v3.5.1, send a DMA read task and check again */
-		if (ipa->version == IPA_VERSION_3_5_1) {
-			ret = ipa_endpoint_stop_rx_dma(ipa);
-			if (ret)
-				break;
-		}
-
-		msleep(1);
-	} while (retries--);
-
-	return retries ? ret : -EIO;
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
 {
 	if (endpoint->toward_ipa) {
--- a/drivers/net/wireguard/send.c~linux-next-git-rejects
+++ a/drivers/net/wireguard/send.c
@@ -303,11 +303,6 @@ void wg_packet_encrypt_worker(struct wor
 		}
 		wg_queue_enqueue_per_peer(&PACKET_PEER(first)->tx_queue, first,
 					  state);
-<<<<<<< HEAD
-		if (need_resched())
-			cond_resched();
-=======
->>>>>>> linux-next/akpm-base
 	}
 }
 
--- a/include/net/mptcp.h~linux-next-git-rejects
+++ a/include/net/mptcp.h
@@ -68,11 +68,8 @@ static inline bool rsk_is_mptcp(const st
 	return tcp_rsk(req)->is_mptcp;
 }
 
-<<<<<<< HEAD
-=======
 void mptcp_space(const struct sock *ssk, int *space, int *full_space);
 
->>>>>>> linux-next/akpm-base
 bool mptcp_syn_options(struct sock *sk, const struct sk_buff *skb,
 		       unsigned int *size, struct mptcp_out_options *opts);
 bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
--- a/net/sched/cls_api.c~linux-next-git-rejects
+++ a/net/sched/cls_api.c
@@ -3527,16 +3527,6 @@ static void tcf_sample_get_group(struct
 #endif
 }
 
-<<<<<<< HEAD
-static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
-{
-	if (WARN_ON_ONCE(hw_stats > TCA_ACT_HW_STATS_ANY))
-		return FLOW_ACTION_HW_STATS_DONT_CARE;
-	else if (!hw_stats)
-		return FLOW_ACTION_HW_STATS_DISABLED;
-
-	return hw_stats;
-=======
 static void tcf_gate_entry_destructor(void *priv)
 {
 	struct action_gate_entry *oe = priv;
@@ -3556,7 +3546,6 @@ static int tcf_gate_get_entries(struct f
 	entry->destructor_priv = entry->gate.entries;
 
 	return 0;
->>>>>>> linux-next/akpm-base
 }
 
 int tc_setup_flow_action(struct flow_action *flow_action,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
mm-gupc-updating-the-documentation-fix.patch
mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-add-debug_wx-support-fixpatch-added-to-mm-tree.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-rejects.patch
arch-x86-makefile-use-config_shell.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch
