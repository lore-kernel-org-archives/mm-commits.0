From: akpm@linux-foundation.org
Subject: + slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch added to -mm tree
Date: Thu, 09 Apr 2015 13:23:09 -0700
Message-ID: <5526dfad.lK8QY7Kd6aRgkZxO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018AbbDIUXK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2015 16:23:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub-bulk-allocation-from-per-cpu-partial-pages-fix
has been added to the -mm tree.  Its filename is
     slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: slub-bulk-allocation-from-per-cpu-partial-pages-fix

fix comments, code layout

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN mm/slub.c~slub-bulk-allocation-from-per-cpu-partial-pages-fix mm/slub.c
--- a/mm/slub.c~slub-bulk-allocation-from-per-cpu-partial-pages-fix
+++ a/mm/slub.c
@@ -2771,17 +2771,16 @@ bool kmem_cache_alloc_bulk(struct kmem_c
 
 			if (unlikely(!object)) {
 				/*
-				 * Check if there remotely freed objects
-				 * availalbe in the page.
+				 * Check if there are remotely freed objects
+				 * available in the page.
 				 */
 				object = get_freelist(s, c->page);
 
 				if (!object) {
 					/*
-					 * All objects in use lets check if
-					 * we have other per cpu partial
-					 * pages that have available
-					 * objects.
+					 * All objects in use.  Let's check if
+					 * we have other per cpu partial pages
+					 * that have available objects.
 					 */
 					c->page = c->partial;
 					if (!c->page) {
@@ -2792,14 +2791,12 @@ bool kmem_cache_alloc_bulk(struct kmem_c
 
 					/* Next per cpu partial page */
 					c->partial = c->page->next;
-					c->freelist = get_freelist(s,
-							c->page);
+					c->freelist = get_freelist(s, c->page);
 					continue;
 				}
 
 			}
 
-
 			*p++ = object;
 			size--;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ocfs2-make-mlog_errno-return-the-errno.patch
mm.patch
mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix.patch
mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix-fix-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
document-interaction-between-compaction-and-the-unevictable-lru-fix.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-mmapc-use-while-instead-of-ifgoto-fix.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
mm-memblock-add-debug-output-for-the-memblock_add-fix.patch
mm-uninline-and-cleanup-page-mapping-related-helpers-checkpatch-fixes.patch
mm-cma-add-functions-to-get-region-pages-counters-fix.patch
mm-cma_debugc-remove-blank-lines-before-define_simple_attribute.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
zsmalloc-support-compaction-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
checkpatch-match-more-world-writable-permissions-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kernel-forkc-avoid-division-by-zero-fix.patch
kernel-forkc-avoid-division-by-zero-fix-fix.patch
doc-sysctl-kerneltxt-document-threads-max-fix.patch
mm-rcu-protected-get_mm_exe_file-fix-2.patch
affs-kstrdup-memory-handling-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-rejects.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

