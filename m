From: akpm@linux-foundation.org
Subject: [folded-merged]
 cma-generalize-cma-reserved-area-management-functionality-fix.patch removed from -mm tree
Date: Wed, 06 Aug 2014 15:45:24 -0700
Message-ID: <53e2b004.JGoHCigXG5TbcmrX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:49604 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbaHFWpZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:45:25 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so433426qgd.4
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:45:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: CMA: fix ARM build failure related to MAX_CMA_AREAS definition
has been removed from the -mm tree.  Its filename was
     cma-generalize-cma-reserved-area-management-functionality-fix.patch

This patch was dropped because it was folded into cma-generalize-cma-reserved-area-management-functionality.patch

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: CMA: fix ARM build failure related to MAX_CMA_AREAS definition

If CMA is disabled, CONFIG_CMA_AREAS isn't defined so compile error
happens. To fix it, define MAX_CMA_AREAS if CONFIG_CMA_AREAS
isn't defined.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/cma.h~cma-generalize-cma-reserved-area-management-functionality-fix include/linux/cma.h
--- a/include/linux/cma.h~cma-generalize-cma-reserved-area-management-functionality-fix
+++ a/include/linux/cma.h
@@ -5,8 +5,14 @@
  * There is always at least global CMA area and a few optional
  * areas configured in kernel .config.
  */
+#ifdef CONFIG_CMA_AREAS
 #define MAX_CMA_AREAS	(1 + CONFIG_CMA_AREAS)
 
+#else
+#define MAX_CMA_AREAS	(0)
+
+#endif
+
 struct cma;
 
 extern phys_addr_t cma_get_base(struct cma *cma);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slub-use-new-node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-mark-resiliency_test-as-init-text.patch
mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch
slab-add-unlikely-macro-to-help-compiler.patch
slab-move-up-code-to-get-kmem_cache_node-in-free_block.patch
slab-defer-slab_destroy-in-free_block.patch
slab-factor-out-initialization-of-arracy-cache.patch
slab-introduce-alien_cache.patch
slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache.patch
slab-destroy-a-slab-without-holding-any-alien-cache-lock.patch
slab-remove-a-useless-lockdep-annotation.patch
slab-remove-bad_alien_magic.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
slub-reduce-duplicate-creation-on-the-first-object.patch
mm-move-slab-related-stuff-from-utilc-to-slab_commonc.patch
mm-trivial-comment-cleanup-in-slabc.patch
mm-slub-fix-some-indenting-in-cmpxchg_double_slab.patch
slab-fix-the-alias-countvia-sysfs-of-slab-cache.patch
vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
dma-cma-separate-core-cma-management-codes-from-dma-apis.patch
dma-cma-support-alignment-constraint-on-cma-region.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
cma-generalize-cma-reserved-area-management-functionality.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework-fix.patch
mm-cma-clean-up-cma-allocation-error-path.patch
mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch
mm-cma-clean-up-log-message.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
slub-remove-kmemcg-id-from-create_unique_id.patch
kernel-smpc-on_each_cpu_cond-fix-warning-in-fallback-path.patch

