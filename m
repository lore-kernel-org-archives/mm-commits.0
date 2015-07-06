From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-pass-pfn-to-__free_pages_bootmem.patch
 removed from -mm tree
Date: Mon, 06 Jul 2015 12:46:12 -0700
Message-ID: <559adb04.Pl+5aJONPeghptrH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbbGFTqO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:46:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, daniel@numascale.com, dave.hansen@intel.com, hpa@zytor.com, mingo@elte.hu, nzimmer@sgi.com, penberg@kernel.org, robinmholt@gmail.com, scott.norton@hp.com, tglx@linutronix.de, tony.luck@intel.com, waiman.long@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: pass PFN to __free_pages_bootmem
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-pass-pfn-to-__free_pages_bootmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: page_alloc: pass PFN to __free_pages_bootmem

__free_pages_bootmem prepares a page for release to the buddy allocator
and assumes that the struct page is initialised.  Parallel initialisation
of struct pages defers initialisation and __free_pages_bootmem can be
called for struct pages that cannot yet map struct page to PFN.  This
patch passes PFN to __free_pages_bootmem with no other functional change.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Tested-by: Nate Zimmer <nzimmer@sgi.com>
Tested-by: Waiman Long <waiman.long@hp.com>
Tested-by: Daniel J Blueman <daniel@numascale.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Nate Zimmer <nzimmer@sgi.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Waiman Long <waiman.long@hp.com>
Cc: Scott Norton <scott.norton@hp.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c    |   13 +++++++------
 mm/internal.h   |    3 ++-
 mm/memblock.c   |    2 +-
 mm/nobootmem.c  |    4 ++--
 mm/page_alloc.c |    3 ++-
 5 files changed, 14 insertions(+), 11 deletions(-)

diff -puN mm/bootmem.c~mm-page_alloc-pass-pfn-to-__free_pages_bootmem mm/bootmem.c
--- a/mm/bootmem.c~mm-page_alloc-pass-pfn-to-__free_pages_bootmem
+++ a/mm/bootmem.c
@@ -164,7 +164,7 @@ void __init free_bootmem_late(unsigned l
 	end = PFN_DOWN(physaddr + size);
 
 	for (; cursor < end; cursor++) {
-		__free_pages_bootmem(pfn_to_page(cursor), 0);
+		__free_pages_bootmem(pfn_to_page(cursor), cursor, 0);
 		totalram_pages++;
 	}
 }
@@ -172,7 +172,7 @@ void __init free_bootmem_late(unsigned l
 static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 {
 	struct page *page;
-	unsigned long *map, start, end, pages, count = 0;
+	unsigned long *map, start, end, pages, cur, count = 0;
 
 	if (!bdata->node_bootmem_map)
 		return 0;
@@ -210,17 +210,17 @@ static unsigned long __init free_all_boo
 		if (IS_ALIGNED(start, BITS_PER_LONG) && vec == ~0UL) {
 			int order = ilog2(BITS_PER_LONG);
 
-			__free_pages_bootmem(pfn_to_page(start), order);
+			__free_pages_bootmem(pfn_to_page(start), start, order);
 			count += BITS_PER_LONG;
 			start += BITS_PER_LONG;
 		} else {
-			unsigned long cur = start;
+			cur = start;
 
 			start = ALIGN(start + 1, BITS_PER_LONG);
 			while (vec && cur != start) {
 				if (vec & 1) {
 					page = pfn_to_page(cur);
-					__free_pages_bootmem(page, 0);
+					__free_pages_bootmem(page, cur, 0);
 					count++;
 				}
 				vec >>= 1;
@@ -229,12 +229,13 @@ static unsigned long __init free_all_boo
 		}
 	}
 
+	cur = bdata->node_min_pfn;
 	page = virt_to_page(bdata->node_bootmem_map);
 	pages = bdata->node_low_pfn - bdata->node_min_pfn;
 	pages = bootmem_bootmap_pages(pages);
 	count += pages;
 	while (pages--)
-		__free_pages_bootmem(page++, 0);
+		__free_pages_bootmem(page++, cur++, 0);
 
 	bdebug("nid=%td released=%lx\n", bdata - bootmem_node_data, count);
 
diff -puN mm/internal.h~mm-page_alloc-pass-pfn-to-__free_pages_bootmem mm/internal.h
--- a/mm/internal.h~mm-page_alloc-pass-pfn-to-__free_pages_bootmem
+++ a/mm/internal.h
@@ -155,7 +155,8 @@ __find_buddy_index(unsigned long page_id
 }
 
 extern int __isolate_free_page(struct page *page, unsigned int order);
-extern void __free_pages_bootmem(struct page *page, unsigned int order);
+extern void __free_pages_bootmem(struct page *page, unsigned long pfn,
+					unsigned int order);
 extern void prep_compound_page(struct page *page, unsigned long order);
 #ifdef CONFIG_MEMORY_FAILURE
 extern bool is_free_buddy_page(struct page *page);
diff -puN mm/memblock.c~mm-page_alloc-pass-pfn-to-__free_pages_bootmem mm/memblock.c
--- a/mm/memblock.c~mm-page_alloc-pass-pfn-to-__free_pages_bootmem
+++ a/mm/memblock.c
@@ -1419,7 +1419,7 @@ void __init __memblock_free_late(phys_ad
 	end = PFN_DOWN(base + size);
 
 	for (; cursor < end; cursor++) {
-		__free_pages_bootmem(pfn_to_page(cursor), 0);
+		__free_pages_bootmem(pfn_to_page(cursor), cursor, 0);
 		totalram_pages++;
 	}
 }
diff -puN mm/nobootmem.c~mm-page_alloc-pass-pfn-to-__free_pages_bootmem mm/nobootmem.c
--- a/mm/nobootmem.c~mm-page_alloc-pass-pfn-to-__free_pages_bootmem
+++ a/mm/nobootmem.c
@@ -86,7 +86,7 @@ void __init free_bootmem_late(unsigned l
 	end = PFN_DOWN(addr + size);
 
 	for (; cursor < end; cursor++) {
-		__free_pages_bootmem(pfn_to_page(cursor), 0);
+		__free_pages_bootmem(pfn_to_page(cursor), cursor, 0);
 		totalram_pages++;
 	}
 }
@@ -101,7 +101,7 @@ static void __init __free_pages_memory(u
 		while (start + (1UL << order) > end)
 			order--;
 
-		__free_pages_bootmem(pfn_to_page(start), order);
+		__free_pages_bootmem(pfn_to_page(start), start, order);
 
 		start += (1UL << order);
 	}
diff -puN mm/page_alloc.c~mm-page_alloc-pass-pfn-to-__free_pages_bootmem mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-pass-pfn-to-__free_pages_bootmem
+++ a/mm/page_alloc.c
@@ -878,7 +878,8 @@ static void __free_pages_ok(struct page
 	local_irq_restore(flags);
 }
 
-void __init __free_pages_bootmem(struct page *page, unsigned int order)
+void __init __free_pages_bootmem(struct page *page, unsigned long pfn,
+							unsigned int order)
 {
 	unsigned int nr_pages = 1 << order;
 	struct page *p = page;
_

Patches currently in -mm which might be from mgorman@suse.de are

userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

