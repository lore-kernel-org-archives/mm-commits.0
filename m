Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E77DC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  5 Jan 2022 22:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245201AbiAEW4u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Jan 2022 17:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245194AbiAEW4m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2022 17:56:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3A6C06118A
        for <mm-commits@vger.kernel.org>; Wed,  5 Jan 2022 14:56:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1C95B81E3A
        for <mm-commits@vger.kernel.org>; Wed,  5 Jan 2022 22:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E1BC36AE9;
        Wed,  5 Jan 2022 22:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1641423399;
        bh=DRg4H02hF/46tqgKdeep/PeMuEhKPs9uP17BEXn76PQ=;
        h=Date:From:To:Subject:From;
        b=KE0eMd3VJrkFXLCmaSOvhhnwgnWd0wDCM5Xa6irnWU/RFWzwOC/t203LUEd1Qul/L
         qN1g5veJOj64Sw0Z1a77wrOt88anXJ/FzqEmGGOO+TSbs+3HR8zbsKX/zKME3ftVHN
         5Utc6DE3Xm72NdGHBA1hvhN6P9HiBpO2DK8Rr7wQ=
Date:   Wed, 05 Jan 2022 14:56:38 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20220105225638.cjjHjbau7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


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

 drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c |    4 -
 drivers/gpu/drm/nouveau/nouveau_fence.c                 |   35 ----------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c         |    5 -
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c       |    5 -
 drivers/platform/x86/intel/Kconfig                      |    3 
 5 files changed, 52 deletions(-)

--- a/drivers/platform/x86/intel/Kconfig~linux-next-git-rejects
+++ a/drivers/platform/x86/intel/Kconfig
@@ -170,8 +170,6 @@ config INTEL_UNCORE_FREQ_CONTROL
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called intel-uncore-frequency.
-<<<<<<< HEAD
-=======
 
 config INTEL_VSEC
 	tristate "Intel Vendor Specific Extended Capabilities Driver"
@@ -183,4 +181,3 @@ config INTEL_VSEC
 
 	  To compile this driver as a module, choose M here: the module will
 	  be called intel_vsec.
->>>>>>> linux-next/akpm-base
--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
@@ -686,11 +686,7 @@ static const struct dc_debug_options deb
 	.disable_clock_gate = true,
 	.disable_pplib_clock_request = true,
 	.disable_pplib_wm_range = true,
-<<<<<<< HEAD
-	.pipe_split_policy = MPC_SPLIT_DYNAMIC,
-=======
 	.pipe_split_policy = MPC_SPLIT_AVOID,
->>>>>>> linux-next/akpm-base
 	.force_single_disp_pipe_split = false,
 	.disable_dcc = DCC_ENABLE,
 	.vsr_support = true,
--- a/drivers/gpu/drm/nouveau/nouveau_fence.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -355,19 +355,7 @@ nouveau_fence_sync(struct nouveau_bo *nv
 		if (ret)
 			return ret;
 
-<<<<<<< HEAD
-		fobj = NULL;
-	} else {
-		fobj = dma_resv_shared_list(resv);
-	}
-
-	/* Waiting for the exclusive fence first causes performance regressions
-	 * under some circumstances. So manually wait for the shared ones first.
-	 */
-	for (i = 0; i < (fobj ? fobj->shared_count : 0) && !ret; ++i) {
-=======
 	dma_resv_for_each_fence(&cursor, resv, exclusive, fence) {
->>>>>>> linux-next/akpm-base
 		struct nouveau_channel *prev = NULL;
 		bool must_wait = true;
 
@@ -386,32 +374,9 @@ nouveau_fence_sync(struct nouveau_bo *nv
 
 		if (must_wait) {
 			ret = dma_fence_wait(fence, intr);
-<<<<<<< HEAD
-	}
-
-	fence = dma_resv_excl_fence(resv);
-	if (fence) {
-		struct nouveau_channel *prev = NULL;
-		bool must_wait = true;
-
-		f = nouveau_local_fence(fence, chan->drm);
-		if (f) {
-			rcu_read_lock();
-			prev = rcu_dereference(f->channel);
-			if (prev && (prev == chan || fctx->sync(f, prev, chan) == 0))
-				must_wait = false;
-			rcu_read_unlock();
-		}
-
-		if (must_wait)
-			ret = dma_fence_wait(fence, intr);
-
-		return ret;
-=======
 			if (ret)
 				return ret;
 		}
->>>>>>> linux-next/akpm-base
 	}
 	return 0;
 }
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1430,11 +1430,6 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv
 							metadata);
 			if (err)
 				goto err_out;
-<<<<<<< HEAD
-
-			attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-=======
->>>>>>> linux-next/akpm-base
 		}
 	}
 
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -398,13 +398,8 @@ irq_pool_request_vector(struct mlx5_irq_
 	cpumask_copy(irq->mask, affinity);
 	if (!irq_pool_is_sf_pool(pool) && !pool->xa_num_irqs.max &&
 	    cpumask_empty(irq->mask))
-<<<<<<< HEAD
-		cpumask_set_cpu(cpumask_first(cpu_online_mask), irq->mask);
-	irq_set_affinity_hint(irq->irqn, irq->mask);
-=======
 		cpumask_set_cpu(0, irq->mask);
 	irq_set_affinity_and_hint(irq->irqn, irq->mask);
->>>>>>> linux-next/akpm-base
 unlock:
 	mutex_unlock(&pool->lock);
 	return irq;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
memcg-add-per-memcg-vmalloc-stat-v2-fix.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-vmalloc-allocate-small-pages-for-area-pages-fix.patch
mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix2.patch
proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch
kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes.patch
hashh-remove-unused-define-directive-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-rejects.patch
fs-f2fs-datac-fix-mess.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

