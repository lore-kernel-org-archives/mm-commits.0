From: akpm@linux-foundation.org
Subject: + mm-slab-mark-enable_cpucache-as-init-text.patch added to -mm
 tree
Date: Wed, 18 Jun 2014 16:39:26 -0700
Message-ID: <53a2232e.oEsXu5Y85tjYb+88%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43177 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaFRXj1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 19:39:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, iamjoonsoo.kim@lge.com, cl@linux.com, rientjes@google.com


The patch titled
     Subject: mm, slab: mark enable_cpucache as init text
has been added to the -mm tree.  Its filename is
     mm-slab-mark-enable_cpucache-as-init-text.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-mark-enable_cpucache-as-init-text.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-mark-enable_cpucache-as-init-text.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, slab: mark enable_cpucache as init text

enable_cpucache() is only called for bootstrap, so it may be moved to init.text
and freed after boot.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~mm-slab-mark-enable_cpucache-as-init-text mm/slab.c
--- a/mm/slab.c~mm-slab-mark-enable_cpucache-as-init-text
+++ a/mm/slab.c
@@ -3911,7 +3911,7 @@ static int do_tune_cpucache(struct kmem_
 }
 
 /* Called with slab_mutex held always */
-static int enable_cpucache(struct kmem_cache *cachep, gfp_t gfp)
+static int __init enable_cpucache(struct kmem_cache *cachep, gfp_t gfp)
 {
 	int err;
 	int limit = 0;
_

Patches currently in -mm which might be from rientjes@google.com are

mm-nommu-per-thread-vma-cache-fix.patch
mm-hotplug-probe-interface-is-available-on-several-platforms.patch
slab-maintainer-update.patch
watchdog-remove-preemption-restrictions-when-restarting-lockup-detector.patch
mm-pcp-allow-restoring-percpu_pagelist_fraction-default.patch
mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep.patch
mm-let-mm_find_pmd-fix-buggy-race-with-thp-fault.patch
slab-fix-oops-when-reading-proc-slab_allocators.patch
mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slub-use-new-node-functions.patch
slub-use-new-node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions-fix.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slab-mark-enable_cpucache-as-init-text.patch
mm-slub-mark-resiliency_test-as-init-text.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-page_alloc-simplify-drain_zone_pages-by-using-min.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
mm-utilc-add-kstrimdup.patch
lib-add-size-unit-t-p-e-to-memparse.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
proc-stat-convert-to-single_open_size.patch
fs-seq_file-fallback-to-vmalloc-allocation.patch
linux-next.patch

