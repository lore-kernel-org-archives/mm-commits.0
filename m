From: akpm@linux-foundation.org
Subject: + jbd-slab-cleanups-2.patch added to -mm tree
Date: Tue, 18 Sep 2007 19:19:34 -0700
Message-ID: <200709190219.l8J2JYrv002414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40084 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343AbXISCTr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Sep 2007 22:19:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, cmm@us.ibm.com


The patch titled
     JBD slab cleanups 2
has been added to the -mm tree.  Its filename is
     jbd-slab-cleanups-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: JBD slab cleanups 2
From: Christoph Lameter <clameter@sgi.com>

Replace jbd_kmalloc with kmalloc directly.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/checkpoint.c   |    2 +-
 fs/jbd/journal.c      |   12 ++++++------
 fs/jbd/transaction.c  |    6 +++---
 fs/jbd2/checkpoint.c  |    2 +-
 fs/jbd2/journal.c     |   12 ++++++------
 fs/jbd2/transaction.c |    6 +++---
 include/linux/jbd.h   |   15 ---------------
 include/linux/jbd2.h  |   15 ---------------
 8 files changed, 20 insertions(+), 50 deletions(-)

diff -puN fs/jbd/checkpoint.c~jbd-slab-cleanups-2 fs/jbd/checkpoint.c
--- a/fs/jbd/checkpoint.c~jbd-slab-cleanups-2
+++ a/fs/jbd/checkpoint.c
@@ -693,5 +693,5 @@ void __journal_drop_transaction(journal_
 	J_ASSERT(journal->j_running_transaction != transaction);
 
 	jbd_debug(1, "Dropping transaction %d, all done\n", transaction->t_tid);
-	jbd_kfree(transaction);
+	kfree(transaction);
 }
diff -puN fs/jbd/journal.c~jbd-slab-cleanups-2 fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-slab-cleanups-2
+++ a/fs/jbd/journal.c
@@ -653,7 +653,7 @@ static journal_t * journal_init_common (
 	journal_t *journal;
 	int err;
 
-	journal = jbd_kmalloc(sizeof(*journal), GFP_KERNEL);
+	journal = kmalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
 	if (!journal)
 		goto fail;
 	memset(journal, 0, sizeof(*journal));
@@ -678,7 +678,7 @@ static journal_t * journal_init_common (
 	/* Set up a default-sized revoke table for the new mount. */
 	err = journal_init_revoke(journal, JOURNAL_REVOKE_DEFAULT_HASH);
 	if (err) {
-		jbd_kfree(journal);
+		kfree(journal);
 		goto fail;
 	}
 	return journal;
@@ -727,7 +727,7 @@ journal_t * journal_init_dev(struct bloc
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
 			__FUNCTION__);
-		jbd_kfree(journal);
+		kfree(journal);
 		journal = NULL;
 		goto out;
 	}
@@ -781,7 +781,7 @@ journal_t * journal_init_inode (struct i
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
 			__FUNCTION__);
-		jbd_kfree(journal);
+		kfree(journal);
 		return NULL;
 	}
 
@@ -790,7 +790,7 @@ journal_t * journal_init_inode (struct i
 	if (err) {
 		printk(KERN_ERR "%s: Cannnot locate journal superblock\n",
 		       __FUNCTION__);
-		jbd_kfree(journal);
+		kfree(journal);
 		return NULL;
 	}
 
@@ -1158,7 +1158,7 @@ void journal_destroy(journal_t *journal)
 	if (journal->j_revoke)
 		journal_destroy_revoke(journal);
 	kfree(journal->j_wbuf);
-	jbd_kfree(journal);
+	kfree(journal);
 }
 
 
diff -puN fs/jbd/transaction.c~jbd-slab-cleanups-2 fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~jbd-slab-cleanups-2
+++ a/fs/jbd/transaction.c
@@ -96,8 +96,8 @@ static int start_this_handle(journal_t *
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = jbd_kmalloc(sizeof(*new_transaction),
-						GFP_NOFS);
+		new_transaction = kmalloc(sizeof(*new_transaction),
+						GFP_NOFS|__GFP_NOFAIL);
 		if (!new_transaction) {
 			ret = -ENOMEM;
 			goto out;
@@ -229,7 +229,7 @@ repeat_locked:
 	spin_unlock(&journal->j_state_lock);
 out:
 	if (unlikely(new_transaction))		/* It's usually NULL */
-		jbd_kfree(new_transaction);
+		kfree(new_transaction);
 	return ret;
 }
 
diff -puN fs/jbd2/checkpoint.c~jbd-slab-cleanups-2 fs/jbd2/checkpoint.c
--- a/fs/jbd2/checkpoint.c~jbd-slab-cleanups-2
+++ a/fs/jbd2/checkpoint.c
@@ -693,5 +693,5 @@ void __jbd2_journal_drop_transaction(jou
 	J_ASSERT(journal->j_running_transaction != transaction);
 
 	jbd_debug(1, "Dropping transaction %d, all done\n", transaction->t_tid);
-	jbd2_kfree(transaction);
+	kfree(transaction);
 }
diff -puN fs/jbd2/journal.c~jbd-slab-cleanups-2 fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd-slab-cleanups-2
+++ a/fs/jbd2/journal.c
@@ -654,7 +654,7 @@ static journal_t * journal_init_common (
 	journal_t *journal;
 	int err;
 
-	journal = jbd2_kmalloc(sizeof(*journal), GFP_KERNEL);
+	journal = kmalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
 	if (!journal)
 		goto fail;
 	memset(journal, 0, sizeof(*journal));
@@ -679,7 +679,7 @@ static journal_t * journal_init_common (
 	/* Set up a default-sized revoke table for the new mount. */
 	err = jbd2_journal_init_revoke(journal, JOURNAL_REVOKE_DEFAULT_HASH);
 	if (err) {
-		jbd2_kfree(journal);
+		kfree(journal);
 		goto fail;
 	}
 	return journal;
@@ -728,7 +728,7 @@ journal_t * jbd2_journal_init_dev(struct
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
 			__FUNCTION__);
-		jbd2_kfree(journal);
+		kfree(journal);
 		journal = NULL;
 		goto out;
 	}
@@ -782,7 +782,7 @@ journal_t * jbd2_journal_init_inode (str
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
 			__FUNCTION__);
-		jbd2_kfree(journal);
+		kfree(journal);
 		return NULL;
 	}
 
@@ -791,7 +791,7 @@ journal_t * jbd2_journal_init_inode (str
 	if (err) {
 		printk(KERN_ERR "%s: Cannnot locate journal superblock\n",
 		       __FUNCTION__);
-		jbd2_kfree(journal);
+		kfree(journal);
 		return NULL;
 	}
 
@@ -1159,7 +1159,7 @@ void jbd2_journal_destroy(journal_t *jou
 	if (journal->j_revoke)
 		jbd2_journal_destroy_revoke(journal);
 	kfree(journal->j_wbuf);
-	jbd2_kfree(journal);
+	kfree(journal);
 }
 
 
diff -puN fs/jbd2/transaction.c~jbd-slab-cleanups-2 fs/jbd2/transaction.c
--- a/fs/jbd2/transaction.c~jbd-slab-cleanups-2
+++ a/fs/jbd2/transaction.c
@@ -96,8 +96,8 @@ static int start_this_handle(journal_t *
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = jbd2_kmalloc(sizeof(*new_transaction),
-						GFP_NOFS);
+		new_transaction = kmalloc(sizeof(*new_transaction),
+						GFP_NOFS|__GFP_NOFAIL);
 		if (!new_transaction) {
 			ret = -ENOMEM;
 			goto out;
@@ -229,7 +229,7 @@ repeat_locked:
 	spin_unlock(&journal->j_state_lock);
 out:
 	if (unlikely(new_transaction))		/* It's usually NULL */
-		jbd2_kfree(new_transaction);
+		kfree(new_transaction);
 	return ret;
 }
 
diff -puN include/linux/jbd.h~jbd-slab-cleanups-2 include/linux/jbd.h
--- a/include/linux/jbd.h~jbd-slab-cleanups-2
+++ a/include/linux/jbd.h
@@ -71,16 +71,6 @@ extern int journal_enable_debug;
 #define jbd_debug(f, a...)	/**/
 #endif
 
-static inline void *__jbd_kmalloc(const char *where, size_t size,
-						gfp_t flags, int retry)
-{
-	return kmalloc(size, flags | (retry ? __GFP_NOFAIL : 0));
-}
-
-static inline void jbd_kfree(void *ptr)
-{
-	return kfree(ptr);
-}
 
 static inline void *jbd_alloc(size_t size, gfp_t flags)
 {
@@ -92,11 +82,6 @@ static inline void jbd_free(void *ptr, s
 	free_pages((unsigned long)ptr, get_order(size));
 };
 
-#define jbd_kmalloc(size, flags) \
-	__jbd_kmalloc(__FUNCTION__, (size), (flags), journal_oom_retry)
-#define jbd_rep_kmalloc(size, flags) \
-	__jbd_kmalloc(__FUNCTION__, (size), (flags), 1)
-
 #define JFS_MIN_JOURNAL_BLOCKS 1024
 
 #ifdef __KERNEL__
diff -puN include/linux/jbd2.h~jbd-slab-cleanups-2 include/linux/jbd2.h
--- a/include/linux/jbd2.h~jbd-slab-cleanups-2
+++ a/include/linux/jbd2.h
@@ -71,16 +71,6 @@ extern u8 jbd2_journal_enable_debug;
 #define jbd_debug(f, a...)	/**/
 #endif
 
-static inline void *__jbd2_kmalloc(const char *where, size_t size,
-						gfp_t flags, int retry)
-{
-	return kmalloc(size, flags | (retry ? __GFP_NOFAIL : 0));
-}
-static inline void jbd2_kfree(void *ptr)
-{
-	return kfree(ptr);
-}
-
 static inline void *jbd2_alloc(size_t size, gfp_t flags)
 {
 	return (void *)__get_free_pages(flags, get_order(size));
@@ -91,11 +81,6 @@ static inline void jbd2_free(void *ptr, 
 	free_pages((unsigned long)ptr, get_order(size));
 };
 
-#define jbd2_kmalloc(size, flags) \
-	__jbd2_kmalloc(__FUNCTION__, (size), (flags), journal_oom_retry)
-#define jbd_rep_kmalloc(size, flags) \
-	__jbd2_kmalloc(__FUNCTION__, (size), (flags), 1)
-
 #define JBD2_MIN_JOURNAL_BLOCKS 1024
 
 #ifdef __KERNEL__
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
fix-numa-memory-policy-reference-counting.patch
infiniband-work-around-gcc-slub-problem.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86-fix-cpu_to_node-references.patch
x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
x86-acpi-use-cpu_physical_id.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
sparc64-sparsemem_vmemmap-support.patch
sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
slub-direct-pass-through-of-page-size-or-higher-kmalloc.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
slab-allocators-fail-if-ksize-is-called-with-a-null-parameter.patch
mem-policy-add-mpol_f_mems_allowed-get_mempolicy-flag.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
update-n_high_memory-node-state-for-memory-hotadd.patch
memoryless-nodes-fix-interleave-behavior-for-memoryless-nodes.patch
memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-nodes-slab-support.patch
memoryless-nodes-slub-support.patch
memoryless-nodes-uncached-allocator-updates.patch
memoryless-nodes-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
memoryless-nodes-add-n_cpu-node-state.patch
memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-n_high_memory-for-cpusets.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
categorize-gfp-flags.patch
categorize-gfp-flags-fix.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
slub-avoid-page-struct-cacheline-bouncing-due-to-remote-frees-to-cpu-slab.patch
slub-do-not-use-page-mapping.patch
slub-do-not-use-page-mapping-fix.patch
slub-move-page-offset-to-kmem_cache_cpu-offset.patch
slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab.patch
slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way.patch
slub-optimize-cacheline-use-for-zeroing.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap-update.patch
mm-mempolicyc-cleanups.patch
mm-mempolicyc-cleanups-fix.patch
mm-vmstatc-cleanups.patch
add-node-states-sysfs-class-attributes-v5.patch
slub-simplify-irq-off-handling.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix-2.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
jbd-slab-cleanups.patch
jbd-slab-cleanups-2.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
bit_spin_lock-use-lock-bitops.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
