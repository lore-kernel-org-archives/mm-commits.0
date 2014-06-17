From: akpm@linux-foundation.org
Subject: +
 slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch added to
 -mm tree
Date: Tue, 17 Jun 2014 14:44:28 -0700
Message-ID: <53a0b6bc.4wMS15JAhWM4TeEV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965160AbaFQVo3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 17:44:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, mhocko@suse.cz, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, cl@linux.com, vdavydov@parallels.com


The patch titled
     Subject: slub: make dead memcg caches discard free slabs immediately
has been added to the -mm tree.  Its filename is
     slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slub: make dead memcg caches discard free slabs immediately

Since a dead memcg cache is destroyed only after the last slab allocated
to it is freed, we must disable caching of empty slabs for such caches,
otherwise they will be hanging around forever.

This patch makes SLUB discard dead memcg caches' slabs as soon as they
become empty.  To achieve that, it disables per cpu partial lists for dead
caches (see put_cpu_partial) and forbids keeping empty slabs on per node
partial lists by setting cache's min_partial to 0 on kmem_cache_shrink,
which is always called on memcg offline (see memcg_unregister_all_caches).

Thanks to Joonsoo Kim.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/slub.c~slub-make-dead-memcg-caches-discard-free-slabs-immediately mm/slub.c
--- a/mm/slub.c~slub-make-dead-memcg-caches-discard-free-slabs-immediately
+++ a/mm/slub.c
@@ -2059,6 +2059,14 @@ static void put_cpu_partial(struct kmem_
 
 	} while (this_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page)
 								!= oldpage);
+
+	if (memcg_cache_dead(s)) {
+		unsigned long flags;
+
+		local_irq_save(flags);
+		unfreeze_partials(s, this_cpu_ptr(s->cpu_slab));
+		local_irq_restore(flags);
+	}
 #endif
 }
 
@@ -3397,6 +3405,9 @@ int __kmem_cache_shrink(struct kmem_cach
 		kmalloc(sizeof(struct list_head) * objects, GFP_KERNEL);
 	unsigned long flags;
 
+	if (memcg_cache_dead(s))
+		s->min_partial = 0;
+
 	if (!slabs_by_inuse) {
 		/*
 		 * Do not fail shrinking empty slabs if allocation of the
_

Patches currently in -mm which might be from vdavydov@parallels.com are

slab-fix-oops-when-reading-proc-slab_allocators.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
linux-next.patch

