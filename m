From: akpm@linux-foundation.org
Subject: [merged] mm-slab-remove-bad_alien_magic-again.patch removed from
 -mm tree
Date: Fri, 20 May 2016 14:03:18 -0700
Message-ID: <573f7b96.Xr6GdHq/fzM9/2Aa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETVDT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:03:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, geert@linux-m68k.org, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: remove BAD_ALIEN_MAGIC again
has been removed from the -mm tree.  Its filename was
     mm-slab-remove-bad_alien_magic-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: remove BAD_ALIEN_MAGIC again

Initial attemp to remove BAD_ALIEN_MAGIC is once reverted by 'commit
edcad2509550 ("Revert "slab: remove BAD_ALIEN_MAGIC"")' because it causes
a problem on m68k which has many node but !CONFIG_NUMA.  In this case,
although alien cache isn't used at all but to cope with some
initialization path, garbage value is used and that is BAD_ALIEN_MAGIC. 
Now, this patch set use_alien_caches to 0 when !CONFIG_NUMA, there is no
initialization path problem so we don't need BAD_ALIEN_MAGIC at all.  So
remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/slab.c~mm-slab-remove-bad_alien_magic-again mm/slab.c
--- a/mm/slab.c~mm-slab-remove-bad_alien_magic-again
+++ a/mm/slab.c
@@ -421,8 +421,6 @@ static struct kmem_cache kmem_cache_boot
 	.name = "kmem_cache",
 };
 
-#define BAD_ALIEN_MAGIC 0x01020304ul
-
 static DEFINE_PER_CPU(struct delayed_work, slab_reap_work);
 
 static inline struct array_cache *cpu_cache_get(struct kmem_cache *cachep)
@@ -644,7 +642,7 @@ static int transfer_objects(struct array
 static inline struct alien_cache **alloc_alien_cache(int node,
 						int limit, gfp_t gfp)
 {
-	return (struct alien_cache **)BAD_ALIEN_MAGIC;
+	return NULL;
 }
 
 static inline void free_alien_cache(struct alien_cache **ac_ptr)
@@ -1212,7 +1210,7 @@ void __init kmem_cache_init(void)
 					sizeof(struct rcu_head));
 	kmem_cache = &kmem_cache_boot;
 
-	if (num_possible_nodes() == 1)
+	if (!IS_ENABLED(CONFIG_NUMA) || num_possible_nodes() == 1)
 		use_alien_caches = 0;
 
 	for (i = 0; i < NUM_INIT_LISTS; i++)
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


