From: akpm@linux-foundation.org
Subject: [merged] slab-add-unlikely-macro-to-help-compiler.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:03:03 -0700
Message-ID: <53e3db77.vBMZKUF9ggSntLpB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:40737 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbaHGUDE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:03:04 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so844840obb.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:03:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: add unlikely macro to help compiler
has been removed from the -mm tree.  Its filename was
     slab-add-unlikely-macro-to-help-compiler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: slab: add unlikely macro to help compiler

This patchset does some cleanup and tries to remove lockdep annotation.

Patches 1~2 are just for really really minor improvement.
Patches 3~9 are for clean-up and removing lockdep annotation.

There are two cases that lockdep annotation is needed in SLAB.
1) holding two node locks
2) holding two array cache(alien cache) locks

I looked at the code and found that we can avoid these cases without any
negative effect.

1) occurs if freeing object makes new free slab and we decide to
   destroy it.  Although we don't need to hold the lock during destroying
   a slab, current code do that.  Destroying a slab without holding the
   lock would help the reduction of the lock contention.  To do it, I
   change the implementation that new free slab is destroyed after
   releasing the lock.

2) occurs on similar situation.  When we free object from non-local
   node, we put this object to alien cache with holding the alien cache
   lock.  If alien cache is full, we try to flush alien cache to proper
   node cache, and, in this time, new free slab could be made.  Destroying
   it would be started and we will free metadata object which comes from
   another node.  In this case, we need another node's alien cache lock to
   free object.  This forces us to hold two array cache locks and then we
   need lockdep annotation although they are always different locks and
   deadlock cannot be possible.  To prevent this situation, I use same way
   as 1).

In this way, we can avoid 1) and 2) cases, and then, can remove lockdep
annotation. As short stat noted, this makes SLAB code much simpler.



This patch (of 9):

slab_should_failslab() is called on every allocation, so to optimize it is
reasonable.  We normally don't allocate from kmem_cache.  It is just used
when new kmem_cache is created, so it's very rare case.  Therefore, add
unlikely macro to help compiler optimization.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~slab-add-unlikely-macro-to-help-compiler mm/slab.c
--- a/mm/slab.c~slab-add-unlikely-macro-to-help-compiler
+++ a/mm/slab.c
@@ -3048,7 +3048,7 @@ static void *cache_alloc_debugcheck_afte
 
 static bool slab_should_failslab(struct kmem_cache *cachep, gfp_t flags)
 {
-	if (cachep == kmem_cache)
+	if (unlikely(cachep == kmem_cache))
 		return false;
 
 	return should_failslab(cachep->object_size, flags, cachep->flags);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
page-owners-correct-page-order-when-to-free-page.patch

