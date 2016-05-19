From: akpm@linux-foundation.org
Subject: [folded-merged] mm-slab-freelist-randomization-v5-fix.patch
 removed from -mm tree
Date: Thu, 19 May 2016 16:37:46 -0700
Message-ID: <573e4e4a.dKlvcuSwCqgu+bV2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbcESXhr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:37:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, gthelen@google.com, iamjoonsoo.kim@lge.com, keescook@chromium.org, labbott@fedoraproject.org, penberg@kernel.org, rientjes@google.com, thgarnie@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slab-freelist-randomization-v5-fix
has been removed from the -mm tree.  Its filename was
     mm-slab-freelist-randomization-v5-fix.patch

This patch was dropped because it was folded into mm-slab-freelist-randomization-v4.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-slab-freelist-randomization-v5-fix

propagate gfp_t into cache_random_seq_create()

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@fedoraproject.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Garnier <thgarnie@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/slab.c~mm-slab-freelist-randomization-v5-fix mm/slab.c
--- a/mm/slab.c~mm-slab-freelist-randomization-v5-fix
+++ a/mm/slab.c
@@ -1262,7 +1262,7 @@ static void freelist_randomize(struct rn
 }
 
 /* Create a random sequence per cache */
-static int cache_random_seq_create(struct kmem_cache *cachep)
+static int cache_random_seq_create(struct kmem_cache *cachep, gfp_t gfp)
 {
 	unsigned int seed, count = cachep->num;
 	struct rnd_state state;
@@ -1271,7 +1271,7 @@ static int cache_random_seq_create(struc
 		return 0;
 
 	/* If it fails, we will just use the global lists */
-	cachep->random_seq = kcalloc(count, sizeof(freelist_idx_t), GFP_KERNEL);
+	cachep->random_seq = kcalloc(count, sizeof(freelist_idx_t), gfp);
 	if (!cachep->random_seq)
 		return -ENOMEM;
 
@@ -1290,7 +1290,7 @@ static void cache_random_seq_destroy(str
 	cachep->random_seq = NULL;
 }
 #else
-static inline int cache_random_seq_create(struct kmem_cache *cachep)
+static inline int cache_random_seq_create(struct kmem_cache *cachep, gfp_t gfp)
 {
 	return 0;
 }
@@ -3999,7 +3999,7 @@ static int enable_cpucache(struct kmem_c
 	int shared = 0;
 	int batchcount = 0;
 
-	err = cache_random_seq_create(cachep);
+	err = cache_random_seq_create(cachep, gfp);
 	if (err)
 		goto end;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slab-freelist-randomization-v4.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix.patch
mm-page_alloc-only-check-pagecompound-for-high-order-pages-fix.patch
mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask-fix.patch
mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check-fix.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch

