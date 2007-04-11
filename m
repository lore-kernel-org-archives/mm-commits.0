From: akpm@linux-foundation.org
Subject: + slub-extract-finish_bootstrap-function-for-clean-sysfs-boot.patch added to -mm tree
Date: Wed, 11 Apr 2007 15:46:35 -0700
Message-ID: <200704112246.l3BMkZPw016595@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35165 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161323AbXDKWql (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 18:46:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: Extract finish_bootstrap function for clean !SYSFS boot
has been added to the -mm tree.  Its filename is
     slub-extract-finish_bootstrap-function-for-clean-sysfs-boot.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: Extract finish_bootstrap function for clean !SYSFS boot
From: Christoph Lameter <clameter@sgi.com>

Extract finish_bootstrap function from slab_sysfs_init.  We can call that
function also if we do not have sysfs defined.  This enables embedded SMP
systems to have the periodic 30 second check for unused per cpu slabs.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   44 +++++++++++++++++++++++++++-----------------
 1 files changed, 27 insertions(+), 17 deletions(-)

diff -puN mm/slub.c~slub-extract-finish_bootstrap-function-for-clean-sysfs-boot mm/slub.c
--- a/mm/slub.c~slub-extract-finish_bootstrap-function-for-clean-sysfs-boot
+++ a/mm/slub.c
@@ -1631,6 +1631,30 @@ static int calculate_sizes(struct kmem_c
 
 }
 
+static int __init finish_bootstrap(void)
+{
+	struct list_head *h;
+	int err;
+
+	slab_state = SYSFS;
+
+	list_for_each(h, &slab_caches) {
+		struct kmem_cache *s =
+			container_of(h, struct kmem_cache, list);
+
+		err = sysfs_slab_add(s);
+		BUG_ON(err);
+		/*
+		 * Start the periodic checks for inactive cpu slabs.
+		 * flush_all() will zero s->cpu_slabs which will cause
+		 * any allocation of a new cpu slab to schedule an event
+		 * via keventd to watch for inactive cpu slabs.
+		 */
+		flush_all(s);
+	}
+	return 0;
+}
+
 static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 		const char *name, size_t size,
 		size_t align, unsigned long flags,
@@ -2942,7 +2966,6 @@ static int sysfs_slab_alias(struct kmem_
 int __init slab_sysfs_init(void)
 {
 	int err;
-	struct list_head *h;
 
 	err = subsystem_register(&slab_subsys);
 	if (err) {
@@ -2950,22 +2973,7 @@ int __init slab_sysfs_init(void)
 		return -ENOSYS;
 	}
 
-	slab_state = SYSFS;
-
-	list_for_each(h, &slab_caches) {
-		struct kmem_cache *s =
-			container_of(h, struct kmem_cache, list);
-
-		err = sysfs_slab_add(s);
-		BUG_ON(err);
-		/*
-		 * Start the periodic checks for inactive cpu slabs.
-		 * flush_all() will zero s->cpu_slabs which will cause
-		 * any allocation of a new cpu slab to schedule an event
-		 * via keventd to watch for inactive cpu slabs.
-		 */
-		flush_all(s);
-	}
+	finish_bootstrap();
 
 	while (alias_list) {
 		struct saved_alias *al = alias_list;
@@ -2980,4 +2988,6 @@ int __init slab_sysfs_init(void)
 }
 
 __initcall(slab_sysfs_init);
+#else
+__initcall(finish_bootstrap);
 #endif
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
slub-core-missing-inlines-and-statics.patch
slub-fix-cpu-slab-flushing-behavior-so-that-counters-match.patch
slub-extract-finish_bootstrap-function-for-clean-sysfs-boot.patch
slub-move-slab_state-into-sysfs-if-config_sysfs=n.patch
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
