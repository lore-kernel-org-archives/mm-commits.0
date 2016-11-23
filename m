From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 23 Nov 2016 10:26:37 -0800
Message-ID: <5835df5d.VX3rz8/Q1jMbpTht%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53908 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751824AbcKWS0i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Nov 2016 13:26:38 -0500
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

 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c |   18 -----------
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    9 -----
 include/linux/bpf_verifier.h                       |    3 -
 kernel/bpf/verifier.c                              |    4 --
 4 files changed, 34 deletions(-)

diff -puN drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c~linux-next-git-rejects drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -213,19 +213,11 @@ static void dwmac4_rd_enable_tx_timestam
 static int dwmac4_wrback_get_tx_timestamp_status(struct dma_desc *p)
 {
 	/* Context type from W/B descriptor must be zero */
-<<<<<<< HEAD
-	if (p->des3 & TDES3_CONTEXT_TYPE)
-		return -EINVAL;
-
-	/* Tx Timestamp Status is 1 so des0 and des1'll have valid values */
-	if (p->des3 & TDES3_TIMESTAMP_STATUS)
-=======
 	if (le32_to_cpu(p->des3) & TDES3_CONTEXT_TYPE)
 		return -EINVAL;
 
 	/* Tx Timestamp Status is 1 so des0 and des1'll have valid values */
 	if (le32_to_cpu(p->des3) & TDES3_TIMESTAMP_STATUS)
->>>>>>> linux-next/akpm-base
 		return 0;
 
 	return 1;
@@ -249,13 +241,8 @@ static int dwmac4_rx_check_timestamp(voi
 	u32 own, ctxt;
 	int ret = 1;
 
-<<<<<<< HEAD
-	own = p->des3 & RDES3_OWN;
-	ctxt = ((p->des3 & RDES3_CONTEXT_DESCRIPTOR)
-=======
 	own = le32_to_cpu(p->des3) & RDES3_OWN;
 	ctxt = ((le32_to_cpu(p->des3) & RDES3_CONTEXT_DESCRIPTOR)
->>>>>>> linux-next/akpm-base
 		>> RDES3_CONTEXT_DESCRIPTOR_SHIFT);
 
 	if (likely(!own && ctxt)) {
@@ -277,13 +264,8 @@ static int dwmac4_wrback_get_rx_timestam
 	int ret = -EINVAL;
 
 	/* Get the status from normal w/b descriptor */
-<<<<<<< HEAD
-	if (likely(p->des3 & TDES3_RS1V)) {
-		if (likely(p->des1 & RDES1_TIMESTAMP_AVAILABLE)) {
-=======
 	if (likely(le32_to_cpu(p->des3) & TDES3_RS1V)) {
 		if (likely(le32_to_cpu(p->des1) & RDES1_TIMESTAMP_AVAILABLE)) {
->>>>>>> linux-next/akpm-base
 			int i = 0;
 
 			/* Check if timestamp is OK from context descriptor */
diff -puN drivers/net/ethernet/stmicro/stmmac/stmmac_main.c~linux-next-git-rejects drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2493,11 +2493,7 @@ static int stmmac_rx(struct stmmac_priv
 	if (netif_msg_rx_status(priv)) {
 		void *rx_head;
 
-<<<<<<< HEAD
-		pr_info(">>>>>> %s: descriptor ring:\n", __func__);
-=======
 		netdev_info(priv->dev, ">>>>>> %s: descriptor ring:\n", __func__);
->>>>>>> linux-next/akpm-base
 		if (priv->extend_desc)
 			rx_head = (void *)priv->dma_erx;
 		else
@@ -2584,13 +2580,8 @@ static int stmmac_rx(struct stmmac_priv
 				frame_len -= ETH_FCS_LEN;
 
 			if (netif_msg_rx_status(priv)) {
-<<<<<<< HEAD
-				pr_info("\tdesc: %p [entry %d] buff=0x%x\n",
-					p, entry, des);
-=======
 				netdev_info(priv->dev, "\tdesc: %p [entry %d] buff=0x%x\n",
 					    p, entry, des);
->>>>>>> linux-next/akpm-base
 				if (frame_len > ETH_FRAME_LEN)
 					netdev_dbg(priv->dev, "frame size %d, COE: %d\n",
 						   frame_len, status);
diff -puN include/linux/bpf_verifier.h~linux-next-git-rejects include/linux/bpf_verifier.h
--- a/include/linux/bpf_verifier.h~linux-next-git-rejects
+++ a/include/linux/bpf_verifier.h
@@ -24,10 +24,7 @@ struct bpf_reg_state {
 	 */
 	s64 min_value;
 	u64 max_value;
-<<<<<<< HEAD
-=======
 	u32 id;
->>>>>>> linux-next/akpm-base
 	union {
 		/* valid when type == CONST_IMM | PTR_TO_STACK | UNKNOWN_VALUE */
 		s64 imm;
diff -puN kernel/bpf/verifier.c~linux-next-git-rejects kernel/bpf/verifier.c
--- a/kernel/bpf/verifier.c~linux-next-git-rejects
+++ a/kernel/bpf/verifier.c
@@ -1501,10 +1501,6 @@ static void adjust_reg_min_max_vals(stru
 	struct bpf_reg_state *regs = env->cur_state.regs, *dst_reg;
 	s64 min_val = BPF_REGISTER_MIN_RANGE;
 	u64 max_val = BPF_REGISTER_MAX_RANGE;
-<<<<<<< HEAD
-	bool min_set = false, max_set = false;
-=======
->>>>>>> linux-next/akpm-base
 	u8 opcode = BPF_OP(insn->code);
 
 	dst_reg = &regs[insn->dst_reg];
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
mm-disable-numa-migration-faults-for-dax-vmas-fix.patch
filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch
include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch
mm-thp-page-cache-support-for-ppc64-fix.patch
scripts-checkpatchpl-fix-spelling.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

