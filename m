From: akpm@linux-foundation.org
Subject: + slab-numa-kmem_cache-diet.patch added to -mm tree
Date: Sat, 24 Mar 2007 23:43:19 -0800
Message-ID: <200703250743.l2P7hJx7023049@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35262 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbXCYHol (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 03:44:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, apw@shadowen.org, clameter@engr.sgi.com, penberg@cs.helsinki.fi


The patch titled
     slab: NUMA kmem_cache diet
has been added to the -mm tree.  Its filename is
     slab-numa-kmem_cache-diet.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slab: NUMA kmem_cache diet
From: Eric Dumazet <dada1@cosmosbay.com>

Some NUMA machines have a big MAX_NUMNODES (possibly 1024), but fewer
possible nodes.  This patch dynamically sizes the 'struct kmem_cache' to
allocate only needed space.

I moved nodelists[] field at the end of struct kmem_cache, and use the
following computation in kmem_cache_init()

cache_cache.buffer_size = offsetof(struct kmem_cache, nodelists) +
                                 nr_node_ids * sizeof(struct kmem_list3 *);

On my two nodes x86_64 machine, kmem_cache.obj_size is now 192 instead of 704
(This is because on x86_64, MAX_NUMNODES is 64)

On bigger NUMA setups, this might reduce the gfporder of "cache_cache"

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff -puN mm/slab.c~slab-numa-kmem_cache-diet mm/slab.c
--- a/mm/slab.c~slab-numa-kmem_cache-diet
+++ a/mm/slab.c
@@ -389,7 +389,6 @@ struct kmem_cache {
 	unsigned int buffer_size;
 	u32 reciprocal_buffer_size;
 /* 3) touched by every alloc & free from the backend */
-	struct kmem_list3 *nodelists[MAX_NUMNODES];
 
 	unsigned int flags;		/* constant flags */
 	unsigned int num;		/* # of objs per slab */
@@ -444,6 +443,17 @@ struct kmem_cache {
 	int obj_offset;
 	int obj_size;
 #endif
+	/*
+	 * We put nodelists[] at the end of kmem_cache, because we want to size
+	 * this array to nr_node_ids slots instead of MAX_NUMNODES
+	 * (see kmem_cache_init())
+	 * We still use [MAX_NUMNODES] and not [1] or [0] because cache_cache
+	 * is statically defined, so we reserve the max number of nodes.
+	 */
+	struct kmem_list3 *nodelists[MAX_NUMNODES];
+	/*
+	 * Do not add fields after nodelists[]
+	 */
 };
 
 #define CFLGS_OFF_SLAB		(0x80000000UL)
@@ -678,9 +688,6 @@ static struct kmem_cache cache_cache = {
 	.shared = 1,
 	.buffer_size = sizeof(struct kmem_cache),
 	.name = "kmem_cache",
-#if DEBUG
-	.obj_size = sizeof(struct kmem_cache),
-#endif
 };
 
 #define BAD_ALIEN_MAGIC 0x01020304ul
@@ -1437,6 +1444,15 @@ void __init kmem_cache_init(void)
 	cache_cache.array[smp_processor_id()] = &initarray_cache.cache;
 	cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE];
 
+	/*
+	 * struct kmem_cache size depends on nr_node_ids, which
+	 * can be less than MAX_NUMNODES.
+	 */
+	cache_cache.buffer_size = offsetof(struct kmem_cache, nodelists) +
+				 nr_node_ids * sizeof(struct kmem_list3 *);
+#if DEBUG
+	cache_cache.obj_size = cache_cache.buffer_size;
+#endif
 	cache_cache.buffer_size = ALIGN(cache_cache.buffer_size,
 					cache_line_size());
 	cache_cache.reciprocal_buffer_size =
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

git-net.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
slab-dont-allocate-empty-shared-caches.patch
slab-numa-kmem_cache-diet.patch
optimize-timespec_trunc.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
vfs-delay-the-dentry-name-generation-on-sockets-and.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
speedup-divides-by-cpu_power-in-scheduler.patch
