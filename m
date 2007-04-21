From: akpm@linux-foundation.org
Subject: + kmem_cache-simplify-slab-cache-creation.patch added to -mm tree
Date: Fri, 20 Apr 2007 20:55:50 -0700
Message-ID: <200704210355.l3L3to7B031020@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754097AbXDUDzz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 23:55:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     KMEM_CACHE(): simplify slab cache creation
has been added to the -mm tree.  Its filename is
     kmem_cache-simplify-slab-cache-creation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2177,13 +2177,11 @@ static void cfq_slab_kill(void)
 
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
@@ -1199,8 +1199,7 @@ static int __init init_bio(void)
 	int megabytes, bvec_pool_entries;
 	int scale = BIOVEC_NR_POOLS;
 
-	bio_slab = kmem_cache_create("bio", sizeof(struct bio), 0,
-				SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL, NULL);
+	bio_slab = KMEM_CACHE(bio, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 
 	biovec_init_slabs();
 
diff -puN fs/dcache.c~kmem_cache-simplify-slab-cache-creation fs/dcache.c
--- a/fs/dcache.c~kmem_cache-simplify-slab-cache-creation
+++ a/fs/dcache.c
@@ -2057,12 +2057,8 @@ static void __init dcache_init(unsigned 
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
 
 	register_shrinker(&dcache_shrinker);
 
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

fix-oom-killing-processes-wrongly-thought-mpol_bind.patch
page-migration-fix-nr_file_pages-accounting.patch
slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
extend-print_symbol-capability-fix.patch
extend-print_symbol-capability-fix-fix.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-fix-numa-bootstrap.patch
slub-use-correct-flags-to-check-for-dma-cache.patch
slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch
slub-core-minor-fixes.patch
slub-core-use-enum-for-tracking-modes-instead-of-integers.patch
slub-core-fix-another-numa-bootstrap-issue.patch
slub-core-fix-object-counting.patch
slub-core-drop-version-number.patch
slub-core-tidy.patch
slub-core-tidy-2.patch
slub-core-tidy-3.patch
slub-core-tidy-4.patch
slub-core-tidy-5.patch
slub-core-tidy-6.patch
slub-core-tidy-7.patch
slub-core-tidy-8.patch
slub-core-tidy-9.patch
slub-core-we-do-not-need-ifdef-config_smp-around-bit-spinlocks.patch
slub-core-printk-facility-level-cleanup.patch
slub-core-kmem_cache_close-is-static-and-should-not-be-exported.patch
slub-core-add-explanation-for-defrag_ratio-=-100.patch
slub-core-add-explanation-for-locking.patch
slub-core-add-explanation-for-locking-fix.patch
slub-core-explain-the-64k-limits.patch
slub-core-explain-sizing-of-slabs-in-detail.patch
slub-core-explain-sizing-of-slabs-in-detail-fix.patch
slub-core-add-checks-for-interrupts-disabled.patch
slub-core-use-__print_symbol-instead-of-kallsyms_lookup.patch
slub-core-missing-inlines-and-statics.patch
slub-fix-cpu-slab-flushing-behavior-so-that-counters-match.patch
slub-extract-finish_bootstrap-function-for-clean-sysfs-boot.patch
slub-core-fix-kmem_cache_destroy.patch
slub-core-fix-validation.patch
slub-core-add-after-object-padding.patch
slub-core-resiliency-fixups.patch
slub-core-resiliency-fixups-fix.patch
slub-core-resiliency-test.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-enable-tracking-of-full-slabs-add-checks-for-interrupts-disabled.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
slub-validation-of-slabs-metadata-and-guard-zones-fix-pageerror-checks-during-validation.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-user-documentation.patch
slub-user-documentation-fix.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
kmem_cache-simplify-slab-cache-creation.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
