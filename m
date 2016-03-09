From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 09 Mar 2016 10:23:55 -0800
Message-ID: <56e06a3b.kNRwu9AR5DxCCnc7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbcCISX4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2016 13:23:56 -0500
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

 drivers/net/ethernet/mellanox/mlx5/core/en.h      |    5 --
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    3 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c   |    8 ----
 drivers/net/vxlan.c                               |   22 ------------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       |    3 -
 include/uapi/linux/bpf.h                          |    3 -
 net/tipc/subscr.c                                 |    5 --
 7 files changed, 49 deletions(-)

diff -puN drivers/net/ethernet/mellanox/mlx5/core/en.h~linux-next-git-rejects drivers/net/ethernet/mellanox/mlx5/core/en.h
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h~linux-next-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -286,12 +286,7 @@ struct mlx5e_sq_stats {
 	u64 stopped;
 	u64 wake;
 	u64 dropped;
-<<<<<<< HEAD
-	u64 nop;
-#define NUM_SQ_STATS 9
-=======
 #define NUM_SQ_STATS 11
->>>>>>> linux-next/akpm-base
 };
 
 struct mlx5e_stats {
diff -puN drivers/net/ethernet/mellanox/mlx5/core/en_main.c~linux-next-git-rejects drivers/net/ethernet/mellanox/mlx5/core/en_main.c
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2246,8 +2246,6 @@ void mlx5e_build_default_indir_rqt(u32 *
 		indirection_rqt[i] = i % num_channels;
 }
 
-<<<<<<< HEAD
-=======
 #ifdef CONFIG_MLX5_CORE_EN_DCB
 static void mlx5e_ets_init(struct mlx5e_priv *priv)
 {
@@ -2266,7 +2264,6 @@ static void mlx5e_ets_init(struct mlx5e_
 }
 #endif
 
->>>>>>> linux-next/akpm-base
 static void mlx5e_build_netdev_priv(struct mlx5_core_dev *mdev,
 				    struct net_device *netdev,
 				    int num_channels)
diff -puN drivers/net/ethernet/mellanox/mlx5/core/en_tx.c~linux-next-git-rejects drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -206,13 +206,6 @@ static netdev_tx_t mlx5e_sq_xmit(struct
 	if (skb_is_gso(skb)) {
 		eseg->mss    = cpu_to_be16(skb_shinfo(skb)->gso_size);
 		opcode       = MLX5_OPCODE_LSO;
-<<<<<<< HEAD
-		ihs          = skb_transport_offset(skb) + tcp_hdrlen(skb);
-		payload_len  = skb->len - ihs;
-		num_bytes = skb->len + (skb_shinfo(skb)->gso_segs - 1) * ihs;
-		sq->stats.tso_packets++;
-		sq->stats.tso_bytes += payload_len;
-=======
 
 		if (skb->encapsulation) {
 			ihs = skb_inner_transport_offset(skb) + inner_tcp_hdrlen(skb);
@@ -225,7 +218,6 @@ static netdev_tx_t mlx5e_sq_xmit(struct
 		}
 
 		num_bytes = skb->len + (skb_shinfo(skb)->gso_segs - 1) * ihs;
->>>>>>> linux-next/akpm-base
 	} else {
 		bf = sq->bf_budget &&
 		     !skb->xmit_more &&
diff -puN drivers/net/vxlan.c~linux-next-git-rejects drivers/net/vxlan.c
--- a/drivers/net/vxlan.c~linux-next-git-rejects
+++ a/drivers/net/vxlan.c
@@ -1311,33 +1311,11 @@ static int vxlan_rcv(struct sock *sk, st
 	/* For backwards compatibility, only allow reserved fields to be
 	 * used by VXLAN extensions if explicitly requested.
 	 */
-<<<<<<< HEAD
-	if ((flags & VXLAN_HF_GBP) && (vs->flags & VXLAN_F_GBP)) {
-		struct vxlanhdr_gbp *gbp;
-
-		gbp = (struct vxlanhdr_gbp *)vxh;
-		md->gbp = ntohs(gbp->policy_id);
-
-		if (tun_dst) {
-			tun_dst->u.tun_info.key.tun_flags |= TUNNEL_VXLAN_OPT;
-			tun_dst->u.tun_info.options_len = sizeof(*md);
-		}
-
-		if (gbp->dont_learn)
-			md->gbp |= VXLAN_GBP_DONT_LEARN;
-
-		if (gbp->policy_applied)
-			md->gbp |= VXLAN_GBP_POLICY_APPLIED;
-
-		flags &= ~VXLAN_GBP_USED_BITS;
-	}
-=======
 	if (vs->flags & VXLAN_F_REMCSUM_RX)
 		if (!vxlan_remcsum(&unparsed, skb, vs->flags))
 			goto drop;
 	if (vs->flags & VXLAN_F_GBP)
 		vxlan_parse_gbp_hdr(&unparsed, skb, vs->flags, md);
->>>>>>> linux-next/akpm-base
 
 	if (unparsed.vx_flags || unparsed.vx_vni) {
 		/* If there are any unprocessed flags remaining treat
diff -puN drivers/net/wireless/intel/iwlwifi/mvm/fw.c~linux-next-git-rejects drivers/net/wireless/intel/iwlwifi/mvm/fw.c
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c~linux-next-git-rejects
+++ a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -108,8 +108,6 @@ static int iwl_send_tx_ant_cfg(struct iw
 				    sizeof(tx_ant_cmd), &tx_ant_cmd);
 }
 
-<<<<<<< HEAD
-=======
 static int iwl_send_rss_cfg_cmd(struct iwl_mvm *mvm)
 {
 	int i;
@@ -128,7 +126,6 @@ static int iwl_send_rss_cfg_cmd(struct i
 	return iwl_mvm_send_cmd_pdu(mvm, RSS_CONFIG_CMD, 0, sizeof(cmd), &cmd);
 }
 
->>>>>>> linux-next/akpm-base
 void iwl_free_fw_paging(struct iwl_mvm *mvm)
 {
 	int i;
diff -puN include/uapi/linux/bpf.h~linux-next-git-rejects include/uapi/linux/bpf.h
--- a/include/uapi/linux/bpf.h~linux-next-git-rejects
+++ a/include/uapi/linux/bpf.h
@@ -324,15 +324,12 @@ enum bpf_func_id {
 /* BPF_FUNC_skb_set_tunnel_key flags. */
 #define BPF_F_ZERO_CSUM_TX		(1ULL << 1)
 
-<<<<<<< HEAD
-=======
 /* BPF_FUNC_get_stackid flags. */
 #define BPF_F_SKIP_FIELD_MASK		0xffULL
 #define BPF_F_USER_STACK		(1ULL << 8)
 #define BPF_F_FAST_STACK_CMP		(1ULL << 9)
 #define BPF_F_REUSE_STACKID		(1ULL << 10)
 
->>>>>>> linux-next/akpm-base
 /* user accessible mirror of in-kernel sk_buff.
  * new fields can only be added to the end of this structure
  */
diff -puN net/tipc/subscr.c~linux-next-git-rejects net/tipc/subscr.c
--- a/net/tipc/subscr.c~linux-next-git-rejects
+++ a/net/tipc/subscr.c
@@ -326,12 +326,7 @@ static void tipc_subscrb_rcv_cb(struct n
 		return tipc_subscrp_cancel(s, subscriber);
 	}
 
-<<<<<<< HEAD
-	if (sub)
-		tipc_nametbl_subscribe(sub);
-=======
 	tipc_subscrp_subscribe(net, s, subscriber, swap);
->>>>>>> linux-next/akpm-base
 }
 
 /* Handle one request to establish a new subscriber */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
mm-slab-clean-up-debug_pagealloc-processing-code-fix.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
slub-drop-lock-at-the-end-of-free_debug_processing-fix.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch
mm-simplify-lock_page_memcg-fix.patch
sched-add-schedule_timeout_idle.patch
mm-oom_reaper-report-success-failure-fix.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix-fix.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix.patch
mm-slub-query-dynamic-debug_pagealloc-setting-fix.patch
sound-query-dynamic-debug_pagealloc-setting-fix.patch
mm-add-a-new-vector-based-madvise-syscall-fix.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch
arch-mn10300-kernel-fpu-nofpuc-needs-asm-elfh.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sscanf-implement-basic-character-sets-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
rapidio-add-mport-char-device-driver-fix.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
kernel-add-kcov-code-coverage-makefile-tweaks.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

