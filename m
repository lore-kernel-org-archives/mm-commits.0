From: akpm@linux-foundation.org
Subject: + slab-fix-oops-when-reading-proc-slab_allocators-v2.patch added
 to -mm tree
Date: Wed, 18 Jun 2014 16:47:46 -0700
Message-ID: <53a22522.RsciTsthixrSIUSr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218AbaFRXrr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 19:47:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov@parallels.com, stable@vger.kernel.org, rientjes@google.com, penguin-kernel@I-love.SAKURA.ne.jp, penberg@kernel.org, davej@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com


The patch titled
     Subject: slab-fix-oops-when-reading-proc-slab_allocators-v2
has been added to the -mm tree.  Its filename is
     slab-fix-oops-when-reading-proc-slab_allocators-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-fix-oops-when-reading-proc-slab_allocators-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-fix-oops-when-reading-proc-slab_allocators-v2.patch

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
Subject: slab-fix-oops-when-reading-proc-slab_allocators-v2

v2: edit one more function, calculate_slab_order(), that wants to know
    how much space per object is spent for freelist management.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Dave Jones <davej@redhat.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/slab.c~slab-fix-oops-when-reading-proc-slab_allocators-v2 mm/slab.c
--- a/mm/slab.c~slab-fix-oops-when-reading-proc-slab_allocators-v2
+++ a/mm/slab.c
@@ -2093,13 +2093,16 @@ static size_t calculate_slab_order(struc
 			break;
 
 		if (flags & CFLGS_OFF_SLAB) {
+			size_t freelist_size_per_obj = sizeof(freelist_idx_t);
 			/*
 			 * Max number of objs-per-slab for caches which
 			 * use off-slab slabs. Needed to avoid a possible
 			 * looping condition in cache_grow().
 			 */
+			if (IS_ENABLED(CONFIG_DEBUG_SLAB_LEAK))
+				freelist_size_per_obj += sizeof(char);
 			offslab_limit = size;
-			offslab_limit /= sizeof(freelist_idx_t);
+			offslab_limit /= freelist_size_per_obj;
 
  			if (num > offslab_limit)
 				break;
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
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slab-mark-enable_cpucache-as-init-text.patch
mm-slub-mark-resiliency_test-as-init-text.patch
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
ppc-kvm-cma-use-general-cma-reserved-area-management-framework.patch
mm-cma-clean-up-cma-allocation-error-path.patch
mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch
mm-cma-clean-up-log-message.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
page-owners-correct-page-order-when-to-free-page.patch

