From: akpm@linux-foundation.org
Subject: - slub-get-rid-of-finish_bootstrap.patch removed from -mm tree
Date: Wed, 09 May 2007 14:47:57 -0700
Message-ID: <200705092147.l49LlvWF002530@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757124AbXEIVsA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:48:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: get rid of finish_bootstrap
has been removed from the -mm tree.  Its filename was
     slub-get-rid-of-finish_bootstrap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: get rid of finish_bootstrap
From: Christoph Lameter <clameter@sgi.com>

Its only purpose was to bring some sort of symmetry to sysfs usage when
dealing with bootstrapping per cpu flushing.  Since we do not time out slabs
anymore we have no need to run finish_bootstrap even without sysfs.  Fold it
back into slab_sysfs_init and drop the initcall for the !SYFS case.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff -puN mm/slub.c~slub-get-rid-of-finish_bootstrap mm/slub.c
--- a/mm/slub.c~slub-get-rid-of-finish_bootstrap
+++ a/mm/slub.c
@@ -1704,23 +1704,6 @@ static int calculate_sizes(struct kmem_c
 
 }
 
-static int __init finish_bootstrap(void)
-{
-	struct list_head *h;
-	int err;
-
-	slab_state = SYSFS;
-
-	list_for_each(h, &slab_caches) {
-		struct kmem_cache *s =
-			container_of(h, struct kmem_cache, list);
-
-		err = sysfs_slab_add(s);
-		BUG_ON(err);
-	}
-	return 0;
-}
-
 static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 		const char *name, size_t size,
 		size_t align, unsigned long flags,
@@ -3482,6 +3465,7 @@ static int sysfs_slab_alias(struct kmem_
 
 static int __init slab_sysfs_init(void)
 {
+	struct list_head *h;
 	int err;
 
 	err = subsystem_register(&slab_subsys);
@@ -3490,7 +3474,15 @@ static int __init slab_sysfs_init(void)
 		return -ENOSYS;
 	}
 
-	finish_bootstrap();
+	slab_state = SYSFS;
+
+	list_for_each(h, &slab_caches) {
+		struct kmem_cache *s =
+			container_of(h, struct kmem_cache, list);
+
+		err = sysfs_slab_add(s);
+		BUG_ON(err);
+	}
 
 	while (alias_list) {
 		struct saved_alias *al = alias_list;
@@ -3506,6 +3498,4 @@ static int __init slab_sysfs_init(void)
 }
 
 __initcall(slab_sysfs_init);
-#else
-__initcall(finish_bootstrap);
 #endif
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
remove-constructor-from-buffer_head.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
