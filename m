From: akpm@linux-foundation.org
Subject: +
 cma-generalize-cma-reserved-area-management-functionality-fix.patch added
 to -mm tree
Date: Fri, 20 Jun 2014 13:41:33 -0700
Message-ID: <53a49c7d.rJzY3lZH9jM4yzZK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757612AbaFTUld (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 16:41:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, iamjoonsoo.kim@lge.com


The patch titled
     Subject: CMA: fix ARM build failure related to MAX_CMA_AREAS definition
has been added to the -mm tree.  Its filename is
     cma-generalize-cma-reserved-area-management-functionality-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cma-generalize-cma-reserved-area-management-functionality-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cma-generalize-cma-reserved-area-management-functionality-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

slab-maintainer-update.patch
slab-fix-oops-when-reading-proc-slab_allocators.patch
slab-fix-oops-when-reading-proc-slab_allocators-v2.patch
dma-cma-fix-possible-memory-leak.patch
mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slub-use-new-node-functions.patch
slub-use-new-node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-mark-resiliency_test-as-init-text.patch
mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch
vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
dma-cma-separate-core-cma-management-codes-from-dma-apis.patch
dma-cma-support-alignment-constraint-on-cma-region.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
cma-generalize-cma-reserved-area-management-functionality.patch
cma-generalize-cma-reserved-area-management-functionality-fix.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework.patch
mm-cma-clean-up-cma-allocation-error-path.patch
mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch
mm-cma-clean-up-log-message.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
page-owners-correct-page-order-when-to-free-page.patch

