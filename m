From: akpm@linux-foundation.org
Subject: + slub-core-update-cpu-after-new_slab.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:05:58 -0700
Message-ID: <200704260005.l3Q05wIR016439@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754512AbXDZAGe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:06:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, clameter@sgi.com


The patch titled
     slub: update cpu after new_slab()
has been added to the -mm tree.  Its filename is
     slub-core-update-cpu-after-new_slab.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slub: update cpu after new_slab()
From: Hugh Dickins <hugh@veritas.com>

SLUB gave me a NULL pointer dereference in slab_alloc(), in the
slab_lock(page) of its "Current cpuslab is acceptable" block: cpu 1 had
been looking at cpu_slab[2], which then went NULL beneath it.  Since
new_slab() may reenable interrupts and sleep (when __GFP_WAIT), we may get
rescheduled on a different cpu: so need to reevaluate it.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~slub-core-update-cpu-after-new_slab mm/slub.c
--- a/mm/slub.c~slub-core-update-cpu-after-new_slab
+++ a/mm/slub.c
@@ -1234,11 +1234,12 @@ have_slab:
 
 	page = new_slab(s, gfpflags, node);
 	if (page) {
+		cpu = smp_processor_id();
 		if (s->cpu_slab[cpu]) {
 			/*
-			 * Someone else populated the cpu_slab while
-			 * we enabled interrupts. The page may not
-			 * be on the requested node.
+			 * Someone else populated the cpu_slab while we enabled
+			 * interrupts, or we have got scheduled on another cpu.
+			 * The page may not be on the requested node.
 			 */
 			if (node == -1 ||
 				page_to_nid(s->cpu_slab[cpu]) == node) {
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-drm.patch
scsi-fix-config_scsi_wait_scan=m.patch
scsi-fix-config_scsi_wait_scan=m-fix.patch
scsi-fix-config_scsi_wait_scan=m-fix-fix.patch
i386-make-compat_vdso-runtime-selectable-fix.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
smaps-use-ptep_test_and_clear_young.patch
slub-core-update-cpu-after-new_slab.patch
mm-madvise-avoid-exclusive-mmap_sem.patch
lazy-freeing-of-memory-through-madv_free.patch
lazy-freeing-of-memory-through-madv_free-fix.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch
ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
