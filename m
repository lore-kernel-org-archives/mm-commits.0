From: akpm@linux-foundation.org
Subject: +
 mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled.patch added
 to -mm tree
Date: Wed, 07 May 2014 15:08:11 -0700
Message-ID: <536aaecb.QjCsuWKg4/nVF+AB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaEGWIM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 18:08:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, cl@linux-foundation.org, rientjes@google.com

Subject: + mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled.patch added to -mm tree
To: rientjes@google.com,cl@linux-foundation.org,penberg@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 15:08:11 -0700


The patch titled
     Subject: mm, slab: suppress out of memory warning unless debug is enabled
has been added to the -mm tree.  Its filename is
     mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled.patch

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
Subject: mm, slab: suppress out of memory warning unless debug is enabled

When the slab or slub allocators cannot allocate additional slab pages,
they emit diagnostic information to the kernel log such as current number
of slabs, number of objects, active objects, etc.  This is always coupled
with a page allocation failure warning since it is controlled by
!__GFP_NOWARN.

Suppress this out of memory warning if the allocator is configured without
debug supported.  The page allocation failure warning will indicate it is
a failed slab allocation, the order, and the gfp mask, so this is only
useful to diagnose allocator issues.

Since CONFIG_SLUB_DEBUG is already enabled by default for the slub
allocator, there is no functional change with this patch.  If debug is
disabled, however, the warnings are now suppressed.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   10 ++++++++--
 mm/slub.c |   11 ++++++++---
 2 files changed, 16 insertions(+), 5 deletions(-)

diff -puN mm/slab.c~mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled mm/slab.c
--- a/mm/slab.c~mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled
+++ a/mm/slab.c
@@ -1621,10 +1621,16 @@ __initcall(cpucache_init);
 static noinline void
 slab_out_of_memory(struct kmem_cache *cachep, gfp_t gfpflags, int nodeid)
 {
+#if DEBUG
 	struct kmem_cache_node *n;
 	struct page *page;
 	unsigned long flags;
 	int node;
+	static DEFINE_RATELIMIT_STATE(slab_oom_rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
+
+	if ((gfpflags & __GFP_NOWARN) || !__ratelimit(&slab_oom_rs))
+		return;
 
 	printk(KERN_WARNING
 		"SLAB: Unable to allocate memory on node %d (gfp=0x%x)\n",
@@ -1662,6 +1668,7 @@ slab_out_of_memory(struct kmem_cache *ca
 			node, active_slabs, num_slabs, active_objs, num_objs,
 			free_objects);
 	}
+#endif
 }
 
 /*
@@ -1683,8 +1690,7 @@ static struct page *kmem_getpages(struct
 
 	page = alloc_pages_exact_node(nodeid, flags | __GFP_NOTRACK, cachep->gfporder);
 	if (!page) {
-		if (!(flags & __GFP_NOWARN) && printk_ratelimit())
-			slab_out_of_memory(cachep, flags, nodeid);
+		slab_out_of_memory(cachep, flags, nodeid);
 		return NULL;
 	}
 
diff -puN mm/slub.c~mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled mm/slub.c
--- a/mm/slub.c~mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled
+++ a/mm/slub.c
@@ -2150,8 +2150,14 @@ static inline unsigned long node_nr_objs
 static noinline void
 slab_out_of_memory(struct kmem_cache *s, gfp_t gfpflags, int nid)
 {
+#ifdef CONFIG_SLUB_DEBUG
+	static DEFINE_RATELIMIT_STATE(slub_oom_rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
 	int node;
 
+	if ((gfpflags & __GFP_NOWARN) || !__ratelimit(&slub_oom_rs))
+		return;
+
 	pr_warn("SLUB: Unable to allocate memory on node %d (gfp=0x%x)\n",
 		nid, gfpflags);
 	pr_warn("  cache: %s, object size: %d, buffer size: %d, default order: %d, min order: %d\n",
@@ -2178,6 +2184,7 @@ slab_out_of_memory(struct kmem_cache *s,
 		pr_warn("  node %d: slabs: %ld, objs: %ld, free: %ld\n",
 			node, nr_slabs, nr_objs, nr_free);
 	}
+#endif
 }
 
 static inline void *new_slab_objects(struct kmem_cache *s, gfp_t flags,
@@ -2356,9 +2363,7 @@ new_slab:
 	freelist = new_slab_objects(s, gfpflags, node, &c);
 
 	if (unlikely(!freelist)) {
-		if (!(gfpflags & __GFP_NOWARN) && printk_ratelimit())
-			slab_out_of_memory(s, gfpflags, node);
-
+		slab_out_of_memory(s, gfpflags, node);
 		local_irq_restore(flags);
 		return NULL;
 	}
_

Patches currently in -mm which might be from rientjes@google.com are

mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mem-hotplug-implement-get-put_online_mems.patch
slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch
mm-debug-make-bad_range-output-more-usable-and-readable.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

