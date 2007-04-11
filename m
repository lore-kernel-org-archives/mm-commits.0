From: akpm@linux-foundation.org
Subject: + slub-fix-cpu-slab-flushing-behavior-so-that-counters-match.patch added to -mm tree
Date: Wed, 11 Apr 2007 13:52:33 -0700
Message-ID: <200704112052.l3BKqXg9014119@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60502 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030308AbXDKUwi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 16:52:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: fix cpu slab flushing behavior so that counters match
has been added to the -mm tree.  Its filename is
     slub-fix-cpu-slab-flushing-behavior-so-that-counters-match.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: fix cpu slab flushing behavior so that counters match
From: Christoph Lameter <clameter@sgi.com>

Currently we have a check for keventd in slab_alloc() and we only schedule
the event to check for inactive slabs if keventd is up.  This was done in
the belief that later allocations would start up the checking for all
slabs.  However, that is not true for slabs that are only allocated from
during boot.  We will then have per cpus slabs but s->cpu_slabs is zero. 
As a result flush_all() will not flush the cpu_slabs from these slabcaches
and slab validation wil report counter inconsistencies.

Fix that by removing the check for keventd from slab_alloc.  Instead we set
cpu_slabs to 1 during boot so that slab_alloc believes that a check is
already scheduled.  Thus is will not try to schedule via keventd during
early boot.

Later when sysfs is brought up we have to scan through the list of boot
caches anyways.  At that point we simply flush all active slabs which will
set cpu_slabs to zero.  Any new cpu slab after sysfs init will then cause
the inactive cpu slab event to be triggered.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   26 +++++++++++++++++++++++---
 1 files changed, 23 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~slub-fix-cpu-slab-flushing-behavior-so-that-counters-match mm/slub.c
--- a/mm/slub.c~slub-fix-cpu-slab-flushing-behavior-so-that-counters-match
+++ a/mm/slub.c
@@ -65,7 +65,7 @@
  * SLUB assigns one slab for allocation to each processor.
  * Allocations only occur from these slabs called cpu slabs.
  *
- * If a cpu slab exists then a workqueue thread checks every 10
+ * If a cpu slab exists then a workqueue thread checks every 30
  * seconds if the cpu slab is still in use. The cpu slab is pushed back
  * to the list if inactive [only needed for SMP].
  *
@@ -1171,7 +1171,7 @@ have_slab:
 		SetPageActive(page);
 
 #ifdef CONFIG_SMP
-		if (!atomic_read(&s->cpu_slabs) && keventd_up()) {
+		if (!atomic_read(&s->cpu_slabs)) {
 			atomic_inc(&s->cpu_slabs);
 			schedule_delayed_work(&s->flush, 30 * HZ);
 		}
@@ -1683,7 +1683,20 @@ static int kmem_cache_open(struct kmem_c
 
 #ifdef CONFIG_SMP
 	mutex_init(&s->flushing);
-	atomic_set(&s->cpu_slabs, 0);
+	if (slab_state >= SYSFS)
+		atomic_set(&s->cpu_slabs, 0);
+	else
+		/*
+		 * Keventd may not be up yet. Pretend that we have active
+		 * per_cpu slabs so that there will be no attempt to
+		 * schedule a flusher in slab_alloc.
+		 *
+		 * We fix the situation up later when sysfs is brought up
+		 * by flushing all slabs (which puts the slab caches that
+		 * are mostly/only used in a nice quiet state).
+		 */
+		atomic_set(&s->cpu_slabs, 1);
+
 	INIT_DELAYED_WORK(&s->flush, flusher);
 #endif
 	if (init_kmem_cache_nodes(s, gfpflags & ~SLUB_DMA))
@@ -2945,6 +2958,13 @@ int __init slab_sysfs_init(void)
 
 		err = sysfs_slab_add(s);
 		BUG_ON(err);
+		/*
+		 * Start the periodic checks for inactive cpu slabs.
+		 * flush_all() will zero s->cpu_slabs which will cause
+		 * any allocation of a new cpu slab to schedule an event
+		 * via keventd to watch for inactive cpu slabs.
+		 */
+		flush_all(s);
 	}
 
 	while (alias_list) {
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
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
slub-fix-cpu-slab-flushing-behavior-so-that-counters-match.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
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
slub-user-documentation.patch
slub-user-documentation-fix.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
