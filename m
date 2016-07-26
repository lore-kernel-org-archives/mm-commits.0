From: akpm@linux-foundation.org
Subject: [patch 020/126] mm: reorganize SLAB freelist randomization
Date: Tue, 26 Jul 2016 15:21:56 -0700
Message-ID: <5797e284.DBsrigXFWVynxsmJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757758AbcGZWV6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:21:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, thgarnie@google.com, cl@linux.com, iamjoonsoo.kim@lge.com, keescook@chromium.org, penberg@kernel.org, rientjes@google.com

From: Thomas Garnier <thgarnie@google.com>
Subject: mm: reorganize SLAB freelist randomization

The kernel heap allocators are using a sequential freelist making their
allocation predictable.  This predictability makes kernel heap overflow
easier to exploit.  An attacker can careful prepare the kernel heap to
control the following chunk overflowed.

For example these attacks exploit the predictability of the heap:
 - Linux Kernel CAN SLUB overflow (https://goo.gl/oMNWkU)
 - Exploiting Linux Kernel Heap corruptions (http://goo.gl/EXLn95)

***Problems that needed solving:
 - Randomize the Freelist (singled linked) used in the SLUB allocator.
 - Ensure good performance to encourage usage.
 - Get best entropy in early boot stage.

***Parts:
 - 01/02 Reorganize the SLAB Freelist randomization to share elements
   with the SLUB implementation.
 - 02/02 The SLUB Freelist randomization implementation. Similar approach
   than the SLAB but tailored to the singled freelist used in SLUB.

***Performance data:

slab_test impact is between 3% to 4% on average for 100000 attempts
without smp.  It is a very focused testing, kernbench show the overall
impact on the system is way lower.

Before:

Single thread testing
=====================
1. Kmalloc: Repeatedly allocate then free test
100000 times kmalloc(8) -> 49 cycles kfree -> 77 cycles
100000 times kmalloc(16) -> 51 cycles kfree -> 79 cycles
100000 times kmalloc(32) -> 53 cycles kfree -> 83 cycles
100000 times kmalloc(64) -> 62 cycles kfree -> 90 cycles
100000 times kmalloc(128) -> 81 cycles kfree -> 97 cycles
100000 times kmalloc(256) -> 98 cycles kfree -> 121 cycles
100000 times kmalloc(512) -> 95 cycles kfree -> 122 cycles
100000 times kmalloc(1024) -> 96 cycles kfree -> 126 cycles
100000 times kmalloc(2048) -> 115 cycles kfree -> 140 cycles
100000 times kmalloc(4096) -> 149 cycles kfree -> 171 cycles
2. Kmalloc: alloc/free test
100000 times kmalloc(8)/kfree -> 70 cycles
100000 times kmalloc(16)/kfree -> 70 cycles
100000 times kmalloc(32)/kfree -> 70 cycles
100000 times kmalloc(64)/kfree -> 70 cycles
100000 times kmalloc(128)/kfree -> 70 cycles
100000 times kmalloc(256)/kfree -> 69 cycles
100000 times kmalloc(512)/kfree -> 70 cycles
100000 times kmalloc(1024)/kfree -> 73 cycles
100000 times kmalloc(2048)/kfree -> 72 cycles
100000 times kmalloc(4096)/kfree -> 71 cycles

After:

Single thread testing
=====================
1. Kmalloc: Repeatedly allocate then free test
100000 times kmalloc(8) -> 57 cycles kfree -> 78 cycles
100000 times kmalloc(16) -> 61 cycles kfree -> 81 cycles
100000 times kmalloc(32) -> 76 cycles kfree -> 93 cycles
100000 times kmalloc(64) -> 83 cycles kfree -> 94 cycles
100000 times kmalloc(128) -> 106 cycles kfree -> 107 cycles
100000 times kmalloc(256) -> 118 cycles kfree -> 117 cycles
100000 times kmalloc(512) -> 114 cycles kfree -> 116 cycles
100000 times kmalloc(1024) -> 115 cycles kfree -> 118 cycles
100000 times kmalloc(2048) -> 147 cycles kfree -> 131 cycles
100000 times kmalloc(4096) -> 214 cycles kfree -> 161 cycles
2. Kmalloc: alloc/free test
100000 times kmalloc(8)/kfree -> 66 cycles
100000 times kmalloc(16)/kfree -> 66 cycles
100000 times kmalloc(32)/kfree -> 66 cycles
100000 times kmalloc(64)/kfree -> 66 cycles
100000 times kmalloc(128)/kfree -> 65 cycles
100000 times kmalloc(256)/kfree -> 67 cycles
100000 times kmalloc(512)/kfree -> 67 cycles
100000 times kmalloc(1024)/kfree -> 64 cycles
100000 times kmalloc(2048)/kfree -> 67 cycles
100000 times kmalloc(4096)/kfree -> 67 cycles

Kernbench, before:

Average Optimal load -j 12 Run (std deviation):
Elapsed Time 101.873 (1.16069)
User Time 1045.22 (1.60447)
System Time 88.969 (0.559195)
Percent CPU 1112.9 (13.8279)
Context Switches 189140 (2282.15)
Sleeps 99008.6 (768.091)

After:

Average Optimal load -j 12 Run (std deviation):
Elapsed Time 102.47 (0.562732)
User Time 1045.3 (1.34263)
System Time 88.311 (0.342554)
Percent CPU 1105.8 (6.49444)
Context Switches 189081 (2355.78)
Sleeps 99231.5 (800.358)


This patch (of 2):

This commit reorganizes the previous SLAB freelist randomization to
prepare for the SLUB implementation.  It moves functions that will be
shared to slab_common.

The entropy functions are changed to align with the SLUB implementation,
now using get_random_(int|long) functions.  These functions were chosen
because they provide a bit more entropy early on boot and better
performance when specific arch instructions are not available.

[akpm@linux-foundation.org: fix build]
Link: http://lkml.kernel.org/r/1464295031-26375-2-git-send-email-thgarnie@google.com
Signed-off-by: Thomas Garnier <thgarnie@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab_def.h |    2 
 mm/slab.c                |   80 +++++++++----------------------------
 mm/slab.h                |   14 ++++++
 mm/slab_common.c         |   47 +++++++++++++++++++++
 4 files changed, 82 insertions(+), 61 deletions(-)

diff -puN include/linux/slab_def.h~mm-reorganize-slab-freelist-randomization include/linux/slab_def.h
--- a/include/linux/slab_def.h~mm-reorganize-slab-freelist-randomization
+++ a/include/linux/slab_def.h
@@ -81,7 +81,7 @@ struct kmem_cache {
 #endif
 
 #ifdef CONFIG_SLAB_FREELIST_RANDOM
-	void *random_seq;
+	unsigned int *random_seq;
 #endif
 
 	struct kmem_cache_node *node[MAX_NUMNODES];
diff -puN mm/slab.c~mm-reorganize-slab-freelist-randomization mm/slab.c
--- a/mm/slab.c~mm-reorganize-slab-freelist-randomization
+++ a/mm/slab.c
@@ -1236,61 +1236,6 @@ static void __init set_up_node(struct km
 	}
 }
 
-#ifdef CONFIG_SLAB_FREELIST_RANDOM
-static void freelist_randomize(struct rnd_state *state, freelist_idx_t *list,
-			size_t count)
-{
-	size_t i;
-	unsigned int rand;
-
-	for (i = 0; i < count; i++)
-		list[i] = i;
-
-	/* Fisher-Yates shuffle */
-	for (i = count - 1; i > 0; i--) {
-		rand = prandom_u32_state(state);
-		rand %= (i + 1);
-		swap(list[i], list[rand]);
-	}
-}
-
-/* Create a random sequence per cache */
-static int cache_random_seq_create(struct kmem_cache *cachep, gfp_t gfp)
-{
-	unsigned int seed, count = cachep->num;
-	struct rnd_state state;
-
-	if (count < 2)
-		return 0;
-
-	/* If it fails, we will just use the global lists */
-	cachep->random_seq = kcalloc(count, sizeof(freelist_idx_t), gfp);
-	if (!cachep->random_seq)
-		return -ENOMEM;
-
-	/* Get best entropy at this stage */
-	get_random_bytes_arch(&seed, sizeof(seed));
-	prandom_seed_state(&state, seed);
-
-	freelist_randomize(&state, cachep->random_seq, count);
-	return 0;
-}
-
-/* Destroy the per-cache random freelist sequence */
-static void cache_random_seq_destroy(struct kmem_cache *cachep)
-{
-	kfree(cachep->random_seq);
-	cachep->random_seq = NULL;
-}
-#else
-static inline int cache_random_seq_create(struct kmem_cache *cachep, gfp_t gfp)
-{
-	return 0;
-}
-static inline void cache_random_seq_destroy(struct kmem_cache *cachep) { }
-#endif /* CONFIG_SLAB_FREELIST_RANDOM */
-
-
 /*
  * Initialisation.  Called after the page allocator have been initialised and
  * before smp_init().
@@ -2535,7 +2480,7 @@ static void cache_init_objs_debug(struct
 union freelist_init_state {
 	struct {
 		unsigned int pos;
-		freelist_idx_t *list;
+		unsigned int *list;
 		unsigned int count;
 		unsigned int rand;
 	};
@@ -2554,7 +2499,7 @@ static bool freelist_state_initialize(un
 	unsigned int rand;
 
 	/* Use best entropy available to define a random shift */
-	get_random_bytes_arch(&rand, sizeof(rand));
+	rand = get_random_int();
 
 	/* Use a random state if the pre-computed list is not available */
 	if (!cachep->random_seq) {
@@ -2576,13 +2521,20 @@ static freelist_idx_t next_random_slot(u
 	return (state->list[state->pos++] + state->rand) % state->count;
 }
 
+/* Swap two freelist entries */
+static void swap_free_obj(struct page *page, unsigned int a, unsigned int b)
+{
+	swap(((freelist_idx_t *)page->freelist)[a],
+		((freelist_idx_t *)page->freelist)[b]);
+}
+
 /*
  * Shuffle the freelist initialization state based on pre-computed lists.
  * return true if the list was successfully shuffled, false otherwise.
  */
 static bool shuffle_freelist(struct kmem_cache *cachep, struct page *page)
 {
-	unsigned int objfreelist = 0, i, count = cachep->num;
+	unsigned int objfreelist = 0, i, rand, count = cachep->num;
 	union freelist_init_state state;
 	bool precomputed;
 
@@ -2607,7 +2559,15 @@ static bool shuffle_freelist(struct kmem
 	 * Later use a pre-computed list for speed.
 	 */
 	if (!precomputed) {
-		freelist_randomize(&state.rnd_state, page->freelist, count);
+		for (i = 0; i < count; i++)
+			set_free_obj(page, i, i);
+
+		/* Fisher-Yates shuffle */
+		for (i = count - 1; i > 0; i--) {
+			rand = prandom_u32_state(&state.rnd_state);
+			rand %= (i + 1);
+			swap_free_obj(page, i, rand);
+		}
 	} else {
 		for (i = 0; i < count; i++)
 			set_free_obj(page, i, next_random_slot(&state));
@@ -3979,7 +3939,7 @@ static int enable_cpucache(struct kmem_c
 	int shared = 0;
 	int batchcount = 0;
 
-	err = cache_random_seq_create(cachep, gfp);
+	err = cache_random_seq_create(cachep, cachep->num, gfp);
 	if (err)
 		goto end;
 
diff -puN mm/slab.h~mm-reorganize-slab-freelist-randomization mm/slab.h
--- a/mm/slab.h~mm-reorganize-slab-freelist-randomization
+++ a/mm/slab.h
@@ -42,6 +42,7 @@ struct kmem_cache {
 #include <linux/kmemcheck.h>
 #include <linux/kasan.h>
 #include <linux/kmemleak.h>
+#include <linux/random.h>
 
 /*
  * State of the slab allocator.
@@ -464,4 +465,17 @@ int memcg_slab_show(struct seq_file *m,
 
 void ___cache_free(struct kmem_cache *cache, void *x, unsigned long addr);
 
+#ifdef CONFIG_SLAB_FREELIST_RANDOM
+int cache_random_seq_create(struct kmem_cache *cachep, unsigned int count,
+			gfp_t gfp);
+void cache_random_seq_destroy(struct kmem_cache *cachep);
+#else
+static inline int cache_random_seq_create(struct kmem_cache *cachep,
+					unsigned int count, gfp_t gfp)
+{
+	return 0;
+}
+static inline void cache_random_seq_destroy(struct kmem_cache *cachep) { }
+#endif /* CONFIG_SLAB_FREELIST_RANDOM */
+
 #endif /* MM_SLAB_H */
diff -puN mm/slab_common.c~mm-reorganize-slab-freelist-randomization mm/slab_common.c
--- a/mm/slab_common.c~mm-reorganize-slab-freelist-randomization
+++ a/mm/slab_common.c
@@ -1030,6 +1030,53 @@ void *kmalloc_order_trace(size_t size, g
 EXPORT_SYMBOL(kmalloc_order_trace);
 #endif
 
+#ifdef CONFIG_SLAB_FREELIST_RANDOM
+/* Randomize a generic freelist */
+static void freelist_randomize(struct rnd_state *state, unsigned int *list,
+			size_t count)
+{
+	size_t i;
+	unsigned int rand;
+
+	for (i = 0; i < count; i++)
+		list[i] = i;
+
+	/* Fisher-Yates shuffle */
+	for (i = count - 1; i > 0; i--) {
+		rand = prandom_u32_state(state);
+		rand %= (i + 1);
+		swap(list[i], list[rand]);
+	}
+}
+
+/* Create a random sequence per cache */
+int cache_random_seq_create(struct kmem_cache *cachep, unsigned int count,
+				    gfp_t gfp)
+{
+	struct rnd_state state;
+
+	if (count < 2 || cachep->random_seq)
+		return 0;
+
+	cachep->random_seq = kcalloc(count, sizeof(unsigned int), gfp);
+	if (!cachep->random_seq)
+		return -ENOMEM;
+
+	/* Get best entropy at this stage of boot */
+	prandom_seed_state(&state, get_random_long());
+
+	freelist_randomize(&state, cachep->random_seq, count);
+	return 0;
+}
+
+/* Destroy the per-cache random freelist sequence */
+void cache_random_seq_destroy(struct kmem_cache *cachep)
+{
+	kfree(cachep->random_seq);
+	cachep->random_seq = NULL;
+}
+#endif /* CONFIG_SLAB_FREELIST_RANDOM */
+
 #ifdef CONFIG_SLABINFO
 
 #ifdef CONFIG_SLAB
_
