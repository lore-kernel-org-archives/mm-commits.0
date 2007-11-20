From: akpm@linux-foundation.org
Subject: + do-not-use-stack-to-allocate-cpumask-for-cpumask_of_cpu.patch added to -mm tree
Date: Mon, 19 Nov 2007 23:57:17 -0800
Message-ID: <200711200757.lAK7vHNR025029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60626 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757427AbXKTH6A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 02:58:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, mingo@elte.hu


The patch titled
     Do not use stack to allocate cpumask for cpumask_of_cpu()
has been added to the -mm tree.  Its filename is
     do-not-use-stack-to-allocate-cpumask-for-cpumask_of_cpu.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Do not use stack to allocate cpumask for cpumask_of_cpu()
From: Christoph Lameter <clameter@sgi.com>

Here is a simple patch to use a per cpu cpumask instead of constructing
one on the stack.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |   12 +-----------
 include/linux/percpu.h  |    2 ++
 kernel/sched.c          |    6 ++++++
 3 files changed, 9 insertions(+), 11 deletions(-)

diff -puN include/linux/cpumask.h~do-not-use-stack-to-allocate-cpumask-for-cpumask_of_cpu include/linux/cpumask.h
--- a/include/linux/cpumask.h~do-not-use-stack-to-allocate-cpumask-for-cpumask_of_cpu
+++ a/include/linux/cpumask.h
@@ -222,17 +222,7 @@ int __next_cpu(int n, const cpumask_t *s
 #define next_cpu(n, src)	1
 #endif
 
-#define cpumask_of_cpu(cpu)						\
-({									\
-	typeof(_unused_cpumask_arg_) m;					\
-	if (sizeof(m) == sizeof(unsigned long)) {			\
-		m.bits[0] = 1UL<<(cpu);					\
-	} else {							\
-		cpus_clear(m);						\
-		cpu_set((cpu), m);					\
-	}								\
-	m;								\
-})
+#define cpumask_of_cpu(cpu)	per_cpu(cpu_mask, cpu)
 
 #define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(NR_CPUS)
 
diff -puN include/linux/percpu.h~do-not-use-stack-to-allocate-cpumask-for-cpumask_of_cpu include/linux/percpu.h
--- a/include/linux/percpu.h~do-not-use-stack-to-allocate-cpumask-for-cpumask_of_cpu
+++ a/include/linux/percpu.h
@@ -21,6 +21,8 @@
 	(__per_cpu_end - __per_cpu_start + PERCPU_MODULE_RESERVE)
 #endif	/* PERCPU_ENOUGH_ROOM */
 
+DECLARE_PER_CPU(cpumask_t, cpu_mask);
+
 /*
  * Must be an lvalue. Since @var must be a simple identifier,
  * we force a syntax error here if it isn't.
diff -puN kernel/sched.c~do-not-use-stack-to-allocate-cpumask-for-cpumask_of_cpu kernel/sched.c
--- a/kernel/sched.c~do-not-use-stack-to-allocate-cpumask-for-cpumask_of_cpu
+++ a/kernel/sched.c
@@ -6725,6 +6725,9 @@ static void init_cfs_rq(struct cfs_rq *c
 	cfs_rq->min_vruntime = (u64)(-(1LL << 20));
 }
 
+DEFINE_PER_CPU(cpumask_t, cpu_mask);
+EXPORT_PER_CPU_SYMBOL(cpu_mask);
+
 void __init sched_init(void)
 {
 	int highest_cpu = 0;
@@ -6734,6 +6737,9 @@ void __init sched_init(void)
 		struct rt_prio_array *array;
 		struct rq *rq;
 
+		/* This makes cpumask_of_cpu work */
+		cpu_set(i, per_cpu(cpu_mask, i));
+
 		rq = cpu_rq(i);
 		spin_lock_init(&rq->lock);
 		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
_

Patches currently in -mm which might be from clameter@sgi.com are

ia64-slim-down-__clear_bit_unlock.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
git-s390.patch
do-not-use-stack-to-allocate-cpumask-for-cpumask_of_cpu.patch
git-unionfs.patch
git-x86.patch
x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
vunmap-return-page-array-passed-on-vmap.patch
slub-move-count_partial.patch
slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
slub-use-non-atomic-bit-unlock.patch
slub-fix-coding-style-violations.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial-slub-workaround-for-lockdep-confusion.patch
slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
slub-__slab_alloc-exit-path-consolidation.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-fix.patch
slub-restructure-slab-alloc.patch
slub-comment-kmem_cache_cpu-structure.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
bufferhead-revert-constructor-removal.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
swapin_readahead-excise-numa-bogosity.patch
page-allocator-clean-up-pcp-draining-functions.patch
vmstat-small-revisions-to-refresh_cpu_vm_stats.patch
page-allocator-get-rid-of-the-list-of-cold-pages.patch
page-allocator-get-rid-of-the-list-of-cold-pages-fix.patch
mm-sparsec-check-the-return-value-of-sparse_index_alloc.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
