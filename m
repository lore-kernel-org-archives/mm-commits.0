From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 02 Feb 2017 13:49:01 -0800
Message-ID: <5893a94d.b+DpCdksJmS9AZLM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45770 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751458AbdBBVtC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2017 16:49:02 -0500
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

 drivers/net/ethernet/cadence/macb.c             |   18 --------------
 drivers/net/ethernet/cadence/macb.h             |    3 --
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |    9 -------
 net/sched/cls_matchall.c                        |   15 ++---------
 4 files changed, 3 insertions(+), 42 deletions(-)

diff -puN drivers/net/ethernet/cadence/macb.c~linux-next-git-rejects drivers/net/ethernet/cadence/macb.c
--- a/drivers/net/ethernet/cadence/macb.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/cadence/macb.c
@@ -604,7 +604,6 @@ static void macb_set_addr(struct macb *b
 		desc_64 = macb_64b_desc(bp, desc);
 		desc_64->addrh = upper_32_bits(addr);
 	}
-<<<<<<< HEAD
 #endif
 	desc->addr = lower_32_bits(addr);
 }
@@ -620,23 +619,6 @@ static dma_addr_t macb_get_addr(struct m
 		addr = ((u64)(desc_64->addrh) << 32);
 	}
 #endif
-=======
-#endif
-	desc->addr = lower_32_bits(addr);
-}
-
-static dma_addr_t macb_get_addr(struct macb *bp, struct macb_dma_desc *desc)
-{
-	dma_addr_t addr = 0;
-#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
-	struct macb_dma_desc_64 *desc_64;
-
-	if (bp->hw_dma_cap == HW_DMA_CAP_64B) {
-		desc_64 = macb_64b_desc(bp, desc);
-		addr = ((u64)(desc_64->addrh) << 32);
-	}
-#endif
->>>>>>> linux-next/akpm-base
 	addr |= MACB_BF(RX_WADDR, MACB_BFEXT(RX_WADDR, desc->addr));
 	return addr;
 }
diff -puN drivers/net/ethernet/cadence/macb.h~linux-next-git-rejects drivers/net/ethernet/cadence/macb.h
--- a/drivers/net/ethernet/cadence/macb.h~linux-next-git-rejects
+++ a/drivers/net/ethernet/cadence/macb.h
@@ -955,11 +955,8 @@ struct macb {
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	enum macb_hw_dma_cap hw_dma_cap;
 #endif
-<<<<<<< HEAD
-=======
 
 	struct macb_ptp_info	*ptp_info;	/* macb-ptp interface */
->>>>>>> linux-next/akpm-base
 };
 
 static inline bool macb_is_gem(struct macb *bp)
diff -puN drivers/net/ethernet/mellanox/mlx5/core/en_tc.c~linux-next-git-rejects drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -706,22 +706,13 @@ static int mlx5e_route_lookup_ipv4(struc
 	else
 		*out_dev = rt->dst.dev;
 
-<<<<<<< HEAD
-	ttl = ip4_dst_hoplimit(&rt->dst);
-=======
 	*out_ttl = ip4_dst_hoplimit(&rt->dst);
->>>>>>> linux-next/akpm-base
 	n = dst_neigh_lookup(&rt->dst, &fl4->daddr);
 	ip_rt_put(rt);
 	if (!n)
 		return -ENOMEM;
 
 	*out_n = n;
-<<<<<<< HEAD
-	*saddr = fl4->saddr;
-	*out_ttl = ttl;
-=======
->>>>>>> linux-next/akpm-base
 
 	return 0;
 }
diff -puN net/sched/cls_matchall.c~linux-next-git-rejects net/sched/cls_matchall.c
--- a/net/sched/cls_matchall.c~linux-next-git-rejects
+++ a/net/sched/cls_matchall.c
@@ -171,13 +171,9 @@ static int mall_change(struct net *net,
 	if (!new)
 		return -ENOBUFS;
 
-<<<<<<< HEAD
-	tcf_exts_init(&new->exts, TCA_MATCHALL_ACT, 0);
-=======
-	err = tcf_exts_init(&f->exts, TCA_MATCHALL_ACT, 0);
+	err = tcf_exts_init(&new->exts, TCA_MATCHALL_ACT, 0);
 	if (err)
 		goto err_exts_init;
->>>>>>> linux-next/akpm-base
 
 	if (!handle)
 		handle = 1;
@@ -204,16 +200,11 @@ static int mall_change(struct net *net,
 		call_rcu(&head->rcu, mall_destroy_rcu);
 	return 0;
 
-<<<<<<< HEAD
-errout:
-	kfree(new);
-=======
 err_replace_hw_filter:
 err_set_parms:
-	tcf_exts_destroy(&f->exts);
+	tcf_exts_destroy(&new->exts);
 err_exts_init:
-	kfree(f);
->>>>>>> linux-next/akpm-base
+	kfree(new);
 	return err;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch
mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch
mm-track-active-portions-of-a-section-at-boot-fix.patch
mm-memory_hotplugc-unexport-__remove_pages.patch
z3fold-add-kref-refcounting-checkpatch-fixes.patch
mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk-checkpatch-fixes.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

