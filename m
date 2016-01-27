From: akpm@linux-foundation.org
Subject: +
 slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub.patch added to -mm tree
Date: Tue, 26 Jan 2016 19:29:08 -0800
Message-ID: <56a83984.7LCpHzZKbFn3osDv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbcA0D3J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 22:29:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: use slab_pre_alloc_hook in SLAB allocator shared with SLUB
has been added to the -mm tree.  Its filename is
     slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: slab: use slab_pre_alloc_hook in SLAB allocator shared with SLUB

Deduplicate code in SLAB allocator functions slab_alloc() and
slab_alloc_node() by using the slab_pre_alloc_hook() call, which is now
shared between SLUB and SLAB.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff -puN mm/slab.c~slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub mm/slab.c
--- a/mm/slab.c~slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub
+++ a/mm/slab.c
@@ -3143,15 +3143,10 @@ slab_alloc_node(struct kmem_cache *cache
 	void *ptr;
 	int slab_node = numa_mem_id();
 
-	flags &= gfp_allowed_mask;
-
-	lockdep_trace_alloc(flags);
-
-	if (should_failslab(cachep, flags))
+	cachep = slab_pre_alloc_hook(cachep, flags);
+	if (unlikely(!cachep))
 		return NULL;
 
-	cachep = memcg_kmem_get_cache(cachep, flags);
-
 	cache_alloc_debugcheck_before(cachep, flags);
 	local_irq_save(save_flags);
 
@@ -3231,15 +3226,10 @@ slab_alloc(struct kmem_cache *cachep, gf
 	unsigned long save_flags;
 	void *objp;
 
-	flags &= gfp_allowed_mask;
-
-	lockdep_trace_alloc(flags);
-
-	if (should_failslab(cachep, flags))
+	cachep = slab_pre_alloc_hook(cachep, flags);
+	if (unlikely(!cachep))
 		return NULL;
 
-	cachep = memcg_kmem_get_cache(cachep, flags);
