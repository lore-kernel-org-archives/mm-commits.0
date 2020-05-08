From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch removed
 from -mm tree
Date: Thu, 07 May 2020 18:27:43 -0700
Message-ID: <20200508012743.tKIm4TZnq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbgEHB1p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 21:27:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, laoar.shao@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, vdavydov.dev@gmail.com, willy@infradead.org


The patch titled
     Subject: mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch

This patch was dropped because it was folded into mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix

s/EBUSY/ENOSPC/, per Michal

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix
+++ a/mm/memcontrol.c
@@ -2721,8 +2721,6 @@ static int memcg_alloc_cache_id(void)
 
 	id = ida_simple_get(&memcg_cache_ida,
 			    0, MEMCG_CACHES_MAX_SIZE, GFP_KERNEL);
-	if (id == -ENOSPC)
-		return -EBUSY;
 	if (id < 0)
 		return id;
 
@@ -5004,10 +5002,6 @@ static struct mem_cgroup *mem_cgroup_all
 	memcg->id.id = idr_alloc(&mem_cgroup_idr, NULL,
 				 1, MEM_CGROUP_ID_MAX,
 				 GFP_KERNEL);
-	if (memcg->id.id == -ENOSPC) {
-		error = -EBUSY;
-		goto fail;
-	}
 	if (memcg->id.id < 0) {
 		error = memcg->id.id;
 		goto fail;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc.patch
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
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-add-debug_wx-support-fixpatch-added-to-mm-tree.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-makefile-use-config_shell.patch
kernel-forkc-export-kernel_thread-to-modules.patch
