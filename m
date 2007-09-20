From: akpm@linux-foundation.org
Subject: - git-kgdb-ia64-fix.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:08:01 -0700
Message-ID: <200709202108.l8KL818P002546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58633 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754105AbXITVIi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:08:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, jason.wessel@windriver.com, mm-commits@vger.kernel.org


The patch titled
     git-kgdb ia64 fix
has been removed from the -mm tree.  Its filename was
     git-kgdb-ia64-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-kgdb ia64 fix
From: mel@skynet.ie (Mel Gorman)

IA64 failed to build in kgdb with the messages

arch/ia64/kernel/kgdb.c: In function 'kgdb_arch_set_breakpoint':
arch/ia64/kernel/kgdb.c:555: warning: large integer implicitly truncated to unsigned type
arch/ia64/kernel/kgdb.c: At top level:
arch/ia64/kernel/kgdb.c:673: error: static declaration of 'kgdb_hwbreak_sstep' follows non-static declaration
include/asm/kgdb.h:33: error: previous declaration of 'kgdb_hwbreak_sstep' was here
make[1]: *** [arch/ia64/kernel/kgdb.o] Error 1
make: *** [arch/ia64/kernel] Error 2
make: *** Waiting for unfinished jobs....

It's buried in git-kgdb.patch and I've cc'd who might be the owner. A candidate
fix is below. The build error seems to be a simple case of a badly placed
static. The warning about large integer truncating does not have an obvious
fix and I didn't want to hide the warning with a real bug.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/kgdb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/kernel/kgdb.c~git-kgdb-ia64-fix arch/ia64/kernel/kgdb.c
--- a/arch/ia64/kernel/kgdb.c~git-kgdb-ia64-fix
+++ a/arch/ia64/kernel/kgdb.c
@@ -670,7 +670,7 @@ void kgdb_roundup_cpus(unsigned long fla
 		smp_send_nmi_allbutself();
 }
 
-static volatile int kgdb_hwbreak_sstep[NR_CPUS];
+volatile int kgdb_hwbreak_sstep[NR_CPUS];
 
 static int kgdb_notify(struct notifier_block *self, unsigned long cmd,
 	void *ptr)
_

Patches currently in -mm which might be from mel@csn.ul.ie are

git-net.patch
git-kgdb-ia64-fix.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
sparc64-sparsemem_vmemmap-support.patch
sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap-update.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
