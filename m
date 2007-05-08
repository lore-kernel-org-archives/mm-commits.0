From: akpm@linux-foundation.org
Subject: - kmem_cache-simplify-slab-cache-creation.patch removed from -mm tree
Date: Mon, 07 May 2007 17:03:27 -0700
Message-ID: <200705080003.l4803RwY008952@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967451AbXEHAJ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:09:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     KMEM_CACHE(): simplify slab cache creation
has been removed from the -mm tree.  Its filename was
     kmem_cache-simplify-slab-cache-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KMEM_CACHE(): simplify slab cache creation
From: Christoph Lameter <clameter@sgi.com>

This patch provides a new macro

KMEM_CACHE(<struct>, <flags>)

to simplify slab creation. KMEM_CACHE creates a slab with the name of the
struct, with the size of the struct and with the alignment of the struct.
Additional slab flags may be specified if necessary.

Example

struct test_slab {
	int a,b,c;
	struct list_head;
} __cacheline_aligned_in_smp;

test_slab_cache = KMEM_CACHE(test_slab, SLAB_PANIC)

will create a new slab named "test_slab" of the size sizeof(struct
test_slab) and aligned to the alignment of test slab.  If it fails then we
panic.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/cfq-iosched.c  |    6 ++----
 fs/aio.c             |    6 ++----
 fs/bio.c             |    3 +--
 fs/dcache.c          |    8 ++------
 include/linux/slab.h |   12 ++++++++++++
 kernel/delayacct.c   |    6 +-----
 kernel/pid.c         |    4 +---
 kernel/signal.c      |    6 +-----
 kernel/taskstats.c   |    4 +---
 9 files changed, 23 insertions(+), 32 deletions(-)

diff -puN block/cfq-iosched.c~kmem_cache-simplify-slab-cache-creation block/cfq-iosched.c
--- a/block/cfq-iosched.c~kmem_cache-simplify-slab-cache-creation
+++ a/block/cfq-iosched.c
@@ -2090,13 +2090,11 @@ static void cfq_slab_kill(void)
 
 static int __init cfq_slab_setup(void)
 {
-	cfq_pool = kmem_cache_create("cfq_pool", sizeof(struct cfq_queue), 0, 0,
-					NULL, NULL);
+	cfq_pool = KMEM_CACHE(cfq_queue, 0);
 	if (!cfq_pool)
 		goto fail;
 
-	cfq_ioc_pool = kmem_cache_create("cfq_ioc_pool",
-			sizeof(struct cfq_io_context), 0, 0, NULL, NULL);
+	cfq_ioc_pool = KMEM_CACHE(cfq_io_context, 0);
 	if (!cfq_ioc_pool)
 		goto fail;
 
diff -puN fs/aio.c~kmem_cache-simplify-slab-cache-creation fs/aio.c
--- a/fs/aio.c~kmem_cache-simplify-slab-cache-creation
+++ a/fs/aio.c
@@ -68,10 +68,8 @@ static void aio_queue_work(struct kioctx
  */
 static int __init aio_setup(void)
 {
-	kiocb_cachep = kmem_cache_create("kiocb", sizeof(struct kiocb),
-				0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL, NULL);
-	kioctx_cachep = kmem_cache_create("kioctx", sizeof(struct kioctx),
-				0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL, NULL);
+	kiocb_cachep = KMEM_CACHE(kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
+	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 
 	aio_wq = create_workqueue("aio");
 
diff -puN fs/bio.c~kmem_cache-simplify-slab-cache-creation fs/bio.c
--- a/fs/bio.c~kmem_cache-simplify-slab-cache-creation
+++ a/fs/bio.c
@@ -1193,8 +1193,7 @@ static void __init biovec_init_slabs(voi
 
 static int __init init_bio(void)
 {
-	bio_slab = kmem_cache_create("bio", sizeof(struct bio), 0,
-				SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL, NULL);
+	bio_slab = KMEM_CACHE(bio, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 
 	biovec_init_slabs();
 
diff -puN fs/dcache.c~kmem_cache-simplify-slab-cache-creation fs/dcache.c
--- a/fs/dcache.c~kmem_cache-simplify-slab-cache-creation
+++ a/fs/dcache.c
@@ -2052,12 +2052,8 @@ static void __init dcache_init(unsigned 
 	 * but it is probably not worth it because of the cache nature
 	 * of the dcache. 
 	 */
-	dentry_cache = kmem_cache_create("dentry_cache",
-					 sizeof(struct dentry),
-					 0,
-					 (SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
-					 SLAB_MEM_SPREAD),
-					 NULL, NULL);
+	dentry_cache = KMEM_CACHE(dentry,
+		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD);
 	
 	set_shrinker(DEFAULT_SEEKS, shrink_dcache_memory);
 
diff -puN include/linux/slab.h~kmem_cache-simplify-slab-cache-creation include/linux/slab.h
--- a/include/linux/slab.h~kmem_cache-simplify-slab-cache-creation
+++ a/include/linux/slab.h
@@ -57,6 +57,18 @@ unsigned int kmem_cache_size(struct kmem
 const char *kmem_cache_name(struct kmem_cache *);
 int kmem_ptr_validate(struct kmem_cache *cachep, const void *ptr);
 
+/*
+ * Please use this macro to create slab caches. Simply specify the
+ * name of the structure and maybe some flags that are listed above.
+ *
+ * The alignment of the struct determines object alignment. If you
+ * f.e. add ____cacheline_aligned_in_smp to the struct declaration
+ * then the objects will be properly aligned in SMP configurations.
+ */
+#define KMEM_CACHE(__struct, __flags) kmem_cache_create(#__struct,\
+		sizeof(struct __struct), __alignof__(struct __struct),\
+		(__flags), NULL, NULL)
+
 #ifdef CONFIG_NUMA
 extern void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
 #else
diff -puN kernel/delayacct.c~kmem_cache-simplify-slab-cache-creation kernel/delayacct.c
--- a/kernel/delayacct.c~kmem_cache-simplify-slab-cache-creation
+++ a/kernel/delayacct.c
@@ -31,11 +31,7 @@ __setup("nodelayacct", delayacct_setup_d
 
 void delayacct_init(void)
 {
-	delayacct_cache = kmem_cache_create("delayacct_cache",
-					sizeof(struct task_delay_info),
-					0,
-					SLAB_PANIC,
-					NULL, NULL);
+	delayacct_cache = KMEM_CACHE(task_delay_info, SLAB_PANIC);
 	delayacct_tsk_init(&init_task);
 }
 
diff -puN kernel/pid.c~kmem_cache-simplify-slab-cache-creation kernel/pid.c
--- a/kernel/pid.c~kmem_cache-simplify-slab-cache-creation
+++ a/kernel/pid.c
@@ -412,7 +412,5 @@ void __init pidmap_init(void)
 	set_bit(0, init_pid_ns.pidmap[0].page);
 	atomic_dec(&init_pid_ns.pidmap[0].nr_free);
 
-	pid_cachep = kmem_cache_create("pid", sizeof(struct pid),
-					__alignof__(struct pid),
-					SLAB_PANIC, NULL, NULL);
+	pid_cachep = KMEM_CACHE(pid, SLAB_PANIC);
 }
diff -puN kernel/signal.c~kmem_cache-simplify-slab-cache-creation kernel/signal.c
--- a/kernel/signal.c~kmem_cache-simplify-slab-cache-creation
+++ a/kernel/signal.c
@@ -2636,9 +2636,5 @@ __attribute__((weak)) const char *arch_v
 
 void __init signals_init(void)
 {
-	sigqueue_cachep =
-		kmem_cache_create("sigqueue",
-				  sizeof(struct sigqueue),
-				  __alignof__(struct sigqueue),
-				  SLAB_PANIC, NULL, NULL);
+	sigqueue_cachep = KMEM_CACHE(sigqueue, SLAB_PANIC);
 }
diff -puN kernel/taskstats.c~kmem_cache-simplify-slab-cache-creation kernel/taskstats.c
--- a/kernel/taskstats.c~kmem_cache-simplify-slab-cache-creation
+++ a/kernel/taskstats.c
@@ -524,9 +524,7 @@ void __init taskstats_init_early(void)
 {
 	unsigned int i;
 
-	taskstats_cache = kmem_cache_create("taskstats_cache",
-						sizeof(struct taskstats),
-						0, SLAB_PANIC, NULL, NULL);
+	taskstats_cache = KMEM_CACHE(taskstats, SLAB_PANIC);
 	for_each_possible_cpu(i) {
 		INIT_LIST_HEAD(&(per_cpu(listener_array, i).list));
 		init_rwsem(&(per_cpu(listener_array, i).sem));
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
readahead-state-based-method-aging-accounting.patch
