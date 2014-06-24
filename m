From: akpm@linux-foundation.org
Subject: [merged] slab-fix-oops-when-reading-proc-slab_allocators.patch
 removed from -mm tree
Date: Tue, 24 Jun 2014 12:02:41 -0700
Message-ID: <53a9cb51.3WZgzpAKgxyhIzSG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbaFXTCm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 15:02:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, davej@redhat.com, penberg@kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, stable@vger.kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: fix oops when reading /proc/slab_allocators
has been removed from the -mm tree.  Its filename was
     slab-fix-oops-when-reading-proc-slab_allocators.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: slab: fix oops when reading /proc/slab_allocators

b1cb0982bdd6 ("change the management method of free objects of the slab")
introduced a bug on slab leak detector('/proc/slab_allocators').  This
detector works like as following decription.

1. traverse all objects on all the slabs.
2. determine whether it is active or not.
3. if active, print who allocate this object.

commit 'b1cb098' changes the way how to manage free objects, so logic
determining whether it is active or not is also changed.  In before, we
regard object in cpu caches as inactive one, but, with this commit, we
mistakenly regard object in cpu caches as active one.

This intoduces kernel oops if DEBUG_PAGEALLOC is enabled.  If
DEBUG_PAGEALLOC is enabled, kernel_map_pages() is used to detect who
corrupt free memory in the slab.  It unmaps page table mapping if object
is free and map it if object is active.  When slab leak detector check
object in cpu caches, it mistakenly think this object active so try to
access object memory to retrieve caller of allocation.  At this point,
page table mapping to this object doesn't exist, so oops occurs.

Following is oops message reported from Dave.

It blew up when something tried to read /proc/slab_allocators
(Just cat it, and you should see the oops below)

  Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
  Modules linked in:
  [snip...]
  CPU: 1 PID: 9386 Comm: trinity-c33 Not tainted 3.14.0-rc5+ #131
  task: ffff8801aa46e890 ti: ffff880076924000 task.ti: ffff880076924000
  RIP: 0010:[<ffffffffaa1a8f4a>]  [<ffffffffaa1a8f4a>] handle_slab+0x8a/0x180
  RSP: 0018:ffff880076925de0  EFLAGS: 00010002
  RAX: 0000000000001000 RBX: 0000000000000000 RCX: 000000005ce85ce7
  RDX: ffffea00079be100 RSI: 0000000000001000 RDI: ffff880107458000
  RBP: ffff880076925e18 R08: 0000000000000001 R09: 0000000000000000
  R10: 0000000000000000 R11: 000000000000000f R12: ffff8801e6f84000
  R13: ffffea00079be100 R14: ffff880107458000 R15: ffff88022bb8d2c0
  FS:  00007fb769e45740(0000) GS:ffff88024d040000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffff8801e6f84ff8 CR3: 00000000a22db000 CR4: 00000000001407e0
  DR0: 0000000002695000 DR1: 0000000002695000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000070602
  Stack:
   ffff8802339dcfc0 ffff88022bb8d2c0 ffff880107458000 ffff88022bb8d2c0
   ffff8802339dd008 ffff8802339dcfc0 ffffea00079be100 ffff880076925e68
   ffffffffaa1ad9be ffff880203fe4f00 ffff88022bb8d318 0000000076925e98
  Call Trace:
   [<ffffffffaa1ad9be>] leaks_show+0xce/0x240
   [<ffffffffaa1e6c0e>] seq_read+0x28e/0x490
   [<ffffffffaa23008d>] proc_reg_read+0x3d/0x80
   [<ffffffffaa1c026b>] vfs_read+0x9b/0x160
   [<ffffffffaa1c0d88>] SyS_read+0x58/0xb0
   [<ffffffffaa7420aa>] tracesys+0xd4/0xd9
  Code: f5 00 00 00 0f 1f 44 00 00 48 63 c8 44 3b 0c 8a 0f 84 e3 00 00 00 83 c0 01 44 39 c0 72 eb 41 f6 47 1a 01 0f 84 e9 00 00 00 89 f0 <4d> 8b 4c 04 f8 4d 85 c9 0f 84 88 00 00 00 49 8b 7e 08 4d 8d 46
  RIP  [<ffffffffaa1a8f4a>] handle_slab+0x8a/0x180
   RSP <ffff880076925de0>
  CR2: ffff8801e6f84ff8

To fix the problem, I introduce an object status buffer on each slab. 
With this, we can track object status precisely, so slab leak detector
would not access active object and no kernel oops would occur.  Memory
overhead caused by this fix is only imposed to CONFIG_DEBUG_SLAB_LEAK
which is mainly used for debugging, so memory overhead isn't big problem.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Dave Jones <davej@redhat.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   90 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 71 insertions(+), 19 deletions(-)

diff -puN mm/slab.c~slab-fix-oops-when-reading-proc-slab_allocators mm/slab.c
--- a/mm/slab.c~slab-fix-oops-when-reading-proc-slab_allocators
+++ a/mm/slab.c
@@ -386,6 +386,39 @@ static void **dbg_userword(struct kmem_c
 
 #endif
 
+#define OBJECT_FREE (0)
+#define OBJECT_ACTIVE (1)
+
+#ifdef CONFIG_DEBUG_SLAB_LEAK
+
+static void set_obj_status(struct page *page, int idx, int val)
+{
+	int freelist_size;
+	char *status;
+	struct kmem_cache *cachep = page->slab_cache;
+
+	freelist_size = cachep->num * sizeof(freelist_idx_t);
+	status = (char *)page->freelist + freelist_size;
+	status[idx] = val;
+}
+
+static inline unsigned int get_obj_status(struct page *page, int idx)
+{
+	int freelist_size;
+	char *status;
+	struct kmem_cache *cachep = page->slab_cache;
+
+	freelist_size = cachep->num * sizeof(freelist_idx_t);
+	status = (char *)page->freelist + freelist_size;
+
+	return status[idx];
+}
+
+#else
+static inline void set_obj_status(struct page *page, int idx, int val) {}
+
+#endif
+
 /*
  * Do not go above this order unless 0 objects fit into the slab or
  * overridden on the command line.
@@ -576,12 +609,30 @@ static inline struct array_cache *cpu_ca
 	return cachep->array[smp_processor_id()];
 }
 
+static size_t calculate_freelist_size(int nr_objs, size_t align)
+{
+	size_t freelist_size;
+
+	freelist_size = nr_objs * sizeof(freelist_idx_t);
+	if (IS_ENABLED(CONFIG_DEBUG_SLAB_LEAK))
+		freelist_size += nr_objs * sizeof(char);
+
+	if (align)
+		freelist_size = ALIGN(freelist_size, align);
+
+	return freelist_size;
+}
+
 static int calculate_nr_objs(size_t slab_size, size_t buffer_size,
 				size_t idx_size, size_t align)
 {
 	int nr_objs;
+	size_t remained_size;
 	size_t freelist_size;
+	int extra_space = 0;
 
+	if (IS_ENABLED(CONFIG_DEBUG_SLAB_LEAK))
+		extra_space = sizeof(char);
 	/*
 	 * Ignore padding for the initial guess. The padding
 	 * is at most @align-1 bytes, and @buffer_size is at
@@ -590,14 +641,15 @@ static int calculate_nr_objs(size_t slab
 	 * into the memory allocation when taking the padding
 	 * into account.
 	 */
-	nr_objs = slab_size / (buffer_size + idx_size);
+	nr_objs = slab_size / (buffer_size + idx_size + extra_space);
 
 	/*
 	 * This calculated number will be either the right
 	 * amount, or one greater than what we want.
 	 */
-	freelist_size = slab_size - nr_objs * buffer_size;
-	if (freelist_size < ALIGN(nr_objs * idx_size, align))
+	remained_size = slab_size - nr_objs * buffer_size;
+	freelist_size = calculate_freelist_size(nr_objs, align);
+	if (remained_size < freelist_size)
 		nr_objs--;
 
 	return nr_objs;
@@ -635,7 +687,7 @@ static void cache_estimate(unsigned long
 	} else {
 		nr_objs = calculate_nr_objs(slab_size, buffer_size,
 					sizeof(freelist_idx_t), align);
-		mgmt_size = ALIGN(nr_objs * sizeof(freelist_idx_t), align);
+		mgmt_size = calculate_freelist_size(nr_objs, align);
 	}
 	*num = nr_objs;
 	*left_over = slab_size - nr_objs*buffer_size - mgmt_size;
@@ -2041,13 +2093,16 @@ static size_t calculate_slab_order(struc
 			break;
 
 		if (flags & CFLGS_OFF_SLAB) {
+			size_t freelist_size_per_obj = sizeof(freelist_idx_t);
 			/*
 			 * Max number of objs-per-slab for caches which
 			 * use off-slab slabs. Needed to avoid a possible
 			 * looping condition in cache_grow().
 			 */
+			if (IS_ENABLED(CONFIG_DEBUG_SLAB_LEAK))
+				freelist_size_per_obj += sizeof(char);
 			offslab_limit = size;
-			offslab_limit /= sizeof(freelist_idx_t);
+			offslab_limit /= freelist_size_per_obj;
 
  			if (num > offslab_limit)
 				break;
@@ -2294,8 +2349,7 @@ __kmem_cache_create (struct kmem_cache *
 	if (!cachep->num)
 		return -E2BIG;
 
-	freelist_size =
-		ALIGN(cachep->num * sizeof(freelist_idx_t), cachep->align);
+	freelist_size = calculate_freelist_size(cachep->num, cachep->align);
 
 	/*
 	 * If the slab has been placed off-slab, and we have enough space then
@@ -2308,7 +2362,7 @@ __kmem_cache_create (struct kmem_cache *
 
 	if (flags & CFLGS_OFF_SLAB) {
 		/* really off slab. No need for manual alignment */
-		freelist_size = cachep->num * sizeof(freelist_idx_t);
+		freelist_size = calculate_freelist_size(cachep->num, 0);
 
 #ifdef CONFIG_PAGE_POISONING
 		/* If we're going to use the generic kernel_map_pages()
@@ -2612,6 +2666,7 @@ static void cache_init_objs(struct kmem_
 		if (cachep->ctor)
 			cachep->ctor(objp);
 #endif
+		set_obj_status(page, i, OBJECT_FREE);
 		set_free_obj(page, i, i);
 	}
 }
@@ -2820,6 +2875,7 @@ static void *cache_free_debugcheck(struc
 	BUG_ON(objnr >= cachep->num);
 	BUG_ON(objp != index_to_obj(cachep, page, objnr));
 
+	set_obj_status(page, objnr, OBJECT_FREE);
 	if (cachep->flags & SLAB_POISON) {
 #ifdef CONFIG_DEBUG_PAGEALLOC
 		if ((cachep->size % PAGE_SIZE)==0 && OFF_SLAB(cachep)) {
@@ -2953,6 +3009,8 @@ static inline void cache_alloc_debugchec
 static void *cache_alloc_debugcheck_after(struct kmem_cache *cachep,
 				gfp_t flags, void *objp, unsigned long caller)
 {
+	struct page *page;
+
 	if (!objp)
 		return objp;
 	if (cachep->flags & SLAB_POISON) {
@@ -2983,6 +3041,9 @@ static void *cache_alloc_debugcheck_afte
 		*dbg_redzone1(cachep, objp) = RED_ACTIVE;
 		*dbg_redzone2(cachep, objp) = RED_ACTIVE;
 	}
+
+	page = virt_to_head_page(objp);
+	set_obj_status(page, obj_to_index(cachep, page, objp), OBJECT_ACTIVE);
 	objp += obj_offset(cachep);
 	if (cachep->ctor && cachep->flags & SLAB_POISON)
 		cachep->ctor(objp);
@@ -4219,21 +4280,12 @@ static void handle_slab(unsigned long *n
 						struct page *page)
 {
 	void *p;
-	int i, j;
+	int i;
 
 	if (n[0] == n[1])
 		return;
 	for (i = 0, p = page->s_mem; i < c->num; i++, p += c->size) {
-		bool active = true;
-
-		for (j = page->active; j < c->num; j++) {
-			/* Skip freed item */
-			if (get_free_obj(page, j) == i) {
-				active = false;
-				break;
-			}
-		}
-		if (!active)
+		if (get_obj_status(page, i) != OBJECT_ACTIVE)
 			continue;
 
 		if (!add_caller(n, (unsigned long)*dbg_userword(c, p)))
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slub-use-new-node-functions.patch
slub-use-new-node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-mark-resiliency_test-as-init-text.patch
mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch
vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
dma-cma-separate-core-cma-management-codes-from-dma-apis.patch
dma-cma-support-alignment-constraint-on-cma-region.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
cma-generalize-cma-reserved-area-management-functionality.patch
cma-generalize-cma-reserved-area-management-functionality-fix.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework.patch
mm-cma-clean-up-cma-allocation-error-path.patch
mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch
mm-cma-clean-up-log-message.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
page-owners-correct-page-order-when-to-free-page.patch

