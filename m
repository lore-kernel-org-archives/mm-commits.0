From: akpm@linux-foundation.org
Subject: - extend-print_symbol-capability-fix.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:19:50 -0700
Message-ID: <200704270819.l3R8JpqY023183@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755513AbXD0IU1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:20:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, pmarques@grupopie.com, rdunlap@xenotime.net, rpeterso@redhat.com, rusty@rustcorp.com.au, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     sprint_symbol should return length of string like sprintf
has been removed from the -mm tree.  Its filename was
     extend-print_symbol-capability-fix.patch

This patch was dropped because it was folded into extend-print_symbol-capability.patch

------------------------------------------------------
Subject: sprint_symbol should return length of string like sprintf
From: Christoph Lameter <clameter@sgi.com>

Make sprint_symbol return the length of the symbol

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Robert Peterson <rpeterso@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Paulo Marques <pmarques@grupopie.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kallsyms.h |    2 +-
 kernel/kallsyms.c        |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/kallsyms.h~extend-print_symbol-capability-fix include/linux/kallsyms.h
--- a/include/linux/kallsyms.h~extend-print_symbol-capability-fix
+++ a/include/linux/kallsyms.h
@@ -25,7 +25,7 @@ const char *kallsyms_lookup(unsigned lon
 			    char **modname, char *namebuf);
 
 /* Look up a kernel symbol and return it in a text buffer. */
-extern void sprint_symbol(char *buffer, unsigned long address);
+extern int sprint_symbol(char *buffer, unsigned long address);
 
 /* Look up a kernel symbol and print it to the kernel messages. */
 extern void __print_symbol(const char *fmt, unsigned long address);
diff -puN kernel/kallsyms.c~extend-print_symbol-capability-fix kernel/kallsyms.c
--- a/kernel/kallsyms.c~extend-print_symbol-capability-fix
+++ a/kernel/kallsyms.c
@@ -268,7 +268,7 @@ const char *kallsyms_lookup(unsigned lon
 }
 
 /* Look up a kernel symbol and return it in a text buffer. */
-void sprint_symbol(char *buffer, unsigned long address)
+int sprint_symbol(char *buffer, unsigned long address)
 {
 	char *modname;
 	const char *name;
@@ -277,13 +277,13 @@ void sprint_symbol(char *buffer, unsigne
 
 	name = kallsyms_lookup(address, &size, &offset, &modname, namebuf);
 	if (!name)
-		sprintf(buffer, "0x%lx", address);
+		return sprintf(buffer, "0x%lx", address);
 	else {
 		if (modname)
-			sprintf(buffer, "%s+%#lx/%#lx [%s]", name, offset,
+			return sprintf(buffer, "%s+%#lx/%#lx [%s]", name, offset,
 				size, modname);
 		else
-			sprintf(buffer, "%s+%#lx/%#lx", name, offset, size);
+			return sprintf(buffer, "%s+%#lx/%#lx", name, offset, size);
 	}
 }
 
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-introduce-krealloc.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
extend-print_symbol-capability.patch
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
slub-core-update-cpu-after-new_slab.patch
slub-core-fix-sysfs-directory-handling.patch
slub-core-conform-more-to-slabs-slab_hwcache_align-behavior.patch
slub-core-reduce-the-order-of-allocations-to-avoid-fragmentation.patch
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
slub-validation-of-slabs-metadata-and-guard-zones-remove-duplicate-vm_bug_on.patch
slub-add-min_partial.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-user-documentation.patch
slub-user-documentation-fix.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
slub-major-slabinfo-update.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion-fix.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
kmem_cache-simplify-slab-cache-creation.patch
slab-allocators-remove-slab_debug_initial-flag.patch
slab-allocators-remove-slab_debug_initial-flag-locks-fix.patch
slab-allocators-remove-multiple-alignment-specifications.patch
slab-allocators-remove-slab_ctor_atomic.patch
fault-injection-fix-failslab-with-config_numa.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
slub-i386-support.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
readahead-state-based-method-aging-accounting.patch
