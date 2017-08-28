From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Mon, 28 Aug 2017 13:14:59 -0700
Message-ID: <20170828201459.nk9RkRGGM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57126 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbdH1UPB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Aug 2017 16:15:01 -0400
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

 drivers/infiniband/core/uverbs_cmd.c |   36 -------------------------
 1 file changed, 36 deletions(-)

diff -puN drivers/infiniband/core/uverbs_cmd.c~linux-next-git-rejects drivers/infiniband/core/uverbs_cmd.c
--- a/drivers/infiniband/core/uverbs_cmd.c~linux-next-git-rejects
+++ a/drivers/infiniband/core/uverbs_cmd.c
@@ -2006,44 +2006,8 @@ static int modify_qp(struct ib_uverbs_fi
 	attr->rate_limit	  = cmd->rate_limit;
 
 	if (cmd->base.attr_mask & IB_QP_AV)
-<<<<<<< HEAD
-		attr->ah_attr.type = rdma_ah_find_type(qp->device,
-						       cmd->base.dest.port_num);
-	if (cmd->base.dest.is_global) {
-		rdma_ah_set_grh(&attr->ah_attr, NULL,
-				cmd->base.dest.flow_label,
-				cmd->base.dest.sgid_index,
-				cmd->base.dest.hop_limit,
-				cmd->base.dest.traffic_class);
-		rdma_ah_set_dgid_raw(&attr->ah_attr, cmd->base.dest.dgid);
-	} else {
-		rdma_ah_set_ah_flags(&attr->ah_attr, 0);
-	}
-	rdma_ah_set_dlid(&attr->ah_attr, cmd->base.dest.dlid);
-	rdma_ah_set_sl(&attr->ah_attr, cmd->base.dest.sl);
-	rdma_ah_set_path_bits(&attr->ah_attr, cmd->base.dest.src_path_bits);
-	rdma_ah_set_static_rate(&attr->ah_attr, cmd->base.dest.static_rate);
-	rdma_ah_set_port_num(&attr->ah_attr,
-			     cmd->base.dest.port_num);
-
-	if (cmd->base.attr_mask & IB_QP_ALT_PATH)
-		attr->alt_ah_attr.type =
-			rdma_ah_find_type(qp->device, cmd->base.dest.port_num);
-	if (cmd->base.alt_dest.is_global) {
-		rdma_ah_set_grh(&attr->alt_ah_attr, NULL,
-				cmd->base.alt_dest.flow_label,
-				cmd->base.alt_dest.sgid_index,
-				cmd->base.alt_dest.hop_limit,
-				cmd->base.alt_dest.traffic_class);
-		rdma_ah_set_dgid_raw(&attr->alt_ah_attr,
-				     cmd->base.alt_dest.dgid);
-	} else {
-		rdma_ah_set_ah_flags(&attr->alt_ah_attr, 0);
-	}
-=======
 		copy_ah_attr_from_uverbs(qp->device, &attr->ah_attr,
 					 &cmd->base.dest);
->>>>>>> linux-next/akpm-base
 
 	if (cmd->base.attr_mask & IB_QP_ALT_PATH)
 		copy_ah_attr_from_uverbs(qp->device, &attr->alt_ah_attr,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
mm-page_owner-make-init_pages_in_zone-faster-fix-checkpatch-fixes.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
mm-swap-add-swap-readahead-hit-statistics-fix.patch
swap-choose-swap-device-according-to-numa-node-v2-fix.patch
mm-change-the-call-sites-of-numa-statistics-items-checkpatch-fixes.patch
add-testcases-for-memset16-32-64-fix.patch
vga-optimise-console-scrolling-fix.patch
lib-add-test-for-bitmap_parselist-fix.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
zram-mm-vs-block.patch
drivers-media-cec-cec-adapc-fix-build-with-gcc-444.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

