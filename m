From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 17 Nov 2016 17:01:27 -0800
Message-ID: <582e52e7.CyKA6KnNBH4z+3BS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55040 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbcKRBB3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2016 20:01:29 -0500
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

 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |    4 ---
 net/netfilter/ipvs/ip_vs_ctl.c                             |   11 ----------
 net/netlink/genetlink.c                                    |    7 ------
 3 files changed, 22 deletions(-)

diff -puN drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c~linux-next-git-rejects drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -59,11 +59,7 @@ mlx5_eswitch_add_offloaded_rule(struct m
 		return ERR_PTR(-EOPNOTSUPP);
 
 	/* per flow vlan pop/push is emulated, don't set that into the firmware */
-<<<<<<< HEAD
-	action = attr->action & ~(MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH | MLX5_FLOW_CONTEXT_ACTION_VLAN_POP);
-=======
 	flow_act.action = attr->action & ~(MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH | MLX5_FLOW_CONTEXT_ACTION_VLAN_POP);
->>>>>>> linux-next/akpm-base
 
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
 		dest[i].type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
diff -puN net/netfilter/ipvs/ip_vs_ctl.c~linux-next-git-rejects net/netfilter/ipvs/ip_vs_ctl.c
--- a/net/netfilter/ipvs/ip_vs_ctl.c~linux-next-git-rejects
+++ a/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2840,18 +2840,7 @@ static struct nf_sockopt_ops ip_vs_socko
  */
 
 /* IPVS genetlink family */
-<<<<<<< HEAD
-static struct genl_family ip_vs_genl_family = {
-	.id		= GENL_ID_GENERATE,
-	.hdrsize	= 0,
-	.name		= IPVS_GENL_NAME,
-	.version	= IPVS_GENL_VERSION,
-	.maxattr	= IPVS_CMD_ATTR_MAX,
-	.netnsok        = true,         /* Make ipvsadm to work on netns */
-};
-=======
 static struct genl_family ip_vs_genl_family;
->>>>>>> linux-next/akpm-base
 
 /* Policy used for first-level command attributes */
 static const struct nla_policy ip_vs_cmd_policy[IPVS_CMD_ATTR_MAX + 1] = {
diff -puN net/netlink/genetlink.c~linux-next-git-rejects net/netlink/genetlink.c
--- a/net/netlink/genetlink.c~linux-next-git-rejects
+++ a/net/netlink/genetlink.c
@@ -369,11 +369,7 @@ int genl_register_family(struct genl_fam
 
 	err = genl_validate_assign_mc_groups(family);
 	if (err)
-<<<<<<< HEAD
-		goto errout_free;
-=======
 		goto errout_remove;
->>>>>>> linux-next/akpm-base
 
 	genl_unlock_all();
 
@@ -385,11 +381,8 @@ int genl_register_family(struct genl_fam
 
 	return 0;
 
-<<<<<<< HEAD
-=======
 errout_remove:
 	idr_remove(&genl_fam_idr, family->id);
->>>>>>> linux-next/akpm-base
 errout_free:
 	kfree(family->attrbuf);
 errout_locked:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
mm-disable-numa-migration-faults-for-dax-vmas-fix.patch
filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch
scripts-checkpatchpl-fix-spelling.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

